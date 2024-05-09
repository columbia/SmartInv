1 pragma solidity ^0.4.24;
2 
3 contract OwnableToken {
4     mapping (address => bool) owners;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     event OwnershipExtended(address indexed host, address indexed guest);
8 
9     modifier onlyOwner() {
10         require(owners[msg.sender]);
11         _;
12     }
13 
14     function OwnableToken() public {
15         owners[msg.sender] = true;
16     }
17 
18     function addOwner(address guest) public onlyOwner {
19         require(guest != address(0));
20         owners[guest] = true;
21         emit OwnershipExtended(msg.sender, guest);
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         require(newOwner != address(0));
26         owners[newOwner] = true;
27         delete owners[msg.sender];
28         emit OwnershipTransferred(msg.sender, newOwner);
29     }
30 }
31 
32 contract RBAC {
33   using Roles for Roles.Role;
34 
35   mapping (string => Roles.Role) private roles;
36 
37   event RoleAdded(address indexed operator, string role);
38   event RoleRemoved(address indexed operator, string role);
39 
40   /**
41    * @dev reverts if addr does not have role
42    * @param _operator address
43    * @param _role the name of the role
44    * // reverts
45    */
46   function checkRole(address _operator, string _role)
47     view
48     public
49   {
50     roles[_role].check(_operator);
51   }
52 
53   /**
54    * @dev determine if addr has role
55    * @param _operator address
56    * @param _role the name of the role
57    * @return bool
58    */
59   function hasRole(address _operator, string _role)
60     view
61     public
62     returns (bool)
63   {
64     return roles[_role].has(_operator);
65   }
66 
67   /**
68    * @dev add a role to an address
69    * @param _operator address
70    * @param _role the name of the role
71    */
72   function addRole(address _operator, string _role)
73     internal
74   {
75     roles[_role].add(_operator);
76     emit RoleAdded(_operator, _role);
77   }
78 
79   /**
80    * @dev remove a role from an address
81    * @param _operator address
82    * @param _role the name of the role
83    */
84   function removeRole(address _operator, string _role)
85     internal
86   {
87     roles[_role].remove(_operator);
88     emit RoleRemoved(_operator, _role);
89   }
90 
91   /**
92    * @dev modifier to scope access to a single role (uses msg.sender as addr)
93    * @param _role the name of the role
94    * // reverts
95    */
96   modifier onlyRole(string _role)
97   {
98     checkRole(msg.sender, _role);
99     _;
100   }
101 
102   /**
103    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
104    * @param _roles the names of the roles to scope access to
105    * // reverts
106    *
107    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
108    *  see: https://github.com/ethereum/solidity/issues/2467
109    */
110   // modifier onlyRoles(string[] _roles) {
111   //     bool hasAnyRole = false;
112   //     for (uint8 i = 0; i < _roles.length; i++) {
113   //         if (hasRole(msg.sender, _roles[i])) {
114   //             hasAnyRole = true;
115   //             break;
116   //         }
117   //     }
118 
119   //     require(hasAnyRole);
120 
121   //     _;
122   // }
123 }
124 
125 library Roles {
126   struct Role {
127     mapping (address => bool) bearer;
128   }
129 
130   /**
131    * @dev give an address access to this role
132    */
133   function add(Role storage _role, address _addr)
134     internal
135   {
136     _role.bearer[_addr] = true;
137   }
138 
139   /**
140    * @dev remove an address' access to this role
141    */
142   function remove(Role storage _role, address _addr)
143     internal
144   {
145     _role.bearer[_addr] = false;
146   }
147 
148   /**
149    * @dev check if an address has this role
150    * // reverts
151    */
152   function check(Role storage _role, address _addr)
153     view
154     internal
155   {
156     require(has(_role, _addr));
157   }
158 
159   /**
160    * @dev check if an address has this role
161    * @return bool
162    */
163   function has(Role storage _role, address _addr)
164     view
165     internal
166     returns (bool)
167   {
168     return _role.bearer[_addr];
169   }
170 }
171 
172 library SafeMath {
173 
174   /**
175   * @dev Multiplies two numbers, throws on overflow.
176   */
177   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
178     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
179     // benefit is lost if 'b' is also tested.
180     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
181     if (_a == 0) {
182       return 0;
183     }
184 
185     c = _a * _b;
186     assert(c / _a == _b);
187     return c;
188   }
189 
190   /**
191   * @dev Integer division of two numbers, truncating the quotient.
192   */
193   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
194     // assert(_b > 0); // Solidity automatically throws when dividing by 0
195     // uint256 c = _a / _b;
196     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
197     return _a / _b;
198   }
199 
200   /**
201   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
202   */
203   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
204     assert(_b <= _a);
205     return _a - _b;
206   }
207 
208   /**
209   * @dev Adds two numbers, throws on overflow.
210   */
211   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
212     c = _a + _b;
213     assert(c >= _a);
214     return c;
215   }
216 }
217 
218 contract Ownable {
219   address public owner;
220 
221 
222   event OwnershipRenounced(address indexed previousOwner);
223   event OwnershipTransferred(
224     address indexed previousOwner,
225     address indexed newOwner
226   );
227 
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   constructor() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to relinquish control of the contract.
247    * @notice Renouncing to ownership will leave the contract without an owner.
248    * It will not be possible to call the functions with the `onlyOwner`
249    * modifier anymore.
250    */
251   function renounceOwnership() public onlyOwner {
252     emit OwnershipRenounced(owner);
253     owner = address(0);
254   }
255 
256   /**
257    * @dev Allows the current owner to transfer control of the contract to a newOwner.
258    * @param _newOwner The address to transfer ownership to.
259    */
260   function transferOwnership(address _newOwner) public onlyOwner {
261     _transferOwnership(_newOwner);
262   }
263 
264   /**
265    * @dev Transfers control of the contract to a newOwner.
266    * @param _newOwner The address to transfer ownership to.
267    */
268   function _transferOwnership(address _newOwner) internal {
269     require(_newOwner != address(0));
270     emit OwnershipTransferred(owner, _newOwner);
271     owner = _newOwner;
272   }
273 }
274 
275 contract Whitelist is Ownable, RBAC {
276   string public constant ROLE_WHITELISTED = "whitelist";
277 
278   /**
279    * @dev Throws if operator is not whitelisted.
280    * @param _operator address
281    */
282   modifier onlyIfWhitelisted(address _operator) {
283     checkRole(_operator, ROLE_WHITELISTED);
284     _;
285   }
286 
287   /**
288    * @dev add an address to the whitelist
289    * @param _operator address
290    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
291    */
292   function addAddressToWhitelist(address _operator)
293     onlyOwner
294     public
295   {
296     addRole(_operator, ROLE_WHITELISTED);
297   }
298 
299   /**
300    * @dev getter to determine if address is in whitelist
301    */
302   function whitelist(address _operator)
303     public
304     view
305     returns (bool)
306   {
307     return hasRole(_operator, ROLE_WHITELISTED);
308   }
309 
310   /**
311    * @dev add addresses to the whitelist
312    * @param _operators addresses
313    * @return true if at least one address was added to the whitelist,
314    * false if all addresses were already in the whitelist
315    */
316   function addAddressesToWhitelist(address[] _operators)
317     onlyOwner
318     public
319   {
320     for (uint256 i = 0; i < _operators.length; i++) {
321       addAddressToWhitelist(_operators[i]);
322     }
323   }
324 
325   /**
326    * @dev remove an address from the whitelist
327    * @param _operator address
328    * @return true if the address was removed from the whitelist,
329    * false if the address wasn't in the whitelist in the first place
330    */
331   function removeAddressFromWhitelist(address _operator)
332     onlyOwner
333     public
334   {
335     removeRole(_operator, ROLE_WHITELISTED);
336   }
337 
338   /**
339    * @dev remove addresses from the whitelist
340    * @param _operators addresses
341    * @return true if at least one address was removed from the whitelist,
342    * false if all addresses weren't in the whitelist in the first place
343    */
344   function removeAddressesFromWhitelist(address[] _operators)
345     onlyOwner
346     public
347   {
348     for (uint256 i = 0; i < _operators.length; i++) {
349       removeAddressFromWhitelist(_operators[i]);
350     }
351   }
352 
353 }
354 
355 contract TokenCollector is Whitelist {
356     using SafeERC20 for ABL;
357     using SafeMath for uint256;
358 
359     ABL token;
360     address receiver;
361 
362     constructor(ABL _token, address _receiver) public {
363         token = _token;
364         receiver = _receiver;
365     }
366 
367     function collect() public onlyIfWhitelisted(msg.sender) {
368         uint256 balance = token.balanceOf(msg.sender);
369         require(
370             token.allowance(msg.sender, address(this)) >= balance,
371             "You should send all of your money."
372         );
373         token.safeTransferFrom(msg.sender, receiver, balance);
374     }
375 
376     function selfDestruct() public onlyOwner {
377         token.safeTransfer(receiver, token.balanceOf(address(this)));
378         token.addOwner(address(this));
379         selfdestruct(msg.sender);
380     }
381 }
382 
383 contract ERC20Basic {
384   function totalSupply() public view returns (uint256);
385   function balanceOf(address _who) public view returns (uint256);
386   function transfer(address _to, uint256 _value) public returns (bool);
387   event Transfer(address indexed from, address indexed to, uint256 value);
388 }
389 
390 contract BasicToken is ERC20Basic {
391   using SafeMath for uint256;
392 
393   mapping(address => uint256) internal balances;
394 
395   uint256 internal totalSupply_;
396 
397   /**
398   * @dev Total number of tokens in existence
399   */
400   function totalSupply() public view returns (uint256) {
401     return totalSupply_;
402   }
403 
404   /**
405   * @dev Transfer token for a specified address
406   * @param _to The address to transfer to.
407   * @param _value The amount to be transferred.
408   */
409   function transfer(address _to, uint256 _value) public returns (bool) {
410     require(_value <= balances[msg.sender]);
411     require(_to != address(0));
412 
413     balances[msg.sender] = balances[msg.sender].sub(_value);
414     balances[_to] = balances[_to].add(_value);
415     emit Transfer(msg.sender, _to, _value);
416     return true;
417   }
418 
419   /**
420   * @dev Gets the balance of the specified address.
421   * @param _owner The address to query the the balance of.
422   * @return An uint256 representing the amount owned by the passed address.
423   */
424   function balanceOf(address _owner) public view returns (uint256) {
425     return balances[_owner];
426   }
427 
428 }
429 
430 contract ERC20 is ERC20Basic {
431   function allowance(address _owner, address _spender)
432     public view returns (uint256);
433 
434   function transferFrom(address _from, address _to, uint256 _value)
435     public returns (bool);
436 
437   function approve(address _spender, uint256 _value) public returns (bool);
438   event Approval(
439     address indexed owner,
440     address indexed spender,
441     uint256 value
442   );
443 }
444 
445 library SafeERC20 {
446   function safeTransfer(ERC20Basic _token, address _to, uint256 _value) internal {
447     require(_token.transfer(_to, _value));
448   }
449 
450   function safeTransferFrom(
451     ERC20 _token,
452     address _from,
453     address _to,
454     uint256 _value
455   )
456     internal
457   {
458     require(_token.transferFrom(_from, _to, _value));
459   }
460 
461   function safeApprove(ERC20 _token, address _spender, uint256 _value) internal {
462     require(_token.approve(_spender, _value));
463   }
464 }
465 
466 contract StandardToken is ERC20, BasicToken {
467 
468   mapping (address => mapping (address => uint256)) internal allowed;
469 
470 
471   /**
472    * @dev Transfer tokens from one address to another
473    * @param _from address The address which you want to send tokens from
474    * @param _to address The address which you want to transfer to
475    * @param _value uint256 the amount of tokens to be transferred
476    */
477   function transferFrom(
478     address _from,
479     address _to,
480     uint256 _value
481   )
482     public
483     returns (bool)
484   {
485     require(_value <= balances[_from]);
486     require(_value <= allowed[_from][msg.sender]);
487     require(_to != address(0));
488 
489     balances[_from] = balances[_from].sub(_value);
490     balances[_to] = balances[_to].add(_value);
491     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
492     emit Transfer(_from, _to, _value);
493     return true;
494   }
495 
496   /**
497    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
498    * Beware that changing an allowance with this method brings the risk that someone may use both the old
499    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
500    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
501    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
502    * @param _spender The address which will spend the funds.
503    * @param _value The amount of tokens to be spent.
504    */
505   function approve(address _spender, uint256 _value) public returns (bool) {
506     allowed[msg.sender][_spender] = _value;
507     emit Approval(msg.sender, _spender, _value);
508     return true;
509   }
510 
511   /**
512    * @dev Function to check the amount of tokens that an owner allowed to a spender.
513    * @param _owner address The address which owns the funds.
514    * @param _spender address The address which will spend the funds.
515    * @return A uint256 specifying the amount of tokens still available for the spender.
516    */
517   function allowance(
518     address _owner,
519     address _spender
520    )
521     public
522     view
523     returns (uint256)
524   {
525     return allowed[_owner][_spender];
526   }
527 
528   /**
529    * @dev Increase the amount of tokens that an owner allowed to a spender.
530    * approve should be called when allowed[_spender] == 0. To increment
531    * allowed value is better to use this function to avoid 2 calls (and wait until
532    * the first transaction is mined)
533    * From MonolithDAO Token.sol
534    * @param _spender The address which will spend the funds.
535    * @param _addedValue The amount of tokens to increase the allowance by.
536    */
537   function increaseApproval(
538     address _spender,
539     uint256 _addedValue
540   )
541     public
542     returns (bool)
543   {
544     allowed[msg.sender][_spender] = (
545       allowed[msg.sender][_spender].add(_addedValue));
546     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
547     return true;
548   }
549 
550   /**
551    * @dev Decrease the amount of tokens that an owner allowed to a spender.
552    * approve should be called when allowed[_spender] == 0. To decrement
553    * allowed value is better to use this function to avoid 2 calls (and wait until
554    * the first transaction is mined)
555    * From MonolithDAO Token.sol
556    * @param _spender The address which will spend the funds.
557    * @param _subtractedValue The amount of tokens to decrease the allowance by.
558    */
559   function decreaseApproval(
560     address _spender,
561     uint256 _subtractedValue
562   )
563     public
564     returns (bool)
565   {
566     uint256 oldValue = allowed[msg.sender][_spender];
567     if (_subtractedValue >= oldValue) {
568       allowed[msg.sender][_spender] = 0;
569     } else {
570       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
571     }
572     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
573     return true;
574   }
575 
576 }
577 
578 contract ABL is StandardToken, OwnableToken {
579     using SafeMath for uint256;
580 
581     // Token Distribution Rate
582     uint256 public constant SUM = 400000000;   // totalSupply
583     uint256 public constant DISTRIBUTION = 221450000; // distribution
584     uint256 public constant DEVELOPERS = 178550000;   // developer
585 
586     // Token Information
587     string public constant name = "Airbloc";
588     string public constant symbol = "ABL";
589     uint256 public constant decimals = 18;
590     uint256 public totalSupply = SUM.mul(10 ** uint256(decimals));
591 
592     // token is non-transferable until owner calls unlock()
593     // (to prevent OTC before the token to be listed on exchanges)
594     bool isTransferable = false;
595 
596     function ABL(
597         address _dtb,
598         address _dev
599     ) public {
600         require(_dtb != address(0));
601         require(_dev != address(0));
602         require(DISTRIBUTION + DEVELOPERS == SUM);
603 
604         balances[_dtb] = DISTRIBUTION.mul(10 ** uint256(decimals));
605         emit Transfer(address(0), _dtb, balances[_dtb]);
606 
607         balances[_dev] = DEVELOPERS.mul(10 ** uint256(decimals));
608         emit Transfer(address(0), _dev, balances[_dev]);
609     }
610 
611     function unlock() external onlyOwner {
612         isTransferable = true;
613     }
614 
615     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
616         require(isTransferable || owners[msg.sender]);
617         return super.transferFrom(_from, _to, _value);
618     }
619 
620     function transfer(address _to, uint256 _value) public returns (bool) {
621         require(isTransferable || owners[msg.sender]);
622         return super.transfer(_to, _value);
623     }
624 
625     //////////////////////
626     //  mint and burn   //
627     //////////////////////
628     function mint(
629         address _to,
630         uint256 _amount
631     ) onlyOwner public returns (bool) {
632         require(_to != address(0));
633         require(_amount >= 0);
634 
635         uint256 amount = _amount.mul(10 ** uint256(decimals));
636 
637         totalSupply = totalSupply.add(amount);
638         balances[_to] = balances[_to].add(amount);
639 
640         emit Mint(_to, amount);
641         emit Transfer(address(0), _to, amount);
642 
643         return true;
644     }
645 
646     function burn(
647         uint256 _amount
648     ) onlyOwner public {
649         require(_amount >= 0);
650         require(_amount <= balances[msg.sender]);
651 
652         totalSupply = totalSupply.sub(_amount.mul(10 ** uint256(decimals)));
653         balances[msg.sender] = balances[msg.sender].sub(_amount.mul(10 ** uint256(decimals)));
654 
655         emit Burn(msg.sender, _amount.mul(10 ** uint256(decimals)));
656         emit Transfer(msg.sender, address(0), _amount.mul(10 ** uint256(decimals)));
657     }
658 
659     event Mint(address indexed _to, uint256 _amount);
660     event Burn(address indexed _from, uint256 _amount);
661 }