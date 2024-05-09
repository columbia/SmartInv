1 pragma solidity ^0.4.0;
2 contract BTC666 {
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
18     /// Create a new ballot with $(_numProposals) different proposals.
19     function Ballot(uint8 _numProposals) public {
20         chairperson = msg.sender;
21         voters[chairperson].weight = 1;
22         proposals.length = _numProposals;
23     }
24 
25     /// Give $(toVoter) the right to vote on this ballot.
26     /// May only be called by $(chairperson).
27     function giveRightToVote(address toVoter) public {
28         if (msg.sender != chairperson || voters[toVoter].voted) return;
29         voters[toVoter].weight = 1;
30     }
31 
32     /// Delegate your vote to the voter $(to).
33     function delegate(address to) public {
34         Voter storage sender = voters[msg.sender]; // assigns reference
35         if (sender.voted) return;
36         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
37             to = voters[to].delegate;
38         if (to == msg.sender) return;
39         sender.voted = true;
40         sender.delegate = to;
41         Voter storage delegateTo = voters[to];
42         if (delegateTo.voted)
43             proposals[delegateTo.vote].voteCount += sender.weight;
44         else
45             delegateTo.weight += sender.weight;
46     }
47 
48     /// Give a single vote to proposal $(toProposal).
49     function vote(uint8 toProposal) public {
50         Voter storage sender = voters[msg.sender];
51         if (sender.voted || toProposal >= proposals.length) return;
52         sender.voted = true;
53         sender.vote = toProposal;
54         proposals[toProposal].voteCount += sender.weight;
55     }
56 
57     function winningProposal() public constant returns (uint8 _winningProposal) {
58         uint256 winningVoteCount = 0;
59         for (uint8 prop = 0; prop < proposals.length; prop++)
60             if (proposals[prop].voteCount > winningVoteCount) {
61                 winningVoteCount = proposals[prop].voteCount;
62                 _winningProposal = prop;
63             }
64     }
65 }