1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     if (a == 0) {
65       return 0;
66     }
67     c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     // uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return a / b;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title Pausable
102  * @dev Base contract which allows children to implement an emergency stop mechanism.
103  */
104 contract Pausable is Ownable {
105   event Pause();
106   event Unpause();
107 
108   bool public paused = false;
109 
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is not paused.
113    */
114   modifier whenNotPaused() {
115     require(!paused);
116     _;
117   }
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is paused.
121    */
122   modifier whenPaused() {
123     require(paused);
124     _;
125   }
126 
127   /**
128    * @dev called by the owner to pause, triggers stopped state
129    */
130   function pause() onlyOwner whenNotPaused public {
131     paused = true;
132     emit Pause();
133   }
134 
135   /**
136    * @dev called by the owner to unpause, returns to normal state
137    */
138   function unpause() onlyOwner whenPaused public {
139     paused = false;
140     emit Unpause();
141   }
142 }
143 
144 contract ContractReceiver {
145     function tokenFallback(address _from, uint _value, bytes _data);
146 }
147 
148 contract VictoryGlobalCoin is Pausable {
149   using SafeMath for uint256;
150 
151   mapping (address => uint) balances;
152   mapping (address => mapping (address => uint256)) internal allowed;
153   mapping (address => bool) public frozenAccount;
154 
155   event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
156   event FrozenFunds(address target, bool frozen);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 
159   string public name;
160   string public symbol;
161   uint8 public decimals;
162   uint256 public totalSupply;
163 
164   constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply)
165   {
166       name = _name;
167       symbol = _symbol;
168       decimals = _decimals;
169       totalSupply = _supply;
170       balances[msg.sender] = totalSupply;
171   }
172 
173 
174   // Function to access name of token .
175   function name() constant returns (string _name) {
176       return name;
177   }
178   // Function to access symbol of token .
179   function symbol() constant returns (string _symbol) {
180       return symbol;
181   }
182   // Function to access decimals of token .
183   function decimals() constant returns (uint8 _decimals) {
184       return decimals;
185   }
186   // Function to access total supply of tokens .
187   function totalSupply() constant returns (uint256 _totalSupply) {
188       return totalSupply;
189   }
190 
191   function freezeAccount(address target, bool freeze) onlyOwner public {
192     frozenAccount[target] = freeze;
193     emit FrozenFunds(target, freeze);
194   }
195 
196   // Function that is called when a user or another contract wants to transfer funds .
197   function transfer(address _to, uint _value, bytes _data, string _custom_fallback)
198   whenNotPaused
199   returns (bool success)
200   {
201     require(_to != address(0));
202     require(!frozenAccount[_to]);
203     require(!frozenAccount[msg.sender]);
204     if(isContract(_to)) {
205       require(balanceOf(msg.sender) >= _value);
206         balances[_to] = balanceOf(_to).sub(_value);
207         balances[_to] = balanceOf(_to).add(_value);
208         assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));
209         emit Transfer(msg.sender, _to, _value, _data);
210         return true;
211     }
212     else {
213         return transferToAddress(_to, _value, _data);
214     }
215 }
216 
217 
218   // Function that is called when a user or another contract wants to transfer funds .
219   function transfer(address _to, uint _value, bytes _data)
220   whenNotPaused
221   returns (bool success) {
222     require(_to != address(0));
223     require(!frozenAccount[_to]);
224     require(!frozenAccount[msg.sender]);
225     if(isContract(_to)) {
226         return transferToContract(_to, _value, _data);
227     }
228     else {
229         return transferToAddress(_to, _value, _data);
230     }
231 }
232 
233   // Standard function transfer similar to ERC20 transfer with no _data .
234   // Added due to backwards compatibility reasons .
235   function transfer(address _to, uint _value)
236   whenNotPaused
237   returns (bool success) {
238     require(_to != address(0));
239     require(!frozenAccount[_to]);
240     require(!frozenAccount[msg.sender]);
241     //standard function transfer similar to ERC20 transfer with no _data
242     //added due to backwards compatibility reasons
243     bytes memory empty;
244     if(isContract(_to)) {
245         return transferToContract(_to, _value, empty);
246     }
247     else {
248         return transferToAddress(_to, _value, empty);
249     }
250 }
251 
252 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
253   function isContract(address _addr) private returns (bool is_contract) {
254       uint length;
255       assembly {
256             //retrieve the size of the code on target address, this needs assembly
257             length := extcodesize(_addr)
258       }
259       return (length>0);
260     }
261 
262   //function that is called when transaction target is an address
263   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
264     require(_to != address(0));
265     require(!frozenAccount[_to]);
266     require(balanceOf(msg.sender) >= _value);
267     require(!frozenAccount[msg.sender]);
268     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
269     balances[_to] = balanceOf(_to).add(_value);
270     emit Transfer(msg.sender, _to, _value, _data);
271     return true;
272   }
273 
274   //function that is called when transaction target is a contract
275   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
276     require(_to != address(0));
277     require(!frozenAccount[_to]);
278     require(balanceOf(msg.sender) >= _value);
279     require(!frozenAccount[msg.sender]);
280     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
281     balances[_to] = balanceOf(_to).add(_value);
282     ContractReceiver receiver = ContractReceiver(_to);
283     receiver.tokenFallback(msg.sender, _value, _data);
284     emit Transfer(msg.sender, _to, _value, _data);
285     return true;
286   }
287 
288   function balanceOf(address _owner) constant returns (uint balance) {
289     return balances[_owner];
290   }
291 
292   /**
293    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
294    *
295    * Beware that changing an allowance with this method brings the risk that someone may use both the old
296    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
297    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
298    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299    * @param _spender The address which will spend the funds.
300    * @param _value The amount of tokens to be spent.
301    */
302   function approve(address _spender, uint256 _value)
303     public
304     whenNotPaused
305     returns (bool) {
306     allowed[msg.sender][_spender] = _value;
307     emit Approval(msg.sender, _spender, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Function to check the amount of tokens that an owner allowed to a spender.
313    * @param _owner address The address which owns the funds.
314    * @param _spender address The address which will spend the funds.
315    * @return A uint256 specifying the amount of tokens still available for the spender.
316    */
317   function allowance(
318     address _owner,
319     address _spender
320    )
321     public
322     view
323     returns (uint256)
324   {
325     return allowed[_owner][_spender];
326   }
327 
328   /**
329    * @dev Increase the amount of tokens that an owner allowed to a spender.
330    *
331    * approve should be called when allowed[_spender] == 0. To increment
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param _spender The address which will spend the funds.
336    * @param _addedValue The amount of tokens to increase the allowance by.
337    */
338   function increaseApproval(
339     address _spender,
340     uint _addedValue
341   )
342     public
343     whenNotPaused
344     returns (bool)
345   {
346     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
347     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348     return true;
349   }
350 
351   /**
352    * @dev Decrease the amount of tokens that an owner allowed to a spender.
353    *
354    * approve should be called when allowed[_spender] == 0. To decrement
355    * allowed value is better to use this function to avoid 2 calls (and wait until
356    * the first transaction is mined)
357    * From MonolithDAO Token.sol
358    * @param _spender The address which will spend the funds.
359    * @param _subtractedValue The amount of tokens to decrease the allowance by.
360    */
361   function decreaseApproval(
362     address _spender,
363     uint _subtractedValue
364   )
365     public
366     whenNotPaused
367     returns (bool)
368   {
369     uint oldValue = allowed[msg.sender][_spender];
370     if (_subtractedValue > oldValue) {
371       allowed[msg.sender][_spender] = 0;
372     } else {
373       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374     }
375     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376     return true;
377   }
378   
379     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public returns (bool seccess) {
380     require(amount > 0);
381     require(addresses.length > 0);
382     require(!frozenAccount[msg.sender]);
383 
384     uint256 totalAmount = amount.mul(addresses.length);
385     require(balances[msg.sender] >= totalAmount);
386     bytes memory empty;
387 
388     for (uint i = 0; i < addresses.length; i++) {
389       require(addresses[i] != address(0));
390       require(!frozenAccount[addresses[i]]);
391       balances[addresses[i]] = balances[addresses[i]].add(amount);
392       emit Transfer(msg.sender, addresses[i], amount, empty);
393     }
394     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
395     
396     return true;
397   }
398 
399   function distributeAirdrop(address[] addresses, uint256[] amounts) public returns (bool) {
400     require(addresses.length > 0);
401     require(addresses.length == amounts.length);
402     require(!frozenAccount[msg.sender]);
403 
404     uint256 totalAmount = 0;
405 
406     for(uint i = 0; i < addresses.length; i++){
407       require(amounts[i] > 0);
408       require(addresses[i] != address(0));
409       require(!frozenAccount[addresses[i]]);
410 
411       totalAmount = totalAmount.add(amounts[i]);
412     }
413     require(balances[msg.sender] >= totalAmount);
414 
415     bytes memory empty;
416     for (i = 0; i < addresses.length; i++) {
417       balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);
418       emit Transfer(msg.sender, addresses[i], amounts[i], empty);
419     }
420     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
421     return true;
422   }
423   
424   /**
425      * @dev Function to collect tokens from the list of addresses
426      */
427     function collectTokens(address[] addresses, uint256[] amounts) onlyOwner public returns (bool) {
428         require(addresses.length > 0);
429         require(addresses.length == amounts.length);
430 
431         uint256 totalAmount = 0;
432         bytes memory empty;
433         
434         for (uint j = 0; j < addresses.length; j++) {
435             require(amounts[j] > 0);
436             require(addresses[j] != address(0));
437             require(!frozenAccount[addresses[j]]);
438                     
439             require(balances[addresses[j]] >= amounts[j]);
440             balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);
441             totalAmount = totalAmount.add(amounts[j]);
442             emit Transfer(addresses[j], msg.sender, amounts[j], empty);
443         }
444         balances[msg.sender] = balances[msg.sender].add(totalAmount);
445         return true;
446     }
447 }