1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-03-23
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.4;
12 
13 
14 
15 abstract contract ReentrancyGuard {
16     uint256 private constant _NOT_ENTERED = 1;
17     uint256 private constant _ENTERED = 2;
18     uint256 private _status;
19 
20     constructor() {
21         _status = _NOT_ENTERED;
22     }
23 
24     modifier nonReentrant() {
25         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
26         _status = _ENTERED;
27         _;
28         _status = _NOT_ENTERED;
29     }
30 }
31 
32 library Address {
33     function isContract(address account) internal view returns (bool) {
34         return account.code.length > 0;
35     }
36 
37     function sendValue(address payable recipient, uint256 amount) internal {
38         require(address(this).balance >= amount, "Address: insufficient balance");
39 
40         (bool success, ) = recipient.call{value: amount}("");
41         require(success, "Address: unable to send value, recipient may have reverted");
42     }
43 
44     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
45         return functionCall(target, data, "Address: low-level call failed");
46     }
47 
48     function functionCall(
49         address target,
50         bytes memory data,
51         string memory errorMessage
52     ) internal returns (bytes memory) {
53         return functionCallWithValue(target, data, 0, errorMessage);
54     }
55 
56     function functionCallWithValue(
57         address target,
58         bytes memory data,
59         uint256 value
60     ) internal returns (bytes memory) {
61         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
62     }
63 
64     function functionCallWithValue(
65         address target,
66         bytes memory data,
67         uint256 value,
68         string memory errorMessage
69     ) internal returns (bytes memory) {
70         require(address(this).balance >= value, "Address: insufficient balance for call");
71         require(isContract(target), "Address: call to non-contract");
72 
73         (bool success, bytes memory returndata) = target.call{value: value}(data);
74         return verifyCallResult(success, returndata, errorMessage);
75     }
76 
77     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
78         return functionStaticCall(target, data, "Address: low-level static call failed");
79     }
80 
81     function functionStaticCall(
82         address target,
83         bytes memory data,
84         string memory errorMessage
85     ) internal view returns (bytes memory) {
86         require(isContract(target), "Address: static call to non-contract");
87 
88         (bool success, bytes memory returndata) = target.staticcall(data);
89         return verifyCallResult(success, returndata, errorMessage);
90     }
91 
92     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
94     }
95 
96     function functionDelegateCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         require(isContract(target), "Address: delegate call to non-contract");
102 
103         (bool success, bytes memory returndata) = target.delegatecall(data);
104         return verifyCallResult(success, returndata, errorMessage);
105     }
106 
107     function verifyCallResult(
108         bool success,
109         bytes memory returndata,
110         string memory errorMessage
111     ) internal pure returns (bytes memory) {
112         if (success) {
113             return returndata;
114         } else {
115             // Look for revert reason and bubble it up if present
116             if (returndata.length > 0) {
117                 // The easiest way to bubble the revert reason is using memory via assembly
118                 /// @solidity memory-safe-assembly
119                 assembly {
120                     let returndata_size := mload(returndata)
121                     revert(add(32, returndata), returndata_size)
122                 }
123             } else {
124                 revert(errorMessage);
125             }
126         }
127     }
128 }
129 
130 interface IERC20Permit {
131     function permit(
132         address owner,
133         address spender,
134         uint256 value,
135         uint256 deadline,
136         uint8 v,
137         bytes32 r,
138         bytes32 s
139     ) external;
140 
141     function nonces(address owner) external view returns (uint256);
142 
143     function DOMAIN_SEPARATOR() external view returns (bytes32);
144 }
145 
146 library SafeMathX {
147     function RoundDown(uint256 x, uint256 y) internal pure returns (uint256) {
148         uint256 a = x / 100;
149         uint256 b = x % 100;
150         uint256 c = y / 100;
151         uint256 d = y % 100;
152 
153         return a * c * 100 + a * d + b * c + (b * d) / 100;
154     }
155 }
156 
157 interface IERC20 {
158     event Transfer(address indexed from, address indexed to, uint256 value);
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160     function totalSupply() external view returns (uint256);
161     function balanceOf(address account) external view returns (uint256);
162     function transfer(address to, uint256 amount) external returns (bool);
163     function allowance(address owner, address spender) external view returns (uint256);
164     function approve(address spender, uint256 amount) external returns (bool);
165     function transferFrom(
166         address from,
167         address to,
168         uint256 amount
169     ) external returns (bool);
170 }
171 
172 interface IERC20Metadata is IERC20 {
173     function name() external view returns (string memory);
174     function symbol() external view returns (string memory);
175     function decimals() external view returns (uint8);
176 }
177 
178 library SafeERC20 {
179     using Address for address;
180 
181     function safeTransfer(
182         IERC20 token,
183         address to,
184         uint256 value
185     ) internal {
186         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
187     }
188 
189     function safeTransferFrom(
190         IERC20 token,
191         address from,
192         address to,
193         uint256 value
194     ) internal {
195         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
196     }
197 
198     function safeApprove(
199         IERC20 token,
200         address spender,
201         uint256 value
202     ) internal {
203         require(
204             (value == 0) || (token.allowance(address(this), spender) == 0),
205             "SafeERC20: approve from non-zero to non-zero allowance"
206         );
207         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
208     }
209 
210     function safeIncreaseAllowance(
211         IERC20 token,
212         address spender,
213         uint256 value
214     ) internal {
215         uint256 newAllowance = token.allowance(address(this), spender) + value;
216         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
217     }
218 
219     function safeDecreaseAllowance(
220         IERC20 token,
221         address spender,
222         uint256 value
223     ) internal {
224         unchecked {
225             uint256 oldAllowance = token.allowance(address(this), spender);
226             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
227             uint256 newAllowance = oldAllowance - value;
228             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
229         }
230     }
231 
232     function safePermit(
233         IERC20Permit token,
234         address owner,
235         address spender,
236         uint256 value,
237         uint256 deadline,
238         uint8 v,
239         bytes32 r,
240         bytes32 s
241     ) internal {
242         uint256 nonceBefore = token.nonces(owner);
243         token.permit(owner, spender, value, deadline, v, r, s);
244         uint256 nonceAfter = token.nonces(owner);
245         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
246     }
247 
248     function _callOptionalReturn(IERC20 token, bytes memory data) private {
249         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
250         if (returndata.length > 0) {
251             // Return data is optional
252             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
253         }
254     }
255 }
256 
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address) {
259         return msg.sender;
260     }
261 
262     function _msgData() internal view virtual returns (bytes calldata) {
263         return msg.data;
264     }
265 }
266 
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     function symbol() public view virtual override returns (string memory) {
287         return _symbol;
288     }
289 
290     function decimals() public view virtual override returns (uint8) {
291         return 18;
292     }
293 
294     function totalSupply() public view virtual override returns (uint256) {
295         return _totalSupply;
296     }
297 
298     function balanceOf(address account) public view virtual override returns (uint256) {
299         return _balances[account];
300     }
301 
302     function transfer(address to, uint256 amount) public virtual override returns (bool) {
303         address owner = _msgSender();
304         _transfer(owner, to, amount);
305         return true;
306     }
307 
308     function allowance(address owner, address spender) public view virtual override returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         address owner = _msgSender();
314         _approve(owner, spender, amount);
315         return true;
316     }
317 
318     function transferFrom(
319         address from,
320         address to,
321         uint256 amount
322     ) public virtual override returns (bool) {
323         address spender = _msgSender();
324         _spendAllowance(from, spender, amount);
325         _transfer(from, to, amount);
326         return true;
327     }
328 
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         address owner = _msgSender();
331         _approve(owner, spender, allowance(owner, spender) + addedValue);
332         return true;
333     }
334 
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         uint256 currentAllowance = allowance(owner, spender);
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(owner, spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     function _transfer(
347         address from,
348         address to,
349         uint256 amount
350     ) internal virtual {
351         require(from != address(0), "ERC20: transfer from the zero address");
352         require(to != address(0), "ERC20: transfer to the zero address");
353 
354         _beforeTokenTransfer(from, to, amount);
355 
356         uint256 fromBalance = _balances[from];
357         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
358         unchecked {
359             _balances[from] = fromBalance - amount;
360         }
361         _balances[to] += amount;
362 
363         emit Transfer(from, to, amount);
364 
365         _afterTokenTransfer(from, to, amount);
366     }
367 
368     function _mint(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: mint to the zero address");
370 
371         _beforeTokenTransfer(address(0), account, amount);
372 
373         _totalSupply += amount;
374         _balances[account] += amount;
375         emit Transfer(address(0), account, amount);
376 
377         _afterTokenTransfer(address(0), account, amount);
378     }
379 
380     function _burn(address account, uint256 amount) internal virtual {
381         require(account != address(0), "ERC20: burn from the zero address");
382 
383         _beforeTokenTransfer(account, address(0), amount);
384 
385         uint256 accountBalance = _balances[account];
386         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
387         unchecked {
388             _balances[account] = accountBalance - amount;
389         }
390         _totalSupply -= amount;
391 
392         emit Transfer(account, address(0), amount);
393 
394         _afterTokenTransfer(account, address(0), amount);
395     }
396 
397     function _approve(
398         address owner,
399         address spender,
400         uint256 amount
401     ) internal virtual {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = amount;
406         emit Approval(owner, spender, amount);
407     }
408 
409     function _spendAllowance(
410         address owner,
411         address spender,
412         uint256 amount
413     ) internal virtual {
414         uint256 currentAllowance = allowance(owner, spender);
415         if (currentAllowance != type(uint256).max) {
416             require(currentAllowance >= amount, "ERC20: insufficient allowance");
417             unchecked {
418                 _approve(owner, spender, currentAllowance - amount);
419             }
420         }
421     }
422 
423     function _beforeTokenTransfer(
424         address from,
425         address to,
426         uint256 amount
427     ) internal virtual {}
428 
429     function _afterTokenTransfer(
430         address from,
431         address to,
432         uint256 amount
433     ) internal virtual {}
434 }
435 
436 abstract contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     constructor() {
442         _transferOwnership(_msgSender());
443     }
444 
445     modifier onlyOwner() {
446         _checkOwner();
447         _;
448     }
449 
450     function owner() public view virtual returns (address) {
451         return _owner;
452     }
453 
454     function _checkOwner() internal view virtual {
455         require(owner() == _msgSender(), "Ownable: caller is not the owner");
456     }
457 
458     function renounceOwnership() public virtual onlyOwner {
459         _transferOwnership(address(0));
460     }
461 
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         _transferOwnership(newOwner);
465     }
466 
467     function _transferOwnership(address newOwner) internal virtual {
468         address oldOwner = _owner;
469         _owner = newOwner;
470         emit OwnershipTransferred(oldOwner, newOwner);
471     }
472 }
473 
474 interface SBToken {
475     function excludeFromFee(address account) external;
476     function includeInFee(address account) external;
477 }
478 
479 interface VestingTokens {
480     function addTokensToVesting(address _beneficiary, uint256 _tokenAmount) external;
481 }
482 
483 contract Crowdsale is Context, ReentrancyGuard, Ownable {
484   using SafeERC20 for IERC20;
485   
486   // The token being sold
487   SBToken token;
488 
489   //Vesting Contract Address
490   VestingTokens public vestingTokens;
491 
492   // Address where funds are collected
493   address payable public wallet;
494 
495   // How many token units a buyer gets per wei
496   uint256 public rate;
497 
498   // Amount of wei raised
499   uint256 public weiRaised;
500 
501   bool public preSaleActive;
502 
503   bool public isWhitelistActive;
504   mapping(address => bool) public whitelisted;
505   uint256 public whitelistAccessCount;
506 
507   /**
508    * Event for token purchase logging
509    * @param purchaser who paid for the tokens
510    * @param beneficiary who got the tokens
511    * @param value weis paid for purchase
512    * @param amount amount of tokens purchased
513    */
514   event TokenPurchase(
515     address indexed purchaser,
516     address indexed beneficiary,
517     uint256 value,
518     uint256 amount
519   );
520 
521   event WhitelistStatusChange(bool indexed newValue, bool indexed oldValue);
522 
523   /**
524    * @param _rate Number of token units a buyer gets per wei
525    * @param _wallet Address where collected funds will be forwarded to
526    * @param _token Address of the token being sold
527    */
528   constructor(uint256 _rate, address payable _wallet, address _token, address _vestingTokens) {
529     require(_rate > 0);
530     require(_wallet != address(0));
531 
532     rate = _rate;
533     wallet = _wallet;
534     token = SBToken(_token);
535     vestingTokens = VestingTokens(_vestingTokens);
536   }
537 
538   // -----------------------------------------
539   // Crowdsale external interface
540   // -----------------------------------------
541 
542   /**
543    * @dev fallback function ***DO NOT OVERRIDE***
544    */
545   fallback () external payable {
546     buyTokens(_msgSender());
547   }
548 
549   function activateWhitelist() external onlyOwner{
550 		isWhitelistActive = true;
551 		emit WhitelistStatusChange(true, false);
552 	}
553 	function deactivateWhitelist() external onlyOwner{
554 		isWhitelistActive = false;
555 		emit WhitelistStatusChange(false, true);
556 	}
557 
558   function addWhiteListAddresses(address[] calldata addresses) external onlyOwner {
559         require(whitelistAccessCount + addresses.length <= 1000, "Whitelist amount exceed");
560         for (uint8 i = 0; i < addresses.length; i++)
561         whitelisted[addresses[i]] = true;
562         whitelistAccessCount += addresses.length;
563     }
564 
565     function activatePreSale() external onlyOwner {
566         preSaleActive = true;
567     }
568 
569     function deactivatePreSale() external onlyOwner {
570         preSaleActive = false;
571     }
572 
573     function setRate(uint256 rate_) public onlyOwner{
574         require(rate_ != 0, "Crowdsale: rate is 0");
575         rate = rate_;
576     }
577 
578     function setToken(address token_) public onlyOwner {
579         require(token_ != address(0), "Crowdsale: token is the zero address");
580         token = SBToken(token_);
581     }
582 
583     function setTokenVesting(address tokenVesting_) public onlyOwner {
584         require(tokenVesting_ != address(0), "Crowdsale: token is the zero address");
585         vestingTokens = VestingTokens(tokenVesting_);
586     }
587 
588   /**
589    * @dev low level token purchase ***DO NOT OVERRIDE***
590    * @param _beneficiary Address performing the token purchase
591    */
592   function buyTokens(address _beneficiary) public payable nonReentrant {
593     
594 
595     token.excludeFromFee(_beneficiary);
596 
597     uint256 weiAmount = msg.value;
598     _preValidatePurchase(_beneficiary, weiAmount);
599 
600     // calculate token amount to be created
601     uint256 tokens = _getTokenAmount(weiAmount);
602 
603     // update state
604     weiRaised += weiAmount;
605 
606     _processPurchase(_beneficiary, tokens);
607     emit TokenPurchase(
608       _msgSender(),
609       _beneficiary,
610       weiAmount,
611       tokens
612     );
613 
614     _updatePurchasingState(_beneficiary, weiAmount);
615 
616     _forwardFunds();
617     _postValidatePurchase(_beneficiary, weiAmount);
618 
619     if (_beneficiary != wallet){
620         token.includeInFee(_beneficiary);
621     }
622   }
623 
624   // -----------------------------------------
625   // Internal interface (extensible)
626   // -----------------------------------------
627 
628   /**
629    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
630    * @param _beneficiary Address performing the token purchase
631    * @param _weiAmount Value in wei involved in the purchase
632    */
633   function _preValidatePurchase(
634     address _beneficiary,
635     uint256 _weiAmount
636   )
637     internal
638   {
639     if (isWhitelistActive){
640     require(whitelisted[_beneficiary], "SOLIDBLOCK: You need to be whitelisted");
641     }
642     require(preSaleActive, "Crowdsale: PreSale is not active");
643     require(_beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
644     require(_weiAmount != 0, "Crowdsale: weiAmount is 0");
645   }
646 
647   /**
648    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
649    * @param _beneficiary Address performing the token purchase
650    * @param _weiAmount Value in wei involved in the purchase
651    */
652   function _postValidatePurchase(
653     address _beneficiary,
654     uint256 _weiAmount
655   )
656     internal
657   {
658     // optional override
659   }
660 
661   /**
662    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
663    * @param _beneficiary Address performing the token purchase
664    * @param _tokenAmount Number of tokens to be emitted
665    */
666   function _deliverTokens(
667     address _beneficiary,
668     uint256 _tokenAmount
669   )
670     internal
671   {
672     //IERC20(address(token)).safeTransfer(_beneficiary, _tokenAmount);
673     vestingTokens.addTokensToVesting(_beneficiary, _tokenAmount);
674   }
675 
676   /**
677    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
678    * @param _beneficiary Address receiving the tokens
679    * @param _tokenAmount Number of tokens to be purchased
680    */
681   function _processPurchase(
682     address _beneficiary,
683     uint256 _tokenAmount
684   )
685     internal
686   {
687     _deliverTokens(_beneficiary, _tokenAmount);
688   }
689 
690   /**
691    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
692    * @param _beneficiary Address receiving the tokens
693    * @param _weiAmount Value in wei involved in the purchase
694    */
695   function _updatePurchasingState(
696     address _beneficiary,
697     uint256 _weiAmount
698   )
699     internal
700   {
701     // optional override
702   }
703 
704   /**
705    * @dev Override to extend the way in which ether is converted to tokens.
706    * @param _weiAmount Value in wei to be converted into tokens
707    * @return Number of tokens that can be purchased with the specified _weiAmount
708    */
709   function _getTokenAmount(uint256 _weiAmount)
710     internal view returns (uint256)
711   {
712     return (_weiAmount * rate);
713   }
714 
715   /**
716    * @dev Determines how ETH is stored/forwarded on purchases.
717    */
718   function _forwardFunds() internal {
719     wallet.transfer(msg.value);
720   }
721 
722   function withdraw() public payable onlyOwner {
723         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
724         require(success);
725     }
726 }