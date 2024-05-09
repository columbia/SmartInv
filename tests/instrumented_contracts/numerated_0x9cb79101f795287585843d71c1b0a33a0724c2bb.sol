1 /**
2 Copyright (c) 2019 - 2552 VoiEdge Inc
3 
4 Licensed under the Apache License, Version 2.0 (the "License");
5 you may not use this file except in compliance with the License.
6 You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10 Unless required by applicable law or agreed to in writing, software
11 distributed under the License is distributed on an "AS IS" BASIS,
12 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13 See the License for the specific language governing permissions and
14 limitations under the License.
15 */
16 
17 pragma solidity ^0.5.0;
18 
19 /**
20  * @title HERC20+ interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 interface HERC20 {
24   function totalSupply() external view returns (uint256);
25 
26   function balanceOf(address who) external view returns (uint256);
27 
28   function allowance(address owner, address spender)
29     external view returns (uint256);
30 
31   function transfer(address to, uint256 value) external returns (bool);
32 
33   function approve(address spender, uint256 value)
34     external returns (bool);
35 
36   function transferFrom(address from, address to, uint256 value)
37     external returns (bool);
38 
39   event Transfer(
40     address indexed from,
41     address indexed to,
42     uint256 value
43   );
44 
45   event Approval(
46     address indexed owner,
47     address indexed spender,
48     uint256 value
49   );
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that revert on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, reverts on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (a == 0) {
66       return 0;
67     }
68 
69     uint256 c = a * b;
70     require(c / a == b);
71 
72     return c;
73   }
74 
75   /**
76   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
77   */
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b > 0); // Solidity only automatically asserts when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82 
83     return c;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     require(b <= a);
91     uint256 c = a - b;
92 
93     return c;
94   }
95 
96   /**
97   * @dev Adds two numbers, reverts on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     require(c >= a);
102 
103     return c;
104   }
105 
106   /**
107   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
108   * reverts when dividing by zero.
109   */
110   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111     require(b != 0);
112     return a % b;
113   }
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
121  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract ERC20 is HERC20 {
124   using SafeMath for uint256;
125 
126   mapping (address => uint256) private _balances;
127 
128   mapping (address => mapping (address => uint256)) private _allowed;
129 
130   uint256 private _totalSupply;
131 
132   /**
133   * @dev Total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return _totalSupply;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param owner The address to query the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address owner) public view returns (uint256) {
145     return _balances[owner];
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param owner address The address which owns the funds.
151    * @param spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(
155     address owner,
156     address spender
157    )
158     public
159     view
160     returns (uint256)
161   {
162     return _allowed[owner][spender];
163   }
164 
165   /**
166   * @dev Transfer token for a specified address
167   * @param to The address to transfer to.
168   * @param value The amount to be transferred.
169   */
170   function transfer(address to, uint256 value) public returns (bool) {
171     _transfer(msg.sender, to, value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param spender The address which will spend the funds.
182    * @param value The amount of tokens to be spent.
183    */
184   function approve(address spender, uint256 value) public returns (bool) {
185     require(spender != address(0));
186 
187     _allowed[msg.sender][spender] = value;
188     emit Approval(msg.sender, spender, value);
189     return true;
190   }
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param from address The address which you want to send tokens from
195    * @param to address The address which you want to transfer to
196    * @param value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address from,
200     address to,
201     uint256 value
202   )
203     public
204     returns (bool)
205   {
206     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
207     _transfer(from, to, value);
208     return true;
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed_[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param spender The address which will spend the funds.
218    * @param addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseAllowance(
221     address spender,
222     uint256 addedValue
223   )
224     public
225     returns (bool)
226   {
227     require(spender != address(0));
228 
229     _allowed[msg.sender][spender] = (
230       _allowed[msg.sender][spender].add(addedValue));
231     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed_[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param spender The address which will spend the funds.
242    * @param subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseAllowance(
245     address spender,
246     uint256 subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = (
254       _allowed[msg.sender][spender].sub(subtractedValue));
255     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
256     return true;
257   }
258 
259   /**
260   * @dev Transfer token for a specified addresses
261   * @param from The address to transfer from.
262   * @param to The address to transfer to.
263   * @param value The amount to be transferred.
264   */
265   function _transfer(address from, address to, uint256 value) internal {
266     require(to != address(0));
267 
268     _balances[from] = _balances[from].sub(value);
269     _balances[to] = _balances[to].add(value);
270     emit Transfer(from, to, value);
271   }
272 
273   /**
274    * @dev Internal function that mints an amount of the token and assigns it to
275    * an account. This encapsulates the modification of balances such that the
276    * proper events are emitted.
277    * @param account The account that will receive the created tokens.
278    * @param value The amount that will be created.
279    */
280   function _mint(address account, uint256 value) internal {
281     require(account != address(0));
282 
283     _totalSupply = _totalSupply.add(value);
284     _balances[account] = _balances[account].add(value);
285     emit Transfer(address(0), account, value);
286   }
287 
288   /**
289    * @dev Internal function that burns an amount of the token of a given
290    * account.
291    * @param account The account whose tokens will be burnt.
292    * @param value The amount that will be burnt.
293    */
294   function _burn(address account, uint256 value) internal {
295     require(account != address(0));
296 
297     _totalSupply = _totalSupply.sub(value);
298     _balances[account] = _balances[account].sub(value);
299     emit Transfer(account, address(0), value);
300   }
301 
302   /**
303    * @dev Internal function that burns an amount of the token of a given
304    * account, deducting from the sender's allowance for said account. Uses the
305    * internal burn function.
306    * @param account The account whose tokens will be burnt.
307    * @param value The amount that will be burnt.
308    */
309   function _burnFrom(address account, uint256 value) internal {
310     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
311     // this function needs to emit an event with the updated approval.
312     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
313       value);
314     _burn(account, value);
315   }
316 }
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323 contract Ownable {
324     address private _owner;
325 
326     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
327 
328     /**
329      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330      * account.
331      */
332     constructor () internal {
333         _owner = msg.sender;
334         emit OwnershipTransferred(address(0), _owner);
335     }
336 
337     /**
338      * @return the address of the owner.
339      */
340     function owner() public view returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(isOwner());
349         _;
350     }
351 
352     /**
353      * @return true if `msg.sender` is the owner of the contract.
354      */
355     function isOwner() public view returns (bool) {
356         return msg.sender == _owner;
357     }
358 
359     /**
360      * @dev Allows the current owner to relinquish control of the contract.
361      * @notice Renouncing to ownership will leave the contract without an owner.
362      * It will not be possible to call the functions with the `onlyOwner`
363      * modifier anymore.
364      */
365     function renounceOwnership() public onlyOwner {
366         emit OwnershipTransferred(_owner, address(0));
367         _owner = address(0);
368     }
369 
370     /**
371      * @dev Allows the current owner to transfer control of the contract to a newOwner.
372      * @param newOwner The address to transfer ownership to.
373      */
374     function transferOwnership(address newOwner) public onlyOwner {
375         _transferOwnership(newOwner);
376     }
377 
378     /**
379      * @dev Transfers control of the contract to a newOwner.
380      * @param newOwner The address to transfer ownership to.
381      */
382     function _transferOwnership(address newOwner) internal {
383         require(newOwner != address(0));
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 /**
389  * @title AnthemGold
390  * @dev ERC20 Token backed by Gold Bullion reserves
391  */
392 
393 /**
394  * @title Pausable
395  * @dev Base contract which allows children to implement an emergency stop mechanism.
396  * Based on openzeppelin tag v1.10.0 commit: feb665136c0dae9912e08397c1a21c4af3651ef3
397  * Modifications:
398  * 1) Added pauser role, switched pause/unpause to be onlyPauser (6/14/2018)
399  * 2) Removed whenNotPause/whenPaused from pause/unpause (6/14/2018)
400  * 3) Removed whenPaused (6/14/2018)
401  * 4) Switches ownable library to use zeppelinos (7/12/18)
402  * 5) Remove constructor (7/13/18)
403  */
404 contract Pausable is Ownable {
405   event Pause();
406   event Unpause();
407   event PauserChanged(address indexed newAddress);
408 
409 
410   address public pauser;
411   bool public paused = false;
412 
413   /**
414    * @dev Modifier to make a function callable only when the contract is not paused.
415    */
416   modifier whenNotPaused() {
417     require(!paused);
418     _;
419   }
420 
421   /**
422    * @dev throws if called by any account other than the pauser
423    */
424   modifier onlyPauser() {
425     require(msg.sender == pauser);
426     _;
427   }
428 
429   /**
430    * @dev called by the owner to pause, triggers stopped state
431    */
432   function pause() onlyPauser public {
433     paused = true;
434     emit Pause();
435   }
436 
437   /**
438    * @dev called by the owner to unpause, returns to normal state
439    */
440   function unpause() onlyPauser public {
441     paused = false;
442     emit Unpause();
443   }
444 
445   /**
446    * @dev update the pauser role
447    */
448   function updatePauser(address _newPauser) onlyOwner public {
449     require(_newPauser != address(0));
450     pauser = _newPauser;
451     emit PauserChanged(pauser);
452   }
453 
454 }
455 
456 /**
457  * @title Blacklistable Token
458  * @dev Allows accounts to be blacklisted by a "blacklister" role
459 */
460 contract Blacklistable is Ownable {
461 
462     address public blacklister;
463     mapping(address => bool) internal blacklisted;
464 
465     event Blacklisted(address indexed _account);
466     event UnBlacklisted(address indexed _account);
467     event BlacklisterChanged(address indexed newBlacklister);
468 
469     /**
470      * @dev Throws if called by any account other than the blacklister
471     */
472     modifier onlyBlacklister() {
473         require(msg.sender == blacklister);
474         _;
475     }
476 
477     /**
478      * @dev Throws if argument account is blacklisted
479      * @param _account The address to check
480     */
481     modifier notBlacklisted(address _account) {
482         require(blacklisted[_account] == false);
483         _;
484     }
485 
486     /**
487      * @dev Checks if account is blacklisted
488      * @param _account The address to check    
489     */
490     function isBlacklisted(address _account) public view returns (bool) {
491         return blacklisted[_account];
492     }
493 
494     /**
495      * @dev Adds account to blacklist
496      * @param _account The address to blacklist
497     */
498     function blacklist(address _account) public onlyBlacklister {
499         blacklisted[_account] = true;
500         emit Blacklisted(_account);
501     }
502 
503     /**
504      * @dev Removes account from blacklist
505      * @param _account The address to remove from the blacklist
506     */
507     function unBlacklist(address _account) public onlyBlacklister {
508         blacklisted[_account] = false;
509         emit UnBlacklisted(_account);
510     }
511 
512     function updateBlacklister(address _newBlacklister) public onlyOwner {
513         require(_newBlacklister != address(0));
514         blacklister = _newBlacklister;
515         emit BlacklisterChanged(blacklister);
516     }
517 }
518 
519 contract LakesCash is Ownable, ERC20, Pausable, Blacklistable {
520     using SafeMath for uint256;
521 
522     string public name;
523     string public symbol;
524     uint8 public decimals;
525     string public currency;
526     address public masterMinter;
527     bool internal initialized;
528 
529     mapping(address => uint256) internal balances;
530     mapping(address => mapping(address => uint256)) internal allowed;
531     uint256 internal totalSupply_ = 0;
532     mapping(address => bool) internal minters;
533     mapping(address => uint256) internal minterAllowed;
534 
535     event Mint(address indexed minter, address indexed to, uint256 amount);
536     event Burn(address indexed burner, uint256 amount);
537     event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
538     event MinterRemoved(address indexed oldMinter);
539     event MasterMinterChanged(address indexed newMasterMinter);
540 
541     function initialize(
542         string memory _name,
543         string memory _symbol,
544         string memory _currency,
545         uint8 _decimals,
546         address _masterMinter,
547         address _pauser,
548         address _blacklister,
549         address _owner
550     ) public {
551         require(!initialized);
552         require(_masterMinter != address(0));
553         require(_pauser != address(0));
554         require(_blacklister != address(0));
555         require(_owner != address(0));
556 
557         name = _name;
558         symbol = _symbol;
559         currency = _currency;
560         decimals = _decimals;
561         masterMinter = _masterMinter;
562         pauser = _pauser;
563         blacklister = _blacklister;
564         initialized = true;
565     }
566 
567     /**
568      * @dev Throws if called by any account other than a minter
569     */
570     modifier onlyMinters() {
571         require(minters[msg.sender] == true);
572         _;
573     }
574 
575     /**
576      * @dev Function to mint tokens
577      * @param _to The address that will receive the minted tokens.
578      * @param _amount The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
579      * @return A boolean that indicates if the operation was successful.
580     */
581     function mint(address _to, uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
582         require(_to != address(0));
583         require(_amount > 0);
584 
585         uint256 mintingAllowedAmount = minterAllowed[msg.sender];
586         require(_amount <= mintingAllowedAmount);
587 
588         totalSupply_ = totalSupply_.add(_amount);
589         balances[_to] = balances[_to].add(_amount);
590         minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
591         emit Mint(msg.sender, _to, _amount);
592         emit Transfer(address(0), _to, _amount);
593         return true;
594     }
595 
596     /**
597      * @dev Throws if called by any account other than the masterMinter
598     */
599     modifier onlyMasterMinter() {
600         require(msg.sender == masterMinter);
601         _;
602     }
603 
604     /**
605      * @dev Get minter allowance for an account
606      * @param minter The address of the minter
607     */
608     function minterAllowance(address minter) public view returns (uint256) {
609         return minterAllowed[minter];
610     }
611 
612     /**
613      * @dev Checks if account is a minter
614      * @param account The address to check    
615     */
616     function isMinter(address account) public view returns (bool) {
617         return minters[account];
618     }
619 
620     /**
621      * @dev Get allowed amount for an account
622      * @param owner address The account owner
623      * @param spender address The account spender
624     */
625     function allowance(address owner, address spender) public view returns (uint256) {
626         return allowed[owner][spender];
627     }
628 
629     /**
630      * @dev Get totalSupply of token
631     */
632     function totalSupply() public view returns (uint256) {
633         return totalSupply_;
634     }
635 
636     /**
637      * @dev Get token balance of an account
638      * @param account address The account
639     */
640     function balanceOf(address account) public view returns (uint256) {
641         return balances[account];
642     }
643 
644     /**
645      * @dev Adds blacklisted check to approve
646      * @return True if the operation was successful.
647     */
648     function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
649         allowed[msg.sender][_spender] = _value;
650         emit Approval(msg.sender, _spender, _value);
651         return true;
652     }
653 
654     /**
655      * @dev Transfer tokens from one address to another.
656      * @param _from address The address which you want to send tokens from
657      * @param _to address The address which you want to transfer to
658      * @param _value uint256 the amount of tokens to be transferred
659      * @return bool success
660     */
661     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public returns (bool) {
662         require(_to != address(0));
663         require(_value <= balances[_from]);
664         require(_value <= allowed[_from][msg.sender]);
665 
666         balances[_from] = balances[_from].sub(_value);
667         balances[_to] = balances[_to].add(_value);
668         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
669         emit Transfer(_from, _to, _value);
670         return true;
671     }
672 
673     /**
674      * @dev transfer token for a specified address
675      * @param _to The address to transfer to.
676      * @param _value The amount to be transferred.
677      * @return bool success
678     */
679     function transfer(address _to, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
680         require(_to != address(0));
681         require(_value <= balances[msg.sender]);
682 
683         balances[msg.sender] = balances[msg.sender].sub(_value);
684         balances[_to] = balances[_to].add(_value);
685         emit Transfer(msg.sender, _to, _value);
686         return true;
687     }
688 
689     /**
690      * @dev Function to add/update a new minter
691      * @param minter The address of the minter
692      * @param minterAllowedAmount The minting amount allowed for the minter
693      * @return True if the operation was successful.
694     */
695     function configureMinter(address minter, uint256 minterAllowedAmount) whenNotPaused onlyMasterMinter public returns (bool) {
696         minters[minter] = true;
697         minterAllowed[minter] = minterAllowedAmount;
698         emit MinterConfigured(minter, minterAllowedAmount);
699         return true;
700     }
701 
702     /**
703      * @dev Function to remove a minter
704      * @param minter The address of the minter to remove
705      * @return True if the operation was successful.
706     */
707     function removeMinter(address minter) onlyMasterMinter public returns (bool) {
708         minters[minter] = false;
709         minterAllowed[minter] = 0;
710         emit MinterRemoved(minter);
711         return true;
712     }
713 
714     /**
715      * @dev allows a minter to burn some of its own tokens
716      * Validates that caller is a minter and that sender is not blacklisted
717      * amount is less than or equal to the minter's account balance
718      * @param _amount uint256 the amount of tokens to be burned
719     */
720     function burn(uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) public {
721         uint256 balance = balances[msg.sender];
722         require(_amount > 0);
723         require(balance >= _amount);
724 
725         totalSupply_ = totalSupply_.sub(_amount);
726         balances[msg.sender] = balance.sub(_amount);
727         emit Burn(msg.sender, _amount);
728         emit Transfer(msg.sender, address(0), _amount);
729     }
730 
731     function updateMasterMinter(address _newMasterMinter) onlyOwner public {
732         require(_newMasterMinter != address(0));
733         masterMinter = _newMasterMinter;
734         emit MasterMinterChanged(masterMinter);
735     }
736 }