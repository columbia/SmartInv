1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 pragma solidity ^0.4.11;
48 
49 
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev modifier to allow actions only when the contract IS paused
64    */
65   modifier whenNotPaused() {
66     if (paused) throw;
67     _;
68   }
69 
70   /**
71    * @dev modifier to allow actions only when the contract IS NOT paused
72    */
73   modifier whenPaused {
74     if (!paused) throw;
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused returns (bool) {
82     paused = true;
83     Pause();
84     return true;
85   }
86 
87   /**
88    * @dev called by the owner to unpause, returns to normal state
89    */
90   function unpause() onlyOwner whenPaused returns (bool) {
91     paused = false;
92     Unpause();
93     return true;
94   }
95 }
96 
97 // File: zeppelin-solidity/contracts/math/SafeMath.sol
98 
99 pragma solidity ^0.4.11;
100 
101 
102 /**
103  * @title SafeMath
104  * @dev Math operations with safety checks that throw on error
105  */
106 library SafeMath {
107   function mul(uint256 a, uint256 b) internal returns (uint256) {
108     uint256 c = a * b;
109     assert(a == 0 || c / a == b);
110     return c;
111   }
112 
113   function div(uint256 a, uint256 b) internal returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   function sub(uint256 a, uint256 b) internal returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function add(uint256 a, uint256 b) internal returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
133 
134 pragma solidity ^0.4.11;
135 
136 
137 /**
138  * @title ERC20Basic
139  * @dev Simpler version of ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20Basic {
143   uint256 public totalSupply;
144   function balanceOf(address who) constant returns (uint256);
145   function transfer(address to, uint256 value);
146   event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 // File: zeppelin-solidity/contracts/token/BasicToken.sol
150 
151 pragma solidity ^0.4.11;
152 
153 
154 
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   /**
166   * @dev transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) {
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     Transfer(msg.sender, _to, _value);
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) constant returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 // File: zeppelin-solidity/contracts/token/ERC20.sol
188 
189 pragma solidity ^0.4.11;
190 
191 
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198   function allowance(address owner, address spender) constant returns (uint256);
199   function transferFrom(address from, address to, uint256 value);
200   function approve(address spender, uint256 value);
201   event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 // File: zeppelin-solidity/contracts/token/StandardToken.sol
205 
206 pragma solidity ^0.4.11;
207 
208 
209 
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
220   mapping (address => mapping (address => uint256)) allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amout of tokens to be transfered
228    */
229   function transferFrom(address _from, address _to, uint256 _value) {
230     var _allowance = allowed[_from][msg.sender];
231 
232     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
233     // if (_value > _allowance) throw;
234 
235     balances[_to] = balances[_to].add(_value);
236     balances[_from] = balances[_from].sub(_value);
237     allowed[_from][msg.sender] = _allowance.sub(_value);
238     Transfer(_from, _to, _value);
239   }
240 
241   /**
242    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) {
247 
248     // To change the approve amount you first have to reduce the addresses`
249     //  allowance to zero by calling `approve(_spender, 0)` if it is not
250     //  already 0 to mitigate the race condition described here:
251     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
253 
254     allowed[msg.sender][_spender] = _value;
255     Approval(msg.sender, _spender, _value);
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifing the amount of tokens still avaible for the spender.
263    */
264   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
265     return allowed[_owner][_spender];
266   }
267 
268 }
269 
270 // File: contracts/EightBitToken.sol
271 
272 pragma solidity ^0.4.8;
273 
274 
275 
276 
277 contract EightBitToken is StandardToken, Pausable {
278   using SafeMath for uint256;
279 
280   string public constant name = '8 Circuit Studios Token';
281   string public constant symbol = '8BT';
282   uint256 public constant decimals = 18;
283 
284   uint256 public cap;
285   uint256 public rate;
286   uint256 public startBlock;
287   uint256 public endBlock;
288   uint256 public sold;
289 
290   event Sale(address indexed from, address indexed to, uint256 value, uint256 price);
291 
292   function EightBitToken() {
293     totalSupply = 100 * (10**6) * 10**decimals;
294     balances[owner] = totalSupply;
295   }
296 
297   function () payable {
298     buy(msg.sender);
299   }
300 
301   function startSale(uint256 _cap, uint256 _rate, uint256 _startBlock, uint256 _endBlock) onlyOwner {
302     require(cap == 0);
303     require(_cap > 0);
304     require(balances[owner] >= _cap);
305     require(_rate > 0);
306     require(block.number <= _startBlock);
307     require(_endBlock >= _startBlock);
308 
309     cap = _cap;
310     rate = _rate;
311     startBlock = _startBlock;
312     endBlock = _endBlock;
313   }
314 
315   function buy(address _to) whenNotPaused payable {
316     require(block.number >= startBlock && block.number <= endBlock);
317     require(msg.value > 0);
318     require(_to != 0x0);
319 
320     uint256 tokens = msg.value.mul(rate);
321 
322     sold = sold.add(tokens);
323     assert(sold <= cap);
324 
325     balances[owner] = balances[owner].sub(tokens);
326     balances[_to] = balances[_to].add(tokens);
327 
328     assert(owner.send(msg.value));
329 
330     Sale(owner, _to, tokens, msg.value);
331   }
332 
333   function endSale() onlyOwner {
334     cap = 0;
335     rate = 0;
336     startBlock = 0;
337     endBlock = 0;
338     sold = 0;
339   }
340 
341   // ERC20 overrides
342   function transfer(address _to, uint256 _value) whenNotPaused {
343     super.transfer(_to, _value);
344   }
345 
346   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused {
347     super.transferFrom(_from, _to, _value);
348   }
349 }