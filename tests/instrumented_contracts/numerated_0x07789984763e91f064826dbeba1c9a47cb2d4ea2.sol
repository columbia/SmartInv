1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
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
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public view returns (uint256) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 
216 
217 /**
218  * @title Mintable token
219  * @dev Simple ERC20 Token example, with mintable token creation
220  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
221  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
222  */
223 
224 contract MintableToken is StandardToken, Ownable {
225   event Mint(address indexed to, uint256 amount);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229 
230 
231   modifier canMint() {
232     require(!mintingFinished);
233     _;
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     Mint(_to, _amount);
246     Transfer(address(0), _to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner canMint public returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 /**
262  * @title PullPayment
263  * @dev Base contract supporting async send for pull payments. Inherit from this
264  * contract and use asyncSend instead of send.
265  */
266 contract PullPayment {
267   using SafeMath for uint256;
268 
269   mapping(address => uint256) public payments;
270   uint256 public totalPayments;
271 
272   /**
273   * @dev Called by the payer to store the sent amount as credit to be pulled.
274   * @param dest The destination address of the funds.
275   * @param amount The amount to transfer.
276   */
277   function asyncSend(address dest, uint256 amount) internal {
278     payments[dest] = payments[dest].add(amount);
279     totalPayments = totalPayments.add(amount);
280   }
281 
282   /**
283   * @dev withdraw accumulated balance, called by payee.
284   */
285   function withdrawPayments() public {
286     address payee = msg.sender;
287     uint256 payment = payments[payee];
288 
289     require(payment != 0);
290     require(this.balance >= payment);
291 
292     totalPayments = totalPayments.sub(payment);
293     payments[payee] = 0;
294 
295     assert(payee.send(payment));
296   }
297 }
298 
299 contract EvaCoin is MintableToken, PullPayment {
300     string public constant name = "EvaCoin";
301     string public constant symbol = "EVA";
302     uint8 public constant decimals = 18;
303     bool public transferAllowed = false;
304 
305     // keeper has special limited rights for the coin:
306     // pay dividends
307     address public keeper;
308 
309     // raisings in USD
310     uint256 public raisedPreSaleUSD;
311     uint256 public raisedSale1USD;
312     uint256 public raisedSale2USD;
313     uint256 public payedDividendsUSD;
314 
315     // coin issues
316     uint256 public totalSupplyPreSale = 0;
317     uint256 public totalSupplySale1 = 0;
318     uint256 public totalSupplySale2 = 0;
319 
320     enum SaleStages { PreSale, Sale1, Sale2, SaleOff }
321     SaleStages public stage = SaleStages.PreSale;
322 
323     function EvaCoin() public {
324         keeper = msg.sender; 
325     }   
326 
327     modifier onlyKeeper() {
328         require(msg.sender == keeper);
329         _;
330     }
331 
332     function sale1Started() onlyOwner public {
333         totalSupplyPreSale = totalSupply;
334         stage = SaleStages.Sale1;
335     }
336     function sale2Started() onlyOwner public {
337         totalSupplySale1 = totalSupply;
338         stage = SaleStages.Sale2;
339     }
340     function sale2Stopped() onlyOwner public {
341         totalSupplySale2 = totalSupply;
342         stage = SaleStages.SaleOff;
343     }
344 
345     // ---------------------------- dividends related definitions --------------------
346     uint constant MULTIPLIER = 10e18;
347 
348     mapping(address=>uint256) lastDividends;
349     uint public totalDividendsPerCoin;
350     uint public etherBalance;
351 
352     modifier activateDividends(address account) {
353         if (totalDividendsPerCoin != 0) { // only after first dividends payed
354             var actual = totalDividendsPerCoin - lastDividends[account];
355             var dividends = (balances[account] * actual) / MULTIPLIER;
356 
357             if (dividends > 0 && etherBalance >= dividends) {
358                 etherBalance -= dividends;
359                 lastDividends[account] = totalDividendsPerCoin;
360                 asyncSend(account, dividends);
361             }
362             //This needed for accounts with zero balance at the moment
363             lastDividends[account] = totalDividendsPerCoin;
364         }
365 
366         _;
367     }
368     function activateDividendsFunc(address account) private activateDividends(account) {}
369     // -------------------------------------------------------------------------------
370 
371 
372     // ---------------------------- sale 2 bonus definitions --------------------
373     // coins investor has before sale2 started
374     mapping(address=>uint256) sale1Coins;
375 
376     // investors who has been payed sale2 bonus
377     mapping(address=>bool) sale2Payed;
378 
379     modifier activateBonus(address account) {
380         if (stage == SaleStages.SaleOff && !sale2Payed[account]) {
381             uint256 coins = sale1Coins[account];
382             if (coins == 0) {
383                 coins = balances[account];
384             }
385             balances[account] += balances[account] * coins / (totalSupplyPreSale + totalSupplySale1);
386             sale2Payed[account] = true;
387         } else if (stage != SaleStages.SaleOff) {
388             // remember account balace before SaleOff
389             sale1Coins[account] = balances[account];
390         }
391         _;
392     }
393     function activateBonusFunc(address account) private activateBonus(account) {}
394 
395     // ----------------------------------------------------------------------
396 
397     event TransferAllowed(bool);
398 
399     modifier canTransfer() {
400         require(transferAllowed);
401         _;
402     }
403 
404     // Override StandardToken#transferFrom
405     function transferFrom(address from, address to, uint256 value) canTransfer
406     // stack too deep to call modifiers
407     // activateDividends(from) activateDividends(to) activateBonus(from) activateBonus(to)
408     public returns (bool) {
409         activateDividendsFunc(from);
410         activateDividendsFunc(to);
411         activateBonusFunc(from);
412         activateBonusFunc(to);
413         return super.transferFrom(from, to, value); 
414     }   
415     
416     // Override BasicToken#transfer
417     function transfer(address to, uint256 value) 
418     canTransfer activateDividends(to) activateBonus(to)
419     public returns (bool) {
420         return super.transfer(to, value); 
421     }
422 
423     function allowTransfer() onlyOwner public {
424         transferAllowed = true; 
425         TransferAllowed(true);
426     }
427 
428     function raisedUSD(uint256 amount) onlyOwner public {
429         if (stage == SaleStages.PreSale) {
430             raisedPreSaleUSD += amount;
431         } else if (stage == SaleStages.Sale1) {
432             raisedSale1USD += amount;
433         } else if (stage == SaleStages.Sale2) {
434             raisedSale2USD += amount;
435         } 
436     }
437 
438     function canStartSale2() public constant returns (bool) {
439         return payedDividendsUSD >= raisedPreSaleUSD + raisedSale1USD;
440     }
441 
442     // Dividents can be payed any time - even after PreSale and before Sale1
443     // ethrate - actual ETH/USD rate
444     function sendDividends(uint256 ethrate) public payable onlyKeeper {
445         require(totalSupply > 0); // some coins must be issued
446         totalDividendsPerCoin += (msg.value * MULTIPLIER / totalSupply);
447         etherBalance += msg.value;
448         payedDividendsUSD += msg.value * ethrate / 1 ether;
449     }
450 
451     // Override MintableToken#mint
452     function mint(address _to, uint256 _amount) 
453         onlyOwner canMint activateDividends(_to) activateBonus(_to) 
454         public returns (bool) {
455         super.mint(_to, _amount);
456 
457         if (stage == SaleStages.PreSale) {
458             totalSupplyPreSale += _amount;
459         } else if (stage == SaleStages.Sale1) {
460             totalSupplySale1 += _amount;
461         } else if (stage == SaleStages.Sale2) {
462             totalSupplySale2 += _amount;
463         } 
464     }
465 
466     // Override PullPayment#withdrawPayments
467     function withdrawPayments()
468         activateDividends(msg.sender) activateBonus(msg.sender)
469         public {
470         super.withdrawPayments();
471     }
472 
473     function checkPayments()
474         activateDividends(msg.sender) activateBonus(msg.sender)
475         public returns (uint256) {
476         return payments[msg.sender];
477     }
478     function paymentsOf() constant public returns (uint256) {
479         return payments[msg.sender];
480     }
481 
482     function checkBalance()
483         activateDividends(msg.sender) activateBonus(msg.sender)
484         public returns (uint256) {
485         return balanceOf(msg.sender);
486     }
487 
488     // withdraw ethers if contract has more ethers
489     // than for dividends for some reason
490     function withdraw() onlyOwner public {
491         if (this.balance > etherBalance) {
492             owner.transfer(this.balance - etherBalance);
493         }
494     }
495 
496 }