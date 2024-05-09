1 pragma solidity ^0.5.13;
2 
3 interface RNGOracle {
4   function modulusRequest(uint256 _modulus, uint256 _betmask, bytes32 _seed, uint256 _callbackGasLimit) external returns (bytes32 queryId);
5   function queryWallet(address _user) external view returns (uint256);
6   // function addQueryBalance() external payable; (use this in the ABI to add balance)
7 }
8 
9 interface DDN {
10   function transfer(address _to, uint256 _tokens) external returns (bool);
11   function balanceOf(address _user) external view returns (uint256);
12   function dividendsOf(address _user) external view returns (uint256);
13   function buy() external payable returns (uint256);
14   function reinvest() external returns (uint256);
15 }
16 
17 interface PYRO {
18   function transfer(address _to, uint256 _tokens) external returns (bool);
19   function balanceOf(address _user) external view returns (uint256);
20 }
21 
22 contract WheelOfDDN {
23   using SafeMath for uint;
24 
25   // Modifiers
26   modifier noActiveBet(address _user) {
27     require(betStatus[_user] == false);
28     _;
29   }
30 
31   modifier gameActive() {
32     require(gamePaused == false);
33     _;
34   }
35 
36   modifier onlyAdmin() {
37     require(msg.sender == admin);
38     _;
39   }
40 
41   modifier autoReinvest() {
42     if (ddn.dividendsOf(address(this)) > 0.1 ether) {
43       reinvest();
44     }
45     _;
46   }
47 
48   // Events
49   event BetPlaced(address indexed player, bytes32 queryId);
50   event BetResolved(address indexed player, bytes32 indexed queryId, uint256 betAmount, uint256 roll, uint256 bracket, uint256 win, bool stakeBet, uint256 pyro);
51   event BetFailed(address indexed player, bytes32 indexed queryId, uint256 betAmount, bool stakeBet);
52   event Stake(address indexed player, uint256 tokens);
53   event Withdraw(address indexed player, uint256 tokens);
54 
55   address admin;
56   bool public gamePaused = false;
57 
58   uint8[10] brackets = [1, 3, 6, 12, 24, 40, 56, 68, 76, 80];
59 
60   uint256 constant internal constantFactor = 1e44;
61   uint256 internal globalFactor = 1e22;
62   uint256 internal nonStakeTokens;
63   uint256 internal CALLBACK_GAS_LIMIT = 300000;
64 
65   struct BetInfo {
66     address user;
67     uint256 tokens;
68     bool stakeBet;
69   }
70 
71   mapping(bytes32 => BetInfo) private betInfo;
72   mapping(address => uint256) internal personalFactorLedger_;
73   mapping(address => uint256) internal balanceLedger_;
74   mapping(address => bool) internal betStatus;
75   mapping(bytes32 => bool) internal queryStatus;
76   mapping(address => bytes32) internal lastQuery;
77 
78   DDN private ddn;
79   RNGOracle private oracle;
80   PYRO private pyro;
81 
82 
83   constructor(address _oracleAddress, address _DDN_address, address _PYRO_address)
84     public
85   {
86     admin = msg.sender;
87     oracle = RNGOracle(_oracleAddress);
88     ddn = DDN(_DDN_address);
89     pyro = PYRO(_PYRO_address);
90   }
91 
92 
93   function stake()
94     external
95     payable
96     autoReinvest
97     noActiveBet(msg.sender)
98   {
99     require(msg.value > 0);
100     _stake(msg.sender, ddn.buy.value(msg.value)());
101   }
102 
103   function placeBet()
104     external
105     payable
106     autoReinvest
107     noActiveBet(msg.sender)
108   {
109     require(msg.value > 0);
110     _initSpin(msg.sender, ddn.buy.value(msg.value)(), false);
111   }
112 
113 
114   function tokenCallback(address _from, uint256 _tokens, bytes calldata _data)
115     external
116     autoReinvest
117     noActiveBet(_from)
118     returns (bool)
119   {
120     require(msg.sender == address(ddn));
121     require(_tokens > 0);
122     if (_data.length == 0) {
123       _stake(_from, _tokens);
124     } else {
125       _initSpin(_from, _tokens, false);
126     }
127     return true;
128   }
129 
130 
131   function stakeSpin(uint256 _tokens)
132     external
133     autoReinvest
134     noActiveBet(msg.sender)
135   {
136     address _user = msg.sender;
137     require(stakeOf(_user) >= _tokens);
138     // User cannot bet more than 5% of available pool
139     if (_tokens > betPool(_user) / 20) {
140       _tokens = betPool(_user) / 20;
141     }
142     _initSpin(_user, _tokens, true);
143   }
144 
145 
146   function modulusCallback(bytes32 _queryId, uint256, uint256 _result)
147     external
148   {
149     require(msg.sender == address(oracle));
150     _executeSpin(_queryId, _result);
151   }
152 
153 
154   function queryFailed(bytes32 _queryId)
155     external
156   {
157     if (_queryId == bytes32(0x0)) {
158       _queryId = lastQuery[msg.sender];
159     } else {
160       require(msg.sender == address(oracle));
161     }
162     require(!queryStatus[_queryId]);
163     BetInfo memory _betInfo = betInfo[_queryId];
164     address _user = _betInfo.user;
165     uint256 _tokens = _betInfo.tokens;
166     bool _stakeBet = _betInfo.stakeBet;
167     require(betStatus[_user]);
168     if (!_stakeBet) {
169       nonStakeTokens = nonStakeTokens.sub(_tokens);
170       ddn.transfer(_user, _tokens);
171     }
172     betStatus[_user] = false;
173     queryStatus[_queryId] = true;
174     emit BetFailed(_user, _queryId, _tokens, _stakeBet);
175   }
176 
177 
178   function getBalance()
179     public
180     view
181     returns (uint256)
182   {
183     return ddn.balanceOf(address(this)) - nonStakeTokens;
184   }
185 
186 
187   function withdraw(uint256 _tokens)
188     public
189     autoReinvest
190     noActiveBet(msg.sender)
191   {
192     address _user = msg.sender;
193     uint256 _withdrawable = _tokens;
194     if (_withdrawable > stakeOf(_user)) {
195       _withdrawable = stakeOf(_user);
196     }
197     require(_withdrawable > 0);
198     ddn.transfer(_user, _withdrawable);
199     balanceLedger_[_user] = stakeOf(_user).sub(_withdrawable);
200     personalFactorLedger_[_user] = constantFactor / globalFactor;
201     emit Withdraw(_user, _withdrawable);
202   }
203 
204 
205   function withdrawAll()
206     external
207     noActiveBet(msg.sender)
208   {
209     withdraw(stakeOf(msg.sender));
210   }
211 
212 
213   function stakeOf(address _user)
214     public
215     view
216     returns (uint256)
217   {
218     // Balance ledger * personal factor * globalFactor / constantFactor
219     return balanceLedger_[_user].mul(personalFactorLedger_[_user]).mul(globalFactor) / constantFactor;
220   }
221 
222 
223   function betPool(address _user)
224     public
225     view
226     returns (uint256)
227   {
228     // Balance of contract minus balance of the user
229     return getBalance().sub(stakeOf(_user));
230   }
231 
232 
233   function allInfoFor(address _user) public view returns (uint256 bankroll, uint256 userQueryBalance, uint256 userBalance, uint256 userStake) {
234     return (getBalance(), oracle.queryWallet(_user), ddn.balanceOf(_user), stakeOf(_user));
235   }
236 
237 
238   // Internal Functions
239 
240 
241   function _stake(address _user, uint256 _amount)
242     internal
243     gameActive
244   {
245     balanceLedger_[_user] = stakeOf(_user).add(_amount);
246     personalFactorLedger_[_user] = constantFactor / globalFactor;
247     emit Stake(_user, _amount);
248   }
249 
250 
251   function _initSpin(address _user, uint256 _betAmount, bool _stakeSpin)
252     internal
253     gameActive
254   {
255     bytes32 _queryId = oracle.modulusRequest(80, 1, keccak256(abi.encodePacked(_user, block.number)), CALLBACK_GAS_LIMIT);
256     BetInfo memory _betInfo = BetInfo({
257       user: _user,
258       tokens: _betAmount,
259       stakeBet: _stakeSpin
260     });
261     betInfo[_queryId] = _betInfo;
262     emit BetPlaced(_user, _queryId);
263     if (!_stakeSpin) {
264       nonStakeTokens += _betAmount;
265     }
266     betStatus[_user] = true;
267     lastQuery[_user] = _queryId;
268   }
269 
270 
271   function _executeSpin(bytes32 _queryId, uint256 _result)
272     internal
273     gameActive
274   {
275     require(!queryStatus[_queryId]);
276     BetInfo memory _betInfo = betInfo[_queryId];
277     address _user = _betInfo.user;
278     uint256 _tokens = _betInfo.tokens;
279     bool _stakeBet = _betInfo.stakeBet;
280 
281     require(betStatus[_user]);
282 
283     uint256 _userStake = stakeOf(_user);
284 
285     // max bet is 5% of the stake (of everyone else)
286     // max win is 4x, 4x5 = 20% of the bankroll monkaS
287     require(betPool(_user) > 0);
288     if (_tokens > betPool(_user) / 20) {
289       _tokens = betPool(_user) / 20;
290     }
291 
292     if (_stakeBet) {
293       require(_tokens <= _userStake);
294     }
295 
296     uint256 _bracket;
297     uint256 _return;
298     (_bracket, _return) = _calculateReturn(_result, _tokens);
299 
300     if (_return > _tokens) {  // win
301       uint256 _won = _return - _tokens;
302       _houseLose(_user, _won);
303       if (_stakeBet) {
304         // scenario 1.1: stake bet win
305         personalFactorLedger_[_user] = constantFactor / globalFactor;
306         balanceLedger_[_user] = _userStake.add(_won);
307       } else {
308         // scenario 1.2: direct bet win
309         personalFactorLedger_[_user] = constantFactor / globalFactor;
310         balanceLedger_[_user] = _userStake; // user stake is unchanged despite global win
311         ddn.transfer(_user, _return);
312       }
313     } else {                 // lose
314       uint256 _lost = _tokens - _return;
315       _houseWin(_user, _lost);
316       if (_stakeBet) {
317         // scenario 2.1: stake bet lose
318         _userStake = _userStake.sub(_tokens);
319         _userStake = _userStake.add(_return);
320         balanceLedger_[_user] = _userStake;
321         personalFactorLedger_[_user] = constantFactor / globalFactor;
322       } else {
323         // scenario 2.2: direct bet lose
324         personalFactorLedger_[_user] = constantFactor / globalFactor;
325         balanceLedger_[_user] = _userStake; // user stake is unchanged despite global loss
326         if (_return > 0) {
327           ddn.transfer(_user, _return);
328         }
329       }
330     }
331 
332     if (!_stakeBet) {
333       nonStakeTokens = nonStakeTokens.sub(_betInfo.tokens);
334       if (_betInfo.tokens > _tokens) {
335         ddn.transfer(_user, _betInfo.tokens - _tokens);
336       }
337     }
338 
339     uint256 _userPyro = pyro.balanceOf(_user);
340     uint256 _bonusPyro = pyro.balanceOf(address(this));
341     uint256 _pyroReward = _return * 25; // 25:1 PYRO per DDN won
342     _pyroReward = _bonusPyro > _pyroReward ? _pyroReward : _bonusPyro;
343     if (_pyroReward > 0) {
344       pyro.transfer(_user, _pyroReward);
345       _pyroReward = pyro.balanceOf(_user).sub(_userPyro);
346     }
347 
348     betStatus[_user] = false;
349     queryStatus[_queryId] = true;
350     emit BetResolved(_user, _queryId, _tokens, _result, _bracket, _return, _stakeBet, _pyroReward);
351   }
352 
353 
354   function _calculateReturn(uint256 _result, uint256 _tokens)
355     internal
356     view
357     returns (uint256 bracket, uint256 win)
358   {
359     for (uint256 i = 0; i < brackets.length; i++) {
360       if (brackets[i] > _result) {
361         bracket = i;
362         break;
363       }
364     }
365     if (bracket == 0) { win = _tokens * 5; } // Grand Jackpot 5x
366     else if (bracket == 1) { win = _tokens * 3; } // Jackpot 3x
367     else if (bracket == 2) { win = _tokens * 2; } // Grand Prize 2x
368     else if (bracket == 3) { win = _tokens * 3 / 2; } // Major Prize 1.5x
369     else if (bracket == 4) { win = _tokens * 5 / 4; } // Minor Prize 1.25x
370     else if (bracket == 5) { win = _tokens * 21 / 20; } // Tiny Prize 1.05x
371     else if (bracket == 6) { win = _tokens * 4 / 5; } // Minor Loss 0.8x
372     else if (bracket == 7) { win = _tokens * 11 / 20; } // Major Loss 0.55x
373     else if (bracket == 8) { win = _tokens / 4; } // Grand Loss 0.25x
374     else { win = 0; } // Total Loss 0x
375   }
376 
377 
378   function _houseLose(address _user, uint256 _tokens)
379     internal
380   {
381     uint256 globalDecrease = globalFactor.mul(_tokens) / betPool(_user);
382     globalFactor = globalFactor.sub(globalDecrease);
383   }
384 
385 
386   function _houseWin(address _user, uint256 _tokens)
387     internal
388   {
389     uint256 globalIncrease = globalFactor.mul(_tokens) / betPool(_user);
390     globalFactor = globalFactor.add(globalIncrease);
391   }
392 
393 
394   function reinvest()
395     public
396   {
397     uint256 _tokens = ddn.reinvest();
398     // Increase amount of ddn everyone owns
399     uint256 globalIncrease = globalFactor.mul(_tokens) / getBalance();
400     globalFactor = globalFactor.add(globalIncrease);
401   }
402 
403 
404   // emergency  /  dev functions
405 
406 
407   /*
408     panicButton and refundUser are here incase of an emergency, or launch of a new contract
409     The game will be frozen, and all token holders will be refunded
410   */
411 
412   function setCallbackGas(uint256 _newLimit)
413     public
414     onlyAdmin
415   {
416     CALLBACK_GAS_LIMIT = _newLimit;
417   }
418 
419 
420   function panicButton()
421     public
422     onlyAdmin
423   {
424     if (gamePaused) {
425       gamePaused = false;
426     } else {
427       gamePaused = true;
428     }
429   }
430 
431 
432   function refundUser(address _user)
433     public
434     onlyAdmin
435   {
436     uint256 _tokens = stakeOf(_user);
437     if (_tokens > ddn.balanceOf(address(this))) {
438       _tokens = ddn.balanceOf(address(this));
439     }
440     balanceLedger_[_user] = balanceLedger_[_user].sub(_tokens);
441     personalFactorLedger_[_user] = constantFactor / globalFactor;
442     ddn.transfer(_user, _tokens);
443     emit Withdraw(_user, _tokens);
444   }
445 
446 
447   function withdrawAllPYRO()
448     public
449     onlyAdmin
450   {
451     pyro.transfer(address(0x0E7b52B895E3322eF341004DC6CB5C63e1d9b1c5), pyro.balanceOf(address(this)));
452   }
453 }
454 
455 /**
456  * @title SafeMath
457  * @dev Math operations with safety checks that throw on error
458  */
459 library SafeMath {
460 
461   /**
462   * @dev Multiplies two numbers, throws on overflow.
463   */
464   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
465     if (a == 0) {
466       return 0;
467     }
468     c = a * b;
469     assert(c / a == b);
470     return c;
471   }
472 
473   /**
474   * @dev Integer division of two numbers, truncating the quotient.
475   */
476   function div(uint256 a, uint256 b) internal pure returns (uint256) {
477     // assert(b > 0); // Solidity automatically throws when dividing by 0
478     // uint256 c = a / b;
479     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
480     return a / b;
481   }
482 
483   /**
484   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
485   */
486   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487     assert(b <= a);
488     return a - b;
489   }
490 
491   /**
492   * @dev Adds two numbers, throws on overflow.
493   */
494   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
495     c = a + b;
496     assert(c >= a);
497     return c;
498   }
499 }