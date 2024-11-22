;; Blockchain-Based Collective Consciousness

;; Define data vars
(define-data-var contract-owner principal tx-sender)
(define-data-var next-thought-id uint u0)

;; Define data maps
(define-map thoughts
  { thought-id: uint }
  { content: (string-utf8 1000), timestamp: uint, category: (string-ascii 20) })

(define-map user-thoughts
  { user: principal }
  { thought-ids: (list 100 uint) })

(define-map category-thoughts
  { category: (string-ascii 20) }
  { thought-ids: (list 1000 uint) })

;; Define constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-THOUGHT-NOT-FOUND (err u101))
(define-constant ERR-INVALID-CATEGORY (err u102))
(define-constant ERR-INVALID-CONTENT (err u103))

;; Define read-only functions
(define-read-only (get-thought (thought-id uint))
  (map-get? thoughts { thought-id: thought-id }))

(define-read-only (get-user-thoughts (user principal))
  (map-get? user-thoughts { user: user }))

(define-read-only (get-category-thoughts (category (string-ascii 20)))
  (map-get? category-thoughts { category: category }))

;; Define public functions
(define-public (submit-thought (content (string-utf8 1000)) (category (string-ascii 20)))
  (let
    (
      (user tx-sender)
      (thought-id (var-get next-thought-id))
      (timestamp block-height)
    )
    (asserts! (> (len content) u0) ERR-INVALID-CONTENT)
    (asserts! (> (len category) u0) ERR-INVALID-CATEGORY)
    (map-set thoughts
      { thought-id: thought-id }
      { content: content, timestamp: timestamp, category: category }
    )
    (var-set next-thought-id (+ thought-id u1))
    (let
      (
        (user-thought-list (default-to { thought-ids: (list) } (get-user-thoughts user)))
        (category-thought-list (default-to { thought-ids: (list) } (get-category-thoughts category)))
      )
      (map-set user-thoughts
        { user: user }
        { thought-ids: (unwrap! (as-max-len? (append (get thought-ids user-thought-list) thought-id) u100) ERR-NOT-AUTHORIZED) }
      )
      (map-set category-thoughts
        { category: category }
        { thought-ids: (unwrap! (as-max-len? (append (get thought-ids category-thought-list) thought-id) u1000) ERR-NOT-AUTHORIZED) }
      )
    )
    (ok thought-id)
  )
)

(define-public (delete-thought (thought-id uint))
  (let
    (
      (thought (unwrap! (get-thought thought-id) ERR-THOUGHT-NOT-FOUND))
      (user tx-sender)
    )
    (asserts! (is-eq user (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (map-delete thoughts { thought-id: thought-id })
    (ok true)
  )
)

;; Admin function to update contract owner
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (var-set contract-owner new-owner)
    (ok true)
  )
)
