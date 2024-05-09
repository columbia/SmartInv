1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------
4 // Based on code by OpenZeppelin
5 // ----------------------------------------------------------------------
6 // Copyright (c) 2016 Smart Contract Solutions, Inc.
7 // Released under the MIT license
8 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE
9 // ----------------------------------------------------------------------
10 
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   /**
41   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
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
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused public {
129     paused = true;
130     Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() onlyOwner whenPaused public {
137     paused = false;
138     Unpause();
139   }
140 }
141 
142 /**
143  * @title ERC20Basic
144  * @dev Simpler version of ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/179
146  */
147 contract ERC20Basic {
148   function totalSupply() public view returns (uint256);
149   function balanceOf(address who) public view returns (uint256);
150   function transfer(address to, uint256 value) public returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
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
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint256;
172 
173   mapping(address => uint256) balances;
174 
175   uint256 totalSupply_;
176 
177   /**
178   * @dev total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    *
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param _spender The address which will spend the funds.
249    * @param _value The amount of tokens to be spent.
250    */
251   function approve(address _spender, uint256 _value) public returns (bool) {
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifying the amount of tokens still available for the spender.
262    */
263   function allowance(address _owner, address _spender) public view returns (uint256) {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
278     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 /**
307  * @title Mintable token
308  * @dev Simple ERC20 Token example, with mintable token creation
309  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
310  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
311  */
312 contract MintableToken is StandardToken, Ownable {
313   event Mint(address indexed to, uint256 amount);
314   event MintFinished();
315 
316   bool public mintingFinished = false;
317 
318 
319   modifier canMint() {
320     require(!mintingFinished);
321     _;
322   }
323 
324   /**
325    * @dev Function to mint tokens
326    * @param _to The address that will receive the minted tokens.
327    * @param _amount The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
331     totalSupply_ = totalSupply_.add(_amount);
332     balances[_to] = balances[_to].add(_amount);
333     Mint(_to, _amount);
334     Transfer(address(0), _to, _amount);
335     return true;
336   }
337 
338   /**
339    * @dev Function to stop minting new tokens.
340    * @return True if the operation was successful.
341    */
342   function finishMinting() onlyOwner canMint public returns (bool) {
343     mintingFinished = true;
344     MintFinished();
345     return true;
346   }
347 }
348 
349 /**
350  * @title Pausable token
351  * @dev StandardToken modified with pausable transfers.
352  **/
353 contract PausableToken is StandardToken, Pausable {
354 
355   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
356     return super.transfer(_to, _value);
357   }
358 
359   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
360     return super.transferFrom(_from, _to, _value);
361   }
362 
363   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
364     return super.approve(_spender, _value);
365   }
366 
367   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
368     return super.increaseApproval(_spender, _addedValue);
369   }
370 
371   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
372     return super.decreaseApproval(_spender, _subtractedValue);
373   }
374 }
375 
376 
377 /**
378  * @title Burnable Token
379  * @dev Token that can be irreversibly burned (destroyed).
380  */
381 contract BurnableToken is BasicToken {
382 
383   event Burn(address indexed burner, uint256 value);
384 
385   /**
386    * @dev Burns a specific amount of tokens.
387    * @param _value The amount of token to be burned.
388    */
389   function burn(uint256 _value) public {
390     require(_value <= balances[msg.sender]);
391     // no need to require value <= totalSupply, since that would imply the
392     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
393 
394     address burner = msg.sender;
395     balances[burner] = balances[burner].sub(_value);
396     totalSupply_ = totalSupply_.sub(_value);
397     Burn(burner, _value);
398   }
399 }
400 
401 contract TkoToken is MintableToken, BurnableToken, PausableToken {
402 
403     string public constant name = 'TkoToken';
404 
405     string public constant symbol = 'TKO';
406 
407     uint public constant decimals = 18;
408 
409 }