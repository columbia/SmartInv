1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11     address public pendingOwner;
12     address public manager;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     event ManagerUpdated(address newManager);
17 
18    /**
19    * @dev Throws if called by any account other than the owner.
20    */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Modifier throws if called by any account other than the manager.
28      */
29     modifier onlyManager() {
30         require(msg.sender == manager);
31         _;
32     }
33 
34     /**
35     * @dev Modifier throws if called by any account other than the pendingOwner.
36     */
37     modifier onlyPendingOwner() {
38         require(msg.sender == pendingOwner);
39         _;
40     }
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     /**
47     * @dev Allows the current owner to set the pendingOwner address.
48     * @param newOwner The address to transfer ownership to.
49     */
50     function transferOwnership(address newOwner) public onlyOwner {
51         pendingOwner = newOwner;
52     }
53 
54     /**
55     * @dev Allows the pendingOwner address to finalize the transfer.
56     */
57     function claimOwnership() public onlyPendingOwner {
58         emit OwnershipTransferred(owner, pendingOwner);
59         owner = pendingOwner;
60         pendingOwner = address(0);
61     }
62 
63     /**
64     * @dev Sets the manager address.
65     * @param _manager The manager address.
66     */
67     function setManager(address _manager) public onlyOwner {
68         require(_manager != address(0));
69         manager = _manager;
70         emit ManagerUpdated(manager);
71     }
72 
73 }
74 
75 /**
76  * @title Whitelist
77  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
78  * @dev This simplifies the implementation of "user permissions".
79  */
80 contract Whitelist is Ownable {
81     mapping(address => bool) public whitelist;
82 
83     event WhitelistedAddressAdded(address addr);
84     event WhitelistedAddressRemoved(address addr);
85 
86     /**
87      * @dev Throws if called by any account that's not whitelisted.
88      */
89     modifier onlyWhitelisted() {
90         require(whitelist[msg.sender]);
91         _;
92     }
93 
94     /**
95      * @dev add an address to the whitelist
96      * @param addr address
97      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
98      */
99     function addAddressToWhitelist(address addr) public onlyOwner returns(bool success) {
100         if (!whitelist[addr]) {
101             whitelist[addr] = true;
102             emit WhitelistedAddressAdded(addr);
103             success = true;
104         }
105     }
106 
107     /**
108      * @dev add addresses to the whitelist
109      * @param addrs addresses
110      * @return true if at least one address was added to the whitelist,
111      * false if all addresses were already in the whitelist
112      */
113     function addAddressesToWhitelist(address[] addrs) public onlyOwner returns(bool success) {
114         for (uint256 i = 0; i < addrs.length; i++) {
115             if (addAddressToWhitelist(addrs[i])) {
116                 success = true;
117             }
118         }
119     }
120 
121     /**
122      * @dev remove an address from the whitelist
123      * @param addr address
124      * @return true if the address was removed from the whitelist,
125      * false if the address wasn't in the whitelist in the first place
126      */
127     function removeAddressFromWhitelist(address addr) public onlyOwner returns(bool success) {
128         if (whitelist[addr]) {
129             whitelist[addr] = false;
130             emit WhitelistedAddressRemoved(addr);
131             success = true;
132         }
133     }
134 
135     /**
136      * @dev remove addresses from the whitelist
137      * @param addrs addresses
138      * @return true if at least one address was removed from the whitelist,
139      * false if all addresses weren't in the whitelist in the first place
140      */
141     function removeAddressesFromWhitelist(address[] addrs) public onlyOwner returns(bool success) {
142         for (uint256 i = 0; i < addrs.length; i++) {
143             if (removeAddressFromWhitelist(addrs[i])) {
144                 success = true;
145             }
146         }
147     }
148 
149 }
150 
151 /**
152  * @title Pausable
153  * @dev Base contract which allows children to implement an emergency stop mechanism.
154  */
155 contract Pausable is Whitelist {
156     event Pause();
157     event Unpause();
158 
159     bool public paused = false;
160 
161   /**
162    * @dev Modifier to make a function callable only when the contract is not paused.
163    */
164     modifier whenNotPaused() {
165         require((!paused) || (whitelist[msg.sender]));
166         _;
167     }
168 
169     /**
170      * @dev Modifier to make a function callable only when the contract is paused.
171      */
172     modifier whenPaused() {
173         require(paused);
174         _;
175     }
176 
177     /**
178      * @dev called by the owner to pause, triggers stopped state
179      */
180     function pause() public onlyOwner whenNotPaused {
181         paused = true;
182         emit Pause();
183     }
184 
185     /**
186      * @dev called by the owner to unpause, returns to normal state
187      */
188     function unpause() public onlyOwner whenPaused {
189         paused = false;
190         emit Unpause();
191     }
192 }
193 
194 
195 /**
196  * @title ERC20Basic
197  * @dev Simpler version of ERC20 interface
198  * See https://github.com/ethereum/EIPs/issues/179
199  */
200 contract ERC20Basic {
201     function totalSupply() public view returns (uint256);
202     function balanceOf(address who) public view returns (uint256);
203     function transfer(address to, uint256 value) public returns (bool);
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 }
206 
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213     function allowance(address owner, address spender)
214         public view returns (uint256);
215 
216     function transferFrom(address from, address to, uint256 value)
217         public returns (bool);
218 
219     function approve(address spender, uint256 value) public returns (bool);
220 
221     event Approval(
222         address indexed owner,
223         address indexed spender,
224         uint256 value
225     );
226 }
227 
228 
229 /**
230  * @title SafeMath
231  * @dev Math operations with safety checks that throw on error
232  */
233 library SafeMath {
234 
235     /**
236     * @dev Multiplies two numbers, throws on overflow.
237     */
238     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
239         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
240         // benefit is lost if 'b' is also tested.
241         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
242         if (a == 0) {
243             return 0;
244         }
245 
246         c = a * b;
247         assert(c / a == b);
248         return c;
249     }
250 
251     /**
252     * @dev Integer division of two numbers, truncating the quotient.
253     */
254     function div(uint256 a, uint256 b) internal pure returns (uint256) {
255         // assert(b > 0); // Solidity automatically throws when dividing by 0
256         // uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258         return a / b;
259     }
260 
261     /**
262     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
263     */
264     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265         assert(b <= a);
266         return a - b;
267     }
268 
269     /**
270     * @dev Adds two numbers, throws on overflow.
271     */
272     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
273         c = a + b;
274         assert(c >= a);
275         return c;
276     }
277 }
278 
279 
280 /**
281  * @title Basic token
282  * @dev Basic version of StandardToken, with no allowances.
283  */
284 contract BasicToken is ERC20Basic {
285     using SafeMath for uint256;
286 
287     mapping(address => uint256) public balances;
288 
289     uint256 public totalSupply_;
290 
291     /**
292     * @dev Total number of tokens in existence
293     */
294     function totalSupply() public view returns (uint256) {
295         return totalSupply_;
296     }
297 
298     /**
299     * @dev Transfer token for a specified address
300     * @param _to The address to transfer to.
301     * @param _value The amount to be transferred.
302     */
303     function transfer(address _to, uint256 _value) public returns (bool) {
304         require(_to != address(0));
305         require(_value <= balances[msg.sender]);
306 
307         balances[msg.sender] = balances[msg.sender].sub(_value);
308         balances[_to] = balances[_to].add(_value);
309         emit Transfer(msg.sender, _to, _value);
310         return true;
311     }
312 
313     /**
314     * @dev Gets the balance of the specified address.
315     * @param _owner The address to query the the balance of.
316     * @return An uint256 representing the amount owned by the passed address.
317     */
318     function balanceOf(address _owner) public view returns (uint256) {
319         return balances[_owner];
320     }
321 
322 }
323 
324 
325 /**
326  * @title Standard ERC20 token
327  *
328  * @dev Implementation of the basic standard token.
329  * https://github.com/ethereum/EIPs/issues/20
330  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
331  */
332 contract StandardToken is ERC20, BasicToken {
333 
334     mapping (address => mapping (address => uint256)) internal allowed;
335 
336     /**
337      * @dev Transfer tokens from one address to another
338      * @param _from address The address which you want to send tokens from
339      * @param _to address The address which you want to transfer to
340      * @param _value uint256 the amount of tokens to be transferred
341      */
342     function transferFrom(
343         address _from,
344         address _to,
345         uint256 _value
346     )
347         public
348         returns (bool)
349     {
350         require(_to != address(0));
351         require(_value <= balances[_from]);
352         require(_value <= allowed[_from][msg.sender]);
353 
354         balances[_from] = balances[_from].sub(_value);
355         balances[_to] = balances[_to].add(_value);
356         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
357         emit Transfer(_from, _to, _value);
358         return true;
359     }
360 
361     /**
362     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
363     * Beware that changing an allowance with this method brings the risk that someone may use both the old
364     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
365     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
366     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
367     * @param _spender The address which will spend the funds.
368     * @param _value The amount of tokens to be spent.
369     */
370     function approve(address _spender, uint256 _value) public returns (bool) {
371         allowed[msg.sender][_spender] = _value;
372         emit Approval(msg.sender, _spender, _value);
373         return true;
374     }
375 
376     /**
377     * @dev Function to check the amount of tokens that an owner allowed to a spender.
378     * @param _owner address The address which owns the funds.
379     * @param _spender address The address which will spend the funds.
380     * @return A uint256 specifying the amount of tokens still available for the spender.
381     */
382     function allowance(
383         address _owner,
384         address _spender
385     )
386         public
387         view
388         returns (uint256)
389     {
390         return allowed[_owner][_spender];
391     }
392 
393     /**
394     * @dev Increase the amount of tokens that an owner allowed to a spender.
395     * approve should be called when allowed[_spender] == 0. To increment
396     * allowed value is better to use this function to avoid 2 calls (and wait until
397     * the first transaction is mined)
398     * From MonolithDAO Token.sol
399     * @param _spender The address which will spend the funds.
400     * @param _addedValue The amount of tokens to increase the allowance by.
401     */
402     function increaseApproval(
403         address _spender,
404         uint256 _addedValue
405     )
406         public
407         returns (bool)
408     {
409         allowed[msg.sender][_spender] = (
410         allowed[msg.sender][_spender].add(_addedValue));
411         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
412         return true;
413     }
414 
415     /**
416     * @dev Decrease the amount of tokens that an owner allowed to a spender.
417     * approve should be called when allowed[_spender] == 0. To decrement
418     * allowed value is better to use this function to avoid 2 calls (and wait until
419     * the first transaction is mined)
420     * From MonolithDAO Token.sol
421     * @param _spender The address which will spend the funds.
422     * @param _subtractedValue The amount of tokens to decrease the allowance by.
423     */
424     function decreaseApproval(
425         address _spender,
426         uint256 _subtractedValue
427     )
428         public
429         returns (bool)
430     {
431         uint256 oldValue = allowed[msg.sender][_spender];
432         if (_subtractedValue > oldValue) {
433             allowed[msg.sender][_spender] = 0;
434         } else {
435             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
436         }
437         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
438         return true;
439     }
440 
441 }
442 
443 
444 /**
445  * @title Pausable token
446  * @dev StandardToken modified with pausable transfers.
447  **/
448 contract PausableToken is StandardToken, Pausable {
449 
450     function transfer(
451         address _to,
452         uint256 _value
453     )
454         public
455         whenNotPaused
456         returns (bool)
457     {
458         return super.transfer(_to, _value);
459     }
460 
461     function transferFrom(
462         address _from,
463         address _to,
464         uint256 _value
465     )
466         public
467         whenNotPaused
468         returns (bool)
469     {
470         return super.transferFrom(_from, _to, _value);
471     }
472 
473     function approve(
474         address _spender,
475         uint256 _value
476     )
477         public
478         whenNotPaused
479         returns (bool)
480     {
481         return super.approve(_spender, _value);
482     }
483 
484     function increaseApproval(
485         address _spender,
486         uint256 _addedValue
487     )
488         public
489         whenNotPaused
490         returns (bool success)
491     {
492         return super.increaseApproval(_spender, _addedValue);
493     }
494 
495     function decreaseApproval(
496         address _spender,
497         uint256 _subtractedValue
498     )
499         public
500         whenNotPaused
501         returns (bool success)
502     {
503         return super.decreaseApproval(_spender, _subtractedValue);
504     }
505 }
506 
507 
508 /**
509  * @title Mintable token
510  * @dev Simple ERC20 Token example, with mintable token creation
511  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
512  */
513 contract MintableToken is PausableToken {
514     event Mint(address indexed to, uint256 amount);
515     event MintFinished();
516 
517     bool public mintingFinished = false;
518 
519     modifier canMint() {
520         require(!mintingFinished);
521         _;
522     }
523 
524     /**
525      * @dev Function to mint tokens
526      * @param _to The address that will receive the minted tokens.
527      * @param _amount The amount of tokens to mint.
528      * @return A boolean that indicates if the operation was successful.
529      */
530     function mint(
531         address _to,
532         uint256 _amount
533     )
534         public
535         onlyManager
536         canMint
537         returns (bool)
538     {
539         totalSupply_ = totalSupply_.add(_amount);
540         balances[_to] = balances[_to].add(_amount);
541         emit Mint(_to, _amount);
542         emit Transfer(address(0), _to, _amount);
543         return true;
544     }
545 
546   /**
547    * @dev Function to stop minting new tokens.
548    * @return True if the operation was successful.
549    */
550     function finishMinting() public onlyOwner canMint  returns (bool) {
551         mintingFinished = true;
552         emit MintFinished();
553         return true;
554     }
555 }
556 
557 
558 /**
559  * @title SimpleToken
560  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
561  * Note they can later distribute these tokens as they wish using `transfer` and other
562  * `StandardToken` functions.
563  */
564 contract BeamToken is MintableToken {
565 
566     string public constant name = "Beams"; // solium-disable-line uppercase
567     string public constant symbol = "BEAM"; // solBeamCrowdsaleContractium-disable-line uppercase
568     uint8 public constant decimals = 18; // solium-disable-line uppercase
569 
570     mapping (address => bool) public isLocked;
571 
572     uint256 public constant INITIAL_SUPPLY = 0;
573 
574     constructor() public {
575         totalSupply_ = INITIAL_SUPPLY;
576     }
577 
578     function setLock(address _who, bool _lock) public onlyOwner {
579         require(isLocked[_who] != _lock);
580         isLocked[_who] = _lock;
581     }
582 
583     /**
584      * @dev Modifier to make a function callable only when the caller is not in locklist.
585      */
586     modifier whenNotLocked() {
587         require(!isLocked[msg.sender]);
588         _;
589     }
590 
591     function transfer(
592         address _to,
593         uint256 _value
594     )
595         public
596         whenNotLocked
597         returns (bool)
598     {
599         return super.transfer(_to, _value);
600     }
601 
602     function transferFrom(
603         address _from,
604         address _to,
605         uint256 _value
606     )
607         public
608         whenNotLocked
609         returns (bool)
610     {
611         return super.transferFrom(_from, _to, _value);
612     }
613 
614     function approve(
615         address _spender,
616         uint256 _value
617     )
618         public
619         whenNotLocked
620         returns (bool)
621     {
622         return super.approve(_spender, _value);
623     }
624 
625     function increaseApproval(
626         address _spender,
627         uint256 _addedValue
628     )
629         public
630         whenNotLocked
631         returns (bool success)
632     {
633         return super.increaseApproval(_spender, _addedValue);
634     }
635 
636     function decreaseApproval(
637         address _spender,
638         uint256 _subtractedValue
639     )
640         public
641         whenNotLocked
642         returns (bool success)
643     {
644         return super.decreaseApproval(_spender, _subtractedValue);
645     }
646 }