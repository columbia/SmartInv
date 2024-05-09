1 pragma solidity ^0.5.7;
2 /**
3     INSTRUCTION:
4     Send more then or equal to [minPayment] or 0.01 ETH to one of Wallet Contract address
5     [wallet_0, wallet_1, wallet_2], after round end send to This contract 0 ETH
6     transaction and if you choise won, take your winnings.
7 
8     DAPP:     https://smartlottery.clab
9     BOT:      http://t.me/SmartLotteryGame_bot
10     LICENSE:  Under proprietary rights. All rights reserved.
11               Except <lib.SafeMath, cont.Ownable, lib.Address> under The MIT License (MIT)
12     AUTHOR:   http://t.me/pironmind
13 
14 */
15 
16 /**
17  * Utility library of inline functions on addresses
18  */
19 library Address {
20     function isContract(address account) internal view returns (bool) {
21         uint256 size;
22         assembly { size := extcodesize(account) }
23         return size > 0;
24     }
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error
30  */
31 library SafeMath {
32     function mul(uint256 a, uint256 b) external pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require(c / a == b);
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) external pure returns (uint256) {
42         require(b > 0);
43         uint256 c = a / b;
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) external pure returns (uint256) {
48         require(b <= a);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function add(uint256 a, uint256 b) external pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 /**
66  * Interface of Secure contract
67  */
68 interface ISecure {
69     function getRandomNumber(uint8 _limit, uint8 _totalPlayers, uint _games, uint _countTxs)
70     external
71     view
72     returns(uint);
73 
74     function checkTrasted() external payable returns(bool);
75 }
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100 
101     function isOwner() public view returns (bool) {
102         return msg.sender == _owner;
103     }
104 
105     function renounceOwnership() public onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     function transferOwnership(address newOwner) public onlyOwner {
111         _transferOwnership(newOwner);
112     }
113 
114     function _transferOwnership(address newOwner) internal {
115         require(newOwner != address(0));
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 /**
122  * @title Wallet
123  * @dev The Wallet contract is the payable contract with a term of life in a single round.
124  */
125 contract Wallet {
126     using Address for address;
127     using SafeMath for uint256;
128     using SafeMath for uint8;
129 
130     SmartLotteryGame public slg;
131 
132     uint256 private _totalRised;
133     uint8 private _players;
134     bool closedOut = false;
135     uint public gameId;
136     uint256 public minPaymnent;
137 
138     struct bet {
139         address wallet;
140         uint256 balance;
141     }
142 
143     mapping(uint8 => bet) public bets;
144 
145     modifier canAcceptPayment {
146         require(msg.value >= minPaymnent);
147         _;
148     }
149 
150     modifier canDoTrx() {
151         require(Address.isContract(msg.sender) != true);
152         _;
153     }
154 
155     modifier isClosedOut {
156         require(!closedOut);
157         _;
158     }
159 
160     modifier onlyCreator() {
161         require(msg.sender == address(slg));
162         _;
163     }
164 
165     constructor(uint _gameId, uint256 _minPayment) public {
166         slg = SmartLotteryGame(msg.sender);
167         gameId = _gameId;
168         minPaymnent = _minPayment;
169     }
170 
171     function totalPlayers() public view returns(uint8) {
172         return _players;
173     }
174 
175     function totalBets() public view returns(uint256) {
176         return _totalRised;
177     }
178 
179     function finishDay() external onlyCreator returns(uint256) {
180         uint256 balance = address(this).balance;
181         if (balance >= minPaymnent) {
182             slg.getFunds.value(balance)();
183             return balance;
184         } else {
185             return 0;
186         }
187     }
188 
189     function closeContract() external onlyCreator returns(bool) {
190         return closedOut = true;
191     }
192 
193     function addPlayer(uint8 _id, address _player, uint256 _amount)
194     internal
195     returns(bool) {
196         bets[_id].wallet = _player;
197         bets[_id].balance = _amount;
198         return true;
199     }
200 
201     function()
202     payable
203     canAcceptPayment
204     canDoTrx
205     isClosedOut
206     external {
207         _totalRised = _totalRised.add(msg.value);
208         _players = uint8((_players).add(1));
209         addPlayer(_players, msg.sender, msg.value);
210         slg.participate();
211     }
212 }
213 
214 contract SmartLotteryGame is Ownable {
215     using SafeMath for *;
216 
217     event Withdrawn(address indexed requestor, uint256 weiAmount);
218     event Deposited(address indexed payee, uint256 weiAmount);
219     event WinnerWallet(address indexed wallet, uint256 bank);
220 
221     address public secure;
222 
223     uint public games = 1;
224     uint256 public minPayment = 10**16;
225 
226     Wallet public wallet_0 = new Wallet(games, minPayment);
227     Wallet public wallet_1 = new Wallet(games, minPayment);
228     Wallet public wallet_2 = new Wallet(games, minPayment);
229 
230     uint256 public finishTime;
231     uint256 constant roundDuration = 86400;
232 
233     uint internal _nonceId = 0;
234     uint internal _maxPlayers = 100;
235     uint internal _tp = 0;
236     uint internal _winner;
237     uint8[] internal _particWallets = new uint8[](0);
238     uint256 internal _fund;
239     uint256 internal _commission;
240     uint256 internal _totalBetsWithoutCommission;
241 
242     mapping(uint => Wallet) public wallets;
243     mapping(address => uint256) private _deposits;
244 
245     struct wins{
246         address winner;
247         uint256 time;
248         address w0;
249         address w1;
250         address w2;
251     }
252 
253     struct bet {
254         address wallet;
255         uint256 balance;
256     }
257 
258     mapping(uint => wins) public gamesLog;
259 
260     modifier isReady() {
261         require(secure != address(0));
262         _;
263     }
264 
265     modifier onlyWallets() {
266         require(
267             msg.sender == address(wallet_0) ||
268             msg.sender == address(wallet_1) ||
269             msg.sender == address(wallet_2)
270         );
271         _;
272     }
273 
274     constructor() public {
275         wallets[0] = wallet_0;
276         wallets[1] = wallet_1;
277         wallets[2] = wallet_2;
278         finishTime = now.add(roundDuration);
279     }
280 
281     function _deposit(address payee, uint256 amount) internal {
282         _deposits[payee] = _deposits[payee].add(amount);
283         emit Deposited(payee, amount);
284     }
285 
286     function _raiseFunds() internal returns (uint256) {
287         _fund = _fund.add(wallet_0.finishDay());
288         _fund = _fund.add(wallet_1.finishDay());
289         return _fund.add(wallet_2.finishDay());
290     }
291 
292     function _winnerSelection() internal {
293         uint8 winner;
294         for(uint8 i=0; i<3; i++) {
295             if(wallets[i].totalPlayers() > 0) {
296                 _particWallets.push(i);
297             }
298         }
299         // random choose one of three wallets
300         winner = uint8(ISecure(secure)
301             .getRandomNumber(
302                 uint8(_particWallets.length),
303                 uint8(_tp),
304                 uint(games),
305                 _nonceId
306             ));
307 
308         _winner = _particWallets[winner];
309     }
310 
311     function _distribute() internal {
312         bet memory p;
313 
314         _tp = wallets[_winner].totalPlayers();
315         uint256 accommulDeposit = 0;
316         uint256 percents = 0;
317         uint256 onDeposit = 0;
318 
319         _commission = _fund.mul(15).div(100);
320         _totalBetsWithoutCommission = _fund.sub(_commission);
321 
322         for (uint8 i = 1; i <= _tp; i++) {
323             (p.wallet, p.balance) = wallets[_winner].bets(i);
324             percents = (p.balance)
325             .mul(10000)
326             .div(wallets[_winner].totalBets());
327             onDeposit = _totalBetsWithoutCommission
328             .mul(percents)
329             .div(10000);
330             accommulDeposit = accommulDeposit.add(onDeposit);
331             _deposit(p.wallet, onDeposit);
332         }
333         _deposit(owner(), _fund.sub(accommulDeposit));
334     }
335 
336     function _cleanState() internal {
337         _fund = 0;
338         _particWallets = new uint8[](0);
339     }
340 
341     function _log(address winner, uint256 fund) internal {
342         gamesLog[games].winner = winner;
343         gamesLog[games].time = now;
344         gamesLog[games].w0 = address(wallet_0);
345         gamesLog[games].w1 = address(wallet_1);
346         gamesLog[games].w2 = address(wallet_2);
347         emit WinnerWallet(winner, fund);
348     }
349 
350     function _paymentValidator(address _payee, uint256 _amount) internal {
351         if(_payee != address(wallet_0) &&
352         _payee != address(wallet_1) &&
353         _payee != address(wallet_2))
354         {
355             if(_amount == uint(0)) {
356                 if(depositOf(_payee) != uint(0)) {
357                     withdraw();
358                 } else {
359                     revert("You have zero balance");
360                 }
361             } else {
362                 revert("You can't do nonzero transaction");
363             }
364         }
365     }
366 
367     function _closeWallets() internal returns (bool) {
368         wallets[0].closeContract();
369         wallets[1].closeContract();
370         return wallets[2].closeContract();
371     }
372 
373     function _issueWallets() internal returns (bool) {
374         wallets[0] = wallet_0 = new Wallet(games, minPayment);
375         wallets[1] = wallet_1 = new Wallet(games, minPayment);
376         wallets[2] = wallet_2 = new Wallet(games, minPayment);
377         return true;
378     }
379 
380     function _switchWallets() internal {
381         if(_closeWallets()) {
382             _issueWallets();
383         } else { revert("break on switch");}
384     }
385 
386     function _totalPlayers() internal view returns(uint) {
387         return wallets[0].totalPlayers()
388         .add(wallets[1].totalPlayers())
389         .add(wallets[2].totalPlayers());
390     }
391 
392     function depositOf(address payee) public view returns (uint256) {
393         return _deposits[payee];
394     }
395 
396     function lastWinner() public view returns(address) {
397         return gamesLog[games].winner;
398     }
399 
400     function participate()
401     external
402     onlyWallets
403     isReady
404     {
405         _nonceId = _nonceId.add(1);
406         _tp = _totalPlayers();
407 
408         if (now >= finishTime && 1 == _tp) {
409             finishTime = now.add(roundDuration);
410             return;
411         }
412 
413         if (now >= finishTime || _tp >= _maxPlayers) {
414             // send all funds to this wallet
415             _fund = _raiseFunds();
416             // if it has participators
417             if(_fund > 0) {
418                 // get winner
419                 _winnerSelection();
420                 // do distribute
421                 _distribute();
422                 // log data
423                 _log(address(wallets[_winner]), _fund);
424                 // clear state
425                 _cleanState();
426                 // update round
427                 finishTime = now.add(roundDuration);
428                 // set next game
429                 games = games.add(1);
430                 // issue new wallets
431                 return _switchWallets();
432             }
433         }
434     }
435 
436     function setMinPayment(uint256 _value) public onlyOwner {
437         minPayment = _value;
438     }
439 
440     function setSecure(address _address) public onlyOwner returns (bool) {
441         secure = _address;
442         return true;
443     }
444 
445     function withdraw() public {
446         uint256 payment = _deposits[msg.sender];
447         _deposits[msg.sender] = 0;
448         msg.sender.transfer(payment);
449         emit Withdrawn(msg.sender, payment);
450     }
451 
452     function getFunds() public payable onlyWallets {}
453 
454     function() external payable {
455         _paymentValidator(msg.sender, msg.value);
456     }
457 }