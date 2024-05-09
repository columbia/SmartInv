1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     emit Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256) {
45     return balances[_owner];
46   }
47 }
48 
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (a == 0) {
59       return 0;
60     }
61 
62     c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return a / b;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89     c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender)
102     public view returns (uint256);
103 
104   function transferFrom(address from, address to, uint256 value)
105     public returns (bool);
106 
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(
127     address _from,
128     address _to,
129     uint256 _value
130   )
131     public
132     returns (bool)
133   {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(
168     address _owner,
169     address _spender
170    )
171     public
172     view
173     returns (uint256)
174   {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(
189     address _spender,
190     uint _addedValue
191   )
192     public
193     returns (bool)
194   {
195     allowed[msg.sender][_spender] = (
196       allowed[msg.sender][_spender].add(_addedValue));
197     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(
212     address _spender,
213     uint _subtractedValue
214   )
215     public
216     returns (bool)
217   {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 
231 /**
232  * @title Ownable
233  * @dev The Ownable contract has an owner address, and provides basic authorization control
234  * functions, this simplifies the implementation of "user permissions".
235  */
236 contract Ownable {
237   address public owner;
238 
239 
240   event OwnershipRenounced(address indexed previousOwner);
241   event OwnershipTransferred(
242     address indexed previousOwner,
243     address indexed newOwner
244   );
245 
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   constructor() public {
252     owner = msg.sender;
253   }
254 
255   /**
256    * @dev Throws if called by any account other than the owner.
257    */
258   modifier onlyOwner() {
259     require(msg.sender == owner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to relinquish control of the contract.
265    */
266   function renounceOwnership() public onlyOwner {
267     emit OwnershipRenounced(owner);
268     owner = address(0);
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param _newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address _newOwner) public onlyOwner {
276     _transferOwnership(_newOwner);
277   }
278 
279   /**
280    * @dev Transfers control of the contract to a newOwner.
281    * @param _newOwner The address to transfer ownership to.
282    */
283   function _transferOwnership(address _newOwner) internal {
284     require(_newOwner != address(0));
285     emit OwnershipTransferred(owner, _newOwner);
286     owner = _newOwner;
287   }
288 }
289 
290 
291 contract Pausable is Ownable {
292   event Pause();
293   event Unpause();
294 
295   bool public paused = false;
296 
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is not paused.
300    */
301   modifier whenNotPaused() {
302     require(!paused);
303     _;
304   }
305 
306   /**
307    * @dev Modifier to make a function callable only when the contract is paused.
308    */
309   modifier whenPaused() {
310     require(paused);
311     _;
312   }
313 
314   /**
315    * @dev called by the owner to pause, triggers stopped state
316    */
317   function pause() onlyOwner whenNotPaused public {
318     paused = true;
319     emit Pause();
320   }
321 
322   /**
323    * @dev called by the owner to unpause, returns to normal state
324    */
325   function unpause() onlyOwner whenPaused public {
326     paused = false;
327     emit Unpause();
328   }
329 }
330 
331 
332 contract PausableToken is StandardToken, Pausable {
333 
334   function transfer(
335     address _to,
336     uint256 _value
337   )
338     public
339     whenNotPaused
340     returns (bool)
341   {
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(
346     address _from,
347     address _to,
348     uint256 _value
349   )
350     public
351     whenNotPaused
352     returns (bool)
353   {
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357   function approve(
358     address _spender,
359     uint256 _value
360   )
361     public
362     whenNotPaused
363     returns (bool)
364   {
365     return super.approve(_spender, _value);
366   }
367 
368   function increaseApproval(
369     address _spender,
370     uint _addedValue
371   )
372     public
373     whenNotPaused
374     returns (bool success)
375   {
376     return super.increaseApproval(_spender, _addedValue);
377   }
378 
379   function decreaseApproval(
380     address _spender,
381     uint _subtractedValue
382   )
383     public
384     whenNotPaused
385     returns (bool success)
386   {
387     return super.decreaseApproval(_spender, _subtractedValue);
388   }
389 }
390 
391 contract BctToken is PausableToken {
392   string public constant name = "BctToken";
393   string public constant symbol = "BCT";
394   uint8 public constant decimals = 18;
395   uint256 public constant initialSupply = 2000000000000000000000000000;
396   
397   constructor() public {
398     totalSupply_ = initialSupply;
399     balances[msg.sender] = totalSupply_;
400   }
401 }