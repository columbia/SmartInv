1 pragma solidity ^0.4.18;
2 
3 contract Voting {
4   address creator; // The address of the account that created this ballot.
5 
6   mapping (bytes32 => uint8) public votesReceived;
7   mapping (address => bytes32) public votes;
8 
9   bytes32[] public candidateList;
10   uint16 public totalVotes;
11   bool public votingFinished;
12 
13   function Voting(bytes32[] candidateNames) public {
14     creator = msg.sender;
15     candidateList = candidateNames;
16   }
17 
18   function totalVotesFor(bytes32 candidate) view public returns (uint8) {
19     require(validCandidate(candidate));
20     require(votingFinished);  // Don't reveal votes until voting is finished
21     return votesReceived[candidate];
22   }
23 
24   function numCandidates() public constant returns(uint count) {
25     return candidateList.length;
26   }
27 
28   function getMyVote() public returns(bytes32 candidate) {
29     return votes[msg.sender];
30   }
31 
32   function voteForCandidate(bytes32 candidate) public {
33     require(!votingFinished);
34     require(validCandidate(candidate));
35     votes[msg.sender] = candidate;
36     votesReceived[candidate] += 1;
37     totalVotes += 1;
38   }
39 
40   function validCandidate(bytes32 candidate) view public returns (bool) {
41     for(uint i = 0; i < candidateList.length; i++) {
42       if (candidateList[i] == candidate) {
43         return true;
44       }
45     }
46     return false;
47   }
48   
49   function endVote() public returns (bool) {
50     require(msg.sender == creator);  // Only contract creator can end the vote.
51     votingFinished = true;
52   }
53   
54 }