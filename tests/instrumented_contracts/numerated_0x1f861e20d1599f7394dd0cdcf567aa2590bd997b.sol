1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     emit OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 
99 /**
100  * @title ERC20 interface
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  */
114 contract BasicToken is ERC20Basic, Ownable {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   uint256 totalSupply_;
120   
121   bool public stopped = false;
122   
123   event Stop(address indexed from);
124   
125   event Start(address indexed from);
126   
127   modifier isRunning {
128     assert (!stopped);
129     _;
130   }
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) isRunning public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256 ownerBalance) {
160     return balances[_owner];
161   }
162   
163   function stop() onlyOwner public {
164     stopped = true;
165     emit Stop(msg.sender);
166   }
167 
168   function start() onlyOwner public {
169     stopped = false;
170     emit Start(msg.sender);
171   }
172 
173 }
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) isRunning public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) isRunning public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) isRunning public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 /**
258  * @title Burnable Token
259  * @dev Token that can be irreversibly burned (destroyed).
260  */
261 contract BurnableToken is BasicToken {
262 
263   event Burn(address indexed burner, uint256 value);
264 
265   /**
266    * @dev Burns a specific amount of tokens.
267    * @param _value The amount of token to be burned.
268    */
269   function burn(uint256 _value) public {
270     _burn(msg.sender, _value);
271   }
272 
273   function _burn(address _who, uint256 _value) internal {
274     require(_value <= balances[_who]);
275     balances[_who] = balances[_who].sub(_value);
276     totalSupply_ = totalSupply_.sub(_value);
277     emit Burn(_who, _value);
278     emit Transfer(_who, address(0), _value);
279   }
280 }
281 
282 
283 /**
284  * @title CappedMintableToken token
285  */
286 contract CappedMintableToken is StandardToken {
287   event Mint(address indexed to, uint256 amount);
288   event MintFinished();
289   event MintingAgentChanged(address addr, bool state);
290 
291   uint256 public cap;
292 
293   bool public mintingFinished = false;
294   mapping (address => bool) public mintAgents;
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300   
301   modifier onlyMintAgent() {
302     // crowdsale contracts or owner are allowed to mint new tokens
303     if(!mintAgents[msg.sender] && (msg.sender != owner)) {
304         revert();
305     }
306     _;
307   }
308 
309 
310   constructor(uint256 _cap) public {
311     require(_cap > 0);
312     cap = _cap;
313   }
314 
315 
316   /**
317    * Owner can allow a crowdsale contract to mint new tokens.
318    */
319   function setMintAgent(address addr, bool state) onlyOwner canMint public {
320     mintAgents[addr] = state;
321     emit MintingAgentChanged(addr, state);
322   }
323   
324   /**
325    * @dev Function to mint tokens
326    * @param _to The address that will receive the minted tokens.
327    * @param _amount The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address _to, uint256 _amount) onlyMintAgent canMint isRunning public returns (bool) {
331     require(totalSupply_.add(_amount) <= cap);
332     totalSupply_ = totalSupply_.add(_amount);
333     balances[_to] = balances[_to].add(_amount);
334     emit Mint(_to, _amount);
335     emit Transfer(address(0), _to, _amount);
336     return true;
337   }
338 
339   /**
340    * @dev Function to stop minting new tokens.
341    * @return True if the operation was successful.
342    */
343   function finishMinting() onlyOwner canMint public returns (bool) {
344     mintingFinished = true;
345     emit MintFinished();
346     return true;
347   }
348 }
349 
350 /**
351  * @title Standard Burnable Token
352  * @dev Adds burnFrom method to ERC20 implementations
353  */
354 contract StandardBurnableToken is BurnableToken, StandardToken {
355 
356   /**
357    * @dev Burns a specific amount of tokens from the target address and decrements allowance
358    * @param _from address The address which you want to send tokens from
359    * @param _value uint256 The amount of token to be burned
360    */
361   function burnFrom(address _from, uint256 _value) public {
362     require(_value <= allowed[_from][msg.sender]);
363     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
364     _burn(_from, _value);
365   }
366 }
367 
368 
369 /**
370  * @title ODXToken
371  * @dev Simple ERC20 Token,   
372  * Tokens are mintable and burnable.
373  * No initial token upon creation
374  * Added max token supply
375  */
376 contract ODXToken is CappedMintableToken, StandardBurnableToken {
377 
378   string public name; 
379   string public symbol; 
380   uint8 public decimals; 
381 
382   /**
383    * @dev set totalSupply_ = 0;
384    */
385   constructor(
386       string _name, 
387       string _symbol, 
388       uint8 _decimals, 
389       uint256 _maxTokens
390   ) 
391     public 
392     CappedMintableToken(_maxTokens) 
393   {
394     name = _name;
395     symbol = _symbol;
396     decimals = _decimals;
397     totalSupply_ = 0;
398   }
399   
400   function () payable public {
401       revert();
402   }
403 
404 }