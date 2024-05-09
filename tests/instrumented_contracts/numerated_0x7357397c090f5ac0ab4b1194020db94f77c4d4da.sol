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
77     emit Transfer(msg.sender, _to, _value);
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
110     uint _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     emit Transfer(_from, _to, _value);
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
136     emit Approval(msg.sender, _spender, _value);
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
215     emit Mint(_to, _amount);
216     emit Transfer(address(0), _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner canMint public returns (bool) {
225     mintingFinished = true;
226     emit MintFinished();
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
284   uint256 public startPreICO;
285   uint256 public startICO;
286   uint256 public endPreICO;
287   uint256 public endICO;           
288   
289   uint256 public maxAmountPreICO;
290   uint256 public maxAmountICO;
291   
292   uint256 public totalPreICOAmount;
293   uint256 public totalICOAmount;
294   
295   // Remaining Token Allocation
296   uint public mintStart1; //15th July 2018
297   uint public mintStart2; //15th August 2018
298   uint public mintStart3; //15th December 2018
299   uint public mintStart4; //15th January 2018
300   uint public mintStart5; //15th July 2019     
301   
302   // address where funds are collected
303   address public wallet;
304 
305   // how many token units a buyer gets per wei
306   uint256 public ratePreICO;
307   uint256 public rateICO;      
308 
309   // minimum quantity values
310   uint256 public minQuanValues; 
311   
312   // Remaining Token Allocation
313   uint256 public totalMintAmount; 
314   uint256 public allowTotalMintAmount;
315   uint256 public mintAmount1;
316   uint256 public mintAmount2;
317   uint256 public mintAmount3;
318   uint256 public mintAmount4;
319   uint256 public mintAmount5;
320   // totalTokens
321   uint256 public totalTokens;
322   
323   /**
324    * event for token purchase logging
325    * @param purchaser who paid for the tokens
326    * @param beneficiary who got the tokens
327    * @param value weis paid for purchase
328    * @param amount amount of tokens purchased
329    */
330   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
331   function Crowdsale() public {
332     token = createTokenContract();
333     // total number of tokens
334     totalTokens = 100000000 * 1 ether;
335     // minimum quantity values
336     minQuanValues = 100000000000000000;
337     // start and end timestamps where investments are allowed
338     startPreICO = 1527948000; //3 June 2018 00:00:00 +10 GMT
339     endPreICO = 1530280800; //30 June 2018 00:00:00 +10 GMT
340     startICO = 1530280800; //30 June 2018 00:00:00 +10 GMT
341     endICO = startICO +  30 * 1 days;           
342     // restrictions on amounts during the ico stages
343     maxAmountPreICO = 12000000  * 1 ether;
344     maxAmountICO = 24000000  * 1 ether;
345     // rate decimals = 2;
346     ratePreICO = 79294;
347     rateICO = 59470;
348     // Remaining Token Allocation    
349     mintAmount1 = 10000000 * 1 ether;
350     mintAmount2 = 10000000 * 1 ether;
351     mintAmount3 = 10000000 * 1 ether;
352     mintAmount4 = 10000000 * 1 ether;
353     mintAmount5 = 10000000 * 1 ether;
354     
355     mintStart1 = 1538316000; //1st October  2018 +10 GMT
356     mintStart2 = 1540994400; //1st November 2018 +10 GMT
357     mintStart3 = 1551362400; //1st March    2019 +10 GMT
358     mintStart4 = 1554040800; //1st April    2019 +10 GMT
359     mintStart5 = 1569852000; //1st October  2019 +10 GMT
360     // address where funds are collected
361     wallet = 0x7Ac93a7A1F8304c003274512F6c46C132106FE8E;
362   }
363   function setRatePreICO(uint _ratePreICO) public {
364     ratePreICO = _ratePreICO;
365   }  
366   function setRateICO(uint _rateICO) public {
367     rateICO = _rateICO;
368   }    
369   
370   function createTokenContract() internal returns (MSPT) {
371     return new MSPT();
372   }
373 
374   // fallback function can be used to buy tokens
375   function () external payable {
376     buyTokens(msg.sender);
377   }
378 
379   // low level token purchase function
380   function buyTokens(address beneficiary) public payable {
381     uint256 tokens;
382     uint256 weiAmount = msg.value;
383     uint256 backAmount;
384     require(beneficiary != address(0));
385     //minimum amount in ETH
386     require(weiAmount >= minQuanValues);
387     if (now >= startPreICO && now < endPreICO && totalPreICOAmount < maxAmountPreICO && tokens == 0){
388       tokens = weiAmount.div(100).mul(ratePreICO);
389       if (maxAmountPreICO.sub(totalPreICOAmount) < tokens){
390         tokens = maxAmountPreICO.sub(totalPreICOAmount); 
391         weiAmount = tokens.mul(100).div(ratePreICO);
392         backAmount = msg.value.sub(weiAmount);
393       }
394       totalPreICOAmount = totalPreICOAmount.add(tokens);
395       if (totalPreICOAmount >= maxAmountPreICO){
396         startICO = now;
397         endICO = startICO + 30 * 1 days;
398       }   
399     }    
400     if (now >= startICO && totalICOAmount < maxAmountICO  && tokens == 0){
401       tokens = weiAmount.div(100).mul(rateICO);
402       if (maxAmountICO.sub(totalICOAmount) < tokens){
403         tokens = maxAmountICO.sub(totalICOAmount); 
404         weiAmount = tokens.mul(100).div(rateICO);
405         backAmount = msg.value.sub(weiAmount);
406       }
407       totalICOAmount = totalICOAmount.add(tokens);
408     }     
409     require(tokens > 0);
410     token.mint(beneficiary, tokens);
411     wallet.transfer(weiAmount);
412     
413     if (backAmount > 0){
414       msg.sender.transfer(backAmount);    
415     }
416     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
417   }
418 
419   function mintTokens(address _to, uint256 _amount) onlyOwner public returns (bool) {
420     require(_amount > 0);
421     require(_to != address(0));
422     if (now >= mintStart1 && now < mintStart2){
423       allowTotalMintAmount = mintAmount1;  
424     }
425     if (now >= mintStart2 && now < mintStart3){
426       allowTotalMintAmount = mintAmount1.add(mintAmount2);  
427     }  
428     if (now >= mintStart3 && now < mintStart4){
429       allowTotalMintAmount = mintAmount1.add(mintAmount2).add(mintAmount3);  
430     }       
431     if (now >= mintStart4 && now < mintStart5){
432       allowTotalMintAmount = mintAmount1.add(mintAmount2).add(mintAmount3).add(mintAmount4);  
433     }       
434     if (now >= mintStart5){
435       allowTotalMintAmount = totalMintAmount.add(totalTokens.sub(token.getTotalSupply()));
436     }       
437     require(_amount.add(totalMintAmount) <= allowTotalMintAmount);
438     token.mint(_to, _amount);
439     totalMintAmount = totalMintAmount.add(_amount);
440     return true;
441   }
442   function finishMintingTokens() onlyOwner public returns (bool) {
443     token.finishMinting(); 
444   }
445 }