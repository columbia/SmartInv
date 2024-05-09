1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 
29 /**
30  * @title Basic token
31  * @dev Basic version of StandardToken, with no allowances.
32  */
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) balances;
37 
38   /**
39   * @dev transfer token for a specified address
40   * @param _to The address to transfer to.
41   * @param _value The amount to be transferred.
42   */
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     // SafeMath.sub will throw if there is not enough balance.
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of.
57   * @return An uint256 representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) public view returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 
109 
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * @dev https://github.com/ethereum/EIPs/issues/20
117  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(address _owner, address _spender) public view returns (uint256) {
165     return allowed[_owner][_spender];
166   }
167 
168   /**
169    * @dev Increase the amount of tokens that an owner allowed to a spender.
170    *
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param _spender The address which will spend the funds.
176    * @param _addedValue The amount of tokens to increase the allowance by.
177    */
178   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
179     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   /**
185    * @dev Decrease the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To decrement
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _subtractedValue The amount of tokens to decrease the allowance by.
193    */
194   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
195     uint oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205 }
206 
207 
208 /**
209  * @title Mintable token
210  * @dev Simple ERC20 Token example, with mintable token creation
211  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
212  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
213  */
214 
215 contract MintableToken is StandardToken, Ownable {
216   event Mint(address indexed to, uint256 amount);
217   event MintFinished();
218 
219   bool public mintingFinished = false;
220 
221 
222   modifier canMint() {
223     require(!mintingFinished);
224     _;
225   }
226 
227   /**
228    * @dev Function to mint tokens
229    * @param _to The address that will receive the minted tokens.
230    * @param _amount The amount of tokens to mint.
231    * @return A boolean that indicates if the operation was successful.
232    */
233   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
234     totalSupply = totalSupply.add(_amount);
235     balances[_to] = balances[_to].add(_amount);
236     Mint(_to, _amount);
237     Transfer(address(0), _to, _amount);
238     return true;
239   }
240 
241   /**
242    * @dev Function to stop minting new tokens.
243    * @return True if the operation was successful.
244    */
245   function finishMinting() onlyOwner canMint public returns (bool) {
246     mintingFinished = true;
247     MintFinished();
248     return true;
249   }
250 }
251 
252 
253 /**
254  * @title SafeMath
255  * @dev Math operations with safety checks that throw on error
256  */
257 library SafeMath {
258   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259     if (a == 0) {
260       return 0;
261     }
262     uint256 c = a * b;
263     assert(c / a == b);
264     return c;
265   }
266 
267   function div(uint256 a, uint256 b) internal pure returns (uint256) {
268     // assert(b > 0); // Solidity automatically throws when dividing by 0
269     uint256 c = a / b;
270     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
271     return c;
272   }
273 
274   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
275     assert(b <= a);
276     return a - b;
277   }
278 
279   function add(uint256 a, uint256 b) internal pure returns (uint256) {
280     uint256 c = a + b;
281     assert(c >= a);
282     return c;
283   }
284 }
285 
286 
287 /**
288  * @title Burnable Token
289  * @dev Token that can be irreversibly burned (destroyed).
290  */
291 contract BurnableToken is BasicToken {
292 
293     event Burn(address indexed burner, uint256 value);
294 
295     /**
296      * @dev Burns a specific amount of tokens.
297      * @param _value The amount of token to be burned.
298      */
299     function burn(uint256 _value) public {
300         require(_value <= balances[msg.sender]);
301         // no need to require value <= totalSupply, since that would imply the
302         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
303 
304         address burner = msg.sender;
305         balances[burner] = balances[burner].sub(_value);
306         totalSupply = totalSupply.sub(_value);
307         Burn(burner, _value);
308     }
309 }
310 
311 
312 contract CryptoGoldStandardCoin is MintableToken, BurnableToken {
313   using SafeMath for uint;
314   
315   string public name = "CRYPTO GOLD STANDARD";
316   string public symbol = "CGS";
317   uint8 public decimals = 9;
318   uint public INITIAL_SUPPLY = 100000000000;
319   
320   uint public sellPrice = 0; //the wei/cgs rate a user can sell
321   uint public buyPrice = 2**256-1; //the wei/cgs rate a user can buy
322   uint public priceExpirationBlockNumber = 0;
323   
324   function setPrices(uint newSellPrice, uint newBuyPrice, uint newPriceExpirationBlockNumber) onlyOwner public{
325       require(newPriceExpirationBlockNumber > block.number);
326       require(newSellPrice < newBuyPrice);
327       sellPrice = newSellPrice;
328       buyPrice = newBuyPrice;
329       priceExpirationBlockNumber = newPriceExpirationBlockNumber;
330   }
331   
332   function buy() payable public returns (uint amount){
333     require(block.number <= priceExpirationBlockNumber);
334     amount = msg.value / buyPrice;                    // calculates the amount
335     require(amount>0);                               // check if amount is more than zero
336     require(balances[this] >= amount);               // checks if it has enough to sell
337     balances[msg.sender] += amount;                  // adds the amount to buyer's balance
338     balances[this] -= amount;                        // subtracts amount from seller's balance
339     Transfer(this, msg.sender, amount);               // execute an event reflecting the change
340     return amount;                                    // ends function and returns
341   }
342 
343   function sell(uint amount) public returns (uint revenue){
344     require(block.number <= priceExpirationBlockNumber);
345     require(balances[msg.sender] >= amount);         // checks if the sender has enough to sell
346     balances[this] += amount;                        // adds the amount to owner's balance
347     balances[msg.sender] -= amount;                  // subtracts the amount from seller's balance
348     revenue = amount.mul(sellPrice);
349     msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
350     Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
351     return revenue;                                   // ends function and returns
352   }
353   
354   function forwardFunds(uint amount) onlyOwner public {
355     owner.transfer(amount);
356   }
357   
358   function forwardCoins(uint amount) onlyOwner public {
359     require(balances[this] >= amount);         // checks if the sender has enough to sell
360     balances[this] -= amount;                        // adds the amount to owner's balance
361     balances[owner] += amount;                  // subtracts the amount from seller's balance
362     Transfer(this, owner, amount);              // executes an event reflecting on the change
363   }
364   
365   function CryptoGoldStandardCoin() public {
366     totalSupply = INITIAL_SUPPLY;
367     balances[msg.sender] = INITIAL_SUPPLY;
368   }
369   
370   // fallback
371   function() payable public {
372       buy();
373   }
374 }