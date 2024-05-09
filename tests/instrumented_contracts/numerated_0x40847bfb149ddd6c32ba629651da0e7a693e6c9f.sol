1 pragma solidity ^0.4.24;
2 /**
3  * @title Roles
4  * @dev Library for managing addresses assigned to a Role.
5  */
6 library Roles {
7   struct Role {
8     mapping (address => bool) bearer;
9   }
10 
11   /**
12    * @dev give an account access to this role
13    */
14   function add(Role storage role, address account) internal {
15     require(account != address(0));
16     require(!has(role, account));
17 
18     role.bearer[account] = true;
19   }
20 
21   /**
22    * @dev remove an account's access to this role
23    */
24   function remove(Role storage role, address account) internal {
25     require(account != address(0));
26     require(has(role, account));
27 
28     role.bearer[account] = false;
29   }
30 
31   /**
32    * @dev check if an account has this role
33    * @return bool
34    */
35   function has(Role storage role, address account)
36     internal
37     view
38     returns (bool)
39   {
40     require(account != address(0));
41     return role.bearer[account];
42   }
43 }
44 
45 
46 contract MasterRole {
47   using Roles for Roles.Role;
48 
49   event MasterAdded(address indexed account);
50   event MasterRemoved(address indexed account);
51 
52   Roles.Role private masters;
53 
54   constructor() internal {
55     _addMaster(msg.sender);
56   }
57 
58   modifier onlyMaster() {
59     require(isMaster(msg.sender));
60     _;
61   }
62 
63   function isMaster(address account) public view returns (bool) {
64     return masters.has(account);
65   }
66 
67   function addMaster(address account) public onlyMaster {
68     _addMaster(account);
69   }
70 
71   function renounceMaster() public {
72     _removeMaster(msg.sender);
73   }
74 
75   function _addMaster(address account) internal {
76     masters.add(account);
77     emit MasterAdded(account);
78   }
79 
80   function _removeMaster(address account) internal {
81     masters.remove(account);
82     emit MasterRemoved(account);
83   }
84 }
85 
86 contract MinterRole {
87   using Roles for Roles.Role;
88 
89   event MinterAdded(address indexed account);
90   event MinterRemoved(address indexed account);
91 
92   Roles.Role private minters;
93 
94   constructor() internal {
95     _addMinter(msg.sender);
96   }
97 
98   modifier onlyMinter() {
99     require(isMinter(msg.sender));
100     _;
101   }
102 
103   function isMinter(address account) public view returns (bool) {
104     return minters.has(account);
105   }
106 
107   function addMinter(address account) public onlyMinter {
108     _addMinter(account);
109   }
110 
111   function renounceMinter() public {
112     _removeMinter(msg.sender);
113   }
114 
115   function _addMinter(address account) internal {
116     minters.add(account);
117     emit MinterAdded(account);
118   }
119 
120   function _removeMinter(address account) internal {
121     minters.remove(account);
122     emit MinterRemoved(account);
123   }
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 interface IERC20 {
131   function totalSupply() external view returns (uint256);
132 
133   function balanceOf(address who) external view returns (uint256);
134 
135   function allowance(address owner, address spender)
136     external view returns (uint256);
137 
138   function transfer(address to, uint256 value) external returns (bool);
139 
140   function approve(address spender, uint256 value)
141     external returns (bool);
142 
143   function transferFrom(address from, address to, uint256 value)
144     external returns (bool);
145 
146   event Transfer(
147     address indexed from,
148     address indexed to,
149     uint256 value
150   );
151 
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 
158   event TransferWithData(
159     address indexed from,
160     address indexed to,
161     bytes32 indexed data,
162     uint256 value
163   );
164 }
165 
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, reverts on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173     // benefit is lost if 'b' is also tested.
174     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
175     if (a == 0) {
176       return 0;
177     }
178 
179     uint256 c = a * b;
180     require(c / a == b);
181 
182     return c;
183   }
184 
185   /**
186   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
187   */
188   function div(uint256 a, uint256 b) internal pure returns (uint256) {
189     require(b > 0); // Solidity only automatically asserts when dividing by 0
190     uint256 c = a / b;
191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193     return c;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     require(b <= a);
201     uint256 c = a - b;
202 
203     return c;
204   }
205 
206   /**
207   * @dev Adds two numbers, reverts on overflow.
208   */
209   function add(uint256 a, uint256 b) internal pure returns (uint256) {
210     uint256 c = a + b;
211     require(c >= a);
212 
213     return c;
214   }
215 
216   /**
217   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
218   * reverts when dividing by zero.
219   */
220   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221     require(b != 0);
222     return a % b;
223   }
224 }
225 
226 contract AddressMapper is MasterRole {
227     
228     event DoMap(address indexed src, bytes32 indexed target, string rawTarget);
229     event DoMapAuto(address indexed src, bytes32 indexed target, string rawTarget);
230     event UnMap(address indexed src);
231 
232     mapping (address => string) public mapper;
233 
234     modifier onlyNotSet(address src) {
235         bytes memory tmpTargetBytes = bytes(mapper[src]);
236         require(tmpTargetBytes.length == 0);
237         _;
238     }
239 
240     function()
241         public
242         payable
243         onlyNotSet(msg.sender)
244     {
245         require(msg.value > 0);
246         _doMapAuto(msg.sender, string(msg.data));
247         msg.sender.transfer(msg.value);
248     }
249 
250     function isAddressSet(address thisAddr)
251         public
252         view
253         returns(bool)
254     {
255         bytes memory tmpTargetBytes = bytes(mapper[thisAddr]);
256         if(tmpTargetBytes.length == 0) {
257             return false;
258         } else {
259             return true;
260         }
261     }
262 
263     function _doMapAuto(address src, string target)
264         internal
265     {
266         mapper[src] = target;
267         bytes32 translated = _stringToBytes32(target);
268         emit DoMapAuto(src, translated, target);
269     }
270 
271     function doMap(address src, string target) 
272         public
273         onlyMaster
274         onlyNotSet(src)
275     {
276         mapper[src] = target;
277         bytes32 translated = _stringToBytes32(target);
278         emit DoMap(src, translated, target);
279     }
280 
281     function unMap(address src) 
282         public
283         onlyMaster
284     {
285         mapper[src] = "";
286         emit UnMap(src);
287     }
288 
289     function _stringToBytes32(string memory source) internal returns (bytes32 result) {
290         bytes memory tempEmptyStringTest = bytes(source);
291         if (tempEmptyStringTest.length == 0) {
292             return 0x0;
293         }
294 
295         assembly {
296             result := mload(add(source, 32))
297         }
298     }
299 
300     function submitTransaction(address destination, uint value, bytes data)
301         public
302         onlyMaster
303     {
304         external_call(destination, value, data.length, data);
305     }
306 
307     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
308         bool result;
309         assembly {
310             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
311             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
312             result := call(
313                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
314                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
315                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
316                 destination,
317                 value,
318                 d,
319                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
320                 x,
321                 0                  // Output is ignored, therefore the output size is zero
322             )
323         }
324         return result;
325     }
326 }
327 
328 /**
329  * @title Standard ERC20 token
330  *
331  * @dev Implementation of the basic standard token.
332  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
333  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
334  */
335 contract ERC20 is IERC20 {
336   using SafeMath for uint256;
337 
338   mapping (address => uint256) internal _balances;
339 
340   mapping (address => mapping (address => uint256)) internal _allowed;
341 
342   uint256 private _totalSupply;
343 
344   AddressMapper public addressMapper;
345 
346   constructor(address addressMapperAddr) public {
347     addressMapper = AddressMapper(addressMapperAddr);
348   }
349 
350   /**
351   * @dev Total number of tokens in existence
352   */
353   function totalSupply() public view returns (uint256) {
354     return _totalSupply;
355   }
356 
357   /**
358   * @dev Gets the balance of the specified address.
359   * @param owner The address to query the balance of.
360   * @return An uint256 representing the amount owned by the passed address.
361   */
362   function balanceOf(address owner) public view returns (uint256) {
363     return _balances[owner];
364   }
365 
366   /**
367    * @dev Function to check the amount of tokens that an owner allowed to a spender.
368    * @param owner address The address which owns the funds.
369    * @param spender address The address which will spend the funds.
370    * @return A uint256 specifying the amount of tokens still available for the spender.
371    */
372   function allowance(
373     address owner,
374     address spender
375    )
376     public
377     view
378     returns (uint256)
379   {
380     return _allowed[owner][spender];
381   }
382 
383   /**
384   * @dev Transfer token for a specified address
385   * @param to The address to transfer to.
386   * @param value The amount to be transferred.
387   */
388   function transfer(address to, uint256 value) public returns (bool) {
389     _transfer(msg.sender, to, value);
390     return true;
391   }
392 
393   /**
394   * @dev Transfer token for a specified address
395   * @param to The address to transfer to.
396   * @param value The amount to be transferred.
397   * @param data addtional data.
398   */
399   function transferWithData(address to, uint256 value, bytes32 data) public returns (bool) {
400     _transfer(msg.sender, to, value);
401     emit TransferWithData(msg.sender, to, data, value);
402     return true;
403   }
404 
405   /**
406    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
407    * Beware that changing an allowance with this method brings the risk that someone may use both the old
408    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
409    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
410    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
411    * @param spender The address which will spend the funds.
412    * @param value The amount of tokens to be spent.
413    */
414   function approve(address spender, uint256 value) public returns (bool) {
415     require(spender != address(0));
416 
417     _allowed[msg.sender][spender] = value;
418     emit Approval(msg.sender, spender, value);
419     return true;
420   }
421 
422   /**
423    * @dev Transfer tokens from one address to another
424    * @param from address The address which you want to send tokens from
425    * @param to address The address which you want to transfer to
426    * @param value uint256 the amount of tokens to be transferred
427    */
428   function transferFrom(
429     address from,
430     address to,
431     uint256 value
432   )
433     public
434     returns (bool)
435   {
436     require(value <= _allowed[from][msg.sender]);
437 
438     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
439     _transfer(from, to, value);
440     return true;
441   }
442 
443   /**
444    * @dev Transfer tokens from one address to another
445    * @param from address The address which you want to send tokens from
446    * @param to address The address which you want to transfer to
447    * @param value uint256 the amount of tokens to be transferred
448    * @param data addtional data.
449    */
450   function transferFromWithData(
451     address from,
452     address to,
453     uint256 value,
454     bytes32 data
455   )
456     public
457     returns (bool)
458   {
459     require(value <= _allowed[from][msg.sender]);
460 
461     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
462     _transfer(from, to, value);
463     emit TransferWithData(from, to, data, value);
464     return true;
465   }
466 
467   /**
468    * @dev Increase the amount of tokens that an owner allowed to a spender.
469    * approve should be called when allowed_[_spender] == 0. To increment
470    * allowed value is better to use this function to avoid 2 calls (and wait until
471    * the first transaction is mined)
472    * From MonolithDAO Token.sol
473    * @param spender The address which will spend the funds.
474    * @param addedValue The amount of tokens to increase the allowance by.
475    */
476   function increaseAllowance(
477     address spender,
478     uint256 addedValue
479   )
480     public
481     returns (bool)
482   {
483     require(spender != address(0));
484 
485     _allowed[msg.sender][spender] = (
486       _allowed[msg.sender][spender].add(addedValue));
487     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
488     return true;
489   }
490 
491   /**
492    * @dev Decrease the amount of tokens that an owner allowed to a spender.
493    * approve should be called when allowed_[_spender] == 0. To decrement
494    * allowed value is better to use this function to avoid 2 calls (and wait until
495    * the first transaction is mined)
496    * From MonolithDAO Token.sol
497    * @param spender The address which will spend the funds.
498    * @param subtractedValue The amount of tokens to decrease the allowance by.
499    */
500   function decreaseAllowance(
501     address spender,
502     uint256 subtractedValue
503   )
504     public
505     returns (bool)
506   {
507     require(spender != address(0));
508 
509     _allowed[msg.sender][spender] = (
510       _allowed[msg.sender][spender].sub(subtractedValue));
511     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
512     return true;
513   }
514 
515   /**
516   * @dev Transfer token for a specified addresses
517   * @param from The address to transfer from.
518   * @param to The address to transfer to.
519   * @param value The amount to be transferred.
520   */
521   function _transfer(address from, address to, uint256 value) internal {
522     require(value <= _balances[from]);
523     require(to != address(0));
524 
525     _balances[from] = _balances[from].sub(value);
526     _balances[to] = _balances[to].add(value);
527     emit Transfer(from, to, value);
528   }
529 
530   /**
531    * @dev Internal function that mints an amount of the token and assigns it to
532    * an account. This encapsulates the modification of balances such that the
533    * proper events are emitted.
534    * @param account The account that will receive the created tokens.
535    * @param value The amount that will be created.
536    */
537   function _mint(address account, uint256 value) internal {
538     require(account != 0);
539     _totalSupply = _totalSupply.add(value);
540     _balances[account] = _balances[account].add(value);
541     emit Transfer(address(0), account, value);
542   }
543 
544   /**
545    * @dev Internal function that burns an amount of the token of a given
546    * account.
547    * @param account The account whose tokens will be burnt.
548    * @param value The amount that will be burnt.
549    */
550   function _burn(address account, uint256 value) internal {
551     require(account != 0);
552     require(value <= _balances[account]);
553 
554     _totalSupply = _totalSupply.sub(value);
555     _balances[account] = _balances[account].sub(value);
556     emit Transfer(account, address(0), value);
557   }
558 
559   /**
560    * @dev Internal function that burns an amount of the token of a given
561    * account, deducting from the sender's allowance for said account. Uses the
562    * internal burn function.
563    * @param account The account whose tokens will be burnt.
564    * @param value The amount that will be burnt.
565    */
566   function _burnFrom(address account, uint256 value) internal {
567     require(value <= _allowed[account][msg.sender]);
568 
569     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
570     // this function needs to emit an event with the updated approval.
571     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
572       value);
573     _burn(account, value);
574   }
575 }
576 
577 /**
578  * @title ERC20Mintable
579  * @dev ERC20 minting logic
580  */
581 contract ERC20Mintable is ERC20, MinterRole {
582 
583   constructor(address addressMapperAddr)
584     ERC20(addressMapperAddr)
585     public
586   {}
587 
588   /**
589    * @dev Function to mint tokens
590    * @param to The address that will receive the minted tokens.
591    * @param value The amount of tokens to mint.
592    * @return A boolean that indicates if the operation was successful.
593    */
594   function mint(
595     address to,
596     uint256 value
597   )
598     public
599     onlyMinter
600     returns (bool)
601   {
602     _mint(to, value);
603     return true;
604   }
605 }
606 
607 /**
608  * @title Capped token
609  * @dev Mintable token with a token cap.
610  */
611 contract ERC20Capped is ERC20Mintable {
612 
613   event SetIsPreventedAddr(address indexed preventedAddr, bool hbool);
614 
615   uint256 private _cap;
616   string private _name;
617   string private _symbol;
618   uint8 private _decimals;
619 
620   mapping ( address => bool ) public isPreventedAddr;
621 
622   function transfer(address to, uint256 value) public returns (bool) {
623     _checkedTransfer(msg.sender, to, value);
624     return true;
625   }
626 
627   function transferWithData(address to, uint256 value, bytes32 data) public returns (bool) {
628     _checkedTransfer(msg.sender, to, value);
629     emit TransferWithData(msg.sender, to, data, value);
630     return true;
631   }
632 
633   function transferFrom(
634     address from,
635     address to,
636     uint256 value
637   )
638     public
639     returns (bool)
640   {
641     require(value <= _allowed[from][msg.sender]);
642 
643     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
644     _checkedTransfer(from, to, value);
645     return true;
646   }
647 
648   function transferFromWithData(
649     address from,
650     address to,
651     uint256 value,
652     bytes32 data
653   )
654     public
655     returns (bool)
656   {
657     require(value <= _allowed[from][msg.sender]);
658 
659     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
660     _checkedTransfer(from, to, value);
661     emit TransferWithData(from, to, data, value);
662     return true;
663   }
664 
665   function _checkedTransfer(address from, address to, uint256 value) internal {
666     require(value <= _balances[from]);
667     require(to != address(0));
668 
669     
670     if(isPreventedAddr[to]) {
671       require(addressMapper.isAddressSet(from));
672     }
673 
674     _balances[from] = _balances[from].sub(value);
675     _balances[to] = _balances[to].add(value);
676     emit Transfer(from, to, value);
677   }
678 
679   function setIsPreventedAddr(address thisAddr, bool hbool)
680     public
681     onlyMinter
682   {
683     isPreventedAddr[thisAddr] = hbool;
684     emit SetIsPreventedAddr(thisAddr, hbool);
685   }
686 
687   constructor(address addressMapperAddr, uint256 cap, string name, string symbol, uint8 decimals)
688     ERC20Mintable(addressMapperAddr)
689     public
690   {
691     require(cap > 0);
692     _cap = cap;
693     _name = name;
694     _symbol = symbol;
695     _decimals = decimals;
696 
697   }
698 
699   /**
700    * @return the cap for the token minting.
701    */
702   function cap() public view returns(uint256) {
703     return _cap;
704   }
705 
706   function _mint(address account, uint256 value) internal {
707     require(totalSupply().add(value) <= _cap);
708     super._mint(account, value);
709   }
710 
711   /**
712    * @return the name of the token.
713    */
714   function name() public view returns(string) {
715     return _name;
716   }
717 
718   /**
719    * @return the symbol of the token.
720    */
721   function symbol() public view returns(string) {
722     return _symbol;
723   }
724 
725   /**
726    * @return the number of decimals of the token.
727    */
728   function decimals() public view returns(uint8) {
729     return _decimals;
730   }
731   
732 }