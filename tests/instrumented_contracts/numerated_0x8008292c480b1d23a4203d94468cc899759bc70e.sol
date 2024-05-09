1 //  ___             _                         ___              _
2 // | _ )  _  _   __| |  __ _    __ __  ___   | _ \  ___   ___ | |_
3 // | _ \ | || | / _` | / _` |   \ V / (_-<   |  _/ / -_) (_-< |  _|
4 // |___/  \_,_| \__,_| \__,_|    \_/  /__/   |_|   \___| /__/  \__|
5 
6 // Buda vs Pest
7 // the most ridiculous Rock-Scissor-Paper game on Ethereum
8 // Copyright 2018 www.budapestgame.com
9 
10 pragma solidity ^0.4.18;
11 
12 // File: contracts-raw/Ownable.sol
13 
14 contract Ownable {
15       address public        owner;
16 
17 
18         event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);
19 
20         function Ownable () public {
21                 owner       = msg.sender;
22         }
23 
24         modifier onlyOwner () {
25                 require (msg.sender == owner);
26                 _;
27         }
28 
29         function transferOwnership (address newOwner) public onlyOwner {
30               require (newOwner != address (0));
31 
32               OwnershipTransferred (owner, newOwner);
33               owner     = newOwner;
34         }
35 }
36 
37 // File: contracts-raw/SafeMath.sol
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44         function add (uint256 a, uint256 b) internal pure returns (uint256) {
45               uint256   c = a + b;
46               assert (c >= a);
47               return c;
48         }
49 
50         function sub (uint256 a, uint256 b) internal pure returns (uint256) {
51               assert (b <= a);
52               return a - b;
53         }
54 
55         function mul (uint256 a, uint256 b) internal pure returns (uint256) {
56                 if (a == 0) {
57                         return 0;
58                 }
59                 uint256 c = a * b;
60                 assert (c/a == b);
61                 return c;
62         }
63 
64         // Solidty automatically throws
65         // function div (uint256 a, uint256 b) internal pure returns (uint256) {
66         //       // assert(b > 0); // Solidity automatically throws when dividing by 0
67         //       uint256   c = a/b;
68         //       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69         //       return c;
70         // }
71 }
72 
73 // File: contracts-raw/StandardToken.sol
74 
75 // ERC20 is ERC20Basic
76 
77 
78 // ERC20 standard
79 contract ERC20 {
80         // Basic
81         function totalSupply () public view returns (uint256);
82         function balanceOf (address tokenOwner) public view returns (uint256);
83         function transfer (address to, uint256 amount) public returns (bool);
84         event Transfer (address indexed from, address indexed to, uint256 amount);
85 
86         // Additional
87         function allowance (address tokenOwner, address spender) public view returns (uint256);
88         function approve (address spender, uint256 amount) public returns (bool);
89         function transferFrom (address from, address to, uint256 amount) public returns (bool);
90         event Approval (address indexed tokenOwner, address indexed spender, uint256 amount);
91 }
92 
93 
94 // BasicToken is ERC20Basic
95 
96 contract StandardToken is ERC20 {
97         using SafeMath for uint256;
98 
99         // Basic
100         uint256                             _tokenTotal;
101         mapping (address => uint256)        _tokenBalances;
102 
103         function totalSupply () public view returns (uint256) {
104                 return _tokenTotal;
105         }
106 
107         function balanceOf (address tokenOwner) public view returns (uint256) {
108                 return _tokenBalances[tokenOwner];
109         }
110 
111         function _transfer (address to, uint256 amount) internal {
112                 // SafeMath.sub will throw if there is not enough balance.
113                 // SafeMath.add will throw if overflows
114                 _tokenBalances[msg.sender]      = _tokenBalances[msg.sender].sub (amount);
115                 _tokenBalances[to]              = _tokenBalances[to].add (amount);
116 
117                 Transfer (msg.sender, to, amount);
118         }
119 
120         function transfer (address to, uint256 amount) public returns (bool) {
121                 require (to != address (0));
122                 require (amount <= _tokenBalances[msg.sender]);     // should not be necessary, but double checks
123 
124                 _transfer (to, amount);
125                 return true;
126         }
127 
128 
129         // Additional
130         mapping (address => mapping (address => uint256)) internal  _tokenAllowance;
131 
132         function allowance (address tokenOwner, address spender) public view returns (uint256) {
133                 return _tokenAllowance[tokenOwner][spender];
134         }
135 
136         function approve (address spender, uint256 amount) public returns (bool) {
137                 _tokenAllowance[msg.sender][spender]   = amount;
138                 Approval (msg.sender, spender, amount);
139                 return true;
140         }
141 
142         function _transferFrom (address from, address to, uint256 amount) internal {
143                 // SafeMath.sub will throw if there is not enough balance.
144                 // SafeMath.add will throw if overflows
145                 _tokenBalances[from]    = _tokenBalances[from].sub (amount);
146                 _tokenBalances[to]      = _tokenBalances[to].add (amount);
147 
148                 Transfer (from, to, amount);
149         }
150 
151         function transferFrom (address from, address to, uint256 amount) public returns (bool) {
152                 require (to != address (0));
153                 require (amount <= _tokenBalances[from]);
154                 require (amount <= _tokenAllowance[from][msg.sender]);
155 
156                 _transferFrom (from, to, amount);
157 
158                 _tokenAllowance[from][msg.sender]     = _tokenAllowance[from][msg.sender].sub (amount);
159                 return true;
160         }
161 }
162 
163 // File: contracts-raw/RockScissorPaper.sol
164 
165 //  ___             _                         ___              _
166 // | _ )  _  _   __| |  __ _    __ __  ___   | _ \  ___   ___ | |_
167 // | _ \ | || | / _` | / _` |   \ V / (_-<   |  _/ / -_) (_-< |  _|
168 // |___/  \_,_| \__,_| \__,_|    \_/  /__/   |_|   \___| /__/  \__|
169 
170 // Buda vs Pest
171 // the most ridiculous Rock-Scissor-Paper game on Ethereum
172 // Copyright 2018 www.budapestgame.com
173 
174 pragma solidity ^0.4.18;
175 
176 
177 
178 
179 
180 contract RSPScienceInterface {
181 
182         function isRSPScience() public pure returns (bool);
183         function calcPoseBits (uint256 sek, uint256 posesek0, uint256 posesek1) public pure returns (uint256);
184 }
185 
186 
187 contract RockScissorPaper is StandardToken, Ownable {
188         using SafeMath for uint256;
189 
190         string public   name                = 'RockScissorPaper';
191         string public   symbol              = 'RSP';
192         uint8 public    decimals            = 18;
193 
194         uint8 public    version             = 7;
195 
196         // uint256 public  initialAmount        = 5 * 10**uint(decimals+6);
197 
198         RSPScienceInterface public      rspScience;
199 
200 
201         function _setRSPScienceAddress (address addr) internal {
202                 RSPScienceInterface     candidate   = RSPScienceInterface (addr);
203                 require (candidate.isRSPScience ());
204                 rspScience      = candidate;
205         }
206 
207         function setRSPScienceAddress (address addr) public onlyOwner {
208                 _setRSPScienceAddress (addr);
209         }
210 
211         // Constructor is not called multiple times, fortunately
212         function RockScissorPaper (address addr) public {
213                 // Onwer should be set up and become msg.sender
214                 // During test, mint owner some amount
215                 // During deployment, onwer himself has to buy tokens to be fair
216                 // _mint (msg.sender, initialAmount);
217 
218                 if (addr != address(0)) {
219                         _setRSPScienceAddress (addr);
220                 }
221         }
222 
223         function () public payable {
224                 revert ();
225         }
226 
227 
228         mapping (address => uint256) public         weiInvested;
229         mapping (address => uint256) public         weiRefunded;
230 
231         mapping (address => address) public         referrals;
232         mapping (address => uint256) public         nRefs;
233         mapping (address => uint256) public         weiFromRefs;
234 
235         event TokenInvest (address indexed purchaser, uint256 nWeis, uint256 nTokens, address referral);
236         event TokenRefund (address indexed purchaser, uint256 nWeis, uint256 nTokens);
237 
238         // Buying and selling incur minting and burning
239         function _mint (address tokenOwner, uint256 amount) internal {
240                 _tokenTotal                     = _tokenTotal.add (amount);
241                 _tokenBalances[tokenOwner]     += amount;   // no need to require, overflow already checked above
242 
243                 // Just emit a Transfer Event
244                 Transfer (address (0), tokenOwner, amount);
245         }
246 
247         function _burn (address tokenOwner, uint256 amount) internal {
248                 _tokenBalances[tokenOwner]  = _tokenBalances[tokenOwner].sub (amount);
249                 _tokenTotal                -= amount;       // no need to require, underflow already checked above
250 
251                 // Just emit a Transfer Event
252                 Transfer (tokenOwner, address (0), amount);
253         }
254 
255         // Only owner is allowed to do this
256         function mint (uint256 amount) onlyOwner public {
257                 _mint (msg.sender, amount);
258         }
259 
260 
261         function buyTokens (address referral) public payable {
262                 // minimum buys: 1 token
263                 uint256     amount      = msg.value.mul (5000);
264                 require (amount >= 1 * 10**uint(decimals));
265 
266                 // _processPurchase, _deliverTokens using Minting
267                 _mint (msg.sender, amount);
268 
269                 if ( referrals[msg.sender] == address(0) &&
270                      referral != msg.sender ) {
271                         if (referral == address(0)) {
272                                 referral    = owner;
273                         }
274 
275                         referrals[msg.sender]   = referral;
276                         nRefs[referral]        += 1;
277                 }
278 
279                 // Fund logs
280                 weiInvested[msg.sender]    += msg.value;
281                 TokenInvest (msg.sender, msg.value, amount, referral);
282         }
283 
284         function sellTokens (uint256 amount) public {
285                 _burn (msg.sender, amount);
286 
287                 // uint256     nWeis   = amount/rate * 0.9;
288                 uint256     nWeis   = amount / 5000;
289                 // gameBalance        -= nWeis;
290 
291                 // Fund logs
292                 weiRefunded[msg.sender]     += nWeis;
293                 TokenRefund (msg.sender, nWeis, amount);
294 
295                 msg.sender.transfer (nWeis);
296         }
297 
298 
299 
300         // Gamings
301         struct GameRSP {
302                 address         creator;
303                 uint256         creatorPose;
304                 // uint256
305                 uint256         nTokens;
306 
307                 address         player;
308                 uint256         playerPose;
309                 uint256         sek;
310                 uint256         posebits;
311         }
312 
313 
314         GameRSP[]   games;
315         // mapping (address => uint256) public         lastGameId;
316 
317         function totalGames () public view returns (uint256) {
318                 return games.length;
319         }
320 
321         function gameInfo (uint256 gameId) public view returns (address, uint256, uint256, address, uint256, uint256, uint256) {
322                 GameRSP storage     game    = games[gameId];
323 
324                 return (
325                     game.creator,
326                     game.creatorPose,
327                     game.nTokens,
328                     game.player,
329                     game.playerPose,
330                     game.sek,
331                     game.posebits
332                 );
333         }
334 
335 
336         uint8 public        ownerCut            = 5;                // 5 percent
337         uint8 public        referralCut         = 5;                // 5 percent
338         function changeFeeCut (uint8 ownCut, uint8 refCut) onlyOwner public {
339                 ownerCut        = ownCut;
340                 referralCut     = refCut;
341         }
342 
343 
344         event GameCreated (address indexed creator, uint256 gameId, uint256 pose);
345         event GamePlayed (address indexed player, uint256 gameId, uint256 pose);
346         event GameSolved (address indexed solver, uint256 gameId, uint256 posebits, address referral, uint256 solverFee);
347 
348         function createGame (uint256 amount, uint256 pose) public {
349                 // Will check tokenBalance of sender in transfer ()
350                 // require (_tokenBalances[msg.sender] >= amount && amount >= 100 * 10**uint(decimals));
351                 require (_tokenBalances[msg.sender] >= amount);
352 
353                 // We set 1 as the minimal token required, but 100 tokens probably is the minimum viable
354                 require (amount >= 1 * 10**uint(decimals));
355 
356 
357                 // escrew tokens;
358                 _transfer (this, amount);
359 
360                 GameRSP memory      game    = GameRSP ({
361                         creator:        msg.sender,
362                         creatorPose:    pose,
363                         nTokens:        amount,
364                         player:         address (0),
365                         playerPose:     0,
366                         sek:            0,
367                         posebits:       0
368                 });
369 
370                 uint256     gameId          = games.push (game) - 1;
371 
372                 // lastGameId[msg.sender]      = gameId;
373                 // Todo: Last GameId
374                 // Let's be absolutely sure array don't hit its limits
375                 require (gameId == uint256(uint32(gameId)));
376                 GameCreated (msg.sender, gameId, pose);
377         }
378 
379 
380         function playGame (uint256 gameId, uint256 pose) public {
381                 GameRSP storage     game    = games[gameId];
382 
383                 require (msg.sender != game.creator);
384                 require (game.player == address (0));
385 
386                 uint256     nTokens = game.nTokens;
387                 // Will check tokenBalance of sender in transfer ()
388                 require (_tokenBalances[msg.sender] >= nTokens);
389 
390                 // escrew tokens;
391                 _transfer (this, nTokens);
392 
393                 game.player         = msg.sender;
394                 game.playerPose     = pose;
395 
396                 GamePlayed (msg.sender, gameId, pose);
397         }
398 
399         // Convenience functions
400         function buyAndCreateGame (uint256 amount, uint256 pose, address referral) public payable {
401                 buyTokens (referral);
402                 createGame (amount, pose);
403         }
404 
405         function buyAndPlayGame (uint256 gameId, uint256 pose, address referral) public payable {
406                 buyTokens (referral);
407                 playGame (gameId, pose);
408         }
409 
410 
411         // Bounty to eththrowaway4
412         function _solveGame (uint256 gameId, uint256 sek, uint256 solFee) internal {
413                 GameRSP storage     game    = games[gameId];
414 
415                 require (game.player != address (0));
416                 uint256     nTokens     = game.nTokens;
417 
418                 require (_tokenBalances[this] >= nTokens * 2);
419 
420                 uint256     ownerFee            = nTokens * 2 * ownerCut / 100;
421                 uint256     referralFee         = nTokens * 2 * referralCut / 100;
422                 uint256     winnerPrize         = nTokens * 2 - ownerFee - referralFee - solFee;
423                 uint256     drawPrize           = nTokens - solFee/2;
424 
425                 require (game.sek == 0 && sek != 0);
426                 game.sek        = sek;
427 
428                 address     referral;
429                 // Let's start solving the game
430                 uint256     posebits        = rspScience.calcPoseBits (sek, game.creatorPose, game.playerPose);
431 
432                 // RK, SC, PA,   RK, SC, PA
433                 // 1,  2,  4,    8,  16, 32
434                 if ((posebits % 9) == 0) {                                  // 9, 18 or 36
435                         require (drawPrize >= 0);
436 
437                         // draw (we don't take any fees - fair enough?)
438                         _transferFrom (this, game.creator, drawPrize);
439                         _transferFrom (this, game.player, drawPrize);
440                 }
441                 else if ((posebits % 17) == 0 || posebits == 12) {          // 12, 17, or 34
442                         require (winnerPrize >= 0);
443 
444                         referral            = referrals[game.creator];
445                         if (referral == address(0)) {
446                                 referral    = owner;
447                         }
448 
449                         // creator wins
450                         _transferFrom (this, game.creator, winnerPrize);
451                         _transferFrom (this, referral, referralFee);
452                         _transferFrom (this, owner, ownerFee);
453 
454                         weiFromRefs[referral]     += referralFee;
455                 }
456                 else if ((posebits % 10) == 0 || posebits == 33) {          // 10, 20, or 33
457                         require (winnerPrize >= 0);
458 
459                         referral            = referrals[game.player];
460                         if (referral == address(0)) {
461                                 referral    = owner;
462                         }
463 
464                         // player wins
465                         _transferFrom (this, game.player, winnerPrize);
466                         _transferFrom (this, referral, referralFee);
467                         _transferFrom (this, owner, ownerFee);
468 
469                         weiFromRefs[referral]     += referralFee;
470                 }
471 
472                 if (solFee > 0) {
473                         _transferFrom (this, msg.sender, solFee);
474                 }
475 
476                 game.posebits    = posebits;
477                 GameSolved (msg.sender, gameId, game.posebits, referral, solFee);
478         }
479 
480 
481 
482         // Anyone could call this to claim the prize (an pay gas himself)
483         function solveGame (uint256 gameId, uint256 sek) public {
484                 _solveGame (gameId, sek, 0);
485         }
486 
487         // Or the game could be automatically solved a few moments later by the owner,
488         // charging a 'solverFee'
489         function autoSolveGame (uint256 gameId, uint256 sek, uint256 solFee) onlyOwner public {
490                 _solveGame (gameId, sek, solFee);
491         }
492 
493 }