import { describe, it, beforeEach, expect } from 'vitest';

// Simulated contract state
let dreams: Map<number, { dreamer: string, content: string, timestamp: number, themes: string[] }>;
let userDreams: Map<string, number[]>;
let nextDreamId: number;

// Simulated contract functions
function submitDream(dreamer: string, content: string, themes: string[]): number {
  const dreamId = nextDreamId++;
  dreams.set(dreamId, { dreamer, content, timestamp: Date.now(), themes });
  
  const userDreamList = userDreams.get(dreamer) || [];
  userDreamList.push(dreamId);
  userDreams.set(dreamer, userDreamList);
  
  return dreamId;
}

function getDream(dreamId: number): { dreamer: string, content: string, timestamp: number, themes: string[] } | undefined {
  return dreams.get(dreamId);
}

function getUserDreams(user: string): number[] {
  return userDreams.get(user) || [];
}

describe('Dream Journal Contract', () => {
  beforeEach(() => {
    dreams = new Map();
    userDreams = new Map();
    nextDreamId = 0;
  });
  
  it('should submit a dream', () => {
    const dreamer = 'user1';
    const content = 'I was flying over a city of gold.';
    const themes = ['flying', 'city', 'gold'];
    const dreamId = submitDream(dreamer, content, themes);
    
    expect(dreamId).toBe(0);
    expect(dreams.size).toBe(1);
    expect(userDreams.get(dreamer)).toContain(0);
  });
  
  it('should retrieve a dream by ID', () => {
    const dreamer = 'user1';
    const content = 'I was swimming in an ocean of stars.';
    const themes = ['swimming', 'ocean', 'stars'];
    const dreamId = submitDream(dreamer, content, themes);
    
    const retrievedDream = getDream(dreamId);
    expect(retrievedDream).toBeDefined();
    expect(retrievedDream!.dreamer).toBe(dreamer);
    expect(retrievedDream!.content).toBe(content);
    expect(retrievedDream!.themes).toEqual(themes);
  });
  
  it('should return undefined for non-existent dream ID', () => {
    const retrievedDream = getDream(999);
    expect(retrievedDream).toBeUndefined();
  });
  
  it('should get user\'s dreams', () => {
    const dreamer = 'user2';
    submitDream(dreamer, 'Dream 1', ['theme1']);
    submitDream(dreamer, 'Dream 2', ['theme2']);
    
    const userDreamIds = getUserDreams(dreamer);
    expect(userDreamIds).toHaveLength(2);
    expect(userDreamIds).toContain(0);
    expect(userDreamIds).toContain(1);
  });
  
  it('should return an empty array for user with no dreams', () => {
    const userDreamIds = getUserDreams('nonexistent-user');
    expect(userDreamIds).toHaveLength(0);
  });
  
  it('should handle multiple users submitting dreams', () => {
    submitDream('user1', 'User 1 Dream 1', ['theme1']);
    submitDream('user2', 'User 2 Dream 1', ['theme2']);
    submitDream('user1', 'User 1 Dream 2', ['theme3']);
    
    expect(dreams.size).toBe(3);
    expect(getUserDreams('user1')).toHaveLength(2);
    expect(getUserDreams('user2')).toHaveLength(1);
  });
});

