;; Collective Dream Journal

;; Define data vars
(define-data-var next-dream-id uint u0)

;; Define data maps
(define-map dreams
  { dream-id: uint }
  { dreamer: principal, content: (string-utf8 1000), timestamp: uint, themes: (list 5 (string-ascii 20)) })

(define-map user-dreams principal (list 100 uint))

;; Define constants
(define-constant ERR-NOT-FOUND (err u100))
(define-constant ERR-UNAUTHORIZED (err u101))

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
    (let
      (
        (user-dream-list (default-to (list) (map-get? user-dreams dreamer)))
      )
      (map-set user-dreams
        dreamer
        (unwrap! (as-max-len? (append user-dream-list dream-id) u100) ERR-UNAUTHORIZED)
      )
    )
    (ok dream-id)
  )
)

;; Get a dream by ID
(define-read-only (get-dream (dream-id uint))
  (ok (unwrap! (map-get? dreams { dream-id: dream-id }) ERR-NOT-FOUND))
)

;; Get user's dreams
(define-read-only (get-user-dreams (user principal))
  (ok (default-to (list) (map-get? user-dreams user)))
)

