1 pragma solidity ^0.5.0;
2 
3 
4 library ECRecovery {
5 
6   /**
7    * @dev Recover signer address from a message by using his signature
8    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
9    * @param sig bytes signature, the signature is generated using web3.eth.sign()
10    */
11   function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
12     bytes32 r;
13     bytes32 s;
14     uint8 v;
15 
16     //Check the signature length
17     if (sig.length != 65) {
18       return (address(0));
19     }
20 
21     // Divide the signature in r, s and v variables
22     assembly {
23       r := mload(add(sig, 32))
24       s := mload(add(sig, 64))
25       v := byte(0, mload(add(sig, 96)))
26     }
27 
28     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
29     if (v < 27) {
30       v += 27;
31     }
32 
33     // If the version is correct return the signer address
34     if (v != 27 && v != 28) {
35       return (address(0));
36     } else {
37       return ecrecover(hash, v, r, s);
38     }
39   }
40 } 
41 
42 
43 /**
44  * @title Roles
45  * @dev Library for managing addresses assigned to a Role.
46  */
47 library Roles {
48     struct Role {
49         mapping (address => bool) bearer;
50     }
51 
52     /**
53      * @dev Give an account access to this role.
54      */
55     function add(Role storage role, address account) internal {
56         require(!has(role, account), "Roles: account already has role");
57         role.bearer[account] = true;
58     }
59 
60     /**
61      * @dev Remove an account's access to this role.
62      */
63     function remove(Role storage role, address account) internal {
64         require(has(role, account), "Roles: account does not have role");
65         role.bearer[account] = false;
66     }
67 
68     /**
69      * @dev Check if an account has this role.
70      * @return bool
71      */
72     function has(Role storage role, address account) internal view returns (bool) {
73         require(account != address(0), "Roles: account is the zero address");
74         return role.bearer[account];
75     }
76 }
77 
78 
79 
80 library SafeMath {
81     /**
82      * @dev Multiplies two unsigned integers, reverts on overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Solidity only automatically asserts when dividing by 0
103         require(b > 0, "SafeMath: division by zero");
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     /**
111      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b <= a, "SafeMath: subtraction overflow");
115         uint256 c = a - b;
116 
117         return c;
118     }
119 
120     /**
121      * @dev Adds two unsigned integers, reverts on overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
132      * reverts when dividing by zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b != 0, "SafeMath: modulo by zero");
136         return a % b;
137     }
138 }
139 
140 
141 interface IERC20 {
142     function transfer(address to, uint256 value) external returns (bool);
143     function approve(address spender, uint256 value) external returns (bool);
144     function transferFrom(address from, address to, uint256 value) external returns (bool);
145     function totalSupply() external view returns (uint256);
146     function balanceOf(address who) external view returns (uint256);
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 contract ERC20 is IERC20 {
154     using SafeMath for uint256;
155     mapping (address => uint256) internal _balances;
156     mapping (address => mapping (address => uint256)) internal _allowances;
157     uint256 internal _totalSupply;
158 
159     constructor() internal {
160     }
161 
162     function totalSupply() public view returns (uint256) {
163         return _totalSupply;
164     }
165 
166     function balanceOf(address who) public view returns (uint256) {
167         return _balances[who];
168     }
169 
170     function allowance(address owner, address spender) public view returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function transfer(address to, uint256 value) public returns (bool) {
175         _transfer(msg.sender, to, value);
176         return true;
177     }
178 
179     function approve(address spender, uint256 value) public returns (bool) {
180         _approve(msg.sender, spender, value);
181         return true;
182     }
183 
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _transfer(from, to, value);
186         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
187         return true;
188     }
189 
190     function _transfer(address _from, address to, uint256 value) internal {
191         require(_from != address(0), "ERC20: transfer from the zero address");
192         require(to != address(0), "ERC20: transfer to the zero address");
193 
194         _balances[_from] = _balances[_from].sub(value);
195         _balances[to] = _balances[to].add(value);
196         emit Transfer(_from, to, value);
197     }
198 
199     function _approve(address owner, address spender, uint256 value) internal {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202 
203         _allowances[owner][spender] = value;
204         emit Approval(owner, spender, value);
205     }
206 
207 }
208 
209 contract Ownable {
210     address public owner;
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212     using SafeMath for uint256;
213     uint256 public startdate;
214 
215     constructor() internal {
216         owner = msg.sender;
217         startdate = now;
218     }
219 
220     modifier onlyOwner() {
221         require(msg.sender == owner,"Ownable: caller is not owner.");
222         _;
223     }
224 
225     function transferOwnership(address newOwner) public;
226 
227     function _transferOwnership(address newOwner) internal onlyOwner {
228         require(newOwner != address(0), "Ownable: address is zero.");
229         emit OwnershipTransferred(owner, newOwner);
230         owner = newOwner;
231     }
232 }
233 
234 contract MinterRole {
235     using Roles for Roles.Role;
236 
237     event MinterAdded(address indexed account);
238     event MinterRemoved(address indexed account);
239 
240     Roles.Role private _minters;
241 
242     constructor () internal {
243         _addMinter(msg.sender);
244     }
245 
246     modifier onlyMinter() {
247         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role.");
248         _;
249     }
250 
251     function isMinter(address account) public view returns (bool) {
252         return _minters.has(account);
253     }
254 
255     function renounceMinter() public;
256 
257     function _addMinter(address account) internal {
258         _minters.add(account);
259         emit MinterAdded(account);
260     }
261 
262     function _removeMinter(address account) internal {
263         _minters.remove(account);
264         emit MinterRemoved(account);
265     }
266 }
267 
268 contract Mintable is MinterRole{
269      uint256 private _cap;
270      event Mint(address indexed minter, address receiver, uint256 value);
271 
272     constructor (uint256 cap) internal {
273         require(cap > 0, "ERC20Capped: cap is 0");
274         _cap = cap;
275     }
276 
277     function renounceMinter() public;
278 
279     function addMinter(address minter) public;
280 
281     function removeMinter(address minter) public;
282 
283     function cap() public view returns (uint256) {
284         return _cap;
285     }
286 
287     function mint(address to, uint256 value) public onlyMinter returns (bool) {
288         _mint(to, value);
289         emit Mint(msg.sender, to, value);
290         return true;
291     }
292 
293     function _mint(address account, uint256 value) internal;
294 }
295 
296 contract Pausable {
297     event Paused(address account);
298     event Unpaused(address account);
299 
300     bool private _paused;
301 
302     constructor () internal {
303         _paused = false;
304     }
305 
306     function paused() public view returns (bool) {
307         return _paused;
308     }
309 
310     modifier whenNotPaused() {
311         require(!_paused, "Pausable: paused");
312         _;
313     }
314 
315     modifier whenPaused() {
316         require(_paused, "Pausable: not paused");
317         _;
318     }
319 
320     function _pause() internal whenNotPaused {
321         _paused = true;
322         emit Paused(msg.sender);
323     }
324 
325     function _unpause() internal whenPaused {
326         _paused = false;
327         emit Unpaused(msg.sender);
328     }
329 
330     function pause() public;
331     function unpause() public;
332 }
333 
334 contract Burnable {
335     event Burn(address burner, uint256 value);
336 
337     constructor () internal {}
338     function burn(address account, uint256 value) public;
339 
340     function _burn(address account, uint256 value) internal{
341         emit Burn(account, value);
342     }
343 }
344 
345 contract Lockable {
346     uint256 internal _totalLocked = 0;
347     event Lock(address beneficiary, uint256 amount, uint256 releaseTime);
348 
349     mapping(address => uint256) internal _lock_list_period;
350     mapping(address => bool) internal _lock_list;
351     mapping(address => uint256) internal _revocable;
352 
353     modifier notLocked() {
354         require(_lock_list[msg.sender] == true, "Lockable: sender address is locked.");
355         _;
356     }
357 
358     function totalLocked() public view returns (uint256){
359         return _totalLocked;
360     }
361 
362     function mintLockedToken(address addr, uint256 tokens, uint256 _duration) public;
363 
364     function releaseLockedToken() public returns (bool);
365 
366     function isLocked(address addr) public view returns (bool) {
367         return _lock_list[addr];
368     }
369 
370     function lockedPeriod(address addr) public view returns (uint256) {
371         return _lock_list_period[addr];
372     }
373 
374     function lockedBalance(address addr) public view returns (uint256) {
375         return _revocable[addr];
376     }
377 }
378 
379 contract DelegatorRole {
380     using Roles for Roles.Role;
381 
382     event DelegatorAdded(address indexed account);
383     event DelegatorRemoved(address indexed account);
384 
385     Roles.Role private _delegators;
386 
387     constructor () internal {
388         _addDelegator(msg.sender);
389     }
390 
391     modifier onlyDelegator() {
392         require(isDelegator(msg.sender), "DelegatorRole: caller does not have the Delegator role.");
393         _;
394     }
395 
396     function isDelegator(address account) public view returns (bool) {
397         return _delegators.has(account);
398     }
399 
400     function renounceDelegator() public;
401 
402     function _addDelegator(address account) internal {
403         _delegators.add(account);
404         emit DelegatorAdded(account);
405     }
406 
407     function _removeDelegator(address account) internal {
408         _delegators.remove(account);
409         emit DelegatorRemoved(account);
410     }
411 }
412 
413 contract Delegatable is DelegatorRole{
414     using ECRecovery for bytes32;
415     using SafeMath for uint;
416 
417     uint16 private _feeRate;
418     address private _feeCollector;
419     mapping(address => uint256) internal _nonces;
420     event Delegated(address delegator, address sender, address receiver, uint256 value, uint256 nonce);
421 
422     constructor () internal{
423         _feeRate = 10; //0.01%
424         _feeCollector = msg.sender;
425     }
426 
427     function setFeeRate(uint16 _rate) public;
428 
429     function setFeeCollector(address _collector) public;
430 
431     function addDelegator(address minter) public;
432 
433     function removeDelegator(address minter) public;
434 
435     function renounceDelegator() public;
436 
437     function _setFeeRate(uint16 _rate) internal{
438         _feeRate = _rate;
439     }
440 
441     function _setFeeCollector(address _collector) internal{
442         _feeCollector = _collector;
443     }
444 
445     function feeRate() public view returns (uint16){
446         return _feeRate;
447     }
448 
449     function feeCollector() public view returns (address){
450         return _feeCollector;
451     }
452 
453     function nonceOf(address _addr) public view returns (uint256 nonce){
454         return _nonces[_addr];
455     }
456 
457     function _delegatedTransfer(address _from, address _to, uint256 _value, uint256 _fee) internal returns(bool success);
458 
459     function delegatedTransfer(address _from, address _to, uint256 _value, uint256 _nonce, bytes calldata _signature) external onlyDelegator returns(bool success){
460         require(_nonce == nonceOf(_from), "Delegatable: nonce is not correct");
461 
462         bytes32 hash = keccak256(abi.encodePacked(
463             "\x19Ethereum Signed Message:\n32",
464             keccak256(abi.encodePacked(_from, _to, _value, _nonce)))
465         );
466         address sender = hash.recover(_signature);
467 
468         // fee
469         uint _fee = _value.mul(_feeRate).div(uint(100000));
470 
471         if(_from == sender){
472             if(_delegatedTransfer(_from, _to, _value, _fee)){
473                 uint256 newNonce = nonceOf(_from).add(uint256(1));
474                 _nonces[_from] = newNonce;
475                 emit Delegated(msg.sender, _from, _to, _value, newNonce);
476                 return true;
477             }
478             else{
479                 return false;
480             }
481         } else {
482             return false;
483         }
484     }
485 }
486 
487 contract TrustShoreToken is ERC20, Ownable, Mintable, Pausable, Burnable, Lockable, Delegatable{
488     string private _name = "TrustShore";
489     string private _symbol = "TST";
490     uint8 private _decimals = 18;
491 
492     constructor (uint256 cap) public Mintable(cap){
493     }
494 
495     function name() public view returns (string memory) {
496         return _name;
497     }
498 
499     function symbol() public view returns (string memory) {
500         return _symbol;
501     }
502 
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 
507     //Override Mintable
508     function _mint(address account, uint256 value) internal {
509         require(account != address(0), "Mintable: mint to the zero address.");
510         require(totalSupply().add(value).add(totalLocked()) <= cap(), "Mintable: cap exceeded.");
511 
512         _totalSupply = _totalSupply.add(value);
513         _balances[account] = _balances[account].add(value);
514         emit Transfer(address(0), account, value);
515     }
516 
517     function renounceMinter() public {
518         require(msg.sender != owner, "Mintable: Owner cannot renounce. Transfer owner first.");
519         super._removeMinter(msg.sender);
520     }
521 
522     function addMinter(address minter) public onlyOwner{
523         super._addMinter(minter);
524 
525     }
526 
527     function removeMinter(address minter) public onlyOwner{
528         super._removeMinter(minter);
529     }
530 
531     //Override Ownerble
532     function transferOwnership(address newOwner) public{
533         require(msg.sender == owner, "Ownable: only owner transfer ownership");
534         addMinter(newOwner);
535         addDelegator(newOwner);
536         removeMinter(owner);
537         removeDelegator(owner);
538         super._transferOwnership(newOwner);
539     }
540 
541     //Override Pausable
542     function pause() public onlyOwner {
543         require(!paused(), "Pausable: Already paused.");
544         super._pause();
545     }
546 
547     function unpause() public onlyOwner {
548         require(paused(), "Pausable: Not paused.");
549         super._unpause();
550     }
551 
552     function transfer(address to, uint256 value) public returns (bool) {
553         require(!paused(), "Pausable: token transfer is paused.");
554         super._transfer(msg.sender, to, value);
555         return true;
556     }
557 
558     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
559         require(value > 0, "transferFrom: value is must be greater than zero.");
560         require(balanceOf(from) >= value, "transferFrom: balance of from address is not enough");
561         require(_allowances[from][msg.sender] >= value, "transferFrom: sender are not allowed to send.");
562 
563         return super.transferFrom(from, to, value);
564     }
565 
566     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
567         return super.approve(spender, value);
568     }
569 
570     //Override Burnable
571     function burn(address account, uint256 value) public onlyOwner {
572         require(account != address(0), "Burnable: burn from the zero address");
573         require(_balances[account] >= value, "Burnable: not enough tokens");
574         _totalSupply = _totalSupply.sub(value);
575         _balances[account] = _balances[account].sub(value);
576         super._burn(account, value);
577         emit Transfer(account, address(0), value);
578     }
579 
580     //Apply SafeTransfer
581     function safeTransfer(address to, uint256 value) public {
582         require(!_isContract(to),"SafeTransfer: receiver is contract");
583         transfer(to,value);
584     }
585 
586     function safeTransferFrom(address from, address to, uint256 value) public {
587         require(!_isContract(from),"SafeTransfer: sender is contract");
588         require(!_isContract(to),"SafeTransfer: receiver is contract");
589         transferFrom(from, to, value);
590     }
591 
592     function safeApprove(address spender, uint256 value) public {
593         require(value != 0, "SafeTransfer: approve from non-zero to non-zero allowance");
594         require(!_isContract(spender),"SafeTransfer: spender is contract");
595         approve(spender, value);
596     }
597 
598     function _isContract(address _addr) private view returns (bool is_contract){
599         uint length;
600         assembly {
601             length := extcodesize(_addr)
602         }
603         return (length>0);
604     }
605 
606     //Override Lockable
607     function mintLockedToken(address addr, uint256 tokens, uint256 _duration) public {
608         require(msg.sender == owner, "Lockable: only owner can lock token ");
609         require(_totalSupply.add(totalLocked()).add(tokens) <= cap(), "Lockable: locked tokens can not exceed total cap.");
610         require(_lock_list[addr] == false, "Lockable: this address is already locked");
611 
612         uint256 releaseTime = block.timestamp.add(_duration.mul(1 minutes));
613 
614         //if(_lock_list[addr] == true) {
615         //    _totalLocked.sub(_revocable[addr]);
616         //}
617 
618         _lock_list_period[addr] = releaseTime;
619         _lock_list[addr] = true;
620         _revocable[addr] = tokens;
621         _totalLocked = _totalLocked.add(tokens);
622 
623         emit Lock(addr, tokens, releaseTime);
624     }
625 
626     function releaseLockedToken() public returns (bool) {
627         require(_lock_list[msg.sender] == true);
628         require(_revocable[msg.sender] > 0);
629 
630         uint256 releaseTime = _lock_list_period[msg.sender];
631         uint256 currentTime = block.timestamp;
632 
633         if(currentTime > releaseTime) {
634             uint256 tokens = _revocable[msg.sender];
635 
636             _lock_list_period[msg.sender] = 0;
637             _lock_list[msg.sender] = false;
638             _revocable[msg.sender] = 0;
639             _totalSupply = _totalSupply.add(tokens);
640             _balances[msg.sender] = _balances[msg.sender].add(tokens);
641             return true;
642         } else {
643             return false;
644         }
645     }
646 
647     //Override Delegatable
648     function setFeeRate(uint16 _rate) public{
649         require(msg.sender == owner, "Delegatable: only owner change the fee rate");
650         _setFeeRate(_rate);
651     }
652 
653     function setFeeCollector(address _collector) public{
654         require(msg.sender == owner, "Delegatable: only owner change the fee collector");
655         _setFeeCollector(_collector);
656     }
657 
658     function renounceDelegator() public {
659         require(msg.sender != owner, "Delegatable : Owner cannot renounce. Transfer owner first.");
660         super._removeDelegator(msg.sender);
661     }
662 
663     function _delegatedTransfer(address _from, address _to, uint256 _value, uint256 _fee) internal returns(bool success){
664         uint _amount = _value.add(_fee);
665 
666         if (balanceOf(_from) < _amount)
667             return false;
668         _balances[_from] = balanceOf(_from).sub(_amount);
669         _balances[_to] = balanceOf(_to).add(_value);
670         _balances[feeCollector()] = balanceOf(feeCollector()).add(_fee);
671         emit Transfer(_from, _to, _value);
672         emit Transfer(_from, feeCollector(), _fee);
673         return true;
674     }
675 
676     function addDelegator(address delegator) public onlyOwner{
677         super._addDelegator(delegator);
678 
679     }
680 
681     function removeDelegator(address delegator) public onlyOwner{
682         super._removeDelegator(delegator);
683     }
684 }