1 pragma solidity ^0.4.19;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * Math operations with safety checks
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal pure returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal pure returns (uint) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint a, uint b) internal pure returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal pure returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
46     return a < b ? a : b;
47   }
48 }
49 
50 // File: contracts/ERC20.sol
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   uint256 public totalSupply;
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84  /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100  /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120   mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) public view returns (uint256) {
164     return allowed[_owner][_spender];
165   }
166 
167   /**
168    * @dev Increase the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _addedValue The amount of tokens to increase the allowance by.
176    */
177   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
178     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183   /**
184    * @dev Decrease the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To decrement
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _subtractedValue The amount of tokens to decrease the allowance by.
192    */
193   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 // File: contracts/ERC223.sol
207 
208 /**
209  * ERC20-compatible version of ERC223
210  * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible
211  */
212 contract ERC223Basic is StandardToken {
213     function transfer(address to, uint value, bytes data) public;
214     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
215 }
216 
217 /**
218  * Contract that is working with ERC223 tokens
219  */
220 contract ERC223ReceivingContract {
221     function tokenFallback(address _from, uint _value, bytes _data) public;
222 }
223 
224 /**
225  * ERC20-compatible version of ERC223
226  * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible
227  */
228 contract ERC223BasicToken is ERC223Basic {
229     using SafeMath for uint;
230 
231     /**
232      * @dev Fix for the ERC20 short address attack.
233      */
234     modifier onlyPayloadSize(uint size) {
235         require(msg.data.length >= size + 4);
236         _;
237     }
238 
239     // Function that is called when a user or another contract wants to transfer funds .
240     function transfer(address to, uint value, bytes data) onlyPayloadSize(2 * 32) public {
241         // Standard function transfer similar to ERC20 transfer with no _data .
242         // Added due to backwards compatibility reasons .
243         uint codeLength;
244 
245         assembly {
246             // Retrieve the size of the code on target address, this needs assembly .
247             codeLength := extcodesize(to)
248         }
249 
250         balances[msg.sender] = balances[msg.sender].sub(value);
251         balances[to] = balances[to].add(value);
252         if(codeLength > 0) {
253             ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
254             receiver.tokenFallback(msg.sender, value, data);
255         }
256         Transfer(msg.sender, to, value);  // ERC20 transfer event
257         Transfer(msg.sender, to, value, data);  // ERC223 transfer event
258     }
259 
260     // Standard function transfer similar to ERC20 transfer with no _data .
261     // Added due to backwards compatibility reasons .
262     function transfer(address to, uint256 value) onlyPayloadSize(2 * 32)  public returns (bool) {
263         uint codeLength;
264 
265         assembly {
266             // Retrieve the size of the code on target address, this needs assembly .
267             codeLength := extcodesize(to)
268         }
269 
270         balances[msg.sender] = balances[msg.sender].sub(value);
271         balances[to] = balances[to].add(value);
272         if(codeLength > 0) {
273             ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
274             bytes memory empty;
275             receiver.tokenFallback(msg.sender, value, empty);
276         }
277         Transfer(msg.sender, to, value);  // ERC20 transfer event
278         return true;
279     }
280 }
281 
282 // File: contracts/DogRacingToken.sol
283 
284 /**
285  * DogRacing Token
286  */
287 contract DogRacingToken is ERC223BasicToken {
288   using SafeMath for uint256;
289 
290   string constant public name = "Dog Racing";
291   string constant public symbol = "DGR";
292   uint8 constant public decimals = 3;
293   uint256 constant public totalSupply 	= 326250000 * 1000;	// Supply is in the smallest units
294 
295   address public owner;   // owner address
296 
297   modifier onlyOwner {
298     require(owner == msg.sender);
299     _;
300   }
301 
302   function DogRacingToken() public {
303     owner = msg.sender;
304     balances[owner] = totalSupply;   // All tokens are assigned to the owner
305   }
306 
307   // Owner may burn own tokens
308   function burnTokens(uint256 amount) onlyOwner external {
309     balances[owner] = balances[owner].sub(amount);
310   }
311 }
312 
313 // File: contracts/DogRacingCrowdsale.sol
314 
315 /**
316  * DogRacing Crowdsale
317  */
318 contract DogRacingCrowdsale {
319   using SafeMath for uint256;
320 
321   DogRacingToken public token;		// Token contract address
322 
323   uint256 public stage1_start;		// Crowdsale timing
324   uint256 public stage2_start;
325   uint256 public stage3_start;
326   uint256 public stage4_start;
327   uint256 public crowdsale_end;
328 
329   uint256 public stage1_price;		// Prices in token millis / ETH
330   uint256 public stage2_price;		
331   uint256 public stage3_price;		
332   uint256 public stage4_price;
333 
334   uint256 public hard_cap_wei;		// Crowdsale hard cap in wei
335 
336   address public owner;   			// Owner address
337 
338   uint256 public wei_raised;		// Total Wei raised by crowdsale
339 
340   event TokenPurchase(address buyer, uint256 weiAmount, uint256 tokensAmount);
341 
342   modifier onlyOwner {
343     require(owner == msg.sender);
344    _;
345   }
346 
347   modifier withinCrowdsaleTime {
348 	require(now >= stage1_start && now < crowdsale_end);
349 	_;
350   }
351 
352   modifier afterCrowdsale {
353 	require(now >= crowdsale_end);
354 	_;
355   }
356 
357   modifier withinCap {
358   	require(wei_raised < hard_cap_wei);
359 	_;
360   }
361 
362   // Constructor
363   function DogRacingCrowdsale(DogRacingToken _token,
364   							  uint256 _stage1_start, uint256 _stage2_start, uint256 _stage3_start, uint256 _stage4_start, uint256 _crowdsale_end,
365   							  uint256 _stage1_price, uint256 _stage2_price, uint256 _stage3_price, uint256 _stage4_price,
366   							  uint256 _hard_cap_wei) public {
367   	require(_stage1_start > now);
368   	require(_stage2_start > _stage1_start);
369   	require(_stage3_start > _stage2_start);
370   	require(_stage4_start > _stage3_start);
371   	require(_crowdsale_end > _stage4_start);
372   	require(_stage1_price > 0);
373   	require(_stage2_price < _stage1_price);
374   	require(_stage3_price < _stage2_price);
375   	require(_stage4_price < _stage3_price);
376   	require(_hard_cap_wei > 0);
377     require(_token != address(0));
378 
379   	owner = msg.sender;
380 
381   	token = _token;
382 
383   	stage1_start = _stage1_start;
384   	stage2_start = _stage2_start;
385   	stage3_start = _stage3_start;
386   	stage4_start = _stage4_start;
387   	crowdsale_end = _crowdsale_end;
388 
389   	stage1_price = _stage1_price;
390   	stage2_price = _stage2_price;
391   	stage3_price = _stage3_price;
392   	stage4_price = _stage4_price;
393 
394   	hard_cap_wei = _hard_cap_wei;
395   }
396 
397   // get current price in token millis / ETH
398   function getCurrentPrice() public view withinCrowdsaleTime returns (uint256) {
399   	if (now < stage2_start) {
400   		return stage1_price;
401   	} else if (now < stage3_start) {
402   		return stage2_price;
403   	} else if (now < stage4_start) {
404   		return stage3_price;
405   	} else {
406   		return stage4_price;
407   	}
408   }
409 
410   // get amount in token millis for amount in wei
411   function getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
412     uint256 price = getCurrentPrice();
413     return weiAmount.mul(price).div(1 ether);
414   }
415 
416   // fallback function
417   function () external payable {
418     buyTokens(msg.sender);
419   }
420 
421   // tokens fallback function
422   function tokenFallback(address, uint256, bytes) external pure {
423   }
424 
425   // tokens purchase
426   function buyTokens(address beneficiary) public withinCrowdsaleTime withinCap payable {
427    	uint256 wei_amount = msg.value;
428     
429     require(beneficiary != address(0));
430     require(wei_amount != 0);
431  
432     // calculate token amount to be sold
433     uint256 tokens = getTokenAmount(wei_amount);
434 
435     // update state
436     wei_raised = wei_raised.add(wei_amount);
437     require(wei_raised <= hard_cap_wei);
438 
439     // deliver tokens
440     token.transfer(beneficiary, tokens);
441 
442     TokenPurchase(beneficiary, wei_amount, tokens);
443 
444     // deliver ether
445     owner.transfer(msg.value);
446   }
447 
448   // Remaining tokens withdrawal
449   function withdrawTokens() external onlyOwner afterCrowdsale {
450   	uint256 tokens_remaining = token.balanceOf(address(this));
451   	token.transfer(owner, tokens_remaining);
452   }
453 
454 }