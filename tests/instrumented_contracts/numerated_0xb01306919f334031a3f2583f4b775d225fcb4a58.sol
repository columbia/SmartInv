1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/BikeCrowdsale.sol
322 
323 //import "./BlockchainBikeToken.sol";
324 contract BikeCrowdsale is Ownable, StandardToken {
325     string public constant name = "Blockchain based Bike Token"; // name of token
326     string public constant symbol = "BBT"; // symbol of token
327     uint8 public constant decimals = 18;
328 
329     using SafeMath for uint256;
330 
331     struct Investor {
332         uint256 weiDonated;
333         uint256 tokensGiven;
334         uint256 freeTokens;
335     }
336 
337     mapping(address => Investor) participants;
338 
339     uint256 public totalSupply= 5*10**9 * 10**18; // total supply 
340     uint256 public hardCap = 1000000 * 10**18; // 1 million ether = 1 m * 10^18 Wei
341     uint256 public minimalGoal = 1000 * 10**18; // 1k ether = 1k * 10^18 Wei
342     uint256 public weiToToken = 5000; // 1 ether = 5000 tokens
343     uint256 public totalSoldTokens = 0;
344     uint256 public openingTime = 1537372800; // date -j -f "%Y-%m-%d %H:%M:%S" "2018-09-20 00:00:00" "+%s"
345     uint256 public closingTime = 1568044800; // date -j -f "%Y-%m-%d %H:%M:%S" "2019-09-10 00:00:00" "+%s";
346 
347     uint256 public totalCollected; // unit: Wei
348 
349     bool public ICOstatus = true; // true - active, false - inactive
350     bool public hardcapReached = false; // true - the cap is reached, false - the cap is not reached
351     bool public minimalgoalReached = false; // true - the goal is reached, false - the goal is not reached
352     bool public isRefundable = true; // can refund or not
353 
354     address public forSale; // fund address for sale 
355     address public ecoSystemFund; // fund address for eco-system
356     address public founders; // fund address for founders
357     address public team; // fund address for team
358     address public advisers; // fund address for advisors
359     address public bounty; // fund address for bountry
360     address public affiliate; // fund address for affiliate
361 
362     address private crowdsale;
363  
364     //BlockchainBikeToken public token;
365 
366 
367   constructor(
368     //address _token
369     ) public {
370 
371     require(hardCap > minimalGoal);
372     require(openingTime < closingTime);
373     //token = BlockchainBikeToken(_token);
374     crowdsale = address(this);
375 
376     forSale = 0xf6ACFDba39D8F786D0D2781A1D20C82E47adF8b7;
377     ecoSystemFund = 0x5A77aAE15258a2a4445C701d63dbE74016F7e629;
378     founders = 0xA80A449514541aeEcd3e17BECcC74a86e3de6bfA;
379     team = 0x309d62B8eaDF717b76296326CA35bB8f2D996B1a;
380     advisers = 0xc4319217ca328F7518c463D6D3e78f68acc5B076;
381     bounty = 0x3605e4E99efFaB70D0C84aA2beA530683824246f;
382     affiliate = 0x1709365100eD9B7c417E0dF0fdc32027af1DAff1;
383 
384     /*forSale = _forSale;
385     ecoSystemFund = _ecoSystemFund;
386     founders = _founders;
387     team = _team;
388     advisers = _advisers;
389     bounty = _bountry;
390     affiliate = _affiliate;*/
391 
392     balances[team] = totalSupply * 28 / 100;
393     balances[founders] = totalSupply * 12 / 100;
394     balances[bounty] = totalSupply * 1 / 100;
395     balances[affiliate] = totalSupply * 1 / 100;
396     balances[advisers] = totalSupply * 1 / 100;
397     balances[ecoSystemFund] = totalSupply * 5 / 100;
398     balances[forSale] = totalSupply * 52 / 100;
399 
400     emit Transfer(0x0, team, balances[team]);
401     emit Transfer(0x0, founders, balances[founders]);
402     emit Transfer(0x0, bounty, balances[bounty]);
403     emit Transfer(0x0, affiliate, balances[affiliate]);
404     emit Transfer(0x0, advisers, balances[advisers]);
405     emit Transfer(0x0, ecoSystemFund, balances[ecoSystemFund]);
406     emit Transfer(0x0, forSale, balances[forSale]);
407   }
408 
409 
410   // returns address of crowdsale token, The token must be ERC20-compliant
411   /*function getToken() view public onlyOwner() returns(address) {
412     return address(token);
413   }*/
414 
415 
416   function () external payable {
417 
418     require(msg.value >= 0.1 ether); // minimal ether to buy
419     require(now >= openingTime);
420     require(now <= closingTime);
421     require(hardCap > totalCollected);
422     require(isICOActive());
423     require(!hardcapReached);
424 
425     sellTokens(msg.sender, msg.value); // the msg.value is in wei
426   }
427 
428 
429   function sellTokens(address _recepient, uint256 _value) private
430   {
431     require(_recepient != 0x0); // 0x0 is meaning to destory(burn)
432     require(now >= openingTime && now <= closingTime);
433 
434     // the unit of the msg.value is in wei 
435 
436     // if reaching the hard cap, we allow the user to pay partial ethers and get partial tokensSold
437     // then, we will refund reset ethers to the buyer's address
438     uint256 newTotalCollected = totalCollected + _value; // unit: wei
439 
440     if (hardCap <= newTotalCollected) {
441         hardcapReached = true; // reach the hard cap
442         ICOstatus = false;  // close the ICO
443         isRefundable = false; // can't refund
444         minimalgoalReached = true;
445     }
446 
447     totalCollected = totalCollected + _value; // unit: wei
448 
449     if (minimalGoal <= newTotalCollected) {
450         minimalgoalReached = true; // reach the minimal goal (soft cap)
451         isRefundable = false; // can't refund
452     }
453 
454     uint256 tokensSold = _value * weiToToken; // token = eth * rate
455     uint256 bonusTokens = 0;
456     bonusTokens = getBonusTokens(tokensSold);
457     if (bonusTokens > 0) {
458         tokensSold += bonusTokens;
459     }
460 
461         require(balances[forSale] > tokensSold);
462         balances[forSale] -= tokensSold;
463         balances[_recepient] += tokensSold;
464         emit Transfer(forSale, _recepient, tokensSold);
465 
466     participants[_recepient].weiDonated += _value;
467     participants[_recepient].tokensGiven += tokensSold;
468 
469     totalSoldTokens += tokensSold;    // total sold tokens
470   }
471 
472 
473   function isICOActive() private returns (bool) {
474     if (now >= openingTime  && now <= closingTime && !hardcapReached) {
475         ICOstatus = true;
476     } else {
477         ICOstatus = false;
478     }
479     return ICOstatus;
480   }
481 
482 
483   function refund() public {
484     require(now >= openingTime);
485     require(now <= closingTime);
486     require(isRefundable);
487 
488     uint256 weiDonated = participants[msg.sender].weiDonated;
489     uint256 tokensGiven = participants[msg.sender].tokensGiven;
490 
491     require(weiDonated > 0);
492     require(tokensGiven > 0);
493 
494     require(forSale != msg.sender);
495     require(balances[msg.sender] >= tokensGiven); 
496 
497     balances[forSale] += tokensGiven;
498     balances[msg.sender] -= tokensGiven;
499     emit Transfer(msg.sender, forSale, tokensGiven);
500 
501     // if refundSaleTokens fail, it will throw
502     msg.sender.transfer(weiDonated);    // unit: wei, refund ether to buyer
503 
504     participants[msg.sender].weiDonated = 0;    // set balance of wei to 0
505     participants[msg.sender].tokensGiven = 0;   // set balance of token to 0
506     participants[msg.sender].freeTokens = 0; // set free token to 0
507  
508     // re-calcuate total tokens & total wei of funding
509     totalSoldTokens -= tokensGiven;
510     totalCollected -= weiDonated;
511   }
512 
513 
514   function transferICOFundingToWallet(uint256 _value) public onlyOwner() {
515         forSale.transfer(_value); // unit wei
516   }
517 
518   function getBonusTokens(uint256 _tokensSold) view public returns (uint256) {
519 
520     uint256 bonusTokens = 0;
521     uint256 bonusBeginTime = openingTime; // Sep-08
522     // date -j -f "%Y-%m-%d %H:%M:%S" "2018-09-10 00:00:00" "+%s"
523     if (now >= bonusBeginTime && now <= bonusBeginTime+86400*7) {
524         bonusTokens = _tokensSold * 20 / 100;
525     } else if (now > bonusBeginTime+86400*7 && now <= bonusBeginTime+86400*14) {
526         bonusTokens = _tokensSold * 15 / 100;
527     } else if (now > bonusBeginTime+86400*14 && now <= bonusBeginTime+86400*21) {
528         bonusTokens = _tokensSold * 10 / 100;
529     } else if (now > bonusBeginTime+86400*21 && now <= bonusBeginTime+86400*30) {
530         bonusTokens = _tokensSold * 5 / 100;
531     }
532 
533     uint256 newTotalSoldTokens = _tokensSold + bonusTokens;
534     uint256 hardCapTokens = hardCap * weiToToken;
535     if (hardCapTokens < newTotalSoldTokens) {
536         bonusTokens = 0;
537     }
538 
539     return bonusTokens;
540   }
541 
542     function getCrowdsaleStatus() view public onlyOwner() returns (bool,bool,bool,bool) {
543         return (ICOstatus,isRefundable,minimalgoalReached,hardcapReached);
544     }
545 
546   function getCurrentTime() view public onlyOwner() returns (uint256) {
547     return now;
548   }
549 
550   function sendFreeTokens(address _to, uint256 _value) public onlyOwner() {
551     require(_to != 0x0); // 0x0 is meaning to destory(burn)
552     require(participants[_to].freeTokens <= 1000); // maximum total free tokens per user
553     require(_value <= 100); // maximum free tokens per time
554     require(_value > 0);
555     require(forSale != _to);
556     require(balances[forSale] > _value);
557 
558     participants[_to].freeTokens += _value;
559     participants[_to].tokensGiven += _value;
560     totalSoldTokens += _value;    // total sold tokens
561 
562     balances[forSale] -= _value;
563     balances[_to] += _value;
564 
565     emit Transfer(forSale, _to, _value);
566   }
567 
568   // get free tokens in user's account
569   function getFreeTokensAmountOfUser(address _to) view public onlyOwner() returns (uint256) {
570     require(_to != 0x0); // 0x0 is meaning to destory(burn)
571     uint256 _tokens = 0;
572     _tokens = participants[_to].freeTokens;
573     return _tokens;
574   }
575 
576   function getBalanceOfAccount(address _to) view public onlyOwner() returns (uint256, uint256) {
577     return (participants[_to].weiDonated, participants[_to].tokensGiven);
578   }
579 
580     function transferFundsTokens(address _from, address _to, uint256 _value) public onlyOwner() {
581         require(_from == team || _from == founders || _from == bounty || _from == affiliate || _from == advisers || _from == ecoSystemFund || _from == forSale);
582         require(_to == team || _to == founders || _to == bounty || _to == affiliate || _to == advisers || _to == ecoSystemFund || _to == forSale);
583         require(_value > 0);
584         require(balances[_from] >= _value);
585         balances[_from] -= _value;
586         balances[_to] += _value;
587 
588         emit Transfer(_from, _to, _value);
589     }
590 }