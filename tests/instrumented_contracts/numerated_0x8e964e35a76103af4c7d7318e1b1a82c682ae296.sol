1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11   function totalSupply() external view returns (uint256);
12 
13   function balanceOf(address who) external view returns (uint256);
14 
15   function allowance(address owner, address spender)
16     external view returns (uint256);
17 
18   function transfer(address to, uint256 value) external returns (bool);
19 
20   function approve(address spender, uint256 value)
21     external returns (bool);
22 
23   function transferFrom(address from, address to, uint256 value)
24     external returns (bool);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
40 
41 pragma solidity ^0.4.24;
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that revert on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, reverts on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55     // benefit is lost if 'b' is also tested.
56     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57     if (a == 0) {
58       return 0;
59     }
60 
61     uint256 c = a * b;
62     require(c / a == b);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b > 0); // Solidity only automatically asserts when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75     return c;
76   }
77 
78   /**
79   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b <= a);
83     uint256 c = a - b;
84 
85     return c;
86   }
87 
88   /**
89   * @dev Adds two numbers, reverts on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     require(c >= a);
94 
95     return c;
96   }
97 
98   /**
99   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
100   * reverts when dividing by zero.
101   */
102   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b != 0);
104     return a % b;
105   }
106 }
107 
108 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
109 
110 pragma solidity ^0.4.24;
111 
112 
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
120  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract ERC20 is IERC20 {
123   using SafeMath for uint256;
124 
125   mapping (address => uint256) private _balances;
126 
127   mapping (address => mapping (address => uint256)) private _allowed;
128 
129   uint256 private _totalSupply;
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return _totalSupply;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address owner) public view returns (uint256) {
144     return _balances[owner];
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param owner address The address which owns the funds.
150    * @param spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(
154     address owner,
155     address spender
156    )
157     public
158     view
159     returns (uint256)
160   {
161     return _allowed[owner][spender];
162   }
163 
164   /**
165   * @dev Transfer token for a specified address
166   * @param to The address to transfer to.
167   * @param value The amount to be transferred.
168   */
169   function transfer(address to, uint256 value) public returns (bool) {
170     require(value <= _balances[msg.sender]);
171     require(to != address(0));
172 
173     _balances[msg.sender] = _balances[msg.sender].sub(value);
174     _balances[to] = _balances[to].add(value);
175     emit Transfer(msg.sender, to, value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param spender The address which will spend the funds.
186    * @param value The amount of tokens to be spent.
187    */
188   function approve(address spender, uint256 value) public returns (bool) {
189     require(spender != address(0));
190 
191     _allowed[msg.sender][spender] = value;
192     emit Approval(msg.sender, spender, value);
193     return true;
194   }
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param from address The address which you want to send tokens from
199    * @param to address The address which you want to transfer to
200    * @param value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(
203     address from,
204     address to,
205     uint256 value
206   )
207     public
208     returns (bool)
209   {
210     require(value <= _balances[from]);
211     require(value <= _allowed[from][msg.sender]);
212     require(to != address(0));
213 
214     _balances[from] = _balances[from].sub(value);
215     _balances[to] = _balances[to].add(value);
216     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
217     emit Transfer(from, to, value);
218     return true;
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseAllowance(
231     address spender,
232     uint256 addedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].add(addedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    * approve should be called when allowed_[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param spender The address which will spend the funds.
252    * @param subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseAllowance(
255     address spender,
256     uint256 subtractedValue
257   )
258     public
259     returns (bool)
260   {
261     require(spender != address(0));
262 
263     _allowed[msg.sender][spender] = (
264       _allowed[msg.sender][spender].sub(subtractedValue));
265     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Internal function that mints an amount of the token and assigns it to
271    * an account. This encapsulates the modification of balances such that the
272    * proper events are emitted.
273    * @param account The account that will receive the created tokens.
274    * @param amount The amount that will be created.
275    */
276   function _mint(address account, uint256 amount) internal {
277     require(account != 0);
278     _totalSupply = _totalSupply.add(amount);
279     _balances[account] = _balances[account].add(amount);
280     emit Transfer(address(0), account, amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account.
286    * @param account The account whose tokens will be burnt.
287    * @param amount The amount that will be burnt.
288    */
289   function _burn(address account, uint256 amount) internal {
290     require(account != 0);
291     require(amount <= _balances[account]);
292 
293     _totalSupply = _totalSupply.sub(amount);
294     _balances[account] = _balances[account].sub(amount);
295     emit Transfer(account, address(0), amount);
296   }
297 
298   /**
299    * @dev Internal function that burns an amount of the token of a given
300    * account, deducting from the sender's allowance for said account. Uses the
301    * internal burn function.
302    * @param account The account whose tokens will be burnt.
303    * @param amount The amount that will be burnt.
304    */
305   function _burnFrom(address account, uint256 amount) internal {
306     require(amount <= _allowed[account][msg.sender]);
307 
308     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
309     // this function needs to emit an event with the updated approval.
310     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
311       amount);
312     _burn(account, amount);
313   }
314 }
315 
316 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
317 
318 pragma solidity ^0.4.24;
319 
320 
321 
322 /**
323  * @title Burnable Token
324  * @dev Token that can be irreversibly burned (destroyed).
325  */
326 contract ERC20Burnable is ERC20 {
327 
328   /**
329    * @dev Burns a specific amount of tokens.
330    * @param value The amount of token to be burned.
331    */
332   function burn(uint256 value) public {
333     _burn(msg.sender, value);
334   }
335 
336   /**
337    * @dev Burns a specific amount of tokens from the target address and decrements allowance
338    * @param from address The address which you want to send tokens from
339    * @param value uint256 The amount of token to be burned
340    */
341   function burnFrom(address from, uint256 value) public {
342     _burnFrom(from, value);
343   }
344 
345   /**
346    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
347    * an additional Burn event.
348    */
349   function _burn(address who, uint256 value) internal {
350     super._burn(who, value);
351   }
352 }
353 
354 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
355 
356 pragma solidity ^0.4.24;
357 
358 
359 /**
360  * @title Ownable
361  * @dev The Ownable contract has an owner address, and provides basic authorization control
362  * functions, this simplifies the implementation of "user permissions".
363  */
364 contract Ownable {
365   address private _owner;
366 
367 
368   event OwnershipRenounced(address indexed previousOwner);
369   event OwnershipTransferred(
370     address indexed previousOwner,
371     address indexed newOwner
372   );
373 
374 
375   /**
376    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
377    * account.
378    */
379   constructor() public {
380     _owner = msg.sender;
381   }
382 
383   /**
384    * @return the address of the owner.
385    */
386   function owner() public view returns(address) {
387     return _owner;
388   }
389 
390   /**
391    * @dev Throws if called by any account other than the owner.
392    */
393   modifier onlyOwner() {
394     require(isOwner());
395     _;
396   }
397 
398   /**
399    * @return true if `msg.sender` is the owner of the contract.
400    */
401   function isOwner() public view returns(bool) {
402     return msg.sender == _owner;
403   }
404 
405   /**
406    * @dev Allows the current owner to relinquish control of the contract.
407    * @notice Renouncing to ownership will leave the contract without an owner.
408    * It will not be possible to call the functions with the `onlyOwner`
409    * modifier anymore.
410    */
411   function renounceOwnership() public onlyOwner {
412     emit OwnershipRenounced(_owner);
413     _owner = address(0);
414   }
415 
416   /**
417    * @dev Allows the current owner to transfer control of the contract to a newOwner.
418    * @param newOwner The address to transfer ownership to.
419    */
420   function transferOwnership(address newOwner) public onlyOwner {
421     _transferOwnership(newOwner);
422   }
423 
424   /**
425    * @dev Transfers control of the contract to a newOwner.
426    * @param newOwner The address to transfer ownership to.
427    */
428   function _transferOwnership(address newOwner) internal {
429     require(newOwner != address(0));
430     emit OwnershipTransferred(_owner, newOwner);
431     _owner = newOwner;
432   }
433 }
434 
435 // File: contracts/Administratable.sol
436 
437 // Lee, July 29, 2018
438 pragma solidity 0.4.24;
439 
440 
441 contract Administratable is Ownable {
442 	mapping (address => bool) public superAdmins;
443 
444 	event AddSuperAdmin(address indexed admin);
445 	event RemoveSuperAdmin(address indexed admin);
446 
447     modifier validateAddress( address _addr )
448     {
449         require(_addr != address(0x0));
450         require(_addr != address(this));
451         _;
452     }
453 
454 	modifier onlySuperAdmins {
455 		require(msg.sender == owner() || superAdmins[msg.sender]);
456 		_;
457 	}
458 
459 	function addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
460 		require(!superAdmins[_admin]);
461 		superAdmins[_admin] = true;
462 		emit AddSuperAdmin(_admin);
463 	}
464 
465 	function removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){
466 		require(superAdmins[_admin]);
467 		superAdmins[_admin] = false;
468 		emit RemoveSuperAdmin(_admin);
469 	}
470 }
471 
472 // File: contracts/Freezable.sol
473 
474 // Lee, July 29, 2018
475 pragma solidity 0.4.24;
476 
477 
478 contract Freezable is Administratable {
479 
480     bool public frozenToken;
481     mapping (address => bool) public frozenAccounts;
482 
483     event FrozenFunds(address indexed _target, bool _frozen);
484     event FrozenToken(bool _frozen);
485 
486     modifier isNotTokenFrozen() {
487         require(!frozenToken);
488         _;
489     }
490 
491     modifier isNotFrozen( address _to ) {
492         require(!frozenToken);
493         require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);
494         _;
495     }
496 
497     modifier isNotFrozenFrom( address _from, address _to ) {
498         require(!frozenToken);
499         require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);
500         _;
501     }
502 
503     function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {
504         require(frozenAccounts[_target] != _freeze);
505         frozenAccounts[_target] = _freeze;
506         emit FrozenFunds(_target, _freeze);
507     }
508 
509     function freezeToken(bool _freeze) public onlySuperAdmins {
510         require(frozenToken != _freeze);
511         frozenToken = _freeze;
512         emit FrozenToken(frozenToken);
513     }
514 }
515 
516 // File: contracts/Fellaz.sol
517 
518 // Lee, July 29, 2018
519 pragma solidity 0.4.24;
520 
521 
522 
523 contract Fellaz is ERC20Burnable, Freezable
524 {
525     string  public  constant name       = "Fellaz Token";
526     string  public  constant symbol     = "FLZ";
527     uint8   public  constant decimals   = 18;
528     uint256 private constant _totalAmount = 2000000000e18;
529     
530     event Burn(address indexed _burner, uint _value);
531 
532     constructor( address _registry ) public
533     {
534         _mint(_registry, _totalAmount);
535         addSuperAdmin(_registry);
536     }
537 
538 
539     /**
540     * @dev Transfer token for a specified address
541     * @param _to The address to transfer to.
542     * @param _value The amount to be transferred.
543     */    
544     function transfer(address _to, uint _value) public validateAddress(_to) isNotFrozen(_to) returns (bool) 
545     {
546         return super.transfer(_to, _value);
547     }
548 
549     /**
550     * @dev Transfer tokens from one address to another
551     * @param _from address The address which you want to send tokens from
552     * @param _to address The address which you want to transfer to
553     * @param _value uint256 the amount of tokens to be transferred
554     */
555     function transferFrom(address _from, address _to, uint _value) public validateAddress(_to)  isNotFrozenFrom(_from, _to) returns (bool) 
556     {
557         return super.transferFrom(_from, _to, _value);
558     }
559 
560     function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool) 
561     {
562         return super.approve(_spender, _value);
563     }
564 
565     function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
566     {
567         return super.increaseAllowance(_spender, _addedValue);
568     }
569 
570     function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)
571     {
572         return super.decreaseAllowance(_spender, _subtractedValue);
573     }
574 
575     // function batchTransfer(address[] recipients, uint256[] values) public isNotTokenFrozen() returns (bool) {
576     //     uint256 length = recipients.length;
577     //     require(length == values.length, "ERC20: inconsistent arrays");
578     //     address sender = msg.sender;
579     //     uint256 totalValue;
580         
581     //     for (uint256 i; i != length; ++i) {
582     //         address to = recipients[i];
583     //         require(to != address(0), "ERC20: to zero address");
584 
585     //         uint256 value = values[i];
586     //         if (value != 0) {
587     //             uint256 newTotalValue = totalValue + value;
588     //             require(newTotalValue > totalValue, "ERC20: values overflow");
589     //             totalValue = newTotalValue;
590     //             if (sender != to) {
591     //                 transfer(to, value);
592     //             } 
593     //         }
594     //     }
595     //     return true;
596     // }    
597 
598     // function batchTransferFrom( address from, address[]  recipients, uint256[]  values ) public  isNotTokenFrozen() returns (bool) {
599     //     uint256 length = recipients.length;
600     //     require(length == values.length, "ERC20: inconsistent arrays");
601 
602     //     uint256 totalValue;
603     //     for (uint256 i; i != length; ++i) {
604     //         address to = recipients[i];
605     //         require(to != address(0), "ERC20: to zero address");
606 
607     //         uint256 value = values[i];
608     //         if (value != 0) {
609     //             uint256 newTotalValue = totalValue + value;
610     //             require(newTotalValue > totalValue, "ERC20: values overflow");
611     //             totalValue = newTotalValue;
612     //             if (from != to) {
613     //                 transferFrom(from, to, value);
614     //             }
615     //         }
616     //     }
617     //     return true;
618     // }
619 
620 }