1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-13
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (_a == 0) {
21             return 0;
22         }
23 
24         uint256 c = _a * _b;
25         require(c / _a == _b);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34         // require(_b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = _a / _b;
36         // require(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45         require(_b <= _a);
46         uint256 c = _a - _b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two numbers, throws on overflow.
53     */
54     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
55         uint256 c = _a + _b;
56         require(c >= _a);
57 
58         return c;
59     }
60 }
61 
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69     address public owner;
70 
71     event OwnershipRenounced(address indexed previousOwner);
72     event OwnershipTransferred(
73         address indexed previousOwner,
74         address indexed newOwner
75     );
76 
77     /**
78     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79     * account.
80     */
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     /**
86     * @dev Throws if called by any account other than the owner.
87     */
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94     * @dev Allows the current owner to relinquish control of the contract.
95     * @notice Renouncing to ownership will leave the contract without an owner.
96     * It will not be possible to call the functions with the `onlyOwner`
97     * modifier anymore.
98     */
99     function renounceOwnership() public onlyOwner {
100         emit OwnershipRenounced(owner);
101         owner = address(0);
102     }
103 
104     /**
105     * @dev Allows the current owner to transfer control of the contract to a newOwner.
106     * @param _newOwner The address to transfer ownership to.
107     */
108     function transferOwnership(address _newOwner) public onlyOwner {
109         _transferOwnership(_newOwner);
110     }
111 
112     /**
113     * @dev Transfers control of the contract to a newOwner.
114     * @param _newOwner The address to transfer ownership to.
115     */
116     function _transferOwnership(address _newOwner) internal {
117         require(_newOwner != address(0));
118         emit OwnershipTransferred(owner, _newOwner);
119         owner = _newOwner;
120     }
121 }
122 
123 
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is Ownable {
129     event Pause();
130     event Unpause();
131 
132     bool public paused = false;
133 
134     /**
135     * @dev Modifier to make a function callable only when the contract is not paused.
136     */
137     modifier whenNotPaused() {
138         require(!paused);
139         _;
140     }
141 
142     /**
143     * @dev Modifier to make a function callable only when the contract is paused.
144     */
145     modifier whenPaused() {
146         require(paused);
147         _;
148     }
149 
150     /**
151     * @dev called by the owner to pause, triggers stopped state
152     */
153     function pause() public onlyOwner whenNotPaused {
154         paused = true;
155         emit Pause();
156     }
157 
158     /**
159     * @dev called by the owner to unpause, returns to normal state
160     */
161     function unpause() public onlyOwner whenPaused {
162         paused = false;
163         emit Unpause();
164     }
165 }
166 
167 
168 /**
169 * @title ERC20 interface
170 * @dev see https://github.com/ethereum/EIPs/issues/20
171 */
172 contract ERC20 {
173     function totalSupply() public view returns (uint256);
174 
175     function balanceOf(address _who) public view returns (uint256);
176 
177     function allowance(address _owner, address _spender)
178         public view returns (uint256);
179 
180     function transfer(address _to, uint256 _value) public returns (bool);
181 
182     function approve(address _spender, uint256 _value)
183         public returns (bool);
184 
185     function transferFrom(address _from, address _to, uint256 _value)
186         public returns (bool);
187 
188     event Transfer(
189         address indexed from,
190         address indexed to,
191         uint256 value
192     );
193 
194     event Approval(
195         address indexed owner,
196         address indexed spender,
197         uint256 value
198     );
199 }
200 
201 /**
202 * @title Standard ERC20 token
203 *
204 * @dev Implementation of the basic standard token.
205 * https://github.com/ethereum/EIPs/issues/20
206 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207 */
208 contract StandardToken is ERC20 {
209     using SafeMath for uint256;
210 
211     mapping(address => uint256) balances;
212 
213     mapping (address => mapping (address => uint256)) internal allowed;
214 
215     uint256 totalSupply_;
216 
217     /**
218     * @dev Total number of tokens in existence
219     */
220     function totalSupply() public view returns (uint256) {
221         return totalSupply_;
222     }
223 
224     /**
225     * @dev Gets the balance of the specified address.
226     * @param _owner The address to query the the balance of.
227     * @return An uint256 representing the amount owned by the passed address.
228     */
229     function balanceOf(address _owner) public view returns (uint256) {
230         return balances[_owner];
231     }
232 
233     /**
234     * @dev Function to check the amount of tokens that an owner allowed to a spender.
235     * @param _owner address The address which owns the funds.
236     * @param _spender address The address which will spend the funds.
237     * @return A uint256 specifying the amount of tokens still available for the spender.
238     */
239     function allowance(
240         address _owner,
241         address _spender
242     )
243         public
244         view
245         returns (uint256)
246     {
247         return allowed[_owner][_spender];
248     }
249 
250     /**
251     * @dev Transfer token for a specified address
252     * @param _to The address to transfer to.
253     * @param _value The amount to be transferred.
254     */
255     function transfer(address _to, uint256 _value) public returns (bool) {
256         require(_value <= balances[msg.sender]);
257         require(_to != address(0));
258 
259         balances[msg.sender] = balances[msg.sender].sub(_value);
260         balances[_to] = balances[_to].add(_value);
261         emit Transfer(msg.sender, _to, _value);
262         return true;
263     }
264 
265     /**
266     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267     * Beware that changing an allowance with this method brings the risk that someone may use both the old
268     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
269     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271     * @param _spender The address which will spend the funds.
272     * @param _value The amount of tokens to be spent.
273     */
274     function approve(address _spender, uint256 _value) public returns (bool) {
275         allowed[msg.sender][_spender] = _value;
276         emit Approval(msg.sender, _spender, _value);
277         return true;
278     }
279 
280     /**
281     * @dev Transfer tokens from one address to another
282     * @param _from address The address which you want to send tokens from
283     * @param _to address The address which you want to transfer to
284     * @param _value uint256 the amount of tokens to be transferred
285     */
286     function transferFrom(
287         address _from,
288         address _to,
289         uint256 _value
290     )
291         public
292         returns (bool)
293     {
294         require(_value <= balances[_from]);
295         require(_value <= allowed[_from][msg.sender]);
296         require(_to != address(0));
297 
298         balances[_from] = balances[_from].sub(_value);
299         balances[_to] = balances[_to].add(_value);
300         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
301         emit Transfer(_from, _to, _value);
302         return true;
303     }
304 
305     /**
306     * @dev Increase the amount of tokens that an owner allowed to a spender.
307     * approve should be called when allowed[_spender] == 0. To increment
308     * allowed value is better to use this function to avoid 2 calls (and wait until
309     * the first transaction is mined)
310     * From MonolithDAO Token.sol
311     * @param _spender The address which will spend the funds.
312     * @param _addedValue The amount of tokens to increase the allowance by.
313     */
314     function increaseApproval(
315         address _spender,
316         uint256 _addedValue
317     )
318         public
319         returns (bool)
320     {
321         allowed[msg.sender][_spender] = (
322         allowed[msg.sender][_spender].add(_addedValue));
323         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324         return true;
325     }
326 
327     /**
328     * @dev Decrease the amount of tokens that an owner allowed to a spender.
329     * approve should be called when allowed[_spender] == 0. To decrement
330     * allowed value is better to use this function to avoid 2 calls (and wait until
331     * the first transaction is mined)
332     * From MonolithDAO Token.sol
333     * @param _spender The address which will spend the funds.
334     * @param _subtractedValue The amount of tokens to decrease the allowance by.
335     */
336     function decreaseApproval(
337         address _spender,
338         uint256 _subtractedValue
339     )
340         public
341         returns (bool)
342     {
343         uint256 oldValue = allowed[msg.sender][_spender];
344         if (_subtractedValue >= oldValue) {
345             allowed[msg.sender][_spender] = 0;
346         } else {
347             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348         }
349         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350         return true;
351     }
352 
353 }
354 
355 
356 /**
357 * @title Pausable token
358 * @dev StandardToken modified with pausable transfers.
359 **/
360 contract PausableERC20Token is StandardToken, Pausable {
361 
362     function transfer(
363         address _to,
364         uint256 _value
365     )
366         public
367         whenNotPaused
368         returns (bool)
369     {
370         return super.transfer(_to, _value);
371     }
372 
373     function transferFrom(
374         address _from,
375         address _to,
376         uint256 _value
377     )
378         public
379         whenNotPaused
380         returns (bool)
381     {
382         return super.transferFrom(_from, _to, _value);
383     }
384 
385     function approve(
386         address _spender,
387         uint256 _value
388     )
389         public
390         whenNotPaused
391         returns (bool)
392     {
393         return super.approve(_spender, _value);
394     }
395 
396     function increaseApproval(
397         address _spender,
398         uint _addedValue
399     )
400         public
401         whenNotPaused
402         returns (bool success)
403     {
404         return super.increaseApproval(_spender, _addedValue);
405     }
406 
407     function decreaseApproval(
408         address _spender,
409         uint _subtractedValue
410     )
411         public
412         whenNotPaused
413         returns (bool success)
414     {
415         return super.decreaseApproval(_spender, _subtractedValue);
416     }
417 }
418 
419 
420 /**
421 * @title Burnable Pausable Token
422 * @dev Pausable Token that can be irreversibly burned (destroyed).
423 */
424 contract BurnablePausableERC20Token is PausableERC20Token {
425 
426     mapping (address => mapping (address => uint256)) internal allowedBurn;
427 
428     event Burn(address indexed burner, uint256 value);
429 
430     event ApprovalBurn(
431         address indexed owner,
432         address indexed spender,
433         uint256 value
434     );
435 
436     function allowanceBurn(
437         address _owner,
438         address _spender
439     )
440         public
441         view
442         returns (uint256)
443     {
444         return allowedBurn[_owner][_spender];
445     }
446 
447     function approveBurn(address _spender, uint256 _value)
448         public
449         whenNotPaused
450         returns (bool)
451     {
452         allowedBurn[msg.sender][_spender] = _value;
453         emit ApprovalBurn(msg.sender, _spender, _value);
454         return true;
455     }
456 
457     /**
458     * @dev Burns a specific amount of tokens.
459     * @param _value The amount of token to be burned.
460     */
461     function burn(
462         uint256 _value
463     ) 
464         public
465         whenNotPaused
466     {
467         _burn(msg.sender, _value);
468     }
469 
470     /**
471     * @dev Burns a specific amount of tokens from the target address and decrements allowance
472     * @param _from address The address which you want to send tokens from
473     * @param _value uint256 The amount of token to be burned
474     */
475     function burnFrom(
476         address _from, 
477         uint256 _value
478     ) 
479         public 
480         whenNotPaused
481     {
482         require(_value <= allowedBurn[_from][msg.sender]);
483         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
484         // this function needs to emit an event with the updated approval.
485         allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);
486         _burn(_from, _value);
487     }
488 
489     function _burn(
490         address _who, 
491         uint256 _value
492     ) 
493         internal 
494         whenNotPaused
495     {
496         require(_value <= balances[_who]);
497         // no need to require value <= totalSupply, since that would imply the
498         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
499 
500         balances[_who] = balances[_who].sub(_value);
501         totalSupply_ = totalSupply_.sub(_value);
502         emit Burn(_who, _value);
503         emit Transfer(_who, address(0), _value);
504     }
505 
506     function increaseBurnApproval(
507         address _spender,
508         uint256 _addedValue
509     )
510         public
511         whenNotPaused
512         returns (bool)
513     {
514         allowedBurn[msg.sender][_spender] = (
515         allowedBurn[msg.sender][_spender].add(_addedValue));
516         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
517         return true;
518     }
519 
520     function decreaseBurnApproval(
521         address _spender,
522         uint256 _subtractedValue
523     )
524         public
525         whenNotPaused
526         returns (bool)
527     {
528         uint256 oldValue = allowedBurn[msg.sender][_spender];
529         if (_subtractedValue >= oldValue) {
530             allowedBurn[msg.sender][_spender] = 0;
531         } else {
532             allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);
533         }
534         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
535         return true;
536     }
537 }
538 
539 contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {
540     mapping (address => bool) public frozenAccount;
541     event FrozenFunds(address target, bool frozen);
542 
543     function freezeAccount(
544         address target,
545         bool freeze
546     )
547         public
548         onlyOwner
549     {
550         frozenAccount[target] = freeze;
551         emit FrozenFunds(target, freeze);
552     }
553 
554     function transfer(
555         address _to,
556         uint256 _value
557     )
558         public
559         whenNotPaused
560         returns (bool)
561     {
562         require(!frozenAccount[msg.sender], "Sender account freezed");
563         require(!frozenAccount[_to], "Receiver account freezed");
564 
565         return super.transfer(_to, _value);
566     }
567 
568     function transferFrom(
569         address _from,
570         address _to,
571         uint256 _value
572     )
573         public
574         whenNotPaused
575         returns (bool)
576     {
577         require(!frozenAccount[msg.sender], "Spender account freezed");
578         require(!frozenAccount[_from], "Sender account freezed");
579         require(!frozenAccount[_to], "Receiver account freezed");
580 
581         return super.transferFrom(_from, _to, _value);
582     }
583 
584     function burn(
585         uint256 _value
586     ) 
587         public
588         whenNotPaused
589     {
590         require(!frozenAccount[msg.sender], "Sender account freezed");
591 
592         return super.burn(_value);
593     }
594 
595     function burnFrom(
596         address _from, 
597         uint256 _value
598     ) 
599         public 
600         whenNotPaused
601     {
602         require(!frozenAccount[msg.sender], "Spender account freezed");
603         require(!frozenAccount[_from], "Sender account freezed");
604 
605         return super.burnFrom(_from, _value);
606     }
607 }
608 
609 /**
610 * @title DDLV
611 * @dev Token that is ERC20 compatible, Pausableb, Burnable, Ownable with SafeMath.
612 */
613 contract DDLV is FreezableBurnablePausableERC20Token {
614 
615     /** Token Setting: You are free to change any of these
616     * @param name string The name of your token (can be not unique)
617     * @param symbol string The symbol of your token (can be not unique, can be more than three characters)
618     * @param decimals uint8 The accuracy decimals of your token (conventionally be 18)
619     * Read this to choose decimals: https://ethereum.stackexchange.com/questions/38704/why-most-erc-20-tokens-have-18-decimals
620     * @param INITIAL_SUPPLY uint256 The total supply of your token. Example default to be "10000". Change as you wish.
621     **/
622     string public constant name = "DDLV TOKEN";
623     string public constant symbol = "DDLV";
624     uint8 public constant decimals = 18;
625 
626     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
627 
628     /**
629     * @dev Constructor that gives msg.sender all of existing tokens.
630     * Literally put all the issued money in your pocket
631     */
632     constructor() public {
633         totalSupply_ = INITIAL_SUPPLY;
634         balances[msg.sender] = INITIAL_SUPPLY;
635         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
636     }
637 }