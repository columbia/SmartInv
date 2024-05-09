1 pragma solidity ^0.5.0;
2 
3 contract Election {
4     
5     address owner;
6     
7     struct Candidate {
8         uint id;
9         string name;
10         uint voteCount;
11     }
12 
13     event votedEvent (
14         uint indexed candidateID
15     );
16 
17     uint public candidatesCount;
18     mapping(uint => Candidate) public candidates;
19     mapping(address => bool) public voters;
20 
21 
22     constructor() public payable
23 
24     {
25         owner = msg.sender;
26         addCandidate("Candidate 1");
27         addCandidate("Candidate 2");
28     }
29     
30     function kill() public {
31         if (msg.sender == owner) selfdestruct(msg.sender);
32     }
33     
34 
35     function addCandidate(string memory name) private
36     {
37         ++candidatesCount;
38         candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
39     }
40 
41     function vote(uint candidateID) public
42     {
43         require(!voters[msg.sender]);
44         require(candidateID > 0 && candidateID <= candidatesCount);
45 
46         voters[msg.sender] = true;
47         candidates[candidateID].voteCount++;
48         emit votedEvent(candidateID);
49     }
50 }