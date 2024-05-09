1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         return account.code.length > 0;
8     }
9 
10     function sendValue(address payable recipient, uint256 amount) internal {
11         require(
12             address(this).balance >= amount,
13             "Address: insufficient balance"
14         );
15 
16         (bool success, ) = recipient.call{value: amount}("");
17         require(
18             success,
19             "Address: unable to send value, recipient may have reverted"
20         );
21     }
22 
23     function functionCall(
24         address target,
25         bytes memory data
26     ) internal returns (bytes memory) {
27         return
28             functionCallWithValue(
29                 target,
30                 data,
31                 0,
32                 "Address: low-level call failed"
33             );
34     }
35 
36     function functionCall(
37         address target,
38         bytes memory data,
39         string memory errorMessage
40     ) internal returns (bytes memory) {
41         return functionCallWithValue(target, data, 0, errorMessage);
42     }
43 
44     function functionCallWithValue(
45         address target,
46         bytes memory data,
47         uint256 value
48     ) internal returns (bytes memory) {
49         return
50             functionCallWithValue(
51                 target,
52                 data,
53                 value,
54                 "Address: low-level call with value failed"
55             );
56     }
57 
58     function functionCallWithValue(
59         address target,
60         bytes memory data,
61         uint256 value,
62         string memory errorMessage
63     ) internal returns (bytes memory) {
64         require(
65             address(this).balance >= value,
66             "Address: insufficient balance for call"
67         );
68         (bool success, bytes memory returndata) = target.call{value: value}(
69             data
70         );
71         return
72             verifyCallResultFromTarget(
73                 target,
74                 success,
75                 returndata,
76                 errorMessage
77             );
78     }
79 
80     function functionStaticCall(
81         address target,
82         bytes memory data
83     ) internal view returns (bytes memory) {
84         return
85             functionStaticCall(
86                 target,
87                 data,
88                 "Address: low-level static call failed"
89             );
90     }
91 
92     function functionStaticCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal view returns (bytes memory) {
97         (bool success, bytes memory returndata) = target.staticcall(data);
98         return
99             verifyCallResultFromTarget(
100                 target,
101                 success,
102                 returndata,
103                 errorMessage
104             );
105     }
106 
107     function functionDelegateCall(
108         address target,
109         bytes memory data
110     ) internal returns (bytes memory) {
111         return
112             functionDelegateCall(
113                 target,
114                 data,
115                 "Address: low-level delegate call failed"
116             );
117     }
118 
119     function functionDelegateCall(
120         address target,
121         bytes memory data,
122         string memory errorMessage
123     ) internal returns (bytes memory) {
124         (bool success, bytes memory returndata) = target.delegatecall(data);
125         return
126             verifyCallResultFromTarget(
127                 target,
128                 success,
129                 returndata,
130                 errorMessage
131             );
132     }
133 
134     function verifyCallResultFromTarget(
135         address target,
136         bool success,
137         bytes memory returndata,
138         string memory errorMessage
139     ) internal view returns (bytes memory) {
140         if (success) {
141             if (returndata.length == 0) {
142                 require(isContract(target), "Address: call to non-contract");
143             }
144             return returndata;
145         } else {
146             _revert(returndata, errorMessage);
147         }
148     }
149 
150     function verifyCallResult(
151         bool success,
152         bytes memory returndata,
153         string memory errorMessage
154     ) internal pure returns (bytes memory) {
155         if (success) {
156             return returndata;
157         } else {
158             _revert(returndata, errorMessage);
159         }
160     }
161 
162     function _revert(
163         bytes memory returndata,
164         string memory errorMessage
165     ) private pure {
166         if (returndata.length > 0) {
167             /// @solidity memory-safe-assembly
168             assembly {
169                 let returndata_size := mload(returndata)
170                 revert(add(32, returndata), returndata_size)
171             }
172         } else {
173             revert(errorMessage);
174         }
175     }
176 }
177 
178 interface IERC20Permit {
179     function permit(
180         address owner,
181         address spender,
182         uint256 value,
183         uint256 deadline,
184         uint8 v,
185         bytes32 r,
186         bytes32 s
187     ) external;
188 
189     function nonces(address owner) external view returns (uint256);
190 
191     // solhint-disable-next-line func-name-mixedcase
192     function DOMAIN_SEPARATOR() external view returns (bytes32);
193 }
194 
195 interface IERC20 {
196     event Transfer(address indexed from, address indexed to, uint256 value);
197 
198     event Approval(
199         address indexed owner,
200         address indexed spender,
201         uint256 value
202     );
203 
204     function totalSupply() external view returns (uint256);
205 
206     function balanceOf(address account) external view returns (uint256);
207 
208     function transfer(address to, uint256 amount) external returns (bool);
209 
210     function allowance(
211         address owner,
212         address spender
213     ) external view returns (uint256);
214 
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     function transferFrom(
218         address from,
219         address to,
220         uint256 amount
221     ) external returns (bool);
222 }
223 
224 library SafeERC20 {
225     using Address for address;
226 
227     function safeTransfer(IERC20 token, address to, uint256 value) internal {
228         _callOptionalReturn(
229             token,
230             abi.encodeWithSelector(token.transfer.selector, to, value)
231         );
232     }
233 
234     function safeTransferFrom(
235         IERC20 token,
236         address from,
237         address to,
238         uint256 value
239     ) internal {
240         _callOptionalReturn(
241             token,
242             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
243         );
244     }
245 
246     function safeApprove(
247         IERC20 token,
248         address spender,
249         uint256 value
250     ) internal {
251         require(
252             (value == 0) || (token.allowance(address(this), spender) == 0),
253             "SafeERC20: approve from non-zero to non-zero allowance"
254         );
255         _callOptionalReturn(
256             token,
257             abi.encodeWithSelector(token.approve.selector, spender, value)
258         );
259     }
260 
261     function safeIncreaseAllowance(
262         IERC20 token,
263         address spender,
264         uint256 value
265     ) internal {
266         uint256 oldAllowance = token.allowance(address(this), spender);
267         _callOptionalReturn(
268             token,
269             abi.encodeWithSelector(
270                 token.approve.selector,
271                 spender,
272                 oldAllowance + value
273             )
274         );
275     }
276 
277     function safeDecreaseAllowance(
278         IERC20 token,
279         address spender,
280         uint256 value
281     ) internal {
282         unchecked {
283             uint256 oldAllowance = token.allowance(address(this), spender);
284             require(
285                 oldAllowance >= value,
286                 "SafeERC20: decreased allowance below zero"
287             );
288             _callOptionalReturn(
289                 token,
290                 abi.encodeWithSelector(
291                     token.approve.selector,
292                     spender,
293                     oldAllowance - value
294                 )
295             );
296         }
297     }
298 
299     function forceApprove(
300         IERC20 token,
301         address spender,
302         uint256 value
303     ) internal {
304         bytes memory approvalCall = abi.encodeWithSelector(
305             token.approve.selector,
306             spender,
307             value
308         );
309 
310         if (!_callOptionalReturnBool(token, approvalCall)) {
311             _callOptionalReturn(
312                 token,
313                 abi.encodeWithSelector(token.approve.selector, spender, 0)
314             );
315             _callOptionalReturn(token, approvalCall);
316         }
317     }
318 
319     function safePermit(
320         IERC20Permit token,
321         address owner,
322         address spender,
323         uint256 value,
324         uint256 deadline,
325         uint8 v,
326         bytes32 r,
327         bytes32 s
328     ) internal {
329         uint256 nonceBefore = token.nonces(owner);
330         token.permit(owner, spender, value, deadline, v, r, s);
331         uint256 nonceAfter = token.nonces(owner);
332         require(
333             nonceAfter == nonceBefore + 1,
334             "SafeERC20: permit did not succeed"
335         );
336     }
337 
338     function _callOptionalReturn(IERC20 token, bytes memory data) private {
339         bytes memory returndata = address(token).functionCall(
340             data,
341             "SafeERC20: low-level call failed"
342         );
343         require(
344             returndata.length == 0 || abi.decode(returndata, (bool)),
345             "SafeERC20: ERC20 operation did not succeed"
346         );
347     }
348 
349     function _callOptionalReturnBool(
350         IERC20 token,
351         bytes memory data
352     ) private returns (bool) {
353         (bool success, bytes memory returndata) = address(token).call(data);
354         return
355             success &&
356             (returndata.length == 0 || abi.decode(returndata, (bool))) &&
357             Address.isContract(address(token));
358     }
359 }
360 
361 interface IERC20Metadata is IERC20 {
362     function name() external view returns (string memory);
363 
364     function symbol() external view returns (string memory);
365 
366     function decimals() external view returns (uint8);
367 }
368 
369 abstract contract Context {
370     function _msgSender() internal view virtual returns (address) {
371         return msg.sender;
372     }
373 
374     function _msgData() internal view virtual returns (bytes calldata) {
375         return msg.data;
376     }
377 }
378 
379 contract ERC20 is Context, IERC20, IERC20Metadata {
380     mapping(address => uint256) private _balances;
381 
382     mapping(address => mapping(address => uint256)) private _allowances;
383 
384     uint256 private _totalSupply;
385 
386     string private _name;
387     string private _symbol;
388 
389     constructor(string memory name_, string memory symbol_) {
390         _name = name_;
391         _symbol = symbol_;
392     }
393 
394     function name() public view virtual override returns (string memory) {
395         return _name;
396     }
397 
398     function symbol() public view virtual override returns (string memory) {
399         return _symbol;
400     }
401 
402     function decimals() public view virtual override returns (uint8) {
403         return 18;
404     }
405 
406     function totalSupply() public view virtual override returns (uint256) {
407         return _totalSupply;
408     }
409 
410     function balanceOf(
411         address account
412     ) public view virtual override returns (uint256) {
413         return _balances[account];
414     }
415 
416     function transfer(
417         address to,
418         uint256 amount
419     ) public virtual override returns (bool) {
420         address owner = _msgSender();
421         _transfer(owner, to, amount);
422         return true;
423     }
424 
425     function allowance(
426         address owner,
427         address spender
428     ) public view virtual override returns (uint256) {
429         return _allowances[owner][spender];
430     }
431 
432     function approve(
433         address spender,
434         uint256 amount
435     ) public virtual override returns (bool) {
436         address owner = _msgSender();
437         _approve(owner, spender, amount);
438         return true;
439     }
440 
441     function transferFrom(
442         address from,
443         address to,
444         uint256 amount
445     ) public virtual override returns (bool) {
446         address spender = _msgSender();
447         _spendAllowance(from, spender, amount);
448         _transfer(from, to, amount);
449         return true;
450     }
451 
452     function increaseAllowance(
453         address spender,
454         uint256 addedValue
455     ) public virtual returns (bool) {
456         address owner = _msgSender();
457         _approve(owner, spender, allowance(owner, spender) + addedValue);
458         return true;
459     }
460 
461     function decreaseAllowance(
462         address spender,
463         uint256 subtractedValue
464     ) public virtual returns (bool) {
465         address owner = _msgSender();
466         uint256 currentAllowance = allowance(owner, spender);
467         require(
468             currentAllowance >= subtractedValue,
469             "ERC20: decreased allowance below zero"
470         );
471         unchecked {
472             _approve(owner, spender, currentAllowance - subtractedValue);
473         }
474 
475         return true;
476     }
477 
478     function _transfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {
483         require(from != address(0), "ERC20: transfer from the zero address");
484         require(to != address(0), "ERC20: transfer to the zero address");
485 
486         _beforeTokenTransfer(from, to, amount);
487 
488         uint256 fromBalance = _balances[from];
489         require(
490             fromBalance >= amount,
491             "ERC20: transfer amount exceeds balance"
492         );
493         unchecked {
494             _balances[from] = fromBalance - amount;
495 
496             _balances[to] += amount;
497         }
498 
499         emit Transfer(from, to, amount);
500 
501         _afterTokenTransfer(from, to, amount);
502     }
503 
504     function _mint(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: mint to the zero address");
506 
507         _beforeTokenTransfer(address(0), account, amount);
508 
509         _totalSupply += amount;
510         unchecked {
511             _balances[account] += amount;
512         }
513         emit Transfer(address(0), account, amount);
514 
515         _afterTokenTransfer(address(0), account, amount);
516     }
517 
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527 
528             _totalSupply -= amount;
529         }
530 
531         emit Transfer(account, address(0), amount);
532 
533         _afterTokenTransfer(account, address(0), amount);
534     }
535 
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     function _spendAllowance(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         uint256 currentAllowance = allowance(owner, spender);
554         if (currentAllowance != type(uint256).max) {
555             require(
556                 currentAllowance >= amount,
557                 "ERC20: insufficient allowance"
558             );
559             unchecked {
560                 _approve(owner, spender, currentAllowance - amount);
561             }
562         }
563     }
564 
565     function _beforeTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 
571     function _afterTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 }
577 
578 abstract contract Ownable is Context {
579     address private _owner;
580 
581     event OwnershipTransferred(
582         address indexed previousOwner,
583         address indexed newOwner
584     );
585 
586     constructor() {
587         _transferOwnership(_msgSender());
588     }
589 
590     modifier onlyOwner() {
591         _checkOwner();
592         _;
593     }
594 
595     function owner() public view virtual returns (address) {
596         return _owner;
597     }
598 
599     function _checkOwner() internal view virtual {
600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
601     }
602 
603     function renounceOwnership() public virtual onlyOwner {
604         _transferOwnership(address(0));
605     }
606 
607     function transferOwnership(address newOwner) public virtual onlyOwner {
608         require(
609             newOwner != address(0),
610             "Ownable: new owner is the zero address"
611         );
612         _transferOwnership(newOwner);
613     }
614 
615     function _transferOwnership(address newOwner) internal virtual {
616         address oldOwner = _owner;
617         _owner = newOwner;
618         emit OwnershipTransferred(oldOwner, newOwner);
619     }
620 }
621 
622 contract Safereum is Ownable, ERC20 {
623     using SafeERC20 for IERC20;
624 
625     constructor() ERC20("Safereum", "SAFEREUM") {
626         _transferOwnership(0x67c8423a7709aDB8ED31c04DcbB0C161637b807F);
627         _mint(owner(), 1_000_000_000_000 * (10 ** 18));
628     }
629 
630     receive() external payable {}
631 
632     fallback() external payable {}
633 
634     function burn(uint256 amount) external {
635         super._burn(_msgSender(), amount);
636     }
637 
638     function claimStuckTokens(address token) external onlyOwner {
639         if (token == address(0x0)) {
640             payable(_msgSender()).transfer(address(this).balance);
641             return;
642         }
643         IERC20 ERC20token = IERC20(token);
644         uint256 balance = ERC20token.balanceOf(address(this));
645         ERC20token.safeTransfer(_msgSender(), balance);
646     }
647 }