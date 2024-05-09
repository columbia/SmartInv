1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two numbers, truncating the quotient.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     /**
30     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address public owner;
55 
56     event onOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60      * account.
61      */
62     function Ownable() public {
63         owner = msg.sender;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75      * @dev Allows the current owner to transfer control of the contract to a newOwner.
76      * @param newOwner The address to transfer ownership to.
77      */
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0));
80         emit onOwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82     }
83 }
84 
85 /**
86  * @title Lockable
87  * @dev Base contract which allows to implement an emergency stop mechanism.
88  */
89 contract Lockable is Ownable {
90     event onLock();
91 
92     bool public locked = false;
93     /**
94      * @dev Modifier to make a function callable only when the contract is not locked.
95      */
96     modifier whenNotLocked() {
97         require(!locked);
98         _;
99     }
100 
101     /**
102      * @dev called by the owner to set lock state, triggers stop/continue state
103      */
104     function setLock(bool _value) onlyOwner public {
105         locked = _value;
106         emit onLock();
107     }
108 }
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116     function totalSupply() public view returns (uint256);
117 
118     function actualCap() public view returns (uint256);
119 
120     function balanceOf(address who) public view returns (uint256);
121 
122     function transfer(address to, uint256 value) public returns (bool);
123 
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133     function allowance(address owner, address spender) public view returns (uint256);
134 
135     function transferFrom(address from, address to, uint256 value) public returns (bool);
136 
137     function approve(address spender, uint256 value) public returns (bool);
138 
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic, Lockable {
147     using SafeMath for uint256;
148 
149     uint8 public constant decimals = 18; // solium-disable-line uppercase
150     mapping(address => uint256) balances;
151     uint256 totalSupply_;
152     uint256 actualCap_;
153 
154     /**
155      * @dev total number of tokens in existence
156      */
157     function totalSupply() public view returns (uint256) {
158         return totalSupply_;
159     }
160 
161     /**
162      * @dev actual CAP
163      */
164     function actualCap() public view returns (uint256) {
165         return actualCap_;
166     }
167 
168     /**
169      * @dev transfer token for a specified address
170      * @param _to The address to transfer to.
171      * @param _value The amount to be transferred.
172      */
173     function transfer(address _to, uint256 _value) public returns (bool) {
174         require(!locked || msg.sender == owner);
175         //owner can do even locked
176         require(_to != address(0));
177         require(_value <= balances[msg.sender]);
178         // SafeMath.sub will throw if there is not enough balance.
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         emit Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     /**
186     * @dev Gets the balance of the specified address.
187     * @param _owner The address to query the the balance of.
188     * @return An uint256 representing the amount owned by the passed address.
189     */
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balances[_owner];
192     }
193 
194 }
195 
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206     mapping(address => mapping(address => uint256)) internal allowed;
207 
208     /**
209      * @dev Transfer tokens from one address to another
210      * @param _from address The address which you want to send tokens from
211      * @param _to address The address which you want to transfer to
212      * @param _value uint256 the amount of tokens to be transferred
213      */
214     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215         require(!locked || msg.sender == owner);
216         require(_to != address(0));
217         require(_value <= balances[_from]);
218         require(_value <= allowed[_from][msg.sender]);
219         balances[_from] = balances[_from].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222         emit Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     /**
227      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228      *
229      * Beware that changing an allowance with this method brings the risk that someone may use both the old
230      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      * @param _spender The address which will spend the funds.
234      * @param _value The amount of tokens to be spent.
235      */
236     function approve(address _spender, uint256 _value) public returns (bool) {
237         require(!locked || msg.sender == owner);
238         allowed[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242 
243     /**
244      * @dev Function to check the amount of tokens that an owner allowed to a spender.
245      * @param _owner address The address which owns the funds.
246      * @param _spender address The address which will spend the funds.
247      * @return A uint256 specifying the amount of tokens still available for the spender.
248      */
249     function allowance(address _owner, address _spender) public view returns (uint256) {
250         return allowed[_owner][_spender];
251     }
252 
253     /**
254      * @dev Increase the amount of tokens that an owner allowed to a spender.
255      *
256      * approve should be called when allowed[_spender] == 0. To increment
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * @param _spender The address which will spend the funds.
261      * @param _addedValue The amount of tokens to increase the allowance by.
262      */
263     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
264         require(!locked || msg.sender == owner);
265         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270     /**
271      * @dev Decrease the amount of tokens that an owner allowed to a spender.
272      *
273      * approve should be called when allowed[_spender] == 0. To decrement
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * @param _spender The address which will spend the funds.
278      * @param _subtractedValue The amount of tokens to decrease the allowance by.
279      */
280     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
281         require(!locked || msg.sender == owner);
282         uint oldValue = allowed[msg.sender][_spender];
283         if (_subtractedValue > oldValue) {
284             allowed[msg.sender][_spender] = 0;
285         } else {
286             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287         }
288         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289         return true;
290     }
291 
292 }
293 
294 /**
295  * @title Mintable token
296  * @dev Simple ERC20 Token example, with mintable token creation
297  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
298  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
299  */
300 contract MintableToken is StandardToken {
301     event onMint(address indexed to, uint256 amount);
302     event onSetMintable();
303 
304     bool public mintable = true;
305 
306     modifier canMint() {
307         require(mintable);
308         _;
309     }
310 
311     /**
312      * @dev Function to mint tokens
313      * @param _to The address that will receive the minted tokens.
314      * @param _amount The amount of tokens to mint.
315      * @return A boolean that indicates if the operation was successful.
316      */
317     function mint(address _to, uint256 _amount) onlyOwner whenNotLocked canMint public returns (bool) {
318         totalSupply_ = totalSupply_.add(_amount);
319         balances[_to] = balances[_to].add(_amount);
320         emit onMint(_to, _amount);
321         emit Transfer(address(0), _to, _amount);
322         return true;
323     }
324 
325     /**
326      * @dev Function to stop/continue minting new tokens.
327      * @return True if the operation was successful.
328      */
329     function setMintable(bool _value) onlyOwner public returns (bool) {
330         mintable = _value;
331         emit onSetMintable();
332         return true;
333     }
334 }
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract BurnableToken is StandardToken {
341     event onBurn(address indexed burner, uint256 value);
342 
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param _value The amount of token to be burned.
346      */
347     function burn(uint256 _value) whenNotLocked public returns (bool)  {
348         require(_value <= balances[msg.sender]);
349         // no need to require value <= totalSupply, since that would imply the
350         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
351 
352         address burner = msg.sender;
353         balances[burner] = balances[burner].sub(_value);
354         totalSupply_ = totalSupply_.sub(_value);
355         actualCap_ = actualCap_.sub(_value);
356         emit onBurn(burner, _value);
357         emit Transfer(burner, address(0), _value);
358         return true;
359     }
360 }
361 
362 /**
363  * @title Dropable
364  * @dev Base contract which allows to implement air drop mechanism.
365  */
366 contract DropableToken is MintableToken {
367     event onSetDropable();
368     event onSetDropAmount();
369 
370     bool public dropable = false;
371     uint256 dropAmount_ = 100000 * (10 ** uint256(decimals)); // 0.00001% per drop
372 
373     /**
374      * @dev Modifier to make a function callable only when the contract is dropable.
375      */
376     modifier whenDropable() {
377         require(dropable);
378         _;
379     }
380     /**
381      * @dev called by the owner to set dropable
382      */
383     function setDropable(bool _value) onlyOwner public {
384         dropable = _value;
385         emit onSetDropable();
386     }
387 
388     /**
389     * @dev called by the owner to set default airdrop amount
390     */
391     function setDropAmount(uint256 _value) onlyOwner public {
392         dropAmount_ = _value;
393         emit onSetDropAmount();
394     }
395 
396     /**
397      * @dev called by anyone to get the drop amount
398      */
399     function getDropAmount() public view returns (uint256) {
400         return dropAmount_;
401     }
402 
403     /*batch airdrop functions*/
404     function airdropWithAmount(address [] _recipients, uint256 _value) onlyOwner canMint whenDropable external {
405         for (uint i = 0; i < _recipients.length; i++) {
406             address recipient = _recipients[i];
407             require(totalSupply_.add(_value) <= actualCap_);
408             mint(recipient, _value);
409         }
410     }
411 
412     function airdrop(address [] _recipients) onlyOwner canMint whenDropable external {
413         for (uint i = 0; i < _recipients.length; i++) {
414             address recipient = _recipients[i];
415             require(totalSupply_.add(dropAmount_) <= actualCap_);
416             mint(recipient, dropAmount_);
417         }
418     }
419 
420     /*get airdrop function*/
421     //one can get airdrop by themselves as long as they are willing to pay gas
422     function getAirdrop() whenNotLocked canMint whenDropable external returns (bool) {
423         require(totalSupply_.add(dropAmount_) <= actualCap_);
424         mint(msg.sender, dropAmount_);
425         return true;
426     }
427 }
428 
429 
430 /**
431  * @title Purchasable token
432  */
433 contract PurchasableToken is StandardToken {
434     event onPurchase(address indexed to, uint256 etherAmount, uint256 tokenAmount);
435     event onSetPurchasable();
436     event onSetTokenPrice();
437     event onWithdraw(address to, uint256 amount);
438 
439     bool public purchasable = true;
440     uint256 tokenPrice_ = 0.0000000001 ether;
441     uint256 etherAmount_;
442 
443     modifier canPurchase() {
444         require(purchasable);
445         _;
446     }
447 
448     /**
449      * @dev Function to purchase tokens
450      * @return A boolean that indicates if the operation was successful.
451      */
452     function purchase() whenNotLocked canPurchase public payable returns (bool) {
453         uint256 ethAmount = msg.value;
454         uint256 tokenAmount = ethAmount.div(tokenPrice_).mul(10 ** uint256(decimals));
455         require(totalSupply_.add(tokenAmount) <= actualCap_);
456         totalSupply_ = totalSupply_.add(tokenAmount);
457         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
458         etherAmount_ = etherAmount_.add(ethAmount);
459         emit onPurchase(msg.sender, ethAmount, tokenAmount);
460         emit Transfer(address(0), msg.sender, tokenAmount);
461         return true;
462     }
463 
464     /**
465      * @dev Function to stop/continue purchase new tokens.
466      * @return True if the operation was successful.
467      */
468     function setPurchasable(bool _value) onlyOwner public returns (bool) {
469         purchasable = _value;
470         emit onSetPurchasable();
471         return true;
472     }
473 
474     /**
475      * @dev called by the owner to set default airdrop amount
476      */
477     function setTokenPrice(uint256 _value) onlyOwner public {
478         tokenPrice_ = _value;
479         emit onSetTokenPrice();
480     }
481 
482     /**
483      * @dev called by anyone to get the token price for purchase
484      */
485     function getTokenPrice() public view returns (uint256) {
486         return tokenPrice_;
487     }
488 
489     /**
490      * Withdraw the amount of ethers from the contract if any
491      */
492     function withdraw(uint256 _amountOfEthers) onlyOwner public returns (bool){
493         address ownerAddress = msg.sender;
494         require(etherAmount_>=_amountOfEthers);
495         ownerAddress.transfer(_amountOfEthers);
496         etherAmount_ = etherAmount_.sub(_amountOfEthers);
497         emit onWithdraw(ownerAddress, _amountOfEthers);
498         return true;
499     }
500 }
501 
502 contract RBTToken is DropableToken, BurnableToken, PurchasableToken {
503     string public name = "RBT - a flexible token which can be rebranded";
504     string public symbol = "RBT";
505     string public version = '1.0';
506     string public desc = "";
507     uint256 constant CAP = 100000000000 * (10 ** uint256(decimals)); // total
508     uint256 constant STARTUP = 100000000 * (10 ** uint256(decimals)); // 0.1% startup
509 
510     /**
511      * @dev Constructor that gives msg.sender the STARTUP tokens.
512      */
513     function RBTToken() public {
514         mint(msg.sender, STARTUP);
515         actualCap_ = CAP;
516     }
517 
518     // ------------------------------------------------------------------------
519     // Don't accept ETH, fallback function
520     // ------------------------------------------------------------------------
521     function() public payable {
522         revert();
523     }
524 
525     /**
526      * If we want to rebrand, we can.
527      */
528     function setName(string _name) onlyOwner public {
529         name = _name;
530     }
531 
532     /**
533      * If we want to rebrand, we can.
534      */
535     function setSymbol(string _symbol) onlyOwner public {
536         symbol = _symbol;
537     }
538 
539     /**
540      * If we want to rebrand, we can.
541      */
542     function setVersion(string _version) onlyOwner public {
543         version = _version;
544     }
545 
546     /**
547      * If we want to rebrand, we can.
548      */
549     function setDesc(string _desc) onlyOwner public {
550         desc = _desc;
551     }
552 
553     /* Approves and then calls the receiving contract */
554     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
555         if (approve(_spender, _value)) {
556             //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
557             //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
558             //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
559             if (!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {revert();}
560             return true;
561         }
562     }
563 
564     /* Approves and then calls the contract code*/
565     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
566         if (approve(_spender, _value)) {
567             //Call the contract code
568             if (!_spender.call(_extraData)) {revert();}
569             return true;
570         }
571     }
572 
573 }