1 pragma solidity ^0.4.18;
2 
3 /**
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47     using SafeMath for uint256;
48     mapping (address => Snapshot[]) balances;
49     mapping (address => uint256) userWithdrawalBlocks;
50 	
51     /**
52      * @dev 'Snapshot' is the structure that attaches a block number to a
53      * given value, the block number attached is the one that last changed the value
54      * 'fromBlock' - is the block number that the value was generated from
55      * 'value' - is the amount of tokens at a specific block number
56      */
57     struct Snapshot {
58       uint128 fromBlock;
59       uint128 value;
60     }
61 	
62 	/**
63 	 * @dev tracks history of totalSupply
64 	 */
65     Snapshot[] totalSupplyHistory;
66     
67     /**
68      * @dev track history of 'ETH balance' for dividends
69      */
70     Snapshot[] balanceForDividendsHistory;
71 	
72 	/**
73 	* @dev transfer token for a specified address
74 	* @param to - the address to transfer to.
75 	* @param value - the amount to be transferred.
76 	*/
77 	function transfer(address to, uint256 value) public returns (bool) {
78         return doTransfer(msg.sender, to, value);
79 	}
80 	
81 	/**
82 	 * @dev internal function for transfers handling
83 	 */
84 	function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
85 	   if (_amount == 0) {
86 		   return true;
87 	   }
88      
89 	   // Do not allow transfer to 0x0 or the token contract itself
90 	   require((_to != 0) && (_to != address(this)));
91 
92 	   // If the amount being transfered is more than the balance of the
93 	   //  account the transfer returns false
94 	   var previousBalanceFrom = balanceOfAt(_from, block.number);
95 	   if (previousBalanceFrom < _amount) {
96 		   return false;
97 	   }
98 
99 	   // First update the balance array with the new value for the address
100 	   //  sending the tokens
101 	   updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
102 
103 	   // Then update the balance array with the new value for the address
104 	   //  receiving the tokens
105 	   var previousBalanceTo = balanceOfAt(_to, block.number);
106 	   require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
107 	   updateValueAtNow(balances[_to], previousBalanceTo + _amount);
108 
109 	   // An event to make the transfer easy to find on the blockchain
110 	   Transfer(_from, _to, _amount);
111 
112 	   return true;
113     }
114     
115 	/**
116 	* @dev Gets the balance of the specified address.
117 	* @param _owner The address to query the the balance of. 
118 	* @return An uint256 representing the amount owned by the passed address.
119 	*/
120 	function balanceOf(address _owner) public constant returns (uint256 balance) {
121 		return balanceOfAt(_owner, block.number);
122 	}
123 
124     /**
125      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
126      * @param _owner The address from which the balance will be retrieved
127      * @param _blockNumber The block number when the balance is queried
128      * @return The balance at `_blockNumber`
129      */
130     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
131         //  These next few lines are used when the balance of the token is
132         //  requested before a check point was ever created for this token
133         if ((balances[_owner].length == 0)|| (balances[_owner][0].fromBlock > _blockNumber)) {
134 			return 0; 
135         } else {
136             return getValueAt(balances[_owner], _blockNumber);
137         }
138     }
139 
140     /**
141      * @dev Total amount of tokens at a specific `_blockNumber`.
142      * @param _blockNumber The block number when the totalSupply is queried
143      * @return The total amount of tokens at `_blockNumber`
144      */
145     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
146         // These next few lines are used when the totalSupply of the token is
147         // requested before a check point was ever created for this token
148         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
149 			return 0;
150         } else {
151             return getValueAt(totalSupplyHistory, _blockNumber);
152         }
153     }
154 
155     /**
156      * @dev `getValueAt` retrieves the number of tokens at a given block number
157      * @param checkpoints The history of values being queried
158      * @param _block The block number to retrieve the value at
159      * @return The number of tokens being queried
160      */
161     function getValueAt(Snapshot[] storage checkpoints, uint _block) constant internal returns (uint) {
162         if (checkpoints.length == 0) return 0;
163 
164         // Shortcut for the actual value
165         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
166             return checkpoints[checkpoints.length-1].value;
167         if (_block < checkpoints[0].fromBlock) return 0;
168 
169         // Binary search of the value in the array
170         uint min = 0;
171         uint max = checkpoints.length-1;
172         while (max > min) {
173             uint mid = (max + min + 1)/ 2;
174             if (checkpoints[mid].fromBlock<=_block) {
175                 min = mid;
176             } else {
177                 max = mid-1;
178             }
179         }
180         return checkpoints[min].value;
181     }
182 
183     /**
184      * @dev `updateValueAtNow` used to update the `balances` map and the `totalSupplyHistory`
185      * @param checkpoints The history of data being updated
186      * @param _value The new number of tokens
187      */ 
188     function updateValueAtNow(Snapshot[] storage checkpoints, uint _value) internal  {
189         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
190            Snapshot storage newCheckPoint = checkpoints[ checkpoints.length++ ];
191            newCheckPoint.fromBlock =  uint128(block.number);
192            newCheckPoint.value = uint128(_value);
193         } else {
194            Snapshot storage oldCheckPoint = checkpoints[checkpoints.length-1];
195            oldCheckPoint.value = uint128(_value);
196         }
197     }
198 	
199     /**
200      * @dev This function makes it easy to get the total number of tokens
201      * @return The total number of tokens
202      */
203     function redeemedSupply() public constant returns (uint) {
204         return totalSupplyAt(block.number);
205     }
206 }
207 
208 contract Ownable {
209   address public owner;
210 
211   /**
212    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
213    * account.
214    */
215   function Ownable() public {
216     owner = msg.sender;
217   }
218 
219   /**
220    * @dev Throws if called by any account other than the owner.
221    */
222   modifier onlyOwner() {
223     require(msg.sender == owner);
224     _;
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address newOwner) public onlyOwner {
232     require(newOwner != address(0));      
233     owner = newOwner;
234   }
235 }
236 
237 contract StandardToken is ERC20, BasicToken {
238 
239   mapping (address => mapping (address => uint256)) allowed;
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248 	  return doTransfer(_from, _to, _value);
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     // To change the approve amount you first have to reduce the addresses`
258     //  allowance to zero by calling `approve(_spender, 0)` if it is not
259     //  already 0 to mitigate the race condition described here:
260     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276 
277 }
278 
279 contract MintableToken is StandardToken {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282   
283   bool public mintingFinished = false;
284 
285   string public name = "Honey Mining Token";		
286   string public symbol = "HMT";		
287   uint8 public decimals = 8;		
288 
289   modifier canMint() {
290     require(!mintingFinished);
291     _;
292   }
293 
294   /**
295    * @dev Function to mint tokens
296    * @param _to The address that will receive the minted tokens.
297    * @param _amount The amount of tokens to mint.
298    * @return A boolean that indicates if the operation was successful.
299    */
300   function mint(address _to, uint256 _amount) public canMint returns (bool) {
301     totalSupply = totalSupply.add(_amount);
302 	uint curTotalSupply = redeemedSupply();
303 	require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
304 	uint previousBalanceTo = balanceOf(_to);
305 	require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
306 	updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
307     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
308     Mint(_to, _amount);
309     Transfer(0x0, _to, _amount);
310     return true;
311   }
312   
313   /**
314    * @dev Function to record snapshot block and amount
315    */
316   function recordDeposit(uint256 _amount) public {
317 	 updateValueAtNow(balanceForDividendsHistory, _amount);
318   }
319   
320   /**
321    * @dev Function to stop minting new tokens.
322    * @return True if the operation was successful.
323    */
324   function finishMinting() public returns (bool) {
325     mintingFinished = true;
326     MintFinished();
327     return true;
328   }
329   
330   /**
331    * @dev Function to calculate dividends
332    * @return awailable for withdrawal ethere (wei value)
333    */
334   function awailableDividends(address userAddress) public view returns (uint256) {
335       uint256 userLastWithdrawalBlock = userWithdrawalBlocks[userAddress];
336       uint256 amountForWithdraw = 0;
337       for(uint i = 0; i<=balanceForDividendsHistory.length-1; i++){
338           Snapshot storage snapshot = balanceForDividendsHistory[i];
339           if(userLastWithdrawalBlock < snapshot.fromBlock)
340             amountForWithdraw = amountForWithdraw.add(balanceOfAt(userAddress, snapshot.fromBlock).mul(snapshot.value).div(totalSupplyAt(snapshot.fromBlock)));
341       }
342       return amountForWithdraw;
343   }
344   
345   /**
346    * @dev Function to record user withdrawal 
347    */
348   function recordWithdraw(address userAddress) public {
349     userWithdrawalBlocks[userAddress] = balanceForDividendsHistory[balanceForDividendsHistory.length-1].fromBlock;
350   }
351 }
352 
353 contract HoneyMiningToken is Ownable {
354     
355   using SafeMath for uint256;
356 
357   MintableToken public token;
358   /**
359    * @dev Info of max supply
360    */
361   uint256 public maxSupply = 300000000000000;
362   
363   /**
364    * event for token purchase logging
365    * @param purchaser who paid for the tokens, basically - 0x0, but could be user address on refferal case
366    * @param beneficiary who got the tokens
367    * @param value weis paid for purchase
368    * @param amount - of tokens purchased
369    */
370   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
371   
372   /**
373    * event for referral comission logging
374    * @param purchaser who paid for the tokens
375    * @param beneficiary who got the bonus tokens
376    * @param amount - of tokens as ref reward
377    */
378   event ReferralBonus(address indexed purchaser, address indexed beneficiary, uint amount);
379   
380    /**
381    * event for token dividends deposit logging
382    * @param amount - amount of ETH deposited
383    */
384   event DepositForDividends(uint256 indexed amount);
385   
386   /**
387    * event for dividends withdrawal logging 
388    * @param holder - who has the tokens
389    * @param amount - amount of ETH which was withdraw
390   */
391   event WithdrawDividends(address indexed holder, uint256 amount);
392 
393   /**
394    * event for dev rewards logging
395    * @param purchaser - who paid for the tokens
396    * @param amount  - representation of dev reward
397    */
398   event DevReward(address purchaser, uint amount);
399 
400   function HoneyMiningToken() public {
401     token = new MintableToken();
402   }
403 
404   /**
405    * @dev fallback function can be used to buy tokens
406    */
407   function () public payable {buyTokens(0x0);}
408 
409   /**
410    * @dev low level token purchase function
411    * @param referrer - optional parameter for ref bonus
412    */
413   function buyTokens(address referrer) public payable {
414     require(msg.sender != 0x0);
415     require(msg.sender != referrer);
416     require(validPurchase());
417     
418     //we dont need 18 decimals - and will use only 8
419     uint256 amount = msg.value.div(10000000000);
420     
421     // calculate token amount to be created
422     uint256 tokens = amount.mul(rate());
423     require(tokens >= 100000000);
424     uint256 devTokens = tokens.mul(30).div(100);
425     if(referrer != 0x0){
426        require(token.balanceOf(referrer) >= 100000000);
427        // 2.5% for referral and referrer
428        uint256 refTokens = tokens.mul(25).div(1000);
429        //tokens = tokens+refTokens;
430        require(maxSupply.sub(redeemedSupply()) >= tokens.add(refTokens.mul(2)).add(devTokens));
431        
432        //generate tokens for purchser
433        token.mint(msg.sender, tokens.add(refTokens));
434        TokenPurchase(msg.sender, msg.sender, amount, tokens.add(refTokens));
435        token.mint(referrer, refTokens);
436        ReferralBonus(msg.sender, referrer, refTokens);
437        
438     } else{
439         require(maxSupply.sub(redeemedSupply())>=tokens.add(devTokens));
440         //updatedReddemedSupply = redeemedSupply().add(tokens.add(devTokens));
441         
442         //generate tokens for purchser
443         token.mint(msg.sender, tokens);
444     
445         // log purchase
446         TokenPurchase(msg.sender, msg.sender, amount, tokens);
447     }
448     token.mint(owner, devTokens);
449     DevReward(msg.sender, devTokens);
450     forwardFunds();
451   }
452 
453   /**
454    * @return true if the transaction can buy tokens
455    */
456   function validPurchase() internal constant returns (bool) {
457     return !hasEnded() && msg.value != 0;
458   }
459 
460   /**
461    * @return true if sale is over
462    */
463   function hasEnded() public constant returns (bool) {
464     return maxSupply <= redeemedSupply();
465   }
466   
467   /**
468    * @dev get current user balance
469    * @param userAddress - address of user
470    * @return current balance of tokens
471    */
472   function checkBalance(address userAddress) public constant returns (uint){
473       return token.balanceOf(userAddress);
474   }
475   
476   /**
477    * @dev get user balance of tokens on specific block
478    * @param userAddress - address of user
479    * @param targetBlock - block number
480    * @return address balance on block
481    */
482   function checkBalanceAt(address userAddress, uint256 targetBlock) public constant returns (uint){
483       return token.balanceOfAt(userAddress, targetBlock);
484   }
485   
486   /**
487    * @dev get awailable dividends for withdrawal
488    * @param userAddress - target 
489    * @return amount of ether (wei value) for current user
490    */
491   function awailableDividends(address userAddress) public constant returns (uint){
492     return token.awailableDividends(userAddress);
493   }
494   
495   /**
496    * @return total purchased tokens value
497    */
498   function redeemedSupply() public view returns (uint){
499     return token.totalSupply();
500   }
501   
502   /**
503    * @dev user-related method for withdrawal dividends
504    */
505   function withdrawDividends() public {
506     uint _amount = awailableDividends(msg.sender);
507     require(_amount > 0);
508     msg.sender.transfer(_amount);
509     token.recordWithdraw(msg.sender);
510     WithdrawDividends(msg.sender, _amount);
511   }
512   
513   /**
514    * @dev function for deposit ether to token address as/for dividends
515    */
516   function depositForDividends() public payable onlyOwner {
517       require(msg.value > 0);
518       token.recordDeposit(msg.value);
519       DepositForDividends(msg.value);
520   }
521   
522   function stopSales() public onlyOwner{
523    maxSupply = token.totalSupply();
524   }
525    
526   function forwardFunds() internal {
527     owner.transfer(msg.value);
528   }
529   
530   function rate() internal constant returns (uint) {
531     if(redeemedSupply() < 1000000000000)
532         return 675;
533     else if (redeemedSupply() < 5000000000000)
534         return 563;
535     else
536         return 450;
537   }
538 }