1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract DiceGame {
46 
47     using SafeMath for *;
48 
49     modifier onlyOwner {
50         require(owner == msg.sender, "only owner");
51         _;
52     }
53 
54     uint constant BET_EXPIRATION_BLOCKS = 250;
55     uint constant public maxNumber = 96;
56     uint constant public minNumber = 2;
57     uint public maxProfit = 4 ether;
58     uint public maxPendingPayouts; //total unpaid
59     uint public minBet = 0.01 ether;
60     uint public pID = 150000;
61 
62 
63     struct Bet {
64 
65         uint amount;
66         uint40 placeBlockNumber;
67         uint8 roll;
68         bool lessThan;
69         address player;
70     }
71 
72     address public signer = 0x62fF37a452F8fc3A471a59127430C1bCFAeaf313;
73     address public owner;
74 
75     mapping(bytes32 => Bet) public bets;
76     mapping(address => uint) playerPendingWithdrawals;
77     mapping(address => uint) playerIdxAddr;
78     mapping(uint => address) playerAddrIdx;
79 
80     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint BetValue, uint PlayerNumber, bool LessThan, uint256 Timestamp);
81     event LogResult(bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, bool LessThan, uint DiceResult, uint BetValue, uint Value, int Status, uint256 Timestamp);
82     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
83     event LogHouseWithdraw(uint indexed amount);
84 
85     constructor() payable public {
86         owner = msg.sender;
87         playerIdxAddr[msg.sender] = pID;
88         playerAddrIdx[pID] = msg.sender;
89 
90     }
91 
92     function setSecretSigner(address _signer) external onlyOwner {
93         signer = _signer;
94     }
95 
96     function setMinBet(uint _minBet) public onlyOwner {
97         minBet = _minBet;
98 
99     }
100 
101 
102 
103 
104     function getPlayerAddr(uint _pid) public view returns (address) {
105         return playerAddrIdx[_pid];
106     }
107 
108     function createInviteID(address _addr) public returns (bool) {
109         if (playerIdxAddr[_addr] == 0) {
110             pID++;
111             playerIdxAddr[_addr] = pID;
112             playerAddrIdx[pID] = _addr;
113             return true;
114         }
115         return false;
116     }
117 
118     function getPlayerId(address _addr) public view returns (uint){
119         return playerIdxAddr[_addr];
120     }
121 
122     function setMaxProfit(uint _maxProfit) public onlyOwner {
123         maxProfit = _maxProfit;
124     }
125 
126 
127     function() public payable {
128 
129     }
130 
131     function setOwner(address _owner) public onlyOwner {
132         owner = _owner;
133     }
134 
135     function placeBet(uint8 roll, bool lessThan, uint affID, uint lastBlock, bytes32 commit, uint8 v, bytes32 r, bytes32 s) public payable {
136         uint amount = msg.value;
137         require(amount >= minBet, "Amount is less than minimum bet size");
138         require(roll >= minNumber && roll <= maxNumber, "Place number should be with rang.");
139         require(block.number < lastBlock, "Commit has expired.");
140 
141         bytes32 signatureHash = keccak256(abi.encodePacked(lastBlock, commit));
142         require(signer == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
143 
144         Bet storage bet = bets[commit];
145         require(bet.player == address(0x0));
146 
147 
148         uint possibleWinAmount = getDiceWinAmount(amount, roll, lessThan);
149 
150         require(possibleWinAmount <=  amount + maxProfit, "maxProfit limit violation.");
151 
152         maxPendingPayouts = maxPendingPayouts.add(possibleWinAmount);
153 
154         require(maxPendingPayouts  <=   address(this).balance, "insufficient contract balance for payout.");
155 
156 
157         bet.amount = amount;
158         bet.placeBlockNumber = uint40(block.number);
159         bet.roll = uint8(roll);
160         bet.lessThan = lessThan;
161         bet.player = msg.sender;
162 
163         emit LogBet(commit, msg.sender, amount, bet.roll, bet.lessThan, now);
164 
165         if (affID > 150000 && affID <= pID) {
166             address affAddress = playerAddrIdx[affID];
167             if(affAddress != address(0x0)) {
168                 playerPendingWithdrawals[affAddress] = playerPendingWithdrawals[affAddress].add(amount.div(100));
169             }
170         }
171 
172 
173     }
174 
175 
176     function getDiceWinAmount(uint amount, uint roll, bool lessThan) private pure returns (uint) {
177 
178         uint rollNumber = lessThan ? roll : 101 - roll;
179 
180         return amount * 98 / rollNumber;
181     }
182 
183     /**
184         refund user bet amount
185     */
186     function refundBet(bytes32 commit) external {
187 
188         Bet storage bet = bets[commit];
189         uint amount = bet.amount;
190         address player = bet.player;
191         require(amount != 0, "Bet should be in an 'active' state");
192 
193         // Check that bet has already expired.
194         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
195 
196         // Move bet into 'processed' state, release funds.
197         bet.amount = 0;
198         uint profit = getDiceWinAmount(amount, bet.roll, bet.lessThan);
199         maxPendingPayouts = maxPendingPayouts.sub(profit);
200 
201         // Send the refund.
202         safeSendFunds(player, amount);
203 
204     }
205 
206 
207     function settleBet(bytes32 reveal) external {
208 
209 
210         bytes32 commit = keccak256(abi.encodePacked(reveal));
211 
212         Bet storage bet = bets[commit];
213 
214         //save gas
215         uint amount = bet.amount;
216         uint placeBlockNumber = bet.placeBlockNumber;
217         uint8 roll = bet.roll;
218         bool lessThan = bet.lessThan;
219         address player = bet.player;
220 
221         require(amount != 0);
222         require(block.number > placeBlockNumber);
223         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS);
224 
225         bet.amount = 0;
226 
227         uint dice = uint(reveal) % 100 + 1;
228 
229         uint diceWinAmount = getDiceWinAmount(amount, roll, lessThan);
230 
231 
232         maxPendingPayouts = maxPendingPayouts.sub(diceWinAmount);
233 
234         uint diceWin = 0;
235 
236         if ((lessThan && dice <= roll) || (!lessThan && dice >= roll)){ //win
237             diceWin = diceWinAmount;
238             safeSendFunds(player, diceWin);
239         }
240 
241 
242 
243         emit LogResult(commit, player, roll,lessThan,  dice, amount, diceWin, diceWin == 0 ? 1 : 2, now);
244 
245 
246 
247 
248 
249     }
250 
251     function clearStorage(bytes32[] cleanCommits) external onlyOwner {
252         uint length = cleanCommits.length;
253 
254         for (uint i = 0; i < length; i++) {
255             Bet storage bet = bets[cleanCommits[i]];
256             clearProcessedBet(bet);
257         }
258     }
259 
260     function clearProcessedBet(Bet storage bet) private {
261 
262         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BET_EXPIRATION_BLOCKS) {
263             return;
264         }
265 
266         bet.amount = 0;
267         bet.roll = 0;
268         bet.placeBlockNumber = 0;
269         bet.player = address(0);
270     }
271 
272 
273     function safeSendFunds(address beneficiary, uint amount) private {
274         if (!beneficiary.send(amount)) {
275             playerPendingWithdrawals[beneficiary] = playerPendingWithdrawals[beneficiary].add(amount);
276 
277         }
278     }
279 
280 
281     function playerWithdrawPendingTransactions() public returns (bool) {
282         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
283         require(withdrawAmount > 0);
284         playerPendingWithdrawals[msg.sender] = 0;
285         if (msg.sender.call.value(withdrawAmount)()) {
286             return true;
287         } else {
288             playerPendingWithdrawals[msg.sender] = withdrawAmount;
289             return false;
290         }
291     }
292 
293     function pendingWithdrawalsBalance() public view returns (uint) {
294         return playerPendingWithdrawals[msg.sender];
295     }
296 
297     function houseWithdraw(uint amount) public onlyOwner {
298 
299         if (!owner.send(amount)) revert();
300 
301         emit LogHouseWithdraw(amount);
302     }
303 
304     function ownerkill() public onlyOwner {
305         selfdestruct(owner);
306     }
307 }