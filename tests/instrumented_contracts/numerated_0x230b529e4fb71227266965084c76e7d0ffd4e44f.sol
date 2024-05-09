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
55 
56     uint constant public maxNumber = 96;
57     uint constant public minNumber = 2;
58     uint public maxProfit = 4 ether;
59     uint public maxPendingPayouts; //total unpaid
60     uint public minBet = 0.01 ether;
61     uint public pID = 150000;
62 
63 
64     struct Bet {
65 
66         uint amount;
67         uint40 placeBlockNumber;
68         uint8 roll;
69         bool lessThan;
70         bool isInvited;
71         address player;
72     }
73 
74     address public signer = 0x62fF37a452F8fc3A471a59127430C1bCFAeaf313;
75     address public owner;
76 
77     mapping(bytes32 => Bet) public bets;
78     mapping(address => uint) playerPendingWithdrawals;
79     mapping(address => uint) playerIdxAddr;
80     mapping(uint => address) playerAddrIdx;
81 
82     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint BetValue, uint PlayerNumber, bool LessThan, uint256 Timestamp);
83     event LogResult(bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, bool LessThan, uint DiceResult, uint BetValue, uint Value, int Status, uint256 Timestamp);
84     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
85     event LogHouseWithdraw(uint indexed amount);
86 
87     constructor() payable public {
88         owner = msg.sender;
89     }
90 
91     function setSecretSigner(address _signer) external onlyOwner {
92         signer = _signer;
93     }
94 
95     function setMinBet(uint _minBet) public onlyOwner {
96         minBet = _minBet;
97     }
98 
99 
100 
101 
102     function getPlayerAddr(uint _pid) public view returns (address) {
103         return playerAddrIdx[_pid];
104     }
105 
106     function createInviteID(address _addr) public returns (bool) {
107         if (playerIdxAddr[_addr] == 0) {
108             pID++;
109             playerIdxAddr[_addr] = pID;
110             playerAddrIdx[pID] = _addr;
111             return true;
112         }
113         return false;
114     }
115 
116     function getPlayerId(address _addr) public view returns (uint){
117         return playerIdxAddr[_addr];
118     }
119 
120     function setMaxProfit(uint _maxProfit) public onlyOwner {
121         maxProfit = _maxProfit;
122     }
123 
124 
125     function() public payable {
126 
127     }
128 
129     function setOwner(address _owner) public onlyOwner {
130         owner = _owner;
131     }
132 
133     function placeBet(uint8 roll, bool lessThan, uint affID, uint lastBlock, bytes32 commit, uint8 v, bytes32 r, bytes32 s) public payable {
134         uint amount = msg.value;
135         require(amount >= minBet, "Amount is less than minimum bet size");
136         require(roll >= minNumber && roll <= maxNumber, "Place number should be with rang.");
137         require(block.number < lastBlock, "Commit has expired.");
138 
139         bytes32 signatureHash = keccak256(abi.encodePacked(lastBlock, commit));
140         require(signer == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
141 
142         Bet storage bet = bets[commit];
143         require(bet.player == address(0x0));
144 
145         bool isInvited = affID > 150000 && affID <= pID;
146 
147         uint profit = getDiceWinAmount(amount, roll, lessThan, isInvited);
148 
149         require(profit <= amount + maxProfit, "maxProfit limit violation.");
150 
151         maxPendingPayouts = maxPendingPayouts.add(profit);
152 
153         require(maxPendingPayouts < address(this).balance, "insufficient contract balance for payout.");
154 
155 
156         bet.amount = amount;
157         bet.placeBlockNumber = uint40(block.number);
158         bet.roll = roll;
159         bet.lessThan = lessThan;
160         bet.isInvited = isInvited;
161         bet.player = msg.sender;
162 
163         emit LogBet(commit, msg.sender, amount, bet.roll, bet.lessThan, now);
164 
165         if (isInvited) {
166             address affAddress = playerAddrIdx[affID];
167             playerPendingWithdrawals[affAddress] = playerPendingWithdrawals[affAddress].add(amount.div(200));
168         }
169 
170 
171     }
172 
173 
174     function getDiceWinAmount(uint amount, uint roll, bool lessThan, bool isInvited) private pure returns (uint) {
175 
176         uint rollNumber = lessThan ? roll : 101 - roll;
177 
178         return amount * ((1000 - (isInvited ? 15 : 20)) - rollNumber * 10) / rollNumber / 10;
179     }
180 
181     /**
182         refund user bet amount
183     */
184     function refundBet(bytes32 commit) external {
185 
186         Bet storage bet = bets[commit];
187         uint amount = bet.amount;
188         address player = bet.player;
189         require(amount != 0, "Bet should be in an 'active' state");
190 
191         // Check that bet has already expired.
192         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
193 
194         // Move bet into 'processed' state, release funds.
195         bet.amount = 0;
196         uint profit = getDiceWinAmount(amount, bet.roll, bet.lessThan, bet.isInvited);
197         maxPendingPayouts = maxPendingPayouts.sub(profit);
198 
199         // Send the refund.
200         safeSendFunds(player, amount);
201 
202     }
203 
204 
205     function settleBet(bytes32 reveal, bytes32 blockHash) external {
206 
207 
208         bytes32 commit = keccak256(abi.encodePacked(reveal));
209 
210         Bet storage bet = bets[commit];
211 
212         //save gas
213         uint amount = bet.amount;
214         uint placeBlockNumber = bet.placeBlockNumber;
215         uint8 roll = bet.roll;
216         bool lessThan = bet.lessThan;
217         bool isInvited = bet.isInvited;
218         address player = bet.player;
219 
220         require(amount != 0);
221         require(block.number > placeBlockNumber);
222         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS);
223         require(blockhash(placeBlockNumber) == blockHash);
224 
225         bet.amount = 0;
226 
227         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(placeBlockNumber)));
228         uint dice = uint(entropy) % 100 + 1;
229 
230         uint diceWinAmount = getDiceWinAmount(amount, roll, lessThan, isInvited);
231 
232 
233         maxPendingPayouts = maxPendingPayouts.sub(diceWinAmount);
234 
235         uint diceWin = 0;
236 
237         if ((lessThan && dice <= roll) || (!lessThan && dice >= roll)){ //win
238             diceWin = amount.add(diceWinAmount);
239             safeSendFunds(player, diceWin);
240         }
241 
242 
243 
244         emit LogResult(commit, player, roll,lessThan,  dice, amount, diceWin, diceWin == 0 ? 1 : 2, now);
245 
246 
247 
248 
249 
250     }
251 
252     function clearStorage(bytes32[] cleanCommits) external onlyOwner {
253         uint length = cleanCommits.length;
254 
255         for (uint i = 0; i < length; i++) {
256             Bet storage bet = bets[cleanCommits[i]];
257             clearProcessedBet(bet);
258         }
259     }
260 
261     function clearProcessedBet(Bet storage bet) private {
262 
263         if (bet.amount != 0 || block.number <= bet.placeBlockNumber + BET_EXPIRATION_BLOCKS) {
264             return;
265         }
266 
267         bet.amount = 0;
268         bet.roll = 0;
269         bet.placeBlockNumber = 0;
270         bet.player = address(0);
271     }
272 
273 
274     function safeSendFunds(address beneficiary, uint amount) private {
275         if (!beneficiary.send(amount)) {
276             playerPendingWithdrawals[beneficiary] = playerPendingWithdrawals[beneficiary].add(amount);
277 
278         }
279     }
280 
281 
282     function playerWithdrawPendingTransactions() public returns (bool) {
283         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
284         require(withdrawAmount > 0);
285         playerPendingWithdrawals[msg.sender] = 0;
286         if (msg.sender.call.value(withdrawAmount)()) {
287             return true;
288         } else {
289             playerPendingWithdrawals[msg.sender] = withdrawAmount;
290             return false;
291         }
292     }
293 
294     function pendingWithdrawalsBalance() public view returns (uint) {
295         return playerPendingWithdrawals[msg.sender];
296     }
297 
298     function houseWithdraw(uint amount) public onlyOwner {
299 
300         if (!owner.send(amount)) revert();
301 
302         emit LogHouseWithdraw(amount);
303     }
304 
305     function ownerkill() public onlyOwner {
306         selfdestruct(owner);
307     }
308 }