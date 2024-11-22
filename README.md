# Collective Dream Journal

A decentralized application that allows users to anonymously share and explore dreams using a Clarity smart contract and React frontend. The project combines blockchain permanence with an intuitive user interface to create a collective dream repository.

## System Architecture

### Frontend (React)
- Modern React application using shadcn/ui components
- Toast notifications for user feedback
- Responsive dream submission form
- Real-time theme exploration

### Smart Contract (Clarity)
- Secure dream storage and retrieval
- User-specific dream tracking
- Theme categorization system
- Principal-based authentication

## Features

### Dream Submission
- Anonymous dream sharing
- Theme categorization
- Character-limited descriptions
- Timestamp recording

### Dream Exploration
- Common theme discovery
- Personal dream history
- Theme-based searching
- Preservation of privacy

## Technical Components

### Smart Contract Functions

1. `submit-dream`
   ```clarity
   (define-public (submit-dream (content (string-utf8 1000)) (themes (list 5 (string-ascii 20))))
   ```
    - Stores dream content and themes
    - Returns unique dream ID
    - Limits: 1000 chars content, 5 themes max

2. `get-dream`
   ```clarity
   (define-read-only (get-dream (dream-id uint))
   ```
    - Retrieves dream by ID
    - Returns full dream data structure

3. `get-user-dreams`
   ```clarity
   (define-read-only (get-user-dreams (user principal))
   ```
    - Lists user's dream IDs
    - Privacy-preserving design

### React Components

1. `CollectiveDreamJournal`
    - Main form interface
    - Theme management
    - Toast notifications
    - Input validation

```typescript
interface Dream {
  content: string;
  themes: string[];
  timestamp: number;
  id: number;
}
```

## Installation

1. Smart Contract Deployment
```bash
clarinet contract publish collective-dream-journal
```

2. Frontend Setup
```bash
npm install
npm run dev
```

## Usage

### Submitting Dreams
1. Enter dream description
2. Add comma-separated themes
3. Submit using the form
4. Receive confirmation with dream ID

### Exploring Themes
1. Click "Get Common Themes"
2. View popular dream themes
3. Use themes for categorization

## Development Setup

### Prerequisites
- Node.js >= 14
- Clarinet for Clarity development
- React development environment

### Environment Variables
```env
REACT_APP_CONTRACT_ADDRESS=
REACT_APP_NETWORK_URL=
```

## Security Considerations

### Smart Contract
- Size-limited storage
- Principal-based authentication
- Protected state modifications

### Frontend
- Input sanitization
- Error handling
- Privacy preservation

## Testing

### Smart Contract Tests
```clarity
(test-submit-dream
  (let ((result (contract-call? .dream-journal submit-dream "test dream" (list "flying"))))
    (asserts! (is-ok result) "Dream submission failed")))
```

### Frontend Tests
```typescript
describe('CollectiveDreamJournal', () => {
  it('should submit dream successfully', async () => {
    // Test implementation
  });
});
```

## Future Enhancements

1. Feature Additions
    - Dream analysis tools
    - Theme clustering
    - Social interactions
    - Advanced search

2. Technical Improvements
    - Pagination support
    - Enhanced privacy
    - Theme suggestions
    - Real-time updates

## Contributing

1. Fork the repository
2. Create feature branch
3. Submit pull request
4. Follow code style

## License
MIT License
