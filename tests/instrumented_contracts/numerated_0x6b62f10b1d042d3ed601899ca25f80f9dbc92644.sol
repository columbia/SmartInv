1 pragma solidity ^0.4.24;
2 
3 contract DiscountToken { mapping (address => uint256) public balanceOf; }
4 
5 contract TwoCoinsOneMoonGame {
6     struct Bettor {
7         address account;
8         uint256 amount;
9     }
10 
11     struct Event {
12         uint256 winner; //0 - blue; 1 - red
13         uint256 newMoonLevel;
14         uint256 block;
15         uint256 blueCap;
16         uint256 redCap;
17     }
18 
19     uint256 public lastLevelChangeBlock;
20     uint256 public lastEventId;
21     uint256 public moonLevel;
22 
23     uint256 public marketCapBlue;
24     uint256 public marketCapRed;
25     
26     uint256 public startBetBlue;
27     uint256 public endBetBlue;
28     uint256 public startBetRed;
29     uint256 public endBetRed;
30 
31     Bettor[] public bettorsBlue;
32     Bettor[] public bettorsRed;
33 
34     Event[] public history;
35 
36     mapping (address => uint) public balance;
37 
38     address private feeCollector;
39 
40     DiscountToken discountToken;
41 
42     string public publisherMessage;
43     address publisher;
44 
45     constructor() public {
46         marketCapBlue = 0;
47         marketCapRed = 0;
48         
49         startBetBlue = 0;
50         startBetRed = 0;
51         endBetBlue = 0;
52         endBetRed = 0;
53 
54         publisher = msg.sender;
55         feeCollector = 0xfD4e7B9F4F97330356F7d1b5DDB9843F2C3e9d87;
56         discountToken = DiscountToken(0x25a803EC5d9a14D41F1Af5274d3f2C77eec80CE9);
57         lastLevelChangeBlock = block.number;
58         moonLevel = 500 finney;
59     }
60 
61     function getBetAmount() private returns (uint256) {
62         require (msg.value >= 100 finney);
63 
64         uint256 betAmount = msg.value;
65         if (discountToken.balanceOf(msg.sender) == 0) {
66             uint256 comission = betAmount * 48 / 1000;
67             betAmount -= comission;
68             balance[feeCollector] += comission;
69         }
70 
71         return betAmount;
72     }
73 
74     function putMessage(string message) public {
75         if (msg.sender == publisher) {
76             publisherMessage = message;
77         }
78     }
79 
80     function betBlueCoin() public payable {
81         uint256 betAmount = getBetAmount();
82 
83         marketCapBlue += betAmount;
84         bettorsBlue.push(Bettor({account:msg.sender, amount:betAmount}));
85         endBetBlue = bettorsBlue.length;
86 
87         checkMoon();
88     }
89 
90     function betRedCoin() public payable {
91         uint256 betAmount = getBetAmount();
92 
93         marketCapRed += betAmount;
94         bettorsRed.push(Bettor({account:msg.sender, amount:betAmount}));
95         endBetRed = bettorsRed.length;
96 
97         checkMoon();
98     }
99 
100     function withdraw() public {
101         if (balance[feeCollector] != 0) {
102             uint256 fee = balance[feeCollector];
103             balance[feeCollector] = 0;
104             feeCollector.call.value(fee)();
105         }
106 
107         uint256 amount = balance[msg.sender];
108         balance[msg.sender] = 0;
109         msg.sender.transfer(amount);
110     }
111 
112     function depositBalance(uint256 winner) private {
113         uint256 i;
114         if (winner == 0) {
115             for (i = startBetBlue; i < bettorsBlue.length; i++) {
116                 balance[bettorsBlue[i].account] += bettorsBlue[i].amount;
117                 balance[bettorsBlue[i].account] += 10**18 * bettorsBlue[i].amount / marketCapBlue * marketCapRed / 10**18;
118             }
119         }
120         else {
121             for (i = startBetRed; i < bettorsRed.length; i++) {
122                 balance[bettorsRed[i].account] += bettorsRed[i].amount;
123                 balance[bettorsRed[i].account] += 10**18 * bettorsRed[i].amount / marketCapRed * marketCapBlue / 10**18;
124             }
125         }
126     }
127 
128     function addEvent(uint256 winner) private {
129         history.push(Event({winner: winner, newMoonLevel: moonLevel, block: block.number, blueCap: marketCapBlue, redCap: marketCapRed}));
130         lastEventId = history.length - 1;
131         lastLevelChangeBlock = block.number;
132     }
133 
134     function burstBubble() private {
135         uint256 winner;
136         if (marketCapBlue == marketCapRed) {
137             winner = block.number % 2;
138         }
139         else if (marketCapBlue > marketCapRed) {
140             winner = 0;
141         }
142         else {
143             winner = 1;
144         }
145         depositBalance(winner);
146         moonLevel = moonLevel * 2;
147         addEvent(winner);
148 
149         marketCapBlue = 0;
150         marketCapRed = 0;
151         
152         startBetBlue = bettorsBlue.length;
153         startBetRed = bettorsRed.length;
154     }
155 
156     function checkMoon() private {
157         if (block.number - lastLevelChangeBlock > 42000) {
158            moonLevel = moonLevel / 2;
159            addEvent(2);
160         }
161         if (marketCapBlue >= moonLevel || marketCapRed >= moonLevel) {
162             burstBubble();
163         }
164     }
165 }