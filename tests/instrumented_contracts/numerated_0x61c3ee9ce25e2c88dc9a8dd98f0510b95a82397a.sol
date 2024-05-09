1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6  library SafeMath {
7    /**
8    * @dev Multiplies two numbers, revert()s on overflow.
9    */
10    function mul(uint256 a, uint256 b) internal returns (uint256 c) {
11      if (a == 0) {
12        return 0;
13      }
14      c = a * b;
15      assert(c / a == b);
16      return c;
17    }
18 
19    /**
20    * @dev Integer division of two numbers, truncating the quotient.
21    */
22    function div(uint256 a, uint256 b) internal returns (uint256) {
23      assert(b > 0);
24      uint256 c = a / b;
25      assert(a == b * c + a % b);
26      return c;
27    }
28 
29    /**
30    * @dev Subtracts two numbers, revert()s on overflow (i.e. if subtrahend is greater than minuend).
31    */
32    function sub(uint256 a, uint256 b) internal returns (uint256) {
33      assert(b <= a);
34      return a - b;
35    }
36 
37    /**
38    * @dev Adds two numbers, revert()s on overflow.
39    */
40    function add(uint256 a, uint256 b) internal returns (uint256 c) {
41      c = a + b;
42      assert(c >= a && c >= b);
43      return c;
44    }
45 
46    function assert(bool assertion) internal {
47      if (!assertion) {
48        revert();
49      }
50    }
51  }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20Basic {
59   function balanceOf(address who) constant returns (uint);
60   function transfer(address to, uint value);
61   event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint;
70 
71   mapping(address => uint) balances;
72 
73   /**
74    * @dev Fix for the ERC20 short address attack.
75    */
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length < size.add(4)) {
78        revert();
79      }
80      _;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
89     require(_to != 0x0);
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) constant returns (uint balance) {
101     return balances[_owner];
102   }
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) constant returns (uint);
111   function transferFrom(address from, address to, uint value);
112   function approve(address spender, uint value);
113   event Approval(address indexed owner, address indexed spender, uint value);
114 }
115 
116 
117 contract StandardToken is BasicToken, ERC20 {
118 
119   mapping (address => mapping (address => uint)) allowed;
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint the amout of tokens to be transfered
126    */
127   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
128     require(_to != 0x0);
129     uint _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
132     // if (_value > _allowance) revert();
133 
134     balances[_to] = balances[_to].add(_value);
135     balances[_from] = balances[_from].sub(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     emit Transfer(_from, _to, _value);
138   }
139 
140   /**
141    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint _value) {
146 
147     // To change the approve amount you first have to reduce the addresses`
148     //  allowance to zero by calling `approve(_spender, 0)` if it is not
149     //  already 0 to mitigate the race condition described here:
150     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
152 
153     allowed[msg.sender][_spender] = _value;
154     emit Approval(msg.sender, _spender, _value);
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens than an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint specifing the amount of tokens still avaible for the spender.
162    */
163   function allowance(address _owner, address _spender) constant returns (uint remaining) {
164     return allowed[_owner][_spender];
165   }
166 }
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174   address public owner;
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   function Ownable() {
180     owner = msg.sender;
181   }
182 
183   /**
184    * @dev revert()s if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     if (msg.sender != owner) {
188       revert();
189     }
190     _;
191   }
192 
193   /**
194    * @dev Allows the current owner to transfer control of the contract to a newOwner.
195    * @param newOwner The address to transfer ownership to.
196    */
197   function transferOwnership(address newOwner) onlyOwner {
198     if (newOwner != address(0)) {
199       owner = newOwner;
200     }
201   }
202 }
203 
204 /**
205  * @title Pausable
206  * @dev Base contract which allows children to implement an emergency stop mechanism.
207  */
208 contract Pausable is Ownable {
209   event Pause();
210   event Unpause();
211 
212   bool public paused = false;
213 
214   /**
215    * @dev modifier to allow actions only when the contract IS paused
216    */
217   modifier whenNotPaused() {
218     if (paused) revert();
219     _;
220   }
221 
222   /**
223    * @dev modifier to allow actions only when the contract IS NOT paused
224    */
225   modifier whenPaused {
226     if (!paused) revert();
227     _;
228   }
229 
230   /**
231    * @dev called by the owner to pause, triggers stopped state
232    */
233   function pause() onlyOwner whenNotPaused returns (bool) {
234     paused = true;
235     emit Pause();
236     return true;
237   }
238 
239   /**
240    * @dev called by the owner to unpause, returns to normal state
241    */
242   function unpause() onlyOwner whenPaused returns (bool) {
243     paused = false;
244     emit Unpause();
245     return true;
246   }
247 }
248 
249 
250 /**
251  * Pausable token
252  *
253  * Simple ERC20 Token example, with pausable token creation
254  **/
255 
256 contract PausableToken is StandardToken, Pausable {
257 
258   function transfer(address _to, uint _value) whenNotPaused {
259     super.transfer(_to, _value);
260   }
261 
262   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
263     super.transferFrom(_from, _to, _value);
264   }
265 }
266 
267 
268 /**
269  * @title TokenTimelock
270  * @dev TokenTimelock is a token holder contract that will allow a
271  * beneficiary to extract the tokens after a time has passed
272  */
273 contract TokenTimelock {
274 
275   // ERC20 basic token contract being held
276   ERC20Basic token;
277 
278   // beneficiary of tokens after they are released
279   address beneficiary;
280 
281   // timestamp where token release is enabled
282   uint releaseTime;
283 
284   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
285     require(_releaseTime > now);
286     token = _token;
287     beneficiary = _beneficiary;
288     releaseTime = _releaseTime;
289   }
290 
291   /**
292    * @dev beneficiary claims tokens held by time lock
293    */
294   function claim() {
295     require(msg.sender == beneficiary);
296     require(now >= releaseTime);
297 
298     uint amount = token.balanceOf(this);
299     require(amount > 0);
300 
301     token.transfer(beneficiary, amount);
302   }
303 }
304 
305 /**
306  * @title give-token chain Token
307  * @dev give-token chain Token contract
308  */
309 contract GITToken is PausableToken {
310   using SafeMath for uint256;
311 
312   function () {
313       //if ether is sent to this address, send it back.
314       revert();
315   }
316 
317   string public name = "givetoken";
318   string public symbol = "GIT";
319   uint8 public decimals = 18;
320   uint public totalSupply = 100000000000000000000000000;
321 
322   event TimeLock(address indexed to, uint value, uint time);
323   event Burn(address indexed burner, uint256 value);
324 
325   function GITToken() {
326       balances[msg.sender] = totalSupply;              // Give the creator all initial tokens
327   }
328 
329   /**
330    * @dev transfer timelocked tokens
331    */
332   function transferTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
333     onlyOwner whenNotPaused returns (TokenTimelock) {
334     require(_to != 0x0);
335 
336     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
337     transfer(timelock,_amount);
338     emit TimeLock(_to, _amount,_releaseTime);
339 
340     return timelock;
341   }
342 
343   /**
344    * @dev Burns a specific amount of tokens.
345    * @param _value The amount of token to be burned.
346    */
347   function burn(uint256 _value) onlyOwner whenNotPaused {
348     _burn(msg.sender, _value);
349   }
350 
351   function _burn(address _who, uint256 _value) internal {
352     require(_value <= balances[_who]);
353     // no need to require value <= totalSupply, since that would imply the
354     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
355 
356     balances[_who] = balances[_who].sub(_value);
357     totalSupply = totalSupply.sub(_value);
358     emit Burn(_who, _value);
359     emit Transfer(_who, address(0), _value);
360   }
361 }