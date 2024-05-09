1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract ContractReceiver {
18 
19     struct TKN {
20         address sender;
21         uint value;
22         bytes data;
23         bytes4 sig;
24     }
25 
26     function tokenFallback(address _from, uint _value, bytes _data) public pure {
27         TKN memory tkn;
28         tkn.sender = _from;
29         tkn.value = _value;
30         tkn.data = _data;
31         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
32         tkn.sig = bytes4(u);
33 
34         /* tkn variable is analogue of msg variable of Ether transaction
35         *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
36         *  tkn.value the number of tokens that were sent   (analogue of msg.value)
37         *  tkn.data is data of token transaction   (analogue of msg.data)
38         *  tkn.sig is 4 bytes signature of function
39         *  if data of token transaction is a function execution
40         */
41     }
42 }
43 
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 contract CrowdsaleFront is Ownable{
80     //Crowdsale public provider;
81     using SafeMath for uint256;
82     mapping (address => uint256) internal userAmounts;
83     mapping (address => uint256) internal rewardPayed;
84     BwinCommons internal commons;
85     function setCommons(address _addr) public onlyOwner {
86         commons = BwinCommons(_addr);
87     }
88     // fallback function can be used to buy tokens
89     function () public payable {
90         buyTokens(msg.sender, 0, 999);
91     }
92 
93     // low level token purchase function
94     function buyTokens(address beneficiary, address _parent, uint256 _top) public payable returns(bool){
95       bool ret;
96       uint256 tokens;
97       (ret, tokens) = Crowdsale(commons.get("Crowdsale")).buyTokens.value(msg.value)(beneficiary, beneficiary, _parent, _top);
98       userAmounts[beneficiary] = userAmounts[beneficiary].add(tokens);
99       require(ret);
100     }
101 
102     function getTokensFromBuy(address _addr) public view returns (uint256){
103       return userAmounts[_addr];
104     }
105     function rewardPayedOf(address _user) public view returns (uint256) {
106       return rewardPayed[_user];
107     }
108     function rewardPay(address _user, uint256 amount) public {
109       require(msg.sender == commons.get("Crowdsale"));
110       rewardPayed[_user] = rewardPayed[_user].add(amount);
111     }
112 
113     // @return true if crowdsale event has ended
114     function hasEnded() public view returns (bool){
115         return Crowdsale(commons.get("Crowdsale")).hasEnded();
116     }
117 
118 }
119 
120 contract InterestHolder is Ownable{
121   using SafeMath for uint256;
122   BwinCommons internal commons;
123   function setCommons(address _addr) public onlyOwner {
124       commons = BwinCommons(_addr);
125   }
126   bool public locked = true;
127   event ReceiveBalanceUpdate(address _addr,address _user);
128   event ReceiveBalanceUpdateUserType(address _addr,address _user,uint256 _type);
129   function receiveBalanceUpdate(address _user) external returns (bool) {
130     emit ReceiveBalanceUpdate(msg.sender, _user);
131     Token token = Token(commons.get("Token"));
132     User user = User(commons.get("User"));
133     if (msg.sender == address(token)){
134       uint256 _type;
135       (,,_type) = user.getUserInfo(_user);
136       emit ReceiveBalanceUpdateUserType(msg.sender, _user, _type);
137       if (_type == 0){
138           return true;
139       }
140       process(_user,_type);
141       return true;
142     }
143     return false;
144   }
145   event ProcessLx(address _addr,address _user, uint256 _type,uint256 lastBalance, uint256 iAmount, uint256 lastTime);
146   function process(address _user, uint256 _type) internal{
147     Token token = Token(commons.get("Token"));
148     User user = User(commons.get("User"));
149     uint256 _value = compute(_user, _type);
150     uint256 balance = token.balanceOf(_user);
151     user.setInterestor(_user,balance.add(_value),now);
152     if(_value > 0){
153       token.mintForWorker(_user,_value);
154       emit ProcessLx(msg.sender, _user, _type, balance, _value, now);
155     }
156   }
157   event GetLx(address _addr,address _user,uint256 _type);
158 
159   function compute(address _user, uint256 _type) internal view returns (uint256) {
160     User user = User(commons.get("User"));
161     uint256 lastBalance = 0;
162     uint256 lastTime = 0;
163     bool exist;
164     (lastBalance,lastTime,exist) = user.getInterestor(_user);
165     uint256 _value = 0;
166     if (exist && lastTime > 0){
167         uint256 times = now.sub(lastTime);
168         if (_type == 1){
169             _value = lastBalance.div(10000).mul(5).div(86400).mul(times);
170         }else if(_type == 2){
171             _value = lastBalance.div(10000).mul(8).div(86400).mul(times);
172         }
173     }
174     return _value;
175   }
176   function getLx() external returns (uint256) {
177     User user = User(commons.get("User"));
178     uint256 _type;
179     (,,_type) = user.getUserInfo(msg.sender);
180     emit GetLx(msg.sender, msg.sender, _type);
181     if (_type == 0){
182         return 0;
183     }
184     return compute(msg.sender, _type);
185   }
186 }
187 
188 contract TokenHolder is Ownable{
189   using SafeMath for uint256;
190 
191   BwinCommons internal commons;
192   function setCommons(address _addr) public onlyOwner {
193       commons = BwinCommons(_addr);
194   }
195   bool locked = true;
196   mapping (address => uint256) lockedAmount;
197   event ReceiveLockedAmount(address _addr, address _user, uint256 _amount);
198   function receiveLockedAmount(address _user, uint256 _amount) external returns (bool) {
199     address cds = commons.get("Crowdsale");
200     if (msg.sender == address(cds)){
201       lockedAmount[_user] = lockedAmount[_user].add(_amount);
202       emit ReceiveLockedAmount(msg.sender, _user, _amount);
203       return true;
204     }
205     return false;
206   }
207 
208   function balanceOf(address _user) public view returns (uint256) {
209     return lockedAmount[_user];
210   }
211   function balance() public view returns (uint256) {
212     return lockedAmount[msg.sender];
213   }
214 
215   function setLock(bool _locked) public onlyOwner{
216     locked = _locked;
217   }
218 
219   function withDrawlocked() public view returns (bool) {
220       return locked;
221   }
222 
223   function withDrawable() public view returns (bool) {
224     User user = User(commons.get("User"));
225     uint256 _type;
226     (,,_type) = user.getUserInfo(msg.sender);
227     return !locked && (_type > 0) && lockedAmount[msg.sender] > 0;
228   }
229 
230   function withDraw() external {
231     assert(!locked);//用户必须是种子钱包
232     BwinToken token = BwinToken(commons.get("BwinToken"));
233     User user = User(commons.get("User"));
234     uint256 _type;
235     (,,_type) = user.getUserInfo(msg.sender);
236     assert(_type > 0);
237     uint _value = lockedAmount[msg.sender];
238     lockedAmount[msg.sender] = 0;
239     token.transfer(msg.sender,_value);
240   }
241 
242 }
243 
244 contract Destructible is Ownable {
245 
246   function Destructible() public payable { }
247 
248   /**
249    * @dev Transfers the current balance to the owner and terminates the contract.
250    */
251   function destroy() onlyOwner public {
252     selfdestruct(owner);
253   }
254 
255   function destroyAndSend(address _recipient) onlyOwner public {
256     selfdestruct(_recipient);
257   }
258 }
259 
260 contract EtherHolder is Destructible{
261   using SafeMath for uint256;
262   bool locked = false;
263 
264   BwinCommons internal commons;
265   function setCommons(address _addr) public onlyOwner {
266       commons = BwinCommons(_addr);
267   }
268   struct Account {
269     address wallet;
270     address parent;
271     uint256 radio;
272     bool exist;
273   }
274   mapping (address => uint256) private userAmounts;
275   uint256 internal _balance;
276   event ProcessFunds(address _topWallet, uint256 _value ,bool isContract);
277 
278   event ReceiveFunds(address _addr, address _user, uint256 _value, uint256 _amount);
279   function receiveFunds(address _user, uint256 _amount) external payable returns (bool) {
280     emit ReceiveFunds(msg.sender, _user, msg.value, _amount);
281     Crowdsale cds = Crowdsale(commons.get("Crowdsale"));
282     User user = User(commons.get("User"));
283     assert(msg.value == _amount);
284     if (msg.sender == address(cds)){
285         address _topWallet;
286         uint _percent=0;
287         bool _contract;
288         uint256 _topValue = 0;
289         bool _topOk;
290         uint256 _totalShares = 0;
291         uint256 _totalSharePercent = 0;
292         bool _shareRet;
293         if(user.hasUser(_user)){
294           (_topWallet,_percent,_contract) = user.getTopInfoDetail(_user);
295           assert(_percent <= 1000);
296           (_topValue,_topOk) = processFunds(_topWallet,_amount,_percent,_contract);
297         }else{
298           _topOk = true;
299         }
300         (_totalShares,_totalSharePercent,_shareRet) = processShares(_amount.sub(_topValue));
301         assert(_topOk && _shareRet);
302         assert(_topValue.add(_totalShares) <= _amount);
303         assert(_totalSharePercent <= 1000);
304         _balance = _balance.add(_amount);
305         return true;
306     }
307     return false;
308   }
309   event ProcessShares(uint256 _amount, uint i, uint256 _percent, bool _contract,address _wallet);
310   function processShares(uint256 _amount) internal returns(uint256,uint256,bool){
311       uint256 _sended = 0;
312       uint256 _sharePercent = 0;
313       User user = User(commons.get("User"));
314       for(uint i=0;i<user.getShareHolderCount();i++){
315         address _wallet;
316         uint256 _percent;
317         bool _contract;
318         emit ProcessShares(_amount, i, _percent, _contract,_wallet);
319         assert(_percent <= 1000);
320         (_wallet,_percent,_contract) = user.getShareHolder(i);
321         uint256 _value;
322         bool _valueOk;
323         (_value,_valueOk) = processFunds(_wallet,_amount,_percent,_contract);
324         _sharePercent = _sharePercent.add(_percent);
325         _sended = _sended.add(_value);
326       }
327       return (_sended,_sharePercent,true);
328   }
329   function getAmount(uint256 _amount, uint256 _percent) internal pure returns(uint256){
330       uint256 _value = _amount.div(1000).mul(_percent);
331       return _value;
332   }
333   function processFunds(address _topWallet, uint256 _amount ,uint256 _percent, bool isContract) internal returns(uint,bool) {
334       uint256 _value = getAmount(_amount, _percent);
335       userAmounts[_topWallet] = userAmounts[_topWallet].add(_value);
336       emit ProcessFunds(_topWallet,_value,isContract);
337       return (_value,true);
338   }
339 
340   function balanceOf(address _user) public view returns (uint256) {
341     return userAmounts[_user];
342   }
343 
344   function balanceOfme() public view returns (uint256) {
345     return userAmounts[msg.sender];
346   }
347 
348   function withDrawlocked() public view returns (bool) {
349       return locked;
350   }
351   function getBalance() public view returns (uint256, uint256) {
352     return (address(this).balance,_balance);
353   }
354   function lock(bool _locked) public onlyOwner{
355     locked = _locked;
356   }
357   event WithDraw(address caller, uint256 _amount);
358 
359   function withDraw(uint256 _amount) external {
360     assert(!locked);
361     assert(userAmounts[msg.sender] >= _amount);
362     userAmounts[msg.sender] = userAmounts[msg.sender].sub(_amount);
363     _balance = _balance.sub(_amount);
364     msg.sender.transfer(_amount);
365     emit WithDraw(msg.sender, _amount);
366   }
367   function destroy() onlyOwner public {
368     selfdestruct(owner);
369   }
370 }
371 
372 library SafeMath {
373 
374   /**
375   * @dev Multiplies two numbers, throws on overflow.
376   */
377   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378     if (a == 0) {
379       return 0;
380     }
381     uint256 c = a * b;
382     assert(c / a == b);
383     return c;
384   }
385 
386   /**
387   * @dev Integer division of two numbers, truncating the quotient.
388   */
389   function div(uint256 a, uint256 b) internal pure returns (uint256) {
390     // assert(b > 0); // Solidity automatically throws when dividing by 0
391     uint256 c = a / b;
392     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
393     return c;
394   }
395 
396   /**
397   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
398   */
399   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
400     assert(b <= a);
401     return a - b;
402   }
403 
404   /**
405   * @dev Adds two numbers, throws on overflow.
406   */
407   function add(uint256 a, uint256 b) internal pure returns (uint256) {
408     uint256 c = a + b;
409     assert(c >= a);
410     return c;
411   }
412 }
413 
414 contract RBAC {
415   using Roles for Roles.Role;
416 
417   mapping (string => Roles.Role) private roles;
418 
419   event RoleAdded(address addr, string roleName);
420   event RoleRemoved(address addr, string roleName);
421 
422   /**
423    * A constant role name for indicating admins.
424    */
425   string public constant ROLE_ADMIN = "admin";
426 
427   /**
428    * @dev constructor. Sets msg.sender as admin by default
429    */
430   function RBAC()
431     public
432   {
433     addRole(msg.sender, ROLE_ADMIN);
434   }
435 
436   /**
437    * @dev reverts if addr does not have role
438    * @param addr address
439    * @param roleName the name of the role
440    * // reverts
441    */
442   function checkRole(address addr, string roleName)
443     view
444     public
445   {
446     roles[roleName].check(addr);
447   }
448 
449   /**
450    * @dev determine if addr has role
451    * @param addr address
452    * @param roleName the name of the role
453    * @return bool
454    */
455   function hasRole(address addr, string roleName)
456     view
457     public
458     returns (bool)
459   {
460     return roles[roleName].has(addr);
461   }
462 
463   /**
464    * @dev add a role to an address
465    * @param addr address
466    * @param roleName the name of the role
467    */
468   function adminAddRole(address addr, string roleName)
469     onlyAdmin
470     public
471   {
472     addRole(addr, roleName);
473   }
474 
475   /**
476    * @dev remove a role from an address
477    * @param addr address
478    * @param roleName the name of the role
479    */
480   function adminRemoveRole(address addr, string roleName)
481     onlyAdmin
482     public
483   {
484     removeRole(addr, roleName);
485   }
486 
487   /**
488    * @dev add a role to an address
489    * @param addr address
490    * @param roleName the name of the role
491    */
492   function addRole(address addr, string roleName)
493     internal
494   {
495     roles[roleName].add(addr);
496     emit RoleAdded(addr, roleName);
497   }
498 
499   /**
500    * @dev remove a role from an address
501    * @param addr address
502    * @param roleName the name of the role
503    */
504   function removeRole(address addr, string roleName)
505     internal
506   {
507     roles[roleName].remove(addr);
508     emit RoleRemoved(addr, roleName);
509   }
510 
511   /**
512    * @dev modifier to scope access to a single role (uses msg.sender as addr)
513    * @param roleName the name of the role
514    * // reverts
515    */
516   modifier onlyRole(string roleName)
517   {
518     checkRole(msg.sender, roleName);
519     _;
520   }
521 
522   /**
523    * @dev modifier to scope access to admins
524    * // reverts
525    */
526   modifier onlyAdmin()
527   {
528     checkRole(msg.sender, ROLE_ADMIN);
529     _;
530   }
531 
532   /**
533    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
534    * @param roleNames the names of the roles to scope access to
535    * // reverts
536    *
537    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
538    *  see: https://github.com/ethereum/solidity/issues/2467
539    */
540   // modifier onlyRoles(string[] roleNames) {
541   //     bool hasAnyRole = false;
542   //     for (uint8 i = 0; i < roleNames.length; i++) {
543   //         if (hasRole(msg.sender, roleNames[i])) {
544   //             hasAnyRole = true;
545   //             break;
546   //         }
547   //     }
548 
549   //     require(hasAnyRole);
550 
551   //     _;
552   // }
553 }
554 
555 contract BwinCommons is RBAC, Destructible {
556     mapping (string => address) internal addresses;
557     mapping (address => string) internal names;
558 
559     event UpdateRegistration(string key, address old, address n);
560 
561     function register(string key, address ad) public onlyAdmin {
562         emit UpdateRegistration(key, addresses[key], ad);
563         addresses[key] = ad;
564         names[ad] = key;
565     }
566 
567     function get(string key) public view returns(address) {
568         return addresses[key];
569     }
570 
571     function remove() public {
572       string memory key = names[msg.sender];
573       delete addresses[key];
574       delete names[msg.sender];
575     }
576 }
577 
578 contract User is RBAC ,Destructible{
579     struct UserInfo {
580         //推荐人
581         address parent;
582         uint256 top;
583         bool exist;
584         uint256 userType;
585     }
586 
587     struct Partner {
588       address addr;
589       uint256 percent;
590       bool exist;
591       bool iscontract;
592     }
593 
594     struct UserBalance{
595         address user;
596         uint256 balance;
597         uint256 lastTime;
598         bool exist;
599     }
600     mapping (address => UserBalance) internal balanceForInterests;
601     uint256[] internal tops;
602     mapping (uint256 => Partner) internal topDefine;
603 
604     uint256[] internal shareHolders;
605     mapping (uint256 => Partner) internal shareHolderInfos;
606     mapping (address => UserInfo) internal tree;
607     BwinCommons internal commons;
608     function setCommons(address _addr) public onlyAdmin {
609         commons = BwinCommons(_addr);
610     }
611 
612 
613     address[] internal users;
614     event SetInterestor(address caller, address _user, uint256 _balance, uint256 _lastTime);
615     event SetShareHolders(address caller, uint256 topId, address _topAddr, uint256 _percent, bool iscontract);
616     event SetTop(address caller, uint256 topId, address _topAddr, uint256 _percent, bool iscontract);
617     event AddUser(address caller, address _parent, uint256 _top);
618     event SetUser(address caller, address _user, address _parent, uint256 _top, uint256 _type);
619     event SetUserType(address caller, address _user, uint _type);
620     event RemoveUser(address caller, uint _index);
621 
622     function setInterestor(address _user, uint256 _balance, uint256 _lastTime) public onlyRole("INTEREST_HOLDER"){
623         balanceForInterests[_user] = UserBalance(_user,_balance,_lastTime,true);
624         emit SetInterestor(msg.sender,_user,_balance,_lastTime);
625     }
626 
627     function getInterestor(address _user) public view returns(uint256,uint256,bool){
628         return (balanceForInterests[_user].balance,balanceForInterests[_user].lastTime,balanceForInterests[_user].exist);
629     }
630     function setShareHolders(uint256 topId, address _topAddr, uint256 _percent, bool iscontract) public onlyAdmin {
631         if (!shareHolderInfos[topId].exist){
632           shareHolders.push(topId);
633         }
634         shareHolderInfos[topId] = Partner(_topAddr, _percent, true, iscontract);
635         emit SetShareHolders(msg.sender,topId,_topAddr,_percent,iscontract);
636     }
637     function getShareHolder(uint256 _index) public view returns(address, uint256, bool){
638         uint256 shareHolderId = shareHolders[_index];
639         return getShareHoldersInfo(shareHolderId);
640     }
641     function getShareHolderCount() public view returns(uint256){
642         return shareHolders.length;
643     }
644     function getShareHoldersInfo(uint256 shareHolderId) public view returns(address, uint256, bool){
645       return (shareHolderInfos[shareHolderId].addr, shareHolderInfos[shareHolderId].percent, shareHolderInfos[shareHolderId].iscontract);
646     }
647 
648     function setTop(uint256 topId, address _topAddr, uint256 _percent, bool iscontract) public onlyAdmin {
649         if (!topDefine[topId].exist){
650           tops.push(topId);
651         }
652         topDefine[topId] = Partner(_topAddr, _percent, true, iscontract);
653         emit SetTop(msg.sender, topId, _topAddr, _percent, iscontract);
654     }
655     function getTopInfoDetail(address _user) public view returns(address, uint256, bool){
656         uint256 _topId;
657         address _wallet;
658         uint256 _percent;
659         bool _contract;
660         (,_topId,) = getUserInfo(_user);
661         (_wallet,_percent,_contract) = getTopInfo(_topId);
662         return (_wallet,_percent,_contract);
663     }
664     function getTopInfo(uint256 topId) public view returns(address, uint256, bool){
665       return (topDefine[topId].addr, topDefine[topId].percent, topDefine[topId].iscontract);
666     }
667     function addUser(address _parent, uint256 _top) public {
668         require(msg.sender != _parent);
669         if (_parent != address(0)) {
670             require(tree[_parent].exist);
671         }
672         require(!hasUser(msg.sender));
673         tree[msg.sender] = UserInfo(_parent, _top, true, 0);
674         users.push(msg.sender);
675         emit AddUser(msg.sender, _parent, _top);
676     }
677 
678     function getUsersCount() public view returns(uint) {
679         return users.length;
680     }
681 
682     function getUserInfo(address _user) public view returns(address, uint256, uint256) {
683         return (tree[_user].parent, tree[_user].top, tree[_user].userType);
684     }
685 
686     function hasUser(address _user) public view returns(bool) {
687         return tree[_user].exist;
688     }
689 
690     function setUser(address _user, address _parent, uint256 _top, uint256 _type) public onlyAdmin {
691       if(!tree[_user].exist){
692         users.push(_user);
693       }
694       tree[_user] = UserInfo(_parent, _top, true, _type);
695       emit SetUser(msg.sender, _user, _parent, _top, _type);
696     }
697 
698     function setUserType(address _user, uint _type) public onlyAdmin {
699         require(hasUser(_user));
700         tree[_user].userType = _type;
701         emit SetUserType(msg.sender, _user, _type);
702     }
703     function indexOfUserInfo(uint _index) public view returns (address) {
704         return users[_index];
705     }
706 
707     function removeUser(uint _index) public onlyAdmin {
708         address _user = indexOfUserInfo(_index);
709         delete users[_index];
710         delete tree[_user];
711         emit RemoveUser(msg.sender, _index);
712     }
713 }
714 
715 contract Pausable is RBAC {
716   event Pause();
717   event Unpause();
718 
719   bool public paused = false;
720 
721 
722   /**
723    * @dev Modifier to make a function callable only when the contract is not paused.
724    */
725   modifier whenNotPaused() {
726     require(!paused);
727     _;
728   }
729 
730   /**
731    * @dev Modifier to make a function callable only when the contract is paused.
732    */
733   modifier whenPaused() {
734     require(paused);
735     _;
736   }
737 
738   /**
739    * @dev called by the owner to pause, triggers stopped state
740    */
741   function pause() onlyAdmin whenNotPaused public {
742     paused = true;
743     emit Pause();
744   }
745 
746   /**
747    * @dev called by the owner to unpause, returns to normal state
748    */
749   function unpause() onlyAdmin whenPaused public {
750     paused = false;
751     emit Unpause();
752   }
753 }
754 
755 contract BwinToken is ERC20, Pausable, Destructible{
756     //Token t;
757 
758     BwinCommons internal commons;
759     function setCommons(address _addr) public onlyOwner {
760         commons = BwinCommons(_addr);
761     }
762     string public constant name = "FFgame Coin";
763     string public constant symbol = "FFC";
764     uint8 public constant decimals = 18;
765     event Transfer(address indexed from, address indexed to, uint256 value);
766     function BwinToken() public {
767       addRole(msg.sender, ROLE_ADMIN);
768     }
769     function totalSupply() public view returns (uint256){
770       Token t = Token(commons.get("Token"));
771       return t.totalSupply();
772     }
773     function balanceOf(address who) public view returns (uint256){
774       Token t = Token(commons.get("Token"));
775       return t.balanceOf(who);
776     }
777     function transfer(address to, uint256 value) public returns (bool){
778       bytes memory empty;
779       Token t = Token(commons.get("Token"));
780       if(t.transfer(msg.sender, to, value,empty)){
781           emit Transfer(msg.sender, to, value);
782           return true;
783       }
784       return false;
785     }
786 
787 
788     function allowance(address owner, address spender) public view returns (uint256){
789       Token t = Token(commons.get("Token"));
790       return t.allowance(owner, spender);
791     }
792     function transferFrom(address from, address to, uint256 value) public returns (bool){
793       Token t = Token(commons.get("Token"));
794       if(t._transferFrom(msg.sender, from, to, value)){
795           emit Transfer(from, to, value);
796           return true;
797       }
798       return false;
799     }
800     function approve(address spender, uint256 value) public returns (bool){
801       Token t = Token(commons.get("Token"));
802       if (t._approve(msg.sender, spender, value)){
803           emit Approval(msg.sender, spender, value);
804           return true;
805       }
806       return false;
807     }
808 
809     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
810       Token t = Token(commons.get("Token"));
811       if(t._increaseApproval(msg.sender, _spender, _addedValue)){
812           emit Approval(msg.sender, _spender, _addedValue);
813           return true;
814       }
815       return false;
816     }
817 
818     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
819       Token t = Token(commons.get("Token"));
820       if (t._decreaseApproval(msg.sender,_spender, _subtractedValue)){
821           emit Approval(msg.sender, _spender, _subtractedValue);
822           return true;
823       }
824       return false;
825     }
826     event Approval(address indexed owner, address indexed spender, uint256 value);
827 
828 }
829 
830 contract Token is RBAC, Pausable{
831     using SafeMath for uint256;
832 
833     BwinCommons internal commons;
834     function setCommons(address _addr) public onlyAdmin {
835         commons = BwinCommons(_addr);
836     }
837     event TokenApproval(address indexed owner, address indexed spender, uint256 value);
838     event TokenTransfer(address indexed from, address indexed to, uint256 value);
839     event MintForSale(address indexed to, uint256 amount);
840     event MintForWorker(address indexed to, uint256 amount);
841     event MintForUnlock(address indexed to, uint256 amount);
842 
843     function Token() public {
844         addRole(msg.sender, ROLE_ADMIN);
845     }
846 
847     function totalSupply() public view returns (uint256) {
848       TokenData td = TokenData(commons.get("TokenData"));
849       return td.totalSupply();
850     }
851     function balanceOf(address _owner) public view returns (uint256) {
852       TokenData td = TokenData(commons.get("TokenData"));
853       return td.balanceOf(_owner);
854     }
855     function _transferFrom(address _sender, address _from, address _to, uint256 _value) external whenNotPaused onlyRole("FRONT_TOKEN_USER") returns (bool) {
856       InterestHolder ih = InterestHolder(commons.get("InterestHolder"));
857       TokenData td = TokenData(commons.get("TokenData"));
858       uint256 _balanceFrom = balanceOf(_from);
859       uint256 _balanceTo = balanceOf(_to);
860       uint256 _allow = allowance(_from, _sender);
861       require(_from != address(0));
862       require(_sender != address(0));
863       require(_to != address(0));
864       require(_value <= _balanceFrom);
865       require(_value <= _allow);
866       td.setBalance(_from,_balanceFrom.sub(_value));
867       td.setBalance(_to,_balanceTo.add(_value));
868       td.setAllowance(_from, _sender, _allow.sub(_value));
869       if(ih != address(0)){
870         ih.receiveBalanceUpdate(_from);
871         ih.receiveBalanceUpdate(_to);
872       }
873       emit TokenTransfer(_from, _to, _value);
874       return true;
875     }
876 
877     function allowance(address _owner, address _spender) public view returns (uint256) {
878       TokenData td = TokenData(commons.get("TokenData"));
879       return td.allowance(_owner,_spender);
880     }
881     function _approve(address _sender, address _spender, uint256 _value) public onlyRole("FRONT_TOKEN_USER")  whenNotPaused returns (bool) {
882       TokenData td = TokenData(commons.get("TokenData"));
883       return td.setAllowance(_sender, _spender, _value);
884     }
885     function _increaseApproval(address _sender, address _spender, uint _addedValue) public onlyRole("FRONT_TOKEN_USER") whenNotPaused returns (bool) {
886       TokenData td = TokenData(commons.get("TokenData"));
887       td.setAllowance(_sender, _spender, allowance(_sender, _spender).add(_addedValue));
888       emit TokenApproval(_sender, _spender, allowance(_sender, _spender));
889       return true;
890     }
891     function _decreaseApproval(address _sender, address _spender, uint _subtractedValue) public onlyRole("FRONT_TOKEN_USER") whenNotPaused returns (bool) {
892       TokenData td = TokenData(commons.get("TokenData"));
893       uint oldValue = allowance(_sender, _spender);
894       if (_subtractedValue > oldValue) {
895           td.setAllowance(_sender, _spender, 0);
896           //allowed[msg.sender][_spender] = 0;
897       } else {
898           td.setAllowance(_sender, _spender, oldValue.sub(_subtractedValue));
899           //allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
900       }
901       emit TokenApproval(_sender, _spender, allowance(_sender, _spender));
902       return true;
903     }
904 
905     function unlockAmount(address _to, uint256 _amount) external onlyAdmin returns (bool){
906       TokenData td = TokenData(commons.get("TokenData"));
907       require(td.totalSupply().add(_amount) <= td.TotalCapacity());
908       uint256 unlockedAmount = td.valueOf("unlockedAmount");
909       if(_mint(_to, _amount)){
910           td.setValue("unlockedAmount",unlockedAmount.add(_amount));
911           emit MintForUnlock(_to, _amount);
912           return true;
913       }
914       return false;
915     }
916 
917     function _mint(address _to, uint256 _amount) internal returns (bool) {
918       TokenData td = TokenData(commons.get("TokenData"));
919       InterestHolder ih = InterestHolder(commons.get("InterestHolder"));
920       require(_to != address(0));
921       require(_amount > 0);
922       uint256 totalMinted = td.valueOf("totalMinted");
923       td.setTotal(td.totalSupply().add(_amount));
924       td.setBalance(_to,balanceOf(_to).add(_amount));
925       td.setValue("totalMinted",totalMinted.add(_amount));
926       if(address(ih) != address(0)){
927         ih.receiveBalanceUpdate(_to);
928       }
929       return true;
930     }
931 
932     function mintForSale(address _to, uint256 _amount) external onlyRole("TOKEN_SALE") whenNotPaused returns (bool) {
933       TokenData td = TokenData(commons.get("TokenData"));
934       require(td.totalSupply().add(_amount) <= td.TotalCapacity());
935       uint256 saledAmount = td.valueOf("saledAmount");
936       if(_mint(_to, _amount)){
937           td.setValue("saledAmount",saledAmount.add(_amount));
938           emit MintForSale(_to, _amount);
939           return true;
940       }
941       return false;
942     }
943     function mintForWorker(address _to, uint256 _amount) external onlyRole("TOKEN_WORKER") whenNotPaused returns (bool) {
944       TokenData td = TokenData(commons.get("TokenData"));
945       require(td.totalSupply().add(_amount) <= td.TotalCapacity());
946       uint256 minedAmount = td.valueOf("minedAmount");
947       if(_mint(_to, _amount)){
948         td.setValue("minedAmount",minedAmount.add(_amount));
949         emit MintForWorker(_to, _amount);
950         return true;
951       }
952       return false;
953     }
954     function transfer(address _from, address _to, uint _value, bytes _data) external whenNotPaused onlyRole("FRONT_TOKEN_USER")  returns (bool success) {
955 
956         if (isContract(_to)) {
957             return transferToContract(_from, _to, _value, _data);
958         }else {
959             return transferToAddress(_from, _to, _value);
960         }
961     }
962     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
963     function isContract(address _addr) internal view returns (bool) {
964         uint length;
965         assembly {
966             //retrieve the size of the code on target address, this needs assembly
967             length := extcodesize(_addr)
968         }
969         return (length > 0);
970     }
971     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
972       TokenData td = TokenData(commons.get("TokenData"));
973       InterestHolder ih = InterestHolder(commons.get("InterestHolder"));
974       require(_to != address(0));
975       require(_value <= balanceOf(_from));
976       td.setBalance(_from,balanceOf(_from).sub(_value));
977       td.setBalance(_to,balanceOf(_to).add(_value));
978       if(ih != address(0)){
979         ih.receiveBalanceUpdate(_from);
980         ih.receiveBalanceUpdate(_to);
981       }
982       emit TokenTransfer(_from, _to, _value);
983       return true;
984     }
985 
986     //function that is called when transaction target is an address
987     function transferToAddress(address _from, address _to, uint _value) internal returns (bool success) {
988         require(balanceOf(_from) >= _value);
989         require(_transfer(_from, _to, _value));
990         emit TokenTransfer(_from, _to, _value);
991         return true;
992     }
993 
994     //function that is called when transaction target is a contract
995     function transferToContract(address _from, address _to, uint _value, bytes _data) internal returns (bool success) {
996         require(balanceOf(_from) >= _value);
997         require(_transfer(_from, _to, _value));
998         ContractReceiver receiver = ContractReceiver(_to);
999         receiver.tokenFallback(msg.sender, _value, _data);
1000         emit TokenTransfer(msg.sender, _to, _value);
1001         return true;
1002     }
1003 
1004 
1005 
1006 }
1007 
1008 contract TokenData is RBAC, Pausable{
1009   //using SafeMath for uint256;
1010   event TokenDataBalance(address sender, address indexed addr, uint256 value);
1011   event TokenDataAllowance(address sender, address indexed from, address indexed to, uint256 value);
1012   event SetTotalSupply(address _addr, uint256 _total);
1013   mapping(address => uint256) internal balances;
1014   mapping(string => uint256) internal values;
1015 
1016   mapping (address => mapping (address => uint256)) internal allowed;
1017 
1018   address[] internal users;
1019 
1020   uint256 internal totalSupply_;
1021   uint256 internal totalCapacity_;
1022 
1023   string internal  name_;
1024   string internal  symbol_;
1025   uint8 internal  decimals_;
1026   function TokenData(uint256 _totalSupply, uint256 _totalCapacity) public {
1027     addRole(msg.sender, ROLE_ADMIN);
1028     totalSupply_ = _totalSupply;
1029     totalCapacity_ = _totalCapacity;
1030   }
1031 
1032   BwinCommons internal commons;
1033   function setCommons(address _addr) public onlyAdmin {
1034       commons = BwinCommons(_addr);
1035   }
1036   function setTotal(uint256 _total) public onlyRole("TOKEN_DATA_USER") {
1037       totalSupply_ = _total;
1038       emit SetTotalSupply(msg.sender, _total);
1039   }
1040   event SetValue(address _addr, string name, uint256 _value);
1041 
1042   function setValue(string name, uint256 _value) external onlyRole("TOKEN_DATA_USER") {
1043       values[name] = _value;
1044       emit SetValue(msg.sender, name, _value);
1045   }
1046 
1047   event SetTotalCapacity(address _addr, uint256 _total);
1048 
1049   function setTotalCapacity(uint256 _total) external onlyRole("TOKEN_DATA_USER") {
1050       totalCapacity_ = _total;
1051       emit SetTotalCapacity(msg.sender, _total);
1052   }
1053 
1054   function valueOf(string _name) public view returns(uint256){
1055       return values[_name];
1056   }
1057 
1058 
1059   function TotalCapacity() public view returns (uint256) {
1060     return totalCapacity_;
1061   }
1062 
1063   function totalSupply() public view returns (uint256) {
1064     return totalSupply_;
1065   }
1066 
1067 
1068 
1069   function balanceOf(address _owner) public view returns (uint256) {
1070     return balances[_owner];
1071   }
1072 
1073   function allowance(address _owner, address _spender) public view returns (uint256) {
1074     return allowed[_owner][_spender];
1075   }
1076 
1077 
1078 
1079   function setBalance(address _addr, uint256 _value) external whenNotPaused onlyRole("TOKEN_DATA_USER") returns (bool) {
1080     return _setBalance(_addr, _value);
1081   }
1082   function setAllowance(address _from, address _to, uint256 _value) external whenNotPaused onlyRole("TOKEN_DATA_USER") returns (bool) {
1083     return _setAllowance(_from, _to, _value);
1084   }
1085 
1086   function setBalanceAdmin(address _addr, uint256 _value) external onlyAdmin returns (bool) {
1087     return _setBalance(_addr, _value);
1088   }
1089   function setAllowanceAdmin(address _from, address _to, uint256 _value) external onlyAdmin returns (bool) {
1090     return _setAllowance(_from, _to, _value);
1091   }
1092 
1093   function _setBalance(address _addr, uint256 _value) internal returns (bool) {
1094     require(_addr != address(0));
1095     require(_value >= 0);
1096     balances[_addr] = _value;
1097     emit TokenDataBalance(msg.sender, _addr, _value);
1098     return true;
1099   }
1100   function _setAllowance(address _from, address _to, uint256 _value) internal returns (bool) {
1101     require(_from != address(0));
1102     require(_to != address(0));
1103     require(_value >= 0);
1104     allowed[_from][_to] = _value;
1105     emit TokenDataAllowance(msg.sender, _from, _to, _value);
1106     return true;
1107   }
1108 }
1109 
1110 contract Crowdsale is Ownable, Pausable{
1111   using SafeMath for uint256;
1112   uint256 public startTime;
1113   uint256 public endTime;
1114   uint256 public saleCapacity;
1115   uint256 public saledAmount;
1116   uint256 public rate;
1117   uint256 public weiRaised;
1118   event TokenPurchase(address payor, address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1119   BwinCommons internal commons;
1120   function setCommons(address _addr) public onlyOwner {
1121       commons = BwinCommons(_addr);
1122   }
1123   function buyTokens(address payor, address beneficiary, address _parent, uint256 _top) public  payable returns(bool, uint256);
1124   function hasEnded() public view returns (bool){
1125       return (now > endTime || saledAmount >= saleCapacity);
1126   }
1127   modifier onlyFront() {
1128       require(msg.sender == address(commons.get("CrowdsaleFront")));
1129       _;
1130   }
1131   function validPurchase() internal view returns (bool) {
1132       bool withinPeriod = now >= startTime && now <= endTime;
1133       bool withinCapacity = saledAmount <= saleCapacity;
1134       return withinPeriod && withinCapacity;
1135   }
1136 
1137   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
1138       return weiAmount.mul(rate);
1139   }
1140 }
1141 
1142 library Roles {
1143   struct Role {
1144     mapping (address => bool) bearer;
1145   }
1146 
1147   /**
1148    * @dev give an address access to this role
1149    */
1150   function add(Role storage role, address addr)
1151     internal
1152   {
1153     role.bearer[addr] = true;
1154   }
1155 
1156   /**
1157    * @dev remove an address' access to this role
1158    */
1159   function remove(Role storage role, address addr)
1160     internal
1161   {
1162     role.bearer[addr] = false;
1163   }
1164 
1165   /**
1166    * @dev check if an address has this role
1167    * // reverts
1168    */
1169   function check(Role storage role, address addr)
1170     view
1171     internal
1172   {
1173     require(has(role, addr));
1174   }
1175 
1176   /**
1177    * @dev check if an address has this role
1178    * @return bool
1179    */
1180   function has(Role storage role, address addr)
1181     view
1182     internal
1183     returns (bool)
1184   {
1185     return role.bearer[addr];
1186   }
1187 }