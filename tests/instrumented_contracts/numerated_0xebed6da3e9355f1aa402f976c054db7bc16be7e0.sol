1 pragma solidity 0.4.23;
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
77     function transferOwnership(address newOwner) external onlyOwner {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract IgfContract is Ownable
87 {
88 
89 using SafeMath for uint256;
90     //INVESTOR REPOSITORY
91     mapping(address => uint256) internal balances;
92 
93     mapping (address => mapping (address => uint256)) internal allowed;
94 
95     mapping (address => uint256) internal totalAllowed;
96 
97     /**
98     * @dev total number of tokens in existence
99     */
100     uint256 internal totSupply;
101 
102     //COMMON
103     function totalSupply() view public returns(uint256)
104     {
105         return totSupply;
106     }
107     
108     function getTotalAllowed(address _owner) view public returns(uint256)
109     {
110         return totalAllowed[_owner];
111     }
112 
113     function setTotalAllowed(address _owner, uint256 _newValue) internal
114     {
115         totalAllowed[_owner]=_newValue;
116     }
117 
118 
119     function setTotalSupply(uint256 _newValue) internal
120     {
121         totSupply=_newValue;
122     }
123 
124 
125     /**
126     * @dev Gets the balance of the specified address.
127     * @param _owner The address to query the the balance of.
128     * @return An uint256 representing the amount owned by the passed address.
129     */
130 
131     function balanceOf(address _owner) view public returns(uint256)
132     {
133         return balances[_owner];
134     }
135 
136     function setBalanceOf(address _investor, uint256 _newValue) internal
137     {
138         require(_investor!=0x0000000000000000000000000000000000000000);
139         balances[_investor]=_newValue;
140     }
141 
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param _owner address The address which owns the funds.
146      * @param _spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149 
150     function allowance(address _owner, address _spender) view public returns(uint256)
151     {
152         require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());
153         return allowed[_owner][_spender];
154     }
155 
156     function setAllowance(address _owner, address _spender, uint256 _newValue) internal
157     {
158         require(_spender!=0x0000000000000000000000000000000000000000);
159         uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);
160         require(newTotal <= balanceOf(_owner));
161         allowed[_owner][_spender]=_newValue;
162         setTotalAllowed(_owner,newTotal);
163     }
164 
165 
166 
167 // TOKEN 
168    constructor(uint256 _rate, uint256 _minPurchase,uint256 _cap) public
169     {
170         require(_minPurchase>0);
171         require(_rate > 0);
172         require(_cap > 0);
173         rate=_rate;
174         minPurchase=_minPurchase;
175         cap = _cap;
176     }
177 
178     bytes32 public constant name = "IGFToken";
179 
180     bytes3 public constant symbol = "IGF";
181 
182     uint8 public constant decimals = 8;
183 
184     uint256 public cap;
185 
186     bool internal mintingFinished;
187 
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 
192     event Mint(address indexed to, uint256 amount);
193 
194     event MintFinished();
195     
196     event Burn(address indexed _owner, uint256 _value);
197 
198     modifier canMint() {
199         require(!mintingFinished);
200         _;
201     }
202 
203     function getName() view public returns(bytes32)
204     {
205         return name;
206     }
207 
208     function getSymbol() view public returns(bytes3)
209     {
210         return symbol;
211     }
212 
213     function getTokenDecimals() view public returns(uint256)
214     {
215         return decimals;
216     }
217     
218     function getMintingFinished() view public returns(bool)
219     {
220         return mintingFinished;
221     }
222 
223     function getTokenCap() view public returns(uint256)
224     {
225         return cap;
226     }
227 
228     function setTokenCap(uint256 _newCap) external onlyOwner
229     {
230         cap=_newCap;
231     }
232 
233 
234     /**
235     * @dev Burns the tokens of the specified address.
236     * @param _owner The holder of tokens.
237     * @param _value The amount of tokens burned
238     */
239 
240   function burn(address _owner,uint256 _value) external  {
241     require(_value <= balanceOf(_owner));
242     // no need to require value <= totalSupply, since that would imply the
243     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
244 
245     setBalanceOf(_owner, balanceOf(_owner).sub(_value));
246     setTotalSupply(totalSupply().sub(_value));
247     emit Burn(_owner, _value);
248   }
249 
250     
251 
252     function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external
253     {
254         addTokens(_investor,_newValue);
255     }
256 
257     /**
258      * @dev transfer token for a specified address
259      * @param _to The address to transfer to.
260      * @param _value The amount to be transferred.
261     */
262 
263     function transfer(address _to, uint256 _value) external{
264         require(msg.sender!=_to);
265         require(_value <= balanceOf(msg.sender));
266 
267         // SafeMath.sub will throw if there is not enough balance.
268         setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
269         setBalanceOf(_to, balanceOf(_to).add(_value));
270 
271         emit Transfer(msg.sender, _to, _value);
272     }
273 
274     /**
275      * @dev Transfer tokens from one address to another
276      * @param _from address The address which you want to send tokens from
277      * @param _to address The address which you want to transfer to
278      * @param _value uint256 the amount of tokens to be transferred
279      */
280     function transferFrom(address _from, address _to, uint256 _value) external {
281         require(_value <= balanceOf(_from));
282         require(_value <= allowance(_from,_to));
283         setBalanceOf(_from, balanceOf(_from).sub(_value));
284         setBalanceOf(_to, balanceOf(_to).add(_value));
285         setAllowance(_from,_to,allowance(_from,_to).sub(_value));
286         emit Transfer(_from, _to, _value);
287     }
288 
289     /**
290  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291  *
292  * Beware that changing an allowance with this method brings the risk that someone may use both the old
293  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
294  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
295  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296  * @param _owner The address of the owner which allows tokens to a spender
297  * @param _spender The address which will spend the funds.
298  * @param _value The amount of tokens to be spent.
299  */
300     function approve(address _owner,address _spender, uint256 _value) external {
301         require(msg.sender ==_owner);
302         setAllowance(msg.sender,_spender, _value);
303         emit Approval(msg.sender, _spender, _value);
304     }
305 
306 
307     /**
308      * @dev Increase the amount of tokens that an owner allowed to a spender.
309      *
310      * approve should be called when allowed[_spender] == 0. To increment
311      * allowed value is better to use this function to avoid 2 calls (and wait until
312      * the first transaction is mined)
313      * From MonolithDAO Token.sol
314      * @param _owner The address of the owner which allows tokens to a spender
315      * @param _spender The address which will spend the funds.
316      * @param _addedValue The amount of tokens to increase the allowance by.
317      */
318     function increaseApproval(address _owner, address _spender, uint _addedValue) external{
319         require(msg.sender==_owner);
320         setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));
321         emit Approval(_owner, _spender, allowance(_owner,_spender));
322     }
323 
324     /**
325      * @dev Decrease the amount of tokens that an owner allowed to a spender.
326      *
327      * approve should be called when allowed[_spender] == 0. To decrement
328      * allowed value is better to use this function to avoid 2 calls (and wait until
329      * the first transaction is mined)
330      * From MonolithDAO Token.sol
331      * @param _owner The address of the owner which allows tokens to a spender
332      * @param _spender The address which will spend the funds.
333      * @param _subtractedValue The amount of tokens to decrease the allowance by.
334      */
335     function decreaseApproval(address _owner,address _spender, uint _subtractedValue) external{
336         require(msg.sender==_owner);
337 
338         uint oldValue = allowance(_owner,_spender);
339         if (_subtractedValue > oldValue) {
340             setAllowance(_owner,_spender, 0);
341         } else {
342             setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));
343         }
344         emit Approval(_owner, _spender, allowance(_owner,_spender));
345     }
346 
347     /**
348      * @dev Function to mint tokens
349      * @param _to The address that will receive the minted tokens.
350      * @param _amount The amount of tokens to mint.
351      * @return A boolean that indicates if the operation was successful.
352      */
353 
354 
355     function mint(address _to, uint256 _amount) canMint internal{
356         require(totalSupply().add(_amount) <= getTokenCap());
357         setTotalSupply(totalSupply().add(_amount));
358         setBalanceOf(_to, balanceOf(_to).add(_amount));
359         emit Mint(_to, _amount);
360         emit Transfer(address(0), _to, _amount);
361     }
362     
363     function addTokens(address _to, uint256 _amount) canMint internal{
364         require( totalSupply().add(_amount) <= getTokenCap());
365         setTotalSupply(totalSupply().add(_amount));
366         setBalanceOf(_to, balanceOf(_to).add(_amount));
367         emit Transfer(address(0), _to, _amount);
368     }    
369 
370     /**
371      * @dev Function to stop minting new tokens.
372      * @return True if the operation was successful.
373      */
374     function finishMinting() canMint onlyOwner external{
375         mintingFinished = true;
376         emit MintFinished();
377     }
378 
379     //Crowdsale
380     
381         // what is minimal purchase of tokens
382     uint256 internal minPurchase;
383 
384     // how many token units a buyer gets per wei
385     uint256 internal rate;
386 
387     // amount of raised money in wei
388     uint256 internal weiRaised;
389     
390     /**
391      * event for token purchase logging
392      * @param beneficiary who got the tokens
393      * @param value weis paid for purchase
394      * @param amount amount of tokens purchased
395      */
396     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
397 
398     event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);
399 
400     function () external payable {
401     }
402 
403     function getTokenRate() view public returns(uint256)
404     {
405         return rate;
406     }
407 
408     function getMinimumPurchase() view public returns(uint256)
409     {
410         return minPurchase;
411     }
412 
413     function setTokenRate(uint256 _newRate) external onlyOwner
414     {
415         rate = _newRate;
416     }
417     
418     function setMinPurchase(uint256 _newMin) external onlyOwner
419     {
420         minPurchase = _newMin;
421     }
422 
423     function getWeiRaised() view external returns(uint256)
424     {
425         return weiRaised;
426     }
427 
428     // low level token purchase function
429     function buyTokens() external payable{
430         require(msg.value > 0);
431         uint256 weiAmount = msg.value;
432 
433         // calculate token amount to be created
434         uint256 tokens = getTokenAmount(weiAmount);
435         require(validPurchase(tokens));
436 
437         // update state
438         weiRaised = weiRaised.add(weiAmount);
439         mint(msg.sender, tokens);
440         emit TokenPurchase(msg.sender, weiAmount, tokens);
441     }
442 
443     // Override this method to have a way to add business logic to your crowdsale when buying
444     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
445         return weiAmount.div(getTokenRate());
446     }
447 
448     // get all rised wei
449     function withdrawInvestments() external onlyOwner{
450         uint  amount = address(this).balance;
451         getOwner().transfer(amount * 1 wei);
452         emit InvestmentsWithdrawn(amount, block.timestamp);
453     }
454     
455     function getCurrentInvestments() view external onlyOwner returns(uint256)
456     {
457         return address(this).balance;
458     }
459 
460     function getOwner() view internal returns(address)
461     {
462         return owner;
463     }
464 
465     // @return true if the transaction can buy tokens
466     function validPurchase(uint256 tokensAmount) internal view returns (bool) {
467         bool nonZeroPurchase = tokensAmount != 0;
468         bool acceptableAmount = tokensAmount >= getMinimumPurchase();
469         return nonZeroPurchase && acceptableAmount;
470     }
471     
472     // CASHIER
473     uint256 internal dividendsPaid;
474 
475     event DividendsPayment(uint256 amount, address beneficiary);
476 
477     function getTotalDividendsPaid() view external onlyOwner returns (uint256)
478     {
479         return dividendsPaid;
480     }
481 
482     function getBalance() view public onlyOwner returns (uint256)
483     {
484         return address(this).balance;
485     }
486 
487     function payDividends(address beneficiary,uint256 amount) external onlyOwner returns(bool)
488     {
489         require(amount > 0);
490         validBeneficiary(beneficiary);
491         beneficiary.transfer(amount);
492         dividendsPaid.add(amount);
493         emit DividendsPayment(amount, beneficiary);
494         return true;
495     }
496 
497     function depositDividends() payable external onlyOwner
498     {
499        address(this).transfer(msg.value);
500     }
501     
502     function validBeneficiary(address beneficiary) view internal
503     {
504         require(balanceOf(beneficiary)>0);
505     }
506     
507     
508     //duplicates
509     
510     function getInvestorBalance(address _address) view external returns(uint256)
511     {
512         return balanceOf(_address);
513     }
514 }