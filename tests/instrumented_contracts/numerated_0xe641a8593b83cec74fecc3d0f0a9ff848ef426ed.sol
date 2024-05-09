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
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62 
63   event Transfer(address indexed from, address indexed to, uint256 value);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address public owner;
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 }
104 
105 
106 /**
107  * @title QWoodDAOToken
108  * @dev Token which use as share in QWoodDAO.
109  */
110 contract QWoodDAOToken is ERC20, Ownable {
111   using SafeMath for uint256;
112 
113   string public constant name = "QWoodDAO";
114   string public constant symbol = "QOD";
115   uint8 public constant decimals = 18;
116   uint256 public constant INITIAL_SUPPLY = 9000000 * (10 ** uint256(decimals));
117 
118   mapping (address => uint256) balances;
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   uint256 totalSupply_;
122 
123   address public dao;
124 
125   uint public periodOne;
126   uint public periodTwo;
127   uint public periodThree;
128 
129   event NewDAOContract(address indexed previousDAOContract, address indexed newDAOContract);
130 
131   /**
132    * @dev Constructor.
133    */
134   function QWoodDAOToken(
135     uint _periodOne,
136     uint _periodTwo,
137     uint _periodThree
138   ) public {
139     owner = msg.sender;
140 
141     periodOne = _periodOne;
142     periodTwo = _periodTwo;
143     periodThree = _periodThree;
144 
145     totalSupply_ = INITIAL_SUPPLY;
146     balances[owner] = INITIAL_SUPPLY;
147     Transfer(0x0, owner, INITIAL_SUPPLY);
148   }
149 
150 
151   // PUBLIC
152 
153   // ERC20
154 
155   /**
156   * @dev total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return totalSupply_;
160   }
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169 
170     uint256 _balance = _balanceOf(msg.sender);
171     require(_value <= _balance);
172 
173     // SafeMath.sub will throw if there is not enough balance.
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176 
177     Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256 balance) {
187     return _balanceOf(_owner);
188   }
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198 
199     uint256 _balance = _balanceOf(_from);
200     require(_value <= _balance);
201 
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public view returns (uint256) {
234     return allowed[_owner][_spender];
235   }
236 
237   // ERC20 Additional
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   // ERC827
277   /**
278      * @dev Addition to ERC20 token methods. It allows to
279      * @dev approve the transfer of value and execute a call with the sent data.
280      *
281      * @dev Beware that changing an allowance with this method brings the risk that
282      * @dev someone may use both the old and the new allowance by unfortunate
283      * @dev transaction ordering. One possible solution to mitigate this race condition
284      * @dev is to first reduce the spender's allowance to 0 and set the desired value
285      * @dev afterwards:
286      * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      *
288      * @param _spender The address that will spend the funds.
289      * @param _value The amount of tokens to be spent.
290      * @param _data ABI-encoded contract call to call `_to` address.
291      *
292      * @return true if the call function was executed successfully
293      */
294   function approveAndCall(
295     address _spender,
296     uint256 _value,
297     bytes _data
298   )
299   public
300   payable
301   returns (bool)
302   {
303     require(_spender != address(this));
304 
305     approve(_spender, _value);
306 
307     // solium-disable-next-line security/no-call-value
308     require(_spender.call.value(msg.value)(_data));
309 
310     return true;
311   }
312 
313   /**
314    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
315    * @dev address and execute a call with the sent data on the same transaction
316    *
317    * @param _to address The address which you want to transfer to
318    * @param _value uint256 the amout of tokens to be transfered
319    * @param _data ABI-encoded contract call to call `_to` address.
320    *
321    * @return true if the call function was executed successfully
322    */
323   function transferAndCall(
324     address _to,
325     uint256 _value,
326     bytes _data
327   )
328   public
329   payable
330   returns (bool)
331   {
332     require(_to != address(this));
333 
334     transfer(_to, _value);
335 
336     // solium-disable-next-line security/no-call-value
337     require(_to.call.value(msg.value)(_data));
338     return true;
339   }
340 
341   /**
342    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
343    * @dev another and make a contract call on the same transaction
344    *
345    * @param _from The address which you want to send tokens from
346    * @param _to The address which you want to transfer to
347    * @param _value The amout of tokens to be transferred
348    * @param _data ABI-encoded contract call to call `_to` address.
349    *
350    * @return true if the call function was executed successfully
351    */
352   function transferFromAndCall(
353     address _from,
354     address _to,
355     uint256 _value,
356     bytes _data
357   )
358   public payable returns (bool)
359   {
360     require(_to != address(this));
361 
362     transferFrom(_from, _to, _value);
363 
364     // solium-disable-next-line security/no-call-value
365     require(_to.call.value(msg.value)(_data));
366     return true;
367   }
368 
369   /**
370    * @dev Addition to StandardToken methods. Increase the amount of tokens that
371    * @dev an owner allowed to a spender and execute a call with the sent data.
372    *
373    * @dev approve should be called when allowed[_spender] == 0. To increment
374    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
375    * @dev the first transaction is mined)
376    * @dev From MonolithDAO Token.sol
377    *
378    * @param _spender The address which will spend the funds.
379    * @param _addedValue The amount of tokens to increase the allowance by.
380    * @param _data ABI-encoded contract call to call `_spender` address.
381    */
382   function increaseApprovalAndCall(
383     address _spender,
384     uint _addedValue,
385     bytes _data
386   )
387   public
388   payable
389   returns (bool)
390   {
391     require(_spender != address(this));
392 
393     increaseApproval(_spender, _addedValue);
394 
395     // solium-disable-next-line security/no-call-value
396     require(_spender.call.value(msg.value)(_data));
397 
398     return true;
399   }
400 
401   /**
402    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
403    * @dev an owner allowed to a spender and execute a call with the sent data.
404    *
405    * @dev approve should be called when allowed[_spender] == 0. To decrement
406    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
407    * @dev the first transaction is mined)
408    * @dev From MonolithDAO Token.sol
409    *
410    * @param _spender The address which will spend the funds.
411    * @param _subtractedValue The amount of tokens to decrease the allowance by.
412    * @param _data ABI-encoded contract call to call `_spender` address.
413    */
414   function decreaseApprovalAndCall(
415     address _spender,
416     uint _subtractedValue,
417     bytes _data
418   )
419   public
420   payable
421   returns (bool)
422   {
423     require(_spender != address(this));
424 
425     decreaseApproval(_spender, _subtractedValue);
426 
427     // solium-disable-next-line security/no-call-value
428     require(_spender.call.value(msg.value)(_data));
429 
430     return true;
431   }
432 
433   // Additional
434 
435   function pureBalanceOf(address _owner) public view returns (uint256 balance) {
436     return balances[_owner];
437   }
438 
439   /**
440    * @dev Set new DAO contract address.
441    * @param newDao The address of DAO contract.
442    */
443   function setDAOContract(address newDao) public onlyOwner {
444     require(newDao != address(0));
445     NewDAOContract(dao, newDao);
446     dao = newDao;
447   }
448 
449 
450   // INTERNAL
451 
452   function _balanceOf(address _owner) internal view returns (uint256) {
453     if (_owner == dao) {
454       uint256 _frozen;
455       uint _period = _getPeriodFor(now);
456       uint256 _frozenMax = 7000000;
457       uint256 _frozenMin = 1000000;
458       uint256 _frozenStep = 250000;
459 
460       if (_period == 0) _frozen = _frozenMax;
461       if (_period == 1) _frozen = _frozenMax.sub(_frozenStep.mul(_weekFor(now)));
462       if (_period == 2) _frozen = _frozenMin;
463       if (_period == 3) _frozen = 0;
464 
465       return balances[_owner].sub(_frozen * (10 ** uint256(decimals)));
466     }
467 
468     return balances[_owner];
469   }
470 
471   function _getPeriodFor(uint ts) internal view returns (uint) {
472     if (ts < periodOne) return 0;
473     if (ts >= periodThree) return 3;
474     if (ts >= periodTwo) return 2;
475     if (ts >= periodOne) return 1;
476   }
477 
478   function _weekFor(uint ts) internal view returns (uint) {
479     return ts < periodOne ? 0 : (ts - periodOne) / 1 weeks + 1;
480   }
481 }