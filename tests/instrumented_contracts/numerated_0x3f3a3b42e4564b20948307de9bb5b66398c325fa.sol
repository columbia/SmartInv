1 pragma solidity ^0.4.21;
2 
3 
4 
5 /* ************************************************ */
6 /* ********** Zeppelin Solidity - v1.5.0 ********** */
7 /* ************************************************ */
8 
9 
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   uint256 public totalSupply;
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public view returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public view returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * @dev Increase the amount of tokens that an owner allowed to a spender.
165    *
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    * @param _spender The address which will spend the funds.
171    * @param _addedValue The amount of tokens to increase the allowance by.
172    */
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   /**
180    * @dev Decrease the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To decrement
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _subtractedValue The amount of tokens to decrease the allowance by.
188    */
189   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190     uint oldValue = allowed[msg.sender][_spender];
191     if (_subtractedValue > oldValue) {
192       allowed[msg.sender][_spender] = 0;
193     } else {
194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195     }
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200 }
201 
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209   address public owner;
210 
211 
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215   /**
216    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217    * account.
218    */
219   function Ownable() public {
220     owner = msg.sender;
221   }
222 
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232 
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address newOwner) public onlyOwner {
238     require(newOwner != address(0));
239     OwnershipTransferred(owner, newOwner);
240     owner = newOwner;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Claimable
248  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
249  * This allows the new owner to accept the transfer.
250  */
251 contract Claimable is Ownable {
252   address public pendingOwner;
253 
254   /**
255    * @dev Modifier throws if called by any account other than the pendingOwner.
256    */
257   modifier onlyPendingOwner() {
258     require(msg.sender == pendingOwner);
259     _;
260   }
261 
262   /**
263    * @dev Allows the current owner to set the pendingOwner address.
264    * @param newOwner The address to transfer ownership to.
265    */
266   function transferOwnership(address newOwner) onlyOwner public {
267     pendingOwner = newOwner;
268   }
269 
270   /**
271    * @dev Allows the pendingOwner address to finalize the transfer.
272    */
273   function claimOwnership() onlyPendingOwner public {
274     OwnershipTransferred(owner, pendingOwner);
275     owner = pendingOwner;
276     pendingOwner = address(0);
277   }
278 }
279 
280 
281 
282 /* *********************************** */
283 /* ********** Xmoneta Token ********** */
284 /* *********************************** */
285 
286 
287 
288 /**
289  * @title XmonetaToken
290  * @author Xmoneta.com
291  *
292  * ERC20 Compatible token
293  * Zeppelin Solidity - v1.5.0
294  */
295 
296 contract XmonetaToken is StandardToken, Claimable {
297 
298   /* ********** Token Predefined Information ********** */
299 
300   string public constant name = "Xmoneta Token";
301   string public constant symbol = "XMN";
302   uint256 public constant decimals = 18;
303 
304   /* ********** Defined Variables ********** */
305 
306   // Total tokens supply 1 000 000 000
307   // For ethereum wallets we added decimals constant
308   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
309   // Vault where tokens are stored
310   address public vault = msg.sender;
311   // Sales agent who has permissions to manipulate with tokens
312   address public salesAgent;
313 
314   /* ********** Events ********** */
315 
316   event SalesAgentAppointed(address indexed previousSalesAgent, address indexed newSalesAgent);
317   event SalesAgentRemoved(address indexed currentSalesAgent);
318   event Burn(uint256 valueToBurn);
319 
320   /* ********** Functions ********** */
321 
322   // Contract constructor
323   function XmonetaToken() public {
324     owner = msg.sender;
325     totalSupply = INITIAL_SUPPLY;
326     balances[vault] = totalSupply;
327   }
328 
329   // Appoint sales agent of token
330   function setSalesAgent(address newSalesAgent) onlyOwner public {
331     SalesAgentAppointed(salesAgent, newSalesAgent);
332     salesAgent = newSalesAgent;
333   }
334 
335   // Remove sales agent from token
336   function removeSalesAgent() onlyOwner public {
337     SalesAgentRemoved(salesAgent);
338     salesAgent = address(0);
339   }
340 
341   // Transfer tokens from vault to account if sales agent is correct
342   function transferTokensFromVault(address fromAddress, address toAddress, uint256 tokensAmount) public {
343     require(salesAgent == msg.sender);
344     balances[vault] = balances[vault].sub(tokensAmount);
345     balances[toAddress] = balances[toAddress].add(tokensAmount);
346     Transfer(fromAddress, toAddress, tokensAmount);
347   }
348 
349   // Allow the owner to burn a specific amount of tokens from the vault
350   function burn(uint256 valueToBurn) onlyOwner public {
351     require(valueToBurn > 0);
352     balances[vault] = balances[vault].sub(valueToBurn);
353     totalSupply = totalSupply.sub(valueToBurn);
354     Burn(valueToBurn);
355   }
356 
357 }
358 
359 
360 
361 /* ************************************** */
362 /* ************ Xmoneta Sale ************ */
363 /* ************************************** */
364 
365 
366 
367 /**
368  * @title XmonetaSale
369  * @author Xmoneta.com
370  *
371  * Zeppelin Solidity - v1.5.0
372  */
373 
374 contract XmonetaSale {
375 
376   using SafeMath for uint256;
377 
378   /* ********** Defined Variables ********** */
379 
380   // The token being sold
381   XmonetaToken public token;
382   // Crowdsale start timestamp - 03/13/2018 at 12:00pm (UTC)
383   uint256 public startTime = 1520942400;
384   // Crowdsale end timestamp - 05/31/2018 at 12:00pm (UTC)
385   uint256 public endTime = 1527768000;
386   // Addresses where ETH are collected
387   address public wallet1 = 0x36A3c000f8a3dC37FCD261D1844efAF851F81556;
388   address public wallet2 = 0x8beDBE45Aa345938d70388E381E2B6199A15B3C3;
389   // How many token per wei
390   uint256 public rate = 20000;
391   // Cap in ethers
392   uint256 public cap = 8000 * 1 ether;
393   // Amount of raised wei
394   uint256 public weiRaised;
395 
396   // Round B start timestamp - 05/04/2018 at 12:00pm (UTC)
397   uint256 public round_b_begin_date = 1522929600;
398   // Round B start timestamp - 30/04/2018 at 12:00pm (UTC)
399   uint256 public round_c_begin_date = 1525089600;
400 
401   /* ********** Events ********** */
402 
403   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount, uint256 tokens);
404 
405   /* ********** Functions ********** */
406 
407   // Contract constructor
408   function XmonetaSale() public {
409     token = XmonetaToken(0x99705A8B60d0fE21A4B8ee54DB361B3C573D18bb);
410   }
411 
412   // Fallback function to buy tokens
413   function () public payable {
414     buyTokens(msg.sender);
415   }
416 
417   // Bonus calculation for transaction
418   function bonus_calculation() internal returns (uint256, uint256) {
419     // Round A Standard bonus & Extra bonus
420     uint256 bonusPercent = 30;
421     uint256 extraBonusPercent = 50;
422 
423     if (now >= round_c_begin_date) {
424       // Round C Standard bonus & Extra bonus
425       bonusPercent = 10;
426       extraBonusPercent = 30;
427     } else if (now >= round_b_begin_date) {
428       // Round B Standard bonus & Extra bonus
429       bonusPercent = 20;
430       extraBonusPercent = 40;
431     }
432 
433     return (bonusPercent, extraBonusPercent);
434   }
435 
436   // Token purchase function
437   function buyTokens(address beneficiary) public payable {
438     require(validPurchase());
439 
440     uint256 weiAmount = msg.value;
441 
442     // Send spare wei back if investor sent more that cap
443     uint256 tempWeiRaised = weiRaised.add(weiAmount);
444     if (tempWeiRaised > cap) {
445       uint256 spareWeis = tempWeiRaised.sub(cap);
446       weiAmount = weiAmount.sub(spareWeis);
447       beneficiary.transfer(spareWeis);
448     }
449 
450     // Define standard and extra bonus variables
451     uint256 bonusPercent;
452     uint256 extraBonusPercent;
453 
454     // Execute calculation
455     (bonusPercent, extraBonusPercent) = bonus_calculation();
456 
457     // Accept extra bonus if beneficiary send more that 1 ETH
458     if (weiAmount >= 1 ether) {
459       bonusPercent = extraBonusPercent;
460     }
461 
462     // Token calculations with bonus
463     uint256 additionalPercentInWei = rate.div(100).mul(bonusPercent);
464     uint256 rateWithPercents = rate.add(additionalPercentInWei);
465 
466     // Calculate token amount to be sold
467     uint256 tokens = weiAmount.mul(rateWithPercents);
468 
469     // Update state
470     weiRaised = weiRaised.add(weiAmount);
471 
472     // Tranfer tokens from vault
473     token.transferTokensFromVault(msg.sender, beneficiary, tokens);
474     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
475 
476     forwardFunds(weiAmount);
477   }
478 
479   // Send wei to the fund collection wallets
480   function forwardFunds(uint256 weiAmount) internal {
481     uint256 value = weiAmount.div(2);
482 
483     // If buyer send amount of wei that can not be divided to 2 without float point, send all weis to first wallet
484     if (value.mul(2) != weiAmount) {
485       wallet1.transfer(weiAmount);
486     } else {
487       wallet1.transfer(value);
488       wallet2.transfer(value);
489     }
490   }
491 
492   // Validate if the transaction can be success
493   function validPurchase() internal constant returns (bool) {
494     bool withinCap = weiRaised < cap;
495     bool withinPeriod = now >= startTime && now <= endTime;
496     bool nonZeroPurchase = msg.value != 0;
497     return withinPeriod && nonZeroPurchase && withinCap;
498   }
499 
500   // Show if crowdsale has ended or no
501   function hasEnded() public constant returns (bool) {
502     return now > endTime || weiRaised >= cap;
503   }
504 
505 }