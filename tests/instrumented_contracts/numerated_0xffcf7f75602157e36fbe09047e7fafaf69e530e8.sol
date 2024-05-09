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
54     modifier onlyBanker {
55         if(banker[msg.sender] == false) revert();
56         _;
57     }
58 
59     uint constant BET_EXPIRATION_BLOCKS = 250;
60     uint constant public maxNumber = 96;
61     uint constant public minNumber = 2;
62     uint public maxProfit = 4 ether;
63     uint public maxPendingPayouts; //total unpaid
64     uint public minBet = 0.01 ether;
65     uint public pID = 160000;
66 
67 
68     struct Bet {
69 
70         uint amount;
71         uint40 placeBlockNumber;
72         uint8 roll;
73         bool lessThan;
74         address player;
75     }
76 
77     address public signer = 0x62fF37a452F8fc3A471a59127430C1bCFAeaf313;
78     address public owner;
79 
80     mapping(bytes32 => Bet) public bets;
81     mapping(address => uint) playerPendingWithdrawals;
82     mapping(address => uint) playerIdxAddr;
83     mapping(uint => address) playerAddrIdx;
84     mapping(address => bool) banker;
85 
86     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint BetValue, uint PlayerNumber, bool LessThan, uint256 Timestamp);
87     event LogResult(bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, bool LessThan, uint DiceResult, uint BetValue, uint Value, int Status, uint256 Timestamp);
88     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
89     event LogHouseWithdraw(uint indexed amount);
90     event BlockHashVerifyFailed(bytes32 commit);
91 
92     constructor() payable public {
93         owner = msg.sender;
94         playerIdxAddr[msg.sender] = pID;
95         playerAddrIdx[pID] = msg.sender;
96 
97     }
98 
99 
100     function setSecretSigner(address _signer) external onlyOwner {
101         signer = _signer;
102     }
103 
104     function setMinBet(uint _minBet) public onlyOwner {
105         minBet = _minBet;
106     }
107 
108     function addBankerAddress(address bankerAddress) public onlyOwner {
109         banker[bankerAddress] = true;
110     }
111 
112     function setInvite(address inviteAddress, uint inviteID, uint profit) public onlyOwner {
113         playerIdxAddr[inviteAddress] = inviteID;
114         playerAddrIdx[inviteID] = inviteAddress;
115         playerPendingWithdrawals[inviteAddress] = profit;
116     }
117 
118     function batchSetInvite(address[] inviteAddress, uint[] inviteID, uint[] profit) public onlyOwner {
119         uint length = inviteAddress.length;
120         for(uint i = 0;i< length; i++) {
121             setInvite(inviteAddress[i], inviteID[i], profit[i]);
122         }
123 
124     }
125 
126 
127     function getPlayerAddr(uint _pid) public view returns (address) {
128         return playerAddrIdx[_pid];
129     }
130 
131     function createInviteID(address _addr) public returns (bool) {
132         if (playerIdxAddr[_addr] == 0) {
133             pID++;
134             playerIdxAddr[_addr] = pID;
135             playerAddrIdx[pID] = _addr;
136             return true;
137         }
138         return false;
139     }
140 
141     function getPlayerId(address _addr) public view returns (uint){
142         return playerIdxAddr[_addr];
143     }
144 
145     function setMaxProfit(uint _maxProfit) public onlyOwner {
146         maxProfit = _maxProfit;
147     }
148 
149 
150     function() public payable {
151 
152     }
153 
154     function setOwner(address _owner) public onlyOwner {
155         owner = _owner;
156     }
157 
158     function placeBet(uint8 roll, bool lessThan, uint affID, uint lastBlock, bytes32 commit, uint8 v, bytes32 r, bytes32 s) public payable {
159         uint amount = msg.value;
160         require(amount >= minBet, "Amount is less than minimum bet size");
161         require(roll >= minNumber && roll <= maxNumber, "Place number should be with rang.");
162         require(block.number < lastBlock, "Commit has expired.");
163 
164         bytes32 signatureHash = keccak256(abi.encodePacked(lastBlock, commit));
165         require(signer == ecrecover(signatureHash, v, r, s), "ECDSA signature is not valid.");
166 
167         Bet storage bet = bets[commit];
168         require(bet.player == address(0x0));
169 
170 
171         uint possibleWinAmount = getDiceWinAmount(amount, roll, lessThan);
172 
173         require(possibleWinAmount <=  amount + maxProfit, "maxProfit limit violation.");
174 
175         maxPendingPayouts = maxPendingPayouts.add(possibleWinAmount);
176 
177         require(maxPendingPayouts  <=   address(this).balance, "insufficient contract balance for payout.");
178 
179 
180         bet.amount = amount;
181         bet.placeBlockNumber = uint40(block.number);
182         bet.roll = uint8(roll);
183         bet.lessThan = lessThan;
184         bet.player = msg.sender;
185 
186         emit LogBet(commit, msg.sender, amount, bet.roll, bet.lessThan, now);
187 
188         if (affID > 150000 && affID <= pID) {
189             address affAddress = playerAddrIdx[affID];
190             if(affAddress != address(0x0)) {
191                 playerPendingWithdrawals[affAddress] = playerPendingWithdrawals[affAddress].add(amount.div(100));
192             }
193         }
194 
195 
196     }
197 
198 
199     function getDiceWinAmount(uint amount, uint roll, bool lessThan) private pure returns (uint) {
200 
201         uint rollNumber = lessThan ? roll : 101 - roll;
202 
203         return amount * 98 / rollNumber;
204     }
205 
206     /**
207         refund user bet amount
208     */
209     function refundBet(bytes32 commit) external {
210 
211         Bet storage bet = bets[commit];
212         uint amount = bet.amount;
213         address player = bet.player;
214 
215         require(amount != 0);
216         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS);
217 
218         bet.amount = 0;
219         uint winAmount = getDiceWinAmount(amount, bet.roll, bet.lessThan);
220         maxPendingPayouts = maxPendingPayouts.sub(winAmount);
221 
222         safeSendFunds(player, amount);
223 
224     }
225 
226     function settleUncle(bytes32 reveal,bytes32 uncleHash) onlyBanker external {
227         bytes32 commit = keccak256(abi.encodePacked(reveal));
228 
229         Bet storage bet = bets[commit];
230 
231         settle(bet, reveal, uncleHash);
232     }
233 
234     function settleBet(bytes32 reveal,bytes32 blockHash) external {
235 
236 
237         bytes32 commit = keccak256(abi.encodePacked(reveal));
238 
239         Bet storage bet = bets[commit];
240 
241         uint placeBlockNumber = bet.placeBlockNumber;
242 
243         require(block.number > placeBlockNumber);
244         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS);
245 
246 
247         if(blockhash(placeBlockNumber) != blockHash) { //the place bet in uncle block
248             emit BlockHashVerifyFailed(commit);
249             return;
250         }
251 
252         settle(bet, reveal, blockHash);
253 
254     }
255 
256     function settle(Bet storage bet,bytes32 reveal,bytes32 blockHash) private {
257 
258         uint amount = bet.amount;
259         uint8 roll = bet.roll;
260         bool lessThan = bet.lessThan;
261         address player = bet.player;
262 
263         require(amount != 0);
264 
265 
266         bet.amount = 0;
267 
268         bytes32 seed = keccak256(abi.encodePacked(reveal, blockHash));
269 
270         uint dice = uint(seed) % 100 + 1;
271 
272         uint diceWinAmount = getDiceWinAmount(amount, roll, lessThan);
273 
274 
275         maxPendingPayouts = maxPendingPayouts.sub(diceWinAmount);
276 
277         uint diceWin = 0;
278 
279         if ((lessThan && dice <= roll) || (!lessThan && dice >= roll)){ //win
280             diceWin = diceWinAmount;
281             safeSendFunds(player, diceWin);
282         }
283 
284         bytes32 commit = keccak256(abi.encodePacked(reveal));
285 
286         emit LogResult(commit, player, roll,lessThan,  dice, amount, diceWin, diceWin == 0 ? 1 : 2, now);
287     }
288 
289     function safeSendFunds(address beneficiary, uint amount) private {
290         if (!beneficiary.send(amount)) {
291             playerPendingWithdrawals[beneficiary] = playerPendingWithdrawals[beneficiary].add(amount);
292 
293         }
294     }
295 
296 
297     function playerWithdrawPendingTransactions() public returns (bool) {
298         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
299         require(withdrawAmount > 0);
300         playerPendingWithdrawals[msg.sender] = 0;
301         if (msg.sender.call.value(withdrawAmount)()) {
302             return true;
303         } else {
304             playerPendingWithdrawals[msg.sender] = withdrawAmount;
305             return false;
306         }
307     }
308 
309     function pendingWithdrawalsBalance() public view returns (uint) {
310         return playerPendingWithdrawals[msg.sender];
311     }
312 
313     function inviteProfit(address _player) public view returns (uint) {
314         return playerPendingWithdrawals[_player];
315     }
316 
317 
318     function houseWithdraw(uint amount) public onlyOwner {
319 
320         if (!owner.send(amount)) revert();
321 
322         emit LogHouseWithdraw(amount);
323     }
324 
325     function ownerkill() public onlyOwner {
326         selfdestruct(owner);
327     }
328 
329 
330 
331 }