1 /*
2 
3 ██╗  ██╗ ██████╗ ██╗     ██╗  ██╗   ██╗██╗    ██╗ ██████╗  ██████╗ ██████╗ 
4 ██║  ██║██╔═══██╗██║     ██║  ╚██╗ ██╔╝██║    ██║██╔═══██╗██╔═══██╗██╔══██╗
5 ███████║██║   ██║██║     ██║   ╚████╔╝ ██║ █╗ ██║██║   ██║██║   ██║██║  ██║
6 ██╔══██║██║   ██║██║     ██║    ╚██╔╝  ██║███╗██║██║   ██║██║   ██║██║  ██║
7 ██║  ██║╚██████╔╝███████╗███████╗██║   ╚███╔███╔╝╚██████╔╝╚██████╔╝██████╔╝
8 ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝    ╚══╝╚══╝  ╚═════╝  ╚═════╝ ╚═════╝ 
9                                                                            
10             ██╗  ██╗    ██████╗ ███████╗██████╗ ███████╗                   
11             ╚██╗██╔╝    ██╔══██╗██╔════╝██╔══██╗██╔════╝                   
12              ╚███╔╝     ██████╔╝█████╗  ██████╔╝█████╗                     
13              ██╔██╗     ██╔═══╝ ██╔══╝  ██╔═══╝ ██╔══╝                     
14             ██╔╝ ██╗    ██║     ███████╗██║     ███████╗                   
15             ╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝     ╚══════╝                   
16                                                                            
17 
18 Official Links
19 
20 Telegram: https://t.me/hollywoodxpepe
21 Twitter: https://twitter.com/hollywoodxpepe
22 YouTube: https://www.youtube.com/@hollywoodpepe
23 Website: http://hollywoodxpepe.com/
24 GitHub: https://github.com/hollywoodxpepe
25 */
26 
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity 0.8.0;
31 
32 library SafeMath {
33     function tryAdd(
34         uint256 a,
35         uint256 b
36     ) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     function trySub(
45         uint256 a,
46         uint256 b
47     ) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b > a) return (false, 0);
50             return (true, a - b);
51         }
52     }
53 
54     function tryMul(
55         uint256 a,
56         uint256 b
57     ) internal pure returns (bool, uint256) {
58         unchecked {
59             if (a == 0) return (true, 0);
60             uint256 c = a * b;
61             if (c / a != b) return (false, 0);
62             return (true, c);
63         }
64     }
65 
66     function tryDiv(
67         uint256 a,
68         uint256 b
69     ) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75 
76     function tryMod(
77         uint256 a,
78         uint256 b
79     ) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a + b;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a - b;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a * b;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a / b;
100     }
101 
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a % b;
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         unchecked {
112             require(b <= a, errorMessage);
113             return a - b;
114         }
115     }
116 
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         unchecked {
123             require(b > 0, errorMessage);
124             return a / b;
125         }
126     }
127 
128     function mod(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         unchecked {
134             require(b > 0, errorMessage);
135             return a % b;
136         }
137     }
138 }
139 
140 pragma solidity ^0.8.0;
141 
142 interface IERC20 {
143     function totalSupply() external view returns (uint256);
144 
145     function balanceOf(address account) external view returns (uint256);
146 
147     function transfer(
148         address recipient,
149         uint256 amount
150     ) external returns (bool);
151 
152     function allowance(
153         address owner,
154         address spender
155     ) external view returns (uint256);
156 
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     event Approval(
168         address indexed owner,
169         address indexed spender,
170         uint256 value
171     );
172 }
173 
174 pragma solidity ^0.8.0;
175 
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes calldata) {
182         return msg.data;
183     }
184 }
185 
186 pragma solidity ^0.8.0;
187 
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(
192         address indexed previousOwner,
193         address indexed newOwner
194     );
195 
196     constructor() {
197         _transferOwnership(_msgSender());
198     }
199 
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     function renounceOwnership() public virtual onlyOwner {
210         _transferOwnership(address(0));
211     }
212 
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(
215             newOwner != address(0),
216             "Ownable: new owner is the zero address"
217         );
218         _transferOwnership(newOwner);
219     }
220 
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 pragma solidity ^0.8.0;
229 
230 library Address {
231     function isContract(address account) internal view returns (bool) {
232         uint256 size;
233         assembly {
234             size := extcodesize(account)
235         }
236         return size > 0;
237     }
238 
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(
241             address(this).balance >= amount,
242             "Address: insufficient balance"
243         );
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(
247             success,
248             "Address: unable to send value, recipient may have reverted"
249         );
250     }
251 
252     function functionCall(
253         address target,
254         bytes memory data
255     ) internal returns (bytes memory) {
256         return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value
271     ) internal returns (bytes memory) {
272         return
273             functionCallWithValue(
274                 target,
275                 data,
276                 value,
277                 "Address: low-level call with value failed"
278             );
279     }
280 
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(
288             address(this).balance >= value,
289             "Address: insufficient balance for call"
290         );
291         require(isContract(target), "Address: call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.call{value: value}(
294             data
295         );
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     function functionStaticCall(
300         address target,
301         bytes memory data
302     ) internal view returns (bytes memory) {
303         return
304             functionStaticCall(
305                 target,
306                 data,
307                 "Address: low-level static call failed"
308             );
309     }
310 
311     function functionStaticCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         require(isContract(target), "Address: static call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     function functionDelegateCall(
323         address target,
324         bytes memory data
325     ) internal returns (bytes memory) {
326         return
327             functionDelegateCall(
328                 target,
329                 data,
330                 "Address: low-level delegate call failed"
331             );
332     }
333 
334     function functionDelegateCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(isContract(target), "Address: delegate call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.delegatecall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     function verifyCallResult(
346         bool success,
347         bytes memory returndata,
348         string memory errorMessage
349     ) internal pure returns (bytes memory) {
350         if (success) {
351             return returndata;
352         } else {
353             if (returndata.length > 0) {
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 pragma solidity ^0.8.0;
366 
367 library SafeERC20 {
368     using Address for address;
369 
370     function safeTransfer(IERC20 token, address to, uint256 value) internal {
371         _callOptionalReturn(
372             token,
373             abi.encodeWithSelector(token.transfer.selector, to, value)
374         );
375     }
376 
377     function safeTransferFrom(
378         IERC20 token,
379         address from,
380         address to,
381         uint256 value
382     ) internal {
383         _callOptionalReturn(
384             token,
385             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
386         );
387     }
388 
389     function safeApprove(
390         IERC20 token,
391         address spender,
392         uint256 value
393     ) internal {
394         require(
395             (value == 0) || (token.allowance(address(this), spender) == 0),
396             "SafeERC20: approve from non-zero to non-zero allowance"
397         );
398         _callOptionalReturn(
399             token,
400             abi.encodeWithSelector(token.approve.selector, spender, value)
401         );
402     }
403 
404     function safeIncreaseAllowance(
405         IERC20 token,
406         address spender,
407         uint256 value
408     ) internal {
409         uint256 newAllowance = token.allowance(address(this), spender) + value;
410         _callOptionalReturn(
411             token,
412             abi.encodeWithSelector(
413                 token.approve.selector,
414                 spender,
415                 newAllowance
416             )
417         );
418     }
419 
420     function safeDecreaseAllowance(
421         IERC20 token,
422         address spender,
423         uint256 value
424     ) internal {
425         unchecked {
426             uint256 oldAllowance = token.allowance(address(this), spender);
427             require(
428                 oldAllowance >= value,
429                 "SafeERC20: decreased allowance below zero"
430             );
431             uint256 newAllowance = oldAllowance - value;
432             _callOptionalReturn(
433                 token,
434                 abi.encodeWithSelector(
435                     token.approve.selector,
436                     spender,
437                     newAllowance
438                 )
439             );
440         }
441     }
442 
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         bytes memory returndata = address(token).functionCall(
445             data,
446             "SafeERC20: low-level call failed"
447         );
448         if (returndata.length > 0) {
449             require(
450                 abi.decode(returndata, (bool)),
451                 "SafeERC20: ERC20 operation did not succeed"
452             );
453         }
454     }
455 }
456 
457 pragma solidity ^0.8.0;
458 
459 interface IERC20Metadata is IERC20 {
460     function name() external view returns (string memory);
461 
462     function symbol() external view returns (string memory);
463 
464     function decimals() external view returns (uint8);
465 }
466 
467 pragma solidity ^0.8.0;
468 
469 contract HXPEPresale is Ownable {
470     using SafeMath for uint256;
471     using SafeERC20 for IERC20;
472     using SafeERC20 for IERC20Metadata;
473 
474     address public LPAddress;
475 
476     uint256 public rate;
477 
478     address public saleToken;
479 
480     uint public saleTokenDec;
481 
482     uint256 public totalTokensforSale;
483 
484     mapping(address => bool) public payableTokens;
485 
486     mapping(address => uint256) public tokenPrices;
487 
488     bool public saleStatus;
489 
490     address[] public buyers;
491 
492     mapping(address => BuyerTokenDetails) public buyersAmount;
493 
494     uint256 public totalTokensSold;
495 
496     struct BuyerTokenDetails {
497         uint amount;
498         bool exists;
499         bool isClaimed;
500     }
501 
502     constructor(address _LPAddress) {
503         saleStatus = false;
504         LPAddress = _LPAddress;
505     }
506 
507     modifier saleEnabled() {
508         require(saleStatus == true, "Presale: is not enabled");
509         _;
510     }
511 
512     modifier saleStoped() {
513         require(saleStatus == false, "Presale: is not stoped");
514         _;
515     }
516 
517     function setLPAddress(address _LPAddress) external onlyOwner {
518         LPAddress = _LPAddress;
519     }
520 
521     function setSaleToken(
522         address _saleToken,
523         uint256 _totalTokensforSale,
524         uint256 _rate,
525         bool _saleStatus
526     ) external onlyOwner {
527         require(_rate != 0);
528         rate = _rate;
529         saleToken = _saleToken;
530         saleStatus = _saleStatus;
531         saleTokenDec = IERC20Metadata(saleToken).decimals();
532         totalTokensforSale = _totalTokensforSale;
533         IERC20(saleToken).safeTransferFrom(
534             msg.sender,
535             address(this),
536             totalTokensforSale
537         );
538     }
539 
540     function stopSale() external onlyOwner {
541         saleStatus = false;
542     }
543 
544     function resumeSale() external onlyOwner {
545         saleStatus = true;
546     }
547 
548     function addPayableTokens(
549         address[] memory _tokens,
550         uint256[] memory _prices
551     ) external onlyOwner {
552         require(
553             _tokens.length == _prices.length,
554             "Presale: tokens & prices arrays length mismatch"
555         );
556 
557         for (uint256 i = 0; i < _tokens.length; i++) {
558             require(_prices[i] != 0);
559             payableTokens[_tokens[i]] = true;
560             tokenPrices[_tokens[i]] = _prices[i];
561         }
562     }
563 
564     function payableTokenStatus(
565         address _token,
566         bool _status
567     ) external onlyOwner {
568         require(payableTokens[_token] != _status);
569 
570         payableTokens[_token] = _status;
571     }
572 
573     function updateTokenRate(
574         address[] memory _tokens,
575         uint256[] memory _prices,
576         uint256 _rate
577     ) external onlyOwner {
578         require(
579             _tokens.length == _prices.length,
580             "Presale: tokens & prices arrays length mismatch"
581         );
582 
583         if (_rate != 0) {
584             rate = _rate;
585         }
586 
587         for (uint256 i = 0; i < _tokens.length; i += 1) {
588             require(payableTokens[_tokens[i]] == true);
589             require(_prices[i] != 0);
590             tokenPrices[_tokens[i]] = _prices[i];
591         }
592     }
593 
594     function getTokenAmount(
595         address token,
596         uint256 amount
597     ) public view returns (uint256) {
598         uint256 amtOut;
599         if (token != address(0)) {
600             require(payableTokens[token] == true);
601             uint256 price = tokenPrices[token];
602             amtOut = amount.mul(10 ** saleTokenDec).div(price);
603         } else {
604             amtOut = amount.mul(10 ** saleTokenDec).div(rate);
605         }
606         return amtOut;
607     }
608 
609     function transferETH() private {
610         // take 40% of the amount and transfer to LP
611         uint256 lpAmount = msg.value.mul(40).div(100);
612         payable(LPAddress).transfer(lpAmount);
613 
614         // take 60% of the amount and transfer to owner
615         uint256 ownerAmount = msg.value.sub(lpAmount);
616         payable(owner()).transfer(ownerAmount);
617     }
618 
619     function transferToken(address _token, uint256 _amount) private {
620         // take 40% of the amount and transfer to LP
621         uint256 lpAmount = _amount.mul(40).div(100);
622         IERC20(_token).safeTransferFrom(msg.sender, LPAddress, lpAmount);
623 
624         // take 60% of the amount and transfer to owner
625         uint256 ownerAmount = _amount.sub(lpAmount);
626         IERC20(_token).safeTransferFrom(msg.sender, owner(), ownerAmount);
627     }
628 
629     function buyHXPE(
630         address _token,
631         uint256 _amount
632     ) external payable saleEnabled {
633         uint256 saleTokenAmt;
634         if (_token != address(0)) {
635             require(_amount > 0);
636             require(
637                 payableTokens[_token] == true,
638                 "Presale: Token not allowed"
639             );
640 
641             saleTokenAmt = getTokenAmount(_token, _amount);
642             require(
643                 (totalTokensSold + saleTokenAmt) < totalTokensforSale,
644                 "Presale: Not enough tokens to be sale"
645             );
646             transferToken(_token, _amount);
647         } else {
648             saleTokenAmt = getTokenAmount(address(0), msg.value);
649             require((totalTokensSold + saleTokenAmt) < totalTokensforSale);
650             transferETH();
651         }
652         totalTokensSold += saleTokenAmt;
653         if (!buyersAmount[msg.sender].exists) {
654             buyers.push(msg.sender);
655             buyersAmount[msg.sender].exists = true;
656         }
657         buyersAmount[msg.sender].amount += saleTokenAmt;
658     }
659 
660     function withdrawHXPE() external saleStoped {
661         require(
662             buyersAmount[msg.sender].amount > 0,
663             "Presale: No tokens to claim"
664         );
665         uint256 tokensforWithdraw = buyersAmount[msg.sender].amount;
666         buyersAmount[msg.sender].amount = 0;
667         IERC20(saleToken).safeTransfer(msg.sender, tokensforWithdraw);
668     }
669 
670     // Method to unlock all the tokens
671     function unlockAllTokens() external onlyOwner saleStoped {
672         for (uint256 i = 0; i < buyers.length; i++) {
673             if (buyersAmount[buyers[i]].amount > 0) {
674                 IERC20(saleToken).safeTransfer(
675                     buyers[i],
676                     buyersAmount[buyers[i]].amount
677                 );
678                 buyersAmount[buyers[i]].amount = 0;
679             }
680         }
681     }
682 
683     function withdrawAllSaleTokens() external onlyOwner saleStoped {
684         uint256 amt = IERC20(saleToken).balanceOf(address(this));
685         IERC20(saleToken).transfer(msg.sender, amt);
686         totalTokensforSale = 0;
687     }
688 }