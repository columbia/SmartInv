1 pragma solidity ^0.4.21;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an address access to this role
10    */
11   function add(Role storage role, address addr)
12     internal
13   {
14     role.bearer[addr] = true;
15   }
16 
17   /**
18    * @dev remove an address' access to this role
19    */
20   function remove(Role storage role, address addr)
21     internal
22   {
23     role.bearer[addr] = false;
24   }
25 
26   /**
27    * @dev check if an address has this role
28    * // reverts
29    */
30   function check(Role storage role, address addr)
31     view
32     internal
33   {
34     require(has(role, addr));
35   }
36 
37   /**
38    * @dev check if an address has this role
39    * @return bool
40    */
41   function has(Role storage role, address addr)
42     view
43     internal
44     returns (bool)
45   {
46     return role.bearer[addr];
47   }
48 }
49 
50 
51 
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 
61 
62 
63 
64 
65 contract AccessControl {
66     using Roles for Roles.Role;
67 
68     mapping (string => Roles.Role) private roles;
69 
70     event RoleAdded(address addr, string roleName);
71     event RoleRemoved(address addr, string roleName);
72 
73     /**
74      * @dev reverts if addr does not have role
75      * @param addr address
76      * @param roleName the name of the role
77      * // reverts
78      */
79     function checkRole(address addr, string roleName)
80     view
81     public
82     {
83         roles[roleName].check(addr);
84     }
85 
86     /**
87      * @dev determine if addr has role
88      * @param addr address
89      * @param roleName the name of the role
90      * @return bool
91      */
92     function hasRole(address addr, string roleName)
93     view
94     public
95     returns (bool)
96     {
97         return roles[roleName].has(addr);
98     }
99 
100     /**
101      * @dev add a role to an address
102      * @param addr address
103      * @param roleName the name of the role
104      */
105     function addRole(address addr, string roleName)
106     internal
107     {
108         roles[roleName].add(addr);
109         emit RoleAdded(addr, roleName);
110     }
111 
112     /**
113      * @dev remove a role from an address
114      * @param addr address
115      * @param roleName the name of the role
116      */
117     function removeRole(address addr, string roleName)
118     internal
119     {
120         roles[roleName].remove(addr);
121         emit RoleRemoved(addr, roleName);
122     }
123 
124     /**
125      * @dev modifier to scope access to a single role (uses msg.sender as addr)
126      * @param roleName the name of the role
127      * // reverts
128      */
129     modifier onlyRole(string roleName)
130     {
131         checkRole(msg.sender, roleName);
132         _;
133     }
134 
135 }
136 
137 
138 
139 /**
140  * @title Ownable
141  * @dev The Ownable contract has an owner address, and provides basic authorization control
142  * functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable {
145   address public owner;
146 
147 
148   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150 
151   /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155   constructor() public {
156     owner = msg.sender;
157   }
158 
159   /**
160    * @dev Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner);
164     _;
165   }
166 
167   /**
168    * @dev Allows the current owner to transfer control of the contract to a newOwner.
169    * @param newOwner The address to transfer ownership to.
170    */
171   function transferOwnership(address newOwner) public onlyOwner {
172     require(newOwner != address(0));
173     emit OwnershipTransferred(owner, newOwner);
174     owner = newOwner;
175   }
176 
177 }
178 
179 
180 
181 
182 
183 
184 
185 
186 contract AccessControlManager is AccessControl {
187 
188     string public constant SUPER_ADMIN = "superAdmin";
189     string public constant LIMITED_ADMIN = "limitedAdmin";
190 
191     /**
192      * @dev modifier to scope access to admins
193      * // reverts
194      */
195     modifier onlyAdmin()
196     {
197         checkRole(msg.sender, SUPER_ADMIN);
198         _;
199     }
200 
201     /**
202      * @dev modifier to check adding/removing roles
203      *
204      */
205     modifier canUpdateRole(string role){
206         if ((keccak256(abi.encodePacked(role)) != keccak256(abi.encodePacked(SUPER_ADMIN)) && (hasRole(msg.sender, SUPER_ADMIN) || hasRole(msg.sender, LIMITED_ADMIN))))
207         _;
208     }
209 
210     /**
211      * @dev constructor. Sets msg.sender as admin by default
212      */
213     constructor()
214     public
215     {
216         addRole(msg.sender, SUPER_ADMIN);
217     }
218 
219     /**
220      * @dev add admin role to an address
221      * @param addr address
222      */
223     function addAdmin(address addr)
224     onlyAdmin
225     public
226     {
227         addRole(addr, SUPER_ADMIN);
228     }
229 
230     /**
231      * @dev remove a role from an address
232      * @param addr address
233      */
234     function removeAdmin(address addr)
235     onlyAdmin
236     public
237     {
238         require(msg.sender != addr);
239         removeRole(addr, SUPER_ADMIN);
240     }
241 
242     /**
243      * @dev add a role to an address
244      * @param addr address
245      * @param roleName the name of the role
246      */
247     function adminAddRole(address addr, string roleName)
248     canUpdateRole(roleName)
249     public
250     {
251         addRole(addr, roleName);
252     }
253 
254 
255     /**
256      * @dev remove a role from an address
257      * @param addr address
258      * @param roleName the name of the role
259      */
260     function adminRemoveRole(address addr, string roleName)
261     canUpdateRole(roleName)
262     public
263     {
264         removeRole(addr, roleName);
265     }
266 
267 
268     /**
269      * @dev add a role to an addresses array
270      * solidity dosen't supports dynamic arrays as arguments so only one role at time.
271      * @param addrs addresses
272      * @param roleName the name of the role
273      */
274     function adminAddRoles(address[] addrs, string roleName)
275     public
276     {
277         for (uint256 i = 0; i < addrs.length; i++) {
278             adminAddRole(addrs[i],roleName);
279         }
280     }
281 
282 
283     /**
284      * @dev remove a specific role from an addresses array
285      * solidity dosen't supports dynamic arrays as arguments so only one role at time.
286      * @param addrs addresses
287      * @param roleName the name of the role
288      */
289     function adminRemoveRoles(address[] addrs, string roleName)
290     public
291     {
292         for (uint256 i = 0; i < addrs.length; i++) {
293             adminRemoveRole(addrs[i],roleName);
294         }
295     }
296 
297 
298 }
299 
300 
301 
302 contract AccessControlClient {
303 
304 
305     AccessControlManager public acm;
306 
307 
308     constructor(AccessControlManager addr) public {
309         acm = AccessControlManager(addr);
310     }
311 
312     /**
313     * @dev add a role to an address
314     * ONLY WITH RELEVANT ROLES!!
315     * @param addr address
316     * @param roleName the name of the role
317     */
318     function addRole(address addr, string roleName)
319     public
320     {
321         acm.adminAddRole(addr,roleName);
322     }
323 
324 
325     /**
326      * @dev remove a role from an address
327      * ONLY WITH RELEVANT ROLES!!
328      * @param addr address
329      * @param roleName the name of the role
330      */
331     function removeRole(address addr, string roleName)
332     public
333     {
334         acm.adminRemoveRole(addr,roleName);
335     }
336 
337     /**
338      * @dev add a role to an addresses array
339      * ONLY WITH RELEVANT ROLES!!
340      * solidity dosen't supports dynamic arrays as arguments so only one role at time.
341      * @param addrs addresses
342      * @param roleName the name of the role
343      */
344     function addRoles(address[] addrs, string roleName)
345     public
346     {
347         acm.adminAddRoles(addrs,roleName);
348 
349     }
350 
351 
352     /**
353      * @dev remove a specific role from an addresses array
354      * ONLY WITH RELEVANT ROLES!!
355      * solidity dosen't supports dynamic arrays as arguments so only one role at time.
356      * @param addrs addresses
357      * @param roleName the name of the role
358      */
359     function removeRoles(address[] addrs, string roleName)
360     public
361     {
362         acm.adminRemoveRoles(addrs,roleName);
363     }
364 
365     /**
366      * @dev reverts if addr does not have role
367      * @param addr address
368      * @param roleName the name of the role
369      * // reverts
370      */
371     function checkRole(address addr, string roleName)
372     view
373     public
374     {
375         acm.checkRole(addr, roleName);
376     }
377 
378     /**
379      * @dev determine if addr has role
380      * @param addr address
381      * @param roleName the name of the role
382      * @return bool
383      */
384     function hasRole(address addr, string roleName)
385     view
386     public
387     returns (bool)
388     {
389         return acm.hasRole(addr, roleName);
390     }
391 
392 
393 }
394 
395 
396 
397 
398 
399 
400 
401 
402 
403 
404 
405 
406 contract ERC20 is ERC20Basic {
407   function allowance(address owner, address spender) public view returns (uint256);
408   function transferFrom(address from, address to, uint256 value) public returns (bool);
409   function approve(address spender, uint256 value) public returns (bool);
410   event Approval(address indexed owner, address indexed spender, uint256 value);
411 }
412 
413 
414 
415 contract DetailedERC20 is ERC20 {
416     string public name;
417 
418     string public symbol;
419 
420     uint8 public decimals;
421 
422 constructor (string _name, string _symbol, uint8 _decimals) public {
423 name = _name;
424 symbol = _symbol;
425 decimals = _decimals;
426 }
427 }
428 
429 
430 
431 
432 
433 
434 
435 
436 
437 
438 /**
439  * @title SafeMath
440  * @dev Math operations with safety checks that throw on error
441  */
442 library SafeMath {
443 
444   /**
445   * @dev Multiplies two numbers, throws on overflow.
446   */
447   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
448     if (a == 0) {
449       return 0;
450     }
451     c = a * b;
452     assert(c / a == b);
453     return c;
454   }
455 
456   /**
457   * @dev Integer division of two numbers, truncating the quotient.
458   */
459   function div(uint256 a, uint256 b) internal pure returns (uint256) {
460     // assert(b > 0); // Solidity automatically throws when dividing by 0
461     // uint256 c = a / b;
462     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
463     return a / b;
464   }
465 
466   /**
467   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
468   */
469   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470     assert(b <= a);
471     return a - b;
472   }
473 
474   /**
475   * @dev Adds two numbers, throws on overflow.
476   */
477   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
478     c = a + b;
479     assert(c >= a);
480     return c;
481   }
482 }
483 
484 
485 
486 /**
487  * @title Basic token
488  * @dev Basic version of StandardToken, with no allowances.
489  */
490 contract BasicToken is ERC20Basic {
491   using SafeMath for uint256;
492 
493   mapping(address => uint256) balances;
494 
495   uint256 totalSupply_;
496 
497   /**
498   * @dev total number of tokens in existence
499   */
500   function totalSupply() public view returns (uint256) {
501     return totalSupply_;
502   }
503 
504   /**
505   * @dev transfer token for a specified address
506   * @param _to The address to transfer to.
507   * @param _value The amount to be transferred.
508   */
509   function transfer(address _to, uint256 _value) public returns (bool) {
510     require(_to != address(0));
511     require(_value <= balances[msg.sender]);
512 
513     balances[msg.sender] = balances[msg.sender].sub(_value);
514     balances[_to] = balances[_to].add(_value);
515     emit Transfer(msg.sender, _to, _value);
516     return true;
517   }
518 
519   /**
520   * @dev Gets the balance of the specified address.
521   * @param _owner The address to query the the balance of.
522   * @return An uint256 representing the amount owned by the passed address.
523   */
524   function balanceOf(address _owner) public view returns (uint256) {
525     return balances[_owner];
526   }
527 
528 }
529 
530 
531 
532 contract BurnableToken is BasicToken {
533 
534   event Burn(address indexed burner, uint256 value);
535 
536   /**
537    * @dev Burns a specific amount of tokens.
538    * @param _value The amount of token to be burned.
539    */
540   function burn(uint256 _value) public {
541     _burn(msg.sender, _value);
542   }
543 
544   function _burn(address _who, uint256 _value) internal {
545     require(_value <= balances[_who]);
546     // no need to require value <= totalSupply, since that would imply the
547     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
548 
549     balances[_who] = balances[_who].sub(_value);
550     totalSupply_ = totalSupply_.sub(_value);
551     emit Burn(_who, _value);
552     emit Transfer(_who, address(0), _value);
553   }
554 }
555 
556 
557 
558 
559 
560 
561 
562 
563 
564 contract StandardToken is ERC20, BasicToken {
565 
566   mapping (address => mapping (address => uint256)) internal allowed;
567 
568 
569   /**
570    * @dev Transfer tokens from one address to another
571    * @param _from address The address which you want to send tokens from
572    * @param _to address The address which you want to transfer to
573    * @param _value uint256 the amount of tokens to be transferred
574    */
575   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
576     require(_to != address(0));
577     require(_value <= balances[_from]);
578     require(_value <= allowed[_from][msg.sender]);
579 
580     balances[_from] = balances[_from].sub(_value);
581     balances[_to] = balances[_to].add(_value);
582     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
583     emit Transfer(_from, _to, _value);
584     return true;
585   }
586 
587   /**
588    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
589    *
590    * Beware that changing an allowance with this method brings the risk that someone may use both the old
591    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
592    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
593    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
594    * @param _spender The address which will spend the funds.
595    * @param _value The amount of tokens to be spent.
596    */
597   function approve(address _spender, uint256 _value) public returns (bool) {
598     allowed[msg.sender][_spender] = _value;
599     emit Approval(msg.sender, _spender, _value);
600     return true;
601   }
602 
603   /**
604    * @dev Function to check the amount of tokens that an owner allowed to a spender.
605    * @param _owner address The address which owns the funds.
606    * @param _spender address The address which will spend the funds.
607    * @return A uint256 specifying the amount of tokens still available for the spender.
608    */
609   function allowance(address _owner, address _spender) public view returns (uint256) {
610     return allowed[_owner][_spender];
611   }
612 
613   /**
614    * @dev Increase the amount of tokens that an owner allowed to a spender.
615    *
616    * approve should be called when allowed[_spender] == 0. To increment
617    * allowed value is better to use this function to avoid 2 calls (and wait until
618    * the first transaction is mined)
619    * From MonolithDAO Token.sol
620    * @param _spender The address which will spend the funds.
621    * @param _addedValue The amount of tokens to increase the allowance by.
622    */
623   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
624     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
625     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
626     return true;
627   }
628 
629   /**
630    * @dev Decrease the amount of tokens that an owner allowed to a spender.
631    *
632    * approve should be called when allowed[_spender] == 0. To decrement
633    * allowed value is better to use this function to avoid 2 calls (and wait until
634    * the first transaction is mined)
635    * From MonolithDAO Token.sol
636    * @param _spender The address which will spend the funds.
637    * @param _subtractedValue The amount of tokens to decrease the allowance by.
638    */
639   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
640     uint oldValue = allowed[msg.sender][_spender];
641     if (_subtractedValue > oldValue) {
642       allowed[msg.sender][_spender] = 0;
643     } else {
644       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
645     }
646     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
647     return true;
648   }
649 
650 }
651 
652 
653 
654 
655 contract MintableToken is StandardToken {
656   event Mint(address indexed to, uint256 amount);
657   event MintFinished();
658 
659 
660   modifier canMint() {
661     _;
662   }
663 
664   modifier canReceive(address addr) {
665     _;
666   }
667 
668   /**
669    * @dev Function to mint tokens
670    * @param _to The address that will receive the minted tokens.
671    * @param _amount The amount of tokens to mint.
672    * @return A boolean that indicates if the operation was successful.
673    */
674   function mint(address _to, uint256 _amount) canMint canReceive(_to) public returns (bool) {
675     totalSupply_ = totalSupply_.add(_amount);
676     balances[_to] = balances[_to].add(_amount);
677     emit Mint(_to, _amount);
678     emit Transfer(address(0), _to, _amount);
679     return true;
680   }
681 
682 
683 }
684 
685 
686 
687 
688 contract CaratToken is MintableToken, BurnableToken, DetailedERC20, AccessControlClient {
689 
690 
691     string public constant SUPER_ADMIN = "superAdmin";
692 
693     string public constant LIMITED_ADMIN = "limitedAdmin";
694 
695     string public constant KYC_ROLE = "KycEnabled";
696 
697 
698     //Token Spec
699     string public constant NAME = "Carats Token";
700 
701     string public constant SYMBOL = "CARAT";
702 
703     uint8 public constant DECIMALS = 18;
704 
705 
706 
707     /**
708       * @dev Throws if called by any account other than the minters(ACM) or if the minting period finished.
709       */
710     modifier canMint() {
711         require(_isMinter(msg.sender));
712         _;
713     }
714 
715 
716     /**
717       * @dev Throws if minted to any account other than the KYC
718       */
719     modifier canReceive(address addr) {
720         if(hasRole(addr, KYC_ROLE) || hasRole(addr, LIMITED_ADMIN) || hasRole(addr, SUPER_ADMIN)){
721             _;
722         }
723     }
724 
725 
726     constructor (AccessControlManager acm)
727                  AccessControlClient(acm)
728                  DetailedERC20(NAME, SYMBOL,DECIMALS) public
729                  {}
730 
731 
732 
733     function _isMinter(address addr) internal view returns (bool) {
734     return hasRole(addr, SUPER_ADMIN) || hasRole(addr, LIMITED_ADMIN);
735     }
736 }