1 pragma solidity ^0.4.18;
2 
3 contract FakeVote {
4     
5     // key-value store mapping account to the number of votes that it received
6     mapping (address => uint256) public voteCount;
7     
8     // every account has a finite number of votes it can cast
9     mapping (address => uint256) public alreadyUsedVotes;
10     
11     // every account can cast maximally 10 votes
12     uint256 public maxNumVotesPerAccount = 10;
13     
14     // cast a vote for an account
15     function voteFor(address participant, uint256 numVotes) public {
16 
17         // overflow protection
18         require (voteCount[participant] < voteCount[participant] + numVotes);
19         
20         // do not allow self-votes
21         require(participant != msg.sender);
22         
23         // do not allow voter to cast more votes than they should be able to
24         require(alreadyUsedVotes[msg.sender] + numVotes <= maxNumVotesPerAccount);
25         
26         // increase vote count
27         alreadyUsedVotes[msg.sender] += numVotes;
28         
29         // register votes;
30         voteCount[participant] += numVotes;
31     }
32 }