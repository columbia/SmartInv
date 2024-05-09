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
27     uint256 public startBetRed;
28 
29     Bettor[] public bettorsBlue;
30     Bettor[] public bettorsRed;
31 
32     Event[] public history;
33 
34     mapping (address => uint) public balance;
35 
36     address private feeCollector;
37 
38     DiscountToken discountToken;
39 
40     constructor() public {
41         marketCapBlue = 0;
42         marketCapRed = 0;
43         
44         startBetBlue = 0;
45         startBetRed = 0;
46         
47         feeCollector = 0xfd4e7b9f4f97330356f7d1b5ddb9843f2c3e9d87;
48         discountToken = DiscountToken(0x40430713e9fa954cf33562b8469ad94ab3e14c10);
49         lastLevelChangeBlock = block.number;
50         moonLevel = 500 finney;
51     }
52 
53     function getBetAmount() private returns (uint256) {
54         require (msg.value >= 100 finney);
55 
56         uint256 betAmount = msg.value;
57         if (discountToken.balanceOf(msg.sender) == 0) {
58             uint256 comission = betAmount * 4 / 100;
59             betAmount -= comission;
60             balance[feeCollector] += comission;
61         }
62 
63         return betAmount;
64     }
65 
66     function betBlueCoin() public payable {
67         uint256 betAmount = getBetAmount();
68 
69         marketCapBlue += betAmount;
70         bettorsBlue.push(Bettor({account:msg.sender, amount:betAmount}));
71 
72         checkMoon();
73     }
74 
75     function betRedCoin() public payable {
76         uint256 betAmount = getBetAmount();
77 
78         marketCapRed += betAmount;
79         bettorsRed.push(Bettor({account:msg.sender, amount:betAmount}));
80 
81         checkMoon();
82     }
83 
84     function withdraw() public {
85         if (balance[feeCollector] != 0) {
86             uint256 fee = balance[feeCollector];
87             balance[feeCollector] = 0;
88             feeCollector.call.value(fee)();
89         }
90 
91         uint256 amount = balance[msg.sender];
92         balance[msg.sender] = 0;
93         msg.sender.transfer(amount);
94     }
95 
96     function depositBalance(uint256 winner) private {
97         uint256 i;
98         if (winner == 0) {
99             for (i = startBetBlue; i < bettorsBlue.length; i++) {
100                 balance[bettorsBlue[i].account] += bettorsBlue[i].amount;
101                 balance[bettorsBlue[i].account] += 10**18 * bettorsBlue[i].amount / marketCapBlue * marketCapRed / 10**18;
102             }
103         }
104         else {
105             for (i = startBetRed; i < bettorsRed.length; i++) {
106                 balance[bettorsRed[i].account] += bettorsRed[i].amount;
107                 balance[bettorsRed[i].account] += 10**18 * bettorsRed[i].amount / marketCapRed * marketCapBlue / 10**18;
108             }
109         }
110     }
111 
112     function addEvent(uint256 winner) private {
113         history.push(Event({winner: winner, newMoonLevel: moonLevel, block: block.number, blueCap: marketCapBlue, redCap: marketCapRed}));
114         lastEventId = history.length - 1;
115         lastLevelChangeBlock = block.number;
116     }
117 
118     function burstBubble() private {
119         uint256 winner;
120         if (marketCapBlue == marketCapRed) {
121             winner = block.number % 2;
122         }
123         else if (marketCapBlue > marketCapRed) {
124             winner = 0;
125         }
126         else {
127             winner = 1;
128         }
129         depositBalance(winner);
130         moonLevel = moonLevel * 2;
131         addEvent(winner);
132 
133         marketCapBlue = 0;
134         marketCapRed = 0;
135         
136         startBetBlue = bettorsBlue.length;
137         startBetRed = bettorsRed.length;
138     }
139 
140     function checkMoon() private {
141         if (block.number - lastLevelChangeBlock > 42000) {
142            moonLevel = moonLevel / 2;
143            addEvent(2);
144         }
145         if (marketCapBlue >= moonLevel || marketCapRed >= moonLevel) {
146             burstBubble();
147         }
148     }
149 }