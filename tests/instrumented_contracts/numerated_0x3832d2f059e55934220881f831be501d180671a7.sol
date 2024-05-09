1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 1e106b3
6 Repository: https://github.com/renproject/gateway-sol
7 Issues: https://github.com/renproject/gateway-sol/issues
8 
9 Licenses
10 @openzeppelin/contracts: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
11 gateway-sol: https://github.com/renproject/gateway-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity ^0.5.16;
16 
17 
18 contract Initializable {
19 
20   
21   bool private initialized;
22 
23   
24   bool private initializing;
25 
26   
27   modifier initializer() {
28     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
29 
30     bool isTopLevelCall = !initializing;
31     if (isTopLevelCall) {
32       initializing = true;
33       initialized = true;
34     }
35 
36     _;
37 
38     if (isTopLevelCall) {
39       initializing = false;
40     }
41   }
42 
43   
44   function isConstructor() private view returns (bool) {
45     
46     
47     
48     
49     
50     address self = address(this);
51     uint256 cs;
52     assembly { cs := extcodesize(self) }
53     return cs == 0;
54   }
55 
56   
57   uint256[50] private ______gap;
58 }
59 
60 contract Context is Initializable {
61     
62     
63     constructor () internal { }
64     
65 
66     function _msgSender() internal view returns (address payable) {
67         return msg.sender;
68     }
69 
70     function _msgData() internal view returns (bytes memory) {
71         this; 
72         return msg.data;
73     }
74 }
75 
76 contract Ownable is Initializable, Context {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     
82     function initialize(address sender) public initializer {
83         _owner = sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     
93     modifier onlyOwner() {
94         require(isOwner(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     
99     function isOwner() public view returns (bool) {
100         return _msgSender() == _owner;
101     }
102 
103     
104     function renounceOwnership() public onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     
110     function transferOwnership(address newOwner) public onlyOwner {
111         _transferOwnership(newOwner);
112     }
113 
114     
115     function _transferOwnership(address newOwner) internal {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 
121     uint256[50] private ______gap;
122 }
123 
124 contract Proxy {
125   
126   function () payable external {
127     _fallback();
128   }
129 
130   
131   function _implementation() internal view returns (address);
132 
133   
134   function _delegate(address implementation) internal {
135     assembly {
136       
137       
138       
139       calldatacopy(0, 0, calldatasize)
140 
141       
142       
143       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
144 
145       
146       returndatacopy(0, 0, returndatasize)
147 
148       switch result
149       
150       case 0 { revert(0, returndatasize) }
151       default { return(0, returndatasize) }
152     }
153   }
154 
155   
156   function _willFallback() internal {
157   }
158 
159   
160   function _fallback() internal {
161     _willFallback();
162     _delegate(_implementation());
163   }
164 }
165 
166 library OpenZeppelinUpgradesAddress {
167     
168     function isContract(address account) internal view returns (bool) {
169         uint256 size;
170         
171         
172         
173         
174         
175         
176         
177         assembly { size := extcodesize(account) }
178         return size > 0;
179     }
180 }
181 
182 contract BaseUpgradeabilityProxy is Proxy {
183   
184   event Upgraded(address indexed implementation);
185 
186   
187   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
188 
189   
190   function _implementation() internal view returns (address impl) {
191     bytes32 slot = IMPLEMENTATION_SLOT;
192     assembly {
193       impl := sload(slot)
194     }
195   }
196 
197   
198   function _upgradeTo(address newImplementation) internal {
199     _setImplementation(newImplementation);
200     emit Upgraded(newImplementation);
201   }
202 
203   
204   function _setImplementation(address newImplementation) internal {
205     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
206 
207     bytes32 slot = IMPLEMENTATION_SLOT;
208 
209     assembly {
210       sstore(slot, newImplementation)
211     }
212   }
213 }
214 
215 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
216   
217   constructor(address _logic, bytes memory _data) public payable {
218     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
219     _setImplementation(_logic);
220     if(_data.length > 0) {
221       (bool success,) = _logic.delegatecall(_data);
222       require(success);
223     }
224   }  
225 }
226 
227 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
228   
229   event AdminChanged(address previousAdmin, address newAdmin);
230 
231   
232 
233   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
234 
235   
236   modifier ifAdmin() {
237     if (msg.sender == _admin()) {
238       _;
239     } else {
240       _fallback();
241     }
242   }
243 
244   
245   function admin() external ifAdmin returns (address) {
246     return _admin();
247   }
248 
249   
250   function implementation() external ifAdmin returns (address) {
251     return _implementation();
252   }
253 
254   
255   function changeAdmin(address newAdmin) external ifAdmin {
256     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
257     emit AdminChanged(_admin(), newAdmin);
258     _setAdmin(newAdmin);
259   }
260 
261   
262   function upgradeTo(address newImplementation) external ifAdmin {
263     _upgradeTo(newImplementation);
264   }
265 
266   
267   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
268     _upgradeTo(newImplementation);
269     (bool success,) = newImplementation.delegatecall(data);
270     require(success);
271   }
272 
273   
274   function _admin() internal view returns (address adm) {
275     bytes32 slot = ADMIN_SLOT;
276     assembly {
277       adm := sload(slot)
278     }
279   }
280 
281   
282   function _setAdmin(address newAdmin) internal {
283     bytes32 slot = ADMIN_SLOT;
284 
285     assembly {
286       sstore(slot, newAdmin)
287     }
288   }
289 
290   
291   function _willFallback() internal {
292     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
293     super._willFallback();
294   }
295 }
296 
297 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
298   
299   function initialize(address _logic, bytes memory _data) public payable {
300     require(_implementation() == address(0));
301     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
302     _setImplementation(_logic);
303     if(_data.length > 0) {
304       (bool success,) = _logic.delegatecall(_data);
305       require(success);
306     }
307   }  
308 }
309 
310 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
311   
312   function initialize(address _logic, address _admin, bytes memory _data) public payable {
313     require(_implementation() == address(0));
314     InitializableUpgradeabilityProxy.initialize(_logic, _data);
315     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
316     _setAdmin(_admin);
317   }
318 }
319 
320 interface IERC20 {
321     
322     function totalSupply() external view returns (uint256);
323 
324     
325     function balanceOf(address account) external view returns (uint256);
326 
327     
328     function transfer(address recipient, uint256 amount) external returns (bool);
329 
330     
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     
334     function approve(address spender, uint256 amount) external returns (bool);
335 
336     
337     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
338 
339     
340     event Transfer(address indexed from, address indexed to, uint256 value);
341 
342     
343     event Approval(address indexed owner, address indexed spender, uint256 value);
344 }
345 
346 library SafeMath {
347     
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         uint256 c = a + b;
350         require(c >= a, "SafeMath: addition overflow");
351 
352         return c;
353     }
354 
355     
356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
357         return sub(a, b, "SafeMath: subtraction overflow");
358     }
359 
360     
361     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
362         require(b <= a, errorMessage);
363         uint256 c = a - b;
364 
365         return c;
366     }
367 
368     
369     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
370         
371         
372         
373         if (a == 0) {
374             return 0;
375         }
376 
377         uint256 c = a * b;
378         require(c / a == b, "SafeMath: multiplication overflow");
379 
380         return c;
381     }
382 
383     
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         return div(a, b, "SafeMath: division by zero");
386     }
387 
388     
389     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
390         
391         require(b > 0, errorMessage);
392         uint256 c = a / b;
393         
394 
395         return c;
396     }
397 
398     
399     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
400         return mod(a, b, "SafeMath: modulo by zero");
401     }
402 
403     
404     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b != 0, errorMessage);
406         return a % b;
407     }
408 }
409 
410 contract ERC20 is Initializable, Context, IERC20 {
411     using SafeMath for uint256;
412 
413     mapping (address => uint256) private _balances;
414 
415     mapping (address => mapping (address => uint256)) private _allowances;
416 
417     uint256 private _totalSupply;
418 
419     
420     function totalSupply() public view returns (uint256) {
421         return _totalSupply;
422     }
423 
424     
425     function balanceOf(address account) public view returns (uint256) {
426         return _balances[account];
427     }
428 
429     
430     function transfer(address recipient, uint256 amount) public returns (bool) {
431         _transfer(_msgSender(), recipient, amount);
432         return true;
433     }
434 
435     
436     function allowance(address owner, address spender) public view returns (uint256) {
437         return _allowances[owner][spender];
438     }
439 
440     
441     function approve(address spender, uint256 amount) public returns (bool) {
442         _approve(_msgSender(), spender, amount);
443         return true;
444     }
445 
446     
447     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
448         _transfer(sender, recipient, amount);
449         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
450         return true;
451     }
452 
453     
454     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456         return true;
457     }
458 
459     
460     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     
466     function _transfer(address sender, address recipient, uint256 amount) internal {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
471         _balances[recipient] = _balances[recipient].add(amount);
472         emit Transfer(sender, recipient, amount);
473     }
474 
475     
476     function _mint(address account, uint256 amount) internal {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _totalSupply = _totalSupply.add(amount);
480         _balances[account] = _balances[account].add(amount);
481         emit Transfer(address(0), account, amount);
482     }
483 
484     
485     function _burn(address account, uint256 amount) internal {
486         require(account != address(0), "ERC20: burn from the zero address");
487 
488         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
489         _totalSupply = _totalSupply.sub(amount);
490         emit Transfer(account, address(0), amount);
491     }
492 
493     
494     function _approve(address owner, address spender, uint256 amount) internal {
495         require(owner != address(0), "ERC20: approve from the zero address");
496         require(spender != address(0), "ERC20: approve to the zero address");
497 
498         _allowances[owner][spender] = amount;
499         emit Approval(owner, spender, amount);
500     }
501 
502     
503     function _burnFrom(address account, uint256 amount) internal {
504         _burn(account, amount);
505         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
506     }
507 
508     uint256[50] private ______gap;
509 }
510 
511 contract ERC20Detailed is Initializable, IERC20 {
512     string private _name;
513     string private _symbol;
514     uint8 private _decimals;
515 
516     
517     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
518         _name = name;
519         _symbol = symbol;
520         _decimals = decimals;
521     }
522 
523     
524     function name() public view returns (string memory) {
525         return _name;
526     }
527 
528     
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     
534     function decimals() public view returns (uint8) {
535         return _decimals;
536     }
537 
538     uint256[50] private ______gap;
539 }
540 
541 contract Claimable is Initializable, Ownable {
542     address public pendingOwner;
543 
544     function initialize(address _nextOwner) public initializer {
545         Ownable.initialize(_nextOwner);
546     }
547 
548     modifier onlyPendingOwner() {
549         require(
550             _msgSender() == pendingOwner,
551             "Claimable: caller is not the pending owner"
552         );
553         _;
554     }
555 
556     function transferOwnership(address newOwner) public onlyOwner {
557         require(
558             newOwner != owner() && newOwner != pendingOwner,
559             "Claimable: invalid new owner"
560         );
561         pendingOwner = newOwner;
562     }
563 
564     function claimOwnership() public onlyPendingOwner {
565         _transferOwnership(pendingOwner);
566         delete pendingOwner;
567     }
568 }
569 
570 library Address {
571     
572     function isContract(address account) internal view returns (bool) {
573         
574         
575         
576         bytes32 codehash;
577         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
578         
579         assembly { codehash := extcodehash(account) }
580         return (codehash != accountHash && codehash != 0x0);
581     }
582 
583     
584     function toPayable(address account) internal pure returns (address payable) {
585         return address(uint160(account));
586     }
587 
588     
589     function sendValue(address payable recipient, uint256 amount) internal {
590         require(address(this).balance >= amount, "Address: insufficient balance");
591 
592         
593         (bool success, ) = recipient.call.value(amount)("");
594         require(success, "Address: unable to send value, recipient may have reverted");
595     }
596 }
597 
598 library SafeERC20 {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     function safeTransfer(IERC20 token, address to, uint256 value) internal {
603         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
604     }
605 
606     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
607         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
608     }
609 
610     function safeApprove(IERC20 token, address spender, uint256 value) internal {
611         
612         
613         
614         
615         require((value == 0) || (token.allowance(address(this), spender) == 0),
616             "SafeERC20: approve from non-zero to non-zero allowance"
617         );
618         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
619     }
620 
621     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
622         uint256 newAllowance = token.allowance(address(this), spender).add(value);
623         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
624     }
625 
626     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
627         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
628         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
629     }
630 
631     
632     function callOptionalReturn(IERC20 token, bytes memory data) private {
633         
634         
635 
636         
637         
638         
639         
640         
641         require(address(token).isContract(), "SafeERC20: call to non-contract");
642 
643         
644         (bool success, bytes memory returndata) = address(token).call(data);
645         require(success, "SafeERC20: low-level call failed");
646 
647         if (returndata.length > 0) { 
648             
649             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
650         }
651     }
652 }
653 
654 contract CanReclaimTokens is Claimable {
655     using SafeERC20 for ERC20;
656 
657     mapping(address => bool) private recoverableTokensBlacklist;
658 
659     function initialize(address _nextOwner) public initializer {
660         Claimable.initialize(_nextOwner);
661     }
662 
663     function blacklistRecoverableToken(address _token) public onlyOwner {
664         recoverableTokensBlacklist[_token] = true;
665     }
666 
667     
668     
669     function recoverTokens(address _token) external onlyOwner {
670         require(
671             !recoverableTokensBlacklist[_token],
672             "CanReclaimTokens: token is not recoverable"
673         );
674 
675         if (_token == address(0x0)) {
676             msg.sender.transfer(address(this).balance);
677         } else {
678             ERC20(_token).safeTransfer(
679                 msg.sender,
680                 ERC20(_token).balanceOf(address(this))
681             );
682         }
683     }
684 }
685 
686 contract ERC20WithRate is Initializable, Ownable, ERC20 {
687     using SafeMath for uint256;
688 
689     uint256 public constant _rateScale = 1e18;
690     uint256 internal _rate;
691 
692     event LogRateChanged(uint256 indexed _rate);
693 
694     
695     function initialize(address _nextOwner, uint256 _initialRate)
696         public
697         initializer
698     {
699         Ownable.initialize(_nextOwner);
700         _setRate(_initialRate);
701     }
702 
703     function setExchangeRate(uint256 _nextRate) public onlyOwner {
704         _setRate(_nextRate);
705     }
706 
707     function exchangeRateCurrent() public view returns (uint256) {
708         require(_rate != 0, "ERC20WithRate: rate has not been initialized");
709         return _rate;
710     }
711 
712     function _setRate(uint256 _nextRate) internal {
713         require(_nextRate > 0, "ERC20WithRate: rate must be greater than zero");
714         _rate = _nextRate;
715     }
716 
717     function balanceOfUnderlying(address _account)
718         public
719         view
720         returns (uint256)
721     {
722         return toUnderlying(balanceOf(_account));
723     }
724 
725     function toUnderlying(uint256 _amount) public view returns (uint256) {
726         return _amount.mul(_rate).div(_rateScale);
727     }
728 
729     function fromUnderlying(uint256 _amountUnderlying)
730         public
731         view
732         returns (uint256)
733     {
734         return _amountUnderlying.mul(_rateScale).div(_rate);
735     }
736 }
737 
738 contract ERC20WithPermit is Initializable, ERC20, ERC20Detailed {
739     using SafeMath for uint256;
740 
741     mapping(address => uint256) public nonces;
742 
743     
744     
745     string public version;
746 
747     
748     bytes32 public DOMAIN_SEPARATOR;
749     
750     
751     bytes32
752         public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
753 
754     function initialize(
755         uint256 _chainId,
756         string memory _version,
757         string memory _name,
758         string memory _symbol,
759         uint8 _decimals
760     ) public initializer {
761         ERC20Detailed.initialize(_name, _symbol, _decimals);
762         version = _version;
763         DOMAIN_SEPARATOR = keccak256(
764             abi.encode(
765                 keccak256(
766                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
767                 ),
768                 keccak256(bytes(name())),
769                 keccak256(bytes(version)),
770                 _chainId,
771                 address(this)
772             )
773         );
774     }
775 
776     
777     function permit(
778         address holder,
779         address spender,
780         uint256 nonce,
781         uint256 expiry,
782         bool allowed,
783         uint8 v,
784         bytes32 r,
785         bytes32 s
786     ) external {
787         bytes32 digest = keccak256(
788             abi.encodePacked(
789                 "\x19\x01",
790                 DOMAIN_SEPARATOR,
791                 keccak256(
792                     abi.encode(
793                         PERMIT_TYPEHASH,
794                         holder,
795                         spender,
796                         nonce,
797                         expiry,
798                         allowed
799                     )
800                 )
801             )
802         );
803 
804         require(holder != address(0), "ERC20WithRate: address must not be 0x0");
805         require(
806             holder == ecrecover(digest, v, r, s),
807             "ERC20WithRate: invalid signature"
808         );
809         require(
810             expiry == 0 || now <= expiry,
811             "ERC20WithRate: permit has expired"
812         );
813         require(nonce == nonces[holder]++, "ERC20WithRate: invalid nonce");
814         uint256 amount = allowed ? uint256(-1) : 0;
815         _approve(holder, spender, amount);
816     }
817 }
818 
819 contract RenERC20LogicV1 is
820     Initializable,
821     ERC20,
822     ERC20Detailed,
823     ERC20WithRate,
824     ERC20WithPermit,
825     Claimable,
826     CanReclaimTokens
827 {
828     
829     function initialize(
830         uint256 _chainId,
831         address _nextOwner,
832         uint256 _initialRate,
833         string memory _version,
834         string memory _name,
835         string memory _symbol,
836         uint8 _decimals
837     ) public initializer {
838         ERC20Detailed.initialize(_name, _symbol, _decimals);
839         ERC20WithRate.initialize(_nextOwner, _initialRate);
840         ERC20WithPermit.initialize(
841             _chainId,
842             _version,
843             _name,
844             _symbol,
845             _decimals
846         );
847         Claimable.initialize(_nextOwner);
848         CanReclaimTokens.initialize(_nextOwner);
849     }
850 
851     
852     
853     function mint(address _to, uint256 _amount) public onlyOwner {
854         _mint(_to, _amount);
855     }
856 
857     
858     
859     function burn(address _from, uint256 _amount) public onlyOwner {
860         _burn(_from, _amount);
861     }
862 
863     function transfer(address recipient, uint256 amount) public returns (bool) {
864         
865         
866         
867         require(
868             recipient != address(this),
869             "RenERC20: can't transfer to token address"
870         );
871         return super.transfer(recipient, amount);
872     }
873 
874     function transferFrom(
875         address sender,
876         address recipient,
877         uint256 amount
878     ) public returns (bool) {
879         
880         
881         require(
882             recipient != address(this),
883             "RenERC20: can't transfer to token address"
884         );
885         return super.transferFrom(sender, recipient, amount);
886     }
887 }
888 
889 contract RenERC20Proxy is InitializableAdminUpgradeabilityProxy {
890 
891 }