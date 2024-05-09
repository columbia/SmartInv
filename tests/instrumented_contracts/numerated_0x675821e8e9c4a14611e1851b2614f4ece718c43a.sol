1 pragma solidity ^0.4.25;
2 
3 /*
4     @KAKUTAN-team
5     https://myethergames.fun
6     26.12.2018
7 */
8 
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address _newOwner) public onlyOwner {
25         _transferOwnership(_newOwner);
26     }
27 
28     function _transferOwnership(address _newOwner) internal {
29         require(_newOwner != address(0));
30         emit OwnershipTransferred(owner, _newOwner);
31         owner = _newOwner;
32     }
33 }
34 
35 library SafeMath {
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a / b;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57         c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 contract BlackAndWhite is Ownable {
64 
65     using SafeMath for uint256;
66 
67     uint8 constant BLACK = 0;
68     uint8 constant WHITE = 1;
69     uint constant TEAM_PERCENT = 2;
70     uint constant BET_EXPIRATION_BLOCKS = 250;
71     uint public betAmount = 50000000000000000;
72     uint public minAmount = 100000000000000000;
73     uint public lockedInBets;
74     uint public teamBalance;
75 
76     uint betId;
77 
78     struct Bet {
79         uint amount;
80         uint8 option;
81         uint40 placeBlockNumber;
82         address gambler;
83     }
84 
85     mapping (uint => Bet) bets;
86 
87     address public botAddress;
88 
89     modifier onlyBot {
90         require (msg.sender == botAddress);
91         _;
92     }
93 
94     event FailedPayment(address indexed beneficiary, uint amount);
95     event Payment(address indexed beneficiary, uint amount);
96 
97     event Commit(address gambler, uint commit, uint8 option);
98     event Reveal(uint betId, uint reveal, uint seed, uint amount, address gambler, uint8 betOption);
99 
100     event NewPrice(uint newPrice);
101 
102 
103     constructor() public {
104         botAddress = 0x3be76eeFF089AF790dd8Cbf3b921e430a962214d;
105         betId = 0;
106     }
107 
108     function setBotAddress(address newAddress) external onlyOwner {
109         botAddress = newAddress;
110     }
111 
112     function() external payable {
113 
114     }
115 
116     function placeBet(uint8 option) public payable {
117         require(option == BLACK || option == WHITE);
118         Bet storage bet = bets[betId];
119         require (bet.gambler == address(0));
120         betId = betId.add(1);
121         uint amount = msg.value;
122         require(amount == betAmount);
123 
124         uint possibleWinAmount;
125 
126         possibleWinAmount = getWinAmount(amount);
127 
128         lockedInBets = lockedInBets.add(possibleWinAmount);
129 
130         require (lockedInBets <= address(this).balance);
131 
132         emit Commit(msg.sender, betId.sub(1), option);
133 
134         bet.amount = amount;
135         bet.option = option;
136         bet.placeBlockNumber = uint40(block.number);
137         bet.gambler = msg.sender;
138     }
139 
140     function settleBet(uint _betId, uint data) external onlyBot {
141         require(data != 0);
142         Bet storage bet = bets[_betId];
143         uint placeBlockNumber = bet.placeBlockNumber;
144 
145         require (block.number > placeBlockNumber);
146         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS);
147         uint amount = bet.amount;
148         address gambler = bet.gambler;
149 
150         require (amount != 0, "Bet should be in an 'active' state");
151 
152         bet.amount = 0;
153 
154         uint possibleWinAmount = getWinAmount(amount);
155         uint winAmount = 0;
156         uint seed = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
157         uint random = data.add(seed);
158 
159         if(bet.option == BLACK) {
160             winAmount = random % 2 == BLACK ? possibleWinAmount : 0;
161         }
162 
163         if(bet.option == WHITE) {
164             winAmount = random % 2 == WHITE ? possibleWinAmount : 0;
165         }
166 
167         if(winAmount > 0) {
168             require(address(this).balance >= minAmount + winAmount + teamBalance );
169         }
170 
171         teamBalance = teamBalance.add(beneficiaryPercent(amount));
172         lockedInBets -= possibleWinAmount;
173 
174         sendFunds(gambler, winAmount);
175 
176         emit Reveal(_betId, data, seed, winAmount, gambler, bet.option);
177     }
178 
179     function refundBet(uint _betId) external {
180         Bet storage bet = bets[_betId];
181         uint amount = bet.amount;
182 
183         require (amount != 0);
184 
185         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS);
186 
187         bet.amount = 0;
188 
189         uint winAmount;
190         winAmount = getWinAmount(amount);
191 
192         lockedInBets -= uint128(winAmount);
193 
194         sendFunds(bet.gambler, amount);
195     }
196 
197     function getWinAmount(uint amount) private pure returns (uint winAmount) {
198         uint team = beneficiaryPercent(amount);
199 
200         winAmount = (amount * 2) - team;
201     }
202 
203     function beneficiaryPercent(uint amount) private pure returns(uint) {
204         uint team = amount * TEAM_PERCENT / 100;
205         require(team <= amount);
206         return team;
207     }
208 
209     function sendFunds(address _beneficiary, uint amount) private {
210         if (_beneficiary.send(amount)) {
211             emit Payment(_beneficiary, amount);
212         } else {
213             emit FailedPayment(_beneficiary, amount);
214         }
215     }
216 
217     function withdrawFunds(address _beneficiary, uint withdrawAmount) external onlyOwner {
218         require (withdrawAmount <= address(this).balance);
219         require (lockedInBets + withdrawAmount <= address(this).balance);
220         sendFunds(_beneficiary, withdrawAmount);
221     }
222 
223     function setPrice(uint newPrice) public onlyOwner {
224         betAmount = newPrice;
225         emit NewPrice(newPrice);
226     }
227 
228     function setMinAmount(uint amount) public onlyOwner{
229         minAmount = amount;
230     }
231 
232     function canRefund(uint _betId) public constant returns(bool) {
233         Bet storage bet = bets[_betId];
234         if(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS && bet.placeBlockNumber > 0 && bet.amount > 0) {
235             return true;
236         } else {
237             return false;
238         }
239     }
240 
241 }