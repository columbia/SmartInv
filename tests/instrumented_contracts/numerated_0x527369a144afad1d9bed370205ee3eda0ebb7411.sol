1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library Config {
33     address constant internal BANK = 0xF2058a24B61E5B7cD0Aa6F4CC28f7ff0ecA10FF4;
34     uint constant internal INITIAL_SUPPLY = 50000000000000000000000000;
35 
36     function bank() internal pure returns (address) {
37       return BANK;
38     }
39     
40     function initial_supply() internal pure returns (uint) {
41       return INITIAL_SUPPLY;
42     }
43 }
44 
45 library Roles {
46   struct Role {
47     mapping (address => bool) bearer;
48   }
49 
50   /**
51    * @dev give an account access to this role
52    */
53   function add(Role storage role, address account) internal {
54     require(account != address(0));
55     require(!has(role, account));
56 
57     role.bearer[account] = true;
58   }
59 
60   /**
61    * @dev remove an account's access to this role
62    */
63   function remove(Role storage role, address account) internal {
64     require(account != address(0));
65     require(has(role, account));
66 
67     role.bearer[account] = false;
68   }
69 
70   /**
71    * @dev check if an account has this role
72    * @return bool
73    */
74   function has(Role storage role, address account)
75     internal
76     view
77     returns (bool)
78   {
79     require(account != address(0));
80     return role.bearer[account];
81   }
82 }
83 
84 library SafeMath {
85 
86   /**
87   * @dev Multiplies two numbers, reverts on overflow.
88   */
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91     // benefit is lost if 'b' is also tested.
92     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93     if (a == 0) {
94       return 0;
95     }
96 
97     uint256 c = a * b;
98     require(c / a == b);
99 
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b > 0); // Solidity only automatically asserts when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111     return c;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     require(b <= a);
119     uint256 c = a - b;
120 
121     return c;
122   }
123 
124   /**
125   * @dev Adds two numbers, reverts on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     require(c >= a);
130 
131     return c;
132   }
133 
134   /**
135   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
136   * reverts when dividing by zero.
137   */
138   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139     require(b != 0);
140     return a % b;
141   }
142 }
143 
144 contract ERC20Detailed is IERC20 {
145   string private _name;
146   string private _symbol;
147   uint8 private _decimals;
148 
149   constructor(string name, string symbol, uint8 decimals) public {
150     _name = name;
151     _symbol = symbol;
152     _decimals = decimals;
153   }
154 
155   /**
156    * @return the name of the token.
157    */
158   function name() public view returns(string) {
159     return _name;
160   }
161 
162   /**
163    * @return the symbol of the token.
164    */
165   function symbol() public view returns(string) {
166     return _symbol;
167   }
168 
169   /**
170    * @return the number of decimals of the token.
171    */
172   function decimals() public view returns(uint8) {
173     return _decimals;
174   }
175 }
176 
177 contract MinterRole {
178   using Roles for Roles.Role;
179 
180   event MinterAdded(address indexed account);
181   event MinterRemoved(address indexed account);
182 
183   Roles.Role private minters;
184 
185   constructor() internal {
186     _addMinter(msg.sender);
187   }
188 
189   modifier onlyMinter() {
190     require(isMinter(msg.sender));
191     _;
192   }
193 
194   function isMinter(address account) public view returns (bool) {
195     return minters.has(account);
196   }
197 
198   function addMinter(address account) public onlyMinter {
199     _addMinter(account);
200   }
201 
202   function renounceMinter() public {
203     _removeMinter(msg.sender);
204   }
205 
206   function _addMinter(address account) internal {
207     minters.add(account);
208     emit MinterAdded(account);
209   }
210 
211   function _removeMinter(address account) internal {
212     minters.remove(account);
213     emit MinterRemoved(account);
214   }
215 }
216 
217 contract SuperInvestorRole {
218   using Roles for Roles.Role;
219   using Config for Config;
220     
221   address internal BANK = Config.bank();
222 
223   event SuperInvestorAdded(address indexed account);
224   event SuperInvestorRemoved(address indexed account);
225 
226   Roles.Role private superInvestors;
227 
228   constructor() internal {
229   }
230 
231   modifier onlyBank() {
232     require(msg.sender == BANK);
233     _;
234   }
235   
236   modifier onlyBankOrSuperInvestor() {
237     require(msg.sender == BANK || isSuperInvestor(msg.sender));
238     _;
239   }
240 
241   function isSuperInvestor(address account) public view returns (bool) {
242     return superInvestors.has(account);
243   }
244 
245   function addSuperInvestor(address account) public onlyBank {
246     _addSuperInvestor(account);
247   }
248 
249   function renounceSuperInvestor() public onlyBankOrSuperInvestor {
250     _removeSuperInvestor(msg.sender);
251   }
252 
253   function _addSuperInvestor(address account) internal {
254     superInvestors.add(account);
255     emit SuperInvestorAdded(account);
256   }
257 
258   function _removeSuperInvestor(address account) internal {
259     superInvestors.remove(account);
260     emit SuperInvestorRemoved(account);
261   }
262 }
263 
264 contract InvestorRole is SuperInvestorRole {
265   using Roles for Roles.Role;
266   using Config for Config;
267     
268   address internal BANK = Config.bank();
269 
270   event InvestorAdded(address indexed account);
271   event InvestorRemoved(address indexed account);
272 
273   Roles.Role private investors;
274 
275   constructor() internal {
276   }
277   
278   modifier onlyInvestor() {
279     require(isInvestor(msg.sender));
280     _;
281   }
282 
283   function isInvestor(address account) public view returns (bool) {
284     return investors.has(account);
285   }
286 
287   function addInvestor(address account) public onlyBankOrSuperInvestor {
288     _addInvestor(account);
289   }
290 
291   function renounceInvestor() public onlyInvestor() {
292     _removeInvestor(msg.sender);
293   }
294 
295   function _addInvestor(address account) internal {
296     investors.add(account);
297     emit InvestorAdded(account);
298   }
299 
300   function _removeInvestor(address account) internal {
301     investors.remove(account);
302     emit InvestorRemoved(account);
303   }
304 }
305 
306 contract ERC20 is IERC20 {
307   using SafeMath for uint256;
308 
309   mapping (address => uint256) private _balances;
310 
311   mapping (address => mapping (address => uint256)) private _allowed;
312 
313   uint256 private _totalSupply;
314 
315   /**
316   * @dev Total number of tokens in existence
317   */
318   function totalSupply() public view returns (uint256) {
319     return _totalSupply;
320   }
321 
322   /**
323   * @dev Gets the balance of the specified address.
324   * @param owner The address to query the balance of.
325   * @return An uint256 representing the amount owned by the passed address.
326   */
327   function balanceOf(address owner) public view returns (uint256) {
328     return _balances[owner];
329   }
330 
331   /**
332    * @dev Function to check the amount of tokens that an owner allowed to a spender.
333    * @param owner address The address which owns the funds.
334    * @param spender address The address which will spend the funds.
335    * @return A uint256 specifying the amount of tokens still available for the spender.
336    */
337   function allowance(
338     address owner,
339     address spender
340    )
341     public
342     view
343     returns (uint256)
344   {
345     return _allowed[owner][spender];
346   }
347 
348   /**
349   * @dev Transfer token for a specified address
350   * @param to The address to transfer to.
351   * @param value The amount to be transferred.
352   */
353   function transfer(address to, uint256 value) public returns (bool) {
354     _transfer(msg.sender, to, value);
355     return true;
356   }
357 
358   /**
359    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
360    * Beware that changing an allowance with this method brings the risk that someone may use both the old
361    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
362    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
363    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
364    * @param spender The address which will spend the funds.
365    * @param value The amount of tokens to be spent.
366    */
367   function approve(address spender, uint256 value) public returns (bool) {
368     require(spender != address(0));
369 
370     _allowed[msg.sender][spender] = value;
371     emit Approval(msg.sender, spender, value);
372     return true;
373   }
374 
375   /**
376    * @dev Transfer tokens from one address to another
377    * @param from address The address which you want to send tokens from
378    * @param to address The address which you want to transfer to
379    * @param value uint256 the amount of tokens to be transferred
380    */
381   function transferFrom(
382     address from,
383     address to,
384     uint256 value
385   )
386     public
387     returns (bool)
388   {
389     require(value <= _allowed[from][msg.sender]);
390 
391     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
392     _transfer(from, to, value);
393     return true;
394   }
395 
396   /**
397    * @dev Increase the amount of tokens that an owner allowed to a spender.
398    * approve should be called when allowed_[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param spender The address which will spend the funds.
403    * @param addedValue The amount of tokens to increase the allowance by.
404    */
405   function increaseAllowance(
406     address spender,
407     uint256 addedValue
408   )
409     public
410     returns (bool)
411   {
412     require(spender != address(0));
413 
414     _allowed[msg.sender][spender] = (
415       _allowed[msg.sender][spender].add(addedValue));
416     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
417     return true;
418   }
419 
420   /**
421    * @dev Decrease the amount of tokens that an owner allowed to a spender.
422    * approve should be called when allowed_[_spender] == 0. To decrement
423    * allowed value is better to use this function to avoid 2 calls (and wait until
424    * the first transaction is mined)
425    * From MonolithDAO Token.sol
426    * @param spender The address which will spend the funds.
427    * @param subtractedValue The amount of tokens to decrease the allowance by.
428    */
429   function decreaseAllowance(
430     address spender,
431     uint256 subtractedValue
432   )
433     public
434     returns (bool)
435   {
436     require(spender != address(0));
437 
438     _allowed[msg.sender][spender] = (
439       _allowed[msg.sender][spender].sub(subtractedValue));
440     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
441     return true;
442   }
443 
444   /**
445   * @dev Transfer token for a specified addresses
446   * @param from The address to transfer from.
447   * @param to The address to transfer to.
448   * @param value The amount to be transferred.
449   */
450   function _transfer(address from, address to, uint256 value) internal {
451     require(value <= _balances[from]);
452     require(to != address(0));
453 
454     _balances[from] = _balances[from].sub(value);
455     _balances[to] = _balances[to].add(value);
456     emit Transfer(from, to, value);
457   }
458 
459   /**
460    * @dev Internal function that mints an amount of the token and assigns it to
461    * an account. This encapsulates the modification of balances such that the
462    * proper events are emitted.
463    * @param account The account that will receive the created tokens.
464    * @param value The amount that will be created.
465    */
466   function _mint(address account, uint256 value) internal {
467     require(account != 0);
468     _totalSupply = _totalSupply.add(value);
469     _balances[account] = _balances[account].add(value);
470     emit Transfer(address(0), account, value);
471   }
472 
473   /**
474    * @dev Internal function that burns an amount of the token of a given
475    * account.
476    * @param account The account whose tokens will be burnt.
477    * @param value The amount that will be burnt.
478    */
479   function _burn(address account, uint256 value) internal {
480     require(account != 0);
481     require(value <= _balances[account]);
482 
483     _totalSupply = _totalSupply.sub(value);
484     _balances[account] = _balances[account].sub(value);
485     emit Transfer(account, address(0), value);
486   }
487 
488   /**
489    * @dev Internal function that burns an amount of the token of a given
490    * account, deducting from the sender's allowance for said account. Uses the
491    * internal burn function.
492    * @param account The account whose tokens will be burnt.
493    * @param value The amount that will be burnt.
494    */
495   function _burnFrom(address account, uint256 value) internal {
496     require(value <= _allowed[account][msg.sender]);
497 
498     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
499     // this function needs to emit an event with the updated approval.
500     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
501       value);
502     _burn(account, value);
503   }
504 }
505 
506 contract ERC20Mintable is ERC20, MinterRole {
507   using Config for Config;
508   
509   address internal _bank = Config.bank();
510 
511   /**
512    * @dev Function to mint tokens
513    * @param value The amount of tokens to mint.
514    * @return A boolean that indicates if the operation was successful.
515    */
516   function mint(
517     uint256 value
518   )
519     public
520     onlyMinter
521     returns (bool)
522   {
523     _mint(_bank, value);
524     return true;
525   }
526 }
527 
528 contract ERC20Burnable is ERC20 {
529   /**
530    * @dev Burns a specific amount of tokens.
531    * @param value The amount of token to be burned.
532    */
533   function burn(uint256 value) public {
534     _burn(msg.sender, value);
535   }
536 
537   /**
538    * @dev Burns a specific amount of tokens from the target address and decrements allowance
539    * @param from address The address which you want to send tokens from
540    * @param value uint256 The amount of token to be burned
541    */
542   function burnFrom(address from, uint256 value) public {
543     _burnFrom(from, value);
544   }
545 }
546 
547 interface IVest {
548   function totalVested() external view returns (uint256);
549 
550   function vestedOf(address who) external view returns (uint256);
551   
552   event Vest(
553     address indexed to,
554     uint256 value
555   );
556 }
557 
558 contract Vest is IVest {
559   using SafeMath for uint256;
560   
561   struct Beneficiary {
562     address _address;
563     uint256 startTime;
564     uint256 _amount;
565     uint256 _percent;
566     bool monthly;
567   }
568 
569   mapping (address => Beneficiary) beneficiaries;
570 
571   mapping (address => uint256) private _vestedBalances;
572 
573   uint256 private _totalVested;
574   uint256 private beneficiariesCount;
575 
576   function totalVested() public view returns (uint256) {
577     return _totalVested;
578   }
579 
580   function vestedOf(address owner) public view returns (uint256) {
581     return _vestedBalances[owner];
582   }
583 
584   function _vest(address to, uint256 value, uint256 percent, bool monthly) internal {
585     require(to != address(0));
586 
587     _totalVested = _totalVested.add(value);
588     _vestedBalances[to] = _vestedBalances[to].add(value);
589 
590     addBeneficiary(to, now, value, percent, monthly);
591     emit Vest(to, value);
592   }
593 
594   function totalBeneficiaries() public view returns (uint256) {
595     return beneficiariesCount;
596   }
597 
598   function addBeneficiary (address to, uint256, uint256 value, uint256 percent, bool monthly) internal {
599     beneficiariesCount ++;
600     beneficiaries[to] = Beneficiary(to, now, value, percent, monthly);
601   }
602   
603   function isBeneficiary (address _address) public view returns (bool) {
604     if (beneficiaries[_address]._address != 0) {
605       return true;
606     } else {
607       return false;
608     }
609   }
610 
611   function getBeneficiary (address _address) public view returns (address, uint256, uint256, uint256, bool) {
612     Beneficiary storage b = beneficiaries[_address];
613     return (b._address, b.startTime, b._amount, b._percent, b.monthly);
614   }
615   
616   function _getLockedAmount(address _address) public view returns (uint256) {
617     Beneficiary memory b = beneficiaries[_address];
618     uint256 amount = b._amount;
619     uint256 percent = b._percent;
620     uint256 timeValue = _getTimeValue(_address);
621     uint256 calcAmount = amount.mul(timeValue.mul(percent)).div(100);
622 
623     if (calcAmount >= amount) {
624         return 0;
625     } else {
626         return amount.sub(calcAmount);
627     }
628   }
629   
630   function _getTimeValue(address _address) internal view returns (uint256) {
631     Beneficiary memory b = beneficiaries[_address];
632     uint256 startTime = b.startTime;
633     uint256 presentTime = now;
634     uint256 timeValue = presentTime.sub(startTime);
635     bool monthly = b.monthly;
636 
637     if (monthly) {
638       return timeValue.div(10 minutes);
639     } else {
640       return timeValue.div(120 minutes);  
641     }
642   }
643 }
644 
645 contract SuperInvestable is SuperInvestorRole, InvestorRole {
646   using SafeMath for uint256;
647   using Config for Config;
648 
649   address internal BANK = Config.bank();
650   uint256 public percent;
651   
652   struct Investor {
653     address _address;
654     uint256 _amount;
655     uint256 _initialAmount;
656     uint256 startTime;
657   }
658   
659   mapping (address => Investor) investorList;
660   
661   modifier onlyBank() {
662     require(msg.sender == BANK);
663     _;
664   }
665   
666   function setPercent (uint256 _percent) external onlyBank returns (bool) {
667     percent = _percent;
668     return true;
669   }
670   
671   function addToInvestorList (address to, uint256 _amount, uint256 _initialAmount, uint256) internal {
672     _addInvestor(to);
673     investorList[to] = Investor(to, _amount, _initialAmount, now);
674   }
675       
676   function getInvestor (address _address) internal view returns (address, uint256, uint256, uint256) {
677     Investor storage i = investorList[_address];
678     return (i._address, i._amount, i._initialAmount, i.startTime);
679   }
680   
681   function _getInvestorLockedAmount (address _address) public view returns (uint256) {
682     Investor memory i = investorList[_address];
683     uint256 amount = i._amount;
684     uint256 timeValue = _getTimeValue(_address);
685     uint256 calcAmount = amount.mul(timeValue.mul(percent)).div(100);
686 
687     if (calcAmount >= amount) {
688         return 0;
689     } else {
690         return amount.sub(calcAmount);
691     }
692   }
693   
694   function _getTimeValue (address _address) internal view returns (uint256) {
695     Investor memory i = investorList[_address];
696     uint256 startTime = i.startTime;
697     uint256 presentTime = now;
698     uint256 timeValue = presentTime.sub(startTime);
699 
700     return timeValue.div(1 minutes);
701   }
702 }
703 
704 contract FTCash is ERC20Detailed, ERC20Mintable, ERC20Burnable, Vest, SuperInvestable {
705     using Config for Config;
706 
707     uint internal INITIAL_SUPPLY = Config.initial_supply();
708     address internal BANK = Config.bank();
709 
710     string internal _name = "FTCash";
711     string internal _symbol = "FTX";
712     uint8 internal _decimals = 18;
713 
714     modifier onlyBank() {
715       require(msg.sender == BANK);
716       _;
717     }
718 
719     constructor()
720       ERC20Detailed(_name, _symbol, _decimals)
721 
722     public 
723     {
724         _mint(BANK, INITIAL_SUPPLY);
725         // _addMinter(BANK);
726         // renounceMinter();
727     }
728 
729     function vest(address _to, uint256 _amount, uint256 percent, bool monthly)
730       onlyBank external returns (bool) {
731       _vest(_to, _amount, percent, monthly);
732       transfer(_to, _amount);
733       return true;
734     }
735 
736     /* Checks limit for the address 
737     *  Checks if the address is a Beneficiary and checks the allowed transferrable first
738     *  Then checks if address is a Super Investor and converts the recipient into an Investor
739     *  Then checks if address is an Investor and checks the allowed transferrable
740     *  Then returns if remaining balance after the transfer is gte to value
741     */
742     function checkLimit(address _address, uint256 value) internal view returns (bool) {
743       uint256 remaining = balanceOf(_address).sub(value);
744       
745       if (isBeneficiary(_address) && isInvestor(_address)) {
746         uint256 ilocked = _getInvestorLockedAmount(_address);
747         uint256 locked = _getLockedAmount(_address);
748         return remaining >= locked.add(ilocked);
749       }
750       
751       if (isBeneficiary(_address)) {
752         return remaining >= _getLockedAmount(_address);
753       }
754       
755       if (isInvestor(_address)) {
756         return remaining >= _getInvestorLockedAmount(_address);
757       }
758     }
759 
760     /* Checks if sender is a Beneficiary or an Investor then checks the limit
761     *  Then checks if the sender is a superInvestor then converts the recipient to an investor
762     *  Then proceeds to transfer the amount
763     */
764     function transfer(address to, uint256 value) public returns (bool) {
765       if (isBeneficiary(msg.sender) || isInvestor(msg.sender)) {
766         require(checkLimit(msg.sender, value));
767       }
768 
769       if (isSuperInvestor(msg.sender)) {
770         addToInvestorList(to, value, value, now);
771       }
772 
773       _transfer(msg.sender, to, value);
774       return true;
775     }
776     
777     function bankBurnFrom(address account, uint256 value) external onlyBank {
778       _burn(account, value);
779     }
780 }