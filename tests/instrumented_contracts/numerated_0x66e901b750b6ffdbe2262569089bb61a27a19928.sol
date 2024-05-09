1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 // NOTICE: Contract begins line 345
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 library Address {
73     function isContract(address account) internal view returns (bool) {
74         // This method relies in extcodesize, which returns 0 for contracts in
75         // construction, since the code is only stored at the end of the
76         // constructor execution.
77 
78         uint256 size;
79         // solhint-disable-next-line no-inline-assembly
80         assembly { size := extcodesize(account) }
81         return size > 0;
82     }
83 
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86 
87         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
88         (bool success, ) = recipient.call{ value: amount }("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93       return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
97         return _functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
102     }
103 
104     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
105         require(address(this).balance >= value, "Address: insufficient balance for call");
106         return _functionCallWithValue(target, data, value, errorMessage);
107     }
108 
109     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
110         require(isContract(target), "Address: call to non-contract");
111 
112         // solhint-disable-next-line avoid-low-level-calls
113         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
114         if (success) {
115             return returndata;
116         } else {
117             // Look for revert reason and bubble it up if present
118             if (returndata.length > 0) {
119                 // The easiest way to bubble the revert reason is using memory via assembly
120 
121                 // solhint-disable-next-line no-inline-assembly
122                 assembly {
123                     let returndata_size := mload(returndata)
124                     revert(add(32, returndata), returndata_size)
125                 }
126             } else {
127                 revert(errorMessage);
128             }
129         }
130     }
131 }
132 
133 contract ERC20 is IERC20 {
134     using SafeMath for uint256;
135     using Address for address;
136 
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowances;
140 
141     uint256 private _totalSupply;
142 
143     string private _name;
144     string private _symbol;
145     uint8 private _decimals;
146 
147     constructor (string memory name, string memory symbol) {
148         _name = name;
149         _symbol = symbol;
150         _decimals = 18;
151     }
152 
153     function name() public view returns (string memory) {
154         return _name;
155     }
156 
157     function symbol() public view returns (string memory) {
158         return _symbol;
159     }
160 
161     function decimals() public view returns (uint8) {
162         return _decimals;
163     }
164 
165     function totalSupply() public view override returns (uint256) {
166         return _totalSupply;
167     }
168 
169     function balanceOf(address account) public view override returns (uint256) {
170         return _balances[account];
171     }
172 
173     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
174         _transfer(msg.sender, recipient, amount);
175         return true;
176     }
177 
178     function allowance(address owner, address spender) public view virtual override returns (uint256) {
179         return _allowances[owner][spender];
180     }
181 
182     function approve(address spender, uint256 amount) public virtual override returns (bool) {
183         _approve(msg.sender, spender, amount);
184         return true;
185     }
186 
187     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
194         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
195         return true;
196     }
197 
198     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
199         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
200         return true;
201     }
202 
203     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206 
207         _beforeTokenTransfer(sender, recipient, amount);
208 
209         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
210         _balances[recipient] = _balances[recipient].add(amount);
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _mint(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _beforeTokenTransfer(address(0), account, amount);
218 
219         _totalSupply = _totalSupply.add(amount);
220         _balances[account] = _balances[account].add(amount);
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: burn from the zero address");
226 
227         _beforeTokenTransfer(account, address(0), amount);
228 
229         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
230         _totalSupply = _totalSupply.sub(amount);
231         emit Transfer(account, address(0), amount);
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _setupDecimals(uint8 decimals_) internal {
243         _decimals = decimals_;
244     }
245 
246     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
247 }
248 
249 library SafeERC20 {
250     using SafeMath for uint256;
251     using Address for address;
252 
253     function safeTransfer(IERC20 token, address to, uint256 value) internal {
254         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
255     }
256 
257     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
258         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
259     }
260 
261     function safeApprove(IERC20 token, address spender, uint256 value) internal {
262         // safeApprove should only be called when setting an initial allowance,
263         // or when resetting it to zero. To increase and decrease it, use
264         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
265         // solhint-disable-next-line max-line-length
266         require((value == 0) || (token.allowance(address(this), spender) == 0),
267             "SafeERC20: approve from non-zero to non-zero allowance"
268         );
269         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
270     }
271 
272     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
273         uint256 newAllowance = token.allowance(address(this), spender).add(value);
274         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
275     }
276 
277     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
278         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
279         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
280     }
281 
282     function _callOptionalReturn(IERC20 token, bytes memory data) private {
283         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
284         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
285         // the target address contains contract code and also asserts for success in the low-level call.
286 
287         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
288         if (returndata.length > 0) { // Return data is optional
289             // solhint-disable-next-line max-line-length
290             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
291         }
292     }
293 }
294 
295 interface IOwnable {
296   function owner() external view returns (address);
297 
298   function renounceManagement() external;
299   
300   function pushManagement( address newOwner_ ) external;
301   
302   function pullManagement() external;
303 }
304 
305 abstract contract Ownable is IOwnable {
306 
307     address internal _owner;
308     address internal _newOwner;
309 
310     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
311     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
312 
313     constructor () {
314         _owner = msg.sender;
315         emit OwnershipPushed( address(0), _owner );
316     }
317 
318     function owner() public view override returns (address) {
319         return _owner;
320     }
321 
322     modifier onlyOwner() {
323         require( _owner == msg.sender, "Ownable: caller is not the owner" );
324         _;
325     }
326 
327     function renounceManagement() public virtual override onlyOwner() {
328         emit OwnershipPushed( _owner, address(0) );
329         _owner = address(0);
330     }
331 
332     function pushManagement( address newOwner_ ) public virtual override onlyOwner() {
333         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
334         emit OwnershipPushed( _owner, newOwner_ );
335         _newOwner = newOwner_;
336     }
337     
338     function pullManagement() public virtual override {
339         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
340         emit OwnershipPulled( _owner, _newOwner );
341         _owner = _newOwner;
342     }
343 }
344 
345 /**
346  * Range Pool is a RangeSwap ERC20 token that facilitates trades between stablecoins. We execute "optimistic swaps" --
347  * essentially, the pool assumes all tokens to be worth the same amount at all times, and executes as such.
348  * The caveat is that tokens must remain within a range, determined by Allocation Points (AP). For example,
349  * token A with (lowAP = 1e8) and (highAP = 5e8) must make up 10%-50% of the pool at all times.
350  * RangeSwap allows for cheaper execution and higher capital efficiency than existing, priced swap protocols.
351  */
352 contract RangePool is ERC20, Ownable {
353 
354     using SafeMath for uint;
355     using SafeERC20 for IERC20;
356     using SafeERC20 for ERC20;
357     using Address for address;
358 
359 
360     /* ========== EVENTS ========== */
361 
362     event Swap( address, uint, address );
363     event Add( address, uint );
364     event Remove( address, uint );
365 
366     event TokenAdded( address, uint, uint );
367     event BoundsChanged( address, uint, uint );
368     event Accepting( address, bool );
369     event FeeChanged( uint );
370 
371 
372     /* ========== STRUCTS ========== */
373 
374     struct PoolToken {
375         uint lowAP; // 9 decimals
376         uint highAP; // 9 decimals
377         bool accepting; // can send in (swap or add)
378         bool pushed; // pushed to tokens list
379     }
380 
381 
382     /* ========== STATE VARIABLES ========== */
383 
384     mapping( address => PoolToken ) public tokenInfo;
385     address[] public tokens;
386     uint public totalTokens;
387 
388     uint public fee; // 9 decimals
389     
390     constructor() ERC20( 'Range Pool Token', 'RPT' ) {
391         _mint( msg.sender, 1e18 );
392         totalTokens = 1e18;
393     }
394 
395     /* ========== SWAP ========== */
396 
397     // swap amount from firstToken to secondToken
398     function swap( address firstToken, uint amount, address secondToken ) external {
399         require( amount <= maxCanSwap( firstToken, secondToken ), "Exceeds limit" );
400 
401         emit Swap( firstToken, amount, secondToken );
402 
403         uint feeToTake = amount.mul(fee).div(1e9);
404         totalTokens = totalTokens.add( feeToTake );
405 
406         IERC20( firstToken ).safeTransferFrom( msg.sender, address(this), amount ); 
407         IERC20( secondToken ).safeTransfer( msg.sender, amount.sub( feeToTake ) ); // take fee on amount
408     }
409 
410     /* ========== ADD LIQUIDITY ========== */
411 
412     // add token to pool as liquidity. returns number of pool tokens minted.
413     function add( address token, uint amount ) external returns ( uint amount_ ) {
414         amount_ = value( amount ); // do this before changing totalTokens or totalSupply
415 
416         totalTokens = totalTokens.add( amount ); // add amount to total first
417 
418         require( amount <= maxCanAdd( token ), "Exceeds limit" );
419 
420         IERC20( token ).safeTransferFrom( msg.sender, address(this), amount );
421         emit Add( token, amount );
422 
423         _mint( msg.sender, amount_ );
424     }
425 
426     // add liquidity evenly across all tokens. returns number of pool tokens minted.
427     function addAll( uint amount ) external returns ( uint amount_ ) {
428         uint sum;
429         for ( uint i = 0; i < tokens.length; i++ ) {
430             IERC20 token = IERC20( tokens[i] );
431             uint send = amount.mul( token.balanceOf( address(this) ) ).div( totalTokens );
432             if (send > 0) {
433                 token.safeTransferFrom( msg.sender, address(this), send );
434                 emit Add( tokens[i], send );
435                 sum = sum.add(send);
436             }
437         }
438         amount_ = value( sum );
439 
440         totalTokens = totalTokens.add( sum ); // add amount second (to not skew pool)
441         _mint( msg.sender, amount_ );
442     }
443 
444     /* ========== REMOVE LIQUIDITY ========== */
445 
446     // remove token from liquidity, burning pool token
447     // pass in amount token to remove, returns amount_ pool tokens burned
448     function remove( address token, uint amount ) external returns (uint amount_) {
449         amount_ = value( amount ); // token balance => pool token balance
450         amount = amount.sub( amount.mul( fee ).div( 1e9 ) ); // take fee
451 
452         require( amount <= maxCanRemove( token ), "Exceeds limit" );
453         emit Remove( token, amount );
454 
455         _burn( msg.sender, amount_ ); // burn pool token
456         totalTokens = totalTokens.sub( amount ); // remove amount from pool less fees
457 
458         IERC20( token ).safeTransfer( msg.sender, amount ); // send token removed
459     }
460 
461     // remove liquidity evenly across all tokens 
462     // pass in amount tokens to remove, returns amount_ pool tokens burned
463     function removeAll( uint amount ) public returns (uint amount_) {
464         uint sum;
465         for ( uint i = 0; i < tokens.length; i++ ) {
466             IERC20 token = IERC20( tokens[i] );
467             uint send = amount.mul( token.balanceOf( address(this) ) ).div( totalTokens );
468 
469             if ( send > 0 ) {
470                 uint minusFee = send.sub( send.mul( fee ).div( 1e9 ) );
471                 token.safeTransfer( msg.sender, minusFee );
472                 emit Remove( tokens[i], minusFee ); // take fee
473                 sum = sum.add(send);
474             }
475         }
476 
477         amount_ = value( sum );
478         _burn( msg.sender, amount_ );
479         totalTokens = totalTokens.sub( sum.sub( sum.mul( fee ).div( 1e9 ) ) ); // remove amount from pool less fees
480     }
481 
482     /* ========== VIEW FUNCTIONS ========== */
483 
484     // number of tokens 1 pool token can be redeemed for
485     function redemptionValue() public view returns (uint value_) {
486         value_ = totalTokens.mul(1e18).div( totalSupply() );
487     } 
488 
489     // token value => pool token value
490     function value( uint amount ) public view returns ( uint ) {
491         return amount.mul( 1e18 ).div( redemptionValue() );
492     }
493 
494     // maximum number of token that can be added to pool
495     function maxCanAdd( address token ) public view returns ( uint ) {
496         require( tokenInfo[token].accepting, "Not accepting token" );
497         uint maximum = totalTokens.mul( tokenInfo[ token ].highAP ).div( 1e9 );
498         uint balance = IERC20( token ).balanceOf( address(this) );
499         return maximum.sub( balance );
500     }
501 
502     // maximum number of token that can be removed from pool
503     function maxCanRemove( address token ) public view returns ( uint ) {
504         uint minimum = totalTokens.mul( tokenInfo[ token ].lowAP ).div( 1e9 );
505         uint balance = IERC20( token ).balanceOf( address(this) );
506         return balance.sub( minimum );
507     }
508 
509     // maximum size of trade from first token to second token
510     function maxCanSwap( address firstToken, address secondToken ) public view returns ( uint ) {
511         uint canAdd = maxCanAdd( firstToken);
512         uint canRemove = maxCanRemove( secondToken );
513 
514         if ( canAdd > canRemove ) {
515             return canRemove;
516         } else {
517             return canAdd;
518         }
519     }
520 
521     // amount of secondToken returned by swap
522     function amountOut( address firstToken, uint amount, address secondToken ) external view returns ( uint ) {
523         if ( amount <= maxCanSwap( firstToken, secondToken ) ) {
524             return amount.sub( amount.mul( fee ).div( 1e9 ) );
525         } else {
526             return 0;
527         }
528     }
529 
530     /* ========== SETTINGS ========== */
531 
532     // set fee taken on trades
533     function setFee( uint newFee ) external onlyOwner() {
534         fee = newFee;
535         emit FeeChanged( fee );
536     }
537 
538     // add new token to pool. allocation points are 9 decimals.
539     // must call toggleAccept to activate token
540     function addToken( address token, uint lowAP, uint highAP ) external onlyOwner() {
541         require( !tokenInfo[ token ].pushed );
542 
543         tokenInfo[ token ] = PoolToken({
544             lowAP: lowAP,
545             highAP: highAP,
546             accepting: false,
547             pushed: true
548         });
549 
550         tokens.push( token );
551         emit TokenAdded( token, lowAP, highAP );
552     }
553 
554     // change bounds of tokens in pool
555     function changeBound( address token, uint newLow, uint newHigh ) external onlyOwner() {
556         tokenInfo[ token ].highAP = newHigh;
557         tokenInfo[ token ].lowAP = newLow;
558 
559         emit BoundsChanged( token, newLow, newHigh );
560     }
561 
562     // toggle whether to accept incoming token
563     // setting token to false will not allow swaps as incoming token or adds
564     function toggleAccept( address token ) external onlyOwner() {
565         tokenInfo[ token ].accepting = !tokenInfo[ token ].accepting;
566         emit Accepting( token, tokenInfo[ token ].accepting );
567     }
568 }