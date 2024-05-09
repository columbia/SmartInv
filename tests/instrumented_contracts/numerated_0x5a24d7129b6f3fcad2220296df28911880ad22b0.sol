1 /**
2  * author: pif
3  *
4  *
5  * maxfee9 v1.08 beta
6  *
7  * This is a rewrite of maxfee in the hope to:
8  * - create the Socially engineeered token
9  * - make it easier to change the tokenomics
10  * - make it easier to maintain the code and develop it further
11  * - remove redundant code
12  * - fix some of the issues reported in the audit (e.g. SSL-03)
13  *      
14  *
15  *
16  *copyright all rights reserved
17  * SPDX-License-Identifier: MIT
18  */
19 pragma solidity ^0.8.4;
20 
21 /**
22  * Tokenomics:
23  * 
24  * Liquidity        0%
25  * Redistribution   2%
26  * Burn             0.1%
27  * Charity          0.2%
28  * Marketing        0%
29   */
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 interface IERC20Metadata is IERC20 {
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45 }
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {return msg.sender;}
48     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
49 }
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         unchecked { require(b <= a, errorMessage); return a - b; }
58     }
59 }
60 library Address {
61     function isContract(address account) internal view returns (bool) { uint256 size; assembly { size := extcodesize(account) } return size > 0;}
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
67     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
68     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
69     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
70         require(address(this).balance >= value, "Address: insufficient balance for call");
71         require(isContract(target), "Address: call to non-contract");
72         (bool success, bytes memory returndata) = target.call{ value: value }(data);
73         return _verifyCallResult(success, returndata, errorMessage);
74     }
75     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
76         return functionStaticCall(target, data, "Address: low-level static call failed");
77     }
78     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
79         require(isContract(target), "Address: static call to non-contract");
80         (bool success, bytes memory returndata) = target.staticcall(data);
81         return _verifyCallResult(success, returndata, errorMessage);
82     }
83     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
85     }
86     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
87         require(isContract(target), "Address: delegate call to non-contract");
88         (bool success, bytes memory returndata) = target.delegatecall(data);
89         return _verifyCallResult(success, returndata, errorMessage);
90     }
91     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
92         if (success) { return returndata; } else {
93             if (returndata.length > 0) {
94                 assembly {
95                     let returndata_size := mload(returndata)
96                     revert(add(32, returndata), returndata_size)
97                 }
98             } else {revert(errorMessage);}
99         }
100     }
101 }
102 abstract contract Ownable is Context {
103     address private _owner;
104     address private _previousOwner;
105     uint256 private _lockTime;
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107     constructor () {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112     function owner() public view returns (address) {
113         return _owner;
114     }
115     modifier onlyOwner() {
116         require(_owner == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119     function renounceOwnership() public virtual onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123     function transferOwnership(address newOwner) public virtual onlyOwner {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128     function getUnlockTime() public view returns (uint256) {
129         return _lockTime;
130     }
131     function lock(uint256 time) public virtual onlyOwner {
132         _previousOwner = _owner;
133         _owner = address(0);
134         _lockTime = block.timestamp + time;
135         emit OwnershipTransferred(_owner, address(0));
136     }
137     function unlock() public virtual {
138         require(_previousOwner == msg.sender, "Only the previous owner can unlock onwership");
139         require(block.timestamp > _lockTime , "The contract is still locked");
140         emit OwnershipTransferred(_owner, _previousOwner);
141         _owner = _previousOwner;
142     }
143 }
144 abstract contract Manageable is Context {
145     address private _manager;
146     event ManagementTransferred(address indexed previousManager, address indexed newManager);
147     constructor(){
148         address msgSender = _msgSender();
149         _manager = msgSender;
150         emit ManagementTransferred(address(0), msgSender);
151     }
152     function manager() public view returns(address){ return _manager; }
153     modifier onlyManager(){
154         require(_manager == _msgSender(), "Manageable: caller is not the manager");
155         _;
156     }
157     function transferManagement(address newManager) external virtual onlyManager {
158         emit ManagementTransferred(_manager, newManager);
159         _manager = newManager;
160     }
161 }
162 interface IPancakeV2Factory {
163     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
164     function createPair(address tokenA, address tokenB) external returns (address pair);
165 }
166 interface IPancakeV2Router {
167     function factory() external pure returns (address);
168     function WETH() external pure returns (address);
169     function addLiquidityETH(
170         address token,
171         uint amountTokenDesired,
172         uint amountTokenMin,
173         uint amountETHMin,
174         address to,
175         uint deadline
176     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 }
185 
186 /**
187  * BULL
188  * 
189  * You can add  if you want. 
190   * NOTE: the PFI fee. 
191  * you should be using this contract at all (you're just wasting gas if you do).
192  *
193  * - extra fee (e.g. double) over a threshold 
194  */
195 abstract contract Tokenomics {
196     
197     using SafeMath for uint256;
198     
199     // --------------------- Token Settings ------------------- //
200 
201     string internal constant NAME = "PLSZEN";
202     string internal constant SYMBOL = "PZEN";
203     
204     uint16 internal constant FEES_DIVISOR = 10**4;
205     uint8 internal constant DECIMALS = 9;
206     uint256 internal constant ZEROES = 10**DECIMALS;
207     
208     uint256 private constant MAX = ~uint256(0);
209     uint256 internal constant TOTAL_SUPPLY = 880 * 10**6 *10**9;
210     uint256 internal _reflectedSupply = (MAX - (MAX % TOTAL_SUPPLY));
211 
212     /**
213      * @dev Set the maximum transaction amount allowed in a transfer.
214      * 
215      * The default value is 1% of the total supply. 
216      * 
217      * NOTE: set the value to `TOTAL_SUPPLY` to have an unlimited max, i.e.
218      * `maxTransactionAmount = TOTAL_SUPPLY;`
219      */
220     uint256 internal constant maxTransactionAmount = TOTAL_SUPPLY;
221     
222     /**
223      * @dev Set the maximum allowed balance in a wallet.
224      * 
225      * The default value is 2% of the total supply. 
226      * 
227      * NOTE: set the value to 0 to have an unlimited max.
228      *
229      * IMPORTANT: This value MUST be greater than `numberOfTokensToSwapToLiquidity` set below,
230      * otherwise the liquidity swap will never be executed
231      */
232     uint256 internal constant maxWalletBalance = TOTAL_SUPPLY / 3; // 2% of the total supply
233     
234     /**
235      * @dev Set the number of tokens to swap and add to liquidity. 
236      * 
237      * Whenever the contract's balance reaches this number of tokens, swap & liquify will be 
238      * executed in the very next transfer (via the `_beforeTokenTransfer`)
239      * 
240      * If the `FeeType.Liquidity` is enabled in `FeesSettings`, the given % of each transaction will be first
241      * sent to the contract address. Once the contract's balance reaches `numberOfTokensToSwapToLiquidity` the
242      * `swapAndLiquify` of `Liquifier` will be executed. Half of the tokens will be swapped for ETH 
243      * (or BNB on BSC) and together with the other half converted into a Token-ETH/Token-BNB LP Token.
244      * 
245      * See: `Liquifier`
246      */
247     uint256 internal constant numberOfTokensToSwapToLiquidity = TOTAL_SUPPLY / 1000; // 0.1% of the total supply
248 
249     // --------------------- Fees Settings ------------------- //
250 
251     /**
252      * @dev To add/edit/remove fees scroll down to the `addFees` function below
253      */
254 
255     address internal charityAddress = 0xe83b3c8fc65f6DacfCcC90C8cAc45a1f1dD38a2d;
256     address internal marketingAddress = 0xe83b3c8fc65f6DacfCcC90C8cAc45a1f1dD38a2d;
257 
258     /**
259      * @dev You can change the value of the burn address to pretty much anything
260      * that's (clearly) a non-random address, i.e. for which the probability of 
261      * someone having the private key is (virtually) 0. For example, 0x00.....1, 
262      * 0x111...111, 0x12345.....12345, etc.
263      *
264      * NOTE: This does NOT need to be the zero address, adress(0) = 0x000...000;
265      *
266      * Trasfering tokens to the burn address is good for DEFLATION. Nevertheless
267      * if the burn address is excluded from rewards, sending tokens
268      * to the burn address actually improves redistribution to holders (as they will
269      * have a larger % of tokens in non-excluded accounts)
270      *
271      * p.s. the address below is the speed of light in vacuum in m/s (expressed in decimals),
272      * the hex value is 0x0000000000000000000000000000000011dE784A; :)
273      *
274      * Here are the values of some other fundamental constants to use:
275      * 0x0000000000000000000000000000000602214076 (Avogardo constant)
276      * 0x0000000000000000000000000000000001380649 (Boltzmann constant)
277      * 0x2718281828459045235360287471352662497757 (e)
278      * 0x0000000000000000000000000000001602176634 (elementary charge)
279      * 0x0000000000000000000000000200231930436256 (electron g-factor)
280      * 0x0000000000000000000000000000091093837015 (electron mass)
281      * 0x0000000000000000000000000000137035999084 (fine structure constant)
282      * 0x0577215664901532860606512090082402431042 (Euler-Mascheroni constant)
283      * 0x1618033988749894848204586834365638117720 (golden ratio)
284      * 0x0000000000000000000000000000009192631770 (hyperfine transition fq)
285      * 0x0000000000000000000000000000010011659208 (muom g-2)
286      * 0x3141592653589793238462643383279502884197 (pi)
287      * 0x0000000000000000000000000000000662607015 (Planck's constant)
288      * 0x0000000000000000000000000000001054571817 (reduced Planck's constant)
289      * 0x1414213562373095048801688724209698078569 (sqrt(2))
290      */
291     address internal burnAddress = 0x1414213562373095048801688724209698078569 ;
292 
293     /**
294      * @dev You 
295      * rewriting PZEN
296      *
297      * keep this
298      * and you'll be added to the partners section to promote your token. 
299      */
300     address internal tipToTheDev = 0x079086722C172eb0aDC9886529D2b8139Bc45667;
301 
302     enum FeeType { Antiwhale, Burn, Liquidity, Rfi, External, ExternalToETH }
303     struct Fee {
304         FeeType name;
305         uint256 value;
306         address recipient;
307         uint256 total;
308     }
309 
310     Fee[] internal fees;
311     uint256 internal sumOfFees;
312 
313     constructor() {
314         _addFees();
315     }
316 
317     function _addFee(FeeType name, uint256 value, address recipient) private {
318         fees.push( Fee(name, value, recipient, 0 ) );
319         sumOfFees += value;
320     }
321 
322     function _addFees() private {
323 
324         /**
325          * The PFI recipient is ignored but we need to give a valid address value
326          *
327          * CAUTION:
328          *      There are more efficient and cleaner token contracts without PFI 
329          *      so you should use one of those
330          *
331          * The value of fees is given 
332          * e.g. for 5% use 
333          */ 
334         _addFee(FeeType.Rfi, 200, address(this) ); 
335 
336         _addFee(FeeType.Burn, 1, burnAddress );
337         _addFee(FeeType.Liquidity, 0, address(this) );
338         _addFee(FeeType.External, 20, charityAddress );
339         _addFee(FeeType.External, 0, marketingAddress );
340 
341         // 0.1% as a tip removed
342        // _addFee(FeeType.ExternalToETH, 1, tipToTheDev );
343     }
344 
345     function _getFeesCount() internal view returns (uint256){ return fees.length; }
346 
347     function _getFeeStruct(uint256 index) private view returns(Fee storage){
348         require( index >= 0 && index < fees.length, "FeesSettings._getFeeStruct: Fee index out of bounds");
349         return fees[index];
350     }
351     function _getFee(uint256 index) internal view returns (FeeType, uint256, address, uint256){
352         Fee memory fee = _getFeeStruct(index);
353         return ( fee.name, fee.value, fee.recipient, fee.total );
354     }
355     function _addFeeCollectedAmount(uint256 index, uint256 amount) internal {
356         Fee storage fee = _getFeeStruct(index);
357         fee.total = fee.total.add(amount);
358     }
359 
360     // function getCollectedFeeTotal(uint256 index) external view returns (uint256){
361     function getCollectedFeeTotal(uint256 index) internal view returns (uint256){
362         Fee memory fee = _getFeeStruct(index);
363         return fee.total;
364     }
365 }
366 
367 abstract contract Presaleable is Manageable {
368     bool internal isInPresale;
369     function setPreseableEnabled(bool value) external onlyManager {
370         isInPresale = value;
371     }
372 }
373 
374 abstract contract BaseRfiToken is IERC20, IERC20Metadata, Ownable, Presaleable, Tokenomics {
375 
376     using SafeMath for uint256;
377     using Address for address;
378 
379     mapping (address => uint256) internal _reflectedBalances;
380     mapping (address => uint256) internal _balances;
381     mapping (address => mapping (address => uint256)) internal _allowances;
382     
383     mapping (address => bool) internal _isExcludedFromFee;
384     mapping (address => bool) internal _isExcludedFromRewards;
385     address[] private _excluded;
386     
387     constructor(){
388         
389         _reflectedBalances[owner()] = _reflectedSupply;
390         
391         // exclude owner and this contract from fee
392         _isExcludedFromFee[owner()] = true;
393         _isExcludedFromFee[address(this)] = true;
394         
395         // exclude the owner and this contract from rewards
396         _exclude(owner());
397         _exclude(address(this));
398 
399         emit Transfer(address(0), owner(), TOTAL_SUPPLY);
400         
401     }
402     
403     /** Functions required by IERC20Metadat **/
404         function name() external pure override returns (string memory) { return NAME; }
405         function symbol() external pure override returns (string memory) { return SYMBOL; }
406         function decimals() external pure override returns (uint8) { return DECIMALS; }
407         
408     /** Functions required by IERC20Metadat - END **/
409     /** Functions required by IERC20 **/
410         function totalSupply() external pure override returns (uint256) {
411             return TOTAL_SUPPLY;
412         }
413         
414         function balanceOf(address account) public view override returns (uint256){
415             if (_isExcludedFromRewards[account]) return _balances[account];
416             return tokenFromReflection(_reflectedBalances[account]);
417         }
418         
419         function transfer(address recipient, uint256 amount) external override returns (bool){
420             _transfer(_msgSender(), recipient, amount);
421             return true;
422         }
423         
424         function allowance(address owner, address spender) external view override returns (uint256){
425             return _allowances[owner][spender];
426         }
427     
428         function approve(address spender, uint256 amount) external override returns (bool) {
429             _approve(_msgSender(), spender, amount);
430             return true;
431         }
432         
433         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
434             _transfer(sender, recipient, amount);
435             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
436             return true;
437         }
438     /** Functions required by IERC20 - END **/
439 
440     /**
441      * @dev this is really a "soft" burn (total supply is not reduced). PFI holders
442      * get two benefits from burning tokens:
443      *
444      * 1) Tokens in the burn address increase the % of tokens held by holders not
445      *    excluded from rewards (assuming the burn address is excluded)
446      * 2) Tokens in the burn address cannot be sold (which in turn draing the 
447      *    liquidity pool)
448      *
449      *
450      * In PFI holders already get % of each transaction so the value of their tokens 
451      * increases (in a way). Therefore there is really no need to do a "hard" burn 
452      * (reduce the total supply). What matters (in PFI) is to make sure that a large
453      * amount of tokens cannot be sold = draining the liquidity pool = lowering the
454      * value of tokens holders own. For this purpose, transfering tokens to a (vanity)
455      * burn address is the most appropriate way to "burn". 
456      *
457      * There is an extra check placed into the `transfer` function to make sure the
458      * burn address cannot withdraw the tokens is has
459      * virtually zero).
460      */
461     function burn(uint256 amount) external {
462 
463         address sender = _msgSender();
464         require(sender != address(0), "BaseRfiToken: burn from the zero address");
465         require(sender != address(burnAddress), "BaseRfiToken: burn from the burn address");
466 
467         uint256 balance = balanceOf(sender);
468         require(balance >= amount, "BaseRfiToken: burn amount exceeds balance");
469 
470         uint256 reflectedAmount = amount.mul(_getCurrentRate());
471 
472         // remove the amount from the sender's balance first
473         _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount);
474         if (_isExcludedFromRewards[sender])
475             _balances[sender] = _balances[sender].sub(amount);
476 
477         _burnTokens( sender, amount, reflectedAmount );
478     }
479     
480     /**
481      * @dev  burns the specified amount of tokens by sending them 
482      * to the burn address
483      */
484     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
485 
486         /**
487          * @dev Do not reduce (soft) burning by sending
488          * tokens to the burn address (which should be excluded from rewards) is sufficient
489          * in PFI
490          */ 
491         _reflectedBalances[burnAddress] = _reflectedBalances[burnAddress].add(rBurn);
492         if (_isExcludedFromRewards[burnAddress])
493             _balances[burnAddress] = _balances[burnAddress].add(tBurn);
494 
495         /**
496          * @dev Emit the event so that the burn address balance is updated (on bscscan)
497          */
498         emit Transfer(sender, burnAddress, tBurn);
499     }
500 
501     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
503         return true;
504     }
505     
506     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
508         return true;
509     }
510     
511     function isExcludedFromReward(address account) external view returns (bool) {
512         return _isExcludedFromRewards[account];
513     }
514 
515     /**
516      * @dev Calculates and returns the reflected amount for the given amount with or without 
517      * the transfer fees (deductTransferFee true/false)
518      */
519     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
520         require(tAmount <= TOTAL_SUPPLY, "Amount must be less than supply");
521         if (!deductTransferFee) {
522             (uint256 rAmount,,,,) = _getValues(tAmount,0);
523             return rAmount;
524         } else {
525             (,uint256 rTransferAmount,,,) = _getValues(tAmount,_getSumOfFees(_msgSender(), tAmount));
526             return rTransferAmount;
527         }
528     }
529 
530     /**
531      * @dev Calculates and returns the amount of tokens corresponding to the given reflected amount.
532      */
533     function tokenFromReflection(uint256 rAmount) internal view returns(uint256) {
534         require(rAmount <= _reflectedSupply, "Amount must be less than total reflections");
535         uint256 currentRate = _getCurrentRate();
536         return rAmount.div(currentRate);
537     }
538     
539     function excludeFromReward(address account) external onlyOwner() {
540         require(!_isExcludedFromRewards[account], "Account is not included");
541         _exclude(account);
542     }
543     
544     function _exclude(address account) internal {
545         if(_reflectedBalances[account] > 0) {
546             _balances[account] = tokenFromReflection(_reflectedBalances[account]);
547         }
548         _isExcludedFromRewards[account] = true;
549         _excluded.push(account);
550     }
551 
552     function includeInReward(address account) external onlyOwner() {
553         require(_isExcludedFromRewards[account], "Account is not excluded");
554         for (uint256 i = 0; i < _excluded.length; i++) {
555             if (_excluded[i] == account) {
556                 _excluded[i] = _excluded[_excluded.length - 1];
557                 _balances[account] = 0;
558                 _isExcludedFromRewards[account] = false;
559                 _excluded.pop();
560                 break;
561             }
562         }
563     }
564     
565     function setExcludedFromFee(address account, bool value) external onlyOwner { _isExcludedFromFee[account] = value; }
566     function isExcludedFromFee(address account) public view returns(bool) { return _isExcludedFromFee[account]; }
567     
568     function _approve(address owner, address spender, uint256 amount) internal {
569         require(owner != address(0), "BaseRfiToken: approve from the zero address");
570         require(spender != address(0), "BaseRfiToken: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575     
576     /**
577      */
578     function _isUnlimitedSender(address account) internal view returns(bool){
579         // the owner should be the only whitelisted sender
580         return (account == owner());
581     }
582     /**
583      */
584     function _isUnlimitedRecipient(address account) internal view returns(bool){
585         // the owner should be a white-listed recipient
586         // and anyone should be able to burn as many tokens as 
587         // he/she wants
588         return (account == owner() || account == burnAddress);
589     }
590 
591     function _transfer(address sender, address recipient, uint256 amount) private {
592         require(sender != address(0), "BaseRfiToken: transfer from the zero address");
593         require(recipient != address(0), "BaseRfiToken: transfer to the zero address");
594         require(sender != address(burnAddress), "BaseRfiToken: transfer from the burn address");
595         require(amount > 0, "Transfer amount must be greater than zero");
596         
597         // indicates whether or not feee should be deducted from the transfer
598         bool takeFee = true;
599 
600         if ( isInPresale ){ takeFee = false; }
601         else {
602             /**
603             * Check the amount is within the max allowed limit as long as a
604             * unlimited sender/recepient is not involved in the transaction
605             */
606             if ( amount > maxTransactionAmount && !_isUnlimitedSender(sender) && !_isUnlimitedRecipient(recipient) ){
607                 revert("Transfer amount exceeds the maxTxAmount.");
608             }
609             /**
610             * The pair needs to excluded from the max wallet balance check; 
611             * selling tokens is sending them back to the pair (without this
612             * check, selling tokens would not work if the pair's balance 
613             * was over the allowed max)
614             *
615             * Note: This does NOT take into account the fees which will be deducted 
616             *       from the amount. As such it could be a bit confusing 
617             */
618             if ( maxWalletBalance > 0 && !_isUnlimitedSender(sender) && !_isUnlimitedRecipient(recipient) && !_isV2Pair(recipient) ){
619                 uint256 recipientBalance = balanceOf(recipient);
620                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
621             }
622         }
623 
624         // if any account belongs to _isExcludedFromFee account then remove the fee
625         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){ takeFee = false; }
626 
627         _beforeTokenTransfer(sender, recipient, amount, takeFee);
628         _transferTokens(sender, recipient, amount, takeFee);
629         
630     }
631 
632     function _transferTokens(address sender, address recipient, uint256 amount, bool takeFee) private {
633     
634         /**
635          * We don't need to know anything about the individual fees here 
636          * (like max does with `_getValues`). All that is required 
637          * for the transfer is the sum of all fees to calculate the % of the total 
638          * transaction amount which should be transferred to the recipient. 
639          *
640          * The `_takeFees` call will/should take care of the individual fees
641          */
642         uint256 sumOfFees = _getSumOfFees(sender, amount);
643         if ( !takeFee ){ sumOfFees = 0; }
644         
645         (uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, uint256 tTransferAmount, uint256 currentRate ) = _getValues(amount, sumOfFees);
646         
647         /** 
648          * Sender's and Recipient's reflected balances must be always updated regardless of
649          * whether they are excluded from rewards or not.
650          */ 
651         _reflectedBalances[sender] = _reflectedBalances[sender].sub(rAmount);
652         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rTransferAmount);
653 
654         /**
655          * Update the true/nominal balances for excluded accounts
656          */        
657         if (_isExcludedFromRewards[sender]){ _balances[sender] = _balances[sender].sub(tAmount); }
658         if (_isExcludedFromRewards[recipient] ){ _balances[recipient] = _balances[recipient].add(tTransferAmount); }
659         
660         _takeFees( amount, currentRate, sumOfFees );
661         emit Transfer(sender, recipient, tTransferAmount);
662     }
663     
664     function _takeFees(uint256 amount, uint256 currentRate, uint256 sumOfFees ) private {
665         if ( sumOfFees > 0 && !isInPresale ){
666             _takeTransactionFees(amount, currentRate);
667         }
668     }
669     
670     function _getValues(uint256 tAmount, uint256 feesSum) internal view returns (uint256, uint256, uint256, uint256, uint256) {
671         
672         uint256 tTotalFees = tAmount.mul(feesSum).div(FEES_DIVISOR);
673         uint256 tTransferAmount = tAmount.sub(tTotalFees);
674         uint256 currentRate = _getCurrentRate();
675         uint256 rAmount = tAmount.mul(currentRate);
676         uint256 rTotalFees = tTotalFees.mul(currentRate);
677         uint256 rTransferAmount = rAmount.sub(rTotalFees);
678         
679         return (rAmount, rTransferAmount, tAmount, tTransferAmount, currentRate);
680     }
681     
682     function _getCurrentRate() internal view returns(uint256) {
683         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
684         return rSupply.div(tSupply);
685     }
686     
687     function _getCurrentSupply() internal view returns(uint256, uint256) {
688         uint256 rSupply = _reflectedSupply;
689         uint256 tSupply = TOTAL_SUPPLY;  
690 
691         /**
692          * The code below removes balances of addresses excluded from rewards from
693          * rSupply and tSupply, which effectively increases the % of transaction fees
694          * delivered to non-excluded holders
695          */    
696         for (uint256 i = 0; i < _excluded.length; i++) {
697             if (_reflectedBalances[_excluded[i]] > rSupply || _balances[_excluded[i]] > tSupply) return (_reflectedSupply, TOTAL_SUPPLY);
698             rSupply = rSupply.sub(_reflectedBalances[_excluded[i]]);
699             tSupply = tSupply.sub(_balances[_excluded[i]]);
700         }
701         if (tSupply == 0 || rSupply < _reflectedSupply.div(TOTAL_SUPPLY)) return (_reflectedSupply, TOTAL_SUPPLY);
702         return (rSupply, tSupply);
703     }
704     
705     /**
706      * @dev Hook that is called.
707      */
708     function _beforeTokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) internal virtual;
709     
710     /**
711      * @dev Returns. 
712      * 
713      * To separate concerns this contract (class) will take care of ONLY handling PFI, i.e. 
714      * changing the rates and updating the holder's balance (via `_redistribute`). 
715      * It is not the responsibility of the dev/user to handle all other fees and taxes 
716      * in the appropriate contracts (classes).
717      */ 
718     function _getSumOfFees(address sender, uint256 amount) internal view virtual returns (uint256);
719 
720     /**
721      * @dev A delegate 
722      */
723     function _isV2Pair(address account) internal view virtual returns(bool);
724 
725     /**
726      * @dev Redistributes the specified amount among the current holders via the reflect.finance
727      * algorithm, which ultimately adjusts the
728      * current rate used by  and, in turn, the value returns from `Of`. 
729      * This is the bit of clever math which allows pfi to redistribute the fee without 
730      * having to iterate through all holders. 
731      */
732     function _redistribute(uint256 amount, uint256 currentRate, uint256 fee, uint256 index) internal {
733         uint256 tFee = amount.mul(fee).div(FEES_DIVISOR);
734         uint256 rFee = tFee.mul(currentRate);
735 
736         _reflectedSupply = _reflectedSupply.sub(rFee);
737         _addFeeCollectedAmount(index, tFee);
738     }
739 
740     /**
741      * @dev Hook that is called before event is emitted if fees are enabled for the transfer
742      */
743     function _takeTransactionFees(uint256 amount, uint256 currentRate) internal virtual;
744 }
745 
746 abstract contract Liquifier is Ownable, Manageable {
747 
748     using SafeMath for uint256;
749 
750     uint256 private withdrawableBalance;
751 
752     enum Env {Testnet, MainnetV1, MainnetV2}
753     Env private _env;
754 
755     // PancakeSwap V1
756     address private _mainnetRouterV1Address = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
757     // PancakeSwap V2
758     address private _mainnetRouterV2Address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
759     // Testnet
760     // address private _testnetRouterAddress = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
761     // PancakeSwap Testnet = https://pancake.kiemtienonline360.com/
762     address private _testnetRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
763 
764     IPancakeV2Router internal _router;
765     address internal _pair;
766     
767     bool private inSwapAndLiquify;
768     bool private swapAndLiquifyEnabled = true;
769 
770     uint256 private maxTransactionAmount;
771     uint256 private numberOfTokensToSwapToLiquidity;
772 
773     modifier lockTheSwap {
774         inSwapAndLiquify = true;
775         _;
776         inSwapAndLiquify = false;
777     }
778 
779     event RouterSet(address indexed router);
780     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
781     event SwapAndLiquifyEnabledUpdated(bool enabled);
782     event LiquidityAdded(uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity);
783 
784     receive() external payable {}
785 
786     function initializeLiquiditySwapper(Env env, uint256 maxTx, uint256 liquifyAmount) internal {
787         _env = env;
788         if (_env == Env.MainnetV1){ _setRouterAddress(_mainnetRouterV1Address); }
789         else if (_env == Env.MainnetV2){ _setRouterAddress(_mainnetRouterV2Address); }
790         else /*(_env == Env.Testnet)*/{ _setRouterAddress(_testnetRouterAddress); }
791 
792         maxTransactionAmount = maxTx;
793         numberOfTokensToSwapToLiquidity = liquifyAmount;
794 
795     }
796 
797     /**
798      * NOTE: passing the `contractTokenBalance` here is preferred to creating `balanceOfDelegate`
799      */
800     function liquify(uint256 contractTokenBalance, address sender) internal {
801 
802         if (contractTokenBalance >= maxTransactionAmount) contractTokenBalance = maxTransactionAmount;
803         
804         bool isOverRequiredTokenBalance = ( contractTokenBalance >= numberOfTokensToSwapToLiquidity );
805         
806         /**
807          * - first check if the contract has collected enough tokens to swap and liquify
808          * - then check swap and liquify is enabled
809          * - then make sure not to get caught in a circular liquidity event
810          * - finally, don't swap & liquify if the sender is the uniswap pair
811          */
812         if ( isOverRequiredTokenBalance && swapAndLiquifyEnabled && !inSwapAndLiquify && (sender != _pair) ){
813             // TODO check if the `(sender != _pair)` is necessary because that basically
814             // stops swap and liquify for all "buy" transactions
815             _swapAndLiquify(contractTokenBalance);            
816         }
817 
818     }
819 
820     /**
821      * @dev sets the router address and created the router, factory pair to enable
822      * swapping and liquifying (contract) tokens
823      */
824     function _setRouterAddress(address router) private {
825         IPancakeV2Router _newPancakeRouter = IPancakeV2Router(router);
826         _pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
827         _router = _newPancakeRouter;
828         emit RouterSet(router);
829     }
830     
831     function _swapAndLiquify(uint256 amount) private lockTheSwap {
832         
833         // split the contract balance into halves
834         uint256 half = amount.div(2);
835         uint256 otherHalf = amount.sub(half);
836         
837         // capture the contract's current ETH balance.
838         // this is so that we can capture exactly the amount of ETH that the
839         // swap creates, and not make the liquidity event include any ETH that
840         // has been manually sent to the contract
841         uint256 initialBalance = address(this).balance;
842         
843         // swap tokens for ETH
844         _swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
845 
846         // how much ETH did we just swap into?
847         uint256 newBalance = address(this).balance.sub(initialBalance);
848 
849         // add liquidity to uniswap
850         _addLiquidity(otherHalf, newBalance);
851         
852         emit SwapAndLiquify(half, newBalance, otherHalf);
853     }
854     
855     function _swapTokensForEth(uint256 tokenAmount) private {
856         
857         // generate the uniswap pair path of token -> weth
858         address[] memory path = new address[](2);
859         path[0] = address(this);
860         path[1] = _router.WETH();
861 
862         _approveDelegate(address(this), address(_router), tokenAmount);
863 
864         // make the swap
865         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
866             tokenAmount,
867             // The minimum amount of output tokens that must be received for the transaction not to revert.
868             // 0 = accept any amount (slippage is inevitable)
869             0,
870             path,
871             address(this),
872             block.timestamp
873         );
874     }
875     
876     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
877         // approve token transfer to cover all possible scenarios
878         _approveDelegate(address(this), address(_router), tokenAmount);
879 
880         // add tahe liquidity
881         (uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity) = _router.addLiquidityETH{value: ethAmount}(
882             address(this),
883             tokenAmount,
884             // Bounds the extent to which the WETH/token price can go up before the transaction reverts. 
885             // Must be <= amountTokenDesired; 0 = accept any amount (slippage is inevitable)
886             0,
887             // Bounds the extent to which the token/WETH price can go up before the transaction reverts.
888             // 0 = accept any amount (slippage is inevitable)
889             0,
890             // this is a centralized risk if the owner's account is ever compromised (see Certik SSL-04)
891             owner(),
892             block.timestamp
893         );
894 
895         // fix the forever locked BNBs as per the noncertik's audit
896         /**
897          * The swapAndLiquify function converts half of the contractTokenBalance SafeMoon tokens to BNB. 
898          * For every swapAndLiquify function call, a small amount of BNB remains in the contract. 
899          * This amount grows over time with the swapAndLiquify function being called throughout the life 
900          * of the contract. The Safemoon contract does not contain a method to withdraw these funds, 
901          * and the BNB will be locked in the Safemoon contract forever.
902          */
903         withdrawableBalance = address(this).balance;
904         emit LiquidityAdded(tokenAmountSent, ethAmountSent, liquidity);
905     }
906     
907 
908     /**
909     * @dev Sets the uniswapV2 pair (router & factory) for swapping and liquifying tokens
910     */
911     function setRouterAddress(address router) external onlyManager() {
912         _setRouterAddress(router);
913     }
914 
915     /**
916      * @dev Sends the swap and liquify flag to the provided value. If set to `false` tokens collected in the contract will
917      * NOT be converted into liquidity.
918      */
919     function setSwapAndLiquifyEnabled(bool enabled) external onlyManager {
920         swapAndLiquifyEnabled = enabled;
921         emit SwapAndLiquifyEnabledUpdated(swapAndLiquifyEnabled);
922     }
923 
924     /**
925      * @dev The owner can withdraw ETH(BNB) collected in the contract from `pfiswapAndLiquify`
926      * or if someone (accidentally) sends ETH/BNB directly to the contract.
927      *
928      * Note: This addresses the contract flaw 
929      * 
930      * The swapAndLiquify function converts 
931      * For every swapAndLiquify function call, a small amount of BNB remains in the contract. 
932      * This amount grows over time with the swapAndLiquify function being called 
933      * throughout the life of the contract. 
934      * to withdraw these funds, and the BNB will be locked in the contract forever.
935      * https://www.certik.org/projects/
936      */
937     function withdrawLockedEth(address payable recipient) external onlyManager(){
938         require(recipient != address(0), "Cannot withdraw the ETH balance to the zero address");
939         require(withdrawableBalance > 0, "The ETH balance must be greater than 0");
940 
941         // prevent re-entrancy attacks
942         uint256 amount = withdrawableBalance;
943         withdrawableBalance = 0;
944         recipient.transfer(amount);
945     }
946 
947     /**
948      * @dev Use this delegate instead of having (unnecessarily) extend `BasepfiToken` to gained access 
949      * to the `_approve` function.
950      */
951     function _approveDelegate(address owner, address spender, uint256 amount) internal virtual;
952 
953 }
954 
955 //////////////////////////////////////////////////////////////////////////
956 abstract contract Antiwhale is Tokenomics {
957 
958     /**
959      * @dev Returns the total sum of fees (in percents / per-mille - this depends on the FEES_DIVISOR value)
960      *
961      * NOTE: Currently this is just a placeholder. The parameters passed to this function are the
962      *      sender's token balance and the transfer amount. An *antiwhale* mechanics can use these 
963      *      values to adjust the fees total for each tx
964      */
965     // function _getAntiwhaleFees(uint256 sendersBalance, uint256 amount) internal view returns (uint256){
966     function _getAntiwhaleFees(uint256, uint256) internal view returns (uint256){
967         return sumOfFees;
968     }
969 }
970 //////////////////////////////////////////////////////////////////////////
971 
972 abstract contract PZEN is BaseRfiToken, Liquifier, Antiwhale {
973     
974     using SafeMath for uint256;
975 
976     // constructor(string memory _name, string memory _symbol, uint8 _decimals){
977     constructor(Env _env){
978 
979         initializeLiquiditySwapper(_env, maxTransactionAmount, numberOfTokensToSwapToLiquidity);
980 
981         // exclude the pair address from rewards - we don't want to redistribute
982         // tx fees to these two; redistribution is only for holders, dah!
983         _exclude(_pair);
984         _exclude(burnAddress);
985     }
986     
987     function _isV2Pair(address account) internal view override returns(bool){
988         return (account == _pair);
989     }
990 
991     function _getSumOfFees(address sender, uint256 amount) internal view override returns (uint256){ 
992         return _getAntiwhaleFees(balanceOf(sender), amount); 
993     }
994     
995     // function _beforeTokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) internal override {
996     function _beforeTokenTransfer(address sender, address , uint256 , bool ) internal override {
997         if ( !isInPresale ){
998             uint256 contractTokenBalance = balanceOf(address(this));
999             liquify( contractTokenBalance, sender );
1000         }
1001     }
1002 
1003     function _takeTransactionFees(uint256 amount, uint256 currentRate) internal override {
1004         
1005         if( isInPresale ){ return; }
1006 
1007         uint256 feesCount = _getFeesCount();
1008         for (uint256 index = 0; index < feesCount; index++ ){
1009             (FeeType name, uint256 value, address recipient,) = _getFee(index);
1010             // no need to check value < 0 as the value is uint (i.e. from 0 to 2^256-1)
1011             if ( value == 0 ) continue;
1012 
1013             if ( name == FeeType.Rfi ){
1014                 _redistribute( amount, currentRate, value, index );
1015             }
1016             else if ( name == FeeType.Burn ){
1017                 _burn( amount, currentRate, value, index );
1018             }
1019             else if ( name == FeeType.Antiwhale){
1020                 // TODO
1021             }
1022             else if ( name == FeeType.ExternalToETH){
1023                 _takeFeeToETH( amount, currentRate, value, recipient, index );
1024             }
1025             else {
1026                 _takeFee( amount, currentRate, value, recipient, index );
1027             }
1028         }
1029     }
1030 
1031     function _burn(uint256 amount, uint256 currentRate, uint256 fee, uint256 index) private {
1032         uint256 tBurn = amount.mul(fee).div(FEES_DIVISOR);
1033         uint256 rBurn = tBurn.mul(currentRate);
1034 
1035         _burnTokens(address(this), tBurn, rBurn);
1036         _addFeeCollectedAmount(index, tBurn);
1037     }
1038 
1039     function _takeFee(uint256 amount, uint256 currentRate, uint256 fee, address recipient, uint256 index) private {
1040 
1041         uint256 tAmount = amount.mul(fee).div(FEES_DIVISOR);
1042         uint256 rAmount = tAmount.mul(currentRate);
1043 
1044         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rAmount);
1045         if(_isExcludedFromRewards[recipient])
1046             _balances[recipient] = _balances[recipient].add(tAmount);
1047 
1048         _addFeeCollectedAmount(index, tAmount);
1049     }
1050     
1051     /**
1052      * @dev When implemented this will convert the fee amount of tokens into ETH/BNB
1053      * and send to the recipient's wallet. Note that this reduces liquidity so it 
1054      * might be a good idea to add a % into the liquidity fee for % you take our through
1055      * this method (just a suggestions)
1056      */
1057     function _takeFeeToETH(uint256 amount, uint256 currentRate, uint256 fee, address recipient, uint256 index) private {
1058         _takeFee(amount, currentRate, fee, recipient, index);        
1059     }
1060 
1061     function _approveDelegate(address owner, address spender, uint256 amount) internal override {
1062         _approve(owner, spender, amount);
1063     }
1064 }
1065 
1066 contract PZENDEPLOYERcontract is PZEN{
1067 
1068     constructor() PZEN(Env.Testnet){
1069         // pre-approve the initial liquidity supply (to safe a bit of time)
1070         _approve(owner(),address(_router), ~uint256(0));
1071     }
1072 }
1073 
1074 /**
1075  * Todo (beta):
1076  *
1077  * - reorganize the sol file(s) to make put everything editable in a single .sol file
1078  *      and keep all other code in other .sol file(s)
1079  * - move variable values initialized in the contract to be constructor parameters
1080  * - add/remove setters/getter where appropriate
1081  * - add unit tests (via ganache-cli + truffle)
1082  * - add full dev evn (truffle) folders & files
1083  *
1084  * Todo:
1085  * 
1086  * - implement `_takeFeeToETH` (currently just calls `_takeFee`)
1087  * - change Uniswap to PancakeSwap in contract/interface names and local var names
1088  * - change ETH to BNB in names and comments
1089  */
1090 
1091 /**
1092  * Tests passed:
1093  * 
1094  * - Tokenomics fees can be added/removed/edited 
1095  * - Tokenomics fees are correctly taken from each (qualifying) transaction
1096  * - The PFI fee is correctly distributed among holders (which are not excluded from rewards)
1097  */