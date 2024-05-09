1 pragma solidity ^0.4.23;
2 
3 /**
4  * Contributors
5  * Andrey Shishkin motive.do@gmail.com
6  * Scott Yu scott@aqwire.io
7  */
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 /**
51  * @title Whitelist
52  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
53  * @dev This simplifies the implementation of "user permissions".
54  */
55 contract Whitelist is Ownable {
56   mapping(address => bool) public whitelist;
57 
58   event WhitelistedAddressAdded(address addr);
59   event WhitelistedAddressRemoved(address addr);
60 
61   /**
62    * @dev Throws if called by any account that's not whitelisted.
63    */
64   modifier onlyWhitelisted() {
65     require(whitelist[msg.sender]);
66     _;
67   }
68 
69   /**
70    * @dev add an address to the whitelist
71    * @param addr address
72    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
73    */
74   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
75     if (!whitelist[addr]) {
76       whitelist[addr] = true;
77       emit WhitelistedAddressAdded(addr);
78       success = true;
79     }
80   }
81 
82   /**
83    * @dev add addresses to the whitelist
84    * @param addrs addresses
85    * @return true if at least one address was added to the whitelist,
86    * false if all addresses were already in the whitelist
87    */
88   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
89     for (uint256 i = 0; i < addrs.length; i++) {
90       if (addAddressToWhitelist(addrs[i])) {
91         success = true;
92       }
93     }
94   }
95 
96   /**
97    * @dev remove an address from the whitelist
98    * @param addr address
99    * @return true if the address was removed from the whitelist,
100    * false if the address wasn't in the whitelist in the first place
101    */
102   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
103     if (whitelist[addr]) {
104       whitelist[addr] = false;
105       emit WhitelistedAddressRemoved(addr);
106       success = true;
107     }
108   }
109 
110   /**
111    * @dev remove addresses from the whitelist
112    * @param addrs addresses
113    * @return true if at least one address was removed from the whitelist,
114    * false if all addresses weren't in the whitelist in the first place
115    */
116   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
117     for (uint256 i = 0; i < addrs.length; i++) {
118       if (removeAddressFromWhitelist(addrs[i])) {
119         success = true;
120       }
121     }
122   }
123 
124 }
125 
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that throw on error
130  */
131 library SafeMath {
132 
133   /**
134   * @dev Multiplies two numbers, throws on overflow.
135   */
136   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     if (a == 0) {
138       return 0;
139     }
140     c = a * b;
141     assert(c / a == b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     // uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return a / b;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
167     c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 
174 /**
175  * @title ERC20Basic
176  * @dev Simpler version of ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/179
178  */
179 contract ERC20Basic {
180   function totalSupply() public view returns (uint256);
181   function balanceOf(address who) public view returns (uint256);
182   function transfer(address to, uint256 value) public returns (bool);
183   event Transfer(address indexed from, address indexed to, uint256 value);
184 }
185 
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param _owner The address to query the the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address _owner) public view returns (uint256) {
226     return balances[_owner];
227   }
228 
229 }
230 
231 
232 /**
233  * @title Burnable Token
234  * @dev Token that can be irreversibly burned (destroyed).
235  */
236 contract BurnableToken is BasicToken {
237 
238   event Burn(address indexed burner, uint256 value);
239 
240   /**
241    * @dev Burns a specific amount of tokens.
242    * @param _value The amount of token to be burned.
243    */
244   function burn(uint256 _value) public {
245     _burn(msg.sender, _value);
246   }
247 
248   function _burn(address _who, uint256 _value) internal {
249     require(_value <= balances[_who]);
250     // no need to require value <= totalSupply, since that would imply the
251     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
252 
253     balances[_who] = balances[_who].sub(_value);
254     totalSupply_ = totalSupply_.sub(_value);
255     emit Burn(_who, _value);
256     emit Transfer(_who, address(0), _value);
257   }
258 }
259 
260 
261 /**
262  * @title ERC20 interface
263  * @dev see https://github.com/ethereum/EIPs/issues/20
264  */
265 contract ERC20 is ERC20Basic {
266   function allowance(address owner, address spender) public view returns (uint256);
267   function transferFrom(address from, address to, uint256 value) public returns (bool);
268   function approve(address spender, uint256 value) public returns (bool);
269   event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * @dev https://github.com/ethereum/EIPs/issues/20
278  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281 
282   mapping (address => mapping (address => uint256)) internal allowed;
283 
284 
285   /**
286    * @dev Transfer tokens from one address to another
287    * @param _from address The address which you want to send tokens from
288    * @param _to address The address which you want to transfer to
289    * @param _value uint256 the amount of tokens to be transferred
290    */
291   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
292     require(_to != address(0));
293     require(_value <= balances[_from]);
294     require(_value <= allowed[_from][msg.sender]);
295 
296     balances[_from] = balances[_from].sub(_value);
297     balances[_to] = balances[_to].add(_value);
298     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299     emit Transfer(_from, _to, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305    *
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(address _owner, address _spender) public view returns (uint256) {
326     return allowed[_owner][_spender];
327   }
328 
329   /**
330    * @dev Increase the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To increment
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _addedValue The amount of tokens to increase the allowance by.
338    */
339   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
340     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
356     uint oldValue = allowed[msg.sender][_spender];
357     if (_subtractedValue > oldValue) {
358       allowed[msg.sender][_spender] = 0;
359     } else {
360       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
361     }
362     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366 }
367 
368 
369 /**
370  * @title Standard Burnable Token
371  * @dev Adds burnFrom method to ERC20 implementations
372  */
373 contract StandardBurnableToken is BurnableToken, StandardToken {
374 
375   /**
376    * @dev Burns a specific amount of tokens from the target address and decrements allowance
377    * @param _from address The address which you want to send tokens from
378    * @param _value uint256 The amount of token to be burned
379    */
380   function burnFrom(address _from, uint256 _value) public {
381     require(_value <= allowed[_from][msg.sender]);
382     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
383     // this function needs to emit an event with the updated approval.
384     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
385     _burn(_from, _value);
386   }
387 }
388 
389 
390 contract AqwireToken is StandardBurnableToken, Whitelist {
391     string public constant name = "Aqwire Token"; 
392     string public constant symbol = "QEY"; 
393     uint8 public constant decimals = 18; 
394 
395     uint256 public constant INITIAL_SUPPLY = 250000000 * (10 ** uint256(decimals));
396     uint256 public unlockTime;
397 
398     constructor() public{
399         totalSupply_ = INITIAL_SUPPLY;
400         balances[msg.sender] = INITIAL_SUPPLY;
401         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
402 
403         // owner is automatically whitelisted
404         addAddressToWhitelist(msg.sender);
405 
406     }
407 
408     function setUnlockTime(uint256 _unlockTime) public onlyOwner {
409         unlockTime = _unlockTime;
410     }
411 
412     function transfer(address _to, uint256 _value) public returns (bool) {
413         // lock transfers until after ICO completes unless whitelisted
414         require(block.timestamp >= unlockTime || whitelist[msg.sender], "Unable to transfer as unlock time not passed or address not whitelisted");
415 
416         return super.transfer(_to, _value);
417     }
418 
419     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
420         // lock transfers until after ICO completes unless whitelisted
421         require(block.timestamp >= unlockTime || whitelist[msg.sender], "Unable to transfer as unlock time not passed or address not whitelisted");
422 
423         return super.transferFrom(_from, _to, _value);
424     }
425 
426 }