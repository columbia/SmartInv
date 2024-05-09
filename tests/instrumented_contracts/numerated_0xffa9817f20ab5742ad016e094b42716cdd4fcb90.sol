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
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182      * @dev Set the amount of tokens that an owner allowed to a spender.
183      * @param _owner address The address which owns the funds.
184      * @param _spender address The address which will spend the funds.
185      * @param _newValue uint256 The amount of tokens allowed to spend by _spender on _owsner's expence.
186      */
187     function setAllowance(address _owner, address _spender, uint256 _newValue) internal
188     {
189         require(_spender!=0x0000000000000000000000000000000000000000);
190         uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);
191         require(newTotal <= balanceOf(_owner));
192         allowed[_owner][_spender]=_newValue;
193         setTotalAllowed(_owner,newTotal);
194     }
195 
196 
197    constructor() public
198     {
199         // require(_rate > 0);
200     //    require(_cap > 0);
201         //rate=_rate;
202         cap = 48000000*1000000000000000000;
203     }
204 
205     
206     bytes32 public constant name = "SYNCoin";
207 
208     bytes4 public constant symbol = "SYNC";
209 
210     uint8 public constant decimals = 18;
211 
212     uint256 public cap;
213 
214     bool public mintingFinished;
215 
216     /** @dev Fires on every transportation of tokens, both minting and transfer
217      *  @param _from address The address from which transfer has been initialized.
218      *  @param _to address The address to where the tokens are headed.
219      *  @param value uint256 The amount of tokens transferred
220      */
221     event Transfer(address indexed _from, address indexed _to, uint256 value);
222 
223     /** @dev Fires when owner allows spender to spend value of tokens on their(owner's) expence
224      *  @param _owner address The address from which allowance has been initialized.
225      *  @param _spender address The address who was allowed to spend tokens on owner's expence.
226      *  @param value uint256 The amount of tokens allowed for spending
227      */
228     event Approval(address indexed _owner, address indexed _spender, uint256 value);
229 
230     /** @dev Fires on every creation of new tokens
231      *  @param _to address The owner address of new tokens.
232      *  @param amount uint256 The amount of tokens created
233      */
234     event Mint(address indexed _to, uint256 amount);
235 
236     /** @dev fires when minting process is complete and no new tokens can be minted
237     */
238     event MintFinished();
239 
240     // /** @dev Fires on every destruction of existing tokens
241     //  *  @param to address The owner address of tokens burned.
242     //  *  @param value uint256 The amount of tokens destroyed
243     //  */
244     // event Burn(address indexed _owner, uint256 _value);
245 
246     /** @dev Check if tokens are no more mintable
247     */
248     modifier canMint() {
249         require(!mintingFinished);
250         _;
251     }
252 
253     function getName() pure public returns(bytes32)
254     {
255         return name;
256     }
257 
258     function getSymbol() pure public returns(bytes4)
259     {
260         return symbol;
261     }
262 
263     function getTokenDecimals() pure public returns(uint256)
264     {
265         return decimals;
266     }
267     
268     function getMintingFinished() view public returns(bool)
269     {
270         return mintingFinished;
271     }
272 
273     /** @dev Get maximum amount of how many tokens can be minted by this contract
274      * @return uint256 The amount of how many tokens can be minted by this contract
275     */
276     function getTokenCap() view public returns(uint256)
277     {
278         return cap;
279     }
280 
281     /** @dev Set maximum amount of how many tokens can be minted by this contract
282     */
283     function setTokenCap(uint256 _newCap) external onlyOwner
284     {
285         cap=_newCap;
286     }
287 
288     /** @dev Set the balance of _investor as _newValue. Only usable by contract owner
289      * @param _investor address The address whose balance is updated
290      * @param _newValue uint256. The new token balance of _investor 
291     */
292     function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external
293     {
294         setTokens(_investor,_newValue);
295     }
296 
297     /**
298      * @dev transfer token for a specified address
299      * @param _to The address to transfer to.
300      * @param _value The amount to be transferred.
301     */
302 
303     function transfer(address _to, uint256 _value) public returns(bool){
304         require(msg.sender!=_to);
305         require(_value <= balanceOf(msg.sender));
306 
307         // SafeMath.sub will throw if there is not enough balance.
308         setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
309         setBalanceOf(_to, balanceOf(_to).add(_value));
310 
311         emit Transfer(msg.sender, _to, _value);
312         return true;
313     }
314 
315     /**
316      * @dev Transfer tokens from one address to another
317      * @param _from address The address which you want to send tokens from
318      * @param _to address The address which you want to transfer to
319      * @param _value uint256 the amount of tokens to be transferred
320      */
321     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
322         require(_value <= balanceOf(_from));
323         require(_value <= allowance(_from,_to));
324         setBalanceOf(_from, balanceOf(_from).sub(_value));
325         setBalanceOf(_to, balanceOf(_to).add(_value));
326         setAllowance(_from,_to,allowance(_from,_to).sub(_value));
327         emit Transfer(_from, _to, _value);
328         return true;
329     }
330 
331     /**
332  * @dev Approve the passed address to spend the specified amount of tokens on expence of msg.sender.
333  *
334  * Beware that changing an allowance with this method brings the risk that someone may use both the old
335  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
336  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
337  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338  * @param _spender The address which will spend the funds.
339  * @param _value The amount of tokens to be spent.
340  */
341     function approve(address _spender, uint256 _value) public returns(bool){
342         require(msg.sender!=_spender);
343         setAllowance(msg.sender,_spender, _value);
344         emit Approval(msg.sender, _spender, _value);
345         return true;
346     }
347 
348 
349     /**
350      * @dev Increase the amount of tokens that an owner allowed to a spender.
351      *
352      * approve should be called when allowed[_spender] == 0. To increment
353      * allowed value is better to use this function to avoid 2 calls (and wait until
354      * the first transaction is mined)
355      * From MonolithDAO Token.sol
356      * @param _spender The address which will spend the funds.
357      * @param _addedValue The amount of tokens to increase the allowance by.
358      */
359     function increaseApproval(address _spender, uint _addedValue) public returns(bool){
360         require(msg.sender!=_spender);
361         setAllowance(msg.sender,_spender,allowance(msg.sender,_spender).add(_addedValue));
362         emit Approval(msg.sender, _spender, allowance(msg.sender,_spender));
363         return true;
364     }
365 
366     /**
367      * @dev Decrease the amount of tokens that an owner allowed to a spender.
368      *
369      * approve should be called when allowed[_spender] == 0. To decrement
370      * allowed value is better to use this function to avoid 2 calls (and wait until
371      * the first transaction is mined)
372      * From MonolithDAO Token.sol
373      * @param _spender The address which will spend the funds.
374      * @param _subtractedValue The amount of tokens to decrease the allowance by.
375      */
376     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool){
377         require(msg.sender!=_spender);
378 
379         uint oldValue = allowance(msg.sender,_spender);
380         if (_subtractedValue > oldValue) {
381             setAllowance(msg.sender,_spender, 0);
382         } else {
383             setAllowance(msg.sender,_spender, oldValue.sub(_subtractedValue));
384         }
385         emit Approval(msg.sender, _spender, allowance(msg.sender,_spender));
386         return true;
387     }
388 
389     /**
390      * @dev Function to mint tokens
391      * @param _to The address that will receive the minted tokens.
392      * @param _amount The amount of tokens to mint.
393      * @return A boolean that indicates if the operation was successful.
394      */
395 
396 
397     function mint(address _to, uint256 _amount) canMint internal{
398         require(totalSupply().add(_amount) <= getTokenCap());
399         setTotalSupply(totalSupply().add(_amount));
400         setBalanceOf(_to, balanceOf(_to).add(_amount));
401         emit Mint(_to, _amount);
402         emit Transfer(address(0), _to, _amount);
403     }
404     
405     /**
406      * @dev Changes balance of _to to _amount, also increments or decrements total token supply depending on whether balance is increased or decreased
407      * @param _to address The address which token balance is updated
408      * @param _amount uint256 The new balance
409     */
410     function setTokens(address _to, uint256 _amount) canMint internal{
411         if(_amount > balanceOf(_to)){
412             uint256 diff = _amount.sub(balanceOf(_to));
413             require( totalSupply().add(diff) <= getTokenCap());
414             setTotalSupply(totalSupply().add(diff));
415             setBalanceOf(_to, _amount);
416         }else{
417             uint256 diff = balanceOf(_to).sub(_amount);
418             setTotalSupply(totalSupply().sub(diff));
419             setBalanceOf(_to, _amount);
420         }
421         emit Transfer(address(0), _to, _amount);
422     }    
423 
424     /**
425      * @dev Function to stop minting new tokens.
426      * @return True if the operation was successful.
427      */
428     function finishMinting() canMint onlyOwner external{
429         emit MintFinished();
430     }
431 
432     //Crowdsale
433     
434     // how many token units a buyer gets per wei
435     //uint256 internal rate;
436 
437     // amount of raised money in wei
438     //uint256 internal weiRaised;
439     
440     /**
441      * event for token purchase logging
442      * @param _beneficiary who got the tokens
443      * @param value uint256 The amount of weis paid for purchase
444      * @param amount uint256 The amount of tokens purchased
445      */
446     //event TokenPurchase(address indexed _beneficiary, uint256 value, uint256 amount);
447 
448      /**
449      * event for when current balance of smart contract is emptied by contract owner
450      * @param amount uint  The amount of wei withdrawn from contract balance
451      * @param timestamp uint The timestamp of withdrawal
452      */
453     //event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);
454 
455     /**
456      @dev Fallback function for when contract is simply sent ether. This calls buyTokens() method
457     */
458     // function () external payable {
459     //     buyTokens(msg.sender);
460     // }
461 
462     /**
463      * @dev Just a getter for token rate
464      * @return uint256 Current token rate stored in this contract and by which new tokens are minted
465     */
466     // function getTokenRate() view public returns(uint256)
467     // {
468     //     return rate;
469     // }
470 
471     /**
472      * @dev Setter for token rate. Callable by contract owner only
473      * @param _newRate uint256 New token rate stored in this contract
474     */
475     // function setTokenRate(uint256 _newRate) external onlyOwner
476     // {
477     //     rate = _newRate;
478     // }
479 
480     /**
481      * @dev Returns how much wei was ever received by this smart contract
482     */
483     // function getWeiRaised() view external returns(uint256)
484     // {
485     //     return weiRaised;
486     // }
487 
488     /**
489      * @dev low level token purchase function. Can be called from fallback function or directly
490      * @param _buyer address The address which will receive bought tokens
491     */
492     // function buyTokens(address _buyer) public payable{
493     //     require(msg.value > 0);
494     //     uint256 weiAmount = msg.value;
495 
496     //     // calculate token amount to be created
497     //     uint256 tokens = getTokenAmount(weiAmount);
498     //     require(validPurchase(tokens));
499 
500     //     // update state
501     //     weiRaised = weiRaised.add(weiAmount);
502     //     mint(_buyer, tokens);
503     //     emit TokenPurchase(_buyer, weiAmount, tokens);
504     // }
505 
506     /**
507      * @dev Get how many tokens can be received for this amount of wei.
508      * @param weiAmount uint256 The amount of wei
509      * @return uint256 How many tokens to be bought for weiAmount
510     */
511     // function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
512     //     return weiAmount.div(getTokenRate());
513     // }
514 
515     /**
516      * @dev Function for smart contract owner to withdraw all wei from contract's balance
517     */
518     // function withdrawInvestments() external onlyOwner{
519     //     uint  amount = address(this).balance;
520     //     getOwner().transfer(amount * 1 wei);
521     //     emit InvestmentsWithdrawn(amount, block.timestamp);
522     // }
523 
524     /**
525      * @dev Get current balance of smart contract in wei. Callable only by contract owner
526      * @return uint256 Current contract balance if wei
527     */
528     
529     // function getCurrentInvestments() view external onlyOwner returns(uint256)
530     // {
531     //     return address(this).balance;
532     // }
533 
534     /**
535      * @dev Get the address of owner of this smart contract
536      * @return address
537     */
538     function getOwner() view internal returns(address payable)
539     {
540         return owner;
541     }
542 
543     /**
544      * @return true if the transaction can buy tokens
545     */ 
546     // function validPurchase(uint256 tokensAmount) internal pure returns (bool) {
547     //     bool nonZeroPurchase = tokensAmount != 0;
548     //     return nonZeroPurchase;
549     // }
550     function destroy() external onlyOwner{
551         selfdestruct(getOwner());
552     }
553 }