1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 contract SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner {
83     require(newOwner != address(0));
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) constant returns (uint256);
97   function transfer(address to, uint256 value) returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) constant returns (uint256);
109   function transferFrom(address from, address to, uint256 value) returns (bool);
110   function approve(address spender, uint256 value) returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is SafeMath, ERC20Basic {
120 
121   mapping(address => uint256) balances;
122 
123   /**
124    * @dev Fix for the ERC20 short address attack.
125    */
126   modifier onlyPayloadSize(uint size) {
127     require(msg.data.length >= size + 4);
128      _;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool){
137     balances[msg.sender] = sub(balances[msg.sender],_value);
138     balances[_to] = add(balances[_to],_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) constant returns (uint balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amout of tokens to be transfered
173    */
174   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
175     var _allowance = allowed[_from][msg.sender];
176 
177     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
178     // require (_value <= _allowance);
179 
180     balances[_to] = add(balances[_to],_value);
181     balances[_from] = sub(balances[_from],_value);
182     allowed[_from][msg.sender] = sub(_allowance,_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) returns (bool) {
193 
194     // To change the approve amount you first have to reduce the addresses`
195     //  allowance to zero by calling `approve(_spender, 0)` if it is not
196     //  already 0 to mitigate the race condition described here:
197     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
199 
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifing the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
212     return allowed[_owner][_spender];
213   }
214 
215 }
216 
217 
218 
219 
220 
221 
222 /**
223  * @title Pausable
224  * @dev Base contract which allows children to implement an emergency stop mechanism.
225  */
226 contract Pausable is Ownable {
227   event Pause();
228   event Unpause();
229 
230   bool public paused = false;
231 
232 
233   /**
234    * @dev modifier to allow actions only when the contract IS paused
235    */
236   modifier whenNotPaused() {
237     require(!paused);
238     _;
239   }
240 
241   /**
242    * @dev modifier to allow actions only when the contract IS NOT paused
243    */
244   modifier whenPaused() {
245     require(paused);
246     _;
247   }
248 
249   /**
250    * @dev called by the owner to pause, triggers stopped state
251    */
252   function pause() onlyOwner whenNotPaused {
253     paused = true;
254     Pause();
255   }
256 
257   /**
258    * @dev called by the owner to unpause, returns to normal state
259    */
260   function unpause() onlyOwner whenPaused {
261     paused = false;
262     Unpause();
263   }
264 }
265 
266 
267 
268 /**
269  * Pausable token
270  *
271  * Simple ERC20 Token example, with pausable token creation
272  **/
273 
274 contract PausableToken is StandardToken, Pausable {
275 
276   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
277     return super.transfer(_to, _value);
278   }
279 
280   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
281     return super.transferFrom(_from, _to, _value);
282   }
283 }
284 
285 
286 /**
287  * @title KYC
288  * @dev KYC contract handles the white list for PLCCrowdsale contract
289  * Only accounts registered in KYC contract can buy PLC token.
290  * Admins can register account, and the reason why
291  */
292 contract KYC is Ownable, SafeMath, Pausable {
293   // check the address is registered for token sale
294   mapping (address => bool) public registeredAddress;
295 
296   // check the address is admin of kyc contract
297   mapping (address => bool) public admin;
298 
299   event Registered(address indexed _addr);
300   event Unregistered(address indexed _addr);
301   event NewAdmin(address indexed _addr);
302 
303   /**
304    * @dev check whether the address is registered for token sale or not.
305    * @param _addr address
306    */
307   modifier onlyRegistered(address _addr) {
308     require(isRegistered(_addr));
309     _;
310   }
311 
312   /**
313    * @dev check whether the msg.sender is admin or not
314    */
315   modifier onlyAdmin() {
316     require(admin[msg.sender]);
317     _;
318   }
319 
320   function KYC() {
321     admin[msg.sender] = true;
322   }
323 
324   /**
325    * @dev set new admin as admin of KYC contract
326    * @param _addr address The address to set as admin of KYC contract
327    */
328   function setAdmin(address _addr)
329     public
330     onlyOwner
331   {
332     require(_addr != address(0) && admin[_addr] == false);
333     admin[_addr] = true;
334 
335     NewAdmin(_addr);
336   }
337 
338   /**
339    * @dev check the address is register for token sale
340    * @param _addr address The address to check whether register or not
341    */
342   function isRegistered(address _addr)
343     public
344     constant
345     returns (bool)
346   {
347     return registeredAddress[_addr];
348   }
349 
350   /**
351    * @dev register the address for token sale
352    * @param _addr address The address to register for token sale
353    */
354   function register(address _addr)
355     public
356     onlyAdmin
357     whenNotPaused
358   {
359     require(_addr != address(0) && registeredAddress[_addr] == false);
360 
361     registeredAddress[_addr] = true;
362 
363     Registered(_addr);
364   }
365 
366   /**
367    * @dev register the addresses for token sale
368    * @param _addrs address[] The addresses to register for token sale
369    */
370   function registerByList(address[] _addrs)
371     public
372     onlyAdmin
373     whenNotPaused
374   {
375     for(uint256 i = 0; i < _addrs.length; i++) {
376       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
377 
378       registeredAddress[_addrs[i]] = true;
379 
380       Registered(_addrs[i]);
381     }
382   }
383 
384   /**
385    * @dev unregister the registered address
386    * @param _addr address The address to unregister for token sale
387    */
388   function unregister(address _addr)
389     public
390     onlyAdmin
391     onlyRegistered(_addr)
392   {
393     registeredAddress[_addr] = false;
394 
395     Unregistered(_addr);
396   }
397 
398   /**
399    * @dev unregister the registered addresses
400    * @param _addrs address[] The addresses to unregister for token sale
401    */
402   function unregisterByList(address[] _addrs)
403     public
404     onlyAdmin
405   {
406     for(uint256 i = 0; i < _addrs.length; i++) {
407       require(isRegistered(_addrs[i]));
408 
409       registeredAddress[_addrs[i]] = false;
410 
411       Unregistered(_addrs[i]);
412     }
413 
414   }
415 }