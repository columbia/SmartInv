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
23      // assert(b > 0); // Solidity automatically revert()s when dividing by 0
24      // uint256 c = a / b;
25      // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26      return a / b;
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
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implemantation of the basic standart token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is BasicToken, ERC20 {
124 
125   mapping (address => mapping (address => uint)) allowed;
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint the amout of tokens to be transfered
132    */
133   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
134     require(_to != 0x0);
135     uint _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
138     // if (_value > _allowance) revert();
139 
140     balances[_to] = balances[_to].add(_value);
141     balances[_from] = balances[_from].sub(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     emit Transfer(_from, _to, _value);
144   }
145 
146   /**
147    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint _value) {
152 
153     // To change the approve amount you first have to reduce the addresses`
154     //  allowance to zero by calling `approve(_spender, 0)` if it is not
155     //  already 0 to mitigate the race condition described here:
156     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
158 
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens than an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint specifing the amount of tokens still avaible for the spender.
168    */
169   function allowance(address _owner, address _spender) constant returns (uint remaining) {
170     return allowed[_owner][_spender];
171   }
172 }
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180   address public owner;
181   /**
182    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183    * account.
184    */
185   function Ownable() {
186     owner = msg.sender;
187   }
188 
189   /**
190    * @dev revert()s if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     if (msg.sender != owner) {
194       revert();
195     }
196     _;
197   }
198 
199   /**
200    * @dev Allows the current owner to transfer control of the contract to a newOwner.
201    * @param newOwner The address to transfer ownership to.
202    */
203   function transferOwnership(address newOwner) onlyOwner {
204     if (newOwner != address(0)) {
205       owner = newOwner;
206     }
207   }
208 }
209 
210 /**
211  * @title Pausable
212  * @dev Base contract which allows children to implement an emergency stop mechanism.
213  */
214 contract Pausable is Ownable {
215   event Pause();
216   event Unpause();
217 
218   bool public paused = false;
219 
220   /**
221    * @dev modifier to allow actions only when the contract IS paused
222    */
223   modifier whenNotPaused() {
224     if (paused) revert();
225     _;
226   }
227 
228   /**
229    * @dev modifier to allow actions only when the contract IS NOT paused
230    */
231   modifier whenPaused {
232     if (!paused) revert();
233     _;
234   }
235 
236   /**
237    * @dev called by the owner to pause, triggers stopped state
238    */
239   function pause() onlyOwner whenNotPaused returns (bool) {
240     paused = true;
241     emit Pause();
242     return true;
243   }
244 
245   /**
246    * @dev called by the owner to unpause, returns to normal state
247    */
248   function unpause() onlyOwner whenPaused returns (bool) {
249     paused = false;
250     emit Unpause();
251     return true;
252   }
253 }
254 
255 
256 /**
257  * Pausable token
258  *
259  * Simple ERC20 Token example, with pausable token creation
260  **/
261 
262 contract PausableToken is StandardToken, Pausable {
263 
264   function transfer(address _to, uint _value) whenNotPaused {
265     super.transfer(_to, _value);
266   }
267 
268   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
269     super.transferFrom(_from, _to, _value);
270   }
271 }
272 
273 /**
274  * @title TokenTimelock
275  * @dev TokenTimelock is a token holder contract that will allow a
276  * beneficiary to extract the tokens after a time has passed
277  */
278 contract TokenTimelock {
279 
280   // ERC20 basic token contract being held
281   ERC20Basic token;
282 
283   // beneficiary of tokens after they are released
284   address beneficiary;
285 
286   // timestamp where token release is enabled
287   uint releaseTime;
288 
289   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
290     require(_releaseTime > now);
291     token = _token;
292     beneficiary = _beneficiary;
293     releaseTime = _releaseTime;
294   }
295 
296   /**
297    * @dev beneficiary claims tokens held by time lock
298    */
299   function claim() {
300     require(msg.sender == beneficiary);
301     require(now >= releaseTime);
302 
303     uint amount = token.balanceOf(this);
304     require(amount > 0);
305 
306     token.transfer(beneficiary, amount);
307   }
308 }
309 
310 /**
311  * @title CNYTokenPlus
312  * @dev CNY Token Plus contract
313  */
314 contract CNYTokenPlus is PausableToken {
315   using SafeMath for uint256;
316 
317   function () {
318       //if ether is sent to this address, send it back.
319       revert();
320   }
321 
322   string public name = "CNYTokenPlus";
323   string public symbol = "CTP";
324   uint8 public decimals = 18;
325   uint public totalSupply = 100000000000000000000000000;
326   string public version = 'CNYt⁺ 3.0';
327   // The nonce for avoid transfer replay attacks
328   mapping(address => uint256) nonces;
329 
330   event Burn(address indexed burner, uint256 value);
331   event TimeLock(address indexed to, uint value, uint time);
332 
333   function CNYTokenPlus() {
334       balances[msg.sender] = totalSupply;              // Give the creator all initial tokens
335   }
336 
337   /**
338    * @dev transfer timelocked tokens
339    */
340   function transferTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
341     onlyOwner whenNotPaused returns (TokenTimelock) {
342 
343     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
344     transfer(timelock,_amount);
345     emit TimeLock(_to, _amount,_releaseTime);
346 
347     return timelock;
348   }
349 
350   /**
351    * @dev Burns a specific amount of tokens.
352    * @param _value The amount of token to be burned.
353    */
354   function burn(uint256 _value) onlyOwner whenNotPaused {
355     _burn(msg.sender, _value);
356   }
357 
358   function _burn(address _who, uint256 _value) internal {
359     require(_value <= balances[_who]);
360     // no need to require value <= totalSupply, since that would imply the
361     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
362 
363     balances[_who] = balances[_who].sub(_value);
364     totalSupply = totalSupply.sub(_value);
365     emit Burn(_who, _value);
366     emit Transfer(_who, address(0), _value);
367   }
368 
369   /*
370    * Proxy transfer HC token. When some users of the ethereum account don't have ether,
371    * Who can authorize the agent for broadcast transactions, the agents may charge fees
372    * @param _from
373    * @param _to
374    * @param _value
375    * @param fee
376    * @param _v
377    * @param _r
378    * @param _s
379    * @param _comment
380    */
381   function transferProxy(address _from, address _to, uint256 _value, uint256 _fee,
382       uint8 _v, bytes32 _r, bytes32 _s) whenNotPaused {
383 
384       require((balances[_from] >= _fee.add(_value)));
385       require(balances[_to].add(_value) >= balances[_to]);
386       require(balances[msg.sender].add(_fee) >= balances[msg.sender]);
387 
388       uint256 nonce = nonces[_from];
389       bytes32 hash = keccak256(_from,_to,_value,_fee,nonce);
390       bytes memory prefix = "\x19Ethereum Signed Message:\n32";
391       bytes32 prefixedHash = keccak256(prefix, hash);
392       require(_from == ecrecover(prefixedHash,_v,_r,_s));
393 
394       balances[_from] = balances[_from].sub(_value.add(_fee));
395       balances[_to] = balances[_to].add(_value);
396       balances[msg.sender] = balances[msg.sender].add(_fee);
397       nonces[_from] = nonce.add(1);
398 
399       emit Transfer(_from, _to, _value);
400       emit Transfer(_from, msg.sender, _fee);
401   }
402 }