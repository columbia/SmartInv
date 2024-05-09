1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  */
8 contract Ownable {
9   address public owner;
10   
11   struct Admins {
12     mapping(address=>bool) isAdmin;
13   }
14   
15   Admins internal admins;
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38   
39   
40   function addAdmin(address candidate) public onlyOwner returns(bool) {
41     admins.isAdmin[candidate] = true;
42     return true;
43   }
44   
45   function removeAdmin(address candidate) public onlyOwner returns(bool) {
46     admins.isAdmin[candidate] = false;
47     return true;
48   }
49   
50   function checkAdmin(address candidate) public onlyOwner view returns(bool) {
51     return admins.isAdmin[candidate];
52   }
53   
54   
55   modifier onlyAdmins() {
56     require(admins.isAdmin[msg.sender] == true);
57     _;
58   }
59   
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    * @notice Renouncing to ownership will leave the contract without an owner.
63    * It will not be possible to call the functions with the `onlyOwner`
64    * modifier anymore.
65    */
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipRenounced(owner);
68     owner = address(0);
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address _newOwner) public onlyOwner {
76     _transferOwnership(_newOwner);
77   }
78 
79   /**
80    * @dev Transfers control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function _transferOwnership(address _newOwner) internal {
84     require(_newOwner != address(0));
85     emit OwnershipTransferred(owner, _newOwner);
86     owner = _newOwner;
87   }
88 }
89 
90 
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (a == 0) {
101       return 0;
102     }
103 
104     c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return a / b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
131     c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 
138 contract Pausable is Ownable {
139   event Pause();
140   event Unpause();
141 
142   bool public paused = false;
143 
144 
145   /**
146    * @dev Modifier to make a function callable only when the contract is not paused.
147    */
148   modifier whenNotPaused() {
149     require(!paused);
150     _;
151   }
152 
153   /**
154    * @dev Modifier to make a function callable only when the contract is paused.
155    */
156   modifier whenPaused() {
157     require(paused);
158     _;
159   }
160 
161   /**
162    * @dev called by the owner to pause, triggers stopped state
163    */
164   function pause() onlyOwner whenNotPaused public {
165     paused = true;
166     emit Pause();
167   }
168 
169   /**
170    * @dev called by the owner to unpause, returns to normal state
171    */
172   function unpause() onlyOwner whenPaused public {
173     paused = false;
174     emit Unpause();
175   }
176 }
177 
178 contract ERC20Basic {
179   function totalSupply() public view returns (uint256);
180   function balanceOf(address who) public view returns (uint256);
181   function transfer(address to, uint256 value) public returns (bool);
182   event Transfer(address indexed from, address indexed to, uint256 value);
183 }
184 
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender)
187     public view returns (uint256);
188 
189   function transferFrom(address from, address to, uint256 value)
190     public returns (bool);
191 
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   uint256 totalSupply_;
207 
208   /**
209   * @dev Total number of tokens in existence
210   */
211   
212   constructor(uint256 totalSupply) public {
213       totalSupply_ = totalSupply;
214       balances[msg.sender] = totalSupply_;
215   }
216   
217   function totalSupply() public view returns (uint256) {
218     return totalSupply_;
219   }
220 
221   /**
222   * @dev Transfer token for a specified address
223   * @param _to The address to transfer to.
224   * @param _value The amount to be transferred.
225   */
226   function transfer(address _to, uint256 _value) public returns (bool) {
227     require(_to != address(0));
228     require(_value <= balances[msg.sender]);
229 
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235   
236   function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
237       uint cnt = _receivers.length;
238       uint256 amount = _value.mul(uint256(cnt));
239       require(cnt > 0 && cnt <= 20);
240       require(_value > 0 && balances[msg.sender] >= amount);
241   
242       balances[msg.sender] = balances[msg.sender].sub(amount);
243       for (uint i = 0; i < cnt; i++) {
244           balances[_receivers[i]] = balances[_receivers[i]].add(_value);
245           emit Transfer(msg.sender, _receivers[i], _value);
246       }
247       return true;
248     }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public view returns (uint256) {
256     return balances[_owner];
257   }
258 
259 }
260 
261 
262 contract DetailedERC20 is ERC20 {
263   string public name;
264   string public symbol;
265   uint8 public decimals;
266 
267   constructor(string _name, string _symbol, uint8 _decimals) public {
268     name = _name;
269     symbol = _symbol;
270     decimals = _decimals;
271   }
272 }
273 
274 contract StandardToken is DetailedERC20('Gold Features Coin Token','GFCT',18), BasicToken(10000000000000000000000000000) {
275 
276   mapping (address => mapping (address => uint256)) internal allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(
286     address _from,
287     address _to,
288     uint256 _value
289   )
290     public
291     returns (bool)
292   {
293     require(_to != address(0));
294     require(_value <= balances[_from]);
295     require(_value <= allowed[_from][msg.sender]);
296 
297     balances[_from] = balances[_from].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300     emit Transfer(_from, _to, _value);
301     return true;
302   }
303   
304   
305 
306   /**
307    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
308    * Beware that changing an allowance with this method brings the risk that someone may use both the old
309    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
310    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
311    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312    * @param _spender The address which will spend the funds.
313    * @param _value The amount of tokens to be spent.
314    */
315   function approve(address _spender, uint256 _value) public returns (bool) {
316     require(allowed[msg.sender][_spender] == 0);
317     allowed[msg.sender][_spender] = _value;
318     emit Approval(msg.sender, _spender, _value);
319     return true;
320   }
321 
322   /**
323    * @dev Function to check the amount of tokens that an owner allowed to a spender.
324    * @param _owner address The address which owns the funds.
325    * @param _spender address The address which will spend the funds.
326    * @return A uint256 specifying the amount of tokens still available for the spender.
327    */
328   function allowance(
329     address _owner,
330     address _spender
331    )
332     public
333     view
334     returns (uint256)
335   {
336     return allowed[_owner][_spender];
337   }
338 
339   /**
340    * @dev Increase the amount of tokens that an owner allowed to a spender.
341    * approve should be called when allowed[_spender] == 0. To increment
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _addedValue The amount of tokens to increase the allowance by.
347    */
348   function increaseApproval(
349     address _spender,
350     uint256 _addedValue
351   )
352     public
353     returns (bool)
354   {
355     allowed[msg.sender][_spender] = (
356       allowed[msg.sender][_spender].add(_addedValue));
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    * approve should be called when allowed[_spender] == 0. To decrement
364    * allowed value is better to use this function to avoid 2 calls (and wait until
365    * the first transaction is mined)
366    * From MonolithDAO Token.sol
367    * @param _spender The address which will spend the funds.
368    * @param _subtractedValue The amount of tokens to decrease the allowance by.
369    */
370   function decreaseApproval(
371     address _spender,
372     uint256 _subtractedValue
373   )
374     public
375     returns (bool)
376   {
377     uint256 oldValue = allowed[msg.sender][_spender];
378     if (_subtractedValue > oldValue) {
379       allowed[msg.sender][_spender] = 0;
380     } else {
381       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
382     }
383     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386   
387   function recoverLost(
388     address lost,
389     uint256 amount
390   )
391     public
392     returns (bool)
393   {
394     this.transfer(lost,amount);
395   }
396 
397 }
398 
399 
400 contract GFCT_Token is StandardToken, Pausable {
401 
402   function transfer(
403     address _to,
404     uint256 _value
405   )
406     public
407     whenNotPaused
408     returns (bool)
409   {
410     return super.transfer(_to, _value);
411   }
412 
413   function batchTransfer (
414       address[] _receivers,
415       uint256 _value
416     )
417       public
418       whenNotPaused
419       onlyAdmins
420       returns (bool) 
421     {
422       return super.batchTransfer(_receivers, _value);
423     }
424 
425   function transferFrom(
426     address _from,
427     address _to,
428     uint256 _value
429   )
430     public
431     whenNotPaused
432     returns (bool)
433   {
434     return super.transferFrom(_from, _to, _value);
435   }
436 
437   function approve(
438     address _spender,
439     uint256 _value
440   )
441     public
442     whenNotPaused
443     returns (bool)
444   {
445     return super.approve(_spender, _value);
446   }
447 
448   function increaseApproval(
449     address _spender,
450     uint _addedValue
451   )
452     public
453     whenNotPaused
454     returns (bool success)
455   {
456     return super.increaseApproval(_spender, _addedValue);
457   }
458 
459   function decreaseApproval(
460     address _spender,
461     uint _subtractedValue
462   )
463     public
464     whenNotPaused
465     returns (bool success)
466   {
467     return super.decreaseApproval(_spender, _subtractedValue);
468   }
469   
470   function recoverLost(
471       address lost,
472       uint256 amount
473     )
474       public
475       whenNotPaused
476       onlyOwner
477       returns(bool)
478     {
479         return super.recoverLost(lost,amount);
480     }
481 }