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
110     require(_to != address(0));
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = balances[_from].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     emit Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     emit Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() public {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner public {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 contract MintableToken is StandardToken, Ownable {
194   event Mint(address indexed to, uint256 amount);
195   event MintFinished();
196 
197   bool public mintingFinished = false;
198 
199 
200   modifier canMint() {
201     require(!mintingFinished);
202     _;
203   }
204 
205   /**
206    * @dev Function to mint tokens
207    * @param _to The address that will receive the minted tokens.
208    * @param _amount The amount of tokens to mint.
209    * @return A boolean that indicates if the operation was successful.
210    */
211   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
212     totalSupply = totalSupply.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     emit Mint(_to, _amount);
215     emit Transfer(address(0), _to, _amount);
216     return true;
217   }
218 
219   /**
220    * @dev Function to stop minting new tokens.
221    * @return True if the operation was successful.
222    */
223   function finishMinting() onlyOwner canMint public returns (bool) {
224     mintingFinished = true;
225     emit MintFinished();
226     return true;
227   }
228 }
229 
230 contract INV is Ownable, MintableToken {
231   using SafeMath for uint256;    
232   string public constant name = "Invest";
233   string public constant symbol = "INV";
234   uint32 public constant decimals = 18;
235 
236   address public addressTeam; // address of vesting smart contract
237   address public addressReserve;
238   address public addressAdvisors;
239   address public addressBounty;
240 
241   uint public summTeam;
242   uint public summReserve;
243   uint public summAdvisors;
244   uint public summBounty;
245   
246   function INV() public {
247     summTeam =     42000000 * 1 ether;
248     summReserve =  27300000 * 1 ether;
249     summAdvisors = 10500000 * 1 ether;
250     summBounty =    4200000 * 1 ether;  
251 
252     addressTeam =     0xE347C064D8535b2f7D7C0f7bc5d6763125FC2Dc6;
253     addressReserve =  0xB7C8163F7aAA51f1836F43d76d263e72529413ad;
254     addressAdvisors = 0x461361e2b78F401db76Ea1FD4E0125bF3c56a222;
255     addressBounty =   0x4060F9bf893fa563C272F5E4d4E691e84eF983CA;
256 
257     //Founders and supporters initial Allocations
258     mint(addressTeam, summTeam);
259     mint(addressReserve, summReserve);
260     mint(addressAdvisors, summAdvisors);
261     mint(addressBounty, summBounty);
262   }
263   function getTotalSupply() public constant returns(uint256){
264       return totalSupply;
265   }
266 }
267 
268 /**
269  * @title Crowdsale
270  * @dev Crowdsale is a base contract for managing a token crowdsale.
271  * Crowdsales have a start and end timestamps, where investors can make
272  * token purchases and the crowdsale will assign them tokens based
273  * on a token per ETH rate. Funds collected are forwarded to a wallet
274  * as they arrive. The contract requires a MintableToken that will be
275  * minted as contributions arrive, note that the crowdsale contract
276  * must be owner of the token in order to be able to mint it.
277  */
278 contract Crowdsale is Ownable {
279   using SafeMath for uint256;
280   // totalTokens
281   uint256 public totalTokens;
282   // total all stage
283   uint256 public totalAllStage;
284   // The token being sold
285   INV public token;
286   // start and end timestamps where investments are allowed (both inclusive)
287     //start
288   uint256 public startSeedStage;
289   uint256 public startPrivateSaleStage;
290   uint256 public startPreSaleStage;
291   uint256 public startPublicSaleStage; 
292     //end
293   uint256 public endSeedStage;
294   uint256 public endPrivateSaleStage;
295   uint256 public endPreSaleStage;
296   uint256 public endPublicSaleStage;    
297 
298   
299   // the maximum number of tokens that can 
300   // be allocated at the current stage of the ICO
301   uint256 public maxSeedStage;
302   uint256 public maxPrivateSaleStage;
303   uint256 public maxPreSaleStage;
304   uint256 public maxPublicSaleStage;   
305   // the total number of tokens distributed at the current stage of the ICO
306   uint256 public totalSeedStage;
307   uint256 public totalPrivateSaleStage;
308   uint256 public totalPreSaleStage;
309   uint256 public totalPublicSaleStage; 
310 
311   // rate
312   uint256 public rateSeedStage;
313   uint256 public ratePrivateSaleStage;
314   uint256 public ratePreSaleStage;
315   uint256 public ratePublicSaleStage;   
316 
317   // address where funds are collected
318   address public wallet;
319 
320   // minimum payment
321   uint256 public minPayment; 
322 
323   /**
324    * event for token purchase logging
325    * @param purchaser who paid for the tokens
326    * @param beneficiary who got the tokens
327    * @param value weis paid for purchase
328    * @param amount amount of tokens purchased
329    */
330   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
331   
332   function Crowdsale() public {
333     token = createTokenContract();
334     // total number of tokens
335     totalTokens = 126000000 * 1 ether;
336     // minimum quantity values
337     minPayment = 10000000000000000; //0.01 eth
338     
339   // start and end timestamps where investments are allowed (both inclusive)
340     //start
341   startSeedStage = 1523275200; //09 Apr 2018 12:00:00 UTC
342   startPrivateSaleStage = 1526385600; //15 May 2018 12:00:00 UTC
343   startPreSaleStage = 1527336000; //26 May 2018 12:00:00 UTC
344   startPublicSaleStage = 1534334400; //15 Aug 2018 08:00:00 UTC
345     //end
346   endSeedStage = 1525867200; //09 May 2018 12:00:00 UTC
347   endPrivateSaleStage = 1526817600; //20 May 2018 12:00:00 UTC
348   endPreSaleStage = 1531656000; //15 Jul 2018 12:00:00 UTC
349   endPublicSaleStage = 1538308800; //30 Sep 2018 12:00:00 UTC
350 
351   // the maximum number of tokens that can 
352   // be allocated at the current stage of the ICO
353   maxSeedStage = 126000000 * 1 ether;
354   maxPrivateSaleStage = 126000000 * 1 ether;
355   maxPreSaleStage = 126000000 * 1 ether;
356   maxPublicSaleStage = 126000000 * 1 ether;   
357 
358   // rate for each stage of the ICO
359   rateSeedStage = 10000;
360   ratePrivateSaleStage = 8820;
361   ratePreSaleStage = 7644;
362   ratePublicSaleStage = 4956;   
363 
364   // address where funds are collected
365   wallet = 0x72b0FeF6BB61732e97AbA95D64B33f1345A7ABf7;  
366   
367   }
368 
369   function createTokenContract() internal returns (INV) {
370     return new INV();
371   }
372 
373   function () external payable {
374     buyTokens(msg.sender);
375   }
376 
377   function buyTokens(address beneficiary) public payable {
378     uint256 tokens;
379     uint256 weiAmount = msg.value;
380     uint256 backAmount;
381     require(beneficiary != address(0));
382     //minimum amount in ETH
383     require(weiAmount >= minPayment);
384     require(totalAllStage < totalTokens);
385     //Seed
386     if (now >= startSeedStage && now < endSeedStage && totalSeedStage < maxSeedStage){
387       tokens = weiAmount.mul(rateSeedStage);
388       if (maxSeedStage.sub(totalSeedStage) < tokens){
389         tokens = maxSeedStage.sub(totalSeedStage); 
390         weiAmount = tokens.div(rateSeedStage);
391         backAmount = msg.value.sub(weiAmount);
392       }
393       totalSeedStage = totalSeedStage.add(tokens);
394     }
395     //Private Sale
396     if (now >= startPrivateSaleStage && now < endPrivateSaleStage && totalPrivateSaleStage < maxPrivateSaleStage){
397       tokens = weiAmount.mul(ratePrivateSaleStage);
398       if (maxPrivateSaleStage.sub(totalPrivateSaleStage) < tokens){
399         tokens = maxPrivateSaleStage.sub(totalPrivateSaleStage); 
400         weiAmount = tokens.div(ratePrivateSaleStage);
401         backAmount = msg.value.sub(weiAmount);
402       }
403       totalPrivateSaleStage = totalPrivateSaleStage.add(tokens);
404     }    
405     //Pre-sale
406     if (now >= startPreSaleStage && now < endPreSaleStage && totalPreSaleStage < maxPreSaleStage){
407       tokens = weiAmount.mul(ratePreSaleStage);
408       if (maxPreSaleStage.sub(totalPreSaleStage) < tokens){
409         tokens = maxPreSaleStage.sub(totalPreSaleStage); 
410         weiAmount = tokens.div(ratePreSaleStage);
411         backAmount = msg.value.sub(weiAmount);
412       }
413       totalPreSaleStage = totalPreSaleStage.add(tokens);
414     }    
415     //Public Sale
416     if (now >= startPublicSaleStage && now < endPublicSaleStage && totalPublicSaleStage < maxPublicSaleStage){
417       tokens = weiAmount.mul(ratePublicSaleStage);
418       if (maxPublicSaleStage.sub(totalPublicSaleStage) < tokens){
419         tokens = maxPublicSaleStage.sub(totalPublicSaleStage); 
420         weiAmount = tokens.div(ratePublicSaleStage);
421         backAmount = msg.value.sub(weiAmount);
422       }
423       totalPublicSaleStage = totalPublicSaleStage.add(tokens);
424     }   
425     
426     require(tokens > 0);
427     token.mint(beneficiary, tokens);
428     totalAllStage = totalAllStage.add(tokens);
429     wallet.transfer(weiAmount);
430     
431     if (backAmount > 0){
432       msg.sender.transfer(backAmount);    
433     }
434     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
435   }
436 }