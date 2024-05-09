1 pragma solidity ^0.4.18;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(address _owner, address _spender) public view returns (uint256) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   /**
213    * @dev Decrease the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To decrement
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _subtractedValue The amount of tokens to decrease the allowance by.
221    */
222   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223     uint oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue > oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 /**
236  * @title Mintable token
237  * @dev Simple ERC20 Token example, with mintable token creation
238  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
239  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
240  */
241 
242 contract MintableToken is StandardToken, Ownable {
243   event Mint(address indexed to, uint256 amount);
244   event MintFinished();
245 
246   bool public mintingFinished = false;
247 
248 
249   modifier canMint() {
250     require(!mintingFinished);
251     _;
252   }
253 
254   /**
255    * @dev Function to mint tokens
256    * @param _to The address that will receive the minted tokens.
257    * @param _amount The amount of tokens to mint.
258    * @return A boolean that indicates if the operation was successful.
259    */
260   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
261     totalSupply = totalSupply.add(_amount);
262     balances[_to] = balances[_to].add(_amount);
263     Mint(_to, _amount);
264     Transfer(address(0), _to, _amount);
265     return true;
266   }
267 
268   /**
269    * @dev Function to stop minting new tokens.
270    * @return True if the operation was successful.
271    */
272   function finishMinting() onlyOwner canMint public returns (bool) {
273     mintingFinished = true;
274     MintFinished();
275     return true;
276   }
277 }
278 
279 contract REPOExchange is MintableToken {
280 
281   uint public deal_cancel_rate = 0;
282 
283   struct REPODeal {
284     address lender;
285     address borrower;
286 
287     address collateral;
288     address pledge;
289 
290     uint collateralAmount;
291     uint pledgeAmount;
292 
293     uint interest;
294     uint lenderFee;
295     uint borrowerFee;
296 
297     uint pledgeUntil;
298     uint collateralUntil;
299     uint endsAt;
300 
301     int state;
302 
303     /* 0 - inited
304        1 - pledge payed
305        2 - collateral transfered to contract and then to borrower, contract started
306        3 - collateral returned to contract in time, pledge and the rest of payment went back, collateral returned, contract successfully closed
307 
308        negative codes mean negative result
309 
310        0 -> -1 pledge was not success fully payed
311        0 -> -10 pledge was not success fully payed, but borrower paid in tokens
312 
313        1 -> -2 refused to provide collateral, need to return pledge and payment
314        1 -> -20 refused to provide collateral, need to return pledge and payment, collateralter paid in tokens
315 
316        2 -> -3 collateral was not returned in time, pledge and payment transfered to collateralter
317     */
318 
319   }
320 
321   event NewDeal(uint dealID, address lender, address borrower, address collateral, address pledge, uint collateralAmount, uint pledgeAmount,
322        uint interest, uint lenderFee_, uint borrowerFee_, uint pledgeUntil, uint collateralUntil, uint endsAt);
323 
324   event PledgePayed(uint dealID);
325   event PledgeNotPayed(uint dealID);
326   event PledgePaymentCanceled(uint dealID);
327 
328   event CollateralTransfered(uint dealID);
329   event CollateralNotTransfered(uint dealID);
330   event CollateralTransferCanceled(uint dealID);
331 
332   event CollateralReturned(uint dealID);
333   event CollateralNotReturned(uint dealID);
334 
335   event DealCancelRate(uint dealCancelRate);
336 
337   function setDealCancelRate(uint deal_cancel_rate_) public {
338     require(msg.sender == owner);
339     deal_cancel_rate = deal_cancel_rate_;
340     DealCancelRate(deal_cancel_rate);
341   }
342 
343   function getDealCancelRate() public constant returns (uint _deal_cancel_rate) {
344     return deal_cancel_rate;
345   }
346 
347 
348   uint lastDealID;
349   mapping (uint => REPODeal) deals;
350 
351   function REPOExchange() public {
352   }
353 
354   function() public {
355     revert();
356   }
357 
358   function newDeal(address lender_, address borrower_, address collateral_, address pledge_, uint collateralAmount_, uint pledgeAmount_,
359     uint interest_, uint lenderFee_, uint borrowerFee_, uint pledgeUntil_, uint collateralUntil_, uint endsAt_) public returns (uint dealID) {
360     require(msg.sender == owner);
361     dealID = lastDealID++;
362     deals[dealID] = REPODeal(lender_, borrower_, collateral_, pledge_, collateralAmount_, pledgeAmount_,
363       interest_, lenderFee_, borrowerFee_, pledgeUntil_, collateralUntil_, endsAt_, 0);
364 
365     NewDeal(dealID, lender_, borrower_, collateral_, pledge_, collateralAmount_, pledgeAmount_,
366       interest_, lenderFee_, borrowerFee_, pledgeUntil_, collateralUntil_, endsAt_);
367   }
368 
369   function payPledge(uint dealID) public payable {
370     REPODeal storage deal = deals[dealID];
371     require(deal.state == 0);
372     require(block.number < deal.pledgeUntil);
373     require(msg.sender == deal.borrower);
374 
375     uint payment = deal.pledgeAmount + deal.borrowerFee;
376     if (deal.pledge == 0) {
377       require(msg.value == payment);
378     } else {
379       require(ERC20(deal.pledge).transferFrom(msg.sender, this, payment));
380     }
381     //all is ok, now contract has pledge
382     deal.state = 1;
383     PledgePayed(dealID);
384   }
385 
386   function cancelPledgePayment(uint dealID) public {
387     REPODeal storage deal = deals[dealID];
388     require(deal.state == 0);
389     require(msg.sender == deal.borrower);
390     require(this.transferFrom(msg.sender, owner, deal_cancel_rate));
391     deal.state = -10;
392     PledgePaymentCanceled(dealID);
393   }
394 
395   function notifyPledgeNotPayed(uint dealID) public {
396     REPODeal storage deal = deals[dealID];
397     require(deal.state == 0);
398     require(block.number >= deal.pledgeUntil);
399     deal.state = -1;
400     PledgeNotPayed(dealID);
401   }
402 
403   function transferCollateral(uint dealID) public payable {
404     REPODeal storage deal = deals[dealID];
405     require(deal.state == 1);
406     require(block.number < deal.collateralUntil);
407     require(msg.sender == deal.lender);
408 
409     uint payment = deal.collateralAmount + deal.lenderFee;
410     if (deal.collateral == 0) {
411       require(msg.value == payment);
412       require(deal.borrower.send(deal.collateralAmount));
413       require(owner.send(deal.lenderFee));
414     } else {
415       require(ERC20(deal.collateral).transferFrom(msg.sender, deal.borrower, deal.collateralAmount));
416       require(ERC20(deal.collateral).transferFrom(msg.sender, owner, deal.lenderFee));
417     }
418 
419     sendGoods(deal.pledge, owner, deal.borrowerFee);
420 
421     deal.state = 2;
422     CollateralTransfered(dealID);
423   }
424 
425   function cancelCollateralTransfer(uint dealID) public {
426     REPODeal storage deal = deals[dealID];
427     require(deal.state == 1);
428     require(msg.sender == deal.lender);
429     require(this.transferFrom(msg.sender, owner, deal_cancel_rate));
430 
431     sendGoods(deal.pledge, deal.borrower, deal.pledgeAmount + deal.borrowerFee);
432 
433     deal.state = -20;
434     CollateralTransferCanceled(dealID);
435   }
436 
437   function notifyCollateralNotTransfered(uint dealID) public {
438     REPODeal storage deal = deals[dealID];
439     require(deal.state == 1);
440     require(block.number >= deal.collateralUntil);
441 
442     sendGoods(deal.pledge, deal.borrower, deal.pledgeAmount + deal.borrowerFee);
443 
444     deal.state = -2;
445     CollateralNotTransfered(dealID);
446   }
447 
448   function sendGoods(address goods, address to, uint amount) private {
449     if (goods == 0) {
450       require(to.send(amount));
451     } else {
452       require(ERC20(goods).transfer(to, amount));
453     }
454   }
455 
456   function returnCollateral(uint dealID) public payable {
457     REPODeal storage deal = deals[dealID];
458     require(deal.state == 2);
459     require(block.number < deal.endsAt);
460     require(msg.sender == deal.borrower);
461 
462     uint payment = deal.collateralAmount + deal.interest;
463     if (deal.collateral == 0) {
464       require(msg.value == payment);
465       require(deal.lender.send(msg.value));
466     } else {
467       require(ERC20(deal.collateral).transferFrom(msg.sender, deal.lender, payment));
468     }
469 
470     sendGoods(deal.pledge, deal.borrower, deal.pledgeAmount);
471 
472     deal.state = 3;
473     CollateralReturned(dealID);
474   }
475 
476   function notifyCollateralNotReturned(uint dealID) public {
477     REPODeal storage deal = deals[dealID];
478     require(deal.state == 2);
479     require(block.number >= deal.endsAt);
480 
481     sendGoods(deal.pledge, deal.lender, deal.pledgeAmount);
482 
483     deal.state = -3;
484     CollateralNotReturned(dealID);
485   }
486 }