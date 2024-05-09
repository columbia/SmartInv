1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts/ParkadeCoin.sol
264 
265 /**
266     @title A dividend-paying ERC20 token,
267     @dev Based on https://programtheblockchain.com/posts/2018/02/07/writing-a-simple-dividend-token-contract/
268           and https://programtheblockchain.com/posts/2018/02/13/writing-a-robust-dividend-token-contract/
269 */
270 contract ParkadeCoin is StandardToken, Ownable {
271   using SafeMath for uint256;
272   string public name = "Parkade Coin";
273   string public symbol = "PRKC";
274   uint8 public decimals = 18;
275 
276 
277   /**
278     There are a total of 400,000,000 tokens * 10^18 = 4 * 10^26 token units total
279     A scaling value of 1e10 means that a deposit of 0.04Eth will increase scaledDividendPerToken by 1.
280     A scaling value of 1e10 means that investors must wait until their scaledDividendBalances 
281       is at least 1e10 before any withdrawals will credit their account.
282   */
283   uint256 public scaling = uint256(10) ** 10;
284 
285   // Remainder value (in Wei) resulting from deposits
286   uint256 public scaledRemainder = 0;
287 
288   // Amount of wei credited to an account, but not yet withdrawn
289   mapping(address => uint256) public scaledDividendBalances;
290   // Cumulative amount of Wei credited to an account, since the contract's deployment
291   mapping(address => uint256) public scaledDividendCreditedTo;
292   // Cumulative amount of Wei that each token has been entitled to. Independent of withdrawals
293   uint256 public scaledDividendPerToken = 0;
294 
295   /**
296    * @dev Throws if transaction size is greater than the provided amount
297    * This is used to mitigate the Ethereum short address attack as described in https://tinyurl.com/y8jjvh8d
298    */
299   modifier onlyPayloadSize(uint size) { 
300     assert(msg.data.length >= size + 4);
301     _;    
302   }
303 
304   constructor() public {
305     // Total INITAL SUPPLY of 400 million tokens 
306     totalSupply_ = uint256(400000000) * (uint256(10) ** decimals);
307     // Initially assign all tokens to the contract's creator.
308     balances[msg.sender] = totalSupply_;
309     emit Transfer(address(0), msg.sender, totalSupply_);
310   }
311 
312   /**
313   * @dev Update the dividend balances associated with an account
314   * @param account The account address to update
315   */
316   function update(address account) 
317   internal 
318   {
319     // Calculate the amount "owed" to the account, in units of (wei / token) S
320     // Subtract Wei already credited to the account (per token) from the total Wei per token
321     uint256 owed = scaledDividendPerToken.sub(scaledDividendCreditedTo[account]);
322 
323     // Update the dividends owed to the account (in Wei)
324     // # Tokens * (# Wei / token) = # Wei
325     scaledDividendBalances[account] = scaledDividendBalances[account].add(balances[account].mul(owed));
326     // Update the total (wei / token) amount credited to the account
327     scaledDividendCreditedTo[account] = scaledDividendPerToken;
328   }
329 
330   event Transfer(address indexed from, address indexed to, uint256 value);
331   event Deposit(uint256 value);
332   event Withdraw(uint256 paidOut, address indexed to);
333 
334   mapping(address => mapping(address => uint256)) public allowance;
335 
336   /**
337   * @dev transfer token for a specified address
338   * @param _to The address to transfer to.
339   * @param _value The amount to be transferred.
340   */
341   function transfer(address _to, uint256 _value) 
342   public 
343   onlyPayloadSize(2*32) 
344   returns (bool success) 
345   {
346     require(balances[msg.sender] >= _value);
347 
348     // Added to transfer - update the dividend balances for both sender and receiver before transfer of tokens
349     update(msg.sender);
350     update(_to);
351 
352     balances[msg.sender] = balances[msg.sender].sub(_value);
353     balances[_to] = balances[_to].add(_value);
354 
355     emit Transfer(msg.sender, _to, _value);
356     return true;
357   }
358 
359   /**
360    * @dev Transfer tokens from one address to another
361    * @param _from address The address which you want to send tokens from
362    * @param _to address The address which you want to transfer to
363    * @param _value uint256 the amount of tokens to be transferred
364    */
365   function transferFrom(address _from, address _to, uint256 _value)
366   public
367   onlyPayloadSize(3*32)
368   returns (bool success)
369   {
370     require(_to != address(0));
371     require(_value <= balances[_from]);
372     require(_value <= allowed[_from][msg.sender]);
373 
374     // Added to transferFrom - update the dividend balances for both sender and receiver before transfer of tokens
375     update(_from);
376     update(_to);
377 
378     balances[_from] = balances[_from].sub(_value);
379     balances[_to] = balances[_to].add(_value);
380     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
381     emit Transfer(_from, _to, _value);
382     return true;
383   }
384 
385   /**
386   * @dev deposit Ether into the contract for dividend splitting
387   */
388   function deposit() 
389   public 
390   payable 
391   onlyOwner 
392   {
393     // Scale the deposit and add the previous remainder
394     uint256 available = (msg.value.mul(scaling)).add(scaledRemainder);
395 
396     // Compute amount of Wei per token
397     scaledDividendPerToken = scaledDividendPerToken.add(available.div(totalSupply_));
398 
399     // Compute the new remainder
400     scaledRemainder = available % totalSupply_;
401 
402     emit Deposit(msg.value);
403   }
404 
405   /**
406   * @dev withdraw dividends owed to an address
407   */
408   function withdraw() 
409   public 
410   {
411     // Update the dividend amount associated with the account
412     update(msg.sender);
413 
414     // Compute amount owed to the investor
415     uint256 amount = scaledDividendBalances[msg.sender].div(scaling);
416     // Put back any remainder
417     scaledDividendBalances[msg.sender] %= scaling;
418 
419     // Send investor the Wei dividends
420     msg.sender.transfer(amount);
421 
422     emit Withdraw(amount, msg.sender);
423   }
424 }