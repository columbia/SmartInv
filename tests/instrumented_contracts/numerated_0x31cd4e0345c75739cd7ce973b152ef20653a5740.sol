1 pragma solidity ^0.4.12;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner(){
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 }
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public constant returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a * b;
70     assert(a == 0 || c / a == b);
71     return c;
72   }
73 
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return c;
79   }
80 
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106    */
107   function transfer(address _to, uint256 _value) public returns (bool){
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118    */
119   function balanceOf(address _owner) public constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134   /**
135   * @dev Transfer tokens from one address to another
136   * @param _from address The address which you want to send tokens from
137   * @param _to address The address which you want to transfer to
138   * @param _value uint256 the amout of tokens to be transfered
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
152   * @param _spender The address which will spend the funds.
153   * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156 
157     // To change the approve amount you first have to reduce the addresses`
158     //  allowance to zero by calling `approve(_spender, 0)` if it is not
159     //  already 0 to mitigate the race condition described here:
160     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
162 
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Function to check the amount of tokens that an owner allowed to a spender.
170   * @param _owner address The address which owns the funds.
171     * @param _spender address The address which will spend the funds.
172     * @return A uint256 specifing the amount of tokens still avaible for the spender.
173    */
174   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
175     return allowed[_owner][_spender];
176   }
177 }
178 
179 /**
180  * @title Mintable token
181  * @dev Simple ERC20 Token example, with mintable token creation
182  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
183  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
184  */
185 
186 contract MintableToken is StandardToken, Ownable {
187   event Mint(address indexed to, uint256 amount);
188   event MintFinished();
189 
190   bool public mintingFinished = false;
191 
192   modifier canMint() {
193     require(!mintingFinished);
194     _;
195   }
196 
197   /**
198   * @dev Function to mint tokens
199   * @param _to The address that will recieve the minted tokens.
200     * @param _amount The amount of tokens to mint.
201     * @return A boolean that indicates if the operation was successful.
202    */
203   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
204     totalSupply = totalSupply.add(_amount);
205     balances[_to] = balances[_to].add(_amount);
206     Transfer(0X0, _to, _amount);
207     return true;
208   }
209 
210   /**
211   * @dev Function to stop minting new tokens.
212   * @return True if the operation was successful.
213    */
214   function finishMinting() onlyOwner public returns (bool) {
215     mintingFinished = true;
216     MintFinished();
217     return true;
218   }
219 }
220 
221 contract ReporterToken is MintableToken {
222   string public name = "Reporter Token";
223   string public symbol = "NEWS";
224   uint256 public decimals = 18;
225 
226   bool public tradingStarted = false;
227 
228   /**
229   * @dev modifier that throws if trading has not started yet
230    */
231   modifier hasStartedTrading() {
232     require(tradingStarted);
233     _;
234   }
235 
236   /**
237   * @dev Allows the owner to enable the trading. This can not be undone
238   */
239   function startTrading() public onlyOwner {
240     tradingStarted = true;
241   }
242 
243   /**
244    * @dev Allows anyone to transfer the Change tokens once trading has started
245    * @param _to the recipient address of the tokens.
246    * @param _value number of tokens to be transfered.
247    */
248   function transfer(address _to, uint _value) hasStartedTrading public returns (bool) {
249     return super.transfer(_to, _value);
250   }
251 
252   /**
253   * @dev Allows anyone to transfer the Change tokens once trading has started
254   * @param _from address The address which you want to send tokens from
255   * @param _to address The address which you want to transfer to
256   * @param _value uint the amout of tokens to be transfered
257    */
258   function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool) {
259     return super.transferFrom(_from, _to, _value);
260   }
261 
262   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
263     oddToken.transfer(owner, amount);
264   }
265 }
266 
267 contract ReporterTokenSale is Ownable {
268   using SafeMath for uint256;
269 
270   // The token being sold
271   ReporterToken public token;
272 
273   uint256 public decimals;  
274   uint256 public oneCoin;
275 
276   // start and end block where investments are allowed (both inclusive)
277   uint256 public startTimestamp;
278   uint256 public endTimestamp;
279 
280   // address where funds are collected
281   address public multiSig;
282 
283   function setWallet(address _newWallet) public onlyOwner {
284     multiSig = _newWallet;
285   }
286 
287   // These will be set by setTier()
288   uint256 public rate; // how many token units a buyer gets per wei
289   uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
290   uint256 public maxContribution = 200000 ether;  // default limit to tokens that the users can buy
291 
292   // ***************************
293 
294   // amount of raised money in wei
295   uint256 public weiRaised;
296 
297   // amount of raised tokens 
298   uint256 public tokenRaised;
299 
300   // maximum amount of tokens being created
301   uint256 public maxTokens;
302 
303   // maximum amount of tokens for sale
304   uint256 public tokensForSale;  // 36 Million Tokens for SALE
305 
306   // number of participants in presale
307   uint256 public numberOfPurchasers = 0;
308 
309   //  for whitelist
310   address public cs;
311 
312 
313   // switch on/off the authorisation , default: false
314   bool    public freeForAll = false;
315 
316   mapping (address => bool) public authorised; // just to annoy the heck out of americans
317 
318   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
319   event SaleClosed();
320 
321   function ReporterTokenSale() public {
322     startTimestamp = 1508684400; // 22 Oct. 2017. 15:00 UTC
323     endTimestamp = 1519657200;   // 26 Febr. 2018. 15:00 UTC
324     multiSig = 0xD00d085F125EAFEA9e8c5D3f4bc25e6D0c93Af0e;
325 
326     token = new ReporterToken();
327     decimals = token.decimals();
328     oneCoin = 10 ** decimals;
329     maxTokens = 60 * (10**6) * oneCoin;
330     tokensForSale = 36 * (10**6) * oneCoin;
331   }
332 
333   /**
334   * @dev Calculates the amount of bonus coins the buyer gets
335   */
336   function setTier() internal {
337     // first 25% tokens get extra 30% of tokens, next half get 15%
338     if (tokenRaised <= 9000000 * oneCoin) {
339       rate = 1420;
340       //minContribution = 100 ether;
341       //maxContribution = 1000000 ether;
342     } else if (tokenRaised <= 18000000 * oneCoin) {
343       rate = 1170;
344       //minContribution = 5 ether;
345       //maxContribution = 1000000 ether;
346     } else {
347       rate = 1000;
348       //minContribution = 0.01 ether;
349       //maxContribution = 100 ether;
350     }
351   }
352 
353   // @return true if crowdsale event has ended
354   function hasEnded() public constant returns (bool) {
355     if (now > endTimestamp)
356       return true;
357     if (tokenRaised >= tokensForSale)
358       return true; // if we reach the tokensForSale
359     return false;
360   }
361 
362   /**
363   * @dev throws if person sending is not contract owner or cs role
364    */
365   modifier onlyCSorOwner() {
366     require((msg.sender == owner) || (msg.sender==cs));
367     _;
368   }
369    modifier onlyCS() {
370     require(msg.sender == cs);
371     _;
372   }
373 
374   /**
375   * @dev throws if person sending is not authorised or sends nothing
376   */
377   modifier onlyAuthorised() {
378     require (authorised[msg.sender] || freeForAll);
379     require (now >= startTimestamp);
380     require (!(hasEnded()));
381     require (multiSig != 0x0);
382     require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
383     _;
384   }
385 
386   /**
387   * @dev authorise an account to participate
388   */
389   function authoriseAccount(address whom) onlyCSorOwner public {
390     authorised[whom] = true;
391   }
392 
393   /**
394   * @dev authorise a lot of accounts in one go
395   */
396   function authoriseManyAccounts(address[] many) onlyCSorOwner public {
397     for (uint256 i = 0; i < many.length; i++) {
398       authorised[many[i]] = true;
399     }
400   }
401 
402   /**
403   * @dev ban an account from participation (default)
404   */
405   function blockAccount(address whom) onlyCSorOwner public {
406     authorised[whom] = false;
407    }  
408     
409   /**
410   * @dev set a new CS representative
411   */
412   function setCS(address newCS) onlyOwner public {
413     cs = newCS;
414   }
415 
416   function placeTokens(address beneficiary, uint256 _tokens) onlyCS public {
417     //check minimum and maximum amount
418     require(_tokens != 0);
419     require(!hasEnded());
420     uint256 amount = 0;
421     if (token.balanceOf(beneficiary) == 0) {
422       numberOfPurchasers++;
423     }
424     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
425     token.mint(beneficiary, _tokens);
426     TokenPurchase(beneficiary, amount, _tokens);
427   }
428 
429   // low level token purchase function
430   function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal {
431 
432     setTier();
433 
434     //check minimum and maximum amount
435     require(amount >= minContribution);
436     require(amount <= maxContribution);
437 
438     // calculate token amount to be created
439     uint256 tokens = amount.mul(rate);
440 
441     // update state
442     weiRaised = weiRaised.add(amount);
443     if (token.balanceOf(beneficiary) == 0) {
444       numberOfPurchasers++;
445     }
446     tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
447     token.mint(beneficiary, tokens);
448     TokenPurchase(beneficiary, amount, tokens);
449     multiSig.transfer(this.balance); // better in case any other ether ends up here
450   }
451 
452   // transfer ownership of the token to the owner of the presale contract
453   function finishSale() public onlyOwner {
454     require(hasEnded());
455 
456     // assign the rest of the 60M tokens to the reserve
457     uint unassigned;
458     if(maxTokens > tokenRaised) {
459       unassigned  = maxTokens.sub(tokenRaised);
460       token.mint(multiSig,unassigned);
461     }
462     token.finishMinting();
463     token.transferOwnership(owner);
464     SaleClosed();
465   }
466 
467   // fallback function can be used to buy tokens
468   function () public payable {
469     buyTokens(msg.sender, msg.value);
470   }
471 
472   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
473     oddToken.transfer(owner, amount);
474   }
475 }