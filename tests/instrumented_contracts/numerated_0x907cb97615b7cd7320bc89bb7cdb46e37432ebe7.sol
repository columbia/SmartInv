1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   uint256 public totalDonation;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   function allowance(address owner, address spender) public view returns (uint256);
15   function transferFrom(address from, address to, uint256 value) public returns (bool);
16   function approve(address spender, uint256 value) public returns (bool);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 
64 
65 
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
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
123     emit Transfer(msg.sender, _to, _value);
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
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  */
143 contract StandardToken is ERC20Basic, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(address _owner, address _spender) public view returns (uint256) {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192    * @dev Increase the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _addedValue The amount of tokens to increase the allowance by.
200    */
201   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   /**
208    * @dev Decrease the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To decrement
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _subtractedValue The amount of tokens to decrease the allowance by.
216    */
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 
231 
232 
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will receive the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint256 _amount) internal returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     emit Mint(_to, _amount);
252     emit Transfer(address(0), _to, _amount);
253     return true;
254   }
255 
256 }
257 
258 
259 
260 contract Frens is MintableToken
261 {
262     // Using libraries 
263     using SafeMath for uint;
264 
265     
266     //////////////////////
267     // ERC20 token state
268     //////////////////////
269     
270     /**
271     These state vars are handled in the OpenZeppelin libraries;
272     we display them here for the developer's information.
273     ***
274     // ERC20Basic - Store account balances
275     mapping (address => uint256) public balances;
276 
277     // StandardToken - Owner of account approves transfer of an amount to another account
278     mapping (address => mapping (address => uint256)) public allowed;
279 
280     // 
281     uint256 public totalSupply;
282     */
283     
284     //////////////////////
285     // Human token state
286     //////////////////////
287     string public constant name = "Fren.community";
288     string public constant symbol = "Frens";
289     uint8 public constant  decimals = 18;
290 
291     ///////////////////////////////////////////////////////////
292     // State vars for custom staking and budget functionality
293     ///////////////////////////////////////////////////////////
294 
295     /// Stake minting
296     // Minted tokens per second for all stakers
297     uint private globalMintRate;
298     // Total tokens currently staked
299     uint public totalFrensStaked; 
300 
301     // struct that will hold user stake
302     struct TokenStakeData {
303         uint initialStakeBalance;
304         uint initialStakeTime;
305         uint initialStakePercentage;
306         uint initialClaimTime;
307     }
308     
309     // Track all tokens staked
310     mapping (address => TokenStakeData) public stakeBalances;
311 
312     // Fire a loggable event when tokens are staked
313     event Stake(address indexed staker,  uint256 value);
314 
315     // Fire a loggable event when staked tokens are vested
316     event Vest(address indexed vester, uint256 stakedAmount, uint256 stakingGains);
317 
318     //////////////////////////////////////////////////
319     /// Begin Frens token functionality
320     //////////////////////////////////////////////////
321 
322     /// @dev Frens token constructor
323     constructor() public
324     {
325         // Define owner
326         owner = msg.sender;
327         //staking not enabled at first to transfer with no burns
328         // Define initial owner supply. (ether here is used only to get the decimals right)
329         uint _initOwnerSupply = 100000 ether;
330         // One-time bulk mint given to owner
331         bool _success = mint(msg.sender, _initOwnerSupply);
332         // Abort if initial minting failed for whatever reason
333         require(_success);
334 
335     }
336     
337     function donateToFrens (uint256 _value1) public returns (bool) {
338         totalDonation = totalDonation.add(_value1);
339         balances[msg.sender] = balances[msg.sender].sub(_value1);
340     }
341     
342     
343     function transfer(address _to, uint256 _value) public returns (bool) {
344     require(_to != address(0));
345     require(_value <= balances[msg.sender]);
346     
347     // SafeMath.sub will throw if there is not enough balance.
348     uint burn_token = (_value*10)/100;
349     uint token_send = _value.sub(burn_token);
350     balances[msg.sender] = balances[msg.sender].sub(_value);
351     balances[_to] = balances[_to].add(token_send);
352     totalSupply = totalSupply.sub(burn_token.div(2));
353     totalDonation = totalDonation.add(burn_token.div(2));
354     emit Transfer(msg.sender, _to, token_send);
355     emit Transfer(msg.sender,address(0),burn_token.div(2));
356     return true;
357         
358 }
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360     require(_to != address(0));
361     require(_value <= balances[_from]);
362     require(_value <= allowed[_from][msg.sender]);
363     
364 
365     uint burn_token = (_value*10)/100;
366     uint token_send = _value.sub(burn_token);
367     balances[_from] = balances[_from].sub(_value);
368     balances[_to] = balances[_to].add(token_send);
369     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
370     totalSupply = totalSupply.sub(burn_token.div(2));
371     totalDonation = totalDonation.add(burn_token.div(2));
372     emit Transfer(_from, _to, token_send);
373     emit Transfer(_from,address(0),burn_token.div(2)); 
374     return true;
375 
376 }
377     function _burn(address account, uint256 amount) onlyOwner public returns (bool) {
378 
379     balances[account] = balances[account].sub(amount);
380     totalSupply = totalSupply.sub(amount);
381     emit Transfer(account, address(0), amount);
382     }
383     
384 
385     /// @dev staking function which allows users to stake an amount of tokens to gain interest for up to 10 days 
386     function stakeFrens(uint _stakeAmount) external
387     {
388         // Require that tokens are staked successfully
389         require(stakeTokens(_stakeAmount));
390     }
391 
392     /// @dev allows users to reclaim any staked tokens
393     /// @return bool on success
394     function claimFrens() external returns (bool success)
395     {
396         /// Sanity checks: 
397         // require that there was some amount vested
398         require(stakeBalances[msg.sender].initialStakeBalance > 0);
399         // require that time has elapsed
400         require(now > stakeBalances[msg.sender].initialStakeTime);
401 
402         // Calculate the time elapsed since the tokens were originally staked
403         uint _timePassedSinceStake = now.sub(stakeBalances[msg.sender].initialStakeTime);
404 
405         // Calculate tokens to mint
406         uint _tokensToMint = calculateStakeGains(_timePassedSinceStake);
407 
408         // Add the original stake back to the user's balance
409         balances[msg.sender] += stakeBalances[msg.sender].initialStakeBalance;
410         
411         // Subtract stake balance from totalFrensStaked
412         totalFrensStaked -= stakeBalances[msg.sender].initialStakeBalance;
413         
414         // Not spliting stake; mint all new tokens and give them to msg.sender 
415         mint(msg.sender, _tokensToMint);
416         mint(owner, _tokensToMint.div(20)); //used for marketting, websites devs, giveaways and other stuffs
417         
418         
419         // Fire an event to tell the world of the newly vested tokens
420         emit Vest(msg.sender, stakeBalances[msg.sender].initialStakeBalance, _tokensToMint);
421 
422         // Clear out stored data from mapping
423         stakeBalances[msg.sender].initialStakeBalance = 0;
424         stakeBalances[msg.sender].initialStakeTime = 0;
425 
426         return true;
427     }
428 
429     /// @dev Allows user to check their staked balance
430     function getStakedBalance() view external returns (uint stakedBalance) 
431     {
432         return stakeBalances[msg.sender].initialStakeBalance;
433     }
434 
435 
436     /// @dev stake function reduces the user's total available balance. totalSupply is unaffected
437     /// @param _value determines how many tokens a user wants to stake
438     function stakeTokens(uint256 _value) private returns (bool success)
439     {
440         /// Sanity Checks:
441         // You can only stake as many tokens as you have
442         require(_value <= balances[msg.sender]);
443         // You can only stake tokens if  you have not already staked tokens
444         require(stakeBalances[msg.sender].initialStakeBalance == 0);
445 
446         // Subtract stake amount from regular token balance
447         balances[msg.sender] = balances[msg.sender].sub(_value);
448         
449         // Add stake amount to staked balance
450         stakeBalances[msg.sender].initialStakeBalance = _value;
451 
452         // Increment the global staked tokens value
453         totalFrensStaked += _value;
454         
455         // Save the time that the stake started
456         stakeBalances[msg.sender].initialStakeTime = now;
457         
458         stakeBalances[msg.sender].initialClaimTime = now;
459 
460 
461         // Fire an event to tell the world of the newly staked tokens
462         emit Stake(msg.sender, _value);
463 
464         return true;
465     }
466     
467     function takeDonatedFrens() external returns (uint claimAmount)
468     {
469         require(stakeBalances[msg.sender].initialStakeBalance > 10000000000000000000);
470     
471         require(86400 < now.sub(stakeBalances[msg.sender].initialClaimTime));
472         
473         uint _amountClaim = totalDonation.div(100);
474         uint _amountHave = stakeBalances[msg.sender].initialStakeBalance;
475         
476         if (_amountHave < _amountClaim) {
477             
478             mint(msg.sender, _amountHave.div(100));
479             
480             totalDonation = totalDonation.sub(_amountHave.div(100));
481             
482         } else {
483          
484          mint(msg.sender, totalDonation.div(100));
485          
486          claimAmount = totalDonation.div(100);
487          
488          totalDonation = totalDonation.sub(totalDonation.div(100));
489          
490          stakeBalances[msg.sender].initialClaimTime = now;
491          
492     }     
493     
494 }
495 
496     /// @dev Helper function to claimStake that modularizes the minting via staking calculation 
497     function calculateStakeGains(uint _timePassedSinceStake) view private returns (uint mintTotal)
498     {
499         // Store seconds in a day (need it in variable to use SafeMath)
500         uint _secondsPerDay = 86400;
501         uint _tokensToMint = 0;         // store number of new tokens to be minted
502         
503         // Determine the amount to be newly minted upon vesting, if any
504         if (_timePassedSinceStake >_secondsPerDay) {
505             
506         
507             
508            // Tokens were staked for enough time to mint new tokens; determine how many
509             if (_timePassedSinceStake > _secondsPerDay.mul(10)) {
510                 // Tokens were staked for the maximum amount of time (10 days)
511                 _tokensToMint = stakeBalances[msg.sender].initialStakeBalance.div(10);
512             } else if (_secondsPerDay.mul(9) < _timePassedSinceStake && _timePassedSinceStake < _secondsPerDay.mul(10)){
513                 // Tokens were staked for a mintable amount of time between 9 and 10 days
514                 _tokensToMint = stakeBalances[msg.sender].initialStakeBalance.div(20);
515             } else if (_secondsPerDay.mul(7) < _timePassedSinceStake && _timePassedSinceStake < _secondsPerDay.mul(9)){
516                 // Tokens were staked for a mintable amount of time between 7 and 9 days
517                 _tokensToMint = stakeBalances[msg.sender].initialStakeBalance.div(30);
518             } else if (_secondsPerDay.mul(6) < _timePassedSinceStake && _timePassedSinceStake < _secondsPerDay.mul(7)){
519                 // Tokens were staked for a mintable amount of time between 6 and 7 days
520                 _tokensToMint = stakeBalances[msg.sender].initialStakeBalance.div(40);
521             } else if (_secondsPerDay.mul(5) < _timePassedSinceStake && _timePassedSinceStake < _secondsPerDay.mul(6)){
522                 // Tokens were staked for a mintable amount of time between 5 and 6 days
523                 _tokensToMint = stakeBalances[msg.sender].initialStakeBalance.div(50);
524             } else {
525                 
526                 _tokensToMint = 0;
527             }
528         } 
529         
530         // Return the amount of new tokens to be minted
531         return _tokensToMint;
532 
533     }
534     
535     
536 
537     /// @dev calculateFraction allows us to better handle the Solidity ugliness of not having decimals as a native type 
538     /// @param _numerator is the top part of the fraction we are calculating
539     /// @param _denominator is the bottom part of the fraction we are calculating
540     /// @param _precision tells the function how many significant digits to calculate out to
541     /// @return quotient returns the result of our fraction calculation
542     function calculateFraction(uint _numerator, uint _denominator, uint _precision) pure private returns(uint quotient) 
543     {
544         // Take passed value and expand it to the required precision
545         _numerator = _numerator.mul(10 ** (_precision + 1));
546         // handle last-digit rounding
547         uint _quotient = ((_numerator.div(_denominator)) + 5) / 10;
548         return (_quotient);
549     }
550 }