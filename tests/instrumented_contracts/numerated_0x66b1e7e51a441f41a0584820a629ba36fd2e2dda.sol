1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     /**
16     * @dev Integer division of two numbers, truncating the quotient.
17     */
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24     /**
25     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
26     */
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31     /**
32     * @dev Adds two numbers, throws on overflow.
33     */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 contract TheRichestWins {
42     using SafeMath for uint256;
43 
44     address contractOwner;
45     uint tokenStartPrice = 0.001 ether;
46     uint tokenStartPrice2 = 0.001483239697419133 ether;  // sqrt(2.2) = 1,483239697419133
47     uint tokenPrice;
48     uint tokenPrice2;
49     address tokenOwner;
50     address tokenOwner2;
51     uint lastBuyBlock;
52     uint newRoundDelay = 40;
53 
54     address public richestPlayer;
55     uint public highestPrice;
56 
57     uint public round;
58     uint public flips;
59     uint payoutRound;
60     uint public richestRoundId;
61 
62     event Transfer(address indexed from, address indexed to, uint256 price);
63     event NewRound(uint paidPrice, uint win, address winner);
64     event RichestBonus(uint win, address richestPlayer);
65 
66 
67     function TheRichestWins() public {
68         contractOwner = msg.sender;
69         tokenOwner = address(0);
70         lastBuyBlock = block.number; 
71         tokenPrice = tokenStartPrice;
72         tokenPrice2 = tokenStartPrice2;
73     }
74 
75     function getRoundId() public view returns(uint) {
76         return round*1000000+flips;
77     }
78 
79     function changeNewRoundDelay(uint delay) public {
80         require(contractOwner == msg.sender);
81         newRoundDelay = delay;
82     }
83     function changeContractOwner(address newOwner) public {
84         require(contractOwner == msg.sender);
85         contractOwner = newOwner;
86     }
87     
88 
89     function buyToken() public payable {
90         address currentOwner;
91         uint256 currentPrice;
92         uint256 paidTooMuch;
93         uint256 payment;
94 
95         if (tokenPrice < tokenPrice2) {
96             currentOwner = tokenOwner;
97             currentPrice = tokenPrice;
98             require(tokenOwner2 != msg.sender);
99         } else {
100             currentOwner = tokenOwner2;
101             currentPrice = tokenPrice2;
102             require(tokenOwner != msg.sender);
103         }
104         require(msg.value >= currentPrice);
105 
106         paidTooMuch = msg.value.sub(currentPrice);
107         payment = currentPrice.div(2);
108 
109         if (tokenPrice < tokenPrice2) {
110             tokenPrice = currentPrice.mul(110).div(50);
111             tokenOwner = msg.sender;
112         } else {
113             tokenPrice2 = currentPrice.mul(110).div(50);
114             tokenOwner2 = msg.sender;
115         }
116         lastBuyBlock = block.number;
117         flips++;
118 
119         Transfer(currentOwner, msg.sender, currentPrice);
120 
121         if (currentOwner != address(0)) {
122             payoutRound = getRoundId()-3;
123             currentOwner.call.value(payment).gas(24000)();
124         }
125         if (paidTooMuch > 0)
126             msg.sender.transfer(paidTooMuch);
127     }
128 
129     function getBlocksToNextRound() public view returns(uint) {
130         if (lastBuyBlock + newRoundDelay < block.number) {
131             return 0;
132         }
133         return lastBuyBlock + newRoundDelay + 1 - block.number;
134     }
135 
136     function getPool() public view returns(uint balance) {
137         balance = this.balance;
138     }
139 
140     function finishRound() public {
141         require(tokenPrice > tokenStartPrice);
142         require(lastBuyBlock + newRoundDelay < block.number);
143 
144         lastBuyBlock = block.number;
145         address owner = tokenOwner;
146         uint price = tokenPrice;
147         if (tokenPrice2>tokenPrice) {
148             owner = tokenOwner2;
149             price = tokenPrice2;
150         }
151         uint lastPaidPrice = price.mul(50).div(110);
152         uint win = this.balance - lastPaidPrice;
153 
154         if (highestPrice < lastPaidPrice) {
155             richestPlayer = owner;
156             highestPrice = lastPaidPrice;
157             richestRoundId = getRoundId()-1;
158         }
159 
160         tokenPrice = tokenStartPrice;
161         tokenPrice2 = tokenStartPrice2;
162         tokenOwner = address(0);
163         tokenOwner2 = address(0);
164 
165         payoutRound = getRoundId()-1;
166         flips = 0;
167         round++;
168         NewRound(lastPaidPrice, win / 2, owner);
169 
170         contractOwner.transfer((this.balance - (lastPaidPrice + win / 2) - win / 10) * 19 / 20);
171         owner.call.value(lastPaidPrice + win / 2).gas(24000)();
172         if (richestPlayer!=address(0)) {
173             payoutRound = richestRoundId;
174             RichestBonus(win / 10, richestPlayer);
175             richestPlayer.call.value(win / 10).gas(24000)();
176         }
177     }
178 
179     function getPayoutRoundId() public view returns(uint) {
180         return payoutRound;
181     }
182     function getPrice() public view returns(uint) {
183         if (tokenPrice2<tokenPrice)
184             return tokenPrice2;
185         return tokenPrice;
186     }
187 
188     function getCurrentData() public view returns (uint price, uint nextPrice, uint pool, address winner, address looser, bool canFinish, uint nextPool, uint win, uint nextWin) {
189         winner = tokenOwner;
190         looser = tokenOwner2;
191         price = tokenPrice2;
192         nextPrice = tokenPrice;
193         if (tokenPrice2>tokenPrice) {
194             winner = tokenOwner2;
195             looser = tokenOwner;
196             price = tokenPrice;
197             nextPrice = tokenPrice2;
198         }
199         canFinish = (tokenPrice > tokenStartPrice) && (lastBuyBlock + newRoundDelay < block.number);
200         pool = getPool();
201         if (price == tokenStartPrice) {
202             nextPool = pool + price;
203             win = 0;
204         } else if (price == tokenStartPrice2) {
205             nextPool = pool + price;
206             win = (pool-nextPrice.mul(50).div(110))/2;
207         } else {
208             nextPool = pool + price / 2;
209             win = (pool-nextPrice.mul(50).div(110))/2;
210         }
211         nextWin = (nextPool-price)/2;
212     }
213 }