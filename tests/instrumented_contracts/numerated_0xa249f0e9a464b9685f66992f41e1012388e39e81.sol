1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**a
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address _who) public view returns (uint256);
149   function transfer(address _to, uint256 _value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) internal balances;
157 
158   uint256 internal totalSupply_;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_value <= balances[msg.sender]);
174     require(_to != address(0));
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 contract ERC20 is ERC20Basic {
194   function allowance(address _owner, address _spender)
195     public view returns (uint256);
196 
197   function transferFrom(address _from, address _to, uint256 _value)
198     public returns (bool);
199 
200   function approve(address _spender, uint256 _value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(
220     address _from,
221     address _to,
222     uint256 _value
223   )
224     public
225     returns (bool)
226   {
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229     require(_to != address(0));
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(
260     address _owner,
261     address _spender
262    )
263     public
264     view
265     returns (uint256)
266   {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint256 _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint256 _subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     uint256 oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue >= oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 contract PausableToken is StandardToken, Pausable {
321 
322   function transfer(
323     address _to,
324     uint256 _value
325   )
326     public
327     whenNotPaused
328     returns (bool)
329   {
330     return super.transfer(_to, _value);
331   }
332 
333   function transferFrom(
334     address _from,
335     address _to,
336     uint256 _value
337   )
338     public
339     whenNotPaused
340     returns (bool)
341   {
342     return super.transferFrom(_from, _to, _value);
343   }
344 
345   function approve(
346     address _spender,
347     uint256 _value
348   )
349     public
350     whenNotPaused
351     returns (bool)
352   {
353     return super.approve(_spender, _value);
354   }
355 
356   function increaseApproval(
357     address _spender,
358     uint _addedValue
359   )
360     public
361     whenNotPaused
362     returns (bool success)
363   {
364     return super.increaseApproval(_spender, _addedValue);
365   }
366 
367   function decreaseApproval(
368     address _spender,
369     uint _subtractedValue
370   )
371     public
372     whenNotPaused
373     returns (bool success)
374   {
375     return super.decreaseApproval(_spender, _subtractedValue);
376   }
377 }
378 
379 contract AerumToken is Ownable, PausableToken {
380 
381     string public name = "Aerum";
382     string public symbol = "XRM";
383     uint8 public decimals = 18;
384     uint256 public initialSupply = 1000 * 1000 * 1000;
385 
386     constructor() public {
387         totalSupply_ = initialSupply * (10 ** uint256(decimals));
388         balances[owner] = totalSupply_;
389     }
390 
391     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
392         require(_spender != address(this));
393         require(super.approve(_spender, _value));
394         require(_spender.call(_data));
395         return true;
396     }
397 }