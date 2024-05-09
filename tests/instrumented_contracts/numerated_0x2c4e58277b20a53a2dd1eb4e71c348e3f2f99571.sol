1 pragma solidity 0.5.2;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 contract Ownable {
51     address payable public owner;
52 
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57     /**
58      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59      * account.
60      */
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function transferOwnership(address payable newOwner) external onlyOwner {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract SYNCContract is Ownable
87 {
88 
89 using SafeMath for uint256;
90     mapping(address => uint256) internal balances;
91 
92     mapping(address => uint256) internal totalBalances;
93     
94     mapping (address => mapping (address => uint256)) internal allowed;
95 
96     mapping (address => uint256) internal totalAllowed;
97 
98     /**
99      * @dev total number of tokens in existence
100     */
101     uint256 internal totSupply;
102 
103     /**
104      * @dev Gets the total supply of tokens currently in circulation.
105      * @return An uint256 representing the amount of tokens already minted.
106     */
107     function totalSupply() view public returns(uint256)
108     {
109         return totSupply;
110     }
111     
112     /**
113      * @dev Gets the sum of all tokens that this address allowed others spend on its expence. 
114      * Basically a sum of all allowances from this address
115      * @param _owner The address to query the allowances of.
116      * @return An uint256 representing the sum of all allowances of the passed address.
117     */
118     function getTotalAllowed(address _owner) view public returns(uint256)
119     {
120         return totalAllowed[_owner];
121     }
122 
123     /**
124      * @dev Sets the sum of all tokens that this address allowed others spend on its expence. 
125      * @param _owner The address to query the allowances of.
126      * @param _newValue The amount of tokens allowed by the _owner address.
127     */
128     function setTotalAllowed(address _owner, uint256 _newValue) internal
129     {
130         totalAllowed[_owner]=_newValue;
131     }
132 
133     /**
134     * @dev Sets the total supply of tokens currently in circulation. 
135     * Callable only internally and only when total supply should be changed for consistency
136     * @param _newValue An uint256 representing the amount of tokens already minted.
137     */
138 
139     function setTotalSupply(uint256 _newValue) internal
140     {
141         totSupply=_newValue;
142     }
143 
144 
145     /**
146      * @dev Gets the balance of the specified address.
147      * @param _owner The address to query the the balance of.
148      * @return An uint256 representing the amount owned by the passed address.
149     */
150 
151     function balanceOf(address _owner) view public returns(uint256)
152     {
153         return balances[_owner];
154     }
155 
156     /**
157      * @dev Sets the balance of the specified address. 
158      * Only callable from inside smart contract by method updateInvestorTokenBalance, which is callable only by contract owner
159      * @param _investor The address to query the the balance of.
160      * @return An uint256 representing the amount owned by the passed address.
161     */
162     function setBalanceOf(address _investor, uint256 _newValue) internal
163     {
164         require(_investor!=0x0000000000000000000000000000000000000000);
165         balances[_investor]=_newValue;
166     }
167 
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param _owner address The address which owns the funds.
172      * @param _spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175 
176     function allowance(address _owner, address _spender) view public returns(uint256)
177     {
178         require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());
179         return allowed[_owner][_spender];
180     }
181 
182     /**
183      * @dev Set the amount of tokens that an owner allowed to a spender.
184      * @param _owner address The address which owns the funds.
185      * @param _spender address The address which will spend the funds.
186      * @param _newValue uint256 The amount of tokens allowed to spend by _spender on _owsner's expence.
187      */
188     function setAllowance(address _owner, address _spender, uint256 _newValue) internal
189     {
190         require(_spender!=0x0000000000000000000000000000000000000000);
191         uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);
192         require(newTotal <= balanceOf(_owner));
193         allowed[_owner][_spender]=_newValue;
194         setTotalAllowed(_owner,newTotal);
195     }
196 
197 
198    constructor() public
199     {
200         // require(_rate > 0);
201     //    require(_cap > 0);
202         //rate=_rate;
203         cap = 48000000*1000000000000000000;
204     }
205 
206     
207     bytes32 public constant name = "SYNCoin";
208 
209     bytes4 public constant symbol = "SYNC";
210 
211     uint8 public constant decimals = 18;
212 
213     uint256 public cap;
214 
215     bool public mintingFinished;
216 
217     /** @dev Fires on every transportation of tokens, both minting and transfer
218      *  @param _from address The address from which transfer has been initialized.
219      *  @param _to address The address to where the tokens are headed.
220      *  @param value uint256 The amount of tokens transferred
221      */
222     event Transfer(address indexed _from, address indexed _to, uint256 value);
223 
224     /** @dev Fires when owner allows spender to spend value of tokens on their(owner's) expence
225      *  @param _owner address The address from which allowance has been initialized.
226      *  @param _spender address The address who was allowed to spend tokens on owner's expence.
227      *  @param value uint256 The amount of tokens allowed for spending
228      */
229     event Approval(address indexed _owner, address indexed _spender, uint256 value);
230 
231     /** @dev Fires on every creation of new tokens
232      *  @param _to address The owner address of new tokens.
233      *  @param amount uint256 The amount of tokens created
234      */
235     event Mint(address indexed _to, uint256 amount);
236 
237     /** @dev fires when minting process is complete and no new tokens can be minted
238     */
239     event MintFinished();
240 
241     // /** @dev Fires on every destruction of existing tokens
242     //  *  @param to address The owner address of tokens burned.
243     //  *  @param value uint256 The amount of tokens destroyed
244     //  */
245     // event Burn(address indexed _owner, uint256 _value);
246 
247     /** @dev Check if tokens are no more mintable
248     */
249     modifier canMint() {
250         require(!mintingFinished);
251         _;
252     }
253 
254     function getName() pure public returns(bytes32)
255     {
256         return name;
257     }
258 
259     function getSymbol() pure public returns(bytes4)
260     {
261         return symbol;
262     }
263 
264     function getTokenDecimals() pure public returns(uint256)
265     {
266         return decimals;
267     }
268     
269     function getMintingFinished() view public returns(bool)
270     {
271         return mintingFinished;
272     }
273 
274     /** @dev Get maximum amount of how many tokens can be minted by this contract
275      * @return uint256 The amount of how many tokens can be minted by this contract
276     */
277     function getTokenCap() view public returns(uint256)
278     {
279         return cap;
280     }
281 
282     /** @dev Set maximum amount of how many tokens can be minted by this contract
283     */
284     function setTokenCap(uint256 _newCap) external onlyOwner
285     {
286         cap=_newCap;
287     }
288 
289     /** @dev Set the balance of _investor as _newValue. Only usable by contract owner
290      * @param _investor address The address whose balance is updated
291      * @param _newValue uint256. The new token balance of _investor 
292     */
293     function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external
294     {
295         setTokens(_investor,_newValue);
296     }
297 
298     /**
299      * @dev transfer token for a specified address
300      * @param _to The address to transfer to.
301      * @param _value The amount to be transferred.
302     */
303 
304     function transfer(address _to, uint256 _value) external{
305         require(msg.sender!=_to);
306         require(_value <= balanceOf(msg.sender));
307 
308         // SafeMath.sub will throw if there is not enough balance.
309         setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
310         setBalanceOf(_to, balanceOf(_to).add(_value));
311 
312         emit Transfer(msg.sender, _to, _value);
313     }
314 
315     /**
316      * @dev Transfer tokens from one address to another
317      * @param _from address The address which you want to send tokens from
318      * @param _to address The address which you want to transfer to
319      * @param _value uint256 the amount of tokens to be transferred
320      */
321     function transferFrom(address _from, address _to, uint256 _value) external {
322         require(_value <= balanceOf(_from));
323         require(_value <= allowance(_from,_to));
324         setBalanceOf(_from, balanceOf(_from).sub(_value));
325         setBalanceOf(_to, balanceOf(_to).add(_value));
326         setAllowance(_from,_to,allowance(_from,_to).sub(_value));
327         emit Transfer(_from, _to, _value);
328     }
329 
330     /**
331  * @dev Approve the passed address to spend the specified amount of tokens on expence of msg.sender.
332  *
333  * Beware that changing an allowance with this method brings the risk that someone may use both the old
334  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
335  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
336  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337  * @param _owner The address of the owner which allows tokens to a spender
338  * @param _spender The address which will spend the funds.
339  * @param _value The amount of tokens to be spent.
340  */
341     function approve(address _owner,address _spender, uint256 _value) external {
342         require(msg.sender ==_owner);
343         setAllowance(msg.sender,_spender, _value);
344         emit Approval(msg.sender, _spender, _value);
345     }
346 
347 
348     /**
349      * @dev Increase the amount of tokens that an owner allowed to a spender.
350      *
351      * approve should be called when allowed[_spender] == 0. To increment
352      * allowed value is better to use this function to avoid 2 calls (and wait until
353      * the first transaction is mined)
354      * From MonolithDAO Token.sol
355      * @param _owner The address of the owner which allows tokens to a spender
356      * @param _spender The address which will spend the funds.
357      * @param _addedValue The amount of tokens to increase the allowance by.
358      */
359     function increaseApproval(address _owner, address _spender, uint _addedValue) external{
360         require(msg.sender==_owner);
361         setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));
362         emit Approval(_owner, _spender, allowance(_owner,_spender));
363     }
364 
365     /**
366      * @dev Decrease the amount of tokens that an owner allowed to a spender.
367      *
368      * approve should be called when allowed[_spender] == 0. To decrement
369      * allowed value is better to use this function to avoid 2 calls (and wait until
370      * the first transaction is mined)
371      * From MonolithDAO Token.sol
372      * @param _owner The address of the owner which allows tokens to a spender
373      * @param _spender The address which will spend the funds.
374      * @param _subtractedValue The amount of tokens to decrease the allowance by.
375      */
376     function decreaseApproval(address _owner,address _spender, uint _subtractedValue) external{
377         require(msg.sender==_owner);
378 
379         uint oldValue = allowance(_owner,_spender);
380         if (_subtractedValue > oldValue) {
381             setAllowance(_owner,_spender, 0);
382         } else {
383             setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));
384         }
385         emit Approval(_owner, _spender, allowance(_owner,_spender));
386     }
387 
388     /**
389      * @dev Function to mint tokens
390      * @param _to The address that will receive the minted tokens.
391      * @param _amount The amount of tokens to mint.
392      * @return A boolean that indicates if the operation was successful.
393      */
394 
395 
396     function mint(address _to, uint256 _amount) canMint internal{
397         require(totalSupply().add(_amount) <= getTokenCap());
398         setTotalSupply(totalSupply().add(_amount));
399         setBalanceOf(_to, balanceOf(_to).add(_amount));
400         emit Mint(_to, _amount);
401         emit Transfer(address(0), _to, _amount);
402     }
403     
404     /**
405      * @dev Changes balance of _to to _amount, also increments or decrements total token supply depending on whether balance is increased or decreased
406      * @param _to address The address which token balance is updated
407      * @param _amount uint256 The new balance
408     */
409     function setTokens(address _to, uint256 _amount) canMint internal{
410         if(_amount > balanceOf(_to)){
411             uint256 diff = _amount.sub(balanceOf(_to));
412             require( totalSupply().add(diff) <= getTokenCap());
413             setTotalSupply(totalSupply().add(diff));
414             setBalanceOf(_to, _amount);
415         }else{
416             uint256 diff = balanceOf(_to).sub(_amount);
417             setTotalSupply(totalSupply().sub(diff));
418             setBalanceOf(_to, _amount);
419         }
420         emit Transfer(address(0), _to, _amount);
421     }    
422 
423     /**
424      * @dev Function to stop minting new tokens.
425      * @return True if the operation was successful.
426      */
427     function finishMinting() canMint onlyOwner external{
428         emit MintFinished();
429     }
430 
431     //Crowdsale
432     
433     // how many token units a buyer gets per wei
434     //uint256 internal rate;
435 
436     // amount of raised money in wei
437     //uint256 internal weiRaised;
438     
439     /**
440      * event for token purchase logging
441      * @param _beneficiary who got the tokens
442      * @param value uint256 The amount of weis paid for purchase
443      * @param amount uint256 The amount of tokens purchased
444      */
445     //event TokenPurchase(address indexed _beneficiary, uint256 value, uint256 amount);
446 
447      /**
448      * event for when current balance of smart contract is emptied by contract owner
449      * @param amount uint  The amount of wei withdrawn from contract balance
450      * @param timestamp uint The timestamp of withdrawal
451      */
452     //event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);
453 
454     /**
455      @dev Fallback function for when contract is simply sent ether. This calls buyTokens() method
456     */
457     // function () external payable {
458     //     buyTokens(msg.sender);
459     // }
460 
461     /**
462      * @dev Just a getter for token rate
463      * @return uint256 Current token rate stored in this contract and by which new tokens are minted
464     */
465     // function getTokenRate() view public returns(uint256)
466     // {
467     //     return rate;
468     // }
469 
470     /**
471      * @dev Setter for token rate. Callable by contract owner only
472      * @param _newRate uint256 New token rate stored in this contract
473     */
474     // function setTokenRate(uint256 _newRate) external onlyOwner
475     // {
476     //     rate = _newRate;
477     // }
478 
479     /**
480      * @dev Returns how much wei was ever received by this smart contract
481     */
482     // function getWeiRaised() view external returns(uint256)
483     // {
484     //     return weiRaised;
485     // }
486 
487     /**
488      * @dev low level token purchase function. Can be called from fallback function or directly
489      * @param _buyer address The address which will receive bought tokens
490     */
491     // function buyTokens(address _buyer) public payable{
492     //     require(msg.value > 0);
493     //     uint256 weiAmount = msg.value;
494 
495     //     // calculate token amount to be created
496     //     uint256 tokens = getTokenAmount(weiAmount);
497     //     require(validPurchase(tokens));
498 
499     //     // update state
500     //     weiRaised = weiRaised.add(weiAmount);
501     //     mint(_buyer, tokens);
502     //     emit TokenPurchase(_buyer, weiAmount, tokens);
503     // }
504 
505     /**
506      * @dev Get how many tokens can be received for this amount of wei.
507      * @param weiAmount uint256 The amount of wei
508      * @return uint256 How many tokens to be bought for weiAmount
509     */
510     // function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
511     //     return weiAmount.div(getTokenRate());
512     // }
513 
514     /**
515      * @dev Function for smart contract owner to withdraw all wei from contract's balance
516     */
517     // function withdrawInvestments() external onlyOwner{
518     //     uint  amount = address(this).balance;
519     //     getOwner().transfer(amount * 1 wei);
520     //     emit InvestmentsWithdrawn(amount, block.timestamp);
521     // }
522 
523     /**
524      * @dev Get current balance of smart contract in wei. Callable only by contract owner
525      * @return uint256 Current contract balance if wei
526     */
527     
528     // function getCurrentInvestments() view external onlyOwner returns(uint256)
529     // {
530     //     return address(this).balance;
531     // }
532 
533     /**
534      * @dev Get the address of owner of this smart contract
535      * @return address
536     */
537     function getOwner() view internal returns(address payable)
538     {
539         return owner;
540     }
541 
542     /**
543      * @return true if the transaction can buy tokens
544     */ 
545     // function validPurchase(uint256 tokensAmount) internal pure returns (bool) {
546     //     bool nonZeroPurchase = tokensAmount != 0;
547     //     return nonZeroPurchase;
548     // }
549     function destroy() external onlyOwner{
550         selfdestruct(getOwner());
551     }
552 }