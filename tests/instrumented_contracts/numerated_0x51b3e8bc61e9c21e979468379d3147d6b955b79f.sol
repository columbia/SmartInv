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
107 
108 /**
109  * @title Burnable Token
110  * @dev Token that can be irreversibly burned (destroyed).
111  */
112 contract BurnableToken is BasicToken {
113 
114   event Burn(address indexed burner, uint256 value);
115 
116   /**
117    * @dev Burns a specific amount of tokens.
118    * @param _value The amount of token to be burned.
119    */
120   function burn(uint256 _value) public {
121     require(_value <= balances[msg.sender]);
122     // no need to require value <= totalSupply, since that would imply the
123     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
124 
125     address burner = msg.sender;
126     balances[burner] = balances[burner].sub(_value);
127     totalSupply_ = totalSupply_.sub(_value);
128     Burn(burner, _value);
129   }
130 }
131 
132 /**
133  * @title Ownable
134  * @dev The Ownable contract has an owner address, and provides basic authorization control
135  * functions, this simplifies the implementation of "user permissions".
136  */
137 contract Ownable {
138   address public owner;
139 
140 
141   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   function Ownable() public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to transfer control of the contract to a newOwner.
162    * @param newOwner The address to transfer ownership to.
163    */
164   function transferOwnership(address newOwner) public onlyOwner {
165     require(newOwner != address(0));
166     OwnershipTransferred(owner, newOwner);
167     owner = newOwner;
168   }
169 
170 }
171 
172 contract UBOCOIN is BurnableToken, Ownable
173 {
174     // ERC20 token parameters
175     string public constant name = "UBOCOIN";
176     string public constant symbol = "UBO";
177     uint8 public constant decimals = 18;
178     
179     
180     // Crowdsale base price (before bonuses): 0.001 ETH per UBO
181     uint256 private UBO_per_ETH = 1000 * (uint256(10) ** decimals);
182     
183     // 14 days with 43% bonus for purchases of at least 1000 UBO (19 february - 5 march)
184     uint256 private constant pre_ICO_duration = 15 days;
185     uint256 private constant pre_ICO_bonus_percentage = 43;
186     uint256 private constant pre_ICO_bonus_minimum_purchased_UBO = 1000 * (uint256(10) ** decimals);
187     
188     // 21 days with 15% bonus (6 march - 26 march)
189     uint256 private constant first_bonus_sale_duration = 21 days;
190     uint256 private constant first_bonus_sale_bonus = 15;
191     
192     // 15 days with 10% bonus (27 march - 10 april)
193     uint256 private constant second_bonus_sale_duration = 15 days;
194     uint256 private constant second_bonus_sale_bonus = 10;
195     
196     // 8 days with 6% bonus (11 april - 18 april)
197     uint256 private constant third_bonus_sale_duration = 8 days;
198     uint256 private constant third_bonus_sale_bonus = 6;
199     
200     // 7 days with 3% bonus (19 april - 25 april)
201     uint256 private constant fourth_bonus_sale_duration = 7 days;
202     uint256 private constant fourth_bonus_sale_bonus = 3;
203     
204     // 5 days with no bonus (26 april - 30 april)
205     uint256 private constant final_sale_duration = 5 days;
206     
207     
208     // The target of the crowdsale is 3500000 UBICOINS.
209     // If the crowdsale has finished, and the target has not been reached,
210     // all crowdsale participants will be able to call refund() and get their
211     // ETH back. The refundMany() function can be used to refund multiple
212     // participants in one transaction.
213     uint256 public constant crowdsaleTargetUBO = 3500000 * (uint256(10) ** decimals);
214     
215     
216     // Variables that remember the start times of the various crowdsale periods
217     uint256 private pre_ICO_start_timestamp;
218     uint256 private first_bonus_sale_start_timestamp;
219     uint256 private second_bonus_sale_start_timestamp;
220     uint256 private third_bonus_sale_start_timestamp;
221     uint256 private fourth_bonus_sale_start_timestamp;
222     uint256 private final_sale_start_timestamp;
223     uint256 private crowdsale_end_timestamp;
224     
225     
226     // Publicly accessible trackers that indicate how much UBO is left
227     // in each category
228     uint256 public crowdsaleAmountLeft;
229     uint256 public foundersAmountLeft;
230     uint256 public earlyBackersAmountLeft;
231     uint256 public teamAmountLeft;
232     uint256 public bountyAmountLeft;
233     uint256 public reservedFundLeft;
234     
235     // Keep track of all participants, how much they bought and how much they spent.
236     address[] public allParticipants;
237     mapping(address => uint256) public participantToEtherSpent;
238     mapping(address => uint256) public participantToUBObought;
239     
240     
241     function crowdsaleTargetReached() public view returns (bool)
242     {
243         return amountOfUBOsold() >= crowdsaleTargetUBO;
244     }
245     
246     function crowdsaleStarted() public view returns (bool)
247     {
248         return pre_ICO_start_timestamp > 0 && now >= pre_ICO_start_timestamp;
249     }
250     
251     function crowdsaleFinished() public view returns (bool)
252     {
253         return pre_ICO_start_timestamp > 0 && now >= crowdsale_end_timestamp;
254     }
255     
256     function amountOfParticipants() external view returns (uint256)
257     {
258         return allParticipants.length;
259     }
260     
261     function amountOfUBOsold() public view returns (uint256)
262     {
263         return totalSupply_ * 70 / 100 - crowdsaleAmountLeft;
264     }
265     
266     // If the crowdsale target has not been reached, or the crowdsale has not finished,
267     // don't allow the transfer of tokens purchased in the crowdsale.
268     function transfer(address _to, uint256 _amount) public returns (bool)
269     {
270         if (!crowdsaleTargetReached() || !crowdsaleFinished())
271         {
272             require(balances[msg.sender] - participantToUBObought[msg.sender] >= _amount);
273         }
274         
275         return super.transfer(_to, _amount);
276     }
277     
278     
279     // Constructor function
280     function UBOCOIN() public
281     {
282         totalSupply_ = 300000000 * (uint256(10) ** decimals);
283         balances[this] = totalSupply_;
284         Transfer(0x0, this, totalSupply_);
285         
286         crowdsaleAmountLeft = totalSupply_ * 70 / 100;   // 70%
287         foundersAmountLeft = totalSupply_ * 10 / 100;    // 10%
288         earlyBackersAmountLeft = totalSupply_ * 5 / 100; // 5%
289         teamAmountLeft = totalSupply_ * 5 / 100;         // 5%
290         bountyAmountLeft = totalSupply_ * 5 / 100;       // 5%
291         reservedFundLeft = totalSupply_ * 5 / 100;       // 5%
292         
293         setPreICOStartTime(1518998400); // This timstamp indicates 2018-02-19 00:00 UTC
294     }
295     
296     function setPreICOStartTime(uint256 _timestamp) public onlyOwner
297     {
298         // If the crowdsale has already started, don't allow re-scheduling it.
299         require(!crowdsaleStarted());
300         
301         pre_ICO_start_timestamp = _timestamp;
302         first_bonus_sale_start_timestamp = pre_ICO_start_timestamp + pre_ICO_duration;
303         second_bonus_sale_start_timestamp = first_bonus_sale_start_timestamp + first_bonus_sale_duration;
304         third_bonus_sale_start_timestamp = second_bonus_sale_start_timestamp + second_bonus_sale_duration;
305         fourth_bonus_sale_start_timestamp = third_bonus_sale_start_timestamp + third_bonus_sale_duration;
306         final_sale_start_timestamp = fourth_bonus_sale_start_timestamp + fourth_bonus_sale_duration;
307         crowdsale_end_timestamp = final_sale_start_timestamp + final_sale_duration;
308     }
309     
310     function startPreICOnow() external onlyOwner
311     {
312         setPreICOStartTime(now);
313     }
314     
315     function destroyUnsoldTokens() external
316     {
317         require(crowdsaleStarted() && crowdsaleFinished());
318         
319         uint256 amountToBurn = crowdsaleAmountLeft;
320         crowdsaleAmountLeft = 0;
321         this.burn(amountToBurn);
322     }
323     
324     // If someone sends ETH to the contract address,
325     // assume that they are trying to buy tokens.
326     function () payable external
327     {
328         buyTokens();
329     }
330     
331     function buyTokens() payable public
332     {
333         uint256 amountOfUBOpurchased = msg.value * UBO_per_ETH / (1 ether);
334         
335         // Only allow buying tokens if the ICO has started, and has not finished
336         require(crowdsaleStarted());
337         require(!crowdsaleFinished());
338         
339         // If the pre-ICO hasn't started yet, cancel the transaction
340         if (now < pre_ICO_start_timestamp)
341         {
342             revert();
343         }
344         
345         // If we are in the pre-ICO...
346         else if (now >= pre_ICO_start_timestamp && now < first_bonus_sale_start_timestamp)
347         {
348             // If they purchased enough to be eligible for the pre-ICO bonus,
349             // then give them the bonus
350             if (amountOfUBOpurchased >= pre_ICO_bonus_minimum_purchased_UBO)
351             {
352                 amountOfUBOpurchased = amountOfUBOpurchased * (100 + pre_ICO_bonus_percentage) / 100;
353             }
354         }
355         
356         // If we are in the first bonus sale...
357         else if (now >= first_bonus_sale_start_timestamp && now < second_bonus_sale_start_timestamp)
358         {
359             amountOfUBOpurchased = amountOfUBOpurchased * (100 + first_bonus_sale_bonus) / 100;
360         }
361         
362         // If we are in the second bonus sale...
363         else if (now >= second_bonus_sale_start_timestamp && now < third_bonus_sale_start_timestamp)
364         {
365             amountOfUBOpurchased = amountOfUBOpurchased * (100 + second_bonus_sale_bonus) / 100;
366         }
367         
368         // If we are in the third bonus sale...
369         else if (now >= third_bonus_sale_start_timestamp && now < fourth_bonus_sale_start_timestamp)
370         {
371             amountOfUBOpurchased = amountOfUBOpurchased * (100 + third_bonus_sale_bonus) / 100;
372         }
373         
374         // If we are in the fourth bonus sale...
375         else if (now >= fourth_bonus_sale_start_timestamp && now < final_sale_start_timestamp)
376         {
377             amountOfUBOpurchased = amountOfUBOpurchased * (100 + fourth_bonus_sale_bonus) / 100;
378         }
379         
380         // If we are in the final sale...
381         else if (now >= final_sale_start_timestamp && now < crowdsale_end_timestamp)
382         {
383             // No bonus
384         }
385         
386         // If we are passed the final sale, cancel the transaction.
387         else
388         {
389             revert();
390         }
391         
392         // Make sure the crowdsale has enough UBO left
393         require(amountOfUBOpurchased <= crowdsaleAmountLeft);
394         
395         // Remove the tokens from this contract and the crowdsale tokens,
396         // add them to the buyer
397         crowdsaleAmountLeft -= amountOfUBOpurchased;
398         balances[this] -= amountOfUBOpurchased;
399         balances[msg.sender] += amountOfUBOpurchased;
400         Transfer(this, msg.sender, amountOfUBOpurchased);
401         
402         // Track statistics
403         if (participantToEtherSpent[msg.sender] == 0)
404         {
405             allParticipants.push(msg.sender);
406         }
407         participantToUBObought[msg.sender] += amountOfUBOpurchased;
408         participantToEtherSpent[msg.sender] += msg.value;
409     }
410     
411     function refund() external
412     {
413         // If the crowdsale has not started yet, don't allow refund
414         require(crowdsaleStarted());
415         
416         // If the crowdsale has not finished yet, don't allow refund
417         require(crowdsaleFinished());
418         
419         // If the target was reached, don't allow refund
420         require(!crowdsaleTargetReached());
421         
422         _refundParticipant(msg.sender);
423     }
424     
425     function refundMany(uint256 _startIndex, uint256 _endIndex) external
426     {
427         // If the crowdsale has not started yet, don't allow refund
428         require(crowdsaleStarted());
429         
430         // If the crowdsale has not finished yet, don't allow refund
431         require(crowdsaleFinished());
432         
433         // If the target was reached, don't allow refund
434         require(!crowdsaleTargetReached());
435         
436         for (uint256 i=_startIndex; i<=_endIndex && i<allParticipants.length; i++)
437         {
438             _refundParticipant(allParticipants[i]);
439         }
440     }
441     
442     function _refundParticipant(address _participant) internal
443     {
444         if (participantToEtherSpent[_participant] > 0)
445         {
446             // Return the UBO they bought into the crowdsale funds
447             uint256 refundUBO = participantToUBObought[_participant];
448             participantToUBObought[_participant] = 0;
449             balances[_participant] -= refundUBO;
450             balances[this] += refundUBO;
451             crowdsaleAmountLeft += refundUBO;
452             Transfer(_participant, this, refundUBO);
453             
454             // Return the ETH they spent to buy them
455             uint256 refundETH = participantToEtherSpent[_participant];
456             participantToEtherSpent[_participant] = 0;
457             _participant.transfer(refundETH);
458         }
459     }
460     
461     function distributeFounderTokens(address _founderAddress, uint256 _amount) external onlyOwner
462     {
463         require(_amount <= foundersAmountLeft);
464         foundersAmountLeft -= _amount;
465         this.transfer(_founderAddress, _amount);
466     }
467     
468     function distributeEarlyBackerTokens(address _earlyBackerAddress, uint256 _amount) external onlyOwner
469     {
470         require(_amount <= earlyBackersAmountLeft);
471         earlyBackersAmountLeft -= _amount;
472         this.transfer(_earlyBackerAddress, _amount);
473     }
474     
475     function distributeTeamTokens(address _teamMemberAddress, uint256 _amount) external onlyOwner
476     {
477         require(_amount <= teamAmountLeft);
478         teamAmountLeft -= _amount;
479         this.transfer(_teamMemberAddress, _amount);
480     }
481     
482     function distributeBountyTokens(address _bountyReceiverAddress, uint256 _amount) external onlyOwner
483     {
484         require(_amount <= bountyAmountLeft);
485         bountyAmountLeft -= _amount;
486         this.transfer(_bountyReceiverAddress, _amount);
487     }
488     
489     function distributeReservedTokens(address _to, uint256 _amount) external onlyOwner
490     {
491         require(_amount <= reservedFundLeft);
492         reservedFundLeft -= _amount;
493         this.transfer(_to, _amount);
494     }
495     
496     function distributeCrowdsaleTokens(address _to, uint256 _amount) external onlyOwner
497     {
498         require(_amount <= crowdsaleAmountLeft);
499         crowdsaleAmountLeft -= _amount;
500         this.transfer(_to, _amount);
501     }
502     
503     function ownerWithdrawETH() external onlyOwner
504     {
505         // Only allow the owner to withdraw if the crowdsale target has been reached
506         require(crowdsaleTargetReached());
507         
508         owner.transfer(this.balance);
509     }
510 }