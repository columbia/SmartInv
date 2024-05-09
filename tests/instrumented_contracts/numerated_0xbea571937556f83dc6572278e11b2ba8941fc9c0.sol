1 pragma solidity ^0.4.24;
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
51     address public owner;
52 
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57     /**
58      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59      * account.
60      */
61     function Ownable() public {
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
77     function transferOwnership(address newOwner) external onlyOwner {
78         require(newOwner != address(0));
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract EcroContract is Ownable
87 {
88 
89 using SafeMath for uint256;
90     //INVESTOR REPOSITORY
91     mapping(address => uint256) internal balances;
92 
93     mapping (address => mapping(uint256=>uint256)) masterNodes;
94     
95     mapping (address => uint256[]) masterNodesDates;
96 
97     mapping (address => mapping (address => uint256)) internal allowed;
98 
99     mapping (address => uint256) internal totalAllowed;
100 
101     /**
102     * @dev total number of tokens in existence
103     */
104     uint256 internal totSupply;
105 
106     //COMMON
107     function totalSupply() view public returns(uint256)
108     {
109         return totSupply;
110     }
111     
112     function getTotalAllowed(address _owner) view public returns(uint256)
113     {
114         return totalAllowed[_owner];
115     }
116 
117     function setTotalAllowed(address _owner, uint256 _newValue) internal
118     {
119         totalAllowed[_owner]=_newValue;
120     }
121 
122 
123     function setTotalSupply(uint256 _newValue) internal
124     {
125         totSupply=_newValue;
126     }
127 
128     function getMasterNodesDates(address _owner) view public returns(uint256[])
129     {
130         return masterNodesDates[_owner];
131     }
132 
133     function getMasterNodes(address _owner, uint256 _date)  view public returns(uint256)
134     {
135         return masterNodes[_owner][_date];
136     }
137 
138     function addMasterNodes(address _owner,uint256 _date,uint256 _amount) internal
139     {
140         masterNodesDates[_owner].push(_date);
141         masterNodes[_owner][_date]=_amount;
142     }
143 
144     function removeMasterNodes(address _owner,uint256 _date) internal
145     {
146         masterNodes[_owner][_date]=0;
147     }
148 
149 
150     /**
151     * @dev Gets the balance of the specified address.
152     * @param _owner The address to query the the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155 
156     function balanceOf(address _owner) view public returns(uint256)
157     {
158         return balances[_owner];
159     }
160 
161     function setBalanceOf(address _investor, uint256 _newValue) internal
162     {
163         require(_investor!=0x0000000000000000000000000000000000000000);
164         balances[_investor]=_newValue;
165     }
166 
167 
168     /**
169      * @dev Function to check the amount of tokens that an owner allowed to a spender.
170      * @param _owner address The address which owns the funds.
171      * @param _spender address The address which will spend the funds.
172      * @return A uint256 specifying the amount of tokens still available for the spender.
173      */
174 
175     function allowance(address _owner, address _spender) view public returns(uint256)
176     {
177         require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());
178         return allowed[_owner][_spender];
179     }
180 
181     function setAllowance(address _owner, address _spender, uint256 _newValue) internal
182     {
183         require(_spender!=0x0000000000000000000000000000000000000000);
184         uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);
185         require(newTotal <= balanceOf(_owner));
186         allowed[_owner][_spender]=_newValue;
187         setTotalAllowed(_owner,newTotal);
188     }
189 
190 
191 
192 // TOKEN 
193     function EcroContract(uint256 _rate, uint256 _minPurchase,uint256 _tokenReturnRate,uint256 _cap,uint256 _nodePrice) public
194     {
195         require(_minPurchase>0);
196         require(_rate > 0);
197         require(_cap > 0);
198         require(_nodePrice>0);
199         require(_tokenReturnRate>0);
200         rate=_rate;
201         minPurchase=_minPurchase;
202         tokenReturnRate=_tokenReturnRate;
203         cap = _cap;
204         nodePrice = _nodePrice;
205     }
206 
207     bytes32 internal constant name = "ECRO Coin";
208 
209     bytes3 internal constant symbol = "ECR";
210 
211     uint8 internal constant decimals = 8;
212 
213     uint256 internal cap;
214 
215     uint256 internal nodePrice;
216 
217     bool internal mintingFinished;
218 
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222 
223     event Mint(address indexed to, uint256 amount);
224 
225     event MintFinished();
226 
227     event Burn(address indexed burner, uint256 value);
228 
229     event TokenUnfrozen(address indexed owner, uint256 value);
230 
231     event TokenFrozen(address indexed owner, uint256 value);
232   
233     event MasterNodeBought(address indexed owner, uint256 amount);
234     
235     event MasterNodeReturned(address indexed owner, uint256 amount);
236     
237     modifier canMint() {
238         require(!mintingFinished);
239         _;
240     }
241 
242     function getName() view public returns(bytes32)
243     {
244         return name;
245     }
246 
247     function getSymbol() view public returns(bytes3)
248     {
249         return symbol;
250     }
251 
252     function getTokenDecimals() view public returns(uint256)
253     {
254         return decimals;
255     }
256     
257     function getMintingFinished() view public returns(bool)
258     {
259         return mintingFinished;
260     }
261 
262     function getTokenCap() view public returns(uint256)
263     {
264         return cap;
265     }
266 
267     function setTokenCap(uint256 _newCap) external onlyOwner
268     {
269         cap=_newCap;
270     }
271 
272     function getNodePrice() view public returns(uint256)
273     {
274         return nodePrice;
275     }
276 
277     function setNodePrice(uint256 _newPrice) external onlyOwner
278     {
279         require(_newPrice>0);
280         nodePrice=_newPrice;
281     }
282 
283     /**
284     * @dev Burns the tokens of the specified address.
285     * @param _owner The holder of tokens.
286     * @param _value The amount of tokens burned
287     */
288 
289   function burn(address _owner,uint256 _value) internal  {
290     require(_value <= balanceOf(_owner));
291     // no need to require value <= totalSupply, since that would imply the
292     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
293 
294     setBalanceOf(_owner, balanceOf(_owner).sub(_value));
295     setTotalSupply(totalSupply().sub(_value));
296     emit Burn(_owner, _value);
297     emit Transfer(_owner, address(0), _value);
298   }
299 
300     function freezeTokens(address _who, uint256 _value) internal
301     {
302         require(_value <= balanceOf(_who));
303         setBalanceOf(_who, balanceOf(_who).sub(_value));
304         emit TokenFrozen(_who, _value);
305         emit Transfer(_who, address(0), _value);
306   }
307     
308     function unfreezeTokens(address _who, uint256 _value) internal
309     {
310         setBalanceOf(_who, balanceOf(_who).add(_value));
311         emit TokenUnfrozen(_who, _value);
312         emit Transfer(address(0),_who, _value);
313     }
314 
315     function buyMasterNodes(uint256 _date,uint256 _amount) external
316     {
317         freezeTokens(msg.sender,_amount*getNodePrice());
318         addMasterNodes(msg.sender, _date, getMasterNodes(msg.sender,_date).add(_amount));
319         MasterNodeBought(msg.sender,_amount);
320     }  
321     
322     function returnMasterNodes(address _who, uint256 _date) onlyOwner external
323     {
324         uint256 amount = getMasterNodes(_who,_date);
325         removeMasterNodes(_who, _date);
326         unfreezeTokens(_who,amount*getNodePrice());
327         MasterNodeReturned(_who,amount);
328     }
329 
330     function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external
331     {
332         addTokens(_investor,_newValue);
333     }
334 
335     /**
336      * @dev transfer token for a specified address
337      * @param _to The address to transfer to.
338      * @param _value The amount to be transferred.
339     */
340 
341     function transfer(address _to, uint256 _value) external{
342         require(msg.sender!=_to);
343         require(_value <= balanceOf(msg.sender));
344 
345         // SafeMath.sub will throw if there is not enough balance.
346         setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
347         setBalanceOf(_to, balanceOf(_to).add(_value));
348 
349         Transfer(msg.sender, _to, _value);
350     }
351 
352     /**
353      * @dev Transfer tokens from one address to another
354      * @param _from address The address which you want to send tokens from
355      * @param _to address The address which you want to transfer to
356      * @param _value uint256 the amount of tokens to be transferred
357      */
358     function transferFrom(address _from, address _to, uint256 _value) external {
359         require(_value <= balanceOf(_from));
360         require(_value <= allowance(_from,_to));
361         setBalanceOf(_from, balanceOf(_from).sub(_value));
362         setBalanceOf(_to, balanceOf(_to).add(_value));
363         setAllowance(_from,_to,allowance(_from,_to).sub(_value));
364         Transfer(_from, _to, _value);
365     }
366 
367     /**
368  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
369  *
370  * Beware that changing an allowance with this method brings the risk that someone may use both the old
371  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
372  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
373  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374  * @param _owner The address of the owner which allows tokens to a spender
375  * @param _spender The address which will spend the funds.
376  * @param _value The amount of tokens to be spent.
377  */
378     function approve(address _owner,address _spender, uint256 _value) external {
379         require(msg.sender ==_owner);
380         setAllowance(msg.sender,_spender, _value);
381         Approval(msg.sender, _spender, _value);
382     }
383 
384 
385     /**
386      * @dev Increase the amount of tokens that an owner allowed to a spender.
387      *
388      * approve should be called when allowed[_spender] == 0. To increment
389      * allowed value is better to use this function to avoid 2 calls (and wait until
390      * the first transaction is mined)
391      * From MonolithDAO Token.sol
392      * @param _owner The address of the owner which allows tokens to a spender
393      * @param _spender The address which will spend the funds.
394      * @param _addedValue The amount of tokens to increase the allowance by.
395      */
396     function increaseApproval(address _owner, address _spender, uint _addedValue) external{
397         require(msg.sender==_owner);
398         setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));
399         Approval(_owner, _spender, allowance(_owner,_spender));
400     }
401 
402     /**
403      * @dev Decrease the amount of tokens that an owner allowed to a spender.
404      *
405      * approve should be called when allowed[_spender] == 0. To decrement
406      * allowed value is better to use this function to avoid 2 calls (and wait until
407      * the first transaction is mined)
408      * From MonolithDAO Token.sol
409      * @param _owner The address of the owner which allows tokens to a spender
410      * @param _spender The address which will spend the funds.
411      * @param _subtractedValue The amount of tokens to decrease the allowance by.
412      */
413     function decreaseApproval(address _owner,address _spender, uint _subtractedValue) external{
414         require(msg.sender==_owner);
415 
416         uint oldValue = allowance(_owner,_spender);
417         if (_subtractedValue > oldValue) {
418             setAllowance(_owner,_spender, 0);
419         } else {
420             setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));
421         }
422         Approval(_owner, _spender, allowance(_owner,_spender));
423     }
424 
425     /**
426      * @dev Function to mint tokens
427      * @param _to The address that will receive the minted tokens.
428      * @param _amount The amount of tokens to mint.
429      * @return A boolean that indicates if the operation was successful.
430      */
431 
432 
433     function mint(address _to, uint256 _amount) canMint internal{
434         require(totalSupply().add(_amount) <= getTokenCap());
435         setTotalSupply(totalSupply().add(_amount));
436         setBalanceOf(_to, balanceOf(_to).add(_amount));
437         Mint(_to, _amount);
438         Transfer(address(0), _to, _amount);
439     }
440     
441     function addTokens(address _to, uint256 _amount) canMint internal{
442         require( totalSupply().add(_amount) <= getTokenCap());
443         setTotalSupply(totalSupply().add(_amount));
444         setBalanceOf(_to, balanceOf(_to).add(_amount));
445         Transfer(address(0), _to, _amount);
446     }    
447 
448     /**
449      * @dev Function to stop minting new tokens.
450      * @return True if the operation was successful.
451      */
452     function finishMinting() canMint onlyOwner external{
453         mintingFinished = true;
454         MintFinished();
455     }
456 
457     //Crowdsale
458     
459         // what is minimal purchase of tokens
460     uint256 internal minPurchase;
461 
462     // how many token units a buyer gets per wei
463     uint256 internal rate;
464 
465     // amount of raised money in wei
466     uint256 internal weiRaised;
467     
468     uint256 internal tokenReturnRate;
469 
470     /**
471      * event for token purchase logging
472      * @param beneficiary who got the tokens
473      * @param value weis paid for purchase
474      * @param amount amount of tokens purchased
475      */
476     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
477 
478     event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);
479 
480     function () external payable {
481     }
482 
483     function getTokenRate() view public returns(uint256)
484     {
485         return rate;
486     }
487 
488     function getTokenReturnRate() view public returns(uint256)
489     {
490         return tokenReturnRate;
491     }
492 
493 
494     function getMinimumPurchase() view public returns(uint256)
495     {
496         return minPurchase;
497     }
498 
499     function setTokenRate(uint256 _newRate) external onlyOwner
500     {
501         rate = _newRate;
502     }
503     
504     function setTokenReturnRate(uint256 _newRate) external onlyOwner
505     {
506         tokenReturnRate = _newRate;
507     }
508 
509     function setMinPurchase(uint256 _newMin) external onlyOwner
510     {
511         minPurchase = _newMin;
512     }
513 
514     function getWeiRaised() view external returns(uint256)
515     {
516         return weiRaised;
517     }
518 
519     // low level token purchase function
520     function buyTokens() external payable{
521         require(msg.value > 0);
522         uint256 weiAmount = msg.value;
523 
524         // calculate token amount to be created
525         uint256 tokens = getTokenAmount(weiAmount);
526         require(validPurchase(tokens));
527 
528         // update state
529         weiRaised = weiRaised.add(weiAmount);
530         mint(msg.sender, tokens);
531         TokenPurchase(msg.sender, weiAmount, tokens);
532     }
533 
534     // Override this method to have a way to add business logic to your crowdsale when buying
535     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
536         return weiAmount.div(getTokenRate());
537     }
538 
539     // get all rised wei
540     function withdrawInvestments() external onlyOwner{
541         uint  amount = this.balance;
542         getOwner().transfer(amount * 1 wei);
543         InvestmentsWithdrawn(amount, block.timestamp);
544     }
545     
546     function returnTokens(uint256 _amount) external
547     {
548         require(balanceOf(msg.sender) >= _amount);
549         burn(msg.sender,_amount);
550         // return (rate * amount) *  returnTokenRate %
551         msg.sender.transfer(getTokenRate().mul(_amount).div(100).mul(tokenReturnRate));
552     }
553 
554     function getCurrentInvestments() view external onlyOwner returns(uint256)
555     {
556         return this.balance;
557     }
558 
559     function getOwner() view internal returns(address)
560     {
561         return owner;
562     }
563 
564     // @return true if the transaction can buy tokens
565     function validPurchase(uint256 tokensAmount) internal view returns (bool) {
566         bool nonZeroPurchase = tokensAmount != 0;
567         bool acceptableAmount = tokensAmount >= getMinimumPurchase();
568         return nonZeroPurchase && acceptableAmount;
569     }
570     
571 }