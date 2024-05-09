1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 /**
118  * @title SafeERC20
119  * @dev Wrappers around ERC20 operations that throw on failure.
120  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
121  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
122  */
123 library SafeERC20 {
124   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
125     assert(token.transfer(to, value));
126   }
127 
128   function safeTransferFrom(
129     ERC20 token,
130     address from,
131     address to,
132     uint256 value
133   )
134     internal
135   {
136     assert(token.transferFrom(from, to, value));
137   }
138 
139   function safeApprove(ERC20 token, address spender, uint256 value) internal {
140     assert(token.approve(spender, value));
141   }
142 }
143 
144 
145 /**
146  * @title Locker
147  * @notice Locker holds tokens and releases them at a certain time.
148  */
149 contract Locker is Ownable {
150   using SafeMath for uint;
151   using SafeERC20 for ERC20Basic;
152 
153   /**
154    * It is init state only when adding release info is possible.
155    * beneficiary only can release tokens when Locker is active.
156    * After all tokens are released, locker is drawn.
157    */
158   enum State { Init, Ready, Active, Drawn }
159 
160   struct Beneficiary {
161     uint ratio;             // ratio based on Locker's initial balance.
162     uint withdrawAmount;    // accumulated tokens beneficiary released
163     bool releaseAllTokens;
164   }
165 
166   /**
167    * @notice Release has info to release tokens.
168    * If lock type is straight, only two release infos is required.
169    *
170    *     |
171    * 100 |                _______________
172    *     |              _/
173    *  50 |            _/
174    *     |         . |
175    *     |       .   |
176    *     |     .     |
177    *     +===+=======+----*----------> time
178    *     Locker  First    Last
179    *  Activated  Release  Release
180    *
181    *
182    * If lock type is variable, the release graph will be
183    *
184    *     |
185    * 100 |                                 _________
186    *     |                                |
187    *  70 |                      __________|
188    *     |                     |
189    *  30 |            _________|
190    *     |           |
191    *     +===+=======+---------+----------*------> time
192    *     Locker   First        Second     Last
193    *  Activated   Release      Release    Release
194    *
195    *
196    *
197    * For the first straight release graph, parameters would be
198    *   coeff: 100
199    *   releaseTimes: [
200    *     first release time,
201    *     second release time
202    *   ]
203    *   releaseRatios: [
204    *     50,
205    *     100,
206    *   ]
207    *
208    * For the second variable release graph, parameters would be
209    *   coeff: 100
210    *   releaseTimes: [
211    *     first release time,
212    *     second release time,
213    *     last release time
214    *   ]
215    *   releaseRatios: [
216    *     30,
217    *     70,
218    *     100,
219    *   ]
220    *
221    */
222   struct Release {
223     bool isStraight;        // lock type : straight or variable
224     uint[] releaseTimes;    //
225     uint[] releaseRatios;   //
226   }
227 
228   uint public activeTime;
229 
230   // ERC20 basic token contract being held
231   ERC20Basic public token;
232 
233   uint public coeff;
234   uint public initialBalance;
235   uint public withdrawAmount; // total amount of tokens released
236 
237   mapping (address => Beneficiary) public beneficiaries;
238   mapping (address => Release) public releases;  // beneficiary's lock
239   mapping (address => bool) public locked; // whether beneficiary's lock is instantiated
240 
241   uint public numBeneficiaries;
242   uint public numLocks;
243 
244   State public state;
245 
246   modifier onlyState(State v) {
247     require(state == v);
248     _;
249   }
250 
251   modifier onlyBeneficiary(address _addr) {
252     require(beneficiaries[_addr].ratio > 0);
253     _;
254   }
255 
256   event StateChanged(State _state);
257   event Locked(address indexed _beneficiary, bool _isStraight);
258   event Released(address indexed _beneficiary, uint256 _amount);
259 
260   function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {
261     require(_token != address(0));
262     require(_beneficiaries.length == _ratios.length);
263 
264     token = ERC20Basic(_token);
265     coeff = _coeff;
266     numBeneficiaries = _beneficiaries.length;
267 
268     uint accRatio;
269 
270     for(uint i = 0; i < numBeneficiaries; i++) {
271       require(_ratios[i] > 0);
272       beneficiaries[_beneficiaries[i]].ratio = _ratios[i];
273 
274       accRatio = accRatio.add(_ratios[i]);
275     }
276 
277     require(coeff == accRatio);
278   }
279 
280   /**
281    * @notice beneficiary can release their tokens after activated
282    */
283   function activate() external onlyOwner onlyState(State.Ready) {
284     require(numLocks == numBeneficiaries); // double check : assert all releases are recorded
285 
286     initialBalance = token.balanceOf(this);
287     require(initialBalance > 0);
288 
289     activeTime = now; // solium-disable-line security/no-block-members
290 
291     // set locker as active state
292     state = State.Active;
293     emit StateChanged(state);
294   }
295 
296   function getReleaseType(address _beneficiary)
297     public
298     view
299     onlyBeneficiary(_beneficiary)
300     returns (bool)
301   {
302     return releases[_beneficiary].isStraight;
303   }
304 
305   function getTotalLockedAmounts(address _beneficiary)
306     public
307     view
308     onlyBeneficiary(_beneficiary)
309     returns (uint)
310   {
311     return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);
312   }
313 
314   function getReleaseTimes(address _beneficiary)
315     public
316     view
317     onlyBeneficiary(_beneficiary)
318     returns (uint[])
319   {
320     return releases[_beneficiary].releaseTimes;
321   }
322 
323   function getReleaseRatios(address _beneficiary)
324     public
325     view
326     onlyBeneficiary(_beneficiary)
327     returns (uint[])
328   {
329     return releases[_beneficiary].releaseRatios;
330   }
331 
332   /**
333    * @notice add new release record for beneficiary
334    */
335   function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)
336     external
337     onlyOwner
338     onlyState(State.Init)
339     onlyBeneficiary(_beneficiary)
340   {
341     require(!locked[_beneficiary]);
342     require(_releaseRatios.length != 0);
343     require(_releaseRatios.length == _releaseTimes.length);
344 
345     uint i;
346     uint len = _releaseRatios.length;
347 
348     // finally should release all tokens
349     require(_releaseRatios[len - 1] == coeff);
350 
351     // check two array are ascending sorted
352     for(i = 0; i < len - 1; i++) {
353       require(_releaseTimes[i] < _releaseTimes[i + 1]);
354       require(_releaseRatios[i] < _releaseRatios[i + 1]);
355     }
356 
357     // 2 release times for straight locking type
358     if (_isStraight) {
359       require(len == 2);
360     }
361 
362     numLocks = numLocks.add(1);
363 
364     // create Release for the beneficiary
365     releases[_beneficiary].isStraight = _isStraight;
366 
367     // copy array of uint
368     releases[_beneficiary].releaseTimes = _releaseTimes;
369     releases[_beneficiary].releaseRatios = _releaseRatios;
370 
371     // lock beneficiary
372     locked[_beneficiary] = true;
373     emit Locked(_beneficiary, _isStraight);
374 
375     //  if all beneficiaries locked, change Locker state to change
376     if (numLocks == numBeneficiaries) {
377       state = State.Ready;
378       emit StateChanged(state);
379     }
380   }
381 
382   /**
383    * @notice transfer releasable tokens for beneficiary wrt the release graph
384    */
385   function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {
386     require(!beneficiaries[msg.sender].releaseAllTokens);
387 
388     uint releasableAmount = getReleasableAmount(msg.sender);
389     beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);
390 
391     beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(
392       beneficiaries[msg.sender].ratio,
393       coeff,
394       initialBalance);
395 
396     withdrawAmount = withdrawAmount.add(releasableAmount);
397 
398     if (withdrawAmount == initialBalance) {
399       state = State.Drawn;
400       emit StateChanged(state);
401     }
402 
403     token.transfer(msg.sender, releasableAmount);
404     emit Released(msg.sender, releasableAmount);
405   }
406 
407   function getReleasableAmount(address _beneficiary) internal view returns (uint) {
408     if (releases[_beneficiary].isStraight) {
409       return getStraightReleasableAmount(_beneficiary);
410     } else {
411       return getVariableReleasableAmount(_beneficiary);
412     }
413   }
414 
415   /**
416    * @notice return releaseable amount for beneficiary in case of straight type of release
417    */
418   function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
419     Beneficiary memory _b = beneficiaries[_beneficiary];
420     Release memory _r = releases[_beneficiary];
421 
422     // total amount of tokens beneficiary can release
423     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
424 
425     uint firstTime = _r.releaseTimes[0];
426     uint lastTime = _r.releaseTimes[1];
427 
428     // solium-disable security/no-block-members
429     require(now >= firstTime); // pass if can release
430     // solium-enable security/no-block-members
431 
432     if(now >= lastTime) { // inclusive to reduce calculation
433       releasableAmount = totalReleasableAmount;
434     } else {
435       // releasable amount at first time
436       uint firstAmount = getPartialAmount(
437         _r.releaseRatios[0],
438         coeff,
439         totalReleasableAmount);
440 
441       // partial amount without first amount
442       releasableAmount = getPartialAmount(
443         now.sub(firstTime),
444         lastTime.sub(firstTime),
445         totalReleasableAmount.sub(firstAmount));
446       releasableAmount = releasableAmount.add(firstAmount);
447     }
448 
449     // subtract already withdrawn amounts
450     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
451   }
452 
453   /**
454    * @notice return releaseable amount for beneficiary in case of variable type of release
455    */
456   function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
457     Beneficiary memory _b = beneficiaries[_beneficiary];
458     Release memory _r = releases[_beneficiary];
459 
460     // total amount of tokens beneficiary will receive
461     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
462 
463     uint releaseRatio;
464 
465     // reverse order for short curcit
466     for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {
467       if (now >= _r.releaseTimes[i]) {
468         releaseRatio = _r.releaseRatios[i];
469         break;
470       }
471     }
472 
473     require(releaseRatio > 0);
474 
475     releasableAmount = getPartialAmount(
476       releaseRatio,
477       coeff,
478       totalReleasableAmount);
479     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
480   }
481 
482   /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497
483   /// @notice Calculates partial value given a numerator and denominator.
484   /// @param numerator Numerator.
485   /// @param denominator Denominator.
486   /// @param target Value to calculate partial of.
487   /// @return Partial value of target.
488   function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {
489     return numerator.mul(target).div(denominator);
490   }
491 }