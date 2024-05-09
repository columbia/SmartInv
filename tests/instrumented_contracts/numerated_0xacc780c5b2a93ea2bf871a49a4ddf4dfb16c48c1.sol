1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 }
41 
42 // File: zeppelin/contracts/math/SafeMath.sol
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50     /**
51     * @dev Multiplies two numbers, throws on overflow.
52     */
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers, truncating the quotient.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // assert(b > 0); // Solidity automatically throws when dividing by 0
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     /**
81     * @dev Adds two numbers, throws on overflow.
82     */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 // File: zeppelin/contracts/token/ERC20/ERC20Basic.sol
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 // File: zeppelin/contracts/token/ERC20/BasicToken.sol
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111     using SafeMath for uint256;
112 
113     mapping(address => uint256) balances;
114 
115     uint256 totalSupply_;
116 
117     /**
118     * @dev total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return totalSupply_;
122     }
123 
124     /**
125     * @dev transfer token for a specified address
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[msg.sender]);
132 
133         // SafeMath.sub will throw if there is not enough balance.
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     /**
141     * @dev Gets the balance of the specified address.
142     * @param _owner The address to query the the balance of.
143     * @return An uint256 representing the amount owned by the passed address.
144     */
145     function balanceOf(address _owner) public view returns (uint256 balance) {
146         return balances[_owner];
147     }
148 
149 }
150 
151 // File: zeppelin/contracts/token/ERC20/ERC20.sol
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158     function allowance(address owner, address spender) public view returns (uint256);
159     function transferFrom(address from, address to, uint256 value) public returns (bool);
160     function approve(address spender, uint256 value) public returns (bool);
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 // File: zeppelin/contracts/token/ERC20/StandardToken.sol
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178     /**
179      * @dev Transfer tokens from one address to another
180      * @param _from address The address which you want to send tokens from
181      * @param _to address The address which you want to transfer to
182      * @param _value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         emit Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198      *
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param _spender The address which will spend the funds.
204      * @param _value The amount of tokens to be spent.
205      */
206     function approve(address _spender, uint256 _value) public returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param _owner address The address which owns the funds.
215      * @param _spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      *
225      * approve should be called when allowed[_spender] == 0. To increment
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * @param _spender The address which will spend the funds.
230      * @param _addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     /**
239      * @dev Decrease the amount of tokens that an owner allowed to a spender.
240      *
241      * approve should be called when allowed[_spender] == 0. To decrement
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _subtractedValue The amount of tokens to decrease the allowance by.
247      */
248     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249         uint oldValue = allowed[msg.sender][_spender];
250         if (_subtractedValue > oldValue) {
251             allowed[msg.sender][_spender] = 0;
252         } else {
253             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254         }
255         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 
259 }
260 
261 // File: contracts/TransferableToken.sol
262 
263 /**
264     Copyright (c) 2018 Cryptense SAS - Kryll.io
265 
266     Kryll.io / Transferable ERC20 token mechanism
267     Version 0.2
268     
269     Permission is hereby granted, free of charge, to any person obtaining a copy
270     of this software and associated documentation files (the "Software"), to deal
271     in the Software without restriction, including without limitation the rights
272     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
273     copies of the Software, and to permit persons to whom the Software is
274     furnished to do so, subject to the following conditions:
275 
276     The above copyright notice and this permission notice shall be included in
277     all copies or substantial portions of the Software.
278 
279     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
280     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
281     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
282     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
283     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
284     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
285     THE SOFTWARE.
286 
287     based on the contracts of OpenZeppelin:
288     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
289 **/
290 
291 pragma solidity ^0.4.23;
292 
293 
294 
295 
296 /**
297  * @title Transferable token
298  *
299  * @dev StandardToken modified with transfert on/off mechanism.
300  **/
301 contract TransferableToken is StandardToken,Ownable {
302 
303     /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
304     * @dev TRANSFERABLE MECANISM SECTION
305     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
306 
307     event Transferable();
308     event UnTransferable();
309 
310     bool public transferable = false;
311     mapping (address => bool) public whitelisted;
312 
313     /**
314         CONSTRUCTOR
315     **/
316     
317     constructor() 
318         StandardToken() 
319         Ownable()
320         public 
321     {
322         whitelisted[msg.sender] = true;
323     }
324 
325     /**
326         MODIFIERS
327     **/
328 
329     /**
330     * @dev Modifier to make a function callable only when the contract is not transferable.
331     */
332     modifier whenNotTransferable() {
333         require(!transferable);
334         _;
335     }
336 
337     /**
338     * @dev Modifier to make a function callable only when the contract is transferable.
339     */
340     modifier whenTransferable() {
341         require(transferable);
342         _;
343     }
344 
345     /**
346     * @dev Modifier to make a function callable only when the caller can transfert token.
347     */
348     modifier canTransfert() {
349         if(!transferable){
350             require (whitelisted[msg.sender]);
351         } 
352         _;
353    }
354    
355     /**
356         OWNER ONLY FUNCTIONS
357     **/
358 
359     /**
360     * @dev called by the owner to allow transferts, triggers Transferable state
361     */
362     function allowTransfert() onlyOwner whenNotTransferable public {
363         transferable = true;
364         emit Transferable();
365     }
366 
367     /**
368     * @dev called by the owner to restrict transferts, returns to untransferable state
369     */
370     function restrictTransfert() onlyOwner whenTransferable public {
371         transferable = false;
372         emit UnTransferable();
373     }
374 
375     /**
376       @dev Allows the owner to add addresse that can bypass the transfer lock.
377     **/
378     function whitelist(address _address) onlyOwner public {
379         require(_address != 0x0);
380         whitelisted[_address] = true;
381     }
382 
383     /**
384       @dev Allows the owner to remove addresse that can bypass the transfer lock.
385     **/
386     function restrict(address _address) onlyOwner public {
387         require(_address != 0x0);
388         whitelisted[_address] = false;
389     }
390 
391 
392     /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
393     * @dev Strandard transferts overloaded API
394     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
395 
396     function transfer(address _to, uint256 _value) public canTransfert returns (bool) {
397         return super.transfer(_to, _value);
398     }
399 
400     function transferFrom(address _from, address _to, uint256 _value) public canTransfert returns (bool) {
401         return super.transferFrom(_from, _to, _value);
402     }
403 
404   /**
405    * Beware that changing an allowance with this method brings the risk that someone may use both the old
406    * and the new allowance by unfortunate transaction ordering. We recommend to use use increaseApproval
407    * and decreaseApproval functions instead !
408    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598
409    */
410     function approve(address _spender, uint256 _value) public canTransfert returns (bool) {
411         return super.approve(_spender, _value);
412     }
413 
414     function increaseApproval(address _spender, uint _addedValue) public canTransfert returns (bool success) {
415         return super.increaseApproval(_spender, _addedValue);
416     }
417 
418     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfert returns (bool success) {
419         return super.decreaseApproval(_spender, _subtractedValue);
420     }
421 }
422 
423 // File: contracts/KryllToken.sol
424 
425 /**
426     Copyright (c) 2018 Cryptense SAS - Kryll.io
427 
428     Kryll.io / KRL ERC20 Token Smart Contract    
429     Version 0.2
430 
431     Permission is hereby granted, free of charge, to any person obtaining a copy
432     of this software and associated documentation files (the "Software"), to deal
433     in the Software without restriction, including without limitation the rights
434     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
435     copies of the Software, and to permit persons to whom the Software is
436     furnished to do so, subject to the following conditions:
437 
438     The above copyright notice and this permission notice shall be included in
439     all copies or substantial portions of the Software.
440 
441     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
442     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
443     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
444     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
445     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
446     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
447     THE SOFTWARE.
448 
449     based on the contracts of OpenZeppelin:
450     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
451 **/
452 
453 pragma solidity ^0.4.23;
454 
455 
456 
457 
458 contract KryllToken is TransferableToken {
459 //    using SafeMath for uint256;
460 
461     string public symbol = "KRL";
462     string public name = "Kryll.io Token";
463     uint8 public decimals = 18;
464   
465 
466     uint256 constant internal DECIMAL_CASES    = (10 ** uint256(decimals));
467     uint256 constant public   SALE             =  17737348 * DECIMAL_CASES; // Token sale
468     uint256 constant public   TEAM             =   8640000 * DECIMAL_CASES; // TEAM (vested)
469     uint256 constant public   ADVISORS         =   2880000 * DECIMAL_CASES; // Advisors
470     uint256 constant public   SECURITY         =   4320000 * DECIMAL_CASES; // Security Reserve
471     uint256 constant public   PRESS_MARKETING  =   5040000 * DECIMAL_CASES; // Press release
472     uint256 constant public   USER_ACQUISITION =  10080000 * DECIMAL_CASES; // User Acquisition 
473     uint256 constant public   BOUNTY           =    720000 * DECIMAL_CASES; // Bounty (ICO & future)
474 
475     address public sale_address     = 0x29e9535AF275a9010862fCDf55Fe45CD5D24C775;
476     address public team_address     = 0xd32E4fb9e8191A97905Fb5Be9Aa27458cD0124C1;
477     address public advisors_address = 0x609f5a53189cAf4EeE25709901f43D98516114Da;
478     address public security_address = 0x2eA5917E227552253891C1860E6c6D0057386F62;
479     address public press_address    = 0xE9cAad0504F3e46b0ebc347F5bf591DBcB49756a;
480     address public user_acq_address = 0xACD80ad0f7beBe447ea0625B606Cf3DF206DafeF;
481     address public bounty_address   = 0x150658D45dc62E9EB246E82e552A3ec93d664985;
482     bool public initialDistributionDone = false;
483 
484     /**
485     * @dev Setup the initial distribution addresses
486     */
487     function reset(address _saleAddrss, address _teamAddrss, address _advisorsAddrss, address _securityAddrss, address _pressAddrss, address _usrAcqAddrss, address _bountyAddrss) public onlyOwner{
488         require(!initialDistributionDone);
489         team_address = _teamAddrss;
490         advisors_address = _advisorsAddrss;
491         security_address = _securityAddrss;
492         press_address = _pressAddrss;
493         user_acq_address = _usrAcqAddrss;
494         bounty_address = _bountyAddrss;
495         sale_address = _saleAddrss;
496     }
497 
498     /**
499     * @dev compute & distribute the tokens
500     */
501     function distribute() public onlyOwner {
502         // Initialisation check
503         require(!initialDistributionDone);
504         require(sale_address != 0x0 && team_address != 0x0 && advisors_address != 0x0 && security_address != 0x0 && press_address != 0x0 && user_acq_address != 0 && bounty_address != 0x0);      
505 
506         // Compute total supply 
507         totalSupply_ = SALE.add(TEAM).add(ADVISORS).add(SECURITY).add(PRESS_MARKETING).add(USER_ACQUISITION).add(BOUNTY);
508 
509         // Distribute KRL Token 
510         balances[owner] = totalSupply_;
511         emit Transfer(0x0, owner, totalSupply_);
512 
513         transfer(team_address, TEAM);
514         transfer(advisors_address, ADVISORS);
515         transfer(security_address, SECURITY);
516         transfer(press_address, PRESS_MARKETING);
517         transfer(user_acq_address, USER_ACQUISITION);
518         transfer(bounty_address, BOUNTY);
519         transfer(sale_address, SALE);
520         initialDistributionDone = true;
521         whitelist(sale_address); // Auto whitelist sale address
522         whitelist(team_address); // Auto whitelist team address (vesting transfert)
523     }
524 
525     /**
526     * @dev Allows owner to later update token name if needed.
527     */
528     function setName(string _name) onlyOwner public {
529         name = _name;
530     }
531 
532 }
533 
534 // File: contracts/KryllVesting.sol
535 
536 /**
537     Copyright (c) 2018 Cryptense SAS - Kryll.io
538 
539     Kryll.io / KRL Vesting Smart Contract
540     Version 0.2
541     
542     Permission is hereby granted, free of charge, to any person obtaining a copy
543     of this software and associated documentation files (the "Software"), to deal
544     in the Software without restriction, including without limitation the rights
545     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
546     copies of the Software, and to permit persons to whom the Software is
547     furnished to do so, subject to the following conditions:
548 
549     The above copyright notice and this permission notice shall be included in
550     all copies or substantial portions of the Software.
551 
552     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
553     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
554     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
555     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
556     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
557     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
558     THE SOFTWARE.
559 
560     based on the contracts of OpenZeppelin:
561     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
562 **/
563 
564 pragma solidity ^0.4.23;
565 
566 
567 
568 
569 /**
570  * @title KryllVesting
571  * @dev A token holder contract that can release its token balance gradually like a
572  * typical vesting scheme, with a cliff and vesting period.
573  */
574 contract KryllVesting is Ownable {
575     using SafeMath for uint256;
576 
577     event Released(uint256 amount);
578 
579     // beneficiary of tokens after they are released
580     address public beneficiary;
581     KryllToken public token;
582 
583     uint256 public startTime;
584     uint256 public cliff;
585     uint256 public released;
586 
587 
588     uint256 constant public   VESTING_DURATION    =  31536000; // 1 Year in second
589     uint256 constant public   CLIFF_DURATION      =   7776000; // 3 months (90 days) in second
590 
591 
592     /**
593     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
594     * _beneficiary, gradually in a linear fashion. By then all of the balance will have vested.
595     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
596     * @param _token The token to be vested
597     */
598     function setup(address _beneficiary,address _token) public onlyOwner{
599         require(startTime == 0); // Vesting not started
600         require(_beneficiary != address(0));
601         // Basic init
602         changeBeneficiary(_beneficiary);
603         token = KryllToken(_token);
604     }
605 
606     /**
607     * @notice Start the vesting process.
608     */
609     function start() public onlyOwner{
610         require(token != address(0));
611         require(startTime == 0); // Vesting not started
612         startTime = now;
613         cliff = startTime.add(CLIFF_DURATION);
614     }
615 
616     /**
617     * @notice Is vesting started flag.
618     */
619     function isStarted() public view returns (bool) {
620         return (startTime > 0);
621     }
622 
623 
624     /**
625     * @notice Owner can change beneficiary address
626     */
627     function changeBeneficiary(address _beneficiary) public onlyOwner{
628         beneficiary = _beneficiary;
629     }
630 
631 
632     /**
633     * @notice Transfers vested tokens to beneficiary.
634     */
635     function release() public {
636         require(startTime != 0);
637         require(beneficiary != address(0));
638         
639         uint256 unreleased = releasableAmount();
640         require(unreleased > 0);
641 
642         released = released.add(unreleased);
643         token.transfer(beneficiary, unreleased);
644         emit Released(unreleased);
645     }
646 
647     /**
648     * @dev Calculates the amount that has already vested but hasn't been released yet.
649     */
650     function releasableAmount() public view returns (uint256) {
651         return vestedAmount().sub(released);
652     }
653 
654     /**
655     * @dev Calculates the amount that has already vested.
656     */
657     function vestedAmount() public view returns (uint256) {
658         uint256 currentBalance = token.balanceOf(this);
659         uint256 totalBalance = currentBalance.add(released);
660 
661         if (now < cliff) {
662             return 0;
663         } else if (now >= startTime.add(VESTING_DURATION)) {
664             return totalBalance;
665         } else {
666             return totalBalance.mul(now.sub(startTime)).div(VESTING_DURATION);
667         }
668     }
669 }