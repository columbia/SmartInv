1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Roles
55  * @author Francisco Giordano (@frangio)
56  * @dev Library for managing addresses assigned to a Role.
57  *      See RBAC.sol for example usage.
58  */
59 library Roles {
60   struct Role {
61     mapping (address => bool) bearer;
62   }
63 
64   /**
65    * @dev give an address access to this role
66    */
67   function add(Role storage role, address addr)
68     internal
69   {
70     role.bearer[addr] = true;
71   }
72 
73   /**
74    * @dev remove an address' access to this role
75    */
76   function remove(Role storage role, address addr)
77     internal
78   {
79     role.bearer[addr] = false;
80   }
81 
82   /**
83    * @dev check if an address has this role
84    * // reverts
85    */
86   function check(Role storage role, address addr)
87     view
88     internal
89   {
90     require(has(role, addr));
91   }
92 
93   /**
94    * @dev check if an address has this role
95    * @return bool
96    */
97   function has(Role storage role, address addr)
98     view
99     internal
100     returns (bool)
101   {
102     return role.bearer[addr];
103   }
104 }
105 
106 /**
107  * @title RBAC (Role-Based Access Control)
108  * @author Matt Condon (@Shrugs)
109  * @dev Stores and provides setters and getters for roles and addresses.
110  * @dev Supports unlimited numbers of roles and addresses.
111  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
112  * This RBAC method uses strings to key roles. It may be beneficial
113  *  for you to write your own implementation of this interface using Enums or similar.
114  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
115  *  to avoid typos.
116  */
117 contract RBAC {
118   using Roles for Roles.Role;
119 
120   mapping (string => Roles.Role) private roles;
121 
122   event RoleAdded(address addr, string roleName);
123   event RoleRemoved(address addr, string roleName);
124 
125   /**
126    * @dev reverts if addr does not have role
127    * @param addr address
128    * @param roleName the name of the role
129    * // reverts
130    */
131   function checkRole(address addr, string roleName)
132     view
133     public
134   {
135     roles[roleName].check(addr);
136   }
137 
138   /**
139    * @dev determine if addr has role
140    * @param addr address
141    * @param roleName the name of the role
142    * @return bool
143    */
144   function hasRole(address addr, string roleName)
145     view
146     public
147     returns (bool)
148   {
149     return roles[roleName].has(addr);
150   }
151 
152   /**
153    * @dev add a role to an address
154    * @param addr address
155    * @param roleName the name of the role
156    */
157   function addRole(address addr, string roleName)
158     internal
159   {
160     roles[roleName].add(addr);
161     emit RoleAdded(addr, roleName);
162   }
163 
164   /**
165    * @dev remove a role from an address
166    * @param addr address
167    * @param roleName the name of the role
168    */
169   function removeRole(address addr, string roleName)
170     internal
171   {
172     roles[roleName].remove(addr);
173     emit RoleRemoved(addr, roleName);
174   }
175 
176   /**
177    * @dev modifier to scope access to a single role (uses msg.sender as addr)
178    * @param roleName the name of the role
179    * // reverts
180    */
181   modifier onlyRole(string roleName)
182   {
183     checkRole(msg.sender, roleName);
184     _;
185   }
186 
187   /**
188    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
189    * @param roleNames the names of the roles to scope access to
190    * // reverts
191    *
192    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
193    *  see: https://github.com/ethereum/solidity/issues/2467
194    */
195   // modifier onlyRoles(string[] roleNames) {
196   //     bool hasAnyRole = false;
197   //     for (uint8 i = 0; i < roleNames.length; i++) {
198   //         if (hasRole(msg.sender, roleNames[i])) {
199   //             hasAnyRole = true;
200   //             break;
201   //         }
202   //     }
203 
204   //     require(hasAnyRole);
205 
206   //     _;
207   // }
208 }
209 
210 /**
211  * @title RBACWithAdmin
212  * @author Matt Condon (@Shrugs)
213  * @dev It's recommended that you define constants in the contract,
214  * @dev like ROLE_ADMIN below, to avoid typos.
215  */
216 contract RBACWithAdmin is RBAC {
217   /**
218    * A constant role name for indicating admins.
219    */
220   string public constant ROLE_ADMIN = "admin";
221 
222   /**
223    * @dev modifier to scope access to admins
224    * // reverts
225    */
226   modifier onlyAdmin()
227   {
228     checkRole(msg.sender, ROLE_ADMIN);
229     _;
230   }
231 
232   /**
233    * @dev constructor. Sets msg.sender as admin by default
234    */
235   constructor()
236     public
237   {
238     addRole(msg.sender, ROLE_ADMIN);
239   }
240 
241   /**
242    * @dev add a role to an address
243    * @param addr address
244    * @param roleName the name of the role
245    */
246   function adminAddRole(address addr, string roleName)
247     onlyAdmin
248     public
249   {
250     addRole(addr, roleName);
251   }
252 
253   /**
254    * @dev remove a role from an address
255    * @param addr address
256    * @param roleName the name of the role
257    */
258   function adminRemoveRole(address addr, string roleName)
259     onlyAdmin
260     public
261   {
262     removeRole(addr, roleName);
263   }
264 }
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   constructor() public {
283     owner = msg.sender;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(msg.sender == owner);
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to transfer control of the contract to a newOwner.
296    * @param newOwner The address to transfer ownership to.
297    */
298   function transferOwnership(address newOwner) public onlyOwner {
299     require(newOwner != address(0));
300     emit OwnershipTransferred(owner, newOwner);
301     owner = newOwner;
302   }
303 
304 }
305 
306 
307 /**
308  * @title ERC20Basic
309  * @dev Simpler version of ERC20 interface
310  * @dev see https://github.com/ethereum/EIPs/issues/179
311  */
312 contract ERC20Basic {
313   function totalSupply() public view returns (uint256);
314   function balanceOf(address who) public view returns (uint256);
315   function transfer(address to, uint256 value) public returns (bool);
316   event Transfer(address indexed from, address indexed to, uint256 value);
317 }
318 
319 /**
320  * @title Basic token
321  * @dev Basic version of StandardToken, with no allowances.
322  */
323 contract BasicToken is ERC20Basic {
324   using SafeMath for uint256;
325 
326   mapping(address => uint256) balances;
327 
328   uint256 totalSupply_;
329 
330   /**
331   * @dev total number of tokens in existence
332   */
333   function totalSupply() public view returns (uint256) {
334     return totalSupply_;
335   }
336 
337   /**
338   * @dev transfer token for a specified address
339   * @param _to The address to transfer to.
340   * @param _value The amount to be transferred.
341   */
342   function transfer(address _to, uint256 _value) public returns (bool) {
343     require(_to != address(0));
344     require(_value <= balances[msg.sender]);
345 
346     balances[msg.sender] = balances[msg.sender].sub(_value);
347     balances[_to] = balances[_to].add(_value);
348     emit Transfer(msg.sender, _to, _value);
349     return true;
350   }
351 
352   /**
353   * @dev Gets the balance of the specified address.
354   * @param _owner The address to query the the balance of.
355   * @return An uint256 representing the amount owned by the passed address.
356   */
357   function balanceOf(address _owner) public view returns (uint256) {
358     return balances[_owner];
359   }
360 
361 }
362 
363 /**
364  * @title ERC20 interface
365  * @dev see https://github.com/ethereum/EIPs/issues/20
366  */
367 contract ERC20 is ERC20Basic {
368   function allowance(address owner, address spender) public view returns (uint256);
369   function transferFrom(address from, address to, uint256 value) public returns (bool);
370   function approve(address spender, uint256 value) public returns (bool);
371   event Approval(address indexed owner, address indexed spender, uint256 value);
372 }
373 
374 contract DetailedERC20 is ERC20 {
375   string public name;
376   string public symbol;
377   uint8 public decimals;
378 
379   constructor(string _name, string _symbol, uint8 _decimals) public {
380     name = _name;
381     symbol = _symbol;
382     decimals = _decimals;
383   }
384 }
385 
386 /**
387  * @title Standard ERC20 token
388  *
389  * @dev Implementation of the basic standard token.
390  * @dev https://github.com/ethereum/EIPs/issues/20
391  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
392  */
393 contract StandardToken is ERC20, BasicToken {
394 
395   mapping (address => mapping (address => uint256)) internal allowed;
396 
397 
398   /**
399    * @dev Transfer tokens from one address to another
400    * @param _from address The address which you want to send tokens from
401    * @param _to address The address which you want to transfer to
402    * @param _value uint256 the amount of tokens to be transferred
403    */
404   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
405     require(_to != address(0));
406     require(_value <= balances[_from]);
407     require(_value <= allowed[_from][msg.sender]);
408 
409     balances[_from] = balances[_from].sub(_value);
410     balances[_to] = balances[_to].add(_value);
411     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
412     emit Transfer(_from, _to, _value);
413     return true;
414   }
415 
416   /**
417    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
418    *
419    * Beware that changing an allowance with this method brings the risk that someone may use both the old
420    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
421    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
422    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
423    * @param _spender The address which will spend the funds.
424    * @param _value The amount of tokens to be spent.
425    */
426   function approve(address _spender, uint256 _value) public returns (bool) {
427     allowed[msg.sender][_spender] = _value;
428     emit Approval(msg.sender, _spender, _value);
429     return true;
430   }
431 
432   /**
433    * @dev Function to check the amount of tokens that an owner allowed to a spender.
434    * @param _owner address The address which owns the funds.
435    * @param _spender address The address which will spend the funds.
436    * @return A uint256 specifying the amount of tokens still available for the spender.
437    */
438   function allowance(address _owner, address _spender) public view returns (uint256) {
439     return allowed[_owner][_spender];
440   }
441 
442   /**
443    * @dev Increase the amount of tokens that an owner allowed to a spender.
444    *
445    * approve should be called when allowed[_spender] == 0. To increment
446    * allowed value is better to use this function to avoid 2 calls (and wait until
447    * the first transaction is mined)
448    * From MonolithDAO Token.sol
449    * @param _spender The address which will spend the funds.
450    * @param _addedValue The amount of tokens to increase the allowance by.
451    */
452   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
453     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
454     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
455     return true;
456   }
457 
458   /**
459    * @dev Decrease the amount of tokens that an owner allowed to a spender.
460    *
461    * approve should be called when allowed[_spender] == 0. To decrement
462    * allowed value is better to use this function to avoid 2 calls (and wait until
463    * the first transaction is mined)
464    * From MonolithDAO Token.sol
465    * @param _spender The address which will spend the funds.
466    * @param _subtractedValue The amount of tokens to decrease the allowance by.
467    */
468   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
469     uint oldValue = allowed[msg.sender][_spender];
470     if (_subtractedValue > oldValue) {
471       allowed[msg.sender][_spender] = 0;
472     } else {
473       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
474     }
475     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
476     return true;
477   }
478 
479 }
480 
481 /**
482  * @title ERC865Token Token
483  *
484  * ERC865Token allows users paying transfers in tokens instead of gas
485  * https://github.com/ethereum/EIPs/issues/865
486  *
487  */
488 
489 contract ERC865 {
490 
491     function transferPreSigned(
492         bytes _signature,
493         address _to,
494         uint256 _value,
495         uint256 _fee,
496         uint256 _nonce
497     )
498         public
499         returns (bool);
500 
501     function approvePreSigned(
502         bytes _signature,
503         address _spender,
504         uint256 _value,
505         uint256 _fee,
506         uint256 _nonce
507     )
508         public
509         returns (bool);
510 
511     function increaseApprovalPreSigned(
512         bytes _signature,
513         address _spender,
514         uint256 _addedValue,
515         uint256 _fee,
516         uint256 _nonce
517     )
518         public
519         returns (bool);
520 
521     function decreaseApprovalPreSigned(
522         bytes _signature,
523         address _spender,
524         uint256 _subtractedValue,
525         uint256 _fee,
526         uint256 _nonce
527     )
528         public
529         returns (bool);
530 }
531 
532 /**
533  * @title ERC865Token Token
534  *
535  * ERC865Token allows users paying transfers in tokens instead of gas
536  * https://github.com/ethereum/EIPs/issues/865
537  *
538  */
539 
540 contract ERC865Token is ERC865, StandardToken, Ownable {
541 
542     /* Nonces of transfers performed */
543     mapping(bytes => bool) signatures;
544     /* mapping of nonces of each user */
545     mapping (address => uint256) nonces;
546 
547     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
548     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
549 
550     bytes4 internal constant transferSig = 0x48664c16;
551     bytes4 internal constant approvalSig = 0xf7ac9c2e;
552     bytes4 internal constant increaseApprovalSig = 0xa45f71ff;
553     bytes4 internal constant decreaseApprovalSig = 0x59388d78;
554 
555     //return nonce using function
556     function getNonce(address _owner) public view returns (uint256 nonce){
557       return nonces[_owner];
558     }
559 
560 
561     /**
562      * @notice Submit a presigned transfer
563      * @param _signature bytes The signature, issued by the owner.
564      * @param _to address The address which you want to transfer to.
565      * @param _value uint256 The amount of tokens to be transferred.
566      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
567      * @param _nonce uint256 Presigned transaction number.
568      */
569     function transferPreSigned(
570         bytes _signature,
571         address _to,
572         uint256 _value,
573         uint256 _fee,
574         uint256 _nonce
575     )
576         public
577         returns (bool)
578     {
579         require(_to != address(0));
580         require(signatures[_signature] == false);
581 
582         bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _to, _value, _fee, _nonce);
583         address from = recover(hashedTx, _signature);
584         require(from != address(0));
585         require(_nonce == nonces[from].add(1));
586         require(_value.add(_fee) <= balances[from]);
587 
588         nonces[from] = _nonce;
589         signatures[_signature] = true;
590         balances[from] = balances[from].sub(_value).sub(_fee);
591         balances[_to] = balances[_to].add(_value);
592         balances[msg.sender] = balances[msg.sender].add(_fee);
593 
594         emit Transfer(from, _to, _value);
595         emit Transfer(from, msg.sender, _fee);
596         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
597         return true;
598     }
599 
600     /**
601      * @notice Submit a presigned approval
602      * @param _signature bytes The signature, issued by the owner.
603      * @param _spender address The address which will spend the funds.
604      * @param _value uint256 The amount of tokens to allow.
605      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
606      * @param _nonce uint256 Presigned transaction number.
607      */
608     function approvePreSigned(
609         bytes _signature,
610         address _spender,
611         uint256 _value,
612         uint256 _fee,
613         uint256 _nonce
614     )
615         public
616         returns (bool)
617     {
618         require(_spender != address(0));
619         require(signatures[_signature] == false);
620 
621         bytes32 hashedTx = recoverPreSignedHash(address(this), approvalSig, _spender, _value, _fee, _nonce);
622         address from = recover(hashedTx, _signature);
623         require(from != address(0));
624         require(_nonce == nonces[from].add(1));
625         require(_value.add(_fee) <= balances[from]);
626 
627         nonces[from] = _nonce;
628         signatures[_signature] = true;
629         allowed[from][_spender] =_value;
630         balances[from] = balances[from].sub(_fee);
631         balances[msg.sender] = balances[msg.sender].add(_fee);
632 
633         emit Approval(from, _spender, _value);
634         emit Transfer(from, msg.sender, _fee);
635         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
636         return true;
637     }
638 
639     /**
640      * @notice Increase the amount of tokens that an owner allowed to a spender.
641      * @param _signature bytes The signature, issued by the owner.
642      * @param _spender address The address which will spend the funds.
643      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
644      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
645      * @param _nonce uint256 Presigned transaction number.
646      */
647     function increaseApprovalPreSigned(
648         bytes _signature,
649         address _spender,
650         uint256 _addedValue,
651         uint256 _fee,
652         uint256 _nonce
653     )
654         public
655         returns (bool)
656     {
657         require(_spender != address(0));
658         require(signatures[_signature] == false);
659 
660         bytes32 hashedTx = recoverPreSignedHash(address(this), increaseApprovalSig, _spender, _addedValue, _fee, _nonce);
661         address from = recover(hashedTx, _signature);
662         require(from != address(0));
663         require(_nonce == nonces[from].add(1));
664         require(allowed[from][_spender].add(_addedValue).add(_fee) <= balances[from]);
665         //require(_addedValue <= allowed[from][_spender]);
666 
667         nonces[from] = _nonce;
668         signatures[_signature] = true;
669         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
670         balances[from] = balances[from].sub(_fee);
671         balances[msg.sender] = balances[msg.sender].add(_fee);
672 
673         emit Approval(from, _spender, allowed[from][_spender]);
674         emit Transfer(from, msg.sender, _fee);
675         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
676         return true;
677     }
678 
679     /**
680      * @notice Decrease the amount of tokens that an owner allowed to a spender.
681      * @param _signature bytes The signature, issued by the owner
682      * @param _spender address The address which will spend the funds.
683      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
684      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
685      * @param _nonce uint256 Presigned transaction number.
686      */
687     function decreaseApprovalPreSigned(
688         bytes _signature,
689         address _spender,
690         uint256 _subtractedValue,
691         uint256 _fee,
692         uint256 _nonce
693     )
694         public
695         returns (bool)
696     {
697         require(_spender != address(0));
698         require(signatures[_signature] == false);
699 
700         bytes32 hashedTx = recoverPreSignedHash(address(this), decreaseApprovalSig, _spender, _subtractedValue, _fee, _nonce);
701         address from = recover(hashedTx, _signature);
702         require(from != address(0));
703         require(_nonce == nonces[from].add(1));
704         //require(_subtractedValue <= balances[from]);
705         //require(_subtractedValue <= allowed[from][_spender]);
706         //require(_subtractedValue <= allowed[from][_spender]);
707         require(_fee <= balances[from]);
708 
709         nonces[from] = _nonce;
710         signatures[_signature] = true;
711         uint oldValue = allowed[from][_spender];
712         if (_subtractedValue > oldValue) {
713             allowed[from][_spender] = 0;
714         } else {
715             allowed[from][_spender] = oldValue.sub(_subtractedValue);
716         }
717         balances[from] = balances[from].sub(_fee);
718         balances[msg.sender] = balances[msg.sender].add(_fee);
719 
720         emit Approval(from, _spender, _subtractedValue);
721         emit Transfer(from, msg.sender, _fee);
722         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
723         return true;
724     }
725 
726     /**
727      * @notice Transfer tokens from one address to another
728      * @param _signature bytes The signature, issued by the spender.
729      * @param _from address The address which you want to send tokens from.
730      * @param _to address The address which you want to transfer to.
731      * @param _value uint256 The amount of tokens to be transferred.
732      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
733      * @param _nonce uint256 Presigned transaction number.
734      */
735     /*function transferFromPreSigned(
736         bytes _signature,
737         address _from,
738         address _to,
739         uint256 _value,
740         uint256 _fee,
741         uint256 _nonce
742     )
743         public
744         returns (bool)
745     {
746         require(_to != address(0));
747         require(signatures[_signature] == false);
748         signatures[_signature] = true;
749 
750         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
751 
752         address spender = recover(hashedTx, _signature);
753         require(spender != address(0));
754         require(_value.add(_fee) <= balances[_from])​;
755 
756         balances[_from] = balances[_from].sub(_value);
757         balances[_to] = balances[_to].add(_value);
758         allowed[_from][spender] = allowed[_from][spender].sub(_value);
759 
760         balances[spender] = balances[spender].sub(_fee);
761         balances[msg.sender] = balances[msg.sender].add(_fee);
762 
763         emit Transfer(_from, _to, _value);
764         emit Transfer(spender, msg.sender, _fee);
765         return true;
766     }*/
767 
768      /**
769       * @notice Hash (keccak256) of the payload used by recoverPreSignedHash
770       * @param _token address The address of the token
771       * @param _spender address The address which will spend the funds.
772       * @param _value uint256 The amount of tokens.
773       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
774       * @param _nonce uint256 Presigned transaction number.
775       */    
776     function recoverPreSignedHash(
777         address _token,
778         bytes4 _functionSig,
779         address _spender,
780         uint256 _value,
781         uint256 _fee,
782         uint256 _nonce
783         )
784       public pure returns (bytes32)
785       {
786         return keccak256(_token, _functionSig, _spender, _value, _fee, _nonce);
787     }
788 
789     /**
790      * @notice Recover signer address from a message by using his signature
791      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
792      * @param sig bytes signature, the signature is generated using web3.eth.sign()
793      */
794     function recover(bytes32 hash, bytes sig) public pure returns (address) {
795       bytes32 r;
796       bytes32 s;
797       uint8 v;
798 
799       //Check the signature length
800       if (sig.length != 65) {
801         return (address(0));
802       }
803 
804       // Divide the signature in r, s and v variables
805       assembly {
806         r := mload(add(sig, 32))
807         s := mload(add(sig, 64))
808         v := byte(0, mload(add(sig, 96)))
809       }
810 
811       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
812       if (v < 27) {
813         v += 27;
814       }
815 
816       // If the version is correct return the signer address
817       if (v != 27 && v != 28) {
818         return (address(0));
819       } else {
820         return ecrecover(hash, v, r, s);
821       }
822     }
823 
824 }
825 
826 contract BeepToken is ERC865Token, RBAC{
827 
828     string public constant name = "Beepnow Token";
829     string public constant symbol = "BPN";
830     uint8 public constant decimals = 0;
831     
832     /* Mapping of whitelisted users */
833     mapping (address => bool) transfersBlacklist;
834     string constant ROLE_ADMIN = "admin";
835     string constant ROLE_DELEGATE = "delegate";
836 
837     bytes4 internal constant transferSig = 0x48664c16;
838 
839     event UserInsertedInBlackList(address indexed user);
840     event UserRemovedFromBlackList(address indexed user);
841     event TransferWhitelistOnly(bool flag);
842     event DelegatedEscrow(address indexed guest, address indexed beeper, uint256 total, uint256 nonce, bytes signature);
843     event DelegatedRemittance(address indexed guest, address indexed beeper, uint256 value, uint256 _fee, uint256 nonce, bytes signature);
844 
845 	modifier onlyAdmin() {
846         require(hasRole(msg.sender, ROLE_ADMIN));
847         _;
848     }
849 
850     modifier onlyAdminOrDelegates() {
851         require(hasRole(msg.sender, ROLE_ADMIN) || hasRole(msg.sender, ROLE_DELEGATE));
852         _;
853     }
854 
855     /*modifier onlyWhitelisted(bytes _signature, address _from, uint256 _value, uint256 _fee, uint256 _nonce) {
856         bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _from, _value, _fee, _nonce);
857         address from = recover(hashedTx, _signature);
858         require(!isUserInBlackList(from));
859         _;
860     }*/
861 
862     function onlyWhitelisted(bytes _signature, address _from, uint256 _value, uint256 _fee, uint256 _nonce) internal view returns(bool) {
863         bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _from, _value, _fee, _nonce);
864         address from = recover(hashedTx, _signature);
865         require(!isUserInBlackList(from));
866         return true;
867     }
868 
869     function addAdmin(address _addr) onlyOwner public {
870         addRole(_addr, ROLE_ADMIN);
871     }
872 
873     function removeAdmin(address _addr) onlyOwner public {
874         removeRole(_addr, ROLE_ADMIN);
875     }
876 
877     function addDelegate(address _addr) onlyAdmin public {
878         addRole(_addr, ROLE_DELEGATE);
879     }
880 
881     function removeDelegate(address _addr) onlyAdmin public {
882         removeRole(_addr, ROLE_DELEGATE);
883     }
884 
885     constructor(address _Admin, address reserve) public {
886         require(_Admin != address(0));
887         require(reserve != address(0));
888         totalSupply_ = 17500000000;
889 		balances[reserve] = totalSupply_;
890         emit Transfer(address(0), reserve, totalSupply_);
891         addRole(_Admin, ROLE_ADMIN);
892     }
893 
894     /**
895      * Is the address allowed to transfer
896      * @return true if the sender can transfer
897      */
898     function isUserInBlackList(address _user) public constant returns (bool) {
899         require(_user != 0x0);
900         return transfersBlacklist[_user];
901     }
902 
903 
904     /**
905      *  User removed from Blacklist
906      */
907     function whitelistUserForTransfers(address _user) onlyAdmin public {
908         require(isUserInBlackList(_user));
909         transfersBlacklist[_user] = false;
910         emit UserRemovedFromBlackList(_user);
911     }
912 
913     /**
914      *  User inserted into Blacklist
915      */
916     function blacklistUserForTransfers(address _user) onlyAdmin public {
917         require(!isUserInBlackList(_user));
918         transfersBlacklist[_user] = true;
919         emit UserInsertedInBlackList(_user);
920     }
921 
922     /**
923     * @notice transfer token for a specified address
924     * @param _to The address to transfer to.
925     * @param _value The amount to be transferred.
926     */
927     function transfer(address _to, uint256 _value) public returns (bool) {
928         require(!isUserInBlackList(msg.sender));
929         return super.transfer(_to, _value);
930     }
931 
932     /**
933      * @notice Transfer tokens from one address to another
934      * @param _from address The address which you want to send tokens from
935      * @param _to address The address which you want to transfer to
936      * @param _value uint256 the amount of tokens to be transferred
937      */
938     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
939         require(_from != address(0));
940         require(_to != address(0));
941         require(!isUserInBlackList(_from));
942         return super.transferFrom(_from, _to, _value);
943     }
944 
945     function transferPreSigned(bytes _signature, address _to, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdminOrDelegates public returns (bool){
946         require(_to != address(0));
947         onlyWhitelisted(_signature, _to, _value, _fee, _nonce);
948         return super.transferPreSigned(_signature, _to, _value, _fee, _nonce);
949     }
950 
951     function approvePreSigned(bytes _signature, address _spender, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdminOrDelegates public returns (bool){
952         require(_spender != address(0));
953         onlyWhitelisted(_signature, _spender, _value, _fee, _nonce);
954         return super.approvePreSigned(_signature, _spender, _value, _fee, _nonce);
955     }
956 
957     function increaseApprovalPreSigned(bytes _signature, address _spender, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdminOrDelegates public returns (bool){
958         require(_spender != address(0));
959         onlyWhitelisted(_signature, _spender, _value, _fee, _nonce);
960         return super.increaseApprovalPreSigned(_signature, _spender, _value, _fee, _nonce);
961     }
962 
963     function decreaseApprovalPreSigned(bytes _signature, address _spender, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdminOrDelegates public returns (bool){
964         require(_spender != address(0));
965         onlyWhitelisted(_signature, _spender, _value, _fee, _nonce);
966         return super.decreaseApprovalPreSigned(_signature, _spender, _value, _fee, _nonce);
967     }
968 
969     /*function transferFromPreSigned(bytes _signature, address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdminOrDelegates public returns (bool){
970         require(_from != address(0));
971         require(_to != address(0));
972         onlyWhitelisted(_signature, _spender, _value, _fee, _nonce);
973         return super.transferPreSigned(_signature, _to, _value, _fee, _nonce);
974     }*/
975 
976     /* Locking funds. User signs the offline transaction and the admin will execute this, through which the admin account the funds */
977     function delegatedSignedEscrow(bytes _signature, address _from, address _to, address _admin, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdmin public returns (bool){
978         require(_from != address(0));
979         require(_to != address(0));
980         require(_admin != address(0));
981         onlyWhitelisted(_signature, _from, _value, _fee, _nonce); 
982         require(hasRole(_admin, ROLE_ADMIN));
983         require(_nonce == nonces[_from].add(1));
984         require(signatures[_signature] == false);
985         uint256 _total = _value.add(_fee);
986         require(_total <= balances[_from]);
987 
988         nonces[_from] = _nonce;
989         signatures[_signature] = true;
990         balances[_from] = balances[_from].sub(_total);
991         balances[_admin] = balances[_admin].add(_total);
992 
993         emit Transfer(_from, _admin, _total);
994         emit DelegatedEscrow(_from, _to, _total, _nonce, _signature);
995         return true;
996     }
997 
998     /* Releasing funds.  User signs the offline transaction and the admin will execute this, in which other user receives the funds. */
999     function delegatedSignedRemittance(bytes _signature, address _from, address _to, address _admin, uint256 _value, uint256 _fee, uint256 _nonce) onlyAdmin public returns (bool){
1000         require(_from != address(0));
1001         require(_to != address(0));
1002         require(_admin != address(0));
1003         onlyWhitelisted(_signature, _from, _value, _fee, _nonce);
1004         require(hasRole(_admin, ROLE_ADMIN));
1005         require(_nonce == nonces[_from].add(1));
1006         require(signatures[_signature] == false);
1007         require(_value.add(_fee) <= balances[_from]);
1008 
1009         nonces[_from] = _nonce;
1010         signatures[_signature] = true;
1011         balances[_from] = balances[_from].sub(_value).sub(_fee);
1012         balances[_admin] = balances[_admin].add(_fee);
1013         balances[_to] = balances[_to].add(_value);
1014 
1015         emit Transfer(_from, _to, _value);
1016         emit Transfer(_from, _admin, _fee);
1017         emit DelegatedRemittance(_from, _to, _value, _fee, _nonce, _signature);
1018         return true;
1019     }
1020     
1021 }