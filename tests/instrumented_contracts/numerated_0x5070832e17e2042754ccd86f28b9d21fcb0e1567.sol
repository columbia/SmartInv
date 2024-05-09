1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6 /** 
7 	Ties.Network TokenSale contract
8 	@author Dmitry Kochin <k@ties.network>
9 */
10 
11 
12 pragma solidity ^0.4.14;
13 
14 
15 /*************************************************************************
16  * import "./include/MintableToken.sol" : start
17  *************************************************************************/
18 
19 /*************************************************************************
20  * import "zeppelin/contracts/token/StandardToken.sol" : start
21  *************************************************************************/
22 
23 
24 /*************************************************************************
25  * import "./BasicToken.sol" : start
26  *************************************************************************/
27 
28 
29 /*************************************************************************
30  * import "./ERC20Basic.sol" : start
31  *************************************************************************/
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 /*************************************************************************
46  * import "./ERC20Basic.sol" : end
47  *************************************************************************/
48 /*************************************************************************
49  * import "../math/SafeMath.sol" : start
50  *************************************************************************/
51 
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal constant returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 /*************************************************************************
83  * import "../math/SafeMath.sol" : end
84  *************************************************************************/
85 
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances. 
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) returns (bool) {
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of. 
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) constant returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 /*************************************************************************
119  * import "./BasicToken.sol" : end
120  *************************************************************************/
121 /*************************************************************************
122  * import "./ERC20.sol" : start
123  *************************************************************************/
124 
125 
126 
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) constant returns (uint256);
135   function transferFrom(address from, address to, uint256 value) returns (bool);
136   function approve(address spender, uint256 value) returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 /*************************************************************************
140  * import "./ERC20.sol" : end
141  *************************************************************************/
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amout of tokens to be transfered
161    */
162   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
163     var _allowance = allowed[_from][msg.sender];
164 
165     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
166     // require (_value <= _allowance);
167 
168     balances[_to] = balances[_to].add(_value);
169     balances[_from] = balances[_from].sub(_value);
170     allowed[_from][msg.sender] = _allowance.sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) returns (bool) {
181 
182     // To change the approve amount you first have to reduce the addresses`
183     //  allowance to zero by calling `approve(_spender, 0)` if it is not
184     //  already 0 to mitigate the race condition described here:
185     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
187 
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifing the amount of tokens still avaible for the spender.
198    */
199   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
200     return allowed[_owner][_spender];
201   }
202 
203 }
204 /*************************************************************************
205  * import "zeppelin/contracts/token/StandardToken.sol" : end
206  *************************************************************************/
207 /*************************************************************************
208  * import "zeppelin/contracts/ownership/Ownable.sol" : start
209  *************************************************************************/
210 
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   /**
222    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223    * account.
224    */
225   function Ownable() {
226     owner = msg.sender;
227   }
228 
229 
230   /**
231    * @dev Throws if called by any account other than the owner.
232    */
233   modifier onlyOwner() {
234     require(msg.sender == owner);
235     _;
236   }
237 
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) onlyOwner {
244     if (newOwner != address(0)) {
245       owner = newOwner;
246     }
247   }
248 
249 }
250 /*************************************************************************
251  * import "zeppelin/contracts/ownership/Ownable.sol" : end
252  *************************************************************************/
253 
254 /**
255  * Mintable token
256  */
257 
258 contract MintableToken is StandardToken, Ownable {
259     uint public totalSupply = 0;
260     address private minter;
261 
262     modifier onlyMinter(){
263         require(minter == msg.sender);
264         _;
265     }
266 
267     function setMinter(address _minter) onlyOwner {
268         minter = _minter;
269     }
270 
271     function mint(address _to, uint _amount) onlyMinter {
272         totalSupply = totalSupply.add(_amount);
273         balances[_to] = balances[_to].add(_amount);
274         Transfer(address(0x0), _to, _amount);
275     }
276 }
277 /*************************************************************************
278  * import "./include/MintableToken.sol" : end
279  *************************************************************************/
280 
281 
282 
283 contract TokenSale is Ownable {
284     using SafeMath for uint;
285 
286     // Constants
287     // =========
288 
289     uint private constant fractions = 1e18;
290     uint private constant millions = 1e6*fractions;
291 
292     uint private constant CAP = 200*millions;
293     uint private constant SALE_CAP = 140*millions;
294     uint private constant BONUS_STEP = 14*millions;
295 
296     uint public price = 0.0008 ether;
297 
298     // Events
299     // ======
300 
301     event AltBuy(address holder, uint tokens, string txHash);
302     event Buy(address holder, uint tokens);
303     event RunSale();
304     event PauseSale();
305     event FinishSale();
306     event PriceSet(uint weiPerTIE);
307 
308     // State variables
309     // ===============
310 
311     MintableToken public token;
312     address authority; //An account to control the contract on behalf of the owner
313     address robot; //An account to purchase tokens for altcoins
314     bool public isOpen = false;
315 
316     // Constructor
317     // ===========
318 
319     function TokenSale(address _token, address _multisig, address _authority, address _robot){
320         token = MintableToken(_token);
321         authority = _authority;
322         robot = _robot;
323         transferOwnership(_multisig);
324     }
325 
326     // Public functions
327     // ================
328 
329     function getCurrentBonus() constant returns (uint){
330         return getBonus(token.totalSupply());
331     }
332 
333     /**
334     * Gets the bonus for the specified total supply
335     */
336     function getBonus(uint totalSupply) constant returns (uint){
337         bytes10 bonuses = "\x14\x11\x0F\x0C\x0A\x08\x06\x04\x02\x00";
338         uint level = totalSupply/BONUS_STEP;
339         if(level < bonuses.length)
340             return uint(bonuses[level]);
341         return 0;
342     }
343 
344     /**
345     * Computes number of tokens with bonus for the specified ether. Correctly
346     * adds bonuses if the sum is large enough to belong to several bonus intervals
347     */
348     function getTokensAmount(uint etherVal) constant returns (uint) {
349         uint tokens = 0;
350         uint totalSupply = token.totalSupply();
351         while(true){
352             //How much we have before next bonus interval
353             uint gap = BONUS_STEP - totalSupply%BONUS_STEP;
354             //Bonus at the current interval
355             uint bonus = 100 + getBonus(totalSupply);
356             //The cost of the entire remainder of this interval
357             uint gapCost = gap*(price*100)/fractions/bonus;
358             if(gapCost >= etherVal){
359                 //If the gap is large enough just sell the necessary amount of tokens
360                 tokens += etherVal.mul(bonus).mul(fractions)/(price*100);
361                 break;
362             }else{
363                 //If the gap is too small sell it and diminish the price by its cost for the next iteration
364                 tokens += gap;
365                 etherVal -= gapCost;
366                 totalSupply += gap;
367             }
368         }
369         return tokens;
370     }
371 
372     function buy(address to) onlyOpen payable{
373         uint amount = msg.value;
374         uint tokens = getTokensAmountUnderCap(amount);
375 
376         owner.transfer(amount);
377         token.mint(to, tokens);
378 
379         Buy(to, tokens);
380     }
381 
382     function () payable{
383         buy(msg.sender);
384     }
385 
386     // Modifiers
387     // =================
388 
389     modifier onlyAuthority() {
390         require(msg.sender == authority || msg.sender == owner);
391         _;
392     }
393 
394     modifier onlyRobot() {
395         require(msg.sender == robot);
396         _;
397     }
398 
399     modifier onlyOpen() {
400         require(isOpen);
401         _;
402     }
403 
404     // Priveleged functions
405     // ====================
406 
407     /**
408     * Used to buy tokens for altcoins.
409     * Robot may call it before TokenSale officially starts to migrate early investors
410     */
411     function buyAlt(address to, uint etherAmount, string _txHash) onlyRobot {
412         uint tokens = getTokensAmountUnderCap(etherAmount);
413         token.mint(to, tokens);
414         AltBuy(to, tokens, _txHash);
415     }
416 
417     function setAuthority(address _authority) onlyOwner {
418         authority = _authority;
419     }
420 
421     function setRobot(address _robot) onlyAuthority {
422         robot = _robot;
423     }
424 
425     function setPrice(uint etherPerTie) onlyAuthority {
426         //Ether is not expected to rate less than $96 and more than $480 during token sale
427         require(0.0005 ether <= etherPerTie && etherPerTie <= 0.0025 ether);
428         price = etherPerTie;
429         PriceSet(price);
430     }
431 
432     // SALE state management: start / pause / finalize
433     // --------------------------------------------
434     function open(bool open) onlyAuthority {
435         isOpen = open;
436         open ? RunSale() : PauseSale();
437     }
438 
439     function finalize() onlyAuthority {
440         uint diff = CAP.sub(token.totalSupply());
441         if(diff > 0) //The unsold capacity moves to team
442             token.mint(owner, diff);
443         selfdestruct(owner);
444         FinishSale();
445     }
446 
447     // Private functions
448     // =========================
449 
450     /**
451     * Gets tokens for specified ether provided that they are still under the cap
452     */
453     function getTokensAmountUnderCap(uint etherAmount) private constant returns (uint){
454         uint tokens = getTokensAmount(etherAmount);
455         require(tokens > 0);
456         require(tokens.add(token.totalSupply()) <= SALE_CAP);
457         return tokens;
458     }
459 
460 }