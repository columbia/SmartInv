1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13       // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14       // benefit is lost if 'b' is also tested.
15       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59 
60     event OwnershipRenounced(address indexed previousOwner);
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     address public owner;
64 
65     /**
66     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67     * account.
68     */
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * @dev Allows the current owner to relinquish control of the contract.
83      * @notice Renouncing to ownership will leave the contract without an owner.
84      * It will not be possible to call the functions with the `onlyOwner`
85      * modifier anymore.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipRenounced(owner);
89         owner = address(0);
90     }
91 
92     /**
93      * @dev Allows the current owner to transfer control of the contract to a newOwner.
94      * @param _newOwner The address to transfer ownership to.
95      */
96     function transferOwnership(address _newOwner) public onlyOwner {
97         require(_newOwner != address(0));
98         emit OwnershipTransferred(owner, _newOwner);
99         owner = _newOwner;
100     }
101 }
102 
103 /**
104  * @title Pausable
105  * @dev Base contract which allows children to implement an emergency stop mechanism.
106  */
107 contract Pausable is Ownable {
108     
109     event Pause();
110     event Unpause();
111 
112     bool public paused = false;
113 
114     /**
115      * @dev Modifier to make a function callable only when the contract is not paused.
116      */
117     modifier whenNotPaused() {
118         require(!paused);
119         _;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is paused.
124      */
125     modifier whenPaused() {
126         require(paused);
127         _;
128     }
129 
130     /**
131      * @dev called by the owner to pause, triggers stopped state
132      */
133     function pause() onlyOwner whenNotPaused public {
134         paused = true;
135         emit Pause();
136     }
137 
138     /**
139      * @dev called by the owner to unpause, returns to normal state
140      */
141     function unpause() onlyOwner whenPaused public {
142         paused = false;
143         emit Unpause();
144     }
145 }
146 
147 contract TokenRepository is Ownable {
148 
149     using SafeMath for uint256;
150 
151     // Name of the ERC-20 token.
152     string public name;
153 
154     // Symbol of the ERC-20 token.
155     string public symbol;
156 
157     // Total decimals of the ERC-20 token.
158     uint256 public decimals;
159 
160     // Total supply of the ERC-20 token.
161     uint256 public totalSupply;
162 
163     // Mapping to hold balances.
164     mapping(address => uint256) public balances;
165 
166     // Mapping to hold allowances.
167     mapping (address => mapping (address => uint256)) public allowed;
168 
169     /**
170     * @dev Sets the name of ERC-20 token.
171     * @param _name Name of the token to set.
172     */
173     function setName(string _name) public onlyOwner {
174         name = _name;
175     }
176 
177     /**
178     * @dev Sets the symbol of ERC-20 token.
179     * @param _symbol Symbol of the token to set.
180     */
181     function setSymbol(string _symbol) public onlyOwner {
182         symbol = _symbol;
183     }
184 
185     /**
186     * @dev Sets the total decimals of ERC-20 token.
187     * @param _decimals Total decimals of the token to set.
188     */
189     function setDecimals(uint256 _decimals) public onlyOwner {
190         decimals = _decimals;
191     }
192 
193     /**
194     * @dev Sets the total supply of ERC-20 token.
195     * @param _totalSupply Total supply of the token to set.
196     */
197     function setTotalSupply(uint256 _totalSupply) public onlyOwner {
198         totalSupply = _totalSupply;
199     }
200 
201     /**
202     * @dev Sets balance of the address.
203     * @param _owner Address to set the balance of.
204     * @param _value Value to set.
205     */
206     function setBalances(address _owner, uint256 _value) public onlyOwner {
207         balances[_owner] = _value;
208     }
209 
210     /**
211     * @dev Sets the value of tokens allowed to be spent.
212     * @param _owner Address owning the tokens.
213     * @param _spender Address allowed to spend the tokens.
214     * @param _value Value of tokens to be allowed to spend.
215     */
216     function setAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
217         allowed[_owner][_spender] = _value;
218     }
219 
220     /**
221     * @dev Mints new tokens.
222     * @param _owner Address to transfer new tokens to.
223     * @param _value Amount of tokens to be minted.
224     */
225     function mintTokens(address _owner, uint256 _value) public onlyOwner {
226         require(_value > totalSupply.add(_value), "");
227         
228         totalSupply = totalSupply.add(_value);
229         setBalances(_owner, _value);
230     }
231     
232     /**
233     * @dev Burns tokens and decreases the total supply.
234     * @param _value Amount of tokens to burn.
235     */
236     function burnTokens(uint256 _value) public onlyOwner {
237         require(_value <= balances[msg.sender]);
238 
239         totalSupply = totalSupply.sub(_value);
240         balances[msg.sender] = balances[msg.sender].sub(_value);
241     }
242 
243     /**
244     * @dev Increases the balance of the address.
245     * @param _owner Address to increase the balance of.
246     * @param _value Value to increase.
247     */
248     function increaseBalance(address _owner, uint256 _value) public onlyOwner {
249         balances[_owner] = balances[_owner].add(_value);
250     }
251 
252     /**
253     * @dev Increases the tokens allowed to be spent.
254     * @param _owner Address owning the tokens.
255     * @param _spender Address to increase the allowance of.
256     * @param _value Value to increase.
257     */
258     function increaseAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
259         allowed[_owner][_spender] = allowed[_owner][_spender].add(_value);
260     }
261 
262     /**
263     * @dev Decreases the balance of the address.
264     * @param _owner Address to decrease the balance of.
265     * @param _value Value to decrease.
266     */
267     function decreaseBalance(address _owner, uint256 _value) public onlyOwner {
268         balances[_owner] = balances[_owner].sub(_value);
269     }
270 
271     /**
272     * @dev Decreases the tokens allowed to be spent.
273     * @param _owner Address owning the tokens.
274     * @param _spender Address to decrease the allowance of.
275     * @param _value Value to decrease.
276     */
277     function decreaseAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
278         allowed[_owner][_spender] = allowed[_owner][_spender].sub(_value);
279     }
280 
281     /**
282     * @dev Transfers the balance from one address to another.
283     * @param _from Address to transfer the balance from.
284     * @param _to Address to transfer the balance to.
285     * @param _value Value to transfer.
286     */
287     function transferBalance(address _from, address _to, uint256 _value) public onlyOwner {
288         decreaseBalance(_from, _value);
289         increaseBalance(_to, _value);
290     }
291 }
292 
293 
294 contract ERC223Receiver {
295     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool);
296 }
297 
298 /**
299  * @title ERC223 interface
300  * @dev see https://github.com/ethereum/EIPs/issues/20
301  */
302 contract ERC223Interface {
303     event Transfer(address indexed from, address indexed to, uint256 value);
304     event Approval(address indexed owner, address indexed spender, uint256 value);
305     
306     function name() public view returns (string);
307     function symbol() public view returns (string);
308     function decimals() public view returns (uint256);
309     function totalSupply() public view returns (uint256);
310     function balanceOf(address _who) public view returns (uint256);
311     function allowance(address _owner, address _spender) public view returns (uint256);
312     function transfer(address _to, uint256 _value) public returns (bool);
313     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
314     function transfer(address _to, uint _value, bytes _data) public returns (bool);
315     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool);
316     function approve(address _spender, uint256 _value) public returns (bool);
317 }
318 
319 /**
320  * @title Standard ERC20 token.
321  *
322  * @dev Implementation of the basic standard token.
323  * https://github.com/ethereum/EIPs/issues/20
324  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
325  */
326 contract ERC223Token is ERC223Interface, Pausable {
327 
328     TokenRepository public tokenRepository;
329 
330     /**
331     * @dev Constructor function.
332     */
333     constructor() public {
334         tokenRepository = new TokenRepository();
335     }
336 
337     /**
338     * @dev Name of the token.
339     */
340     function name() public view returns (string) {
341         return tokenRepository.name();
342     }
343 
344     /**
345     * @dev Symbol of the token.
346     */
347     function symbol() public view returns (string) {
348         return tokenRepository.symbol();
349     }
350 
351     /**
352     * @dev Total decimals of tokens.
353     */
354     function decimals() public view returns (uint256) {
355         return tokenRepository.decimals();
356     }
357 
358     /**
359     * @dev Total number of tokens in existence.
360     */
361     function totalSupply() public view returns (uint256) {
362         return tokenRepository.totalSupply();
363     }
364 
365     /**
366     * @dev Gets the balance of the specified address.
367     * @param _owner The address to query the the balance of.
368     * @return An uint256 representing the amount owned by the passed address.
369     */
370     function balanceOf(address _owner) public view returns (uint256) {
371         return tokenRepository.balances(_owner);
372     }
373 
374     /**
375     * @dev Function to check the amount of tokens that an owner allowed to a spender.
376     * @param _owner address The address which owns the funds.
377     * @param _spender address The address which will spend the funds.
378     * @return A uint256 specifying the amount of tokens still available for the spender.
379     */
380     function allowance(address _owner, address _spender) public view returns (uint256) {
381         return tokenRepository.allowed(_owner, _spender);
382     }
383 
384     /**
385     * @dev Function to execute transfer of token to a specified address
386     * @param _to The address to transfer to.
387     * @param _value The amount to be transferred.
388     */
389     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
390         return transfer(_to, _value, new bytes(0));
391     }
392 
393     /**
394     * @dev Function to execute transfer of token from one address to another.
395     * @param _from address The address which you want to send tokens from.
396     * @param _to address The address which you want to transfer to.
397     * @param _value uint256 the amount of tokens to be transferred.
398     */
399     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
400         return transferFrom(_from, _to, _value, new bytes(0));
401     }
402 
403     /**
404     * @dev Internal function to execute transfer of token to a specified address
405     * @param _to The address to transfer to.
406     * @param _value The amount to be transferred.
407     * @param _data Data to be passed.
408     */
409     function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
410         //filtering if the target is a contract with bytecode inside it
411         if (!_transfer(_to, _value)) revert(); // do a normal token transfer
412         if (_isContract(_to)) return _contractFallback(msg.sender, _to, _value, _data);
413         return true;
414     }
415 
416     /**
417     * @dev Internal function to execute transfer of token from one address to another.
418     * @param _from address The address which you want to send tokens from.
419     * @param _to address The address which you want to transfer to.
420     * @param _value uint256 the amount of tokens to be transferred.
421     * @param _data Data to be passed.
422     */
423     function transferFrom(address _from, address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
424         if (!_transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
425         if (_isContract(_to)) return _contractFallback(_from, _to, _value, _data);
426         return true;
427     }
428     
429     /**
430     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
431     * Beware that changing an allowance with this method brings the risk that someone may use both the old
432     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
433     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
434     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
435     * @param _spender The address which will spend the funds.
436     * @param _value The amount of tokens to be spent.
437     */
438     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
439         tokenRepository.setAllowed(msg.sender, _spender, _value);
440         emit Approval(msg.sender, _spender, _value);
441         return true;
442     }
443 
444     /**
445     * @dev Increase the amount of tokens that an owner allowed to a spender.
446     * Approve should be called when allowed[_spender] == 0. To increment
447     * Allowed value is better to use this function to avoid 2 calls (and wait until
448     * the first transaction is mined).
449     * From MonolithDAO Token.sol
450     * @param _spender The address which will spend the funds.
451     * @param _value The amount of tokens to increase the allowance by.
452     */
453     function increaseApproval(address _spender, uint256 _value) public whenNotPaused returns (bool) {
454         tokenRepository.increaseAllowed(msg.sender, _spender, _value);
455         emit Approval(msg.sender, _spender, tokenRepository.allowed(msg.sender, _spender));
456         return true;
457     }
458 
459     /**
460     * @dev Decrease the amount of tokens that an owner allowed to a spender.
461     * Approve should be called when allowed[_spender] == 0. To decrement
462     * allowed value is better to use this function to avoid 2 calls (and wait until
463     * the first transaction is mined).
464     * From MonolithDAO Token.sol
465     * @param _spender The address which will spend the funds.
466     * @param _value The amount of tokens to decrease the allowance by.
467     */
468     function decreaseApproval(address _spender, uint256 _value) public whenNotPaused returns (bool) {
469         uint256 oldValue = tokenRepository.allowed(msg.sender, _spender);
470         if (_value >= oldValue) {
471             tokenRepository.setAllowed(msg.sender, _spender, 0);
472         } else {
473             tokenRepository.decreaseAllowed(msg.sender, _spender, _value);
474         }
475         emit Approval(msg.sender, _spender, tokenRepository.allowed(msg.sender, _spender));
476         return true;
477     }
478 
479     /**
480     * @dev Internal function to execute transfer of token to a specified address
481     * @param _to The address to transfer to.
482     * @param _value The amount to be transferred.
483     */
484     function _transfer(address _to, uint256 _value) internal returns (bool) {
485         require(_value <= tokenRepository.balances(msg.sender));
486         require(_to != address(0));
487 
488         tokenRepository.transferBalance(msg.sender, _to, _value);
489 
490         emit Transfer(msg.sender, _to, _value);
491         return true;
492     }
493 
494     /**
495     * @dev Internal function to execute transfer of token from one address to another.
496     * @param _from address The address which you want to send tokens from.
497     * @param _to address The address which you want to transfer to.
498     * @param _value uint256 the amount of tokens to be transferred.
499     */
500     function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
501         require(_value <= tokenRepository.balances(_from));
502         require(_value <= tokenRepository.allowed(_from, msg.sender));
503         require(_to != address(0));
504 
505         tokenRepository.transferBalance(_from, _to, _value);
506         tokenRepository.decreaseAllowed(_from, msg.sender, _value);
507 
508         emit Transfer(_from, _to, _value);
509         return true;
510     }
511 
512     /**
513     * @dev Private function that is called when target address is a contract.
514     * @param _from address The address which you want to send tokens from.
515     * @param _to address The address which you want to transfer to.
516     * @param _value uint256 the amount of tokens to be transferred.
517     * @param _data Data to be passed.
518     */
519     function _contractFallback(address _from, address _to, uint _value, bytes _data) private returns (bool) {
520         ERC223Receiver reciever = ERC223Receiver(_to);
521         return reciever.tokenFallback(msg.sender, _from, _value, _data);
522     }
523 
524     /**
525     * @dev Private function that differentiates between an external account and contract account.
526     * @param _address Address of contract/account.
527     */
528     function _isContract(address _address) private view returns (bool) {
529         // Retrieve the size of the code on target address, this needs assembly.
530         uint length;
531         assembly { length := extcodesize(_address) }
532         return length > 0;
533     }
534 }
535 
536 contract NAi is ERC223Token {
537 
538     constructor() public {
539         tokenRepository.setName("NAi");
540         tokenRepository.setSymbol("NAi");
541         tokenRepository.setDecimals(6);
542         tokenRepository.setTotalSupply(20000000 * 10 ** uint(tokenRepository.decimals()));
543 
544         tokenRepository.setBalances(msg.sender, tokenRepository.totalSupply());
545     }
546 
547     /**
548     * @dev Owner of the storage contract.
549     */
550     function storageOwner() public view returns(address) {
551         return tokenRepository.owner();
552     }
553     
554     /**
555     * @dev Burns tokens and decreases the total supply.
556     * @param _value Amount of tokens to burn.
557     */
558     function burnTokens(uint256 _value) public onlyOwner {
559         tokenRepository.burnTokens(_value);
560         emit Transfer(msg.sender, address(0), _value);
561     }
562 
563     /**
564     * @dev Transfers the ownership of storage contract.
565     * @param _newContract The address to transfer to.
566     */
567     function transferStorageOwnership(address _newContract) public onlyOwner {
568         tokenRepository.transferOwnership(_newContract);
569     }
570 
571     /**
572     * @dev Kills the contract and renders it useless.
573     * Can only be executed after transferring the ownership of storage.
574     */
575     function killContract() public onlyOwner {
576         require(storageOwner() != address(this));
577         selfdestruct(owner);
578     }
579 }