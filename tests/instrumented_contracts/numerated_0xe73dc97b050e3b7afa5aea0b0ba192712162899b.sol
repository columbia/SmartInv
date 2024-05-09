1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title Burnable Token
109  * @dev Token that can be irreversibly burned (destroyed).
110  */
111 contract BurnableToken is BasicToken {
112 
113   event Burn(address indexed burner, uint256 value);
114 
115   /**
116    * @dev Burns a specific amount of tokens.
117    * @param _value The amount of token to be burned.
118    */
119   function burn(uint256 _value) public {
120     require(_value <= balances[msg.sender]);
121     // no need to require value <= totalSupply, since that would imply the
122     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
123 
124     address burner = msg.sender;
125     balances[burner] = balances[burner].sub(_value);
126     totalSupply_ = totalSupply_.sub(_value);
127     Burn(burner, _value);
128     Transfer(burner, address(0), _value);
129   }
130 }
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public view returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 /**
239  * @title Ownable
240  * @dev The Ownable contract has an owner address, and provides basic authorization control
241  * functions, this simplifies the implementation of "user permissions".
242  */
243 contract Ownable {
244   address public owner;
245 
246 
247   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249 
250   /**
251    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252    * account.
253    */
254   function Ownable() public {
255     owner = msg.sender;
256   }
257 
258   /**
259    * @dev Throws if called by any account other than the owner.
260    */
261   modifier onlyOwner() {
262     require(msg.sender == owner);
263     _;
264   }
265 
266   /**
267    * @dev Allows the current owner to transfer control of the contract to a newOwner.
268    * @param newOwner The address to transfer ownership to.
269    */
270   function transferOwnership(address newOwner) public onlyOwner {
271     require(newOwner != address(0));
272     OwnershipTransferred(owner, newOwner);
273     owner = newOwner;
274   }
275 
276 }
277 
278 contract BRANDCOIN is StandardToken, BurnableToken, Ownable
279 {
280     // ERC20 token parameters
281     string public constant name = "BRANDCOIN";
282     string public constant symbol = "BRA";
283     uint256 public constant decimals = 18;
284     
285     // Crowdsale base price
286     uint256 public ETH_per_BRA = 0.00024261 ether;
287     
288     // 15 april - 30 april: 43% bonus for purchases of at least 1000 BRA
289     uint256 private first_period_start_date = 1523750400;
290     uint256 private constant first_period_bonus_percentage = 43;
291     uint256 private constant first_period_bonus_minimum_purchased_BRA = 1000 * (uint256(10) ** decimals);
292     
293     // 1 may - 7 may: 15% bonus
294     uint256 private second_period_start_date = 1525132800;
295     uint256 private constant second_period_bonus_percentage = 15;
296     
297     // 8 may - 14 may: 10% bonus
298     uint256 private third_period_start_date = 1525737600;
299     uint256 private constant third_period_bonus_percentage = 10;
300     
301     // 15 may - 21 may: 6% bonus
302     uint256 private fourth_period_start_date = 1526342400;
303     uint256 private constant fourth_period_bonus_percentage = 6;
304     
305     // 22 may - 31 may: 3% bonus
306     uint256 private fifth_period_start_date = 1526947200;
307     uint256 private constant fifth_period_bonus_percentage = 3;
308     
309     // End of ICO: 1 june
310     uint256 private crowdsale_end_timestamp = 1527811200;
311     
312     // The target of the crowdsale is 8000000 BRANDCOIN's.
313     // If the crowdsale has finished, and the target has not been reached,
314     // all crowdsale participants will be able to call refund() and get their
315     // ETH back. The refundMany() function can be used to refund multiple
316     // participants in one transaction.
317     uint256 public constant crowdsaleTargetBRA = 8000000 * (uint256(10) ** decimals);
318     
319     
320     // Keep track of all participants, how much they bought and how much they spent.
321     address[] public allParticipants;
322     mapping(address => uint256) public participantToEtherSpent;
323     mapping(address => uint256) public participantToBRAbought;
324     
325     
326     function crowdsaleTargetReached() public view returns (bool)
327     {
328         return amountOfBRAsold() >= crowdsaleTargetBRA;
329     }
330     
331     function crowdsaleStarted() public view returns (bool)
332     {
333         return now >= first_period_start_date;
334     }
335     
336     function crowdsaleFinished() public view returns (bool)
337     {
338         return now >= crowdsale_end_timestamp;
339     }
340     
341     function amountOfParticipants() external view returns (uint256)
342     {
343         return allParticipants.length;
344     }
345     
346     function amountOfBRAsold() public view returns (uint256)
347     {
348         return totalSupply_ / 2 - balances[this];
349     }
350     
351     // If the crowdsale target has not been reached, or the crowdsale has not finished,
352     // don't allow the transfer of tokens purchased in the crowdsale.
353     function transfer(address _to, uint256 _amount) public returns (bool)
354     {
355         if (!crowdsaleTargetReached() || !crowdsaleFinished())
356         {
357             require(balances[msg.sender] - participantToBRAbought[msg.sender] >= _amount);
358         }
359         
360         return super.transfer(_to, _amount);
361     }
362     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool)
363     {
364         if (!crowdsaleTargetReached() || !crowdsaleFinished())
365         {
366             require(balances[_from] - participantToBRAbought[_from] >= _amount);
367         }
368         
369         return super.transferFrom(_from, _to, _amount);
370     }
371     
372     address public founderWallet = 0x6bC5aa2B9eb4aa5b6170Dafce4482efF56184ADd;
373     address public teamWallet = 0xb054D33607fC07e55469c81ABcB1553B92914E9e;
374     address public bountyAffiliateWallet = 0x9460bc2bB546B640060E0268Ba8C392b0A0D6330;
375     address public earlyBackersWallet = 0x4681B5c67ae0632c57ee206e1f9c2Ca58D6Af34c;
376     address public reserveWallet = 0x4d70B2aCaE5e6558A9f5d55E672E93916Ba5c7aE;
377     
378     // Constructor function
379     function BRANDCOIN() public
380     {
381         totalSupply_ = 1650000000 * (uint256(10) ** decimals);
382         balances[this] = totalSupply_;
383         Transfer(0x0, this, totalSupply_);
384     }
385     
386     bool private distributedInitialFunds = false;
387     function distributeInitialFunds() public onlyOwner
388     {
389         require(!distributedInitialFunds);
390         distributedInitialFunds = true;
391         this.transfer(founderWallet, totalSupply_*15/100);
392         this.transfer(earlyBackersWallet, totalSupply_*5/100);
393         this.transfer(teamWallet, totalSupply_*15/100);
394         this.transfer(bountyAffiliateWallet, totalSupply_*5/100);
395         this.transfer(reserveWallet, totalSupply_*10/100);
396     }
397     
398     function destroyUnsoldTokens() external
399     {
400         require(crowdsaleStarted() && crowdsaleFinished());
401         
402         this.burn(balances[this]);
403     }
404     
405     // If someone sends ETH to the contract address,
406     // assume that they are trying to buy tokens.
407     function () payable external
408     {
409         buyTokens();
410     }
411     
412     function buyTokens() payable public
413     {
414         uint256 amountOfBRApurchased = msg.value * (uint256(10)**decimals) / ETH_per_BRA;
415         
416         // Only allow buying tokens if the ICO has started, and has not finished
417         require(crowdsaleStarted());
418         require(!crowdsaleFinished());
419         
420         // If the pre-ICO hasn't started yet, cancel the transaction
421         if (now < first_period_start_date)
422         {
423             revert();
424         }
425         
426         else if (now >= first_period_start_date && now < second_period_start_date)
427         {
428             if (amountOfBRApurchased >= first_period_bonus_minimum_purchased_BRA)
429             {
430                 amountOfBRApurchased = amountOfBRApurchased * (100 + first_period_bonus_percentage) / 100;
431             }
432         }
433         
434         else if (now >= second_period_start_date && now < third_period_start_date)
435         {
436             amountOfBRApurchased = amountOfBRApurchased * (100 + second_period_bonus_percentage) / 100;
437         }
438         
439         else if (now >= third_period_start_date && now < fourth_period_start_date)
440         {
441             amountOfBRApurchased = amountOfBRApurchased * (100 + third_period_bonus_percentage) / 100;
442         }
443         
444         else if (now >= fourth_period_start_date && now < fifth_period_start_date)
445         {
446             amountOfBRApurchased = amountOfBRApurchased * (100 + fourth_period_bonus_percentage) / 100;
447         }
448         
449         else if (now >= fifth_period_start_date && now < crowdsale_end_timestamp)
450         {
451             amountOfBRApurchased = amountOfBRApurchased * (100 + fifth_period_bonus_percentage) / 100;
452         }
453         
454         // If we are passed the final sale, cancel the transaction.
455         else
456         {
457             revert();
458         }
459         
460         // Send the purchased tokens to the buyer
461         this.transfer(msg.sender, amountOfBRApurchased);
462         
463         // Track statistics
464         if (participantToEtherSpent[msg.sender] == 0)
465         {
466             allParticipants.push(msg.sender);
467         }
468         participantToBRAbought[msg.sender] += amountOfBRApurchased;
469         participantToEtherSpent[msg.sender] += msg.value;
470     }
471     
472     function refund() external
473     {
474         // If the crowdsale has not started yet, don't allow refund
475         require(crowdsaleStarted());
476         
477         // If the crowdsale has not finished yet, don't allow refund
478         require(crowdsaleFinished());
479         
480         // If the target was reached, don't allow refund
481         require(!crowdsaleTargetReached());
482         
483         _refundParticipant(msg.sender);
484     }
485     
486     function refundMany(uint256 _startIndex, uint256 _endIndex) external
487     {
488         // If the crowdsale has not started yet, don't allow refund
489         require(crowdsaleStarted());
490         
491         // If the crowdsale has not finished yet, don't allow refund
492         require(crowdsaleFinished());
493         
494         // If the target was reached, don't allow refund
495         require(!crowdsaleTargetReached());
496         
497         for (uint256 i=_startIndex; i<=_endIndex && i<allParticipants.length; i++)
498         {
499             _refundParticipant(allParticipants[i]);
500         }
501     }
502     
503     function _refundParticipant(address _participant) internal
504     {
505         if (participantToEtherSpent[_participant] > 0)
506         {
507             // Return the BRA they bought to this contract
508             uint256 refundBRA = participantToBRAbought[_participant];
509             participantToBRAbought[_participant] = 0;
510             balances[_participant] -= refundBRA;
511             balances[this] += refundBRA;
512             Transfer(_participant, this, refundBRA);
513             
514             // Return the ETH they spent to buy them
515             uint256 refundETH = participantToEtherSpent[_participant];
516             participantToEtherSpent[_participant] = 0;
517             _participant.transfer(refundETH);
518         }
519     }
520     
521     function ownerWithdrawETH() external onlyOwner
522     {
523         // Only allow the owner to withdraw if the crowdsale target has been reached
524         require(crowdsaleTargetReached());
525         owner.transfer(this.balance);
526     }
527     
528     // As long as the crowdsale has not started yet, the owner can change the base price
529     function setPrice(uint256 _ETH_PER_BRA) external onlyOwner
530     {
531         require(!crowdsaleStarted());
532         ETH_per_BRA = _ETH_PER_BRA;
533     }
534 }