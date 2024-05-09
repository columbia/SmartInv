1 pragma solidity ^0.4.20;
2 
3 
4 
5 /* ********** Zeppelin Solidity - v1.3.0 ********** */
6 
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) public constant returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 
188 
189 /* ********** RxEAL Token Contract ********** */
190 
191 
192 
193 /**
194  * @title RxEALTokenContract
195  * @author RxEAL.com
196  *
197  * ERC20 Compatible token
198  * Zeppelin Solidity - v1.3.0
199  */
200 
201 contract RxEALTokenContract is StandardToken {
202 
203   /* ********** Token Predefined Information ********** */
204 
205   // Predefine token info
206   string public constant name = "RxEAL";
207   string public constant symbol = "RXL";
208   uint256 public constant decimals = 18;
209 
210   /* ********** Defined Variables ********** */
211 
212   // Total tokens supply 96 000 000
213   // For ethereum wallets we added decimals constant
214   uint256 public constant INITIAL_SUPPLY = 96000000 * (10 ** decimals);
215   // Vault where tokens are stored
216   address public vault = this;
217   // Sale agent who has permissions to sell tokens
218   address public salesAgent;
219   // Array of token owners
220   mapping (address => bool) public owners;
221 
222   /* ********** Events ********** */
223 
224   // Contract events
225   event OwnershipGranted(address indexed _owner, address indexed revoked_owner);
226   event OwnershipRevoked(address indexed _owner, address indexed granted_owner);
227   event SalesAgentPermissionsTransferred(address indexed previousSalesAgent, address indexed newSalesAgent);
228   event SalesAgentRemoved(address indexed currentSalesAgent);
229   event Burn(uint256 value);
230 
231   /* ********** Modifiers ********** */
232 
233   // Throws if called by any account other than the owner
234   modifier onlyOwner() {
235     require(owners[msg.sender] == true);
236     _;
237   }
238 
239   /* ********** Functions ********** */
240 
241   // Constructor
242   function RxEALTokenContract() {
243     owners[msg.sender] = true;
244     totalSupply = INITIAL_SUPPLY;
245     balances[vault] = totalSupply;
246   }
247 
248   // Allows the current owner to grant control of the contract to another account
249   function grantOwnership(address _owner) onlyOwner public {
250     require(_owner != address(0));
251     owners[_owner] = true;
252     OwnershipGranted(msg.sender, _owner);
253   }
254 
255   // Allow the current owner to revoke control of the contract from another owner
256   function revokeOwnership(address _owner) onlyOwner public {
257     require(_owner != msg.sender);
258     owners[_owner] = false;
259     OwnershipRevoked(msg.sender, _owner);
260   }
261 
262   // Transfer sales agent permissions to another account
263   function transferSalesAgentPermissions(address _salesAgent) onlyOwner public {
264     SalesAgentPermissionsTransferred(salesAgent, _salesAgent);
265     salesAgent = _salesAgent;
266   }
267 
268   // Remove sales agent from token
269   function removeSalesAgent() onlyOwner public {
270     SalesAgentRemoved(salesAgent);
271     salesAgent = address(0);
272   }
273 
274   // Transfer tokens from vault to account if sales agent is correct
275   function transferTokensFromVault(address _from, address _to, uint256 _amount) public {
276     require(salesAgent == msg.sender);
277     balances[vault] = balances[vault].sub(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Transfer(_from, _to, _amount);
280   }
281 
282   // Allow the current owner to burn a specific amount of tokens from the vault
283   function burn(uint256 _value) onlyOwner public {
284     require(_value > 0);
285     balances[vault] = balances[vault].sub(_value);
286     totalSupply = totalSupply.sub(_value);
287     Burn(_value);
288   }
289 
290 }
291 
292 
293 
294 /* ********** RxEAL Presale Contract ********** */
295 
296 
297 
298 contract RxEALTestSaleContract {
299   // Extend uint256 to use SafeMath functions
300   using SafeMath for uint256;
301 
302   /* ********** Defined Variables ********** */
303 
304   // The token being sold
305   RxEALTokenContract public token;
306 
307   // Start and end timestamps where sales are allowed (both inclusive)
308   uint256 public startTime = 1514808000;
309   uint256 public endTime = 1523448000;
310 
311   // Address where funds are collected
312   address public wallet1 = 0x56E4e5d451dF045827e214FE10bBF99D730d9683;
313   address public wallet2 = 0x8C0988711E60CfF153359Ab6CFC8d45565C6ce79;
314   address public wallet3 = 0x0EdF5c34ddE2573f162CcfEede99EeC6aCF1c2CB;
315   address public wallet4 = 0xcBdC5eE000f77f3bCc0eFeF0dc47d38911CBD45B;
316 
317   // How many token units a buyer gets per wei. Rate per ether equals rate * (10 ** token.decimals())
318   // Cap in ethers
319 
320   // Rate and cap for tier 1
321   uint256 public tier_rate_1 = 1800;
322   uint256 public tier_cap_1 = 48;
323   // Rate and cap for tier 2
324   uint256 public tier_rate_2 = 1440;
325   uint256 public tier_cap_2 = 144;
326   // Rate and cap for tier 3
327   uint256 public tier_rate_3 = 1320;
328   uint256 public tier_cap_3 = 144;
329   // Rate and cap for tier 4
330   uint256 public tier_rate_4 = 1200;
331   uint256 public tier_cap_4 = 144;
332 
333   uint256 public hard_cap;
334 
335   // Current tier
336   uint8 public current_tier = 1;
337 
338   // Amount of raised money in wei
339   uint256 public weiRaised;
340 
341   // Amount of sold tokens
342   uint256 public soldTokens;
343   uint256 public current_tier_sold_tokens;
344 
345   /* ********** Events ********** */
346 
347   // Event for token purchase logging
348   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
349 
350   /* ********** Functions ********** */
351 
352   // Constructor
353   function RxEALTestSaleContract() {
354     token = RxEALTokenContract(0xD6682Db9106e0cfB530B697cA0EcDC8F5597CD15);
355 
356     tier_cap_1 = tier_cap_1 * (10 ** token.decimals());
357     tier_cap_2 = tier_cap_2 * (10 ** token.decimals());
358     tier_cap_3 = tier_cap_3 * (10 ** token.decimals());
359     tier_cap_4 = tier_cap_4 * (10 ** token.decimals());
360 
361     hard_cap = tier_cap_1 + tier_cap_2 + tier_cap_3 + tier_cap_4;
362   }
363 
364   // Fallback function can be used to buy tokens
365   function () payable {
366     buyTokens(msg.sender);
367   }
368 
369   // Tier calculation function
370   function tier_action(
371     uint8 tier,
372     uint256 left_wei,
373     uint256 tokens_amount,
374     uint8 next_tier,
375     uint256 tier_rate,
376     uint256 tier_cap
377   ) internal returns (uint256, uint256) {
378     if (current_tier == tier) {
379       // Tokens to be sold
380       uint256 tokens_can_be_sold;
381       // Temp tokens to be sold
382       uint256 tokens_to_be_sold = left_wei.mul(tier_rate);
383       // New temporary sold tier tokens
384       uint256 new_tier_sold_tokens = current_tier_sold_tokens.add(tokens_to_be_sold);
385 
386       if (new_tier_sold_tokens >= tier_cap) {
387         // If purchase reached tier cap
388 
389         // Calculate spare tokens
390         uint256 spare_tokens = new_tier_sold_tokens.sub(tier_cap);
391         // Tokens to be sold
392         tokens_can_be_sold = tokens_to_be_sold.sub(spare_tokens);
393 
394         // Reset current tier sold tokens
395         current_tier_sold_tokens = 0;
396         // Switch to next tier
397         current_tier = next_tier;
398       } else {
399         // If purchase not reached tier cap
400 
401         // Tokens to be sold
402         tokens_can_be_sold = tokens_to_be_sold;
403         // Update current tier sold tokens
404         current_tier_sold_tokens = new_tier_sold_tokens;
405       }
406 
407       // Wei to buy amount of tokens
408       uint256 wei_amount = tokens_can_be_sold.div(tier_rate);
409       // Spare wei amount
410       left_wei = left_wei.sub(wei_amount);
411       // Tokens to be sold in purchase
412       tokens_amount = tokens_amount.add(tokens_can_be_sold);
413     }
414 
415     return (left_wei, tokens_amount);
416   }
417 
418   // Low level token purchase function
419   function buyTokens(address beneficiary) public payable {
420     require(validPurchase());
421 
422     uint256 left_wei = msg.value;
423     uint256 tokens_amount;
424 
425     (left_wei, tokens_amount) = tier_action(1, left_wei, tokens_amount, 2, tier_rate_1, tier_cap_1);
426     (left_wei, tokens_amount) = tier_action(2, left_wei, tokens_amount, 3, tier_rate_2, tier_cap_2);
427     (left_wei, tokens_amount) = tier_action(3, left_wei, tokens_amount, 4, tier_rate_3, tier_cap_3);
428     (left_wei, tokens_amount) = tier_action(4, left_wei, tokens_amount, 4, tier_rate_4, tier_cap_4);
429 
430     // Update state of raised wei amount and sold tokens ammount
431     uint256 purchase_wei_amount = msg.value.sub(left_wei);
432     weiRaised = weiRaised.add(purchase_wei_amount);
433     soldTokens = soldTokens.add(tokens_amount);
434 
435     // If have spare wei, send it back to beneficiary
436     if (left_wei > 0) {
437       beneficiary.transfer(left_wei);
438     }
439 
440     // Tranfer tokens from vault
441     token.transferTokensFromVault(msg.sender, beneficiary, tokens_amount);
442     TokenPurchase(msg.sender, beneficiary, purchase_wei_amount, tokens_amount);
443 
444     forwardFunds(purchase_wei_amount);
445   }
446 
447   // Send wei to the fund collection wallets
448   function forwardFunds(uint256 weiAmount) internal {
449     uint256 value = weiAmount.div(4);
450 
451     // If buyer sends amount of wei that can not be divided to 4 without float point, send all wei to first wallet
452     if (value.mul(4) != weiAmount) {
453       wallet1.transfer(weiAmount);
454     } else {
455       wallet1.transfer(value);
456       wallet2.transfer(value);
457       wallet3.transfer(value);
458       wallet4.transfer(value);
459     }
460   }
461 
462   // Validate if the transaction can buy tokens
463   function validPurchase() internal constant returns (bool) {
464     bool withinCap = soldTokens < hard_cap;
465     bool withinPeriod = now >= startTime && now <= endTime;
466     bool nonZeroPurchase = msg.value != 0;
467     return withinPeriod && nonZeroPurchase && withinCap;
468   }
469 
470   // Validate if crowdsale event has ended
471   function hasEnded() public constant returns (bool) {
472     return now > endTime || soldTokens >= hard_cap;
473   }
474 }