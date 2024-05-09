1 pragma solidity ^0.4.13;
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
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 /**
189  * @title Pausable
190  * @dev Base contract which allows children to implement an emergency stop mechanism.
191  */
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   /**
200    * @dev modifier to allow actions only when the contract IS paused
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev modifier to allow actions only when the contract IS NOT paused
209    */
210   modifier whenPaused {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused returns (bool) {
219     paused = true;
220     Pause();
221     return true;
222   }
223 
224   /**
225    * @dev called by the owner to unpause, returns to normal state
226    */
227   function unpause() onlyOwner whenPaused returns (bool) {
228     paused = false;
229     Unpause();
230     return true;
231   }
232 }
233 
234 /**
235  * @title Burnable Token
236  * @dev Token that can be irreversibly burned (destroyed).
237  */
238 contract BurnableToken is StandardToken {
239  
240   /**
241    * @dev Burns a specific amount of tokens.
242    * @param _value The amount of token to be burned.
243    */
244   function burn(uint _value) public {
245     require(_value > 0);
246     address burner = msg.sender;
247     balances[burner] = balances[burner].sub(_value);
248     totalSupply = totalSupply.sub(_value);
249     Burn(burner, _value);
250   }
251  
252   event Burn(address indexed burner, uint indexed value);
253  
254 }
255 
256 /**
257  * @title WTF  Token Network Token
258  * @dev ERC20 WTF  Token Network Token (WTF)
259  *
260  * WTF Tokens are divisible by 1e8 (100,000,000) base
261  * units referred to as 'Grains'.
262  *
263  * WTF are displayed using 8 decimal places of precision.
264  *
265  * 1 WTF is equivalent to:
266  *   100000000 == 1 * 10**8 == 1e8 == One Hundred Million Grains
267  *
268  * 10 Million WTF (total supply) is equivalent to:
269  *   1000000000000000 == 10000000 * 10**8 == 1e15 == One Quadrillion Grains
270  *
271  * All initial WTF Grains are assigned to the creator of
272  * this contract.
273  *
274  */
275 contract WTFToken is BurnableToken, Pausable {
276 
277   string public constant name = 'WTF  Token';                   // Set the token name for display
278   string public constant symbol = 'WTF';                                       // Set the token symbol for display
279   uint8 public constant decimals = 8;                                          // Set the number of decimals for display
280   uint256 public constant INITIAL_SUPPLY = 10000000 * 10**uint256(decimals);   // 10 Million WTF specified in Grains\
281   uint256 public sellPrice;
282 
283   /**
284    * @dev WTFToken Constructor
285    * Runs only on initial contract creation.
286    */
287   function WTFToken() {
288     totalSupply = INITIAL_SUPPLY;                                              // Set the total supply
289     balances[msg.sender] = INITIAL_SUPPLY;                                     // Creator address is assigned all
290     sellPrice = 0;
291   }
292 
293   /**
294    * @dev Transfer token for a specified address when not paused
295    * @param _to The address to transfer to.
296    * @param _value The amount to be transferred.
297    */
298   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
299     require(_to != address(0));
300     return super.transfer(_to, _value);
301   }
302 
303   /**
304    * @dev Transfer tokens from one address to another when not paused
305    * @param _from address The address which you want to send tokens from
306    * @param _to address The address which you want to transfer to
307    * @param _value uint256 the amount of tokens to be transferred
308    */
309   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
310     require(_to != address(0));
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   /**
315    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
320     return super.approve(_spender, _value);
321   }
322 
323  /**
324   * @dev Gets the purchase price of tokens by contract
325   */
326   function getPrice() constant returns (uint256 _sellPrice) {
327       return sellPrice;
328   }
329 
330   /**
331   * @dev Sets the purchase price of tokens by contract
332   * @param newSellPrice New purchase price
333   */
334   function setPrice(uint256 newSellPrice) external onlyOwner returns (bool success) {
335       require(newSellPrice > 0);
336       sellPrice = newSellPrice;
337       return true;
338   }
339 
340   /**
341     * @dev Buying ethereum for tokens
342     * @param amount Number of tokens
343     */
344   function sell(uint256 amount) external returns (uint256 revenue){
345       require(balances[msg.sender] >= amount);                                 // Checks if the sender has enough to sell
346       balances[this] = balances[this].add(amount);                             // Adds the amount to owner's balance
347       balances[msg.sender] = balances[msg.sender].sub(amount);                 // Subtracts the amount from seller's balance
348       revenue = amount.mul(sellPrice);                                         // Calculate the seller reward
349       msg.sender.transfer(revenue);                                            // Sends ether to the seller: it's important to do this last to prevent recursion attacks
350       Transfer(msg.sender, this, amount);                                      // Executes an event reflecting on the change
351       return revenue;                                                          // Ends function and returns
352   }
353 
354   /**
355   * @dev Allows you to get tokens from the contract
356   * @param amount Number of tokens
357   */
358   function getTokens(uint256 amount) onlyOwner external returns (bool success) {
359       require(balances[this] >= amount);
360       balances[msg.sender] = balances[msg.sender].add(amount);
361       balances[this] = balances[this].sub(amount);
362       Transfer(this, msg.sender, amount);
363       return true;
364   }
365 
366   /**
367   * @dev Allows you to put Ethereum to the smart contract
368   */
369   function sendEther() payable onlyOwner external returns (bool success) {
370       return true;
371   }
372 
373   /**
374   * @dev Allows you to get ethereum from the contract
375   * @param amount Number of tokens
376   */
377   function getEther(uint256 amount) onlyOwner external returns (bool success) {
378       require(amount > 0);
379       msg.sender.transfer(amount);
380       return true;
381   }
382 }