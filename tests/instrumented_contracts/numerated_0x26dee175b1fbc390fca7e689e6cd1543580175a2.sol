1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  */
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    * @notice Renouncing to ownership will leave the contract without an owner.
37    * It will not be possible to call the functions with the `onlyOwner`
38    * modifier anymore.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72     // benefit is lost if 'b' is also tested.
73     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74     if (a == 0) {
75       return 0;
76     }
77 
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 contract Pausable is Ownable {
113   event Pause();
114   event Unpause();
115 
116   bool public paused = false;
117 
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is not paused.
121    */
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is paused.
129    */
130   modifier whenPaused() {
131     require(paused);
132     _;
133   }
134 
135   /**
136    * @dev called by the owner to pause, triggers stopped state
137    */
138   function pause() onlyOwner whenNotPaused public {
139     paused = true;
140     emit Pause();
141   }
142 
143   /**
144    * @dev called by the owner to unpause, returns to normal state
145    */
146   function unpause() onlyOwner whenPaused public {
147     paused = false;
148     emit Unpause();
149   }
150 }
151 
152 contract ERC20Basic {
153   function totalSupply() public view returns (uint256);
154   function balanceOf(address who) public view returns (uint256);
155   function transfer(address to, uint256 value) public returns (bool);
156   event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender)
161     public view returns (uint256);
162 
163   function transferFrom(address from, address to, uint256 value)
164     public returns (bool);
165 
166   function approve(address spender, uint256 value) public returns (bool);
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 
175 contract BasicToken is ERC20Basic {
176   using SafeMath for uint256;
177 
178   mapping(address => uint256) balances;
179 
180   uint256 totalSupply_;
181 
182   /**
183   * @dev Total number of tokens in existence
184   */
185   
186   constructor(uint256 totalSupply) public {
187       totalSupply_ = totalSupply;
188       balances[msg.sender] = totalSupply_;
189   }
190   
191   function totalSupply() public view returns (uint256) {
192     return totalSupply_;
193   }
194 
195   /**
196   * @dev Transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[msg.sender]);
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209   
210   function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
211       uint cnt = _receivers.length;
212       uint256 amount = _value.mul(uint256(cnt));
213       require(cnt > 0 && cnt <= 20);
214       require(_value > 0 && balances[msg.sender] >= amount);
215   
216       balances[msg.sender] = balances[msg.sender].sub(amount);
217       for (uint i = 0; i < cnt; i++) {
218           balances[_receivers[i]] = balances[_receivers[i]].add(_value);
219           emit Transfer(msg.sender, _receivers[i], _value);
220       }
221       return true;
222     }
223 
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param _owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address _owner) public view returns (uint256) {
230     return balances[_owner];
231   }
232 
233 }
234 
235 
236 contract DetailedERC20 is ERC20 {
237   string public name;
238   string public symbol;
239   uint8 public decimals;
240 
241   constructor(string _name, string _symbol, uint8 _decimals) public {
242     name = _name;
243     symbol = _symbol;
244     decimals = _decimals;
245   }
246 }
247 
248 contract StandardToken is DetailedERC20('IntellishareTestToken','inetest',18), BasicToken(986000000000000000000000000) {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_to != address(0));
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277   
278   
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    * Beware that changing an allowance with this method brings the risk that someone may use both the old
283    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
284    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
285    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286    * @param _spender The address which will spend the funds.
287    * @param _value The amount of tokens to be spent.
288    */
289   function approve(address _spender, uint256 _value) public returns (bool) {
290     require(allowed[msg.sender][_spender] == 0);
291     allowed[msg.sender][_spender] = _value;
292     emit Approval(msg.sender, _spender, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(
303     address _owner,
304     address _spender
305    )
306     public
307     view
308     returns (uint256)
309   {
310     return allowed[_owner][_spender];
311   }
312 
313   /**
314    * @dev Increase the amount of tokens that an owner allowed to a spender.
315    * approve should be called when allowed[_spender] == 0. To increment
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _addedValue The amount of tokens to increase the allowance by.
321    */
322   function increaseApproval(
323     address _spender,
324     uint256 _addedValue
325   )
326     public
327     returns (bool)
328   {
329     allowed[msg.sender][_spender] = (
330       allowed[msg.sender][_spender].add(_addedValue));
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335   /**
336    * @dev Decrease the amount of tokens that an owner allowed to a spender.
337    * approve should be called when allowed[_spender] == 0. To decrement
338    * allowed value is better to use this function to avoid 2 calls (and wait until
339    * the first transaction is mined)
340    * From MonolithDAO Token.sol
341    * @param _spender The address which will spend the funds.
342    * @param _subtractedValue The amount of tokens to decrease the allowance by.
343    */
344   function decreaseApproval(
345     address _spender,
346     uint256 _subtractedValue
347   )
348     public
349     returns (bool)
350   {
351     uint256 oldValue = allowed[msg.sender][_spender];
352     if (_subtractedValue > oldValue) {
353       allowed[msg.sender][_spender] = 0;
354     } else {
355       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
356     }
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360   
361   function recoverLost(
362     address lost,
363     uint256 amount
364   )
365     public
366     returns (bool)
367   {
368     this.transfer(lost,amount);
369   }
370 
371 }
372 
373 
374 contract PausableToken is StandardToken, Pausable {
375 
376   function transfer(
377     address _to,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.transfer(_to, _value);
385   }
386 
387   function batchTransfer (
388       address[] _receivers,
389       uint256 _value
390     )
391       public
392       whenNotPaused
393       onlyOwner
394       returns (bool) 
395     {
396       return super.batchTransfer(_receivers, _value);
397     }
398 
399   function transferFrom(
400     address _from,
401     address _to,
402     uint256 _value
403   )
404     public
405     whenNotPaused
406     returns (bool)
407   {
408     return super.transferFrom(_from, _to, _value);
409   }
410 
411   function approve(
412     address _spender,
413     uint256 _value
414   )
415     public
416     whenNotPaused
417     returns (bool)
418   {
419     return super.approve(_spender, _value);
420   }
421 
422   function increaseApproval(
423     address _spender,
424     uint _addedValue
425   )
426     public
427     whenNotPaused
428     returns (bool success)
429   {
430     return super.increaseApproval(_spender, _addedValue);
431   }
432 
433   function decreaseApproval(
434     address _spender,
435     uint _subtractedValue
436   )
437     public
438     whenNotPaused
439     returns (bool success)
440   {
441     return super.decreaseApproval(_spender, _subtractedValue);
442   }
443   
444   function recoverLost(
445       address lost,
446       uint256 amount
447     )
448       public
449       whenNotPaused
450       onlyOwner
451       returns(bool)
452     {
453         return super.recoverLost(lost,amount);
454     }
455 }