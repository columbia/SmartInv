1 /*
2 
3                                        `-.`'.-'
4                                        `-.        .-'.
5                                     `-.    -./\.-    .-'
6                                         -.  /_|\  .-
7                                     `-.   `/____\'   .-'.
8                                  `-.    -./.-""-.\.-      '
9                                     `-.  /< (()) >\  .-'
10                                   -   .`/__`-..-'__\'   .-
11                                 ,...`-./___|____|___\.-'.,.
12                                    ,-'   ,` . . ',   `-,
13                                 ,-'   ________________  `-,
14                                    ,'/____|_____|_____\
15                                   / /__|_____|_____|___\
16                                  / /|_____|_____|_____|_\
17                                 ' /____|_____|_____|_____\
18                               .' /__|_____|_____|_____|___\
19                              ,' /|_____|_____|_____|_____|_\
20                             /../____|_____|_____|_____|_____\ 
21                            '../__|_____|_____|_____|_____|___\
22                           '.:/|_____|_____|_____|_____|_____|_\               
23                         ,':./____|_____|_____|_____|_____|_____\            
24                        /:../__|_____|_____|_____|_____|_____|___\            
25                       /.../|_____|_____|_____|_____|_____|_____|_\           
26                      '..:/____|_____|_____|_____|_____|_____|_____\        
27                      \:./ _  _ ___  ____ ____ _    _ _ _ _ _  _ ___\        
28                      \./  |\/| |__) |___ |___ |___ _X_ _X_  \/  _|_ \       
29                       """"""""""""""""""""""""""""""""""""""""""""""""              
30                       
31  _ _ _                 _             _   _ 
32 (_) | |               (_)           | | (_)
33  _| | |_   _ _ __ ___  _ _ __   __ _| |_ _ 
34 | | | | | | | '_ ` _ \| | '_ \ / _` | __| |
35 | | | | |_| | | | | | | | | | | (_| | |_| |
36 |_|_|_|\__,_|_| |_| |_|_|_| |_|\__,_|\__|_|
37 
38 https://twitter.com/ILUMeth
39 
40 https://t.me/ilumeth
41 
42 https://ilumeth.org/
43 */ 
44 
45 // SPDX-License-Identifier: MIT
46 
47 pragma solidity 0.8.19;
48 
49 library Address {
50     function isContract(address account) internal view returns (bool) {
51         return account.code.length > 0;
52     }
53 
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(
56             address(this).balance >= amount,
57             "Address: insufficient balance"
58         );
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(
62             success,
63             "Address: unable to send value, recipient may have reverted"
64         );
65     }
66 
67     function functionCall(
68         address target,
69         bytes memory data
70     ) internal returns (bytes memory) {
71         return
72             functionCallWithValue(
73                 target,
74                 data,
75                 0,
76                 "Address: low-level call failed"
77             );
78     }
79 
80     function functionCall(
81         address target,
82         bytes memory data,
83         string memory errorMessage
84     ) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, 0, errorMessage);
86     }
87 
88     function functionCallWithValue(
89         address target,
90         bytes memory data,
91         uint256 value
92     ) internal returns (bytes memory) {
93         return
94             functionCallWithValue(
95                 target,
96                 data,
97                 value,
98                 "Address: low-level call with value failed"
99             );
100     }
101 
102     function functionCallWithValue(
103         address target,
104         bytes memory data,
105         uint256 value,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         require(
109             address(this).balance >= value,
110             "Address: insufficient balance for call"
111         );
112         (bool success, bytes memory returndata) = target.call{value: value}(
113             data
114         );
115         return
116             verifyCallResultFromTarget(
117                 target,
118                 success,
119                 returndata,
120                 errorMessage
121             );
122     }
123 
124     function functionStaticCall(
125         address target,
126         bytes memory data
127     ) internal view returns (bytes memory) {
128         return
129             functionStaticCall(
130                 target,
131                 data,
132                 "Address: low-level static call failed"
133             );
134     }
135 
136     function functionStaticCall(
137         address target,
138         bytes memory data,
139         string memory errorMessage
140     ) internal view returns (bytes memory) {
141         (bool success, bytes memory returndata) = target.staticcall(data);
142         return
143             verifyCallResultFromTarget(
144                 target,
145                 success,
146                 returndata,
147                 errorMessage
148             );
149     }
150 
151     function functionDelegateCall(
152         address target,
153         bytes memory data
154     ) internal returns (bytes memory) {
155         return
156             functionDelegateCall(
157                 target,
158                 data,
159                 "Address: low-level delegate call failed"
160             );
161     }
162 
163     function functionDelegateCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         (bool success, bytes memory returndata) = target.delegatecall(data);
169         return
170             verifyCallResultFromTarget(
171                 target,
172                 success,
173                 returndata,
174                 errorMessage
175             );
176     }
177 
178     function verifyCallResultFromTarget(
179         address target,
180         bool success,
181         bytes memory returndata,
182         string memory errorMessage
183     ) internal view returns (bytes memory) {
184         if (success) {
185             if (returndata.length == 0) {
186                 require(isContract(target), "Address: call to non-contract");
187             }
188             return returndata;
189         } else {
190             _revert(returndata, errorMessage);
191         }
192     }
193 
194     function verifyCallResult(
195         bool success,
196         bytes memory returndata,
197         string memory errorMessage
198     ) internal pure returns (bytes memory) {
199         if (success) {
200             return returndata;
201         } else {
202             _revert(returndata, errorMessage);
203         }
204     }
205 
206     function _revert(
207         bytes memory returndata,
208         string memory errorMessage
209     ) private pure {
210         if (returndata.length > 0) {
211             /// @solidity memory-safe-assembly
212             assembly {
213                 let returndata_size := mload(returndata)
214                 revert(add(32, returndata), returndata_size)
215             }
216         } else {
217             revert(errorMessage);
218         }
219     }
220 }
221 
222 interface IERC20Permit {
223     function permit(
224         address owner,
225         address spender,
226         uint256 value,
227         uint256 deadline,
228         uint8 v,
229         bytes32 r,
230         bytes32 s
231     ) external;
232 
233     function nonces(address owner) external view returns (uint256);
234 
235     // solhint-disable-next-line func-name-mixedcase
236     function DOMAIN_SEPARATOR() external view returns (bytes32);
237 }
238 
239 interface IERC20 {
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     event Approval(
243         address indexed owner,
244         address indexed spender,
245         uint256 value
246     );
247 
248     function totalSupply() external view returns (uint256);
249 
250     function balanceOf(address account) external view returns (uint256);
251 
252     function transfer(address to, uint256 amount) external returns (bool);
253 
254     function allowance(
255         address owner,
256         address spender
257     ) external view returns (uint256);
258 
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     function transferFrom(
262         address from,
263         address to,
264         uint256 amount
265     ) external returns (bool);
266 }
267 
268 library SafeERC20 {
269     using Address for address;
270 
271     function safeTransfer(IERC20 token, address to, uint256 value) internal {
272         _callOptionalReturn(
273             token,
274             abi.encodeWithSelector(token.transfer.selector, to, value)
275         );
276     }
277 
278     function safeTransferFrom(
279         IERC20 token,
280         address from,
281         address to,
282         uint256 value
283     ) internal {
284         _callOptionalReturn(
285             token,
286             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
287         );
288     }
289 
290     function safeApprove(
291         IERC20 token,
292         address spender,
293         uint256 value
294     ) internal {
295         require(
296             (value == 0) || (token.allowance(address(this), spender) == 0),
297             "SafeERC20: approve from non-zero to non-zero allowance"
298         );
299         _callOptionalReturn(
300             token,
301             abi.encodeWithSelector(token.approve.selector, spender, value)
302         );
303     }
304 
305     function safeIncreaseAllowance(
306         IERC20 token,
307         address spender,
308         uint256 value
309     ) internal {
310         uint256 oldAllowance = token.allowance(address(this), spender);
311         _callOptionalReturn(
312             token,
313             abi.encodeWithSelector(
314                 token.approve.selector,
315                 spender,
316                 oldAllowance + value
317             )
318         );
319     }
320 
321     function safeDecreaseAllowance(
322         IERC20 token,
323         address spender,
324         uint256 value
325     ) internal {
326         unchecked {
327             uint256 oldAllowance = token.allowance(address(this), spender);
328             require(
329                 oldAllowance >= value,
330                 "SafeERC20: decreased allowance below zero"
331             );
332             _callOptionalReturn(
333                 token,
334                 abi.encodeWithSelector(
335                     token.approve.selector,
336                     spender,
337                     oldAllowance - value
338                 )
339             );
340         }
341     }
342 
343     function forceApprove(
344         IERC20 token,
345         address spender,
346         uint256 value
347     ) internal {
348         bytes memory approvalCall = abi.encodeWithSelector(
349             token.approve.selector,
350             spender,
351             value
352         );
353 
354         if (!_callOptionalReturnBool(token, approvalCall)) {
355             _callOptionalReturn(
356                 token,
357                 abi.encodeWithSelector(token.approve.selector, spender, 0)
358             );
359             _callOptionalReturn(token, approvalCall);
360         }
361     }
362 
363     function safePermit(
364         IERC20Permit token,
365         address owner,
366         address spender,
367         uint256 value,
368         uint256 deadline,
369         uint8 v,
370         bytes32 r,
371         bytes32 s
372     ) internal {
373         uint256 nonceBefore = token.nonces(owner);
374         token.permit(owner, spender, value, deadline, v, r, s);
375         uint256 nonceAfter = token.nonces(owner);
376         require(
377             nonceAfter == nonceBefore + 1,
378             "SafeERC20: permit did not succeed"
379         );
380     }
381 
382     function _callOptionalReturn(IERC20 token, bytes memory data) private {
383         bytes memory returndata = address(token).functionCall(
384             data,
385             "SafeERC20: low-level call failed"
386         );
387         require(
388             returndata.length == 0 || abi.decode(returndata, (bool)),
389             "SafeERC20: ERC20 operation did not succeed"
390         );
391     }
392 
393     function _callOptionalReturnBool(
394         IERC20 token,
395         bytes memory data
396     ) private returns (bool) {
397         (bool success, bytes memory returndata) = address(token).call(data);
398         return
399             success &&
400             (returndata.length == 0 || abi.decode(returndata, (bool))) &&
401             Address.isContract(address(token));
402     }
403 }
404 
405 interface IERC20Metadata is IERC20 {
406     function name() external view returns (string memory);
407 
408     function symbol() external view returns (string memory);
409 
410     function decimals() external view returns (uint8);
411 }
412 
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes calldata) {
419         return msg.data;
420     }
421 }
422 
423 contract ERC20 is Context, IERC20, IERC20Metadata {
424     mapping(address => uint256) private _balances;
425 
426     mapping(address => mapping(address => uint256)) private _allowances;
427 
428     uint256 private _totalSupply;
429 
430     string private _name;
431     string private _symbol;
432 
433     constructor(string memory name_, string memory symbol_) {
434         _name = name_;
435         _symbol = symbol_;
436     }
437 
438     function name() public view virtual override returns (string memory) {
439         return _name;
440     }
441 
442     function symbol() public view virtual override returns (string memory) {
443         return _symbol;
444     }
445 
446     function decimals() public view virtual override returns (uint8) {
447         return 18;
448     }
449 
450     function totalSupply() public view virtual override returns (uint256) {
451         return _totalSupply;
452     }
453 
454     function balanceOf(
455         address account
456     ) public view virtual override returns (uint256) {
457         return _balances[account];
458     }
459 
460     function transfer(
461         address to,
462         uint256 amount
463     ) public virtual override returns (bool) {
464         address owner = _msgSender();
465         _transfer(owner, to, amount);
466         return true;
467     }
468 
469     function allowance(
470         address owner,
471         address spender
472     ) public view virtual override returns (uint256) {
473         return _allowances[owner][spender];
474     }
475 
476     function approve(
477         address spender,
478         uint256 amount
479     ) public virtual override returns (bool) {
480         address owner = _msgSender();
481         _approve(owner, spender, amount);
482         return true;
483     }
484 
485     function transferFrom(
486         address from,
487         address to,
488         uint256 amount
489     ) public virtual override returns (bool) {
490         address spender = _msgSender();
491         _spendAllowance(from, spender, amount);
492         _transfer(from, to, amount);
493         return true;
494     }
495 
496     function increaseAllowance(
497         address spender,
498         uint256 addedValue
499     ) public virtual returns (bool) {
500         address owner = _msgSender();
501         _approve(owner, spender, allowance(owner, spender) + addedValue);
502         return true;
503     }
504 
505     function decreaseAllowance(
506         address spender,
507         uint256 subtractedValue
508     ) public virtual returns (bool) {
509         address owner = _msgSender();
510         uint256 currentAllowance = allowance(owner, spender);
511         require(
512             currentAllowance >= subtractedValue,
513             "ERC20: decreased allowance below zero"
514         );
515         unchecked {
516             _approve(owner, spender, currentAllowance - subtractedValue);
517         }
518 
519         return true;
520     }
521 
522     function _transfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {
527         require(from != address(0), "ERC20: transfer from the zero address");
528         require(to != address(0), "ERC20: transfer to the zero address");
529 
530         _beforeTokenTransfer(from, to, amount);
531 
532         uint256 fromBalance = _balances[from];
533         require(
534             fromBalance >= amount,
535             "ERC20: transfer amount exceeds balance"
536         );
537         unchecked {
538             _balances[from] = fromBalance - amount;
539 
540             _balances[to] += amount;
541         }
542 
543         emit Transfer(from, to, amount);
544 
545         _afterTokenTransfer(from, to, amount);
546     }
547 
548     function _mint(address account, uint256 amount) internal virtual {
549         require(account != address(0), "ERC20: mint to the zero address");
550 
551         _beforeTokenTransfer(address(0), account, amount);
552 
553         _totalSupply += amount;
554         unchecked {
555             _balances[account] += amount;
556         }
557         emit Transfer(address(0), account, amount);
558 
559         _afterTokenTransfer(address(0), account, amount);
560     }
561 
562     function _burn(address account, uint256 amount) internal virtual {
563         require(account != address(0), "ERC20: burn from the zero address");
564 
565         _beforeTokenTransfer(account, address(0), amount);
566 
567         uint256 accountBalance = _balances[account];
568         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
569         unchecked {
570             _balances[account] = accountBalance - amount;
571 
572             _totalSupply -= amount;
573         }
574 
575         emit Transfer(account, address(0), amount);
576 
577         _afterTokenTransfer(account, address(0), amount);
578     }
579 
580     function _approve(
581         address owner,
582         address spender,
583         uint256 amount
584     ) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     function _spendAllowance(
593         address owner,
594         address spender,
595         uint256 amount
596     ) internal virtual {
597         uint256 currentAllowance = allowance(owner, spender);
598         if (currentAllowance != type(uint256).max) {
599             require(
600                 currentAllowance >= amount,
601                 "ERC20: insufficient allowance"
602             );
603             unchecked {
604                 _approve(owner, spender, currentAllowance - amount);
605             }
606         }
607     }
608 
609     function _beforeTokenTransfer(
610         address from,
611         address to,
612         uint256 amount
613     ) internal virtual {}
614 
615     function _afterTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 }
621 
622 abstract contract Ownable is Context {
623     address private _owner;
624 
625     event OwnershipTransferred(
626         address indexed previousOwner,
627         address indexed newOwner
628     );
629 
630     constructor() {
631         _transferOwnership(_msgSender());
632     }
633 
634     modifier onlyOwner() {
635         _checkOwner();
636         _;
637     }
638 
639     function owner() public view virtual returns (address) {
640         return _owner;
641     }
642 
643     function _checkOwner() internal view virtual {
644         require(owner() == _msgSender(), "Ownable: caller is not the owner");
645     }
646 
647     function renounceOwnership() public virtual onlyOwner {
648         _transferOwnership(address(0));
649     }
650 
651     function transferOwnership(address newOwner) public virtual onlyOwner {
652         require(
653             newOwner != address(0),
654             "Ownable: new owner is the zero address"
655         );
656         _transferOwnership(newOwner);
657     }
658 
659     function _transferOwnership(address newOwner) internal virtual {
660         address oldOwner = _owner;
661         _owner = newOwner;
662         emit OwnershipTransferred(oldOwner, newOwner);
663     }
664 }
665 
666 contract ILUM is Ownable, ERC20 {
667     using SafeERC20 for IERC20;
668 
669     constructor() ERC20("Illuminati", "ILUM") {
670         _transferOwnership(0xCD95f9aa3EAA27E6dc6B988b303F917f020FA99f);
671         _mint(owner(), 177_600_000_000 * (10 ** 18));
672     }
673 
674     receive() external payable {}
675 
676     fallback() external payable {}
677 
678     function burn(uint256 amount) external {
679         super._burn(_msgSender(), amount);
680     }
681 
682     function claimStuckTokens(address token) external onlyOwner {
683         if (token == address(0x0)) {
684             payable(_msgSender()).transfer(address(this).balance);
685             return;
686         }
687         IERC20 ERC20token = IERC20(token);
688         uint256 balance = ERC20token.balanceOf(address(this));
689         ERC20token.safeTransfer(_msgSender(), balance);
690     }
691 }