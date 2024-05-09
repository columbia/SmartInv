1 /** 
2 	Etherus presale contract
3 */
4 
5 
6 pragma solidity ^0.4.21;
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   uint256 public totalSupply;
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 
96 
97 
98 
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   /**
187    * @dev Decrease the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To decrement
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _subtractedValue The amount of tokens to decrease the allowance by.
195    */
196   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197     uint oldValue = allowed[msg.sender][_spender];
198     if (_subtractedValue > oldValue) {
199       allowed[msg.sender][_spender] = 0;
200     } else {
201       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202     }
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207 }
208 
209 
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
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 
255 /**
256  * Mintable token
257  */
258 
259 contract MintableToken is StandardToken, Ownable {
260     uint public totalSupply = 0;
261     address private minter;
262     bool public mintingEnabled = true;
263 
264     modifier onlyMinter() {
265         require(minter == msg.sender);
266         _;
267     }
268 
269     function setMinter(address _minter) public onlyOwner {
270         minter = _minter;
271     }
272 
273     function mint(address _to, uint _amount) public onlyMinter {
274         require(mintingEnabled);
275         totalSupply = totalSupply.add(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         Transfer(address(0x0), _to, _amount);
278     }
279 
280     function stopMinting() public onlyMinter {
281         mintingEnabled = false;
282     }
283 }
284 
285 
286 
287 
288 contract EtherusPreSale is Ownable {
289     using SafeMath for uint;
290 
291     // Constants
292     // =========
293 
294     uint private constant fractions = 1e18;
295     uint private constant millions = 1e6*fractions;
296 
297     uint private constant CAP = 15*millions;
298     uint private constant SALE_CAP = 5*millions;
299     uint private constant ETR_USD_PRICE = 400; //in cents
300 
301     uint public ethPrice = 40000; //in cents
302 
303     // Events
304     // ======
305 
306     event AltBuy(address holder, uint tokens, string txHash);
307     event Buy(address holder, uint tokens);
308     event RunSale();
309     event PauseSale();
310     event FinishSale();
311     event PriceSet(uint USDPerETH);
312 
313     // State variables
314     // ===============
315 
316     MintableToken public token;
317     address authority; //An account to control the contract on behalf of the owner
318     address robot; //An account to purchase tokens for altcoins
319     bool public isOpen = false;
320 
321     // Constructor
322     // ===========
323 
324     function EtherusPreSale(address _token, address _multisig, address _authority, address _robot) public {
325         token = MintableToken(_token);
326         authority = _authority;
327         robot = _robot;
328         transferOwnership(_multisig);
329     }
330 
331     // Public functions
332     // ================
333 
334     /**
335     * Gets the bonus in percents for the specified sum
336     */
337     function getBonus(uint ethSum) public view returns (uint){
338 
339         uint usdSum = ethSum.mul(ethPrice).div(fractions);
340         if(usdSum >= 1e6*100)
341             return 100;
342         if(usdSum >= 5e5*100)
343             return 80;
344         if(usdSum >= 2.5e5*100)
345             return 70;
346         if(usdSum >= 2e5*100)
347             return 60;
348         if(usdSum >= 1.5e5*100)
349             return 50;
350         if(usdSum >= 1.25e5*100)
351             return 40;
352         if(usdSum >= 1e5*100)
353             return 30;
354         if(usdSum >= 7.5e4*100)
355             return 20;
356         if(usdSum >= 5e4*100)
357             return 10;
358 
359         return 0;
360     }
361 
362     /**
363     * Computes number of tokens with bonus for the specified ether. Correctly
364     * adds bonuses if the sum is large enough to belong to several bonus intervals
365     */
366     function getTokensAmount(uint etherVal) public view returns (uint) {
367         uint bonus = getBonus(etherVal);
368         uint tokens = etherVal.mul(ethPrice).mul(100 + bonus).div(ETR_USD_PRICE*100);
369         return tokens;
370     }
371 
372     function buy(address to) public payable onlyOpen {
373         uint amount = msg.value;
374         uint tokens = getTokensAmountUnderCap(amount);
375 
376         owner.transfer(amount);
377         token.mint(to, tokens);
378 
379         Buy(to, tokens);
380     }
381 
382     function () public payable{
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
411     function buyAlt(address to, uint etherAmount, string _txHash) public onlyRobot {
412         uint tokens = getTokensAmountUnderCap(etherAmount);
413         token.mint(to, tokens);
414         AltBuy(to, tokens, _txHash);
415     }
416 
417     function setAuthority(address _authority) public onlyOwner {
418         authority = _authority;
419     }
420 
421     function setRobot(address _robot) public onlyAuthority {
422         robot = _robot;
423     }
424 
425     function setPrice(uint usdPerEther) public onlyAuthority {
426         //Ether is not expected to rate less than $1 and more than $100000 during presale
427         require(1*100 <= usdPerEther && usdPerEther <= 100000*100);
428         ethPrice = usdPerEther;
429         PriceSet(ethPrice);
430     }
431 
432     // SALE state management: start / pause / finalize
433     // --------------------------------------------
434     function open(bool _open) public onlyAuthority {
435         isOpen = _open;
436         if (_open) {
437             RunSale();
438         } else {
439             PauseSale();
440         }
441     }
442 
443     function finalize() public onlyAuthority {
444         uint diff = CAP.sub(token.totalSupply());
445         if(diff > 0) //The unsold capacity moves to team
446             token.mint(owner, diff);
447         token.stopMinting();
448         selfdestruct(owner);
449         FinishSale();
450     }
451 
452     // Private functions
453     // =========================
454 
455     /**
456     * Gets tokens for specified ether provided that they are still under the cap
457     */
458     function getTokensAmountUnderCap(uint etherAmount) private view returns (uint){
459         uint tokens = getTokensAmount(etherAmount);
460         require(tokens > 0);
461         require(tokens.add(token.totalSupply()) <= SALE_CAP);
462         return tokens;
463     }
464 
465 }