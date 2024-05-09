1 // Aeternity Hybrid Onchain Governance Vote - for official information see https://blog.aeternity.com/aeternity-first-on-chain-governance-vote-decentralization-2-0-5e0c8a01891a
2 
3 pragma solidity ^0.5.0;
4 
5 contract SimpleVote {
6     
7     address[] public voters;
8     int8 public maxVoteValue;
9     
10     mapping (address=> int8) public getVote;
11     mapping (address=> bool) public hasVoted;
12 
13     constructor (int8 _maxVoteValue) public {
14         maxVoteValue = _maxVoteValue;
15     }
16     
17     function totalVotes() view public returns (uint) {
18         return voters.length;
19     }
20     
21     function vote(int8 _vote) public returns (bool) {
22         require(block.timestamp < 1557914400, "Voting is over at May 15 2019 at 12:00:00 AM CEST");
23         require(_vote <= maxVoteValue, "Voted for value higher than allowed");
24         getVote[msg.sender] = _vote;
25         if(hasVoted[msg.sender] == false) {
26             voters.push(msg.sender);
27             hasVoted[msg.sender] = true;
28 
29         }
30     }
31 }