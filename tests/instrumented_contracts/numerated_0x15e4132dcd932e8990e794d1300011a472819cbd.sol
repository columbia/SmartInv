1 // SPDX-License-Identifier: MIT
2 
3 /*     
4 
5     Golden Raito Per Liquidity
6     
7     Forked from Ampleforth: https://github.com/ampleforth/uFragments (Credits to Ampleforth team for implementation of rebasing on the ethereum network)
8     
9     GRPL 1.0 license
10     
11     GRPLToken.sol - GRPL ERC-20 Token
12   
13 */
14 
15 pragma solidity ^0.6.12;
16 
17 contract Ownable {
18 
19   address private _owner;
20   uint256 private _ownershipLocked;
21 
22   event OwnershipLocked(address lockedOwner);
23   event OwnershipRenounced(address indexed previousOwner);
24   event OwnershipTransferred(
25     address indexed previousOwner,
26     address indexed newOwner
27   );
28 
29 
30   constructor() public {
31     _owner = msg.sender;
32   _ownershipLocked = 0;
33   }
34 
35   function owner() public view returns(address) {
36     return _owner;
37   }
38 
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   function isOwner() public view returns(bool) {
45     return msg.sender == _owner;
46   }
47 
48   function transferOwnership(address newOwner) public onlyOwner {
49     _transferOwnership(newOwner);
50   }
51 
52   function _transferOwnership(address newOwner) internal {
53     require(_ownershipLocked == 0);
54     require(newOwner != address(0));
55     emit OwnershipTransferred(_owner, newOwner);
56     _owner = newOwner;
57   }
58   
59   // Set _ownershipLocked flag to lock contract owner forever
60   function lockOwnership() public onlyOwner {
61   require(_ownershipLocked == 0);
62   emit OwnershipLocked(_owner);
63     _ownershipLocked = 1;
64   }
65 
66 }
67 
68 library SafeMath {
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113 
114     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b != 0, errorMessage);
116         return a % b;
117     }
118 }
119 
120 /*
121 MIT License
122 
123 Copyright (c) 2018 requestnetwork
124 Copyright (c) 2018 Fragments, Inc.
125 
126 Permission is hereby granted, free of charge, to any person obtaining a copy
127 of this software and associated documentation files (the "Software"), to deal
128 in the Software without restriction, including without limitation the rights
129 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
130 copies of the Software, and to permit persons to whom the Software is
131 furnished to do so, subject to the following conditions:
132 
133 The above copyright notice and this permission notice shall be included in all
134 copies or substantial portions of the Software.
135 
136 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
137 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
138 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
139 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
140 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
141 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
142 SOFTWARE.
143 */
144 
145 library SafeMathInt {
146 
147     int256 private constant MIN_INT256 = int256(1) << 255;
148     int256 private constant MAX_INT256 = ~(int256(1) << 255);
149 
150     function mul(int256 a, int256 b)
151         internal
152         pure
153         returns (int256)
154     {
155         int256 c = a * b;
156 
157         // Detect overflow when multiplying MIN_INT256 with -1
158         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
159         require((b == 0) || (c / b == a));
160         return c;
161     }
162 
163     function div(int256 a, int256 b)
164         internal
165         pure
166         returns (int256)
167     {
168         // Prevent overflow when dividing MIN_INT256 by -1
169         require(b != -1 || a != MIN_INT256);
170 
171         // Solidity already throws when dividing by 0.
172         return a / b;
173     }
174 
175     function sub(int256 a, int256 b)
176         internal
177         pure
178         returns (int256)
179     {
180         int256 c = a - b;
181         require((b >= 0 && c <= a) || (b < 0 && c > a));
182         return c;
183     }
184 
185     function add(int256 a, int256 b)
186         internal
187         pure
188         returns (int256)
189     {
190         int256 c = a + b;
191         require((b >= 0 && c >= a) || (b < 0 && c < a));
192         return c;
193     }
194 
195     function abs(int256 a)
196         internal
197         pure
198         returns (int256)
199     {
200         require(a != MIN_INT256);
201         return a < 0 ? -a : a;
202     }
203 }
204 
205 interface IERC20 {
206 
207   function totalSupply() external view returns (uint256);
208 
209   function balanceOf(address who) external view returns (uint256);
210 
211   function allowance(address owner, address spender)
212     external view returns (uint256);
213 
214   function transfer(address to, uint256 value) external returns (bool);
215 
216   function approve(address spender, uint256 value)
217     external returns (bool);
218 
219   function transferFrom(address from, address to, uint256 value)
220     external returns (bool);
221 
222   event Transfer(
223     address indexed from,
224     address indexed to,
225     uint256 value
226   );
227 
228   event Approval(
229     address indexed owner,
230     address indexed spender,
231     uint256 value
232   );
233 }
234 
235 contract GRPLToken is Ownable, IERC20{
236 
237     //GRPL
238 
239     //Golden Raito Per Liquidity(GRPL) is a goldpegged defi protocol that is based on Ampleforths elastic tokensupply model. 
240     
241     //Grpl uses Fibonacci correction levels as a formula in the Rebase system(progammed inflation adjustment).
242     
243     using SafeMath for uint256;
244     using SafeMathInt for int256;
245 
246     event LogRebasePaused(bool paused);
247     event LogTokenPaused(bool paused);
248     
249     event Transfer(
250     address indexed from,
251     address indexed to,
252     uint256 value
253   );
254 
255   event Approval(
256     address indexed owner,
257     address indexed spender,
258     uint256 value
259   );
260 
261     event LogGRPLPolicyUpdated(address grplPolicy);
262 
263     // Used for authentication
264     address public grplPolicy;
265 
266     modifier onlyGRPLPolicy() {
267         require(msg.sender == grplPolicy);
268         _;
269     }
270 
271     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
272 
273     modifier validRecipient(address to) {
274         require(to != address(0x0));
275         require(to != address(this));
276         _;
277     }
278 
279      // Precautionary emergency controls.
280     bool public rebasePaused;
281     bool public tokenPaused;
282 
283     modifier whenRebaseNotPaused() {
284         require(!rebasePaused);
285         _;
286     }
287 
288     modifier whenTokenNotPaused() {
289         require(!tokenPaused);
290         _;
291     }
292     
293     string private _name;
294     string private _symbol;
295     uint8 private _decimals;
296 
297     uint256 private constant DECIMALS = 18;
298     uint256 private constant MAX_UINT256 = ~uint256(0);
299     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10 *10**6 * 10**DECIMALS; //10 million
300 
301     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
302     // Use the highest value that fits in a uint256 for max granularity.
303     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
304 
305     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
306     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
307   
308     uint256 private _epoch;
309 
310     uint256 private _totalSupply;
311     uint256 private _gonsPerFragment;
312     mapping(address => uint256) private _gonBalances;
313   
314     // This is denominated in Fragments, because the gons-fragments conversion might change before
315     // it's fully paid.
316     mapping (address => mapping (address => uint256)) private _allowedFragments;
317 
318     /**
319      * @param _grplPolicy The address of the GRPL  policy contract to use for authentication.
320      */
321     function setGGRPLPolicy(address _grplPolicy)
322         external
323         onlyOwner
324     {
325         grplPolicy = _grplPolicy;
326         emit LogGRPLPolicyUpdated(_grplPolicy);
327     }
328 
329     /**
330      * @dev Pauses or unpauses the execution of rebase operations.
331      * @param paused Pauses rebase operations if this is true.
332      */
333     function setRebasePaused(bool paused)
334         external
335         onlyOwner
336     {
337         rebasePaused = paused;
338         emit LogRebasePaused(paused);
339     }
340 
341     /**
342      * @dev Pauses or unpauses execution of ERC-20 transactions.
343      * @param paused Pauses ERC-20 transactions if this is true.
344      */
345     function setTokenPaused(bool paused)
346         external
347         onlyOwner
348     {
349         tokenPaused = paused;
350         emit LogTokenPaused(paused);
351     }
352     
353      /**
354      * @dev Notifies Fragments contract about a new rebase cycle.
355      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
356      * @return The total number of fragments after the supply adjustment.
357      */
358     function rebase(uint256 epoch, int256 supplyDelta)
359         external
360         onlyGRPLPolicy
361         returns (uint256)
362     {
363         if (supplyDelta == 0) {
364             emit LogRebase(epoch, _totalSupply);
365             return _totalSupply;
366         }
367 
368         if (supplyDelta < 0) {
369             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
370         } else {
371             _totalSupply = _totalSupply.add(uint256(supplyDelta));
372         }
373 
374         if (_totalSupply > MAX_SUPPLY) {
375             _totalSupply = MAX_SUPPLY;
376         }
377 
378         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
379 
380         emit LogRebase(epoch, _totalSupply);
381         return _totalSupply;
382     }
383 
384   constructor(address _grplPolicy) public {
385         _name = "GRPL";
386         _symbol = "GRPL";
387         _decimals = uint8(DECIMALS);
388 
389         rebasePaused = false;
390         tokenPaused = false;
391         
392         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
393         _gonBalances[msg.sender] = TOTAL_GONS;
394         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
395 
396         grplPolicy = _grplPolicy;
397 
398         emit Transfer(address(0x0), msg.sender, _totalSupply);
399     }
400     
401     function name() public view returns(string memory) {
402         return _name;
403     }
404 
405     function symbol() public view returns(string memory) {
406         return _symbol;
407     }
408 
409     function decimals() public view returns(uint8) {
410         return _decimals;
411     }
412   
413   /**
414      * @return The total number of fragments.
415      */
416     function totalSupply()  
417     public
418     override
419     view
420         returns (uint256)
421     {
422         return _totalSupply;
423     }
424   
425   /**
426      * @param who The address to query.
427      * @return The balance of the specified address.
428      */
429 
430     function balanceOf(address who)
431         public
432         override
433         view
434         returns (uint256)
435     {
436         return _gonBalances[who].div(_gonsPerFragment);
437     }
438 
439   /**
440      * @dev Transfer tokens to a specified address.
441      * @param to The address to transfer to.
442      * @param value The amount to be transferred.
443      * @return True on success, false otherwise.
444      */
445    
446     function transfer(address to, uint256 value)
447         public
448         override
449         whenTokenNotPaused
450         validRecipient(to)
451         returns (bool)
452     {
453         uint256 merValue = value.mul(_gonsPerFragment);
454         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);
455         _gonBalances[to] = _gonBalances[to].add(merValue);
456         emit Transfer(msg.sender, to, value);
457         return true;
458     }
459 
460   /**
461      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
462      * @param owner_ The address which owns the funds.
463      * @param spender The address which will spend the funds.
464      * @return The number of tokens still available for the spender.
465      */
466    
467     function allowance(address owner_, address spender)
468         public
469         override
470         view
471         returns (uint256)
472     {
473         return _allowedFragments[owner_][spender];
474     }
475   
476   /**
477      * @dev Transfer tokens from one address to another.
478      * @param from The address you want to send tokens from.
479      * @param to The address you want to transfer to.
480      * @param value The amount of tokens to be transferred.
481      */
482 
483     function transferFrom(address from, address to, uint256 value)
484         public
485         override
486         whenTokenNotPaused
487         validRecipient(to)
488         returns (bool)
489     {
490         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
491 
492         uint256 merValue = value.mul(_gonsPerFragment);
493         _gonBalances[from] = _gonBalances[from].sub(merValue);
494         _gonBalances[to] = _gonBalances[to].add(merValue);
495         emit Transfer(from, to, value);
496 
497         return true;
498     }
499   
500   /**
501      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
502      * msg.sender. This method is included for ERC20 compatibility.
503      * increaseAllowance and decreaseAllowance should be used instead.
504      * Changing an allowance with this method brings the risk that someone may transfer both
505      * the old and the new allowance - if they are both greater than zero - if a transfer
506      * transaction is mined before the later approve() call is mined.
507      *
508      * @param spender The address which will spend the funds.
509      * @param value The amount of tokens to be spent.
510      */
511 
512     function approve(address spender, uint256 value)
513         public
514         override
515         whenTokenNotPaused
516         returns (bool)
517     {
518         _allowedFragments[msg.sender][spender] = value;
519         emit Approval(msg.sender, spender, value);
520         return true;
521     }
522   
523   /**
524      * @dev Increase the amount of tokens that an owner has allowed to a spender.
525      * This method should be used instead of approve() to avoid the double approval vulnerability
526      * described above.
527      * @param spender The address which will spend the funds.
528      * @param addedValue The amount of tokens to increase the allowance by.
529      */
530 
531     function increaseAllowance(address spender, uint256 addedValue)
532         public
533         whenTokenNotPaused
534         returns (bool)
535     {
536         _allowedFragments[msg.sender][spender] =
537             _allowedFragments[msg.sender][spender].add(addedValue);
538         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
539         return true;
540     }
541   
542   /**
543      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
544      *
545      * @param spender The address which will spend the funds.
546      * @param subtractedValue The amount of tokens to decrease the allowance by.
547      */
548 
549     function decreaseAllowance(address spender, uint256 subtractedValue)
550         public
551         whenTokenNotPaused
552         returns (bool)
553     {
554         uint256 oldValue = _allowedFragments[msg.sender][spender];
555         if (subtractedValue >= oldValue) {
556             _allowedFragments[msg.sender][spender] = 0;
557         } else {
558             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
559         }
560         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
561         return true;
562     }
563 }