1 /*
2  * NYX Token sale smart contract
3  *
4  * Supports ERC20, ERC223 stadards
5  *
6  * The NYX token is mintable during Token Sale. On Token Sale finalization it
7  * will be minted up to the cap and minting will be finished forever
8  */
9 
10 
11 pragma solidity ^0.4.16;
12 
13 
14 /*************************************************************************
15  * import "./include/MintableToken.sol" : start
16  *************************************************************************/
17 
18 /*************************************************************************
19  * import "zeppelin/contracts/token/StandardToken.sol" : start
20  *************************************************************************/
21 
22 
23 /*************************************************************************
24  * import "./BasicToken.sol" : start
25  *************************************************************************/
26 
27 
28 /*************************************************************************
29  * import "./ERC20Basic.sol" : start
30  *************************************************************************/
31 
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 /*************************************************************************
45  * import "./ERC20Basic.sol" : end
46  *************************************************************************/
47 /*************************************************************************
48  * import "../math/SafeMath.sol" : start
49  *************************************************************************/
50 
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal constant returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal constant returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 /*************************************************************************
82  * import "../math/SafeMath.sol" : end
83  *************************************************************************/
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances. 
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) returns (bool) {
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of. 
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) constant returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 /*************************************************************************
118  * import "./BasicToken.sol" : end
119  *************************************************************************/
120 /*************************************************************************
121  * import "./ERC20.sol" : start
122  *************************************************************************/
123 
124 
125 
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) constant returns (uint256);
134   function transferFrom(address from, address to, uint256 value) returns (bool);
135   function approve(address spender, uint256 value) returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 /*************************************************************************
139  * import "./ERC20.sol" : end
140  *************************************************************************/
141 
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
152   mapping (address => mapping (address => uint256)) allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amout of tokens to be transfered
160    */
161   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
162     var _allowance = allowed[_from][msg.sender];
163 
164     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
165     // require (_value <= _allowance);
166 
167     balances[_to] = balances[_to].add(_value);
168     balances[_from] = balances[_from].sub(_value);
169     allowed[_from][msg.sender] = _allowance.sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) returns (bool) {
180 
181     // To change the approve amount you first have to reduce the addresses`
182     //  allowance to zero by calling `approve(_spender, 0)` if it is not
183     //  already 0 to mitigate the race condition described here:
184     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
186 
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifing the amount of tokens still avaible for the spender.
197    */
198   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202 }
203 /*************************************************************************
204  * import "zeppelin/contracts/token/StandardToken.sol" : end
205  *************************************************************************/
206 /*************************************************************************
207  * import "zeppelin/contracts/ownership/Ownable.sol" : start
208  *************************************************************************/
209 
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   /**
221    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
222    * account.
223    */
224   function Ownable() {
225     owner = msg.sender;
226   }
227 
228 
229   /**
230    * @dev Throws if called by any account other than the owner.
231    */
232   modifier onlyOwner() {
233     require(msg.sender == owner);
234     _;
235   }
236 
237 
238   /**
239    * @dev Allows the current owner to transfer control of the contract to a newOwner.
240    * @param newOwner The address to transfer ownership to.
241    */
242   function transferOwnership(address newOwner) onlyOwner {
243     if (newOwner != address(0)) {
244       owner = newOwner;
245     }
246   }
247 
248 }
249 /*************************************************************************
250  * import "zeppelin/contracts/ownership/Ownable.sol" : end
251  *************************************************************************/
252 
253 /**
254  * Mintable token
255  */
256 
257 contract MintableToken is StandardToken, Ownable {
258     uint public totalSupply = 0;
259     address private minter;
260 
261     modifier onlyMinter(){
262         require(minter == msg.sender);
263         _;
264     }
265 
266     function setMinter(address _minter) onlyOwner {
267         minter = _minter;
268     }
269 
270     function mint(address _to, uint _amount) onlyMinter {
271         totalSupply = totalSupply.add(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         Transfer(address(0x0), _to, _amount);
274     }
275 }
276 /*************************************************************************
277  * import "./include/MintableToken.sol" : end
278  *************************************************************************/
279 /*************************************************************************
280  * import "./include/ERC23PayableToken.sol" : start
281  *************************************************************************/
282 
283 
284 
285 /*************************************************************************
286  * import "./ERC23.sol" : start
287  *************************************************************************/
288 
289 
290 
291 
292 /*
293  * ERC23
294  * ERC23 interface
295  * see https://github.com/ethereum/EIPs/issues/223
296  */
297 contract ERC23 is ERC20Basic {
298     function transfer(address to, uint value, bytes data);
299 
300     event TransferData(address indexed from, address indexed to, uint value, bytes data);
301 }
302 /*************************************************************************
303  * import "./ERC23.sol" : end
304  *************************************************************************/
305 /*************************************************************************
306  * import "./ERC23PayableReceiver.sol" : start
307  *************************************************************************/
308 
309 /*
310 * Contract that is working with ERC223 tokens
311 */
312 
313 contract ERC23PayableReceiver {
314     function tokenFallback(address _from, uint _value, bytes _data) payable;
315 }
316 
317 /*************************************************************************
318  * import "./ERC23PayableReceiver.sol" : end
319  *************************************************************************/
320 
321 /**  https://github.com/Dexaran/ERC23-tokens/blob/master/token/ERC223/ERC223BasicToken.sol
322  *
323  */
324 contract ERC23PayableToken is BasicToken, ERC23{
325     // Function that is called when a user or another contract wants to transfer funds .
326     function transfer(address to, uint value, bytes data){
327         transferAndPay(to, value, data);
328     }
329 
330     // Standard function transfer similar to ERC20 transfer with no _data .
331     // Added due to backwards compatibility reasons .
332     function transfer(address to, uint value) returns (bool){
333         bytes memory empty;
334         transfer(to, value, empty);
335         return true;
336     }
337 
338     function transferAndPay(address to, uint value, bytes data) payable {
339 
340         uint codeLength;
341 
342         assembly {
343             // Retrieve the size of the code on target address, this needs assembly .
344             codeLength := extcodesize(to)
345         }
346 
347         balances[msg.sender] = balances[msg.sender].sub(value);
348         balances[to] = balances[to].add(value);
349 
350         if(codeLength>0) {
351             ERC23PayableReceiver receiver = ERC23PayableReceiver(to);
352             receiver.tokenFallback.value(msg.value)(msg.sender, value, data);
353         }else if(msg.value > 0){
354             to.transfer(msg.value);
355         }
356 
357         Transfer(msg.sender, to, value);
358         if(data.length > 0)
359             TransferData(msg.sender, to, value, data);
360     }
361 }
362 /*************************************************************************
363  * import "./include/ERC23PayableToken.sol" : end
364  *************************************************************************/
365 
366 
367 contract NYXToken is MintableToken, ERC23PayableToken {
368     string public constant name = "NYX Token";
369     string public constant symbol = "NYX";
370     uint public constant decimals = 0;
371 
372     bool public transferEnabled = false;
373 
374     //The cap is 150 mln NYX
375     uint private constant CAP = 150*(10**6);
376 
377     function mint(address _to, uint _amount){
378         require(totalSupply.add(_amount) <= CAP);
379         super.mint(_to, _amount);
380     }
381 
382     function NYXToken(address multisigOwner) {
383         //Transfer ownership on the token to multisig on creation
384         transferOwnership(multisigOwner);
385     }
386 
387     /**
388     * Overriding all transfers to check if transfers are enabled
389     */
390     function transferAndPay(address to, uint value, bytes data) payable{
391         require(transferEnabled);
392         super.transferAndPay(to, value, data);
393     }
394 
395     function enableTransfer(bool enabled) onlyOwner{
396         transferEnabled = enabled;
397     }
398 
399 }
400 
401 contract TokenSale is Ownable {
402     using SafeMath for uint;
403 
404     // Constants
405     // =========
406     uint private constant millions = 1e6;
407 
408     uint private constant CAP = 150*millions;
409     uint private constant SALE_CAP = 12*millions;
410 
411     uint public price = 0.002 ether;
412 
413     // Events
414     // ======
415 
416     event AltBuy(address holder, uint tokens, string txHash);
417     event Buy(address holder, uint tokens);
418     event RunSale();
419     event PauseSale();
420     event FinishSale();
421     event PriceSet(uint weiPerNYX);
422 
423     // State variables
424     // ===============
425     bool public presale;
426     NYXToken public token;
427     address authority; //An account to control the contract on behalf of the owner
428     address robot; //An account to purchase tokens for altcoins
429     bool public isOpen = false;
430 
431     // Constructor
432     // ===========
433 
434     function TokenSale(address _token, address _multisig, address _authority, address _robot){
435         token = NYXToken(_token);
436         authority = _authority;
437         robot = _robot;
438         transferOwnership(_multisig);
439     }
440 
441     // Public functions
442     // ================
443     function togglePresale(bool activate) onlyOwner {
444         presale = activate;
445     }
446 
447 
448     function getCurrentPrice() constant returns(uint) {
449         if(presale) {
450             return price - (price*20/100);
451         }
452         return price;
453     }
454     /**
455     * Computes number of tokens with bonus for the specified ether. Correctly
456     * adds bonuses if the sum is large enough to belong to several bonus intervals
457     */
458     function getTokensAmount(uint etherVal) constant returns (uint) {
459         uint tokens = 0;
460         tokens += etherVal/getCurrentPrice();
461         return tokens;
462     }
463 
464     function buy(address to) onlyOpen payable{
465         uint amount = msg.value;
466         uint tokens = getTokensAmountUnderCap(amount);
467         
468         owner.transfer(amount);
469 
470 		token.mint(to, tokens);
471 
472         Buy(to, tokens);
473     }
474 
475     function () payable{
476         buy(msg.sender);
477     }
478 
479     // Modifiers
480     // =================
481 
482     modifier onlyAuthority() {
483         require(msg.sender == authority || msg.sender == owner);
484         _;
485     }
486 
487     modifier onlyRobot() {
488         require(msg.sender == robot);
489         _;
490     }
491 
492     modifier onlyOpen() {
493         require(isOpen);
494         _;
495     }
496 
497     // Priveleged functions
498     // ====================
499 
500     /**
501     * Used to buy tokens for altcoins.
502     * Robot may call it before TokenSale officially starts to migrate early investors
503     */
504     function buyAlt(address to, uint etherAmount, string _txHash) onlyRobot {
505         uint tokens = getTokensAmountUnderCap(etherAmount);
506         token.mint(to, tokens);
507         AltBuy(to, tokens, _txHash);
508     }
509 
510     function setAuthority(address _authority) onlyOwner {
511         authority = _authority;
512     }
513 
514     function setRobot(address _robot) onlyAuthority {
515         robot = _robot;
516     }
517 
518     function setPrice(uint etherPerNYX) onlyAuthority {
519         price = etherPerNYX;
520         PriceSet(price);
521     }
522 
523     // SALE state management: start / pause / finalize
524     // --------------------------------------------
525     function open(bool open) onlyAuthority {
526         isOpen = open;
527         open ? RunSale() : PauseSale();
528     }
529 
530     function finalize() onlyAuthority {
531         uint diff = CAP.sub(token.totalSupply());
532         if(diff > 0) //The unsold capacity moves to team
533             token.mint(owner, diff);
534         selfdestruct(owner);
535         FinishSale();
536     }
537 
538     // Private functions
539     // =========================
540 
541     /**
542     * Gets tokens for specified ether provided that they are still under the cap
543     */
544     function getTokensAmountUnderCap(uint etherAmount) private constant returns (uint){
545         uint tokens = getTokensAmount(etherAmount);
546         require(tokens > 0);
547         require(tokens.add(token.totalSupply()) <= SALE_CAP);
548         return tokens;
549     }
550 
551 }