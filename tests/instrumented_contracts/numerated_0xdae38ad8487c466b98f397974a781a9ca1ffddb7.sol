1 pragma solidity 0.4.24;
2 
3 library AddressSet {
4 
5     struct Instance {
6         address[] list;
7         mapping(address => uint256) idx; // actually stores indexes incremented by 1
8     }
9 
10     function push(Instance storage self, address addr) internal returns (bool) {
11         if (self.idx[addr] != 0) return false;
12         self.idx[addr] = self.list.push(addr);
13         return true;
14     }
15 
16     function sizeOf(Instance storage self) internal view returns (uint256) {
17         return self.list.length;
18     }
19 
20     function getAddress(Instance storage self, uint256 index) internal view returns (address) {
21         return (index < self.list.length) ? self.list[index] : address(0);
22     }
23 
24     function remove(Instance storage self, address addr) internal returns (bool) {
25         if (self.idx[addr] == 0) return false;
26         uint256 idx = self.idx[addr];
27         delete self.idx[addr];
28         if (self.list.length == idx) {
29             self.list.length--;
30         } else {
31             address last = self.list[self.list.length-1];
32             self.list.length--;
33             self.list[idx-1] = last;
34             self.idx[last] = idx;
35         }
36         return true;
37     }
38 }
39 
40 contract ERC20 {
41     function totalSupply() external view returns (uint256 _totalSupply);
42     function balanceOf(address _owner) external view returns (uint256 balance);
43     function transfer(address _to, uint256 _value) external returns (bool success);
44     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
45     function approve(address _spender, uint256 _value) external returns (bool success);
46     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 library SafeMath {
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 contract UHCToken is ERC20 {
79     using SafeMath for uint256;
80     using AddressSet for AddressSet.Instance;
81 
82     address public owner;
83     address public subowner;
84 
85     bool    public              paused         = false;
86     bool    public              contractEnable = true;
87 
88     string  public              name = "UHC";
89     string  public              symbol = "UHC";
90     uint8   public              decimals = 4;
91     uint256 private             summarySupply;
92     uint8   public              transferFeePercent = 3;
93     uint8   public              refererFeePercent = 1;
94 
95     struct account{
96         uint256 balance;
97         uint8 group;
98         uint8 status;
99         address referer;
100         bool isBlocked;
101     }
102 
103     mapping(address => account)                      private   accounts;
104     mapping(address => mapping (address => uint256)) private   allowed;
105     mapping(bytes => address)                        private   promos;
106 
107     AddressSet.Instance                             private   holders;
108 
109     struct groupPolicy {
110         uint8 _default;
111         uint8 _backend;
112         uint8 _admin;
113         uint8 _owner;
114     }
115 
116     groupPolicy public groupPolicyInstance = groupPolicy(0, 3, 4, 9);
117 
118     event EvGroupChanged(address indexed _address, uint8 _oldgroup, uint8 _newgroup);
119     event EvMigration(address indexed _address, uint256 _balance, uint256 _secret);
120     event EvUpdateStatus(address indexed _address, uint8 _oldstatus, uint8 _newstatus);
121     event EvSetReferer(address indexed _referal, address _referer);
122     event SwitchPause(bool isPaused);
123 
124     constructor (string _name, string _symbol, uint8 _decimals,uint256 _summarySupply, uint8 _transferFeePercent, uint8 _refererFeePercent) public {
125         require(_refererFeePercent < _transferFeePercent);
126         owner = msg.sender;
127 
128         accounts[owner] = account(_summarySupply,groupPolicyInstance._owner,3, address(0), false);
129 
130         holders.push(msg.sender);
131         name = _name;
132         symbol = _symbol;
133         decimals = _decimals;
134         summarySupply = _summarySupply;
135         transferFeePercent = _transferFeePercent;
136         refererFeePercent = _refererFeePercent;
137         emit Transfer(address(0), msg.sender, _summarySupply);
138     }
139 
140     modifier minGroup(int _require) {
141         require(accounts[msg.sender].group >= _require);
142         _;
143     }
144 
145     modifier onlySubowner() {
146         require(msg.sender == subowner);
147         _;
148     }
149 
150     modifier whenNotPaused() {
151         require(!paused || accounts[msg.sender].group >= groupPolicyInstance._backend);
152         _;
153     }
154 
155     modifier whenPaused() {
156         require(paused);
157         _;
158     }
159 
160     modifier whenNotMigrating {
161         require(contractEnable);
162         _;
163     }
164 
165     modifier whenMigrating {
166         require(!contractEnable);
167         _;
168     }
169 
170     function servicePause() minGroup(groupPolicyInstance._admin) whenNotPaused public {
171         paused = true;
172         emit SwitchPause(paused);
173     }
174 
175     function serviceUnpause() minGroup(groupPolicyInstance._admin) whenPaused public {
176         paused = false;
177         emit SwitchPause(paused);
178     }
179 
180     function serviceGroupChange(address _address, uint8 _group) minGroup(groupPolicyInstance._admin) external returns(uint8) {
181         require(_address != address(0));
182         require(_group <= groupPolicyInstance._admin);
183 
184         uint8 old = accounts[_address].group;
185         require(old < accounts[msg.sender].group);
186 
187         accounts[_address].group = _group;
188         emit EvGroupChanged(_address, old, _group);
189 
190         return accounts[_address].group;
191     }
192 
193     function serviceTransferOwnership(address newOwner) minGroup(groupPolicyInstance._owner) external {
194         require(newOwner != address(0));
195 
196         subowner = newOwner;
197     }
198 
199     function serviceClaimOwnership() onlySubowner() external {
200         address temp = owner;
201         uint256 value = accounts[owner].balance;
202 
203         accounts[owner].balance = accounts[owner].balance.sub(value);
204         holders.remove(owner);
205         accounts[msg.sender].balance = accounts[msg.sender].balance.add(value);
206         holders.push(msg.sender);
207 
208         owner = msg.sender;
209         subowner = address(0);
210 
211         delete accounts[temp].group;
212         uint8 oldGroup = accounts[msg.sender].group;
213         accounts[msg.sender].group = groupPolicyInstance._owner;
214 
215         emit EvGroupChanged(msg.sender, oldGroup, groupPolicyInstance._owner);
216         emit Transfer(temp, owner, value);
217     }
218 
219     function serviceSwitchTransferAbility(address _address) external minGroup(groupPolicyInstance._admin) returns(bool) {
220         require(accounts[_address].group < accounts[msg.sender].group);
221 
222         accounts[_address].isBlocked = !accounts[_address].isBlocked;
223 
224         return true;
225     }
226 
227     function serviceUpdateTransferFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {
228         require(newFee < 100);
229         require(newFee > refererFeePercent);
230         transferFeePercent = newFee;
231     }
232 
233     function serviceUpdateRefererFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {
234         require(newFee < 100);
235         require(transferFeePercent > newFee);
236         refererFeePercent = newFee;
237     }
238 
239     function serviceSetPromo(bytes num, address _address) external minGroup(groupPolicyInstance._admin) {
240         promos[num] = _address;
241     }
242 
243     function backendSetStatus(address _address, uint8 status) external minGroup(groupPolicyInstance._backend) returns(bool){
244         require(_address != address(0));
245         require(status >= 0 && status <= 4);
246         uint8 oldStatus = accounts[_address].status;
247         accounts[_address].status = status;
248 
249         emit EvUpdateStatus(_address, oldStatus, status);
250 
251         return true;
252     }
253 
254     function backendSetReferer(address _referal, address _referer) external minGroup(groupPolicyInstance._backend) returns(bool) {
255         require(accounts[_referal].referer == address(0));
256         require(_referal != address(0));
257         require(_referal != _referer);
258         require(accounts[_referal].referer != _referer);
259 
260         accounts[_referal].referer = _referer;
261 
262         emit EvSetReferer(_referal, _referer);
263 
264         return true;
265     }
266 
267     function backendSendBonus(address _to, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(bool) {
268         require(_to != address(0));
269         require(_value > 0);
270         require(accounts[owner].balance >= _value);
271 
272         accounts[owner].balance = accounts[owner].balance.sub(_value);
273         accounts[_to].balance = accounts[_to].balance.add(_value);
274 
275         emit Transfer(owner, _to, _value);
276 
277         return true;
278     }
279 
280     function backendRefund(address _from, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(uint256 balance) {
281         require(_from != address(0));
282         require(_value > 0);
283         require(accounts[_from].balance >= _value);
284  
285         accounts[_from].balance = accounts[_from].balance.sub(_value);
286         accounts[owner].balance = accounts[owner].balance.add(_value);
287         if(accounts[_from].balance == 0){
288             holders.remove(_from);
289         }
290         emit Transfer(_from, owner, _value);
291         return accounts[_from].balance;
292     }
293 
294     function getGroup(address _check) external view returns(uint8 _group) {
295         return accounts[_check].group;
296     }
297 
298     function getHoldersLength() external view returns(uint256){
299         return holders.sizeOf();
300     }
301 
302     function getHolderByIndex(uint256 _index) external view returns(address){
303         return holders.getAddress(_index);
304     }
305 
306     function getPromoAddress(bytes _promo) external view returns(address) {
307         return promos[_promo];
308     }
309 
310     function getAddressTransferAbility(address _check) external view returns(bool) {
311         return !accounts[_check].isBlocked;
312     }
313 
314     function transfer(address _to, uint256 _value) external returns (bool success) {
315         return _transfer(msg.sender, _to, address(0), _value);
316     }
317 
318     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
319         return _transfer(_from, _to, msg.sender, _value);
320     }
321 
322     function _transfer(address _from, address _to, address _allow, uint256 _value) minGroup(groupPolicyInstance._default) whenNotMigrating whenNotPaused internal returns(bool) {
323         require(!accounts[_from].isBlocked);
324         require(_from != address(0));
325         require(_to != address(0));
326         uint256 transferFee = accounts[_from].group == 0 ? _value.div(100).mul(accounts[_from].referer == address(0) ? transferFeePercent : transferFeePercent - refererFeePercent) : 0;
327         uint256 transferRefererFee = accounts[_from].referer == address(0) || accounts[_from].group != 0 ? 0 : _value.div(100).mul(refererFeePercent);
328         uint256 summaryValue = _value.add(transferFee).add(transferRefererFee);
329         require(accounts[_from].balance >= summaryValue);
330         require(_allow == address(0) || allowed[_from][_allow] >= summaryValue);
331 
332         accounts[_from].balance = accounts[_from].balance.sub(summaryValue);
333         if(_allow != address(0)) {
334             allowed[_from][_allow] = allowed[_from][_allow].sub(summaryValue);
335         }
336 
337         if(accounts[_from].balance == 0){
338             holders.remove(_from);
339         }
340         accounts[_to].balance = accounts[_to].balance.add(_value);
341         holders.push(_to);
342         emit Transfer(_from, _to, _value);
343 
344         if(transferFee > 0) {
345             accounts[owner].balance = accounts[owner].balance.add(transferFee);
346             emit Transfer(_from, owner, transferFee);
347         }
348 
349         if(transferRefererFee > 0) {
350             accounts[accounts[_from].referer].balance = accounts[accounts[_from].referer].balance.add(transferRefererFee);
351             holders.push(accounts[_from].referer);
352             emit Transfer(_from, accounts[_from].referer, transferRefererFee);
353         }
354         return true;
355     }
356 
357     function approve(address _spender, uint256 _value) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool success) {
358         require (_value == 0 || allowed[msg.sender][_spender] == 0);
359         require(_spender != address(0));
360 
361         allowed[msg.sender][_spender] = _value;
362         emit Approval(msg.sender, _spender, _value);
363         return true;
364     }
365 
366     function increaseApproval(address _spender, uint256 _addedValue) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool)
367     {
368         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
369         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
370         return true;
371     }
372 
373     function decreaseApproval(address _spender, uint256 _subtractedValue) minGroup(groupPolicyInstance._default) whenNotPaused external returns (bool)
374     {
375         uint256 oldValue = allowed[msg.sender][_spender];
376         if (_subtractedValue > oldValue) {
377             allowed[msg.sender][_spender] = 0;
378         } else {
379             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
380         }
381         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
382         return true;
383     }
384 
385     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
386         return allowed[_owner][_spender];
387     }
388 
389     function balanceOf(address _owner) external view returns (uint256 balance) {
390         return accounts[_owner].balance;
391     }
392 
393     function statusOf(address _owner) external view returns (uint8) {
394         return accounts[_owner].status;
395     }
396 
397     function refererOf(address _owner) external constant returns (address) {
398         return accounts[_owner].referer;
399     }
400 
401     function totalSupply() external constant returns (uint256 _totalSupply) {
402         _totalSupply = summarySupply;
403     }
404 
405     function settingsSwitchState() external minGroup(groupPolicyInstance._owner) returns (bool state) {
406 
407         contractEnable = !contractEnable;
408 
409         return contractEnable;
410     }
411 
412     function userMigration(uint256 _secret) external whenMigrating returns (bool successful) {
413         uint256 balance = accounts[msg.sender].balance;
414 
415         require (balance > 0);
416 
417         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(balance);
418         holders.remove(msg.sender);
419         accounts[owner].balance = accounts[owner].balance.add(balance);
420         holders.push(owner);
421         emit EvMigration(msg.sender, balance, _secret);
422         emit Transfer(msg.sender, owner, balance);
423         return true;
424     }
425 }
426 
427 contract EtherReceiver {
428 
429     using SafeMath for uint256;
430 
431     uint256 public      startTime;
432     uint256 public      durationOfStatusSell;
433     uint256 public      weiPerMinToken;
434     uint256 public      softcap;
435     uint256 public      totalSold;
436     uint8   public      referalBonusPercent;
437     uint8   public      refererFeePercent;
438 
439     uint256 public      refundStageStartTime;
440     uint256 public      maxRefundStageDuration;
441 
442     mapping(uint256 => uint256) public      soldOnVersion;
443     mapping(address => uint8)   private     group;
444 
445     uint256 public     version;
446     uint256 public      etherTotal;
447 
448     bool    public     isActive = false;
449     
450     struct Account{
451         // Hack to save gas
452         // if > 0 then value + 1
453         uint256 spent;
454         uint256 allTokens;
455         uint256 statusTokens;
456         uint256 version;
457         // if > 0 then value + 1
458         uint256 versionTokens;
459         // if > 0 then value + 1
460         uint256 versionStatusTokens;
461         // if > 0 then value + 1
462         uint256 versionRefererTokens;
463         uint8 versionBeforeStatus;
464     }
465 
466     mapping(address => Account) public accounts;
467 
468     struct groupPolicy {
469         uint8 _backend;
470         uint8 _admin;
471     }
472 
473     groupPolicy public groupPolicyInstance = groupPolicy(3,4);
474 
475     uint256[4] public statusMinBorders;
476 
477     UHCToken public            token;
478 
479     event EvAccountPurchase(address indexed _address, uint256 _newspent, uint256 _newtokens, uint256 _totalsold);
480     //Используем на бекенде для возврата BTC по версии
481     event EvWithdraw(address indexed _address, uint256 _spent, uint256 _version);
482     event EvSwitchActivate(address indexed _switcher, bool _isActivate);
483     event EvSellStatusToken(address indexed _owner, uint256 _oldtokens, uint256 _newtokens);
484     event EvUpdateVersion(address indexed _owner, uint256 _version);
485     event EvGroupChanged(address _address, uint8 _oldgroup, uint8 _newgroup);
486 
487     constructor (
488         address _token,
489         uint256 _startTime,
490         uint256 _weiPerMinToken, 
491         uint256 _softcap,
492         uint256 _durationOfStatusSell,
493         uint[4] _statusMinBorders, 
494         uint8 _referalBonusPercent, 
495         uint8 _refererFeePercent,
496         uint256 _maxRefundStageDuration,
497         bool _activate
498     ) public
499     {
500         token = UHCToken(_token);
501         startTime = _startTime;
502         weiPerMinToken = _weiPerMinToken;
503         softcap = _softcap;
504         durationOfStatusSell = _durationOfStatusSell;
505         statusMinBorders = _statusMinBorders;
506         referalBonusPercent = _referalBonusPercent;
507         refererFeePercent = _refererFeePercent;
508         maxRefundStageDuration = _maxRefundStageDuration;
509         isActive = _activate;
510         group[msg.sender] = groupPolicyInstance._admin;
511     }
512 
513     modifier onlyOwner(){
514         require(msg.sender == token.owner());
515         _;
516     }
517 
518     modifier saleIsOn() {
519         require(now > startTime && isActive && soldOnVersion[version] < softcap);
520         _;
521     }
522 
523     modifier minGroup(int _require) {
524         require(group[msg.sender] >= _require || msg.sender == token.owner());
525         _;
526     }
527 
528     function refresh(
529         uint256 _startTime, 
530         uint256 _softcap,
531         uint256 _durationOfStatusSell,
532         uint[4] _statusMinBorders,
533         uint8 _referalBonusPercent, 
534         uint8 _refererFeePercent,
535         uint256 _maxRefundStageDuration,
536         bool _activate
537     ) 
538         external
539         minGroup(groupPolicyInstance._admin) 
540     {
541         require(!isActive && etherTotal == 0);
542         startTime = _startTime;
543         softcap = _softcap;
544         durationOfStatusSell = _durationOfStatusSell;
545         statusMinBorders = _statusMinBorders;
546         referalBonusPercent = _referalBonusPercent;
547         refererFeePercent = _refererFeePercent;
548         version = version.add(1);
549         maxRefundStageDuration = _maxRefundStageDuration;
550         isActive = _activate;
551 
552         refundStageStartTime = 0;
553 
554         emit EvUpdateVersion(msg.sender, version);
555     }
556 
557     function transfer(address _to, uint256 _value) external minGroup(groupPolicyInstance._backend) saleIsOn() {
558         token.transfer( _to, _value);
559 
560         updateAccountInfo(_to, 0, _value);
561 
562         address referer = token.refererOf(_to);
563         trySendBonuses(_to, referer, _value);
564     }
565 
566     function withdraw() external minGroup(groupPolicyInstance._admin) returns(bool success) {
567         require(!isActive && (soldOnVersion[version] >= softcap || now > refundStageStartTime + maxRefundStageDuration));
568         uint256 contractBalance = address(this).balance;
569         token.owner().transfer(contractBalance);
570         etherTotal = 0;
571 
572         return true;
573     }
574 
575     function activateVersion(bool _isActive) external minGroup(groupPolicyInstance._admin) {
576         require(isActive != _isActive);
577         isActive = _isActive;
578         refundStageStartTime = isActive ? 0 : now;
579         emit EvSwitchActivate(msg.sender, isActive);
580     }
581 
582     function setWeiPerMinToken(uint256 _weiPerMinToken) external minGroup(groupPolicyInstance._backend)  {
583         require (_weiPerMinToken > 0);
584 
585         weiPerMinToken = _weiPerMinToken;
586     }
587 
588     function refund() external {
589         require(!isActive && soldOnVersion[version] < softcap && now <= refundStageStartTime + maxRefundStageDuration);
590 
591         tryUpdateVersion(msg.sender);
592 
593         Account storage account = accounts[msg.sender];
594 
595         require(account.spent > 1);
596 
597         uint256 value = account.spent.sub(1);
598         account.spent = 1;
599         etherTotal = etherTotal.sub(value);
600         
601         msg.sender.transfer(value);
602 
603         if(account.versionTokens > 0) {
604             token.backendRefund(msg.sender, account.versionTokens.sub(1));
605             account.allTokens = account.allTokens.sub(account.versionTokens.sub(1));
606             account.statusTokens = account.statusTokens.sub(account.versionStatusTokens.sub(1));
607             account.versionStatusTokens = 1;
608             account.versionTokens = 1;
609         }
610 
611         address referer = token.refererOf(msg.sender);
612         if(account.versionRefererTokens > 0 && referer != address(0)) {
613             token.backendRefund(referer, account.versionRefererTokens.sub(1));
614             account.versionRefererTokens = 1;
615         }
616 
617         uint8 currentStatus = token.statusOf(msg.sender);
618         if(account.versionBeforeStatus != currentStatus){
619             token.backendSetStatus(msg.sender, account.versionBeforeStatus);
620         }
621 
622         emit EvWithdraw(msg.sender, value, version);
623     }
624 
625     function serviceGroupChange(address _address, uint8 _group) minGroup(groupPolicyInstance._admin) external returns(uint8) {
626         uint8 old = group[_address];
627         if(old <= groupPolicyInstance._admin) {
628             group[_address] = _group;
629             emit EvGroupChanged(_address, old, _group);
630         }
631         return group[_address];
632     }
633 
634     function () external saleIsOn() payable{
635         uint256 tokenCount = msg.value.div(weiPerMinToken);
636         require(tokenCount > 0);
637 
638         token.transfer( msg.sender, tokenCount);
639 
640         updateAccountInfo(msg.sender, msg.value, tokenCount);
641 
642         address referer = token.refererOf(msg.sender);
643         if (msg.data.length > 0 && referer == address(0)) {
644             referer = token.getPromoAddress(bytes(msg.data));
645             if(referer != address(0)) {
646                 require(referer != msg.sender);
647                 require(token.backendSetReferer(msg.sender, referer));
648             }
649         }
650         trySendBonuses(msg.sender, referer, tokenCount);
651     }
652 
653     function updateAccountInfo(address _address, uint256 incSpent, uint256 incTokenCount) private returns(bool){
654         tryUpdateVersion(_address);
655         Account storage account = accounts[_address];
656         account.spent = account.spent.add(incSpent);
657         account.allTokens = account.allTokens.add(incTokenCount);
658         
659         account.versionTokens = account.versionTokens.add(incTokenCount);
660         
661         totalSold = totalSold.add(incTokenCount);
662         soldOnVersion[version] = soldOnVersion[version].add(incTokenCount);
663         etherTotal = etherTotal.add(incSpent);
664 
665         emit EvAccountPurchase(_address, account.spent.sub(1), account.allTokens, totalSold);
666 
667         if(now < startTime + durationOfStatusSell && now >= startTime){
668 
669             uint256 lastStatusTokens = account.statusTokens;
670 
671             account.statusTokens = account.statusTokens.add(incTokenCount);
672             account.versionStatusTokens = account.versionStatusTokens.add(incTokenCount);
673 
674             uint256 currentStatus = uint256(token.statusOf(_address));
675 
676             uint256 newStatus = currentStatus;
677 
678             for(uint256 i = currentStatus; i < 4; i++){
679 
680                 if(account.statusTokens > statusMinBorders[i]){
681                     newStatus = i + 1;
682                 } else {
683                     break;
684                 }
685             }
686             if(currentStatus < newStatus){
687                 token.backendSetStatus(_address, uint8(newStatus));
688             }
689             emit EvSellStatusToken(_address, lastStatusTokens, account.statusTokens);
690         }
691 
692         return true;
693     }
694 
695     function tryUpdateVersion(address _address) private {
696         Account storage account = accounts[_address];
697         if(account.version != version){
698             account.version = version;
699             account.versionBeforeStatus = token.statusOf(_address);
700         }
701         if(account.version != version || account.spent == 0){
702             account.spent = 1;
703             account.versionTokens = 1;
704             account.versionRefererTokens = 1;
705             account.versionStatusTokens = 1;
706         }
707     }
708 
709     function trySendBonuses(address _address, address _referer, uint256 _tokenCount) private {
710         if(_referer != address(0)) {
711             uint256 refererFee = _tokenCount.div(100).mul(refererFeePercent);
712             uint256 referalBonus = _tokenCount.div(100).mul(referalBonusPercent);
713             if(refererFee > 0) {
714                 token.backendSendBonus(_referer, refererFee);
715                 
716                 accounts[_address].versionRefererTokens = accounts[_address].versionRefererTokens.add(refererFee);
717                 
718             }
719             if(referalBonus > 0) {
720                 token.backendSendBonus(_address, referalBonus);
721                 
722                 accounts[_address].versionTokens = accounts[_address].versionTokens.add(referalBonus);
723                 accounts[_address].allTokens = accounts[_address].allTokens.add(referalBonus);
724             }
725         }
726     }
727 
728     function calculateTokenCount(uint256 weiAmount) external view returns(uint256 summary){
729         return weiAmount.div(weiPerMinToken);
730     }
731 
732     function isSelling() external view returns(bool){
733         return now > startTime && soldOnVersion[version] < softcap && isActive;
734     }
735 
736     function getGroup(address _check) external view returns(uint8 _group) {
737         return group[_check];
738     }
739 }