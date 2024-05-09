1 pragma solidity ^0.5.12;
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
19   constructor () public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a); 
62     return a - b; 
63   } 
64   
65   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
66     uint256 c = a + b; assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) public view returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender], "Error"); 
111     // SafeMath.sub will throw if there is not enough balance. 
112     balances[msg.sender] = balances[msg.sender].sub(_value); 
113     balances[_to] = balances[_to].add(_value); 
114     emit Transfer(msg.sender, _to, _value); 
115     return true; 
116   } 
117 
118   /** 
119    * @dev Gets the balance of the specified address. 
120    * @param _owner The address to query the the balance of. 
121    * @return An uint256 representing the amount owned by the passed address. 
122    */ 
123   function balanceOf(address _owner) public view returns (uint256 balance) { 
124     return balances[_owner]; 
125   } 
126 } 
127 
128 /** 
129  * @title Standard ERC20 token 
130  * 
131  * @dev Implementation of the basic standard token. 
132  * @dev https://github.com/ethereum/EIPs/issues/20 
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
134  */ 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]); 
149     balances[_from] = balances[_from].sub(_value); 
150     balances[_to] = balances[_to].add(_value); 
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
152     emit Transfer(_from, _to, _value); 
153     return true; 
154   } 
155 
156  /** 
157   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
158   * 
159   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
160   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
161   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
162   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
163   * @param _spender The address which will spend the funds. 
164   * @param _value The amount of tokens to be spent. 
165   */ 
166   function approve(address _spender, uint256 _value) public returns (bool) { 
167     allowed[msg.sender][_spender] = _value; 
168     emit Approval(msg.sender, _spender, _value); 
169     return true; 
170   }
171 
172  /** 
173   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
174   * @param _owner address The address which owns the funds. 
175   * @param _spender address The address which will spend the funds. 
176   * @return A uint256 specifying the amount of tokens still available for the spender. 
177   */ 
178   function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
179     return allowed[_owner][_spender]; 
180   } 
181 
182  /** 
183   * approve should be called when allowed[_spender] == 0. To increment 
184   * allowed value is better to use this function to avoid 2 calls (and wait until 
185   * the first transaction is mined) * From MonolithDAO Token.sol 
186   */ 
187   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
190     return true; 
191   }
192 
193   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
194     uint oldValue = allowed[msg.sender][_spender]; 
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   function () external payable {
205     revert();
206   }
207 
208 }
209 
210 contract MiningExpertToken is StandardToken, Ownable {
211     
212     string public constant name = "Mining Expert Token";
213     
214     string public constant symbol = "MEXP";
215     
216     uint32 public constant decimals = 18;
217     
218     uint256 public constant INITIAL_SUPPLY = 200000000*10**18; //200 billion token MEXP
219     
220     constructor () public {
221         totalSupply = INITIAL_SUPPLY;
222     }
223     
224 }
225 
226 //The contract has an address 0x0000009d48b12597675a02fca9c317eadef152cb, it is generated before the contract is uploaded to the network, all other addresses have nothing to do with us
227 contract MiningExpert is MiningExpertToken{
228    using SafeMath for uint;
229    
230    MiningExpertToken public token = new MiningExpertToken();
231     // public information about the contribution of a specific investor
232     mapping (address => uint) public contributor_balance;
233     // public information last payment time
234     mapping (address => uint) public contributor_payout_time;
235     // public information how much the user received money
236     mapping(address => uint) public contributor_payout;
237     // public information how much the user received tokens
238     mapping(address => uint) public contributor_token_payout;
239     // public information how much the user received bonus MEXP
240     mapping(address => bool) public contributor_bonus;
241     // public information how much the user received bonus MEXP
242     mapping(address => uint) public contributor_ETH_bonus;
243     
244     // all deposits below the minimum will be sent directly to the developer's wallet and will
245     // be used for the development of the project
246     uint constant  MINIMAL_DEPOSIT = 0.01 ether;
247     //Token bonus 200%
248     uint constant  BONUS_COEFFICIENT = 2;
249     //bonus 2.2% for a deposit above 10 ETH
250     uint constant  BONUS_ETH = 22;
251     //bonus cost 0.01 ether
252     uint TOKEN_COST = 100;
253     // Time after which you can request the next payment
254     uint constant  PAYOUT_TIME = 1 hours;
255     // 0.0925 % per hour
256     uint constant  HOURLY_PERCENT = 925;
257     //commission 10%
258     uint constant PROJECT_COMMISSION = 10;
259     // developer wallet for advertising and server payments
260     address payable constant DEVELOPER_WALLET  = 0x100000b152A8dA7a8FCb938D7113952BfbB99705;
261     // payment wallet
262     address payable constant PAYMENT_WALLET = 0x2000001068A0F8A100A2A3a6D256A069A074B4E2;
263     
264     event NewContributor(address indexed contributor, uint value, uint time);
265     event PayDividends(address indexed contributor, uint value, uint time);
266     event PayTokenDividends(address indexed contributor, uint value, uint time);
267     event NewContribution(address indexed contributor, uint value,uint time);
268     event PayBonus(address indexed contributor, uint value, uint time);
269     event Refund(address indexed contributor, uint value, uint time);
270     event Reinvest(address indexed contributor, uint value, uint time);
271     event TokenRefund(address indexed contributor, uint value, uint time);
272 
273     uint public total_deposits;
274     uint public number_contributors;
275     uint public last_payout;
276     uint public total_payout;
277     uint public total_token_payout;
278     
279     constructor()public payable {
280         balances[address(this)] = INITIAL_SUPPLY/2;
281         balances[DEVELOPER_WALLET] = INITIAL_SUPPLY/2;
282         emit Transfer(address(this), DEVELOPER_WALLET, INITIAL_SUPPLY/2);
283     }
284     
285     /**
286      * The modifier checking the positive balance of the beneficiary
287     */
288     modifier checkContributor(){
289         require(contributor_balance[msg.sender] > 0,  "Deposit not found");
290         _;
291     }
292     
293     /**
294      * modifier checking the next payout time
295      */
296     modifier checkTime(){
297          require(now >= contributor_payout_time[msg.sender].add(PAYOUT_TIME), "You can request payments at least 1 time per hour");
298          _;
299     }
300     
301     function get_contributor_credit()public view  returns(uint){
302         uint hourly_rate = (contributor_balance[msg.sender].add(contributor_ETH_bonus[msg.sender])).mul(HOURLY_PERCENT).div(1000000);
303         uint debt = now.sub(contributor_payout_time[msg.sender]).div(PAYOUT_TIME);
304         return(debt.mul(hourly_rate));
305     }
306     
307     // Take the remainder of the deposit and exit the project
308     function refund() checkContributor public payable {
309         uint balance = contributor_balance[msg.sender];
310         uint token_balance_payout = contributor_token_payout[msg.sender].div(TOKEN_COST);
311         uint payout_left = balance.sub(contributor_payout[msg.sender]).sub(token_balance_payout);
312         uint out_summ;
313         
314         if(contributor_bonus[msg.sender] || contributor_payout[msg.sender] > 0){
315             out_summ = payout_left.sub(balance.mul(PROJECT_COMMISSION).div(100));
316             msg.sender.transfer(out_summ);
317         }else{
318             out_summ = payout_left;
319             msg.sender.transfer(out_summ);
320         }
321         contributor_balance[msg.sender] = 0;
322         contributor_payout_time[msg.sender] = 0;
323         contributor_payout[msg.sender] = 0;
324         contributor_token_payout[msg.sender] = 0;
325         contributor_bonus[msg.sender] = false;
326         contributor_ETH_bonus[msg.sender] = 0;
327         
328         emit Refund(msg.sender, out_summ, now);
329     }
330     
331     // Conclusion establihsment and exit tokens MEXP
332     function tokenRefund() checkContributor public payable {
333         uint balance = contributor_balance[msg.sender];
334         uint token_balance_payout = contributor_token_payout[msg.sender].div(TOKEN_COST);
335         uint payout_left = balance.sub(contributor_payout[msg.sender]).sub(token_balance_payout);
336         uint out_summ;
337         
338         if(contributor_bonus[msg.sender] || contributor_payout[msg.sender] > 0){
339             out_summ = payout_left.sub(balance.mul(PROJECT_COMMISSION).div(100));
340             this.transfer(msg.sender, out_summ.mul(TOKEN_COST));
341         }else{
342             out_summ = payout_left;
343             this.transfer(msg.sender, out_summ.mul(TOKEN_COST));
344         }
345         contributor_balance[msg.sender] = 0;
346         contributor_payout_time[msg.sender] = 0;
347         contributor_payout[msg.sender] = 0;
348         contributor_token_payout[msg.sender] = 0;
349         contributor_bonus[msg.sender] = false;
350         contributor_ETH_bonus[msg.sender] = 0;
351         total_token_payout += out_summ;
352         
353         emit Refund(msg.sender, out_summ, now);
354     }
355     
356     // Reinvest the dividends into the project
357     function reinvest()public checkContributor payable{
358         require(contributor_bonus[msg.sender], 'Get bonus to reinvest');
359         uint credit = get_contributor_credit();
360         
361         if (credit > 0){
362             uint bonus = credit.mul(BONUS_ETH).div(1000);
363             credit += bonus;
364             contributor_payout_time[msg.sender] = now;
365             contributor_balance[msg.sender] += credit;
366             emit Reinvest(msg.sender, credit, now);
367         }else{
368             revert();
369         }
370     }
371     
372     // Get payment of dividends
373     function receivePayment()checkTime public payable{
374         uint credit = get_contributor_credit();
375         contributor_payout_time[msg.sender] = now;
376         contributor_payout[msg.sender] += credit;
377         // 1 percent held on hedging
378         msg.sender.transfer(credit.sub(credit.div(100)));
379         total_payout += credit;
380         last_payout = now;
381         emit PayDividends(msg.sender, credit, now);
382     }
383     
384     // Get payment of dividends in tokens
385     function receiveTokenPayment()checkTime public payable{
386         uint credit = get_contributor_credit().mul(TOKEN_COST);
387         contributor_payout_time[msg.sender] = now;
388         contributor_token_payout[msg.sender] += credit;
389         this.transfer(msg.sender,credit);
390         total_token_payout += credit;
391         last_payout = now;
392         emit PayTokenDividends(msg.sender, credit, now);
393     }
394     
395     /**
396      * The method of accepting payments, if a zero payment has come, then we start the procedure for refunding
397      * the interest on the deposit, if the payment is not empty, we record the number of broadcasts on the contract
398      * and the payment time
399      */
400     function makeContribution() private{
401             
402         if (contributor_balance[msg.sender] == 0){
403             emit NewContributor(msg.sender, msg.value, now);
404             number_contributors+=1;
405         }
406         
407         // transfer developer commission
408         DEVELOPER_WALLET.transfer(msg.value.mul(10).div(100));
409         
410         if(now >= contributor_payout_time[msg.sender].add(PAYOUT_TIME) && contributor_balance[msg.sender] != 0){
411             receivePayment();
412         }
413         
414         contributor_balance[msg.sender] += msg.value;
415         contributor_payout_time[msg.sender] = now;
416         
417         if (msg.value >= 10 ether){
418             contributor_ETH_bonus[msg.sender] = msg.value.mul(BONUS_ETH).div(1000);
419         }
420         
421         total_deposits += msg.value;
422         emit NewContribution(msg.sender, msg.value, now);
423     }
424     
425     // Get bonus for contribution
426     function getBonus()checkContributor external payable{
427         uint balance = contributor_balance[msg.sender];
428         if (!contributor_bonus[msg.sender]){
429             contributor_bonus[msg.sender] = true;
430             uint bonus = balance.mul(TOKEN_COST);
431             this.transfer(msg.sender, bonus);
432             total_token_payout += bonus;
433             emit PayBonus(msg.sender, bonus, now);
434         }
435     }
436     
437     // Get information on the contributor
438     function getContribtor() public view returns(uint balance, uint payout, uint payout_time, uint token_payout, bool bonus, uint ETH_bonus, uint payout_balance, uint token_balance) {
439         balance = contributor_balance[msg.sender];
440         payout = contributor_payout[msg.sender];
441         payout_time = contributor_payout_time[msg.sender];
442         token_payout = contributor_token_payout[msg.sender];
443         bonus = contributor_bonus[msg.sender];
444         ETH_bonus = contributor_ETH_bonus[msg.sender];
445         payout_balance = get_contributor_credit();
446         token_balance = balanceOf(msg.sender);
447         
448     }
449 
450     /**
451      * function that is launched when transferring money to a contract
452      */
453     function() external payable{
454         if (msg.value >= MINIMAL_DEPOSIT){
455             //if the sender is not a payment wallet, then we make out a deposit otherwise we do nothing,
456             // but simply put money on the balance of the contract
457             if(msg.sender != PAYMENT_WALLET){
458                 makeContribution();
459             }
460             
461         }else{
462            DEVELOPER_WALLET.transfer(msg.value); 
463         }
464     }
465 }