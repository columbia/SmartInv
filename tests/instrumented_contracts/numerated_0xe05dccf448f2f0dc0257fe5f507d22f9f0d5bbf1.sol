1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74   function totalSupply() public view returns (uint256);
75   function balanceOf(address who) public view returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     emit Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = (
205       allowed[msg.sender][_spender].add(_addedValue));
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222 
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228 
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 contract Role is StandardToken {
236     using SafeMath for uint256;
237 
238     address public owner;
239     address public admin;
240 
241     uint256 public contractDeployed = now;
242 
243     event OwnershipTransferred(
244         address indexed previousOwner,
245         address indexed newOwner
246     );
247 
248     event AdminshipTransferred(
249         address indexed previousAdmin,
250         address indexed newAdmin
251     );
252 
253 	  /**
254     * @dev Throws if called by any account other than the owner.
255     */
256     modifier onlyOwner() {
257         require(msg.sender == owner);
258         _;
259     }   
260 
261     /**
262     * @dev Throws if called by any account other than the admin.
263     */
264     modifier onlyAdmin() {
265         require(msg.sender == admin);
266         _;
267     }
268 
269     /**
270     * @dev Allows the current owner to transfer control of the contract to a newOwner.
271     * @param _newOwner The address to transfer ownership to.
272     */
273     function transferOwnership(address _newOwner) external  onlyOwner {
274         _transferOwnership(_newOwner);
275     }
276 
277     /**
278     * @dev Allows the current admin to transfer control of the contract to a newAdmin.
279     * @param _newAdmin The address to transfer adminship to.
280     */
281     function transferAdminship(address _newAdmin) external onlyAdmin {
282         _transferAdminship(_newAdmin);
283     }
284 
285     /**
286     * @dev Transfers control of the contract to a newOwner.
287     * @param _newOwner The address to transfer ownership to.
288     */
289     function _transferOwnership(address _newOwner) internal {
290         require(_newOwner != address(0));
291         balances[owner] = balances[owner].sub(balances[owner]);
292         balances[_newOwner] = balances[_newOwner].add(balances[owner]);
293         owner = _newOwner;
294         emit OwnershipTransferred(owner, _newOwner);
295     }
296 
297     /**
298     * @dev Transfers control of the contract to a newAdmin.
299     * @param _newAdmin The address to transfer adminship to.
300     */
301     function _transferAdminship(address _newAdmin) internal {
302         require(_newAdmin != address(0));
303         emit AdminshipTransferred(admin, _newAdmin);
304         admin = _newAdmin;
305     }
306 }
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Role {
313   event Pause();
314   event Unpause();
315   event NotPausable();
316 
317   bool public paused = false;
318   bool public canPause = true;
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused || msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337      * @dev called by the owner to pause, triggers stopped state
338      **/
339     function pause() onlyOwner whenNotPaused public {
340         require(canPause == true);
341         paused = true;
342         emit Pause();
343     }
344 
345   /**
346   * @dev called by the owner to unpause, returns to normal state
347   */
348   function unpause() onlyOwner whenPaused public {
349     require(paused == true);
350     paused = false;
351     emit Unpause();
352   }
353   
354   /**
355     * @dev Prevent the token from ever being paused again
356   **/
357     function notPausable() onlyOwner public{
358         paused = false;
359         canPause = false;
360         emit NotPausable();
361     }
362 }
363 
364 contract SamToken is Pausable {
365   using SafeMath for uint;
366 
367     uint256 _lockedTokens;
368     uint256 _bountyLockedTokens;
369     uint256 _teamLockedTokens;
370 
371     bool ownerRelease;
372     bool releasedForOwner ;
373 
374     // Team release
375     bool team_1_release;
376     bool teamRelease;
377 
378     // bounty release
379     bool bounty_1_release;
380     bool bountyrelase;
381     
382     uint256 public ownerSupply;   
383     uint256 public adminSupply ;
384     uint256 public teamSupply ;
385     uint256 public bountySupply ;
386    
387     //The name of the  token
388     string public constant name = "SAM Token";
389     //The token symbol
390     string public constant symbol = "SAM";
391     //The precision used in the balance calculations in contract
392     uint public constant decimals = 0;
393 
394   event Burn(address indexed burner, uint256 value);
395   event CompanyTokenReleased( address indexed _company, uint256 indexed _tokens );
396   event TransferTokenToTeam(
397         address indexed _beneficiary,
398         uint256 indexed tokens
399     );
400 
401    event TransferTokenToBounty(
402         address indexed bounty,
403         uint256 indexed tokens
404     );
405 
406   constructor(
407         address _owner,
408         address _admin,
409         uint256 _totalsupply,
410         address _development,
411         address _bounty
412         ) public {
413     owner = _owner;
414     admin = _admin;
415 
416     _totalsupply = _totalsupply;
417     totalSupply_ = totalSupply_.add(_totalsupply);
418 
419     adminSupply = 450000000;
420     teamSupply = 200000000;    
421     ownerSupply = 100000000;
422     bountySupply = 50000000;
423 
424     _lockedTokens = _lockedTokens.add(ownerSupply);
425     _bountyLockedTokens = _bountyLockedTokens.add(bountySupply);
426     _teamLockedTokens = _teamLockedTokens.add(teamSupply);
427 
428     balances[admin] = balances[admin].add(adminSupply);    
429     balances[_development] = balances[_development].add(150000000);
430     balances[_bounty] = balances[_bounty].add(50000000);
431     
432     emit Transfer(address(0), admin, adminSupply);
433   }
434 
435   modifier onlyPayloadSize(uint numWords) {
436     assert(msg.data.length >= numWords * 32 + 4);
437     _;
438   }
439 
440  /**
441   * @dev Locked number of tokens in existence
442   */
443     function lockedTokens() public view returns (uint256) {
444       return _lockedTokens;
445     }
446 
447   /**
448   * @dev Locked number of tokens for bounty in existence
449   */
450     function lockedBountyTokens() public view returns (uint256) {
451       return _bountyLockedTokens;
452     }
453 
454   /**
455   * @dev Locked number of tokens for team in existence
456   */
457     function lockedTeamTokens() public view returns (uint256) {
458       return _teamLockedTokens;
459     }
460 
461   /**
462   * @dev function to check whether passed address is a contract address
463   */
464     function isContract(address _address) private view returns (bool is_contract) {
465       uint256 length;
466       assembly {
467       //retrieve the size of the code on target address, this needs assembly
468         length := extcodesize(_address)
469       }
470       return (length > 0);
471     }
472 
473   /**
474   * @dev Gets the balance of the specified address.
475   * @param tokenOwner The address to query the the balance of.
476   * @return An uint representing the amount owned by the passed address.
477   */
478 
479   function balanceOf(address tokenOwner) public view returns (uint balance) {
480     return balances[tokenOwner];
481   }
482 
483   /**
484    * @dev Function to check the amount of tokens that an owner allowed to a spender.
485    * @param tokenOwner address The address which owns the funds.
486    * @param spender address The address which will spend the funds.
487    * @return A uint specifying the amount of tokens still available for the spender.
488   */
489   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
490     return allowed[tokenOwner][spender];
491   }
492 
493   /**
494   * @dev Transfer token for a specified address
495   * @param to The address to transfer to.
496   * @param tokens The amount to be transferred.
497   */
498   function transfer(address to, uint tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
499     require(to != address(0));
500     require(tokens > 0);
501     require(tokens <= balances[msg.sender]);
502 
503     balances[msg.sender] = balances[msg.sender].sub(tokens);
504     balances[to] = balances[to].add(tokens);
505     emit Transfer(msg.sender, to, tokens);
506     return true;
507   }
508 
509   /**
510    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
511    * Beware that changing an allowance with this method brings the risk that someone may use both the old
512    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
513    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
514    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
515    * @param spender The address which will spend the funds.
516    * @param tokens The amount of tokens to be spent.
517    */
518    
519   function approve(address spender, uint tokens) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
520     require(spender != address(0));
521     allowed[msg.sender][spender] = tokens;
522     emit Approval(msg.sender, spender, tokens);
523     return true;
524   }
525 
526 /**
527 * @dev Transfer tokens from one address to another
528 * @param from address The address which you want to send tokens from
529 * @param to address The address which you want to transfer to
530 * @param tokens uint256 the amount of tokens to be transferred
531 */
532 
533 
534 function transferFrom(address from, address to, uint tokens) public whenNotPaused onlyPayloadSize(3) returns (bool success) {
535     require(tokens > 0);
536     require(from != address(0));
537     require(to != address(0));
538     require(allowed[from][msg.sender] > 0);
539     require(balances[from]>0);
540 
541     balances[from] = balances[from].sub(tokens);
542     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
543     balances[to] = balances[to].add(tokens);
544     emit Transfer(from, to, tokens);
545     return true;
546 }
547 
548 /**
549 * @dev Burns a specific amount of tokens.
550 * @param _value The amount of token to be burned.
551 */
552 function burn(uint _value) public returns (bool success) {
553     require(balances[msg.sender] >= _value);
554     balances[msg.sender] = balances[msg.sender].sub(_value);
555     totalSupply_ = totalSupply_.sub(_value);
556     emit Burn(msg.sender, _value);
557     return true;
558 }
559 
560 /**
561 * @dev Burns a specific amount of tokens from the target address and decrements allowance
562 * @param from address The address which you want to send tokens from
563 * @param _value uint256 The amount of token to be burned
564 */
565 function burnFrom(address from, uint _value) public returns (bool success) {
566     require(balances[from] >= _value);
567     require(_value <= allowed[from][msg.sender]);
568     balances[from] = balances[from].sub(_value);
569     allowed[from][msg.sender] = allowed[from][msg.sender].sub(_value);
570     totalSupply_ = totalSupply_.sub(_value);
571     emit Burn(from, _value);
572     return true;
573 }
574 
575 function () public payable {
576     revert();
577 }
578 
579 /**
580 * @dev Function to transfer any ERC20 token  to owner address which gets accidentally transferred to this contract
581 * @param tokenAddress The address of the ERC20 contract
582 * @param tokens The amount of tokens to transfer.
583 * @return A boolean that indicates if the operation was successful.
584 */
585 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
586     require(tokenAddress != address(0));
587     require(isContract(tokenAddress));
588     return ERC20(tokenAddress).transfer(owner, tokens);
589 }
590 
591 /**
592 * @dev Function to Release Company token to owner address after Locking period is over
593 * @param _company The address of the owner
594 * @return A boolean that indicates if the operation was successful.
595 */
596 // Transfer token to compnay 
597 function companyTokensRelease(address _company) external onlyOwner returns(bool) {
598    require(_company != address(0), "Address is not valid");
599    require(!ownerRelease, "owner release has already done");
600     if (now > contractDeployed.add(365 days) && releasedForOwner == false ) {          
601           balances[_company] = balances[_company].add(_lockedTokens);
602           
603           releasedForOwner = true;
604           ownerRelease = true;
605           emit CompanyTokenReleased(_company, _lockedTokens);
606           _lockedTokens = 0;
607           return true;
608         }
609     }
610 
611 /**
612 * @dev Function to Release Team token to team address after Locking period is over
613 * @param _team The address of the team
614 * @return A boolean that indicates if the operation was successful.
615 */
616 // Transfer token to team 
617 function transferToTeam(address _team) external onlyOwner returns(bool) {
618         require(_team != address(0), "Address is not valid");
619         require(!teamRelease, "Team release has already done");
620         if (now > contractDeployed.add(365 days) && team_1_release == false) {
621             balances[_team] = balances[_team].add(_teamLockedTokens);
622             
623             team_1_release = true;
624             teamRelease = true;
625             emit TransferTokenToTeam(_team, _teamLockedTokens);
626             _teamLockedTokens = 0;
627             return true;
628         }
629     }
630 
631   /**
632 * @dev Function to Release Bounty and Bonus token to Bounty address after Locking period is over
633 * @param _bounty The address of the Bounty
634 * @return A boolean that indicates if the operation was successful.
635 */
636   function transferToBounty(address _bounty) external onlyOwner returns(bool) {
637         require(_bounty != address(0), "Address is not valid");
638         require(!bountyrelase, "Bounty release already done");
639         if (now > contractDeployed.add(180 days) && bounty_1_release == false) {
640             balances[_bounty] = balances[_bounty].add(_bountyLockedTokens);
641             bounty_1_release = true;
642             bountyrelase = true;
643             emit TransferTokenToBounty(_bounty, _bountyLockedTokens);
644             _bountyLockedTokens = 0;
645             return true;
646         }
647   }
648 
649 }