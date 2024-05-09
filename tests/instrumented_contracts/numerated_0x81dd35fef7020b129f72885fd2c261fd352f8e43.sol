1 pragma solidity ^0.4.15;
2 
3 /**
4  * @dev SEEDS token smart contract. For project and ICO details, please check: http://seedsico.info
5  */
6 
7 contract SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Token {
37     uint256 public totalSupply;
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41     function approve(address _spender, uint256 _value) returns (bool success);
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47     /**
48      * @title Ownable
49      * @dev The Ownable contract has an owner address, and provides basic authorization control
50      * functions, this simplifies the implementation of "user permissions".
51      */
52 contract Ownable {
53   address public owner;
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner {
79     require(newOwner != address(0));
80     owner = newOwner;
81   }
82 
83 }
84 
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  * pause is initially set to true; team will unpause before PRE-ICO start.
90  */
91 contract Pausable is Ownable {
92   event Pause();
93   event Unpause();
94 
95   bool public paused = true;
96 
97 
98   /**
99    * @dev modifier to allow actions only when the contract IS paused
100    */
101   modifier whenNotPaused() {
102     require(!paused);
103     _;
104   }
105 
106   /**
107    * @dev modifier to allow actions only when the contract IS NOT paused
108    */
109   modifier whenPaused() {
110     require(paused);
111     _;
112   }
113 
114   /**
115    * @dev called by the owner to pause, triggers stopped state
116    */
117   function pause() onlyOwner whenNotPaused {
118     paused = true;
119     Pause();
120   }
121 
122   /**
123    * @dev called by the owner to unpause, returns to normal state
124    */
125   function unpause() onlyOwner whenPaused {
126     paused = false;
127     Unpause();
128   }
129 }
130 /**
131  * @title LockFunds
132  * @dev Base contract which allows children to lock funds.
133  * Funds are locked in contributors' wallets since ICO end. On 6th March 2018 funds will be transferable
134  */
135 contract LockFunds is Ownable {
136   event Lock();
137   event UnLock();
138 
139   bool public locked = true;
140 
141 
142   /**
143    * @dev modifier to allow actions only when the funds ARE locked
144    */
145   modifier whenNotLocked() {
146     require(!locked);
147     _;
148   }
149 
150   /**
151    * @dev modifier to allow actions only when the funds ARE NOT locked
152    */
153   modifier whenLocked() {
154     require(locked);
155     _;
156   }
157 
158   /**
159    * @dev called by the owner to lock, triggers locked state
160    */
161   function lock() onlyOwner whenNotLocked {
162     locked = true;
163     Lock();
164   }
165 
166   /**
167    * @dev called by the owner to unlock, returns to normal state
168    */
169   function unlock() onlyOwner whenLocked {
170     locked = false;
171     UnLock();
172   }
173 }
174 /**
175  * StandardToken contract that implements LockFunds contract.
176  * Transfers are locked until 6th March 2018.
177 */
178 contract StandardToken is Token, SafeMath, LockFunds {
179 
180     function transfer(address _to, uint256 _value) whenNotLocked returns (bool success) {
181       if (balances[msg.sender] >= _value && _value > 0) {
182         balances[msg.sender] = sub(balances[msg.sender], _value);
183         balances[_to] = add(balances[_to], _value);
184         Transfer(msg.sender, _to, _value);
185         return true;
186       } else {
187         return false;
188       }
189     }
190 
191     function transferFrom(address _from, address _to, uint256 _value) whenNotLocked returns (bool success) {
192       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
193         balances[_to] = add(balances[_to], _value);
194         balances[_from] -= sub(balances[_from], _value);
195         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
196         Transfer(_from, _to, _value);
197         return true;
198       } else {
199         return false;
200       }
201     }
202 
203     function balanceOf(address _owner) constant returns (uint256 balance) {
204         return balances[_owner];
205     }
206 
207     function approve(address _spender, uint256 _value) returns (bool success) {
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
214       return allowed[_owner][_spender];
215     }
216 
217     mapping (address => uint256) balances;
218     mapping (address => mapping (address => uint256)) allowed;
219 }
220 
221 /** Burn contract allows team to burn their OWN SEEDS supply, 
222  * Total supply is updated and lowered.
223 */
224 
225 contract BurnableToken is SafeMath, StandardToken {
226 
227     event Burn(address indexed burner, uint256 value);
228 
229     /**
230      * @dev Burns a specific amount of tokens.
231      * @param _value The amount of token to be burned.
232      */
233     function burn(uint256 _value) public {
234         require(_value <= balances[msg.sender]);
235         // no need to require value <= totalSupply, since that would imply the
236         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238         address burner = msg.sender;
239         balances[burner] = sub(balances[burner],_value);
240         totalSupply = sub(totalSupply,_value);
241         Burn(burner, _value);
242     }
243 }
244 
245 /**SEEDSToken contract allows contributor to participate in PRE-ICO and ICO;
246  * PRE-ICO starts on January 5th 2018 14:00 GMT and ends on January 8th 2018, 13:59 GMT. 50% discount during this phase.
247  * ICO start on  January 8th 2018, 14:00 GMT and ends on March 5th 2018, 23:59 GMT.
248  * Discounts are the following:
249  * - 30% discount during phase 1, starting on 8th January and ending on 15th January;
250  * - 15% discount during phase 2, starting on 15th January and ending on 29th January;
251  * - 5% discount during phase 3, starting on 29th January and ending on 12th February;
252  * - No discount during phase 4, starting on 12th February and ending on 5th March.
253  * On ICO end, SEEDS tokens will be unlocked and transfers will be available.
254  */
255 
256 contract SEEDSToken is SafeMath, StandardToken, BurnableToken, Pausable {
257 
258     string public constant name = "Seeds";                                      //token name
259     string public constant symbol = "SEEDS";                                    //token symbol
260     uint256 public constant decimals = 18;                                      //token decimals
261     uint256 public constant maxFixedSupply = 500000000*10**decimals;            //Max SEEDS supply
262 	uint256 public constant tokenCreationCap = 375000000*10**decimals;          //Max cap for ICO and PRE-ICO
263 	uint256 public constant initialSupply = add(add(freeTotal, teamTotal), add(advisorTotal,lockedTeam));   //sets initial supply
264     uint256 public freeTotal = 5000000*10**decimals;                            //sets bounties and airdrop supply
265     uint256 public teamTotal = 50000000*10**decimals;                           //sets team supply
266     uint256 public advisorTotal = 50000000*10**decimals;                        //sets advisors and partners supply
267     uint256 public lockedTeam = 20000000*10**decimals;                          //sets team funds locked for 24 months 
268     uint256 public stillAvailable = tokenCreationCap;                           //calculates how many tokens are still available for crowdsale
269     
270 	
271 	uint256 public toBeDistributedFree = freeTotal; 
272     uint256 public totalEthReceivedinWei;
273     uint256 public totalDistributedinWei;
274     uint256 public totalBountyinWei;
275 
276     Phase public currentPhase = Phase.END;
277 
278     enum Phase {
279         PreICO,
280         ICO1,
281         ICO2,
282         ICO3,
283         ICO4,
284         END
285     }
286 
287     event CreateSEEDS(address indexed _to, uint256 _value);
288     event PriceChanged(string _text, uint _newPrice);
289     event StageChanged(string _text);
290     event Withdraw(address to, uint amount);
291 
292     function SEEDSToken() {                                                     //sets totalSupply and owner supply
293         owner=msg.sender;                                                       //owner supply = 125 M SEEDS to be distributed
294         balances[owner] = sub(maxFixedSupply, tokenCreationCap);                //through bounties, airdrop, team and advisors
295         totalSupply = initialSupply;
296     
297     }
298 
299     function () payable {
300         createTokens();
301     }
302 
303 
304     function createTokens() whenNotPaused internal  {                           //function that calculates Seeds to be received according 
305         uint multiplier = 10 ** 10;                                             // to ETH sent.
306         uint256 oneTokenInWei;
307         uint256 tokens; 
308         uint256 checkedSupply;
309 
310         if (currentPhase == Phase.PreICO){
311             {
312                 oneTokenInWei = 25000000000000;
313                 tokens = div(msg.value*100000000, oneTokenInWei) * multiplier;
314                 checkedSupply = add(totalSupply, tokens);
315                 if (checkedSupply <= tokenCreationCap)
316                     {
317                         addTokens(tokens);
318                         stillAvailable = sub(stillAvailable, tokens);           //
319                     }
320                 else
321                     revert ();
322             }
323         } 
324         else if (currentPhase == Phase.ICO1){
325             {
326                 oneTokenInWei = 35000000000000;
327                 tokens = div(msg.value*100000000, oneTokenInWei) * multiplier;
328                 checkedSupply = add(totalSupply, tokens);
329                 if (checkedSupply <= tokenCreationCap)
330                     {
331                         addTokens(tokens);
332                         stillAvailable = sub(stillAvailable, tokens);
333                     }
334                 else
335                     revert ();
336             }
337         }
338         else if (currentPhase == Phase.ICO2){
339             {
340                 oneTokenInWei = 42000000000000;
341                 tokens = div(msg.value*100000000, oneTokenInWei) * multiplier;
342                 checkedSupply = add(totalSupply, tokens);
343                 if (checkedSupply <= tokenCreationCap)
344                     {
345                         addTokens(tokens);
346                         stillAvailable = sub(stillAvailable, tokens);           //
347                     }
348                 else
349                     revert ();
350             }
351         }
352         else if (currentPhase == Phase.ICO3){
353             {
354                 oneTokenInWei = 47500000000000;
355                 tokens = div(msg.value*100000000, oneTokenInWei) * multiplier;
356                 checkedSupply = add(totalSupply, tokens);
357                 if (checkedSupply <= tokenCreationCap)
358                     {
359                         addTokens(tokens);
360                         stillAvailable = sub(stillAvailable, tokens);           //
361                     }
362                 else
363                     revert ();
364             }
365         }
366         else if (currentPhase == Phase.ICO4){
367             {
368                 oneTokenInWei = 50000000000000;
369                 tokens = div(msg.value*100000000, oneTokenInWei) * multiplier;
370                 checkedSupply = add(totalSupply, tokens);
371                 if (checkedSupply <= tokenCreationCap)
372                     {
373                         addTokens(tokens);
374                         stillAvailable = sub(stillAvailable, tokens);           //
375                     }
376                 else
377                     revert ();
378             }
379         }
380         else if (currentPhase == Phase.END){
381             revert();
382         }
383     }
384 
385     function addTokens(uint256 tokens) internal {                               //updates received ETH and total supply, sends Seeds to contributor
386         require (msg.value >= 0 && msg.sender != address(0));
387         balances[msg.sender] = add(balances[msg.sender], tokens);
388         totalSupply = add(totalSupply, tokens);
389         totalEthReceivedinWei = add(totalEthReceivedinWei, msg.value);
390         CreateSEEDS(msg.sender, tokens);
391     }
392 
393     function withdrawInWei(address _toAddress, uint256 amount) external onlyOwner {     //allow Seeds team to Withdraw collected Ether
394         require(_toAddress != address(0));
395         _toAddress.transfer(amount);
396         Withdraw(_toAddress, amount);
397     }
398 
399     function setPreICOPhase() external onlyOwner {                              //set current Phase. Initial phase is set to "END".
400         currentPhase = Phase.PreICO;
401         StageChanged("Current stage: PreICO");
402     }
403     
404     function setICO1Phase() external onlyOwner {
405         currentPhase = Phase.ICO1;
406         StageChanged("Current stage: ICO1");
407     }
408     
409     function setICO2Phase() external onlyOwner {
410         currentPhase = Phase.ICO2;
411         StageChanged("Current stage: ICO2");
412     }
413     
414     function setICO3Phase() external onlyOwner {
415         currentPhase = Phase.ICO3;
416         StageChanged("Current stage: ICO3");
417     }
418     
419     function setICO4Phase() external onlyOwner {
420         currentPhase = Phase.ICO4;
421         StageChanged("Current stage: ICO4");
422     }
423 
424     function setENDPhase () external onlyOwner {
425         currentPhase = Phase.END;
426         StageChanged ("Current stage: END");
427     }
428 
429     function generateTokens(address _receiver, uint256 _amount) external onlyOwner {    //token generation
430         require(_receiver != address(0));
431         balances[_receiver] = add(balances[_receiver], _amount);
432         totalSupply = add(totalSupply, _amount);
433         CreateSEEDS(_receiver, _amount);
434     }
435 
436 	function airdropSEEDSinWei(address[] addresses, uint256 _value) onlyOwner { //distribute airdrop, value inserted with decimals
437          uint256 airdrop = _value;
438          uint256 airdropMax = 100000*10**decimals;
439          uint256 total = mul(airdrop, addresses.length);
440          if (toBeDistributedFree >= 0 && total<=airdropMax){
441              for (uint i = 0; i < addresses.length; i++) {
442 	            balances[owner] = sub(balances[owner], airdrop);
443                 balances[addresses[i]] = add(balances[addresses[i]],airdrop);
444                 Transfer(owner, addresses[i], airdrop);
445             }
446 			totalDistributedinWei = add(totalDistributedinWei,total);
447 			toBeDistributedFree = sub(toBeDistributedFree, totalDistributedinWei);
448          }
449          else
450             revert();
451        }
452     function bountySEEDSinWei(address[] addresses, uint256 _value) onlyOwner {  //distribute bounty, value inserted with decimals
453          uint256 bounty = _value;
454          uint256 total = mul(bounty, addresses.length);
455          if (toBeDistributedFree >= 0){
456              for (uint i = 0; i < addresses.length; i++) {
457 	            balances[owner] = sub(balances[owner], bounty);
458                 balances[addresses[i]] = add(balances[addresses[i]],bounty);
459                 Transfer(owner, addresses[i], bounty);
460             }
461 			totalBountyinWei = add(totalBountyinWei,total);
462 			toBeDistributedFree = sub(toBeDistributedFree, totalBountyinWei);
463          }
464          else
465             revert();
466        }
467        
468 }