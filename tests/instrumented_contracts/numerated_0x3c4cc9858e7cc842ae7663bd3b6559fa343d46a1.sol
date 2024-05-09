1 pragma solidity ^0.5.0;
2 
3 library ECRecovery {
4 
5   /**
6    * @dev Recover signer address from a message by using his signature
7    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
8    * @param sig bytes signature, the signature is generated using web3.eth.sign()
9    */
10   function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
11     bytes32 r;
12     bytes32 s;
13     uint8 v;
14 
15     //Check the signature length
16     if (sig.length != 65) {
17       return (address(0));
18     }
19 
20     // Divide the signature in r, s and v variables
21     assembly {
22       r := mload(add(sig, 32))
23       s := mload(add(sig, 64))
24       v := byte(0, mload(add(sig, 96)))
25     }
26 
27     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
28     if (v < 27) {
29       v += 27;
30     }
31 
32     // If the version is correct return the signer address
33     if (v != 27 && v != 28) {
34       return (address(0));
35     } else {
36       return ecrecover(hash, v, r, s);
37     }
38   }
39 }
40 
41 library SafeMath {
42     /**
43      * @dev Multiplies two unsigned integers, reverts on overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61      */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0, "SafeMath: division by zero");
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a, "SafeMath: subtraction overflow");
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Adds two unsigned integers, reverts on overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93      * reverts when dividing by zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0, "SafeMath: modulo by zero");
97         return a % b;
98     }
99 }
100 
101 /**
102  * @title Roles
103  * @dev Library for managing addresses assigned to a Role.
104  */
105 library Roles {
106     struct Role {
107         mapping (address => bool) bearer;
108     }
109 
110     /**
111      * @dev Give an account access to this role.
112      */
113     function add(Role storage role, address account) internal {
114         require(!has(role, account), "Roles: account already has role");
115         role.bearer[account] = true;
116     }
117 
118     /**
119      * @dev Remove an account's access to this role.
120      */
121     function remove(Role storage role, address account) internal {
122         require(has(role, account), "Roles: account does not have role");
123         role.bearer[account] = false;
124     }
125 
126     /**
127      * @dev Check if an account has this role.
128      * @return bool
129      */
130     function has(Role storage role, address account) internal view returns (bool) {
131         require(account != address(0), "Roles: account is the zero address");
132         return role.bearer[account];
133     }
134 }
135 
136 interface IERC20 {
137     function transfer(address to, uint256 value) external returns (bool);
138     function approve(address spender, uint256 value) external returns (bool);
139     function transferFrom(address from, address to, uint256 value) external returns (bool);
140     function totalSupply() external view returns (uint256);
141     function balanceOf(address who) external view returns (uint256);
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     event Transfer(address indexed from, address indexed to, uint256 value);
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 contract ERC20 is IERC20 {
149     using SafeMath for uint256;
150     mapping (address => uint256) internal _balances;
151     mapping (address => mapping (address => uint256)) internal _allowances;
152     uint256 internal _totalSupply;
153     
154     constructor() internal {
155     }
156 
157     function totalSupply() public view returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address who) public view returns (uint256) {
162         return _balances[who];
163     }
164 
165     function allowance(address owner, address spender) public view returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function transfer(address to, uint256 value) public returns (bool) {
170         _transfer(msg.sender, to, value);
171         return true;
172     }
173 
174     function approve(address spender, uint256 value) public returns (bool) {
175         _approve(msg.sender, spender, value);
176         return true;
177     }
178 
179     function transferFrom(address from, address to, uint256 value) public returns (bool) {
180         _transfer(from, to, value);
181         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
182         return true;
183     }
184 
185     function _transfer(address _from, address to, uint256 value) internal {
186         require(_from != address(0), "ERC20: transfer from the zero address");
187         require(to != address(0), "ERC20: transfer to the zero address");
188 
189         _balances[_from] = _balances[_from].sub(value);
190         _balances[to] = _balances[to].add(value);
191         emit Transfer(_from, to, value);
192     }
193 
194     function _approve(address owner, address spender, uint256 value) internal {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197 
198         _allowances[owner][spender] = value;
199         emit Approval(owner, spender, value);
200     }
201 
202 }
203 
204 contract Ownable {
205     address public owner;
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207     using SafeMath for uint256;
208     uint256 public startdate;
209 
210     constructor() internal {
211         owner = msg.sender;
212         startdate = now;
213     }
214     
215     modifier onlyOwner() {
216         require(msg.sender == owner,"Ownerble: caller is not owner.");
217         _;
218     }
219 
220     function transferOwnership(address newOwner) public;
221 
222     function _transferOwnership(address newOwner) internal onlyOwner {
223         require(newOwner != address(0), "Ownerble: address is zero.");
224         emit OwnershipTransferred(owner, newOwner);
225         owner = newOwner;
226     }
227 }
228 
229 contract MinterRole {
230     using Roles for Roles.Role;
231 
232     event MinterAdded(address indexed account);
233     event MinterRemoved(address indexed account);
234 
235     Roles.Role private _minters;
236 
237     constructor () internal {
238         _addMinter(msg.sender);
239     }
240 
241     modifier onlyMinter() {
242         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role.");
243         _;
244     }
245 
246     function isMinter(address account) public view returns (bool) {
247         return _minters.has(account);
248     }
249 
250     function renounceMinter() public;
251 
252     function _addMinter(address account) internal {
253         _minters.add(account);
254         emit MinterAdded(account);
255     }
256 
257     function _removeMinter(address account) internal {
258         _minters.remove(account);
259         emit MinterRemoved(account);
260     }
261 }
262 
263 contract Mintable is MinterRole{
264      uint256 private _cap;
265      event Mint(address indexed minter, address receiver, uint256 value);
266     
267     constructor (uint256 cap) internal {
268         require(cap > 0, "ERC20Capped: cap is 0");
269         _cap = cap;
270     }
271 
272     function renounceMinter() public;
273 
274     function addMinter(address minter) public;
275 
276     function removeMinter(address minter) public;
277 
278     function cap() public view returns (uint256) {
279         return _cap;
280     }
281     
282     function mint(address to, uint256 value) public onlyMinter returns (bool) {
283         _mint(to, value);
284         emit Mint(msg.sender, to, value);
285         return true;
286     }
287     
288     function _mint(address account, uint256 value) internal;
289 }
290 
291 contract Pausable {
292     event Paused(address account);
293     event Unpaused(address account);
294 
295     bool private _paused;
296 
297     constructor () internal {
298         _paused = false;
299     }
300 
301     function paused() public view returns (bool) {
302         return _paused;
303     }
304 
305     modifier whenNotPaused() {
306         require(!_paused, "Pausable: paused");
307         _;
308     }
309 
310     modifier whenPaused() {
311         require(_paused, "Pausable: not paused");
312         _;
313     }
314 
315     function _pause() internal whenNotPaused {
316         _paused = true;
317         emit Paused(msg.sender);
318     }
319 
320     function _unpause() internal whenPaused {
321         _paused = false;
322         emit Unpaused(msg.sender);
323     }
324     
325     function pause() public;
326     function unpause() public;
327 }
328 
329 contract Burnable {
330     event Burn(address burner, uint256 value);
331 
332     constructor () internal {}
333     function burn(address account, uint256 value) public;
334 
335     function _burn(address account, uint256 value) internal{
336         emit Burn(account, value);
337     }
338 }
339 
340 contract Lockable {
341     uint256 internal _totalLocked = 0;
342     event Lock(address beneficiary, uint256 amount, uint256 releaseTime);
343     
344     mapping(address => uint256) internal _lock_list_period;
345     mapping(address => bool) internal _lock_list;
346     mapping(address => uint256) internal _revocable;
347     
348     modifier notLocked() {
349         require(_lock_list[msg.sender] == true, "Lockable: sender address is locked.");
350         _;
351     }
352     
353     function totalLocked() public view returns (uint256){
354         return _totalLocked;
355     }
356     
357     function mintLockedToken(address addr, uint256 tokens, uint256 _duration) public;
358     
359     function releaseLockedToken() public returns (bool);
360     
361     function isLocked(address addr) public view returns (bool) {
362         return _lock_list[addr];
363     }
364     
365     function lockedPeriod(address addr) public view returns (uint256) {
366         return _lock_list_period[addr];
367     }
368     
369     function lockedBalance(address addr) public view returns (uint256) {
370         return _revocable[addr];
371     }
372 }
373 
374 contract DelegatorRole {
375     using Roles for Roles.Role;
376 
377     event DelegatorAdded(address indexed account);
378     event DelegatorRemoved(address indexed account);
379 
380     Roles.Role private _delegators;
381 
382     constructor () internal {
383         _addDelegator(msg.sender);
384     }
385 
386     modifier onlyDelegator() {
387         require(isDelegator(msg.sender), "DelegatorRole: caller does not have the Delegator role.");
388         _;
389     }
390 
391     function isDelegator(address account) public view returns (bool) {
392         return _delegators.has(account);
393     }
394 
395     function renounceDelegator() public;
396 
397     function _addDelegator(address account) internal {
398         _delegators.add(account);
399         emit DelegatorAdded(account);
400     }
401 
402     function _removeDelegator(address account) internal {
403         _delegators.remove(account);
404         emit DelegatorRemoved(account);
405     }
406 }
407 
408 contract Delegatable is DelegatorRole{
409     using ECRecovery for bytes32;
410     using SafeMath for uint;
411 
412     uint16 private _feeRate;
413     address private _feeCollector;
414     mapping(address => uint256) internal _nonces;
415     event Delegated(address delegator, address sender, address receiver, uint256 value, uint256 nonce);
416 
417     constructor () internal{
418         _feeRate = 10; //0.01%
419         _feeCollector = msg.sender;
420     }
421 
422     function setFeeRate(uint16 _rate) public;
423 
424     function setFeeCollector(address _collector) public;
425 
426     function addDelegator(address minter) public;
427 
428     function removeDelegator(address minter) public;
429 
430     function renounceDelegator() public;
431 
432     function _setFeeRate(uint16 _rate) internal{
433         _feeRate = _rate;
434     }
435 
436     function _setFeeCollector(address _collector) internal{
437         _feeCollector = _collector;
438     }
439 
440     function feeRate() public view returns (uint16){
441         return _feeRate;
442     }
443 
444     function feeCollector() public view returns (address){
445         return _feeCollector;
446     }
447 
448     function nonceOf(address _addr) public view returns (uint256 nonce){
449         return _nonces[_addr];
450     }
451 
452     function _delegatedTransfer(address _from, address _to, uint256 _value, uint256 _fee) internal returns(bool success);
453 
454     function delegatedTransfer(address _from, address _to, uint256 _value, uint256 _nonce, bytes calldata _signature) external onlyDelegator returns(bool success){
455         require(_nonce == nonceOf(_from), "Delegatable: nonce is not correct");
456 
457         bytes32 hash = keccak256(abi.encodePacked(
458             "\x19Ethereum Signed Message:\n32",
459             keccak256(abi.encodePacked(_from, _to, _value, _nonce)))
460         );
461         address sender = hash.recover(_signature);
462 
463         // fee
464         uint _fee = _value.mul(_feeRate).div(uint(100000));
465         
466         if(_from == sender){
467             if(_delegatedTransfer(_from, _to, _value, _fee)){
468                 uint256 newNonce = nonceOf(_from).add(uint256(1));
469                 _nonces[_from] = newNonce;
470                 emit Delegated(msg.sender, _from, _to, _value, newNonce);
471                 return true;
472             }
473             else{
474                 return false;
475             }
476         } else {
477             return false;
478         }
479     }
480 }
481 
482 contract TrancheToken is ERC20, Ownable, Mintable, Pausable, Burnable, Lockable, Delegatable{
483     string private _name;
484     string private _symbol;
485     uint8 private _decimals = 18;
486 
487     constructor (string memory name, string memory symbol, uint256 cap) public Mintable(cap){
488         _name = name;
489         _symbol = symbol;
490     }
491     
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503     
504     //Override Mintable
505     function _mint(address account, uint256 value) internal {
506         require(account != address(0), "Mintable: mint to the zero address.");
507         require(totalSupply().add(value).add(totalLocked()) <= cap(), "Mintable: cap exceeded.");
508 
509         _totalSupply = _totalSupply.add(value);
510         _balances[account] = _balances[account].add(value);
511         emit Transfer(address(0), account, value);
512     }
513     
514     function renounceMinter() public {
515         require(msg.sender != owner, "Mintable: Owner cannot renounce. Transfer owner first.");
516         super._removeMinter(msg.sender);
517     }
518  
519     function addMinter(address minter) public onlyOwner{
520         super._addMinter(minter);
521 
522     }
523     
524     function removeMinter(address minter) public onlyOwner{
525         super._removeMinter(minter);
526     }
527     
528     //Override Ownerble
529     function transferOwnership(address newOwner) public{
530         require(msg.sender == owner, "Ownerble: only owner transfer ownership");
531         addMinter(newOwner);
532         addDelegator(newOwner);
533         removeMinter(owner);
534         removeDelegator(owner);
535         super._transferOwnership(newOwner);
536     }
537 
538     //Override Pausable
539     function pause() public onlyOwner {
540         require(!paused(), "Pausable: Already paused.");
541         super._pause();
542     }
543 
544     function unpause() public onlyOwner {
545         require(paused(), "Pausable: Not paused.");
546         super._unpause();
547     }
548 
549     function transfer(address to, uint256 value) public returns (bool) {
550         require(!paused(), "Pausable: token transfer is paused.");
551         super._transfer(msg.sender, to, value);
552         return true;
553     }
554 
555     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
556         require(value > 0, "transferFrom: value is must be greater than zero.");
557         require(balanceOf(from) >= value, "transferFrom: balance of from address is not enough");
558         require(_allowances[from][msg.sender] >= value, "transferFrom: sender are not allowed to send.");
559         
560         return super.transferFrom(from, to, value);
561     }
562 
563     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
564         return super.approve(spender, value);
565     }
566 
567     //Override Burnable
568     function burn(address account, uint256 value) public onlyOwner {
569         require(account != address(0), "Burnable: burn from the zero address");
570         require(_balances[account] >= value, "Burnable: not enought tokens");
571         _totalSupply = _totalSupply.sub(value);
572         _balances[account] = _balances[account].sub(value);
573         super._burn(account, value);
574         emit Transfer(account, address(0), value);
575     }
576     
577     //Apply SafeTransfer
578     function safeTransfer(address to, uint256 value) public {
579         require(!_isContract(to),"SafeTransfer: receiver is contreact");
580         transfer(to,value);
581     }
582 
583     function safeTransferFrom(address from, address to, uint256 value) public {
584         require(!_isContract(from),"SafeTransfer: sender is contract");
585         require(!_isContract(to),"SafeTransfer: receiver is contract");
586         transferFrom(from, to, value);
587     }
588 
589     function safeApprove(address spender, uint256 value) public {
590         require(value != 0, "SafeTransfer: approve from non-zero to non-zero allowance");
591         require(!_isContract(spender),"SafeTransfer: spender is contract");
592         approve(spender, value);
593     }
594 
595     function _isContract(address _addr) private view returns (bool is_contract){
596         uint length;
597         assembly {
598             length := extcodesize(_addr)
599         }
600         return (length>0);
601     }
602 
603     //Override Lockable
604     function mintLockedToken(address addr, uint256 tokens, uint256 _duration) public {
605         require(msg.sender == owner, "Lockable: only owner can lock token ");
606         require(_totalSupply.add(totalLocked()).add(tokens) <= cap(), "Lockable: locked tokens can not exceed total cap.");
607         require(_lock_list[addr] == false, "Lockable: this address is already locked");
608         
609         uint256 releaseTime = block.timestamp.add(_duration.mul(1 minutes));
610         
611         //if(_lock_list[addr] == true) {
612         //    _totalLocked.sub(_revocable[addr]);
613         //}
614         
615         _lock_list_period[addr] = releaseTime;
616         _lock_list[addr] = true;
617         _revocable[addr] = tokens;
618         _totalLocked = _totalLocked.add(tokens);
619         
620         emit Lock(addr, tokens, releaseTime);
621     }
622     
623     function releaseLockedToken() public returns (bool) {
624         require(_lock_list[msg.sender] == true);
625         require(_revocable[msg.sender] > 0);
626         
627         uint256 releaseTime = _lock_list_period[msg.sender];
628         uint256 currentTime = block.timestamp;
629         
630         if(currentTime > releaseTime) {
631             uint256 tokens = _revocable[msg.sender];
632             
633             _lock_list_period[msg.sender] = 0;
634             _lock_list[msg.sender] = false;
635             _revocable[msg.sender] = 0;
636             _totalSupply = _totalSupply.add(tokens);
637             _balances[msg.sender] = _balances[msg.sender].add(tokens);
638             return true;
639         } else {
640             return false;
641         }
642     }
643 
644     //Override Delegatable
645     function setFeeRate(uint16 _rate) public{
646         require(msg.sender == owner, "Delegatable: only owner change the fee rate");
647         _setFeeRate(_rate);
648     }
649 
650     function setFeeCollector(address _collector) public{
651         require(msg.sender == owner, "Delegatable: only owner change the fee collector");
652         _setFeeCollector(_collector);
653     }
654 
655     function renounceDelegator() public {
656         require(msg.sender != owner, "Delegatable : Owner cannot renounce. Transfer owner first.");
657         super._removeDelegator(msg.sender);
658     }
659 
660     function _delegatedTransfer(address _from, address _to, uint256 _value, uint256 _fee) internal returns(bool success){
661         uint _amount = _value.add(_fee);
662 
663         if (balanceOf(_from) < _amount)
664             return false;
665         _balances[_from] = balanceOf(_from).sub(_amount);
666         _balances[_to] = balanceOf(_to).add(_value);
667         _balances[feeCollector()] = balanceOf(feeCollector()).add(_fee);
668         emit Transfer(_from, _to, _value);
669         emit Transfer(_from, feeCollector(), _fee);
670         return true;
671     }
672 
673     function addDelegator(address delegator) public onlyOwner{
674         super._addDelegator(delegator);
675 
676     }
677     
678     function removeDelegator(address delegator) public onlyOwner{
679         super._removeDelegator(delegator);
680     }
681 }