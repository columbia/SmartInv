1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public constant returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic, Ownable {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111   mapping(address => bool) locks;
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     
121     require(!locks[msg.sender] && !locks[_to]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138   
139   /**
140   * @dev Sets the lock state of the specified address.
141   * @param _toLock The address to set the the lock state for.
142   * @param _setTo A bool representing the lock state.
143   */
144   function setLock(address _toLock, bool _setTo) onlyOwner {
145       locks[_toLock] = _setTo;
146   }
147 
148   /**
149   * @dev Gets the lock state of the specified address.
150   * @param _owner The address to query the the lock state of.
151   * @return A bool representing the lock state.
152   */
153   function lockOf(address _owner) public constant returns (bool lock) {
154     return locks[_owner];
155   }
156 
157 }
158 
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     
181     require(!locks[_from] && !locks[_to]);
182 
183     uint256 _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
186     // require (_value <= _allowance);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = _allowance.sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    */
227   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
234     uint oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue > oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 
247 /**
248  * @title Mintable token
249  * @dev ERC20 Token, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 
254 contract MintableToken is StandardToken {
255   string public constant name = "CryptoTask";
256   string public constant symbol = "CTF";
257   uint8 public constant decimals = 18; 
258     
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     require(!locks[_to]);
278     totalSupply = totalSupply.add(_amount);
279     balances[_to] = balances[_to].add(_amount);
280     Mint(_to, _amount);
281     Transfer(0x0, _to, _amount);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() onlyOwner public returns (bool) {
290     mintingFinished = true;
291     MintFinished();
292     return true;
293   }
294   
295 }
296 
297 
298 contract Crowdsale is Ownable {
299     using SafeMath for uint;
300     
301     uint public fundingGoal = 1000 * 1 ether;
302     uint public hardCap;
303     uint public amountRaisedPreSale = 0;
304     uint public amountRaisedICO = 0;
305     uint public contractDeployedTime;
306     //period after which anyone can close the presale
307     uint presaleDuration = 30 * 1 days;
308     //period between pre-sale and ICO
309     uint countdownDuration = 45 * 1 days;
310     //ICO duration
311     uint icoDuration = 20 * 1 days;
312     uint public presaleEndTime;
313     uint public deadline;
314     uint public price = 1000;
315     MintableToken public token;
316     mapping(address => uint) public balanceOf;
317     bool public icoSuccess = false;
318     bool public crowdsaleClosed = false;
319     //2 vaults that the raised funds are forwarded to
320     address vault1;
321     address vault2 = 0xC0776D495f9Ed916C87c8C48f34f08E2B9506342;
322     //stage 0 - presale, 1 - ICO, 2 - ICO success, 3 - after 1st vote on continuation of the project, 4 - after 2nd vote. ICO funds released in 3 stages
323     uint public stage = 0;
324     //total token stake against the project continuation
325     uint public against = 0;
326     uint public lastVoteTime;
327     uint minVoteTime = 180 * 1 days;
328 
329     event GoalReached(uint amountRaised);
330     event FundTransfer(address backer, uint amount, bool isContribution);
331 
332     /**
333      * Constrctor function
334      *
335      * Setup the owner
336      */
337     function Crowdsale() {
338         contractDeployedTime = now;
339         vault1 = msg.sender;
340         token = new MintableToken();
341     }
342 
343     /**
344      * Fallback function
345      *
346      * Called whenever anyone sends funds to the contract
347      */
348     function () payable {
349         require(!token.lockOf(msg.sender) && !crowdsaleClosed && stage<2 && msg.value >= 1 * (1 ether)/10);
350         if(stage==1 && (now < presaleEndTime.add(countdownDuration) || amountRaisedPreSale+amountRaisedICO+msg.value > hardCap)) {
351             throw;
352         }
353         uint amount = msg.value;
354         balanceOf[msg.sender] += amount;
355         if(stage==0) {  //presale
356             amountRaisedPreSale += amount;
357             token.mint(msg.sender, amount.mul(2) * price);
358         } else {
359             amountRaisedICO += amount;
360             token.mint(msg.sender, amount * price);
361         }
362         FundTransfer(msg.sender, amount, true);
363     }
364     
365     /**
366      * Forwards the amount from the contract to the vaults, 67% of the amount to vault1 and 33% to vault2
367      */
368     function forward(uint amount) internal {
369         vault1.transfer(amount.mul(67)/100);
370         vault2.transfer(amount.sub(amount.mul(67)/100));
371     }
372 
373     modifier afterDeadline() { if (stage > 0 && now >= deadline) {_;} }
374 
375     /**
376      * Check after deadline if the goal was reached and ends the campaign
377      */
378     function checkGoalReached() afterDeadline {
379         require(stage==1 && !crowdsaleClosed);
380         if (amountRaisedPreSale+amountRaisedICO >= fundingGoal) {
381             uint amount = amountRaisedICO/3;
382             if(!icoSuccess) {
383                 amount += amountRaisedPreSale/3;    //if funding goal hasn't been already reached in pre-sale
384             }
385             uint amountToken1 = token.totalSupply().mul(67)/(100*4);
386             uint amountToken2 = token.totalSupply().mul(33)/(100*4);
387             forward(amount);
388             icoSuccess = true;
389             token.mint(vault1, amountToken1);    //67% of the 25% of the total
390             token.mint(vault2, amountToken2);    //33% of the 25% of the total
391             stage=2;
392             lastVoteTime = now;
393             GoalReached(amountRaisedPreSale+amountRaisedICO);
394         }
395         crowdsaleClosed = true;
396         token.finishMinting();
397     }
398 
399     /**
400      * Closes presale
401      */
402     function closePresale() {
403         require((msg.sender == owner || now.sub(contractDeployedTime) > presaleDuration) && stage==0);
404         stage = 1;
405         presaleEndTime = now;
406         deadline = now.add(icoDuration.add(countdownDuration));
407         if(amountRaisedPreSale.mul(5) > 10000 * 1 ether) {
408             hardCap = amountRaisedPreSale.mul(5);
409         } else {
410             hardCap = 10000 * 1 ether;
411         }
412         if(amountRaisedPreSale >= fundingGoal) {
413             uint amount = amountRaisedPreSale/3;
414             forward(amount);
415             icoSuccess = true;
416             GoalReached(amountRaisedPreSale);
417         }
418     }
419 
420     /**
421      * Withdraw the funds
422      *
423      * If goal was not reached, each contributor can withdraw the amount they contributed, or less in case project is stopped through voting in later stages.
424      */
425     function safeWithdrawal() {
426         require(crowdsaleClosed && !icoSuccess);
427         
428         uint amount;
429         if(stage==1) {
430             amount = balanceOf[msg.sender];
431         } else if(stage==2) {
432             amount = balanceOf[msg.sender].mul(2)/3;    //2 thirds of the initial deposit can be withdrawn
433         } else if(stage==3) {
434             amount = balanceOf[msg.sender]/3;    //one third of the initial deposit can be withdrawn
435         }
436         balanceOf[msg.sender] = 0;
437         if (amount > 0) {
438             msg.sender.transfer(amount);
439             FundTransfer(msg.sender, amount, false);
440         }
441     }
442     
443     /**
444      * Token stakeholder can vote against the project continuation. Tokens are locked until voteRelease() is called
445      */
446     function voteAgainst()
447     {
448         require((stage==2 || stage==3) && !token.lockOf(msg.sender));   // If has already voted, cancel
449         token.setLock(msg.sender, true);
450         uint voteWeight = token.balanceOf(msg.sender);
451         against = against.add(voteWeight);
452     }
453     
454     /**
455      * Token stakeholder can release the against-vote, and unlock the tokens
456      */
457     function voteRelease()
458     {
459         require((stage==2 || stage==3 || stage==4) && token.lockOf(msg.sender));
460         token.setLock(msg.sender, false);
461         uint voteWeight = token.balanceOf(msg.sender);
462         against = against.sub(voteWeight);
463     }
464     
465     /**
466      * After each voting period, vote stakes can be counted, and in case that more than 50% of token stake is against the continuation,
467      * the remaining eth balances can be withdrawn proportionally
468      */
469     function countVotes()
470     {
471         require(icoSuccess && (stage==2 || stage==3) && now.sub(lastVoteTime) > minVoteTime);
472         lastVoteTime = now;
473         
474         if(against > token.totalSupply()/2) {
475             icoSuccess = false;
476         } else {
477             uint amount = amountRaisedICO/3 + amountRaisedPreSale/3;
478             forward(amount);
479             stage++;
480         }
481     }
482     
483 }