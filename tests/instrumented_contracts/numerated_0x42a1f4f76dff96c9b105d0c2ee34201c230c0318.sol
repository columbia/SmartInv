1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint;
73 
74   mapping(address => uint) balances;
75 
76   /**
77    * @dev Fix for the ERC20 short address attack.
78    */
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length < size + 4) {
81        throw;
82      }
83      _;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) constant returns (uint balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 
109 /**
110  * @title ERC20 interface
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) constant returns (uint);
114   function transferFrom(address from, address to, uint value);
115   function approve(address spender, uint value);
116   event Approval(address indexed owner, address indexed spender, uint value);
117 }
118 
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implemantation of the basic standart token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125 
126  */
127 contract StandardToken is BasicToken, ERC20 {
128 
129   mapping (address => mapping (address => uint)) allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint the amout of tokens to be transfered
137    */
138   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
139     var _allowance = allowed[_from][msg.sender];
140 
141     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
142     // if (_value > _allowance) throw;
143 
144     balances[_to] = balances[_to].add(_value);
145     balances[_from] = balances[_from].sub(_value);
146     allowed[_from][msg.sender] = _allowance.sub(_value);
147     Transfer(_from, _to, _value);
148   }
149 
150   /**
151    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint _value) {
156 
157     // To change the approve amount you first have to reduce the addresses`
158     //  allowance to zero by calling `approve(_spender, 0)` if it is not
159     //  already 0 to mitigate the race condition described here:
160     
161     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
162 
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens than an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint specifing the amount of tokens still avaible for the spender.
172    */
173   function allowance(address _owner, address _spender) constant returns (uint remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177 }
178 
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address public owner;
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     if (msg.sender != owner) {
203       throw;
204     }
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner {
214     if (newOwner != address(0)) {
215       owner = newOwner;
216     }
217   }
218 
219 }
220 
221 
222 /**
223  * @title Mintable token
224  * @dev Simple ERC20 Token example, with Paya token creation
225  */
226 
227 contract ERNeeToken is StandardToken, Ownable {
228   event NeeTK(address indexed to, uint value);
229   event NeeTKFinished();
230 
231   bool public _NeeTKFinished = false;
232   uint public totalSupply = 0;
233 
234 
235   modifier canNeeTK() {
236     if(_NeeTKFinished) throw;
237     _;
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will recieve the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint _amount) onlyOwner canNeeTK returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     NeeTK(_to, _amount);
250     return true;
251   }
252 
253   /**
254    * @dev Function to stop minting new tokens.
255    * @return True if the operation was successful.
256    */
257   function finishNineing() onlyOwner returns (bool) {
258     _NeeTKFinished = true;
259     NeeTKFinished();
260     return true;
261   }
262 }
263 
264 
265 /**
266  * @title Pausable
267  * @dev Base contract which allows children to implement an emergency stop mechanism.
268  */
269 contract Pausable is Ownable {
270   event Pause();
271   event Unpause();
272 
273   bool public paused = false;
274 
275 
276   /**
277    * @dev modifier to allow actions only when the contract IS paused
278    */
279   modifier whenNotPaused() {
280     if (paused) throw;
281     _;
282   }
283 
284   /**
285    * @dev modifier to allow actions only when the contract IS NOT paused
286    */
287   modifier whenPaused {
288     if (!paused) throw;
289     _;
290   }
291 
292   /**
293    * @dev called by the owner to pause, triggers stopped state
294    */
295   function pause() onlyOwner whenNotPaused returns (bool) {
296     paused = true;
297     Pause();
298     return true;
299   }
300 
301   /**
302    * @dev called by the owner to unpause, returns to normal state
303    */
304   function unpause() onlyOwner whenPaused returns (bool) {
305     paused = false;
306     Unpause();
307     return true;
308   }
309 }
310 
311 
312 /**
313  * Pausable token
314  *
315  * Simple ERC20 Token with pausable token creation
316  **/
317 
318 contract PausableToken is StandardToken, Pausable {
319 
320   function transfer(address _to, uint _value) whenNotPaused {
321     super.transfer(_to, _value);
322   }
323 
324   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
325     super.transferFrom(_from, _to, _value);
326   }
327 }
328 
329 
330 /**
331  * @title TokenTimelock
332  * @dev TokenTimelock is a token holder contract that will allow a
333  * beneficiary to extract the tokens after a time has passed
334  */
335 contract TokenTimelock {
336 
337   // ERC20 basic token contract being held
338   ERC20Basic token;
339 
340   // beneficiary of tokens after they are released
341   address beneficiary;
342 
343   // timestamp where token release is enabled
344   uint releaseTime;
345 
346   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
347     require(_releaseTime > now);
348     token = _token;
349     beneficiary = _beneficiary;
350     releaseTime = _releaseTime;
351   }
352 
353   /**
354    * @dev beneficiary claims tokens held by time lock
355    */
356   function claim() {
357     require(msg.sender == beneficiary);
358     require(now >= releaseTime);
359 
360     uint amount = token.balanceOf(this);
361     require(amount > 0);
362 
363     token.transfer(beneficiary, amount);
364   }
365 }
366 
367 
368 /**
369  * @title 9TOKEN
370  * @dev Omise Go Token contract
371  */
372 contract USDexTOKEN is PausableToken, ERNeeToken {
373   using SafeMath for uint256;
374 
375   string public name = "NEEX USD";
376   string public symbol = "USDex";
377   uint public decimals = 2;
378   string public version = 'H1.0';  
379   function () {
380         //if ether is sent to this address, send it back.
381         throw;
382     }
383   /**
384    * @dev Paya timelocked tokens
385    */
386    /*
387   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
388     onlyOwner canPaya returns (TokenTimelock) {
389 
390     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
391     mint(timelock, _amount);
392 
393     return timelock;
394   }
395   */
396    function USDexTOKEN(
397         ) {
398         balances[msg.sender] = 100000000000;               // 999.999.999,000000000
399         totalSupply = 100000000000;                        // 
400         }
401 
402  /* Approves and then calls the receiving contract */
403     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
404         allowed[msg.sender][_spender] = _value;
405         Approval(msg.sender, _spender, _value);
406 
407         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
408         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
409         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
410         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
411         return true;
412     }
413 }