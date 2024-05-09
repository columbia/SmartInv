1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-13
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 // File: zeppelin-solidity/contracts/token/BasicToken.sol
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65   mapping(address => bool) internal locks;
66   mapping(address => mapping(address => uint256)) internal allowed;
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
93 
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
97 
98 /**
99  * @title Burnable Token
100  * @dev Token that can be irreversibly burned (destroyed).
101  */
102 contract BurnableToken is BasicToken {
103 
104     event Burn(address indexed burner, uint256 value);
105 
106     /**
107      * @dev Burns a specific amount of tokens.
108      * @param _value The amount of token to be burned.
109      */
110     function burn(uint256 _value) public {
111         require(_value <= balances[msg.sender]);
112         // no need to require value <= totalSupply, since that would imply the
113         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
114 
115         address burner = msg.sender;
116         balances[burner] = balances[burner].sub(_value);
117         totalSupply = totalSupply.sub(_value);
118         Burn(burner, _value);
119     }
120 
121     
122 }
123 
124 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
125 
126 /**
127  * @title Ownable
128  * @dev The Ownable contract has an owner address, and provides basic authorization control
129  * functions, this simplifies the implementation of "user permissions".
130  */
131 contract Ownable {
132   address public owner;
133 
134 
135   function Ownable() public {
136     owner = msg.sender;
137   }
138 
139 
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }
144 }
145 contract Pausable is Ownable {
146   event Pause();
147   event Unpause();
148 
149   bool public paused = false;
150 
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is not paused.
154    */
155   modifier whenNotPaused() {
156     require(!paused);
157     _;
158   }
159 
160   /**
161    * @dev Modifier to make a function callable only when the contract is paused.
162    */
163   modifier whenPaused() {
164     require(paused);
165     _;
166   }
167 
168   /**
169    * @dev called by the owner to pause, triggers stopped state
170    */
171   function pause() onlyOwner whenNotPaused public {
172     paused = true;
173      Pause();
174   }
175 
176   /**
177    * @dev called by the owner to unpause, returns to normal state
178    */
179   function unpause() onlyOwner whenPaused public {
180     paused = false;
181      Unpause();
182   }
183 
184     
185 }
186 
187 
188 // File: zeppelin-solidity/contracts/token/ERC20.sol
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 // File: zeppelin-solidity/contracts/token/StandardToken.sol
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    *
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(address _owner, address _spender) public view returns (uint256) {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
270     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 // File: zeppelin-solidity/contracts/token/MintableToken.sol
299 
300 /**
301  * @title Mintable token
302  * @dev Simple ERC20 Token example, with mintable token creation
303  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
304  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
305  */
306 
307 contract MintableToken is StandardToken, Ownable {
308   event Mint(address indexed to, uint256 amount);
309   event MintFinished();
310 
311   bool public mintingFinished = false;
312 
313 
314   modifier canMint() {
315     require(!mintingFinished);
316     _;
317   }
318 
319   /**
320    * @dev Function to mint tokens
321    * @param _to The address that will receive the minted tokens.
322    * @param _amount The amount of tokens to mint.
323    * @return A boolean that indicates if the operation was successful.
324    */
325   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
326     totalSupply = totalSupply.add(_amount);
327     balances[_to] = balances[_to].add(_amount);
328     Mint(_to, _amount);
329     Transfer(address(0), _to, _amount);
330     return true;
331   }
332 
333 }
334 
335 // File: zeppelin-solidity/contracts/token/CappedToken.sol
336 
337 /**
338  * @title Capped token
339  * @dev Mintable token with a token cap.
340  */
341 
342 contract CappedToken is MintableToken {
343 
344   uint256 public cap;
345 
346   function CappedToken(uint256 _cap) public {
347     require(_cap > 0);
348     cap = _cap;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
358     require(totalSupply.add(_amount) <= cap);
359 
360     return super.mint(_to, _amount);
361   }
362 
363 }
364 
365 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
366 
367 contract DetailedERC20 is ERC20 {
368   string public name;
369   string public symbol;
370   uint8 public decimals;
371 
372   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
373     name = _name;
374     symbol = _symbol;
375     decimals = _decimals;
376   }
377   
378 }
379 
380 
381 
382 
383 
384 
385 contract AndCoin is DetailedERC20, StandardToken, BurnableToken, CappedToken, Pausable {
386   /**
387    * @dev Set the maximum issuance cap and token details.
388    */
389   function AndCoin()
390     DetailedERC20('AndCoin', 'AND', 18)
391     CappedToken( 50 * (10**9) * (10**18) )
392   public{
393 
394   }
395   
396 }