1 pragma solidity >=0.4.22 <0.6.0;
2 contract shy {
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
18 
19     constructor(uint8 _numProposals) public {
20         chairperson = msg.sender;
21         voters[chairperson].weight = 1;
22         proposals.length = _numProposals;
23     }
24 
25 
26     function giveRightToVote(address toVoter) public {
27         if (msg.sender != chairperson || voters[toVoter].voted) return;
28         voters[toVoter].weight = 1;
29     }
30 
31 
32     function delegate(address to) public {
33         Voter storage sender = voters[msg.sender]; // assigns reference
34         if (sender.voted) return;
35         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
36             to = voters[to].delegate;
37         if (to == msg.sender) return;
38         sender.voted = true;
39         sender.delegate = to;
40         Voter storage delegateTo = voters[to];
41         if (delegateTo.voted)
42             proposals[delegateTo.vote].voteCount += sender.weight;
43         else
44             delegateTo.weight += sender.weight;
45     }
46 
47 
48     function vote(uint8 toProposal) public {
49         Voter storage sender = voters[msg.sender];
50         if (sender.voted || toProposal >= proposals.length) return;
51         sender.voted = true;
52         sender.vote = toProposal;
53         proposals[toProposal].voteCount += sender.weight;
54     }
55 
56     function winningProposal() public view returns (uint8 _winningProposal) {
57         uint256 winningVoteCount = 0;
58         for (uint8 prop = 0; prop < proposals.length; prop++)
59             if (proposals[prop].voteCount > winningVoteCount) {
60                 winningVoteCount = proposals[prop].voteCount;
61                 _winningProposal = prop;
62             }
63     }
64 }