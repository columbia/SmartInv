1 pragma solidity ^0.4.9;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract RoundToken {
6 
7   string public constant name = "ROUND";
8   string public constant symbol = "ROUND";
9   uint8 public constant decimals = 18;
10   string public constant version = '0.1';
11   uint256 public constant totalSupply = 1000000000 * 1000000000000000000;
12 
13   address public owner;
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17   event NewOwner(address _newOwner);
18 
19   modifier checkIfToContract(address _to) {
20     if(_to != address(this))  {
21       _;
22     }
23   }
24 
25   mapping (address => uint256) balances;
26   mapping (address => mapping (address => uint256)) allowed;
27 
28   function RoundToken() {
29     owner = msg.sender;
30     balances[owner] = totalSupply;
31   }
32 
33   function replaceOwner(address _newOwner) returns (bool success) {
34     if (msg.sender != owner) throw;
35     owner = _newOwner;
36     NewOwner(_newOwner);
37     return true;
38   }
39 
40   function balanceOf(address _owner) constant returns (uint256 balance) {
41     return balances[_owner];
42   }
43 
44   function transfer(address _to, uint256 _value) checkIfToContract(_to) returns (bool success) {
45     if (balances[msg.sender] >= _value && _value > 0) {
46       balances[msg.sender] -= _value;
47       balances[_to] += _value;
48       Transfer(msg.sender, _to, _value);
49       return true;
50     } else {
51       return false;
52     }
53   }
54 
55   function transferFrom(address _from, address _to, uint256 _value) checkIfToContract(_to) returns (bool success) {
56     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57       balances[_to] += _value;
58       balances[_from] -= _value;
59       allowed[_from][msg.sender] -= _value;
60       Transfer(_from, _to, _value);
61       return true;
62     } else {
63       return false;
64     }
65   }
66 
67   function approve(address _spender, uint256 _value) returns (bool success) {
68     allowed[msg.sender][_spender] = _value;
69     Approval(msg.sender, _spender, _value);
70     return true;
71   }
72 
73   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
74     tokenRecipient spender = tokenRecipient(_spender);
75     if (approve(_spender, _value)) {
76       spender.receiveApproval(msg.sender, _value, this, _extraData);
77       return true;
78     }
79   }
80 
81   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84 }
85 
86 
87 contract Owned {
88   address public contractOwner;
89   address public pendingContractOwner;
90 
91   function Owned() {
92     contractOwner = msg.sender;
93   }
94 
95   modifier onlyContractOwner() {
96     if (contractOwner == msg.sender) _;
97   }
98 
99   function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
100     pendingContractOwner = _to;
101     return true;
102   }
103 
104   function claimContractOwnership() returns(bool) {
105     if (pendingContractOwner != msg.sender)
106       return false;
107     contractOwner = pendingContractOwner;
108     delete pendingContractOwner;
109     return true;
110   }
111 }
112 
113 contract BidGame is Owned {
114 
115   uint commissionPercent;
116   uint refundPenalty;
117   address gameOracleAddress;
118   address contractRoundTokenAddress;
119 
120   struct Game {
121     uint gameId;
122     uint state; //0 - new, 1 - started, 2XX- game completed;
123     string winnerUserName;
124     uint winnerUserId;
125     uint totalGameBid;
126 	uint bidAmt;
127     Bid[] bids;
128   }
129 
130   struct Bid {
131     address bidderAddress;
132     uint bid;
133     uint userId;
134     string userName;
135     bool refunded;
136   }
137 
138   mapping(uint => Game) games;
139 
140   // ---------------------------------------------------------------------------
141   // modifiers
142   modifier onlyGameOracle() {
143     if (gameOracleAddress == msg.sender) _;
144   }
145 
146   // ---------------------------------------------------------------------------
147   // events
148   event LogSender2(address log, address contractRoundToken);
149   event GameBidAccepted(address bidder, uint amount, uint gameId, uint userId, bytes userName, bool state);
150   event GameStarted(uint gameId);
151   event GameFinished(uint gameId, uint winnerUserId, string winnerUserName, uint winnersPayment, address winnerAddress);
152   event GameRefunded(uint gameId, uint refundUserId, uint refundPayment);
153 
154   // ---------------------------------------------------------------------------
155   // init settings
156   function setParams(uint _commissionPercent, uint _refundPenalty, address _gameOracleAddress, address _contractRoundTokenAddress) onlyContractOwner() {
157     commissionPercent = _commissionPercent;
158     refundPenalty = _refundPenalty;
159     gameOracleAddress = _gameOracleAddress;
160     contractRoundTokenAddress = _contractRoundTokenAddress;
161     LogSender2(msg.sender, contractRoundTokenAddress);
162   }
163 
164   // ---------------------------------------------------------------------------
165   // contact actions
166   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) {
167     uint i = bytesToUint2(bytes(_extraData));
168     uint _gameId = i/10000;
169     uint _userId = i - _gameId*10000;
170 
171 	//check game bid amount and force bidding the same amount of ROUNDs
172 	if (games[_gameId].gameId > 0){
173 		uint amountToBid = games[_gameId].bidAmt;
174 		for (uint k = 0; k < games[_gameId].bids.length; k++) {
175 			if(!games[_gameId].bids[k].refunded && _userId==games[_gameId].bids[k].userId) {
176 				amountToBid-=games[_gameId].bids[k].bid;
177 			}	
178 		}
179 		if(amountToBid>0)
180 			_value = amountToBid;
181 		else
182 			throw;
183     }
184 	
185     RoundToken token = RoundToken(contractRoundTokenAddress);
186     bool state = token.transferFrom(_from, gameOracleAddress, _value);
187 
188     if (!state) throw;
189 
190 	if (games[_gameId].gameId == 0){
191 		games[_gameId].bidAmt = _value;
192 		games[_gameId].gameId = _gameId;
193 	}
194 
195     games[_gameId].totalGameBid += _value;
196     games[_gameId].bids.push(Bid(_from, _value, _userId, '', false));
197 
198     GameBidAccepted(_from, _value, _gameId, _userId, '', state);
199   }
200 
201   function gameResult(uint _gameId, uint _userId) onlyGameOracle() {
202     if (games[_gameId].gameId == 0) throw;
203     if (games[_gameId].winnerUserId != 0) throw;
204     if (games[_gameId].totalGameBid == 0) throw;
205 
206     address winnerAddress;
207     uint commission = games[_gameId].totalGameBid*commissionPercent/100;
208     // if (commission < 1) commission = 1;
209     uint winnerAmount = games[_gameId].totalGameBid - commission;
210 
211     for (uint i = 0; i < games[_gameId].bids.length; i++) {
212       if(!games[_gameId].bids[i].refunded && _userId==games[_gameId].bids[i].userId) {
213         winnerAddress = games[_gameId].bids[i].bidderAddress;
214         break;
215       }
216     }
217 
218     if (winnerAddress == 0) throw;
219 
220     RoundToken token = RoundToken(contractRoundTokenAddress);
221     bool state = token.transferFrom(gameOracleAddress, winnerAddress, winnerAmount);
222 
223     if (!state) throw;
224 
225     games[_gameId].winnerUserId = _userId;
226     games[_gameId].state = 200;
227 
228     GameFinished(_gameId, _userId, '', winnerAmount, winnerAddress);
229   }
230 
231   function gameStart(uint _gameId) onlyGameOracle() {
232     if (games[_gameId].gameId == 0) throw;
233     if (games[_gameId].state != 0) throw;
234     games[_gameId].state = 1;
235     GameStarted(_gameId);
236   }
237 
238   function gameRefund(uint _gameId) onlyGameOracle() {
239     if (games[_gameId].gameId == 0) throw;
240     if (games[_gameId].winnerUserId != 0) throw;
241     if (games[_gameId].totalGameBid == 0) throw;
242 
243     for (uint i = 0; i < games[_gameId].bids.length; i++) {
244       if(!games[_gameId].bids[i].refunded) {
245         uint penalty = games[_gameId].bids[i].bid*refundPenalty/100;
246         // if (penalty < 1) penalty = 1;
247         uint refundAmount = games[_gameId].bids[i].bid - penalty;
248 
249         RoundToken token = RoundToken(contractRoundTokenAddress);
250         bool state = token.transferFrom(gameOracleAddress, games[_gameId].bids[i].bidderAddress, refundAmount);
251 
252         if (!state) throw;
253 
254         games[_gameId].bids[i].refunded = true;
255         games[_gameId].totalGameBid -= games[_gameId].bids[i].bid;
256         GameRefunded(_gameId, games[_gameId].bids[i].userId, refundAmount);
257       }
258     }
259   }
260 
261   function bidRefund(uint _gameId, uint _userId) onlyGameOracle() {
262     if (games[_gameId].gameId == 0) throw;
263     if (games[_gameId].winnerUserId != 0) throw;
264     if (games[_gameId].totalGameBid == 0) throw;
265     for (uint i = 0; i < games[_gameId].bids.length; i++) {
266       if(!games[_gameId].bids[i].refunded) {
267         if (games[_gameId].bids[i].userId == _userId) {
268           uint penalty = games[_gameId].bids[i].bid*refundPenalty/100;
269           // if (penalty < 1) penalty = 1;
270           uint refundAmount = games[_gameId].bids[i].bid - penalty;
271 
272           RoundToken token = RoundToken(contractRoundTokenAddress);
273           bool state = token.transferFrom(gameOracleAddress, games[_gameId].bids[i].bidderAddress, refundAmount);
274 
275           if (!state) throw;
276 
277           games[_gameId].bids[i].refunded = true;
278           games[_gameId].totalGameBid -= games[_gameId].bids[i].bid;
279           GameRefunded(_gameId, games[_gameId].bids[i].userId, refundAmount);
280         }
281       }
282     }
283   }
284 
285   // ---------------------------------------------------------------------------
286   // Get settings
287   function getSettings() constant returns(uint commission, uint penalty) {
288     return (
289       commissionPercent,
290       refundPenalty
291     );
292   }
293 
294   // ---------------------------------------------------------------------------
295   // Get game info
296   function getGame(uint _gameId) constant returns(uint gameId, uint state, uint winnerUserId, uint totalGameBid, uint bidAmt, uint bidsAmount) {
297     var game = games[_gameId];
298     return (
299       game.gameId,
300       game.state,
301       game.winnerUserId,
302       game.totalGameBid,
303 	  game.bidAmt,
304       game.bids.length
305     );
306   }
307 
308   // ---------------------------------------------------------------------------
309   // Get bid info
310   function getGameBid(uint _gameId, uint _bidId) constant returns(address bidderAddress, uint bidsAmount, uint userId, string userName, bool refunded) {
311     Game game = games[_gameId];
312     Bid bid=game.bids[_bidId];
313     return (
314       bid.bidderAddress,
315       bid.bid,
316       bid.userId,
317       bid.userName,
318       bid.refunded
319     );
320   }
321 
322   // ---------------------------------------------------------------------------
323   // Get balance of address
324   function getBalance(address _owner) constant returns (uint256 balance) {
325     RoundToken token = RoundToken(contractRoundTokenAddress);
326     return token.balanceOf(_owner);
327   }
328 
329   // ---------------------------------------------------------------------------
330   // kill contract
331   function kill() onlyContractOwner() {
332    if (msg.sender == contractOwner){
333       suicide(contractOwner);
334     }
335   }
336 
337   // ---------------------------------------------------------------------------
338   // utils
339   function bytesToUint2(bytes b) returns (uint) {
340     uint result = 0;
341     for (uint i=1; i < b.length; i++) {
342       uint x = uint(uint(b[i]));
343       if (x > 0)
344         x = x - 48;
345       result = result + x*(10**(b.length-i-1));
346     }
347     return result;
348   }
349 
350 }