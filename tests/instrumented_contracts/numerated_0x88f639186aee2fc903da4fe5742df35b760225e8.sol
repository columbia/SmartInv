1 pragma solidity 0.5.0;
2 
3 contract Initializable {
4 
5   bool private initialized;
6   bool private initializing;
7 
8   modifier initializer() {
9     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
10 
11     bool wasInitializing = initializing;
12     initializing = true;
13     initialized = true;
14 
15     _;
16 
17     initializing = wasInitializing;
18   }
19 
20   function isConstructor() private view returns (bool) {
21     uint256 cs;
22     assembly { cs := extcodesize(address) }
23     return cs == 0;
24   }
25 
26   uint256[50] private ______gap;
27 }
28 
29 contract Ownable is Initializable {
30 
31   address private _owner;
32   uint256 private _ownershipLocked;
33 
34   event OwnershipLocked(address lockedOwner);
35   event OwnershipRenounced(address indexed previousOwner);
36   event OwnershipTransferred(
37     address indexed previousOwner,
38     address indexed newOwner
39   );
40 
41 
42   function initialize(address sender) internal initializer {
43     _owner = sender;
44 	_ownershipLocked = 0;
45   }
46 
47   function owner() public view returns(address) {
48     return _owner;
49   }
50 
51   modifier onlyOwner() {
52     require(isOwner());
53     _;
54   }
55 
56   function isOwner() public view returns(bool) {
57     return msg.sender == _owner;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     _transferOwnership(newOwner);
62   }
63 
64   function _transferOwnership(address newOwner) internal {
65     require(_ownershipLocked == 0);
66     require(newOwner != address(0));
67     emit OwnershipTransferred(_owner, newOwner);
68     _owner = newOwner;
69   }
70 
71   // Set _ownershipLocked flag to lock contract owner forever
72   function lockOwnership() public onlyOwner {
73 	require(_ownershipLocked == 0);
74 	emit OwnershipLocked(_owner);
75     _ownershipLocked = 1;
76   }
77 
78   uint256[50] private ______gap;
79 }
80 
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender)
87     external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92     external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 value
101   );
102 
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 contract ERC20Detailed is Initializable, IERC20 {
111   string private _name;
112   string private _symbol;
113   uint8 private _decimals;
114 
115   function initialize(string memory name, string memory symbol, uint8 decimals) internal initializer {
116     _name = name;
117     _symbol = symbol;
118     _decimals = decimals;
119   }
120 
121   function name() public view returns(string memory) {
122     return _name;
123   }
124 
125   function symbol() public view returns(string memory) {
126     return _symbol;
127   }
128 
129   function decimals() public view returns(uint8) {
130     return _decimals;
131   }
132 
133   uint256[50] private ______gap;
134 }
135 
136 library SafeMath {
137 
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170 
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174 
175         return c;
176     }
177 
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         return mod(a, b, "SafeMath: modulo by zero");
180     }
181 
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }
187 
188 /*
189 MIT License
190 Copyright (c) 2018 requestnetwork
191 Copyright (c) 2018 Fragments, Inc.
192 Permission is hereby granted, free of charge, to any person obtaining a copy
193 of this software and associated documentation files (the "Software"), to deal
194 in the Software without restriction, including without limitation the rights
195 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
196 copies of the Software, and to permit persons to whom the Software is
197 furnished to do so, subject to the following conditions:
198 The above copyright notice and this permission notice shall be included in all
199 copies or substantial portions of the Software.
200 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
201 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
202 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
203 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
204 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
205 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
206 SOFTWARE.
207 */
208 
209 
210 library SafeMathInt {
211 
212     int256 private constant MIN_INT256 = int256(1) << 255;
213     int256 private constant MAX_INT256 = ~(int256(1) << 255);
214 
215     function mul(int256 a, int256 b)
216         internal
217         pure
218         returns (int256)
219     {
220         int256 c = a * b;
221 
222         // Detect overflow when multiplying MIN_INT256 with -1
223         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
224         require((b == 0) || (c / b == a));
225         return c;
226     }
227 
228     function div(int256 a, int256 b)
229         internal
230         pure
231         returns (int256)
232     {
233         // Prevent overflow when dividing MIN_INT256 by -1
234         require(b != -1 || a != MIN_INT256);
235 
236         // Solidity already throws when dividing by 0.
237         return a / b;
238     }
239 
240     function sub(int256 a, int256 b)
241         internal
242         pure
243         returns (int256)
244     {
245         int256 c = a - b;
246         require((b >= 0 && c <= a) || (b < 0 && c > a));
247         return c;
248     }
249 
250     function add(int256 a, int256 b)
251         internal
252         pure
253         returns (int256)
254     {
255         int256 c = a + b;
256         require((b >= 0 && c >= a) || (b < 0 && c < a));
257         return c;
258     }
259 
260     function abs(int256 a)
261         internal
262         pure
263         returns (int256)
264     {
265         require(a != MIN_INT256);
266         return a < 0 ? -a : a;
267     }
268 }
269 
270 library UInt256Lib {
271 
272     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
273 
274     /**
275      * @dev Safely converts a uint256 to an int256.
276      */
277     function toInt256Safe(uint256 a)
278         internal
279         pure
280         returns (int256)
281     {
282         require(a <= MAX_INT256);
283         return int256(a);
284     }
285 }
286 
287 contract ESTAKE is Ownable, ERC20Detailed {
288 
289 
290 
291 
292     using SafeMath for uint256;
293     using SafeMathInt for int256;
294 	using UInt256Lib for uint256;
295 
296 	struct Transaction {
297         bool enabled;
298         address destination;
299         bytes data;
300     }
301 
302 
303     event TransactionFailed(address indexed destination, uint index, bytes data);
304 
305 	// Stable ordering is not guaranteed.
306 
307     Transaction[] public transactions;
308 
309 
310     modifier validRecipient(address to) {
311         require(to != address(0x0));
312         require(to != address(this));
313         _;
314     }
315 
316     uint256 public constant DECIMALS = 9;
317     uint256 public constant MAX_UINT256 = ~uint256(0);
318     uint256 public constant INITIAL_SUPPLY = 121 * 10**4 * 10**DECIMALS;
319     address public Distributor;
320 
321 
322     uint256 public _totalSupply;
323     uint256 public _currentPrice;
324     uint256 public _targetPrice;
325     uint256  public _userLength;
326 
327     mapping(address => uint256) public _updatedBalance;
328 	mapping(address => bool) userStatus;
329 	mapping(uint => address) public idByAddress;
330 
331     mapping (address => mapping (address => uint256)) public _allowance;
332 
333 	constructor() public {
334 
335 		Ownable.initialize(msg.sender);
336 		ERC20Detailed.initialize("Elastic Staking", "EStake", uint8(DECIMALS));
337 
338         _totalSupply = INITIAL_SUPPLY;
339         _updatedBalance[msg.sender] = _totalSupply;
340 
341         _userLength++;
342         idByAddress[_userLength] = msg.sender;
343 
344         emit Transfer(address(0x0), msg.sender, _totalSupply);
345     }
346 
347 
348     modifier onlyDistributor() {
349         require(msg.sender == Distributor, "Only Distributor");
350         _;
351     }
352 
353 	/**
354      * @return The total number of fragments.
355      */
356 
357     function totalSupply()
358         public
359         view
360         returns (uint256)
361     {
362         return _totalSupply;
363     }
364 
365 	/**
366      * @param who The address to query.
367      * @return The balance of the specified address.
368      */
369 
370     function balanceOf(address who)
371         public
372         view
373         returns (uint256)
374     {
375         return _updatedBalance[who];
376     }
377 
378 	/**
379      * @dev Transfer tokens to a specified address.
380      * @param to The address to transfer to.
381      * @param value The amount to be transferred.
382      * @return True on success, false otherwise.
383      */
384 
385     function transfer(address to, uint256 value)
386         public
387         validRecipient(to)
388         returns (bool)
389     {
390         if(!userStatus[to]){
391             userStatus[to] = true;
392             _userLength++;
393             idByAddress[_userLength] = to;
394         }
395 
396         _updatedBalance[msg.sender] = _updatedBalance[msg.sender].sub(value);
397         _updatedBalance[to] = _updatedBalance[to].add(value);
398 
399         emit Transfer(msg.sender, to, value);
400         return true;
401     }
402 
403 	/**
404      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
405      * @param owner_ The address which owns the funds.
406      * @param spender The address which will spend the funds.
407      * @return The number of tokens still available for the spender.
408      */
409 
410     function allowance(address owner_, address spender)
411         public
412         view
413         returns (uint256)
414     {
415         return _allowance[owner_][spender];
416     }
417 
418 	/**
419      * @dev Transfer tokens from one address to another.
420      * @param from The address you want to send tokens from.
421      * @param to The address you want to transfer to.
422      * @param value The amount of tokens to be transferred.
423      */
424 
425     function transferFrom(address from, address to, uint256 value)
426         public
427         validRecipient(to)
428         returns (bool)
429     {
430         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);
431 
432         if(!userStatus[to]){
433             userStatus[to] = true;
434             _userLength++;
435              idByAddress[_userLength] = to;
436         }
437 
438         _updatedBalance[from] = _updatedBalance[from].sub(value);
439 
440         _updatedBalance[to] = _updatedBalance[to].add(value);
441 
442         emit Transfer(from, to, value);
443 
444         return true;
445     }
446 
447 
448 	/**
449      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
450      * msg.sender. This method is included for ERC20 compatibility.
451      * increaseAllowance and decreaseAllowance should be used instead.
452      * Changing an allowance with this method brings the risk that someone may transfer both
453      * the old and the new allowance - if they are both greater than zero - if a transfer
454      * transaction is mined before the later approve() call is mined.
455      *
456      * @param spender The address which will spend the funds.
457      * @param value The amount of tokens to be spent.
458      */
459 
460     function approve(address spender, uint256 value)
461         public
462         returns (bool)
463     {
464         _allowance[msg.sender][spender] = value;
465         emit Approval(msg.sender, spender, value);
466         return true;
467     }
468 
469 	/**
470      * @dev Increase the amount of tokens that an owner has allowed to a spender.
471      * This method should be used instead of approve() to avoid the double approval vulnerability
472      * described above.
473      * @param spender The address which will spend the funds.
474      * @param addedValue The amount of tokens to increase the allowance by.
475      */
476 
477     function increaseAllowance(address spender, uint256 addedValue)
478         public
479         returns (bool)
480     {
481         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(addedValue);
482         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
483         return true;
484     }
485 
486 	/**
487      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
488      *
489      * @param spender The address which will spend the funds.
490      * @param subtractedValue The amount of tokens to decrease the allowance by.
491      */
492 
493     function decreaseAllowance(address spender, uint256 subtractedValue)
494         public
495         returns (bool)
496     {
497         uint256 oldValue = _allowance[msg.sender][spender];
498         if (subtractedValue >= oldValue) {
499             _allowance[msg.sender][spender] = 0;
500         } else {
501             _allowance[msg.sender][spender] = oldValue.sub(subtractedValue);
502         }
503         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
504         return true;
505     }
506 
507     /* only distribtor can access the following functions. These functions will be used by distribution contract to distribute the rewards
508       to users based on the equation R = (ax + by)*userblance
509     */
510 
511     function setUserBalance(address _user, uint256 _balance) public onlyDistributor {
512         _updatedBalance[_user] = _balance;
513     }
514 
515     function setTotalSupply(uint256 _supply) public onlyDistributor {
516         _totalSupply = _supply;
517     }
518 
519     function setDistributor(address _Distributor) public onlyOwner {
520         Distributor = _Distributor;
521     }
522 
523     function getUserLength() public view returns(uint256) {
524         return _userLength;
525     }
526 
527     function getUserAddress(uint256 id) public view returns(address) {
528         return idByAddress[id];
529     }
530 
531 }