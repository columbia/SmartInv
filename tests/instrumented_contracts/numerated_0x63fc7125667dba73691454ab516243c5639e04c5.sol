1 pragma solidity ^0.4.24;
2 
3 // File: c:/ich/Contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: c:/ich/Contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: c:/ich/Contracts/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: c:/ich/Contracts/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     emit Burn(burner, _value);
135     emit Transfer(burner, address(0), _value);
136   }
137 }
138 
139 // File: c:/ich/Contracts/ERC20.sol
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   function setCrowdsale(address tokenWallet, uint256 amount) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 // File: c:/ich/Contracts/StandardToken.sol
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public view returns (uint256) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
222     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 // File: c:/ich/Contracts/Ownable.sol
251 
252 /**
253  * @title Ownable
254  * @dev The Ownable contract has an owner address, and provides basic authorization control
255  * functions, this simplifies the implementation of "user permissions".
256  */
257 contract Ownable {
258   address public owner;
259 
260 
261   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263 
264   /**
265    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
266    * account.
267    */
268   function Ownable() public {
269     owner = msg.sender;
270   }
271 
272   /**
273    * @dev Throws if called by any account other than the owner.
274    */
275   modifier onlyOwner() {
276     require(msg.sender == owner);
277     _;
278   }
279 
280   /**
281    * @dev Allows the current owner to transfer control of the contract to a newOwner.
282    * @param newOwner The address to transfer ownership to.
283    */
284   function transferOwnership(address newOwner) public onlyOwner {
285     require(newOwner != address(0));
286     emit OwnershipTransferred(owner, newOwner);
287     owner = newOwner;
288   }
289 
290 }
291 
292 // File: c:/ich/Contracts/MintableToken.sol
293 
294 /**
295  * @title Mintable token
296  * @dev Simple ERC20 Token example, with mintable token creation
297  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
298  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
299  */
300 contract MintableToken is StandardToken, Ownable {
301   event Mint(address indexed to, uint256 amount);
302   event MintFinished();
303 
304   bool public mintingFinished = false;
305 
306 
307   modifier canMint() {
308     require(!mintingFinished);
309     _;
310   }
311 
312   /**
313    * @dev Function to mint tokens
314    * @param _to The address that will receive the minted tokens.
315    * @param _amount The amount of tokens to mint.
316    * @return A boolean that indicates if the operation was successful.
317    */
318   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
319     totalSupply_ = totalSupply_.add(_amount);
320     balances[_to] = balances[_to].add(_amount);
321     emit Mint(_to, _amount);
322     emit Transfer(address(0), _to, _amount);
323     return true;
324   }
325 
326   /**
327    * @dev Function to stop minting new tokens.
328    * @return True if the operation was successful.
329    */
330   function finishMinting() onlyOwner canMint public returns (bool) {
331     mintingFinished = true;
332     emit MintFinished();
333     return true;
334   }
335 }
336 
337 // File: c:/ich/Contracts/DetailedERC20.sol
338 
339 contract DetailedERC20 is ERC20 {
340   string public name;
341   string public symbol;
342   uint8 public decimals;
343 
344   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
345     name = _name;
346     symbol = _symbol;
347     decimals = _decimals;
348   }
349 }
350 
351 // File: C:/ich/Contracts/depToken.sol
352 
353 contract tokenContract is BurnableToken, MintableToken, DetailedERC20 {
354 
355   uint256 constant internal DECIMALS = 18;
356 
357 constructor (string _name, string _symbol, uint256 _initialSupply, address realOwner) public
358     DetailedERC20(_name, _symbol, uint8(DECIMALS))
359    {
360     require(_initialSupply > 0);
361     totalSupply_ = _initialSupply;
362     balances[realOwner] = _initialSupply;
363     emit Mint(realOwner, _initialSupply);
364     emit Transfer(address(0), realOwner, _initialSupply);
365     transferOwnership(realOwner);
366   }
367 
368   function setCrowdsale(address tokenWallet, uint maxToken) public returns (bool) {
369     if(tx.origin == owner && balances[tokenWallet] >= maxToken){
370       allowed[tokenWallet][msg.sender] = maxToken;
371       emit Approval(tokenWallet, msg.sender, maxToken);
372       return true;
373     }else{
374       return false;
375     }
376   }
377 
378   /**
379   * @dev Transfers the same amount of tokens to up to 200 specified addresses.
380   * If the sender runs out of balance then the entire transaction fails.
381   * @param _to The addresses to transfer to.
382   * @param _value The amount to be transferred to each address.
383   */
384   function airdrop(address[] _to, uint256 _value) public
385   {
386     require(_to.length <= 200);
387     require(balanceOf(msg.sender) >= _value.mul(_to.length));
388 
389     for (uint i = 0; i < _to.length; i++)
390     {
391       transfer(_to[i], _value);
392     }
393   }
394 
395   /**
396   * @dev Transfers a variable amount of tokens to up to 200 specified addresses.
397   * If the sender runs out of balance then the entire transaction fails.
398   * For each address a value must be specified.
399   * @param _to The addresses to transfer to.
400   * @param _values The amounts to be transferred to the addresses.
401   */
402   function multiTransfer(address[] _to, uint256[] _values) public
403   {
404     require(_to.length <= 200);
405     require(_to.length == _values.length);
406 
407     for (uint i = 0; i < _to.length; i++)
408     {
409       transfer(_to[i], _values[i]);
410     }
411   }
412 }
413 
414 
415 // File: ..\Contracts\tDep.sol
416 
417 contract tDeployer is Ownable {
418 
419 	address private main;
420 
421 	function cMain(address nM) public onlyOwner {
422 		main = nM;
423 	}
424 
425     function deployToken(string _tName, string _tSymbol, uint _mint, address _owner) public returns (address) {
426 		require(msg.sender == main);
427 		tokenContract newContract = new tokenContract(_tName, _tSymbol, _mint, _owner);
428 		return newContract;
429 	}
430 
431 
432 }