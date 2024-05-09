1 // SPDX-License-Identifier: MIT
2 
3 /*
4 MIT License
5 
6 Copyright (c) 2018 requestnetwork
7 Copyright (c) 2018 Fragments, Inc.
8 Copyright (c) 2020 Rebased
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 The above copyright notice and this permission notice shall be included in all
18 copies or substantial portions of the Software.
19 
20 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26 SOFTWARE.
27 */
28 
29 pragma solidity 0.5.17;
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that revert on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, reverts on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (a == 0) {
45       return 0;
46     }
47 
48     uint256 c = a * b;
49     require(c / a == b);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b > 0); // Solidity only automatically asserts when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b <= a);
70     uint256 c = a - b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Adds two numbers, reverts on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     require(c >= a);
81 
82     return c;
83   }
84 
85   /**
86   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
87   * reverts when dividing by zero.
88   */
89   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90     require(b != 0);
91     return a % b;
92   }
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 interface IERC20 {
100   function totalSupply() external view returns (uint256);
101 
102   function balanceOf(address who) external view returns (uint256);
103 
104   function allowance(address owner, address spender)
105     external view returns (uint256);
106 
107   function transfer(address to, uint256 value) external returns (bool);
108 
109   function approve(address spender, uint256 value)
110     external returns (bool);
111 
112   function transferFrom(address from, address to, uint256 value)
113     external returns (bool);
114 
115   event Transfer(
116     address indexed from,
117     address indexed to,
118     uint256 value
119   );
120 
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 contract ERC20Detailed is IERC20 {
129     string private _name;
130     string private _symbol;
131     uint8 private _decimals;
132 
133     /**
134      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
135      * these values are immutable: they can only be set once during
136      * construction.
137      */
138     constructor (string memory name, string memory symbol, uint8 decimals) public {
139         _name = name;
140         _symbol = symbol;
141         _decimals = decimals;
142     }
143 
144     /**
145      * @dev Returns the name of the token.
146      */
147     function name() public view returns (string memory) {
148         return _name;
149     }
150 
151     /**
152      * @dev Returns the symbol of the token, usually a shorter version of the
153      * name.
154      */
155     function symbol() public view returns (string memory) {
156         return _symbol;
157     }
158 
159     /**
160      * @dev Returns the number of decimals used to get its user representation.
161      * For example, if `decimals` equals `2`, a balance of `505` tokens should
162      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
163      *
164      * Tokens usually opt for a value of 18, imitating the relationship between
165      * Ether and Wei.
166      *
167      * NOTE: This information is only used for _display_ purposes: it in
168      * no way affects any of the arithmetic of the contract, including
169      * {IERC20-balanceOf} and {IERC20-transfer}.
170      */
171     function decimals() public view returns (uint8) {
172         return _decimals;
173     }
174 }
175 
176 /**
177  * @title SafeMathInt
178  * @dev Math operations for int256 with overflow safety checks.
179  */
180 library SafeMathInt {
181     int256 private constant MIN_INT256 = int256(1) << 255;
182     int256 private constant MAX_INT256 = ~(int256(1) << 255);
183 
184     /**
185      * @dev Multiplies two int256 variables and fails on overflow.
186      */
187     function mul(int256 a, int256 b)
188         internal
189         pure
190         returns (int256)
191     {
192         int256 c = a * b;
193 
194         // Detect overflow when multiplying MIN_INT256 with -1
195         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
196         require((b == 0) || (c / b == a));
197         return c;
198     }
199 
200     /**
201      * @dev Division of two int256 variables and fails on overflow.
202      */
203     function div(int256 a, int256 b)
204         internal
205         pure
206         returns (int256)
207     {
208         // Prevent overflow when dividing MIN_INT256 by -1
209         require(b != -1 || a != MIN_INT256);
210 
211         // Solidity already throws when dividing by 0.
212         return a / b;
213     }
214 
215     /**
216      * @dev Subtracts two int256 variables and fails on overflow.
217      */
218     function sub(int256 a, int256 b)
219         internal
220         pure
221         returns (int256)
222     {
223         int256 c = a - b;
224         require((b >= 0 && c <= a) || (b < 0 && c > a));
225         return c;
226     }
227 
228     /**
229      * @dev Adds two int256 variables and fails on overflow.
230      */
231     function add(int256 a, int256 b)
232         internal
233         pure
234         returns (int256)
235     {
236         int256 c = a + b;
237         require((b >= 0 && c >= a) || (b < 0 && c < a));
238         return c;
239     }
240 
241     /**
242      * @dev Converts to absolute value, and fails on overflow.
243      */
244     function abs(int256 a)
245         internal
246         pure
247         returns (int256)
248     {
249         require(a != MIN_INT256);
250         return a < 0 ? -a : a;
251     }
252 }
253 
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address private _owner;
262 
263   event OwnershipRenounced(address indexed previousOwner);
264   
265   event OwnershipTransferred(
266     address indexed previousOwner,
267     address indexed newOwner
268   );
269 
270 
271   /**
272    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273    * account.
274    */
275   constructor() public {
276     _owner = msg.sender;
277   }
278 
279   /**
280    * @return the address of the owner.
281    */
282   function owner() public view returns(address) {
283     return _owner;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(isOwner());
291     _;
292   }
293 
294   /**
295    * @return true if `msg.sender` is the owner of the contract.
296    */
297   function isOwner() public view returns(bool) {
298     return msg.sender == _owner;
299   }
300 
301   /**
302    * @dev Allows the current owner to relinquish control of the contract.
303    * @notice Renouncing to ownership will leave the contract without an owner.
304    * It will not be possible to call the functions with the `onlyOwner`
305    * modifier anymore.
306    */
307   function renounceOwnership() public onlyOwner {
308     emit OwnershipRenounced(_owner);
309     _owner = address(0);
310   }
311 
312   /**
313    * @dev Allows the current owner to transfer control of the contract to a newOwner.
314    * @param newOwner The address to transfer ownership to.
315    */
316   function transferOwnership(address newOwner) public onlyOwner {
317     _transferOwnership(newOwner);
318   }
319 
320   /**
321    * @dev Transfers control of the contract to a newOwner.
322    * @param newOwner The address to transfer ownership to.
323    */
324   function _transferOwnership(address newOwner) internal {
325     require(newOwner != address(0));
326     emit OwnershipTransferred(_owner, newOwner);
327     _owner = newOwner;
328   }
329 }
330 
331 /**
332  * @title Rebased V2 ERC20 token
333  * @dev Rebased is based on the uFragments protocol first debuted by Ampleforth.
334  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
335  *      combining tokens proportionally across all wallets.
336  *
337  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
338  *      We support splitting the currency in expansion and combining the currency on contraction by
339  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
340  */
341 contract RebasedV2 is ERC20Detailed, Ownable {
342     using SafeMath for uint256;
343     using SafeMathInt for int256;
344 
345     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
346 
347     // Used for authentication
348     address public controller;
349 
350     modifier onlyController() {
351         require(msg.sender == controller);
352         _;
353     }
354 
355     modifier validRecipient(address to) {
356         require(to != address(0x0));
357         require(to != address(this));
358         _;
359     }
360 
361     uint256 private constant DECIMALS = 9;
362     uint256 private constant MAX_UINT256 = ~uint256(0);
363     uint256 private constant INITIAL_FRAGMENTS_SUPPLY =  2082412747493439;
364 
365     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
366     // Use the highest value that fits in a uint256 for max granularity.
367     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
368 
369     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
370     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
371 
372     uint256 private _totalSupply;
373     uint256 private _gonsPerFragment;
374     mapping(address => uint256) private _gonBalances;
375 
376     // This is denominated in Fragments, because the gons-fragments conversion might change before
377     // it's fully paid.
378     mapping (address => mapping (address => uint256)) private _allowedFragments;
379 
380     /**
381      * @dev Notifies Fragments contract about a new rebase cycle.
382      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
383      * @return The total number of fragments after the supply adjustment.
384      */
385     function rebase(uint256 epoch, int256 supplyDelta)
386         external
387         onlyController
388         returns (uint256)
389     {
390         if (supplyDelta == 0) {
391             emit LogRebase(epoch, _totalSupply);
392             return _totalSupply;
393         }
394 
395         if (supplyDelta < 0) {
396             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
397         } else {
398             _totalSupply = _totalSupply.add(uint256(supplyDelta));
399         }
400 
401         if (_totalSupply > MAX_SUPPLY) {
402             _totalSupply = MAX_SUPPLY;
403         }
404 
405         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
406 
407         emit LogRebase(epoch, _totalSupply);
408         return _totalSupply;
409     }
410 
411     constructor()
412         ERC20Detailed("Rebased v2", "REB2", uint8(DECIMALS))
413         public
414     {
415         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
416         _gonBalances[msg.sender] = TOTAL_GONS;
417         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
418         
419         emit Transfer(address(0x0), msg.sender, _totalSupply);
420     }
421 
422     /**
423      * @notice Sets a new controller
424      */
425     function setController(address _controller)
426         external
427         onlyOwner
428         returns (uint256)
429     {
430         controller = _controller;
431     }
432 
433 
434     /**
435      * @return The total number of fragments.
436      */
437     function totalSupply()
438         external
439         view
440         returns (uint256)
441     {
442         return _totalSupply;
443     }
444 
445     /**
446      * @param who The address to query.
447      * @return The balance of the specified address.
448      */
449     function balanceOf(address who)
450         external
451         view
452         returns (uint256)
453     {
454         return _gonBalances[who].div(_gonsPerFragment);
455     }
456 
457     /**
458      * @dev Transfer tokens to a specified address.
459      * @param to The address to transfer to.
460      * @param value The amount to be transferred.
461      * @return True on success, false otherwise.
462      */
463     function transfer(address to, uint256 value)
464         external
465         validRecipient(to)
466         returns (bool)
467     {
468         uint256 gonValue = value.mul(_gonsPerFragment);
469         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
470         _gonBalances[to] = _gonBalances[to].add(gonValue);
471         emit Transfer(msg.sender, to, value);
472         return true;
473     }
474 
475     /**
476      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
477      * @param owner_ The address which owns the funds.
478      * @param spender The address which will spend the funds.
479      * @return The number of tokens still available for the spender.
480      */
481     function allowance(address owner_, address spender)
482         external
483         view
484         returns (uint256)
485     {
486         return _allowedFragments[owner_][spender];
487     }
488 
489     /**
490      * @dev Transfer tokens from one address to another.
491      * @param from The address you want to send tokens from.
492      * @param to The address you want to transfer to.
493      * @param value The amount of tokens to be transferred.
494      */
495     function transferFrom(address from, address to, uint256 value)
496         external
497         validRecipient(to)
498         returns (bool)
499     {
500         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
501 
502         uint256 gonValue = value.mul(_gonsPerFragment);
503         _gonBalances[from] = _gonBalances[from].sub(gonValue);
504         _gonBalances[to] = _gonBalances[to].add(gonValue);
505         emit Transfer(from, to, value);
506 
507         return true;
508     }
509 
510     /**
511      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
512      * msg.sender. This method is included for ERC20 compatibility.
513      * increaseAllowance and decreaseAllowance should be used instead.
514      * Changing an allowance with this method brings the risk that someone may transfer both
515      * the old and the new allowance - if they are both greater than zero - if a transfer
516      * transaction is mined before the later approve() call is mined.
517      *
518      * @param spender The address which will spend the funds.
519      * @param value The amount of tokens to be spent.
520      */
521     function approve(address spender, uint256 value)
522         external
523         returns (bool)
524     {
525         _allowedFragments[msg.sender][spender] = value;
526         emit Approval(msg.sender, spender, value);
527         return true;
528     }
529 
530     /**
531      * @dev Increase the amount of tokens that an owner has allowed to a spender.
532      * This method should be used instead of approve() to avoid the double approval vulnerability
533      * described above.
534      * @param spender The address which will spend the funds.
535      * @param addedValue The amount of tokens to increase the allowance by.
536      */
537     function increaseAllowance(address spender, uint256 addedValue)
538         external
539         returns (bool)
540     {
541         _allowedFragments[msg.sender][spender] =
542             _allowedFragments[msg.sender][spender].add(addedValue);
543         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
544         return true;
545     }
546 
547     /**
548      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
549      *
550      * @param spender The address which will spend the funds.
551      * @param subtractedValue The amount of tokens to decrease the allowance by.
552      */
553     function decreaseAllowance(address spender, uint256 subtractedValue)
554         external
555         returns (bool)
556     {
557         uint256 oldValue = _allowedFragments[msg.sender][spender];
558         if (subtractedValue >= oldValue) {
559             _allowedFragments[msg.sender][spender] = 0;
560         } else {
561             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
562         }
563         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
564         return true;
565     }
566 }