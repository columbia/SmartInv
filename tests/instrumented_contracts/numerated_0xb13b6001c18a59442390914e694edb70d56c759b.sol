1 /**
2 
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKkkKWMMMMMMWKkkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl''dNMMMMMMNo''oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoOWMMMMMMWkoxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKONMMMMMMXkKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kXMMMMMMXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0O0XMMMMX0O0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOkXNNXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:;::;c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxOKkdc,....,ldk0Ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMWOc,',,,;coddddoc;,,,',lOWMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd,.';oOXWMMMMMMWXOo;'.,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMMMNd,'l0WMMMWNXXNWMMMW0c',dNMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMWX0x,'lXMMMNkdxdollkNMMMKc';dOXMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMNo,'.;OMMMNd,cOOd:.'dNMMWk,'',dWMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMXl'..;OMMMXl.',,''.'lXMMMO;..'oNMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMWOdc',xWMMWOc,...',c0WMMNd''cdOWMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMWKl';kWMMMN0kxxk0NMMMNx;'cKWWMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;.,o0NMMMMMMMMMMN0l,.,oXMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;'.',cdk0KKKK0kdc,'..,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMW0l,:l:,',,,,,,,,:oc,c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;dNN0o;'..';dKNWk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;oNMWNOc''c0NMMMk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl:dKWMKc..cKMMXkccOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXx:lXMXo;;oXMNd;oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOlcdkOkkOOklcxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0c'',,;,,':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNKkxxxxxxxxOXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNNNNNNNNNNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 
44 */
45 
46 pragma solidity ^0.6.6;
47 
48 abstract contract Context {
49     function _msgSender() internal virtual view returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal virtual view returns (bytes memory) {
54         this;
55         return msg.data;
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     function mint(address _to, uint256 _amount) external;
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 }
92 
93 library SafeMath {
94 
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     function mod(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 interface SiloControlMigrator {
157     function migrate(IERC20 token) external returns (IERC20);
158 }
159 
160 library Address {
161 
162     function isContract(address account) internal view returns (bool) {
163 
164         uint256 size;
165         // solhint-disable-next-line no-inline-assembly
166         assembly {
167             size := extcodesize(account)
168         }
169         return size > 0;
170     }
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(
174             address(this).balance >= amount,
175             "Address: insufficient balance"
176         );
177 
178         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
179         (bool success, ) = recipient.call{value: amount}("");
180         require(
181             success,
182             "Address: unable to send value, recipient may have reverted"
183         );
184     }
185 
186     function functionCall(address target, bytes memory data)
187         internal
188         returns (bytes memory)
189     {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     function functionCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         return _functionCallWithValue(target, data, 0, errorMessage);
199     }
200 
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return
207             functionCallWithValue(
208                 target,
209                 data,
210                 value,
211                 "Address: low-level call with value failed"
212             );
213     }
214 
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(
222             address(this).balance >= value,
223             "Address: insufficient balance for call"
224         );
225         return _functionCallWithValue(target, data, value, errorMessage);
226     }
227 
228     function _functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 weiValue,
232         string memory errorMessage
233     ) private returns (bytes memory) {
234         require(isContract(target), "Address: call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = target.call{value: weiValue}(
238             data
239         );
240         if (success) {
241             return returndata;
242         } else {
243             if (returndata.length > 0) {
244                 // solhint-disable-next-line no-inline-assembly
245                 assembly {
246                     let returndata_size := mload(returndata)
247                     revert(add(32, returndata), returndata_size)
248                 }
249             } else {
250                 revert(errorMessage);
251             }
252         }
253     }
254 }
255 
256 library SafeERC20 {
257     using SafeMath for uint256;
258     using Address for address;
259 
260     function safeTransfer(
261         IERC20 token,
262         address to,
263         uint256 value
264     ) internal {
265         _callOptionalReturn(
266             token,
267             abi.encodeWithSelector(token.transfer.selector, to, value)
268         );
269     }
270 
271     function safeTransferFrom(
272         IERC20 token,
273         address from,
274         address to,
275         uint256 value
276     ) internal {
277         _callOptionalReturn(
278             token,
279             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
280         );
281     }
282 
283     function safeApprove(
284         IERC20 token,
285         address spender,
286         uint256 value
287     ) internal {
288         require(
289             (value == 0) || (token.allowance(address(this), spender) == 0),
290             "SafeERC20: approve from non-zero to non-zero allowance"
291         );
292         _callOptionalReturn(
293             token,
294             abi.encodeWithSelector(token.approve.selector, spender, value)
295         );
296     }
297 
298     function safeIncreaseAllowance(
299         IERC20 token,
300         address spender,
301         uint256 value
302     ) internal {
303         uint256 newAllowance = token.allowance(address(this), spender).add(
304             value
305         );
306         _callOptionalReturn(
307             token,
308             abi.encodeWithSelector(
309                 token.approve.selector,
310                 spender,
311                 newAllowance
312             )
313         );
314     }
315 
316     function safeDecreaseAllowance(
317         IERC20 token,
318         address spender,
319         uint256 value
320     ) internal {
321         uint256 newAllowance = token.allowance(address(this), spender).sub(
322             value,
323             "SafeERC20: decreased allowance below zero"
324         );
325         _callOptionalReturn(
326             token,
327             abi.encodeWithSelector(
328                 token.approve.selector,
329                 spender,
330                 newAllowance
331             )
332         );
333     }
334 
335 
336     function _callOptionalReturn(IERC20 token, bytes memory data) private {
337         bytes memory returndata = address(token).functionCall(
338             data,
339             "SafeERC20: low-level call failed"
340         );
341         if (returndata.length > 0) {
342             // solhint-disable-next-line max-line-length
343             require(
344                 abi.decode(returndata, (bool)),
345                 "SafeERC20: ERC20 operation did not succeed"
346             );
347         }
348     }
349 }
350 
351 contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(
355         address indexed previousOwner,
356         address indexed newOwner
357     );
358 
359     constructor() internal {
360         address msgSender = _msgSender();
361         _owner = msgSender;
362         emit OwnershipTransferred(address(0), msgSender);
363     }
364 
365     function owner() public view returns (address) {
366         return _owner;
367     }
368 
369     modifier onlyOwner() {
370         require(_owner == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373 
374     function renounceOwnership() public virtual onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378 
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(
381             newOwner != address(0),
382             "Ownable: new owner is the zero address"
383         );
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 contract TokenRecover is Ownable {
390     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
391         IERC20(tokenAddress).transfer(owner(), tokenAmount);
392     }
393 }
394 
395 contract SiloControl is Ownable, TokenRecover {
396     using SafeMath for uint256;
397     using SafeERC20 for IERC20;
398 
399     struct Depositor {
400         uint256 amount;
401         uint256 mintDebt;
402     }
403 
404     struct SiloData {
405         IERC20 Token;
406         uint256 weight;
407         uint256 lastMintBlock;
408         uint256 mintedTokenPerShare;
409     }
410 
411     IERC20 public mintedToken;
412 
413     address public teller;
414 
415     uint256 public mintPerBlock;
416 
417     SiloControlMigrator public migrator;
418 
419 
420     SiloData[] public siloData;
421 
422     mapping(address => bool) public TokenExistsInSilo;
423 
424     mapping(uint256 => mapping(address => Depositor)) public depositor;
425 
426     uint256 public totalWeight = 0;
427 
428     uint256 public startBlock;
429 
430     uint256 public halvePeriod = 357120;
431     uint256 public minimumMintPerBlock = 43568156563424200;
432     uint256 public lastHalveBlock;
433 
434     event Deposit(address indexed user, uint256 indexed siloid, uint256 amount);
435     event Withdraw(address indexed user, uint256 indexed siloid, uint256 amount);
436     event ExitPoolDisgracefully(address indexed user, uint256 indexed siloid, uint256 amount);
437     event Halve(uint256 newMintPerBlock, uint256 nextHalveBlockNumber);
438 
439     constructor( IERC20 _mintedToken, address _teller, uint256 _startBlock) public {
440         mintedToken = _mintedToken;
441         teller = _teller;
442         mintPerBlock = 181834391801075000;
443         startBlock = _startBlock;
444         lastHalveBlock = _startBlock;
445     }
446 
447     function doHalvingCheck(bool _withUpdate) public {
448         if (mintPerBlock <= minimumMintPerBlock) {
449             return;
450         }
451         bool doHalve = block.number > lastHalveBlock + halvePeriod;
452         if (!doHalve) {
453             return;
454         }
455         uint256 newMintPerBlock = mintPerBlock.mul(96).div(100);
456         if (newMintPerBlock >= minimumMintPerBlock) {
457             mintPerBlock = newMintPerBlock;
458             lastHalveBlock = block.number;
459             emit Halve(newMintPerBlock, block.number + halvePeriod);
460 
461             if (_withUpdate) {
462                 massUpdateSilos();
463             }
464         }
465     }
466 
467     function siloDepth() external view returns (uint256) {
468         return siloData.length;
469     }
470 
471     function add(uint256 _weight, IERC20 _Token, bool _withUpdate) public onlyOwner {
472         require(!TokenExistsInSilo[address(_Token)], "Token Address already exists in silo");
473 
474         if (_withUpdate) {
475             massUpdateSilos();
476         }
477 
478         uint256 lastMintBlock = block.number > startBlock ? block.number : startBlock;
479         totalWeight = totalWeight.add(_weight);
480         siloData.push(
481             SiloData({
482                 Token: _Token,
483                 weight: _weight,
484                 lastMintBlock: lastMintBlock,
485                 mintedTokenPerShare: 0
486             })
487         );
488         TokenExistsInSilo[address(_Token)] = true;
489     }
490 
491     function updateTokenExists(address _TokenAddr, bool _isExists) external onlyOwner {
492         TokenExistsInSilo[_TokenAddr] = _isExists;
493     }
494 
495     function set(uint256 _siloid, uint256 _weight, bool _withUpdate) public onlyOwner {
496         if (_withUpdate) {
497             massUpdateSilos();
498         }
499         totalWeight = totalWeight.sub(siloData[_siloid].weight).add( _weight);
500         siloData[_siloid].weight = _weight;
501     }
502 
503     function setMigrator(SiloControlMigrator _migrator) public onlyOwner {
504         migrator = _migrator;
505     }
506 
507     function migrate(uint256 _siloid) public onlyOwner {
508         require(address(migrator) != address(0), "Address of migrator is null");
509 
510         SiloData storage silo = siloData[_siloid];
511         IERC20 Token = silo.Token;
512         uint256 bal = Token.balanceOf(address(this));
513         Token.safeApprove(address(migrator), bal);
514         IERC20 newToken = migrator.migrate(Token);
515 
516         require(!TokenExistsInSilo[address(newToken)], "New Token Address already exists in silo");
517         require(bal == newToken.balanceOf(address(this)), "New Token balance incorrect");
518 
519         silo.Token = newToken;
520 
521         TokenExistsInSilo[address(newToken)] = true;
522     }
523 
524     function pendingMint(uint256 _siloid, address _user) external view returns (uint256) {
525         SiloData storage silo = siloData[_siloid];
526         Depositor storage user = depositor[_siloid][_user];
527         uint256 mintedTokenPerShare = silo.mintedTokenPerShare;
528         uint256 siloedTokenSupply = silo.Token.balanceOf(address(this));
529         if (block.number > silo.lastMintBlock && siloedTokenSupply != 0) {
530             uint256 blockPassed = block.number.sub(silo.lastMintBlock);
531             uint256 tokenMint = blockPassed
532                 .mul(mintPerBlock)
533                 .mul(silo.weight)
534                 .div(totalWeight);
535             mintedTokenPerShare = mintedTokenPerShare.add(
536                 tokenMint.mul(1e12).div(siloedTokenSupply)
537             );
538         }
539         return
540           user.amount.mul(mintedTokenPerShare).div(1e12).sub(user.mintDebt);
541     }
542 
543     function massUpdateSilos() public {
544         uint256 length = siloData.length;
545         for (uint256 siloid = 0; siloid < length; ++siloid) {
546             updateSilo(siloid);
547         }
548     }
549 
550     function updateSilo(uint256 _siloid) public {
551         doHalvingCheck(false);
552         SiloData storage silo = siloData[_siloid];
553         if (block.number <= silo.lastMintBlock) {
554             return;
555         }
556 
557         uint256 siloedTokenSupply = silo.Token.balanceOf(address(this));
558         if (siloedTokenSupply == 0) {
559             silo.lastMintBlock = block.number;
560             return;
561         }
562         uint256 blockPassed = block.number.sub(silo.lastMintBlock);
563         uint256 tokenMint = blockPassed
564             .mul(mintPerBlock)
565             .mul(silo.weight)
566             .div(totalWeight);
567 
568         mintedToken.mint(teller, tokenMint.div(10));
569         mintedToken.mint(address(this), tokenMint);
570         silo.mintedTokenPerShare = silo.mintedTokenPerShare.add(
571             tokenMint.mul(1e12).div(siloedTokenSupply)
572         );
573         silo.lastMintBlock = block.number;
574     }
575 
576     function deposit(uint256 _siloid, uint256 _amount) public {
577         SiloData storage silo = siloData[_siloid];
578         Depositor storage user = depositor[_siloid][msg.sender];
579         updateSilo(_siloid);
580         if (user.amount > 0) {
581             uint256 pending = user
582                 .amount
583                 .mul(silo.mintedTokenPerShare)
584                 .div(1e12)
585                 .sub(user.mintDebt);
586             safeMintedTransfer(msg.sender, pending);
587         }
588         silo.Token.safeTransferFrom(address(msg.sender), address(this), _amount);
589         user.amount = user.amount.add(_amount);
590         user.mintDebt = user.amount.mul(silo.mintedTokenPerShare).div(1e12);
591         emit Deposit(msg.sender, _siloid, _amount);
592     }
593 
594     function withdraw(uint256 _siloid, uint256 _amount) public {
595         SiloData storage silo = siloData[_siloid];
596         Depositor storage user = depositor[_siloid][msg.sender];
597         require(user.amount >= _amount, "Insufficient Amount to withdraw");
598         updateSilo(_siloid);
599         uint256 pending = user.amount.mul(silo.mintedTokenPerShare).div(1e12).sub(user.mintDebt);
600         safeMintedTransfer(msg.sender, pending);
601         user.amount = user.amount.sub(_amount);
602         user.mintDebt = user.amount.mul(silo.mintedTokenPerShare).div(1e12);
603         silo.Token.safeTransfer(address(msg.sender), _amount);
604         emit Withdraw(msg.sender, _siloid, _amount);
605     }
606 
607     function exitPoolDisgracefully(uint256 _siloid) public {
608         SiloData storage silo = siloData[_siloid];
609         Depositor storage user = depositor[_siloid][msg.sender];
610         silo.Token.safeTransfer(address(msg.sender), user.amount);
611         emit ExitPoolDisgracefully(msg.sender, _siloid, user.amount);
612         user.amount = 0;
613         user.mintDebt = 0;
614     }
615 
616     function safeMintedTransfer(address _to, uint256 _amount) internal {
617         uint256 mintBalance = mintedToken.balanceOf(address(this));
618         if (_amount > mintBalance) {
619             mintedToken.transfer(_to, mintBalance);
620         } else {
621             mintedToken.transfer(_to, _amount);
622         }
623     }
624 }