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
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     
66   address public owner;
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) onlyOwner public {
89     require(newOwner != address(0));      
90     owner = newOwner;
91   }
92 
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances. 
98  */
99 contract BasicToken is ERC20Basic, Ownable {
100   using SafeMath for uint256;
101   address public addressTeam =  0x04cFbFa64917070d7AEECd20225782240E8976dc;
102   bool public frozenAccountICO = true;
103   mapping(address => uint256) balances;
104   mapping (address => bool) public frozenAccount;
105   function setFrozenAccountICO(bool _frozenAccountICO) public onlyOwner{
106     frozenAccountICO = _frozenAccountICO;   
107   }
108   /* This generates a public event on the blockchain that will notify clients */
109   event FrozenFunds(address target, bool frozen);
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     if (msg.sender != owner && msg.sender != addressTeam){  
117       require(!frozenAccountICO); 
118     }
119     require(!frozenAccount[_to]);   // Check if recipient is frozen  
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of. 
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public constant returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) allowed;
147   
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amout of tokens to be transfered
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     if (msg.sender != owner && msg.sender != addressTeam){  
156       require(!frozenAccountICO); 
157     }    
158     require(!frozenAccount[_from]);                     // Check if sender is frozen
159     require(!frozenAccount[_to]);                       // Check if recipient is frozen      
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176 
177     // To change the approve amount you first have to reduce the addresses`
178     //  allowance to zero by calling `approve(_spender, 0)` if it is not
179     //  already 0 to mitigate the race condition described here:
180     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182 
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifing the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198 }
199 
200 
201 
202 /**
203  * @title Mintable token
204  * @dev Simple ERC20 Token example, with mintable token creation
205  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
206  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
207  */
208 contract MintableToken is StandardToken {
209   event Mint(address indexed to, uint256 amount);
210   event MintFinished();
211 
212   bool public mintingFinished = false;
213 
214 
215   modifier canMint() {
216     require(!mintingFinished);
217     _;
218   }
219 
220   /**
221    * @dev Function to mint tokens
222    * @param _to The address that will receive the minted tokens.
223    * @param _amount The amount of tokens to mint.
224    * @return A boolean that indicates if the operation was successful.
225    */
226   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
227     totalSupply = totalSupply.add(_amount);
228     balances[_to] = balances[_to].add(_amount);
229     emit Mint(_to, _amount);
230     emit Transfer(address(0), _to, _amount);
231     return true;
232   }
233 
234   /**
235    * @dev Function to stop minting new tokens.
236    * @return True if the operation was successful.
237    */
238   function finishMinting() onlyOwner canMint public returns (bool) {
239     mintingFinished = true;
240     emit MintFinished();
241     return true;
242   }
243 }
244 
245 contract MahalaCoin is Ownable, MintableToken {
246   using SafeMath for uint256;    
247   string public constant name = "Mahala Coin";
248   string public constant symbol = "MHC";
249   uint32 public constant decimals = 18;
250 
251   // address public addressTeam; 
252   uint public summTeam;
253   
254   function MahalaCoin() public {
255     summTeam =     110000000 * 1 ether;
256     //Founders and supporters initial Allocations
257     mint(addressTeam, summTeam);
258 	mint(owner, 70000000 * 1 ether);
259   }
260       /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
261     /// @param target Address to be frozen
262     /// @param freeze either to freeze it or not
263     function freezeAccount(address target, bool freeze) onlyOwner public {
264         frozenAccount[target] = freeze;
265         emit FrozenFunds(target, freeze);
266     }
267   function getTotalSupply() public constant returns(uint256){
268       return totalSupply;
269   }
270 }
271 
272 
273 
274 
275 /**
276  * @title Crowdsale
277  * @dev Crowdsale is a base contract for managing a token crowdsale.
278  * Crowdsales have a start and end timestamps, where Contributors can make
279  * token Contributions and the crowdsale will assign them tokens based
280  * on a token per ETH rate. Funds collected are forwarded to a wallet
281  * as they arrive. The contract requires a MintableToken that will be
282  * minted as contributions arrive, note that the crowdsale contract
283  * must be owner of the token in order to be able to mint it.
284  */
285 contract Crowdsale is Ownable {
286   using SafeMath for uint256;
287   // totalTokens
288   uint256 public totalTokens;
289   // soft cap
290   uint softcap;
291   // hard cap
292   uint hardcap;  
293   MahalaCoin public token;
294   // balances for softcap
295   mapping(address => uint) public balances;
296   // balances for softcap
297   mapping(address => uint) public balancesToken;  
298   // The token being offered
299 
300   // start and end timestamps where investments are allowed (both inclusive)
301   
302   //pre-sale
303     //start
304   uint256 public startPreSale;
305     //end
306   uint256 public endPreSale;
307 
308   //ico
309     //start
310   uint256 public startIco;
311     //end 
312   uint256 public endIco;    
313 
314   //token distribution
315   uint256 public maxPreSale;
316   uint256 public maxIco;
317 
318   uint256 public totalPreSale;
319   uint256 public totalIco;
320   
321   // how many token units a Contributor gets per wei
322   uint256 public ratePreSale;
323   uint256 public rateIco;   
324 
325   // address where funds are collected
326   address public wallet;
327 
328   // minimum quantity values
329   uint256 public minQuanValues; 
330   uint256 public maxQuanValues; 
331 
332 /**
333 * event for token Procurement logging
334 * @param contributor who Pledged for the tokens
335 * @param beneficiary who got the tokens
336 * @param value weis Contributed for Procurement
337 * @param amount amount of tokens Procured
338 */
339   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
340   function Crowdsale() public {
341     token = createTokenContract();
342     //soft cap
343     softcap = 5000 * 1 ether; 
344     hardcap = 20000 * 1 ether;  	
345     // min quantity values
346     minQuanValues = 100000000000000000; //0.1 eth
347     // max quantity values
348     maxQuanValues = 22 * 1 ether; //    
349     // start and end timestamps where investments are allowed
350     //Pre-sale
351       //start
352     startPreSale = 1523260800;//09 Apr 2018 08:00:00 +0000
353       //end
354     endPreSale = startPreSale + 40 * 1 days;
355   
356     //ico
357       //start
358     startIco = endPreSale;
359       //end 
360     endIco = startIco + 40 * 1 days;   
361 
362     // rate;
363     ratePreSale = 462;
364     rateIco = 231; 
365     
366     // restrictions on amounts during the crowdfunding event stages
367     maxPreSale = 30000000 * 1 ether;
368     maxIco =     60000000 * 1 ether;    
369     // address where funds are collected
370     wallet = 0x04cFbFa64917070d7AEECd20225782240E8976dc;
371   }
372 
373   function setratePreSale(uint _ratePreSale) public onlyOwner  {
374     ratePreSale = _ratePreSale;
375   }
376  
377   function setrateIco(uint _rateIco) public onlyOwner  {
378     rateIco = _rateIco;
379   }   
380   
381 
382   // fallback function can be used to Procure tokens
383   function () external payable {
384     procureTokens(msg.sender);
385   }
386   
387   function createTokenContract() internal returns (MahalaCoin) {
388     return new MahalaCoin();
389   }
390     
391   // low level token Pledge function
392   function procureTokens(address beneficiary) public payable {
393     uint256 tokens;
394     uint256 weiAmount = msg.value;
395     uint256 backAmount;
396     require(beneficiary != address(0));
397     //minimum amount in ETH
398     require(weiAmount >= minQuanValues);
399     //maximum amount in ETH
400     require(weiAmount.add(balances[msg.sender]) <= maxQuanValues);    
401     //hard cap
402     address _this = this;
403     require(hardcap > _this.balance);
404 
405     //Pre-sale
406     if (now >= startPreSale && now < endPreSale && totalPreSale < maxPreSale){
407       tokens = weiAmount.mul(ratePreSale);
408 	  if (maxPreSale.sub(totalPreSale) <= tokens){
409 	    endPreSale = now;
410 	    startIco = now;
411 	    endIco = startIco + 40 * 1 days; 
412 	  }
413       if (maxPreSale.sub(totalPreSale) < tokens){
414         tokens = maxPreSale.sub(totalPreSale); 
415         weiAmount = tokens.div(ratePreSale);
416         backAmount = msg.value.sub(weiAmount);
417       }
418       totalPreSale = totalPreSale.add(tokens);
419     }
420        
421     //ico   
422     if (now >= startIco && now < endIco && totalIco < maxIco){
423       tokens = weiAmount.mul(rateIco);
424       if (maxIco.sub(totalIco) < tokens){
425         tokens = maxIco.sub(totalIco); 
426         weiAmount = tokens.div(rateIco);
427         backAmount = msg.value.sub(weiAmount);
428       }
429       totalIco = totalIco.add(tokens);
430     }        
431 
432     require(tokens > 0);
433     balances[msg.sender] = balances[msg.sender].add(msg.value);
434     token.transfer(msg.sender, tokens);
435    // balancesToken[msg.sender] = balancesToken[msg.sender].add(tokens);
436     
437     if (backAmount > 0){
438       msg.sender.transfer(backAmount);    
439     }
440     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
441   }
442 
443   function refund() public{
444     address _this = this;
445     require(_this.balance < softcap && now > endIco);
446     require(balances[msg.sender] > 0);
447     uint value = balances[msg.sender];
448     balances[msg.sender] = 0;
449     msg.sender.transfer(value);
450   }
451   
452   function transferTokenToMultisig(address _address) public onlyOwner {
453     address _this = this;
454     require(_this.balance < softcap && now > endIco);  
455     token.transfer(_address, token.balanceOf(_this));
456   }   
457   
458   function transferEthToMultisig() public onlyOwner {
459     address _this = this;
460     require(_this.balance >= softcap && now > endIco);  
461     wallet.transfer(_this.balance);
462     token.setFrozenAccountICO(false);
463   }  
464     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
465     /// @param target Address to be frozen
466     /// @param freeze either to freeze it or not
467   function freezeAccount(address target, bool freeze) onlyOwner public {
468     token.freezeAccount(target, freeze);
469   }
470     /// @notice Create `mintedAmount` tokens and send it to `target`
471     /// @param target Address to receive the tokens
472     /// @param mintedAmount the amount of tokens it will receive
473   function mintToken(address target, uint256 mintedAmount) onlyOwner public {
474     token.mint(target, mintedAmount);
475     }  
476     
477 }