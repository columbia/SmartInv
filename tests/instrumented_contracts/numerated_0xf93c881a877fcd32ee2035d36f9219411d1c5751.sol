1 pragma solidity ^0.4.0;
2 contract NinsaToken {
3 
4     struct Voter {
5         uint weight;
6         bool voted;
7         uint8 vote;
8         address delegate;
9     }
10     struct Proposal {
11         uint voteCount;
12     }
13 
14     address chairperson;
15     mapping(address => Voter) voters;
16     Proposal[] proposals;
17 
18     function giveRightToVote(address toVoter) public {
19         if (msg.sender != chairperson || voters[toVoter].voted) return;
20         voters[toVoter].weight = 1;
21     }
22 
23     /// Delegate your vote to the voter $(to).
24     function delegate(address to) public {
25         Voter storage sender = voters[msg.sender]; // assigns reference
26         if (sender.voted) return;
27         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
28             to = voters[to].delegate;
29         if (to == msg.sender) return;
30         sender.voted = true;
31         sender.delegate = to;
32         Voter storage delegateTo = voters[to];
33         if (delegateTo.voted)
34             proposals[delegateTo.vote].voteCount += sender.weight;
35         else
36             delegateTo.weight += sender.weight;
37     }
38 
39     /// Give a single vote to proposal $(toProposal).
40     function vote(uint8 toProposal) public {
41         Voter storage sender = voters[msg.sender];
42         if (sender.voted || toProposal >= proposals.length) return;
43         sender.voted = true;
44         sender.vote = toProposal;
45         proposals[toProposal].voteCount += sender.weight;
46     }
47 
48     function winningProposal() public constant returns (uint8 _winningProposal) {
49         uint256 winningVoteCount = 0;
50         for (uint8 prop = 0; prop < proposals.length; prop++)
51             if (proposals[prop].voteCount > winningVoteCount) {
52                 winningVoteCount = proposals[prop].voteCount;
53                 _winningProposal = prop;
54             }
55     }
56 }