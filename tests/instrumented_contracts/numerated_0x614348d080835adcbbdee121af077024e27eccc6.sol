1 pragma solidity 0.4.19;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: node_modules/zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     // SafeMath.sub will throw if there is not enough balance.
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256 balance) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender) public view returns (uint256);
198   function transferFrom(address from, address to, uint256 value) public returns (bool);
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 // File: node_modules/zeppelin-solidity/contracts/token/ERC827/ERC827.sol
301 
302 /**
303    @title ERC827 interface, an extension of ERC20 token standard
304 
305    Interface of a ERC827 token, following the ERC20 standard with extra
306    methods to transfer value and data and execute calls in transfers and
307    approvals.
308  */
309 contract ERC827 is ERC20 {
310 
311   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
312   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
313   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
314 
315 }
316 
317 // File: node_modules/zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
318 
319 /**
320    @title ERC827, an extension of ERC20 token standard
321 
322    Implementation the ERC827, following the ERC20 standard with extra
323    methods to transfer value and data and execute calls in transfers and
324    approvals.
325    Uses OpenZeppelin StandardToken.
326  */
327 contract ERC827Token is ERC827, StandardToken {
328 
329   /**
330      @dev Addition to ERC20 token methods. It allows to
331      approve the transfer of value and execute a call with the sent data.
332 
333      Beware that changing an allowance with this method brings the risk that
334      someone may use both the old and the new allowance by unfortunate
335      transaction ordering. One possible solution to mitigate this race condition
336      is to first reduce the spender's allowance to 0 and set the desired value
337      afterwards:
338      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
339 
340      @param _spender The address that will spend the funds.
341      @param _value The amount of tokens to be spent.
342      @param _data ABI-encoded contract call to call `_to` address.
343 
344      @return true if the call function was executed successfully
345    */
346   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
347     require(_spender != address(this));
348 
349     super.approve(_spender, _value);
350 
351     require(_spender.call(_data));
352 
353     return true;
354   }
355 
356   /**
357      @dev Addition to ERC20 token methods. Transfer tokens to a specified
358      address and execute a call with the sent data on the same transaction
359 
360      @param _to address The address which you want to transfer to
361      @param _value uint256 the amout of tokens to be transfered
362      @param _data ABI-encoded contract call to call `_to` address.
363 
364      @return true if the call function was executed successfully
365    */
366   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
367     require(_to != address(this));
368 
369     super.transfer(_to, _value);
370 
371     require(_to.call(_data));
372     return true;
373   }
374 
375   /**
376      @dev Addition to ERC20 token methods. Transfer tokens from one address to
377      another and make a contract call on the same transaction
378 
379      @param _from The address which you want to send tokens from
380      @param _to The address which you want to transfer to
381      @param _value The amout of tokens to be transferred
382      @param _data ABI-encoded contract call to call `_to` address.
383 
384      @return true if the call function was executed successfully
385    */
386   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
387     require(_to != address(this));
388 
389     super.transferFrom(_from, _to, _value);
390 
391     require(_to.call(_data));
392     return true;
393   }
394 
395   /**
396    * @dev Addition to StandardToken methods. Increase the amount of tokens that
397    * an owner allowed to a spender and execute a call with the sent data.
398    *
399    * approve should be called when allowed[_spender] == 0. To increment
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _addedValue The amount of tokens to increase the allowance by.
405    * @param _data ABI-encoded contract call to call `_spender` address.
406    */
407   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
408     require(_spender != address(this));
409 
410     super.increaseApproval(_spender, _addedValue);
411 
412     require(_spender.call(_data));
413 
414     return true;
415   }
416 
417   /**
418    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
419    * an owner allowed to a spender and execute a call with the sent data.
420    *
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    * @param _data ABI-encoded contract call to call `_spender` address.
428    */
429   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
430     require(_spender != address(this));
431 
432     super.decreaseApproval(_spender, _subtractedValue);
433 
434     require(_spender.call(_data));
435 
436     return true;
437   }
438 
439 }
440 
441 // File: contracts/BaseContracts/LDGBasicToken.sol
442 
443 contract LDGBasicToken is ERC827Token, Claimable {
444     mapping (address => bool) public isHolder;
445     address[] public holders;
446 
447     function addHolder(address _addr) internal returns (bool) {
448         if (isHolder[_addr] != true) {
449             holders[holders.length++] = _addr;
450             isHolder[_addr] = true;
451             return true;
452         }
453         return false;
454     }
455 
456     function transfer(address _to, uint256 _value) public returns (bool) {
457         require(_to != address(this)); // Prevent transfer to contract itself
458         bool ok = super.transfer(_to, _value);
459         addHolder(_to);
460         return ok;
461     }
462 
463     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
464         require(_to != address(this)); // Prevent transfer to contract itself
465         bool ok = super.transferFrom(_from, _to, _value);
466         addHolder(_to);
467         return ok;
468     }
469 
470     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
471         require(_to != address(this)); // Prevent transfer to contract itself
472         bool ok = super.transfer(_to, _value, _data);
473         addHolder(_to);
474         return ok;
475     }
476 
477     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
478         require(_to != address(this)); // Prevent transfer to contract itself
479         bool ok = super.transferFrom(_from, _to, _value, _data);
480         addHolder(_to);
481         return ok;
482     }
483 }
484 
485 // File: contracts/BaseContracts/LDGBurnableToken.sol
486 
487 /// LDG Burnable Token Contract
488 /// LDG Burnable Token Contract is based on Open Zeppelin
489 /// and modified
490 
491 
492 contract LDGBurnableToken is LDGBasicToken {
493     event Burn(address indexed burner, uint256 value);
494 
495     /**
496     * @dev Burns a specific amount of tokens.
497     * @param _value The amount of token to be burned.
498     */
499     function burn(uint256 _value) public onlyOwner {
500         require(_value <= balances[msg.sender]);
501         // no need to require value <= totalSupply, since that would imply the
502         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
503 
504         address burner = msg.sender;
505         balances[burner] = balances[burner].sub(_value);
506         totalSupply_ = totalSupply_.sub(_value);
507         Burn(burner, _value);
508         Transfer(burner, address(0), _value);
509     }
510 }
511 
512 // File: contracts/BaseContracts/LDGMigratableToken.sol
513 
514 contract MigrationAgent {
515     function migrateFrom(address from, uint256 value) public returns (bool);
516 }
517 
518 contract LDGMigratableToken is LDGBasicToken {
519     using SafeMath for uint256;
520 
521     address public migrationAgent;
522     uint256 public migrationCountComplete;
523 
524     event Migrate(address indexed owner, uint256 value);
525 
526     function setMigrationAgent(address agent) public onlyOwner {
527         migrationAgent = agent;
528     }
529 
530     function migrate() public returns (bool) {
531         require(migrationAgent != address(0));
532 
533         uint256 value = balances[msg.sender];
534         balances[msg.sender] = balances[msg.sender].sub(value);
535         totalSupply_ = totalSupply_.sub(value);
536         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
537 
538         Migrate(msg.sender, value);
539         return true;
540     }
541 
542     function migrateHolders(uint256 count) public onlyOwner returns (bool) {
543         require(count > 0);
544         require(migrationAgent != address(0));
545 
546         count = migrationCountComplete + count;
547 
548         if (count > holders.length) {
549             count = holders.length;
550         }
551 
552         for (uint256 i = migrationCountComplete; i < count; i++) {
553             address holder = holders[i];
554             uint256 value = balances[holder];
555             balances[holder] = balances[holder].sub(value);
556             totalSupply_ = totalSupply_.sub(value);
557             MigrationAgent(migrationAgent).migrateFrom(holder, value);
558 
559             Migrate(holder, value);
560             return true;
561         }
562     }
563 }
564 
565 // File: contracts/BaseContracts/LDGMintableToken.sol
566 
567 /// LDG Mintable Token Contract
568 /// @notice LDG Mintable Token Contract is based on Open Zeppelin
569 /// and modified
570 
571 contract LDGMintableToken is LDGBasicToken {
572     event Mint(address indexed to, uint256 amount);
573     event MintFinished();
574 
575     bool public mintingFinished = false;
576 
577     modifier canMint() {
578         require(!mintingFinished);
579         _;
580     }
581 
582     /**
583     * @dev Function to mint tokens
584     * @param _to The address that will receive the minted tokens.
585     * @param _amount The amount of tokens to mint.
586     * @return A boolean that indicates if the operation was successful.
587     */
588     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
589         totalSupply_ = totalSupply_.add(_amount);
590         balances[_to] = balances[_to].add(_amount);
591         Mint(_to, _amount);
592         Transfer(address(0), _to, _amount);
593         return true;
594     }
595 
596     /**
597     * @dev Function to stop minting new tokens.
598     * @return True if the operation was successful.
599     */
600     function finishMinting() onlyOwner canMint public returns (bool) {
601         mintingFinished = true;
602         MintFinished();
603         return true;
604     }
605 }
606 
607 // File: contracts/LDGToken.sol
608 
609 // ----------------------------------------------------------------------------
610 // Ledgit token contract
611 //
612 // Symbol : LDG
613 // Name : Ledgit Token
614 // Total supply : 1,500,000,000.000000000000000000
615 // Decimals : 18
616 //
617 // ----------------------------------------------------------------------------
618 
619 
620 
621 
622 contract LDGToken is LDGMintableToken, LDGBurnableToken, LDGMigratableToken {
623     string public name;
624     string public symbol;
625     uint8 public decimals;
626 
627     function LDGToken() public {
628         name = "Ledgit";
629         symbol = "LDG";
630         decimals = 18;
631 
632         totalSupply_ = 1500000000 * 10 ** uint(decimals);
633 
634         balances[owner] = totalSupply_;
635         Transfer(address(0), owner, totalSupply_);
636     }
637 
638     function() public payable {
639         revert();
640     }
641 }