1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() public {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner public {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 contract MintableToken is StandardToken, Ownable {
195   event Mint(address indexed to, uint256 amount);
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will receive the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     Transfer(address(0), _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner canMint public returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 contract MSPT is Ownable, MintableToken {
232   using SafeMath for uint256;    
233   string public constant name = "MySmartProperty Tokens";
234   string public constant symbol = "MSPT";
235   uint32 public constant decimals = 18;
236 
237   address public addressSupporters;
238   address public addressEccles;
239   address public addressJenkins;
240   address public addressLeskiw;
241   address public addressBilborough;
242 
243   uint public summSupporters = 1000000 * 1 ether;
244   uint public summEccles = 2000000 * 1 ether;
245   uint public summJenkins = 2000000 * 1 ether;
246   uint public summLeskiw = 2000000 * 1 ether;
247   uint public summBilborough = 3000000 * 1 ether;
248 
249   function MSPT() public {
250     addressSupporters = 0x49ce9f664d9fe7774fE29F5ab17b46266e4437a4;
251     addressEccles = 0xF59C5199FCd7e29b2979831e39EfBcf16b90B485;
252     addressJenkins = 0x974e94C33a37e05c4cE292b43e7F50a57fAA5Bc7;
253     addressLeskiw = 0x3a7e8Eb6DDAa74e58a6F3A39E3d073A9eFA22160;
254     addressBilborough = 0xAabb89Ade1Fc2424b7FE837c40E214375Dcf9840;  
255       
256     //Founders and supporters initial Allocations
257     balances[addressSupporters] = balances[addressSupporters].add(summSupporters);
258     balances[addressEccles] = balances[addressEccles].add(summEccles);
259     balances[addressJenkins] = balances[addressJenkins].add(summJenkins);
260     balances[addressLeskiw] = balances[addressLeskiw].add(summLeskiw);
261     balances[addressBilborough] = balances[addressBilborough].add(summBilborough);
262     totalSupply = summSupporters.add(summEccles).add(summJenkins).add(summLeskiw).add(summBilborough);
263   }
264   function getTotalSupply() public constant returns(uint256){
265       return totalSupply;
266   }
267 }
268 
269 /**
270  * @title Crowdsale
271  * @dev Crowdsale is a base contract for managing a token crowdsale.
272  * Crowdsales have a start and end timestamps, where investors can make
273  * token purchases and the crowdsale will assign them tokens based
274  * on a token per ETH rate. Funds collected are forwarded to a wallet
275  * as they arrive. The contract requires a MintableToken that will be
276  * minted as contributions arrive, note that the crowdsale contract
277  * must be owner of the token in order to be able to mint it.
278  */
279 contract Crowdsale is Ownable {
280   using SafeMath for uint256;
281   // The token being sold
282   MSPT public token;
283   // start and end timestamps where investments are allowed (both inclusive)
284   uint256 public startRoundSeed;
285   uint256 public startPreICO;
286   uint256 public startICO;
287   uint256 public endRoundSeed;
288   uint256 public endPreICO;
289   uint256 public endICO;           
290   
291   uint256 public maxAmountRoundSeed;
292   uint256 public maxAmountPreICO;
293   uint256 public maxAmountICO;
294   
295   uint256 public totalRoundSeedAmount;
296   uint256 public totalPreICOAmount;
297   uint256 public totalICOAmount;
298   
299   // Remaining Token Allocation
300   uint public mintStart1; //15th July 2018
301   uint public mintStart2; //15th August 2018
302   uint public mintStart3; //15th December 2018
303   uint public mintStart4; //15th January 2018
304   uint public mintStart5; //15th July 2019     
305   
306   // address where funds are collected
307   address public wallet;
308 
309   // how many token units a buyer gets per wei
310   uint256 public rateRoundSeed;
311   uint256 public ratePreICO;
312   uint256 public rateICO;      
313 
314   // minimum quantity values
315   uint256 public minQuanValues; 
316   
317   // Remaining Token Allocation
318   uint256 public totalMintAmount; 
319   uint256 public allowTotalMintAmount;
320   uint256 public mintAmount1;
321   uint256 public mintAmount2;
322   uint256 public mintAmount3;
323   uint256 public mintAmount4;
324   uint256 public mintAmount5;
325   // totalTokens
326   uint256 public totalTokens;
327   
328   /**
329    * event for token purchase logging
330    * @param purchaser who paid for the tokens
331    * @param beneficiary who got the tokens
332    * @param value weis paid for purchase
333    * @param amount amount of tokens purchased
334    */
335   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
336   function Crowdsale() public {
337     token = createTokenContract();
338     // total number of tokens
339     totalTokens = 100000000 * 1 ether;
340     // minimum quantity values
341     minQuanValues = 100000000000000000;
342     // start and end timestamps where investments are allowed
343     startRoundSeed = 1518710400; //15 Feb 2018 16:00:00 GMT
344     startPreICO = 1521129600; //15 Mar 2018 16:00:00 GMT
345     startICO = 1523808000; //15 Apr 2018 16:00:00 GMT
346     endRoundSeed = startRoundSeed + 14 * 1 days;
347     endPreICO = startPreICO + 30 * 1 days;
348     endICO = startICO +  30 * 1 days;           
349     // restrictions on amounts during the ico stages
350     maxAmountRoundSeed = 4000000  * 1 ether;
351     maxAmountPreICO = 12000000  * 1 ether;
352     maxAmountICO = 24000000  * 1 ether;
353     // rate decimals = 2;
354     rateRoundSeed = 400000;
355     ratePreICO = 200000;
356     rateICO = 130000;  
357     // Remaining Token Allocation    
358     mintAmount1 = 10000000 * 1 ether;
359     mintAmount2 = 10000000 * 1 ether;
360     mintAmount3 = 10000000 * 1 ether;
361     mintAmount4 = 10000000 * 1 ether;
362     mintAmount5 = 10000000 * 1 ether;
363     
364     mintStart1 = 1531674000; //15th July 2018
365     mintStart2 = 1534352400; //15th August 2018
366     mintStart3 = 1544893200; //15th December 2018
367     mintStart4 = 1547571600; //15th January 2019
368     mintStart5 = 1563210000; //15th July 2019     
369     // address where funds are collected
370     wallet = 0x7Ac93a7A1F8304c003274512F6c46C132106FE8E;
371   }
372   function setRateRoundSeed(uint _rateRoundSeed) public {
373     rateRoundSeed = _rateRoundSeed;
374   }
375   function setRatePreICO(uint _ratePreICO) public {
376     ratePreICO = _ratePreICO;
377   }  
378   function setRateICO(uint _rateICO) public {
379     rateICO = _rateICO;
380   }    
381   
382   function createTokenContract() internal returns (MSPT) {
383     return new MSPT();
384   }
385 
386   // fallback function can be used to buy tokens
387   function () external payable {
388     buyTokens(msg.sender);
389   }
390 
391   // low level token purchase function
392   function buyTokens(address beneficiary) public payable {
393     uint256 tokens;
394     uint256 weiAmount = msg.value;
395     uint256 backAmount;
396     require(beneficiary != address(0));
397     //minimum amount in ETH
398     require(weiAmount >= minQuanValues);
399     if (now >= startRoundSeed && now < endRoundSeed && totalRoundSeedAmount < maxAmountRoundSeed  && tokens == 0){
400       tokens = weiAmount.div(100).mul(rateRoundSeed);
401       if (maxAmountRoundSeed.sub(totalRoundSeedAmount) < tokens){
402         tokens = maxAmountRoundSeed.sub(totalRoundSeedAmount); 
403         weiAmount = tokens.mul(100).div(rateRoundSeed);
404         backAmount = msg.value.sub(weiAmount);
405       }
406       totalRoundSeedAmount = totalRoundSeedAmount.add(tokens);
407       if (totalRoundSeedAmount >= maxAmountRoundSeed){
408         startPreICO = now;
409         endPreICO = startPreICO + 30 * 1 days;
410       }   
411     }
412     if (now >= startPreICO && now < endPreICO && totalPreICOAmount < maxAmountPreICO && tokens == 0){
413       tokens = weiAmount.div(100).mul(ratePreICO);
414       if (maxAmountPreICO.sub(totalPreICOAmount) < tokens){
415         tokens = maxAmountPreICO.sub(totalPreICOAmount); 
416         weiAmount = tokens.mul(100).div(ratePreICO);
417         backAmount = msg.value.sub(weiAmount);
418       }
419       totalPreICOAmount = totalPreICOAmount.add(tokens);
420       if (totalPreICOAmount >= maxAmountPreICO){
421         startICO = now;
422         endICO = startICO + 30 * 1 days;
423       }   
424     }    
425     if (now >= startICO && now < endICO && totalICOAmount < maxAmountICO  && tokens == 0){
426       tokens = weiAmount.div(100).mul(rateICO);
427       if (maxAmountICO.sub(totalICOAmount) < tokens){
428         tokens = maxAmountICO.sub(totalICOAmount); 
429         weiAmount = tokens.mul(100).div(rateICO);
430         backAmount = msg.value.sub(weiAmount);
431       }
432       totalICOAmount = totalICOAmount.add(tokens);
433     }     
434     require(tokens > 0);
435     token.mint(beneficiary, tokens);
436     wallet.transfer(weiAmount);
437     
438     if (backAmount > 0){
439       msg.sender.transfer(backAmount);    
440     }
441     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
442   }
443 
444   function mintTokens(address _to, uint256 _amount) onlyOwner public returns (bool) {
445     require(_amount > 0);
446     require(_to != address(0));
447     if (now >= mintStart1 && now < mintStart2){
448       allowTotalMintAmount = mintAmount1;  
449     }
450     if (now >= mintStart2 && now < mintStart3){
451       allowTotalMintAmount = mintAmount1.add(mintAmount2);  
452     }  
453     if (now >= mintStart3 && now < mintStart4){
454       allowTotalMintAmount = mintAmount1.add(mintAmount2).add(mintAmount3);  
455     }       
456     if (now >= mintStart4 && now < mintStart5){
457       allowTotalMintAmount = mintAmount1.add(mintAmount2).add(mintAmount3).add(mintAmount4);  
458     }       
459     if (now >= mintStart5){
460       allowTotalMintAmount = totalMintAmount.add(totalTokens.sub(token.getTotalSupply()));
461     }       
462     require(_amount.add(totalMintAmount) <= allowTotalMintAmount);
463     token.mint(_to, _amount);
464     totalMintAmount = totalMintAmount.add(_amount);
465     return true;
466   }
467   function finishMintingTokens() onlyOwner public returns (bool) {
468     token.finishMinting(); 
469   }
470 }