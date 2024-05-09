1 pragma solidity ^0.4.10;
2 
3 contract VoteFactory {
4     address public owner;
5     uint public numPolls;
6     uint public nextEndTime;
7     Vote public yesContract;
8     Vote public noContract;
9     mapping(uint => string) public voteDescription;
10     mapping(address => mapping(uint => bool)) public hasVoted;
11     mapping(uint => uint) public numVoters; // number of voters per round
12     mapping(uint => mapping(uint => address)) public voter; // [voteId][voterNumber] => address
13     mapping(uint => uint) public yesCount; // number of yes for a given round
14     mapping(uint => uint) public noCount;
15     
16     event transferredOwner(address newOwner);
17     event startedNewVote(address initiator, uint duration, string description, uint voteId);
18     event voted(address voter, bool isYes);
19     
20     modifier onlyOwner {
21         if (msg.sender != owner)
22             throw;
23         _;
24     }
25     
26     function transferOwner(address newOwner) onlyOwner {
27         owner = newOwner;
28         transferredOwner(newOwner);
29     }
30 
31     function payOut() onlyOwner {
32         // just in case we accumulate a balance here, we have to be able to retrieve it
33         owner.send(this.balance);
34     }
35     
36     function VoteFactory() {
37         owner = msg.sender;
38         // constructor deploys yes and no contract
39         yesContract = new Vote();
40         noContract = new Vote();
41     }
42 
43     function() payable {
44         // default function starts new poll if previous poll is over for at least 10 minutes
45         if (nextEndTime < now + 10 minutes)
46             startNewVote(10 minutes, "Vote on tax reimbursements");
47     }
48     
49     function newVote(uint duration, string description) onlyOwner {
50         // only admin is able to start vote with arbitrary duration
51         startNewVote(duration, description);
52     }
53     
54     function startNewVote(uint duration, string description) internal {
55         // do not allow to start new vote if there's still something ongoing
56         if (now <= nextEndTime)
57             throw;
58         nextEndTime = now + duration;
59         voteDescription[numPolls] = description;
60         startedNewVote(msg.sender, duration, description, ++numPolls);
61     }
62     
63     function vote(bool isYes, address voteSender) {
64         
65         // voting should just be able via voting contract (use them as SWIS contracts)
66         if (msg.sender != address(yesContract) && msg.sender != address(noContract))
67             throw;
68 
69         // throw if time is over
70         if (now > nextEndTime)
71             throw;
72             
73         // throw if sender has already voted before
74         if (hasVoted[voteSender][numPolls])
75             throw;
76         
77         hasVoted[voteSender][numPolls] = true;
78         voter[numPolls][numVoters[numPolls]++] = voteSender;
79         
80         if (isYes)
81             yesCount[numPolls]++;
82         else
83             noCount[numPolls]++;
84 
85         voted(voteSender, isYes);
86     }
87 }
88 
89 contract Vote {
90     VoteFactory public myVoteFactory;
91 
92     function Vote() {
93         // constructor expects to be called by VoteFactory contract
94         myVoteFactory = VoteFactory(msg.sender);
95     }
96     
97     function () payable {
98         // make payable so that wallets that cannot send tx with 0 Wei still work
99         myVoteFactory.vote(this == myVoteFactory.yesContract(), msg.sender);
100     }
101 
102     function payOut() {
103         // just to collect accidentally accumulated funds
104         msg.sender.send(this.balance);
105     }
106 }