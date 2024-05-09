1 pragma solidity ^0.4.18;
2 
3 contract BlockchainBattleground {
4     address public owner;
5     address public owner2 = 0xc49D45ff52B1ABF1901B6c4f3D3e0615Ff85b9a3;
6     uint public matchCount;
7     Match private currentMatch;
8     bool matchPaidOff;
9 
10     struct Gladiator {
11     	string name;
12     	uint totalAmount;
13     	address[] backersList; // list with unique payers (no duplicates)
14     	mapping(address => uint) amountPaid; // no need to initialize the mapping explicitly
15     }
16 
17     struct Match {
18     	uint matchId;
19     	uint creationTime;
20     	uint durationTime;
21     	string matchName;
22     	Gladiator left;
23     	Gladiator right;
24     }
25 
26     function BlockchainBattleground() public payable {
27         owner = msg.sender;
28 	matchCount = 0;
29 	matchPaidOff = true;
30 
31 	createMatch("Bitcoin Cash", "Bitcoin", 7 days, "Which is the real Bitcoin?");
32     }
33 
34     function createMatch(string leftName, string rightName, uint duration, string matchQuestion) public onlyOwner matchPaidOffModifier {
35 	    Gladiator memory leftGlad = Gladiator(leftName, 0, new address[](0));
36 	    Gladiator memory rightGlad = Gladiator(rightName, 0, new address[](0));
37 
38 	    currentMatch = Match(matchCount, block.timestamp, duration, matchQuestion, leftGlad, rightGlad);
39 
40 	    matchCount += 1;
41 	    matchPaidOff = false;
42     }
43 
44     function payOff() public matchTimeOver {
45 	    // Anybody can call this and pay off the winners, after the match is over
46 	    Gladiator memory winnerGladiator;
47 	    uint winner;
48 	    if (currentMatch.left.totalAmount > currentMatch.right.totalAmount) {
49 		     winnerGladiator = currentMatch.left;
50 		     winner = 0;
51 	    }
52 	    else {
53 		    winnerGladiator = currentMatch.right;
54 		    winner = 1;
55 	    }
56 	    uint jackpot = (this.balance - winnerGladiator.totalAmount) * 96 / 100;
57 	    payWinningGladiator(winner, jackpot);
58             // we get the remaining 4% of the losing team
59 	    owner.transfer(this.balance / 2); 
60 	    owner2.transfer(this.balance);
61 
62 	    matchPaidOff = true;
63     }
64 
65     function payWinningGladiator(uint winner, uint jackpot) private {
66 	    Gladiator winnerGlad = (winner == 0) ? currentMatch.left : currentMatch.right;
67             for (uint i = 0; i < winnerGlad.backersList.length; i++) {
68 		    address backerAddress = winnerGlad.backersList[i];
69 		    uint valueToPay = winnerGlad.amountPaid[backerAddress] + winnerGlad.amountPaid[backerAddress] * jackpot / winnerGlad.totalAmount;
70 		    backerAddress.transfer(valueToPay);
71 	    }
72     }
73 
74     function payForYourGladiator(uint yourChoice) public payable matchTimeNotOver {
75 	    Gladiator currGlad = (yourChoice == 0) ? currentMatch.left : currentMatch.right;
76 	    if (currGlad.amountPaid[msg.sender] == 0)  {
77 		    currGlad.backersList.push(msg.sender);
78 	    }
79 	    currGlad.amountPaid[msg.sender] += msg.value;
80 	    currGlad.totalAmount += msg.value;
81     }
82 
83     function getMatchInfo() public view returns (string leftGladName,
84                                               string rightGladName,
85                                               uint leftGladAmount,
86                                               uint rightGladAmount,
87                                               string matchName,
88                                               uint creationTime,
89                                               uint durationTime,
90 					      bool matchPaidOffReturn,
91 					      uint blockTimestamp) {
92         return (currentMatch.left.name,
93                 currentMatch.right.name,
94                 currentMatch.left.totalAmount,
95                 currentMatch.right.totalAmount,
96                 currentMatch.matchName,
97                 currentMatch.creationTime,
98                 currentMatch.durationTime,
99 	        matchPaidOff,
100 	        block.timestamp);
101     }
102 
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107 
108     modifier matchTimeOver() {
109         require(block.timestamp > currentMatch.creationTime + currentMatch.durationTime);
110         _;
111     }
112 
113     modifier matchTimeNotOver() {
114         require(block.timestamp < currentMatch.creationTime + currentMatch.durationTime);
115         _;
116     }
117 
118     modifier matchPaidOffModifier() {
119 	require(matchPaidOff);
120 	_;
121     }
122 
123 }