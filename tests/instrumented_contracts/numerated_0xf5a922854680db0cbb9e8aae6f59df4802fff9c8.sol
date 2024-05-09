1 //  ___             _                         ___              _
2 // | _ )  _  _   __| |  __ _    __ __  ___   | _ \  ___   ___ | |_
3 // | _ \ | || | / _` | / _` |   \ V / (_-<   |  _/ / -_) (_-< |  _|
4 // |___/  \_,_| \__,_| \__,_|    \_/  /__/   |_|   \___| /__/  \__|
5 
6 // Buda vs Pest
7 // the most ridiculous Rock-Scissor-Paper game on Ethereum
8 // Copyright 2018 www.budapestgame.com
9 
10 
11 pragma solidity ^0.4.18;
12 
13 // File: contracts-raw/Ownable.sol
14 
15 contract Ownable {
16       address public        owner;
17 
18 
19         event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);
20 
21         function Ownable () public {
22                 owner       = msg.sender;
23         }
24 
25         modifier onlyOwner () {
26                 require (msg.sender == owner);
27                 _;
28         }
29 
30         function transferOwnership (address newOwner) public onlyOwner {
31               require (newOwner != address (0));
32 
33               OwnershipTransferred (owner, newOwner);
34               owner     = newOwner;
35         }
36 }
37 
38 // File: contracts-raw/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45         function add (uint256 a, uint256 b) internal pure returns (uint256) {
46               uint256   c = a + b;
47               assert (c >= a);
48               return c;
49         }
50 
51         function sub (uint256 a, uint256 b) internal pure returns (uint256) {
52               assert (b <= a);
53               return a - b;
54         }
55 
56         function mul (uint256 a, uint256 b) internal pure returns (uint256) {
57                 if (a == 0) {
58                         return 0;
59                 }
60                 uint256 c = a * b;
61                 assert (c/a == b);
62                 return c;
63         }
64 
65         // Solidty automatically throws
66         // function div (uint256 a, uint256 b) internal pure returns (uint256) {
67         //       // assert(b > 0); // Solidity automatically throws when dividing by 0
68         //       uint256   c = a/b;
69         //       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         //       return c;
71         // }
72 }
73 
74 // File: contracts-raw/StandardToken.sol
75 
76 // ERC20 is ERC20Basic
77 
78 
79 // ERC20 standard
80 contract ERC20 {
81         // Basic
82         function totalSupply () public view returns (uint256);
83         function balanceOf (address tokenOwner) public view returns (uint256);
84         function transfer (address to, uint256 amount) public returns (bool);
85         event Transfer (address indexed from, address indexed to, uint256 amount);
86 
87         // Additional
88         function allowance (address tokenOwner, address spender) public view returns (uint256);
89         function approve (address spender, uint256 amount) public returns (bool);
90         function transferFrom (address from, address to, uint256 amount) public returns (bool);
91         event Approval (address indexed tokenOwner, address indexed spender, uint256 amount);
92 }
93 
94 
95 // BasicToken is ERC20Basic
96 
97 contract StandardToken is ERC20 {
98         using SafeMath for uint256;
99 
100         // Basic
101         uint256                             _tokenTotal;
102         mapping (address => uint256)        _tokenBalances;
103 
104         function totalSupply () public view returns (uint256) {
105                 return _tokenTotal;
106         }
107 
108         function balanceOf (address tokenOwner) public view returns (uint256) {
109                 return _tokenBalances[tokenOwner];
110         }
111 
112         function _transfer (address to, uint256 amount) internal {
113                 // SafeMath.sub will throw if there is not enough balance.
114                 // SafeMath.add will throw if overflows
115                 _tokenBalances[msg.sender]      = _tokenBalances[msg.sender].sub (amount);
116                 _tokenBalances[to]              = _tokenBalances[to].add (amount);
117 
118                 Transfer (msg.sender, to, amount);
119         }
120 
121         function transfer (address to, uint256 amount) public returns (bool) {
122                 require (to != address (0));
123                 require (amount <= _tokenBalances[msg.sender]);     // should not be necessary, but double checks
124 
125                 _transfer (to, amount);
126                 return true;
127         }
128 
129 
130         // Additional
131         mapping (address => mapping (address => uint256)) internal  _tokenAllowance;
132 
133         function allowance (address tokenOwner, address spender) public view returns (uint256) {
134                 return _tokenAllowance[tokenOwner][spender];
135         }
136 
137         function approve (address spender, uint256 amount) public returns (bool) {
138                 _tokenAllowance[msg.sender][spender]   = amount;
139                 Approval (msg.sender, spender, amount);
140                 return true;
141         }
142 
143         function _transferFrom (address from, address to, uint256 amount) internal {
144                 // SafeMath.sub will throw if there is not enough balance.
145                 // SafeMath.add will throw if overflows
146                 _tokenBalances[from]    = _tokenBalances[from].sub (amount);
147                 _tokenBalances[to]      = _tokenBalances[to].add (amount);
148 
149                 Transfer (from, to, amount);
150         }
151 
152         function transferFrom (address from, address to, uint256 amount) public returns (bool) {
153                 require (to != address (0));
154                 require (amount <= _tokenBalances[from]);
155                 require (amount <= _tokenAllowance[from][msg.sender]);
156 
157                 _transferFrom (from, to, amount);
158 
159                 _tokenAllowance[from][msg.sender]     = _tokenAllowance[from][msg.sender].sub (amount);
160                 return true;
161         }
162 }
163 
164 // File: contracts-raw/RockScissorPaper.sol
165 
166 //  ___             _                         ___              _
167 // | _ )  _  _   __| |  __ _    __ __  ___   | _ \  ___   ___ | |_
168 // | _ \ | || | / _` | / _` |   \ V / (_-<   |  _/ / -_) (_-< |  _|
169 // |___/  \_,_| \__,_| \__,_|    \_/  /__/   |_|   \___| /__/  \__|
170 
171 // Buda vs Pest
172 // the most ridiculous Rock-Scissor-Paper game on Ethereum
173 // Copyright 2018 www.budapestgame.com
174 
175 pragma solidity ^0.4.18;
176 
177 
178 
179 
180 
181 contract RSPScienceInterface {
182 
183         function isRSPScience() public pure returns (bool);
184         function calcPoseBits (uint256 sek, uint256 posesek0, uint256 posesek1) public pure returns (uint256);
185 }
186 
187 
188 contract RockScissorPaper is StandardToken, Ownable {
189         using SafeMath for uint256;
190 
191         string public   name                = 'RockScissorPaper';
192         string public   symbol              = 'RSP';
193         uint8 public    decimals            = 18;
194 
195         uint8 public    version             = 7;
196 
197         // uint256 public  initialAmount        = 5 * 10**uint(decimals+6);
198 
199         RSPScienceInterface public      rspScience;
200 
201 
202         function _setRSPScienceAddress (address addr) internal {
203                 RSPScienceInterface     candidate   = RSPScienceInterface (addr);
204                 require (candidate.isRSPScience ());
205                 rspScience      = candidate;
206         }
207 
208         function setRSPScienceAddress (address addr) public onlyOwner {
209                 _setRSPScienceAddress (addr);
210         }
211 
212         // Constructor is not called multiple times, fortunately
213         function RockScissorPaper (address addr) public {
214                 // Onwer should be set up and become msg.sender
215                 // During test, mint owner some amount
216                 // During deployment, onwer himself has to buy tokens to be fair
217                 // _mint (msg.sender, initialAmount);
218 
219                 if (addr != address(0)) {
220                         _setRSPScienceAddress (addr);
221                 }
222         }
223 
224         function () public payable {
225                 revert ();
226         }
227 
228 
229         mapping (address => uint256) public         weiInvested;
230         mapping (address => uint256) public         weiRefunded;
231 
232         mapping (address => address) public         referrals;
233         mapping (address => uint256) public         nRefs;
234         mapping (address => uint256) public         weiFromRefs;
235 
236         event TokenInvest (address indexed purchaser, uint256 nWeis, uint256 nTokens, address referral);
237         event TokenRefund (address indexed purchaser, uint256 nWeis, uint256 nTokens);
238 
239         // Buying and selling incur minting and burning
240         function _mint (address tokenOwner, uint256 amount) internal {
241                 _tokenTotal                     = _tokenTotal.add (amount);
242                 _tokenBalances[tokenOwner]     += amount;   // no need to require, overflow already checked above
243 
244                 // Just emit a Transfer Event
245                 Transfer (address (0), tokenOwner, amount);
246         }
247 
248         function _burn (address tokenOwner, uint256 amount) internal {
249                 _tokenBalances[tokenOwner]  = _tokenBalances[tokenOwner].sub (amount);
250                 _tokenTotal                -= amount;       // no need to require, underflow already checked above
251 
252                 // Just emit a Transfer Event
253                 Transfer (tokenOwner, address (0), amount);
254         }
255 
256         // Only owner is allowed to do this
257         function mint (uint256 amount) onlyOwner public {
258                 _mint (msg.sender, amount);
259         }
260 
261 
262         function buyTokens (address referral) public payable {
263                 // minimum buys: 1 token
264                 uint256     amount      = msg.value.mul (5000);
265                 require (amount >= 1 * 10**uint(decimals));
266 
267                 // _processPurchase, _deliverTokens using Minting
268                 _mint (msg.sender, amount);
269 
270                 if ( referrals[msg.sender] == address(0) &&
271                      referral != msg.sender ) {
272                         if (referral == address(0)) {
273                                 referral    = owner;
274                         }
275 
276                         referrals[msg.sender]   = referral;
277                         nRefs[referral]        += 1;
278                 }
279 
280                 // Fund logs
281                 weiInvested[msg.sender]    += msg.value;
282                 TokenInvest (msg.sender, msg.value, amount, referral);
283         }
284 
285         function sellTokens (uint256 amount) public {
286                 _burn (msg.sender, amount);
287 
288                 // uint256     nWeis   = amount/rate * 0.9;
289                 uint256     nWeis   = amount / 5000;
290                 // gameBalance        -= nWeis;
291 
292                 // Fund logs
293                 weiRefunded[msg.sender]     += nWeis;
294                 TokenRefund (msg.sender, nWeis, amount);
295 
296                 msg.sender.transfer (nWeis);
297         }
298 
299 
300 
301         // Gamings
302         struct GameRSP {
303                 address         creator;
304                 uint256         creatorPose;
305                 // uint256
306                 uint256         nTokens;
307 
308                 address         player;
309                 uint256         playerPose;
310                 uint256         sek;
311                 uint256         posebits;
312         }
313 
314 
315         GameRSP[]   games;
316         // mapping (address => uint256) public         lastGameId;
317 
318         function totalGames () public view returns (uint256) {
319                 return games.length;
320         }
321 
322         function gameInfo (uint256 gameId) public view returns (address, uint256, uint256, address, uint256, uint256, uint256) {
323                 GameRSP storage     game    = games[gameId];
324 
325                 return (
326                     game.creator,
327                     game.creatorPose,
328                     game.nTokens,
329                     game.player,
330                     game.playerPose,
331                     game.sek,
332                     game.posebits
333                 );
334         }
335 
336 
337         uint8 public        ownerCut            = 5;                // 5 percent
338         uint8 public        referralCut         = 5;                // 5 percent
339         function changeFeeCut (uint8 ownCut, uint8 refCut) onlyOwner public {
340                 ownerCut        = ownCut;
341                 referralCut     = refCut;
342         }
343 
344 
345         event GameCreated (address indexed creator, uint256 gameId, uint256 pose);
346         event GamePlayed (address indexed player, uint256 gameId, uint256 pose);
347         event GameSolved (address indexed solver, uint256 gameId, uint256 posebits, address referral, uint256 solverFee);
348 
349         function createGame (uint256 amount, uint256 pose) public {
350                 // Will check tokenBalance of sender in transfer ()
351                 // require (_tokenBalances[msg.sender] >= amount && amount >= 100 * 10**uint(decimals));
352                 require (_tokenBalances[msg.sender] >= amount);
353 
354                 // We set 1 as the minimal token required, but 100 tokens probably is the minimum viable
355                 require (amount >= 1 * 10**uint(decimals));
356 
357 
358                 // escrew tokens;
359                 _transfer (this, amount);
360 
361                 GameRSP memory      game    = GameRSP ({
362                         creator:        msg.sender,
363                         creatorPose:    pose,
364                         nTokens:        amount,
365                         player:         address (0),
366                         playerPose:     0,
367                         sek:            0,
368                         posebits:       0
369                 });
370 
371                 uint256     gameId          = games.push (game) - 1;
372 
373                 // lastGameId[msg.sender]      = gameId;
374                 // Todo: Last GameId
375                 // Let's be absolutely sure array don't hit its limits
376                 require (gameId == uint256(uint32(gameId)));
377                 GameCreated (msg.sender, gameId, pose);
378         }
379 
380 
381         function playGame (uint256 gameId, uint256 pose) public {
382                 GameRSP storage     game    = games[gameId];
383 
384                 require (msg.sender != game.creator);
385                 require (game.player == address (0));
386 
387                 uint256     nTokens = game.nTokens;
388                 // Will check tokenBalance of sender in transfer ()
389                 require (_tokenBalances[msg.sender] >= nTokens);
390 
391                 // escrew tokens;
392                 _transfer (this, nTokens);
393 
394                 game.player         = msg.sender;
395                 game.playerPose     = pose;
396 
397                 GamePlayed (msg.sender, gameId, pose);
398         }
399 
400         // Convenience functions
401         function buyAndCreateGame (uint256 amount, uint256 pose, address referral) public payable {
402                 buyTokens (referral);
403                 createGame (amount, pose);
404         }
405 
406         function buyAndPlayGame (uint256 gameId, uint256 pose, address referral) public payable {
407                 buyTokens (referral);
408                 playGame (gameId, pose);
409         }
410 
411 
412         function _solveGame (uint256 gameId, uint256 sek, uint256 solFee) public {
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