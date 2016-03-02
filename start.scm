#!/usr/bin/csi -s
(use vector-lib)
(use dbus)
(require-extension srfi-69)
(require-extension posix)
;; Config
(define interface "wwp0s20u10")

(define simple-context
  (make-context
    bus: system-bus
    service: 'org.freedesktop.ModemManager1
    interface: 'org.freedesktop.ModemManager1.Modem.Simple
    path: '/org/freedesktop/ModemManager1/Modem/0 ))

(let ([bearer
        (object-path->string 
          (car 
            (call simple-context "Connect"
                  (vector (cons "apn" (make-variant"Internet")) ) )) ) ])

  (printf "Bearer: ~s~%" bearer)
  (define bearer-context
    (make-context
      bus: system-bus
      service: 'org.freedesktop.ModemManager1
      interface: 'org.freedesktop.DBus.Properties
      path: bearer ))

  (let ([res
          (call bearer-context "Get"
                "org.freedesktop.ModemManager1.Bearer" "Ip4Config") ])
    (if (and (list? res) (variant? (car res)) (vector? (variant-data (car res))))
      (let ([data (variant-data (car res))])
        (define (data-get name)
          (let ([index (vector-index (lambda (x) (string=? name (car x))) data)])
            (and index (variant-data (cdr (vector-ref data index)))) ) )
        (printf "Address: ~s/~s~%" (data-get "address") (data-get "prefix"))
        (printf "Gateway ~s~%" (data-get "gateway"))
        (printf "DNS ~s, ~s~%" (data-get "dns1") (data-get "dns2"))
        (define (start name args)
          (process-wait (process-run name args)) )
        (start "ip" (list "route" "flush" "dev" interface))
        (start "ip" (list "address" "flush" "dev" interface))
        (start "ip" (list "link" "set" "dev" interface "up"))
        (start "ip" (list "address" "add" "dev" interface
                          (string-append
                            (data-get "address") "/"
                            (number->string (data-get "prefix")) ) ))
        (start "ip" (list "route" "add" "dev" interface
                          "via" (data-get "gateway") "default" ))
        )
      (printf "Error ~s~%" res) )) )

;; vim: set expandtab ts=2 sw=2:
