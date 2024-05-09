1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
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
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46 
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     // OwnershipTransferred(owner, newOwner);
66    emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 library Locklist {
73   
74   struct List {
75     mapping(address => bool) registry;
76   }
77   
78   function add(List storage list, address _addr)
79     internal
80   {
81     list.registry[_addr] = true;
82   }
83 
84   function remove(List storage list, address _addr)
85     internal
86   {
87     list.registry[_addr] = false;
88   }
89 
90   function check(List storage list, address _addr)
91     view
92     internal
93     returns (bool)
94   {
95     return list.registry[_addr];
96   }
97 }
98 
99 contract Locklisted is Ownable  {
100 
101   Locklist.List private _list;
102   
103   modifier onlyLocklisted() {
104     require(Locklist.check(_list, msg.sender) == true);
105     _;
106   }
107 
108   event AddressAdded(address _addr);
109   event AddressRemoved(address _addr);
110   
111   function LocklistedAddress()
112   public
113   {
114     Locklist.add(_list, msg.sender);
115   }
116 
117   function LocklistAddressenable(address _addr) onlyOwner
118     public
119   {
120     Locklist.add(_list, _addr);
121     emit AddressAdded(_addr);
122   }
123 
124   function LocklistAddressdisable(address _addr) onlyOwner
125     public
126   {
127     Locklist.remove(_list, _addr);
128    emit AddressRemoved(_addr);
129   }
130   
131   function LocklistAddressisListed(address _addr)
132   public
133   view
134   returns (bool)
135   {
136       return Locklist.check(_list, _addr);
137   }
138 }
139 
140 contract ERC20Basic {
141   uint256 public totalSupply;
142   function balanceOf(address who) public constant returns (uint256);
143   function transfer(address to, uint256 value) public returns (bool);
144   event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public constant returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 contract BasicToken is ERC20Basic,Locklisted {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) public returns (bool) {
163     require(!LocklistAddressisListed(_to));
164     require(_to != address(0));
165     require(_value <= balances[msg.sender]);
166     
167     // SafeMath.sub will throw if there is not enough balance.
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170    emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param _owner The address to query the the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address _owner) public constant returns (uint256 balance) {
180     return balances[_owner];
181   }
182 
183 }
184 
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(!LocklistAddressisListed(_to));
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204    emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220    emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    */
240   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 contract TokenFreeze is Ownable, StandardToken {
260   uint256 public unfreeze_date;
261   
262   event FreezeDateChanged(string message, uint256 date);
263 
264   function TokenFreeze() public {
265     unfreeze_date = now;
266   }
267 
268   modifier freezed() {
269     require(unfreeze_date < now);
270     _;
271   }
272 
273   function changeFreezeDate(uint256 datetime) onlyOwner public {
274     require(datetime != 0);
275     unfreeze_date = datetime;
276   emit  FreezeDateChanged("Unfreeze Date: ", datetime);
277   }
278   
279   function transferFrom(address _from, address _to, uint256 _value) freezed public returns (bool) {
280     super.transferFrom(_from, _to, _value);
281   }
282 
283   function transfer(address _to, uint256 _value) freezed public returns (bool) {
284     super.transfer(_to, _value);
285   }
286 
287 }
288 
289 
290 
291 /**
292  * @title Mintable token
293  * @dev Simple ERC20 Token example, with mintable token creation
294  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
295  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
296  */
297 
298 contract MintableToken is TokenFreeze {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301   
302   string public constant name = "Vertex";
303   string public constant symbol = "VTEX";
304   uint8 public constant decimals = 5;  // 18 is the most common number of decimal places
305   bool public mintingFinished = false;
306  
307   mapping (address => bool) public whitelist; 
308   
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     require(!LocklistAddressisListed(_to));
322     totalSupply = totalSupply.add(_amount);
323     require(totalSupply <= 30000000000000);
324     balances[_to] = balances[_to].add(_amount);
325     emit  Mint(_to, _amount);
326     emit Transfer(address(0), _to, _amount);
327     
328     return true;
329   }
330 
331   /**
332    * @dev Function to stop minting new tokens.
333    * @return True if the operation was successful.
334    */
335   function finishMinting() onlyOwner canMint public returns (bool) {
336     mintingFinished = true;
337     emit MintFinished();
338     return true;
339   }
340 }
341 
342 
343 
344 
345 contract WhitelistToken is Locklisted {
346 
347   function onlyLocklistedCanDo()
348     onlyLocklisted
349     view
350     external
351   {    
352   }
353 
354 }
355 
356 //For production, change all days to days
357 //Change and check days and discounts
358 contract Vertex_Token is Ownable,  Locklisted, MintableToken {
359     using SafeMath for uint256;
360 
361     // The token being sold
362     MintableToken public token;
363 
364     // start and end timestamps where investments are allowed (both inclusive)
365     // uint256 public PrivateSaleStartTime;
366     // uint256 public PrivateSaleEndTime;
367     uint256 public ICOStartTime = 1538380800;
368     uint256 public ICOEndTime = 1548403200;
369 
370     uint256 public hardCap = 30000000000000;
371 
372     // address where funds are collected
373     address public wallet;
374 
375     // how many token units a buyer gets per wei
376     uint256 public rate;
377     uint256 public weiRaised;
378 
379     /**
380     * event for token purchase logging
381     * @param purchaser who paid for the tokens
382     * @param beneficiary who got the tokens
383     * @param value weis paid for purchase
384     * @param amount amount of tokens purchased
385     */
386 
387     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
388     event newOraclizeQuery(string description);
389 
390     function Vertex_Token(uint256 _rate, address _wallet, uint256 _unfreeze_date)  public {
391         require(_rate > 0);
392         require(_wallet != address(0));
393 
394         token = createTokenContract();
395 
396         rate = _rate;
397         wallet = _wallet;
398         
399         token.changeFreezeDate(_unfreeze_date);
400     }
401    
402     // function startICO() onlyOwner public {
403     //     require(ICOStartTime == 0);
404     //     ICOStartTime = now;
405     //     ICOEndTime = ICOStartTime + 112 days;
406     // }
407     // function stopICO() onlyOwner public {
408     //     require(ICOEndTime > now);
409     //     ICOEndTime = now;
410     // }
411     
412     function changeTokenFreezeDate(uint256 _new_date) onlyOwner public {
413         token.changeFreezeDate(_new_date);
414     }
415     
416     function unfreezeTokens() onlyOwner public {
417         token.changeFreezeDate(now);
418     }
419 
420     // creates the token to be sold.
421     // override this method to have crowdsale of a specific mintable token.
422     function createTokenContract() internal returns (MintableToken) {
423         return new MintableToken();
424     }
425 
426     // fallback function can be used to buy tokens
427     function () payable public {
428         buyTokens(msg.sender);
429     }
430 
431     //return token price in cents
432     function getUSDPrice() public constant returns (uint256 cents_by_token) {
433         uint256 total_tokens = SafeMath.div(totalTokenSupply(), token.decimals());
434 
435         if (total_tokens > 165000000)
436             return 31;
437         else if (total_tokens > 150000000)
438             return 30;
439         else if (total_tokens > 135000000)
440             return 29;
441         else if (total_tokens > 120000000)
442             return 28;
443         else if (total_tokens > 105000000)
444             return 27;
445         else if (total_tokens > 90000000)
446             return 26;
447         else if (total_tokens > 75000000)
448             return 25;
449         else if (total_tokens > 60000000)
450             return 24;
451         else if (total_tokens > 45000000)
452             return 23;
453         else if (total_tokens > 30000000)
454             return 22;
455         else if (total_tokens > 15000000)
456             return 18;
457         else
458             return 15;
459     }
460     // function calcBonus(uint256 tokens, uint256 ethers) public constant returns (uint256 tokens_with_bonus) {
461     //     return tokens;
462     // }
463     // string 123.45 to 12345 converter
464     function stringFloatToUnsigned(string _s) payable public returns (string) {
465         bytes memory _new_s = new bytes(bytes(_s).length - 1);
466         uint k = 0;
467 
468         for (uint i = 0; i < bytes(_s).length; i++) {
469             if (bytes(_s)[i] == '.') { break; } // 1
470 
471             _new_s[k] = bytes(_s)[i];
472             k++;
473         }
474 
475         return string(_new_s);
476     }
477     // callback for oraclize 
478     // function __callback(bytes32 myid, string result) public {
479     //     if (msg.sender != oraclize_cbAddress()) revert();
480     //     string memory converted = stringFloatToUnsigned(result);
481     //     rate = parseInt(converted);
482     //     rate = SafeMath.div(1000000000000000000, rate); // price for 1 USD in WEI 
483     // }
484     // price updater 
485     // function updatePrice() payable public {
486     //     oraclize_setProof(proofType_NONE);
487     //     if (oraclize_getPrice("URL") > address(this).balance) {
488     //      emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
489     //     } else {
490     //      emit   newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
491     //         oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
492     //     }
493     // }
494     //amy
495     
496     
497      
498      function withdraw(uint amount) onlyOwner returns(bool) {
499          require(amount < this.balance);
500         wallet.transfer(amount);
501         return true;
502 
503     }
504 
505     function getBalance() public view returns (uint256) {
506         return address(this).balance;
507     }
508     
509    //end
510     // low level token purchase function
511     function buyTokens(address beneficiary) public payable {
512         require(beneficiary != address(0));
513         require(validPurchase());
514 
515         uint256 _convert_rate = SafeMath.div(SafeMath.mul(rate, getUSDPrice()), 100);
516 
517         // calculate token amount to be created
518         uint256 weiAmount = SafeMath.mul(msg.value, 10**uint256(token.decimals()));
519         uint256 tokens = SafeMath.div(weiAmount, _convert_rate);
520         require(tokens > 0);
521         
522         //do not need bonus of contrib amount calc
523         // tokens = calcBonus(tokens, msg.value.div(10**uint256(token.decimals())));
524 
525         // update state
526         weiRaised = SafeMath.add(weiRaised, msg.value);
527 
528         // token.mint(beneficiary, tokens);
529         emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
530         // updatePrice();
531         // forwardFunds();
532     }
533 
534 
535     //to send tokens for bitcoin bakers and bounty
536     function sendTokens(address _to, uint256 _amount) onlyOwner public {
537         token.mint(_to, _amount);
538     }
539     //change owner for child contract
540     function transferTokenOwnership(address _newOwner) onlyOwner public {
541         token.transferOwnership(_newOwner);
542     }
543 
544     // send ether to the fund collection wallet
545     // override to create custom fund forwarding mechanisms
546     function forwardFunds() internal {
547         wallet.transfer(address(this).balance);
548     }
549 
550     // @return true if the transaction can buy tokens
551     function validPurchase() internal constant returns (bool) {
552         bool hardCapOk = token.totalSupply() < SafeMath.mul(hardCap, 10**uint256(token.decimals()));
553        // bool withinPrivateSalePeriod = now >= PrivateSaleStartTime && now <= PrivateSaleEndTime;
554         bool withinICOPeriod = now >= ICOStartTime && now <= ICOEndTime;
555         bool nonZeroPurchase = msg.value != 0;
556         
557         // private-sale hardcap
558         uint256 total_tokens = SafeMath.div(totalTokenSupply(), token.decimals());
559         // if (withinPrivateSalePeriod && total_tokens >= 30000000)
560         // {
561         //     stopPrivateSale();
562         //     return false;
563         // }
564         
565         // return hardCapOk && (withinICOPeriod || withinPrivateSalePeriod) && nonZeroPurchase;
566          return hardCapOk && withinICOPeriod && nonZeroPurchase;
567     }
568     
569     // total supply of tokens
570     function totalTokenSupply() public view returns (uint256) {
571         return token.totalSupply();
572     }
573 }