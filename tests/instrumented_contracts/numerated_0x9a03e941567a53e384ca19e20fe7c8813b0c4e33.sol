1 pragma solidity ^0.4.11;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6   function mul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal returns (uint) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) {
48       throw;
49     }
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  */
57 contract ERC20Basic {
58   uint public totalSupply;
59   function balanceOf(address who) constant returns (uint);
60   function transfer(address to, uint value);
61   event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint;
71 
72   mapping(address => uint) balances;
73 
74   /**
75    * @dev Fix for the ERC20 short address attack.
76    */
77   modifier onlyPayloadSize(uint size) {
78      if(msg.data.length < size + 4) {
79        throw;
80      }
81      _;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
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
103 
104 }
105 
106 
107 /**
108  * @title ERC20 interface
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant returns (uint);
112   function transferFrom(address from, address to, uint value);
113   function approve(address spender, uint value);
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123 
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // if (_value > _allowance) throw;
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint _value) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     
159     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens than an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint specifing the amount of tokens still avaible for the spender.
170    */
171   function allowance(address _owner, address _spender) constant returns (uint remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() {
192     owner = msg.sender;
193   }
194 
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     if (msg.sender != owner) {
201       throw;
202     }
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner {
212     if (newOwner != address(0)) {
213       owner = newOwner;
214     }
215   }
216 
217 }
218 
219 
220 /**
221  * @title Mintable token
222  * @dev Simple ERC20 Token example, with Eco token creation
223  */
224 
225 contract EcoToken is StandardToken, Ownable {
226   event Eco(address indexed to, uint value);
227   event EcoFinished();
228   bool public _EcoFinished = false;
229   uint public totalSupply = 0;
230 
231 
232   modifier canEco() {
233     if(_EcoFinished) throw;
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will recieve the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint _amount) onlyOwner canEco returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Eco(_to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishEcoing() onlyOwner returns (bool) {
255     _EcoFinished = true;
256     EcoFinished();
257     return true;
258   }
259 }
260 
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev modifier to allow actions only when the contract IS paused
275    */
276   modifier whenNotPaused() {
277     if (paused) throw;
278     _;
279   }
280 
281   /**
282    * @dev modifier to allow actions only when the contract IS NOT paused
283    */
284   modifier whenPaused {
285     if (!paused) throw;
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused returns (bool) {
293     paused = true;
294     Pause();
295     return true;
296   }
297 
298   /**
299    * @dev called by the owner to unpause, returns to normal state
300    */
301   function unpause() onlyOwner whenPaused returns (bool) {
302     paused = false;
303     Unpause();
304     return true;
305   }
306 }
307 
308 
309 /**
310  * Pausable token
311  *
312  * Simple ERC20 Token with pausable token creation
313  **/
314 
315 contract PausableToken is StandardToken, Pausable {
316 
317   function transfer(address _to, uint _value) whenNotPaused {
318     super.transfer(_to, _value);
319   }
320 
321   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
322     super.transferFrom(_from, _to, _value);
323   }
324 }
325 
326 
327 /**
328  * @title TokenTimelock
329  * @dev TokenTimelock is a token holder contract that will allow a
330  * beneficiary to extract the tokens after a time has passed
331  */
332 contract TokenTimelock {
333 
334   // ERC20 basic token contract being held
335   ERC20Basic token;
336 
337   // beneficiary of tokens after they are released
338   address beneficiary;
339 
340   // timestamp where token release is enabled
341   uint releaseTime;
342 
343   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
344     require(_releaseTime > now);
345     token = _token;
346     beneficiary = _beneficiary;
347     releaseTime = _releaseTime;
348   }
349 
350   /**
351    * @dev beneficiary claims tokens held by time lock
352    */
353   function claim() {
354     require(msg.sender == beneficiary);
355     require(now >= releaseTime);
356 
357     uint amount = token.balanceOf(this);
358     require(amount > 0);
359 
360     token.transfer(beneficiary, amount);
361   }
362 }
363 
364 
365 /**
366  * @title EcoPoint
367  * @dev Omise Go Token contract
368  */
369 contract EcoPoint is PausableToken, EcoToken {
370   using SafeMath for uint256;
371 
372   string public name;
373   string public symbol;
374   uint public decimals;
375   string public version = 'H1.0';  
376   function () {
377         //if ether is sent to this address, send it back.
378         throw;
379     }
380   function EcoPoint() 
381    {
382         balances[msg.sender] = 1000000000000000;               // 100,000,000,000
383         totalSupply = 1000000000000000;                        // 100,000,000,000
384         name="EcoPoint";
385         symbol="ECO";
386         decimals=4;
387         }
388 
389  /* Approves and then calls the receiving contract */
390     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
391         allowed[msg.sender][_spender] = _value;
392         Approval(msg.sender, _spender, _value);
393 
394         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
395         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
396         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
397         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
398         return true;
399     }
400 }