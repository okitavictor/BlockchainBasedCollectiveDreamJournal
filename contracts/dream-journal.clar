;; Collective Dream Journal

;; Define data vars
(define-data-var next-dream-id uint u0)

;; Define data maps
(define-map dreams
  { dream-id: uint }
  { dreamer: principal, content: (string-utf8 1000), timestamp: uint, themes: (list 5 (string-ascii 20)) })

(define-map user-dreams principal (list 100 uint))

(define-map theme-dreams
  { theme: (string-ascii 20) }
  { dream-ids: (list 1000 uint) })

;; Define constants
(define-constant ERR-NOT-FOUND (err u100))
(define-constant ERR-ALREADY-EXISTS (err u101))
(define-constant ERR-UNAUTHORIZED (err u102))

;; Submit a dream
(define-public (submit-dream (content (string-utf8 1000)) (themes (list 5 (string-ascii 20))))
  (let
    (
      (dream-id (var-get next-dream-id))
      (dreamer tx-sender)
    )
    (map-set dreams
      { dream-id: dream-id }
      { dreamer: dreamer, content: content, timestamp: block-height, themes: themes }
    )
    (var-set next-dream-id (+ dream-id u1))
    (map-set user-dreams
      dreamer
      (unwrap! (as-max-len? (append (default-to (list) (map-get? user-dreams dreamer)) dream-id) u100) ERR-ALREADY-EXISTS)
    )
    (map theme-dreams (lambda (theme)
      (map-set theme-dreams
        { theme: theme }
        { dream-ids: (unwrap! (as-max-len? (append (get dream-ids (default-to { dream-ids: (list) } (map-get? theme-dreams { theme: theme }))) dream-id) u1000) ERR-ALREADY-EXISTS) }
      )
    ) themes)
    (ok dream-id)
  )
)

;; Get a dream by ID
(define-read-only (get-dream (dream-id uint))
  (ok (unwrap! (map-get? dreams { dream-id: dream-id }) ERR-NOT-FOUND))
)

;; Get dreams by theme
(define-read-only (get-dreams-by-theme (theme (string-ascii 20)))
  (ok (get dream-ids (default-to { dream-ids: (list) } (map-get? theme-dreams { theme: theme }))))
)

;; Get user's dreams
(define-read-only (get-user-dreams (user principal))
  (ok (default-to (list) (map-get? user-dreams user)))
)

;; Get common themes (simplified)
(define-read-only (get-common-themes)
  (ok (map theme-dreams (lambda (entry) (get theme entry))))
)
