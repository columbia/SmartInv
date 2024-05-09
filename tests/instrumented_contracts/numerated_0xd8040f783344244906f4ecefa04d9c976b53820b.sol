1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 pragma solidity ^0.4.18;
51 
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
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 pragma solidity ^0.4.18;
94 
95 
96 /**
97  * @title Pausable
98  * @dev Base contract which allows children to implement an emergency stop mechanism.
99  */
100 contract Pausable is Ownable {
101   event Pause();
102   event Unpause();
103 
104   bool public paused = false;
105 
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is not paused.
109    */
110   modifier whenNotPaused() {
111     require(!paused);
112     _;
113   }
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is paused.
117    */
118   modifier whenPaused() {
119     require(paused);
120     _;
121   }
122 
123   /**
124    * @dev called by the owner to pause, triggers stopped state
125    */
126   function pause() onlyOwner whenNotPaused public {
127     paused = true;
128     Pause();
129   }
130 
131   /**
132    * @dev called by the owner to unpause, returns to normal state
133    */
134   function unpause() onlyOwner whenPaused public {
135     paused = false;
136     Unpause();
137   }
138 }
139 
140 pragma solidity ^0.4.18;
141 
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  */
148 contract ERC20Basic {
149   function totalSupply() public view returns (uint256);
150   function balanceOf(address who) public view returns (uint256);
151   function transfer(address to, uint256 value) public returns (bool);
152   event Transfer(address indexed from, address indexed to, uint256 value);
153 }
154 
155 pragma solidity ^0.4.18;
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public view returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 pragma solidity ^0.4.18;
169 
170 
171 /**
172  * @title Basic token
173  * @dev Basic version of StandardToken, with no allowances.
174  */
175 contract BasicToken is ERC20Basic {
176   using SafeMath for uint256;
177 
178   mapping(address => uint256) balances;
179 
180   uint256 totalSupply_;
181 
182   /**
183   * @dev total number of tokens in existence
184   */
185   function totalSupply() public view returns (uint256) {
186     return totalSupply_;
187   }
188 
189   /**
190   * @dev transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[msg.sender]);
197 
198     // SafeMath.sub will throw if there is not enough balance.
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     Transfer(msg.sender, _to, _value);
202     return true;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param _owner The address to query the the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address _owner) public view returns (uint256 balance) {
211     return balances[_owner];
212   }
213 
214 }
215 
216 
217 pragma solidity ^0.4.18;
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
287     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 pragma solidity ^0.4.18;
315 
316 /**
317  * @title Pausable token
318  * @dev StandardToken modified with pausable transfers.
319  **/
320 contract PausableToken is StandardToken, Pausable {
321 
322   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transfer(_to, _value);
324   }
325 
326   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
327     return super.transferFrom(_from, _to, _value);
328   }
329 
330   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
331     return super.approve(_spender, _value);
332   }
333 
334   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
335     return super.increaseApproval(_spender, _addedValue);
336   }
337 
338   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
339     return super.decreaseApproval(_spender, _subtractedValue);
340   }
341 }
342 
343 pragma solidity ^0.4.19;
344 
345 contract Token is PausableToken {
346 	string public name = "CCC"; // Token 名称
347 	string public symbol = "ECT"; // Token 标识 例如：ETH/EOS
348 	uint public decimals = 4; // 计量单位，1 ether == 10000 ccc
349 	uint public INITIAL_SUPPLY = 50000 * (10 ** decimals); // 初始供应量
350 
351 	function Token() public {
352 		totalSupply_ = INITIAL_SUPPLY; // 设置初始供应量
353 		balances[msg.sender] = INITIAL_SUPPLY; // 将所有初始 token 都存入 contract 创建者的余额
354 	}
355 
356     function crowdsale(address _crowdsale, uint256 _value) onlyOwner public {
357         require(_crowdsale != address(0));
358         require(_value <= balances[msg.sender]);
359         approve(_crowdsale, _value);
360     }
361 
362     event Burn(address indexed burner, uint256 value);
363 
364     function burn(uint256 _value) public {
365         require(_value <= balances[msg.sender]);
366         // no need to require value <= totalSupply, since that would imply the
367         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
368 
369         address burner = msg.sender;
370         balances[burner] = balances[burner].sub(_value);
371         totalSupply_ = totalSupply_.sub(_value);
372 
373         Burn(burner, _value);
374     }
375 
376     event Mint(address indexed to, uint256 amount);
377 
378     function mint(address _to, uint256 _amount) onlyOwner public {
379         totalSupply_ = totalSupply_.add(_amount);
380         balances[_to] = balances[_to].add(_amount);
381         Mint(_to, _amount);
382         Transfer(address(0), _to, _amount);
383     }
384 }