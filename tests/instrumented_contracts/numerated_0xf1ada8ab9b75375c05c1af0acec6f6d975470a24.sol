1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     if (totalSupply.add(_amount) > 1000000000000000000000000000) {
273         return false;
274     }
275 
276     totalSupply = totalSupply.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     Mint(_to, _amount);
279     Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     MintFinished();
290     return true;
291   }
292 }
293 
294 // File: contracts/TGCToken.sol
295 
296 contract TGCToken is MintableToken {
297     string public constant name = "TokensGate Coin";
298     string public constant symbol = "TGC";
299     uint8 public constant decimals = 18;
300 }
301 
302 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
303 
304 /**
305  * @title Crowdsale
306  * @dev Crowdsale is a base contract for managing a token crowdsale.
307  * Crowdsales have a start and end timestamps, where investors can make
308  * token purchases and the crowdsale will assign them tokens based
309  * on a token per ETH rate. Funds collected are forwarded to a wallet
310  * as they arrive.
311  */
312 contract Crowdsale {
313   using SafeMath for uint256;
314 
315   // The token being sold
316   MintableToken public token;
317 
318   // start and end timestamps where investments are allowed (both inclusive)
319   uint256 public startTime;
320   uint256 public endTime;
321 
322   // address where funds are collected
323   address public wallet;
324 
325   // how many token units a buyer gets per wei
326   uint256 public rate;
327 
328   // amount of raised money in wei
329   uint256 public weiRaised;
330 
331   /**
332    * event for token purchase logging
333    * @param purchaser who paid for the tokens
334    * @param beneficiary who got the tokens
335    * @param value weis paid for purchase
336    * @param amount amount of tokens purchased
337    */
338   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
339 
340 
341   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
342     require(_startTime >= now);
343     require(_endTime >= _startTime);
344     require(_rate > 0);
345     require(_wallet != address(0));
346 
347     token = createTokenContract();
348     startTime = _startTime;
349     endTime = _endTime;
350     rate = _rate;
351     wallet = _wallet;
352   }
353 
354   // creates the token to be sold.
355   // override this method to have crowdsale of a specific mintable token.
356   function createTokenContract() internal returns (MintableToken) {
357     return new MintableToken();
358   }
359 
360 
361   // fallback function can be used to buy tokens
362   function () external payable {
363     buyTokens(msg.sender);
364   }
365 
366   // low level token purchase function
367   function buyTokens(address beneficiary) public payable {
368     require(beneficiary != address(0));
369     require(validPurchase());
370 
371     uint256 weiAmount = msg.value;
372 
373     // calculate token amount to be created
374     uint256 tokens = weiAmount.mul(rate);
375 
376     // update state
377     weiRaised = weiRaised.add(weiAmount);
378 
379     token.mint(beneficiary, tokens);
380     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
381 
382     forwardFunds();
383   }
384 
385   // send ether to the fund collection wallet
386   // override to create custom fund forwarding mechanisms
387   function forwardFunds() internal {
388     wallet.transfer(msg.value);
389   }
390 
391   // @return true if the transaction can buy tokens
392   function validPurchase() internal view returns (bool) {
393     bool withinPeriod = now >= startTime && now <= endTime;
394     bool nonZeroPurchase = msg.value != 0;
395     return withinPeriod && nonZeroPurchase;
396   }
397 
398   // @return true if crowdsale event has ended
399   function hasEnded() public view returns (bool) {
400     return now > endTime;
401   }
402 
403 
404 }
405 
406 // File: contracts/TokensGate.sol
407 
408 contract TokensGate is Crowdsale {
409 
410     mapping(address => bool) public icoAddresses;
411 
412     function TokensGate (
413         uint256 _startTime,
414         uint256 _endTime,
415         uint256 _rate,
416         address _wallet
417     ) public 
418         Crowdsale(_startTime, _endTime, _rate, _wallet)
419     {
420 
421     }
422 
423     function createTokenContract() internal returns (MintableToken) {
424         return new TGCToken();
425     }
426 
427     function () external payable {
428         
429     }
430 
431     function addIcoAddress(address _icoAddress) public {
432         require(msg.sender == wallet);
433 
434         icoAddresses[_icoAddress] = true;
435     }
436 
437     function buyTokens(address beneficiary) public payable {
438         require(beneficiary == address(0));
439     }
440 
441     function mintTokens(address walletToMint, uint256 t) payable public {
442         require(walletToMint != address(0));
443         require(icoAddresses[walletToMint]);
444 
445         token.mint(walletToMint, t);
446     }
447     
448     function changeOwner(address newOwner) payable public {
449         require(msg.sender == wallet);
450         
451         wallet = newOwner;
452     }
453     
454     function tokenOwnership(address newOwner) payable public {
455         require(msg.sender == wallet);
456         
457         token.transferOwnership(newOwner);
458     }
459     
460     function setEndTime(uint256 newEndTime) payable public {
461         require(msg.sender == wallet);
462         
463         endTime = newEndTime;
464     }
465 
466 }