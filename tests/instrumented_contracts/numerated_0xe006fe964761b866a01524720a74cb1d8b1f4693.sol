1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 contract ERC20Basic {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender)
94     public view returns (uint256);
95 
96   function transferFrom(address from, address to, uint256 value)
97     public returns (bool);
98 
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(
119     address _from,
120     address _to,
121     uint256 _value
122   )
123     public
124     returns (bool)
125   {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     emit Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(
160     address _owner,
161     address _spender
162    )
163     public
164     view
165     returns (uint256)
166   {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(
181     address _spender,
182     uint _addedValue
183   )
184     public
185     returns (bool)
186   {
187     allowed[msg.sender][_spender] = (
188       allowed[msg.sender][_spender].add(_addedValue));
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(
204     address _spender,
205     uint _subtractedValue
206   )
207     public
208     returns (bool)
209   {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 contract Ownable {
223   address public owner;
224 
225 
226   event OwnershipRenounced(address indexed previousOwner);
227   event OwnershipTransferred(
228     address indexed previousOwner,
229     address indexed newOwner
230   );
231 
232 
233   /**
234    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235    * account.
236    */
237   constructor() public {
238     owner = msg.sender;
239   }
240 
241   /**
242    * @dev Throws if called by any account other than the owner.
243    */
244   modifier onlyOwner() {
245     require(msg.sender == owner);
246     _;
247   }
248 
249   /**
250    * @dev Allows the current owner to relinquish control of the contract.
251    */
252   function renounceOwnership() public onlyOwner {
253     emit OwnershipRenounced(owner);
254     owner = address(0);
255   }
256 
257   /**
258    * @dev Allows the current owner to transfer control of the contract to a newOwner.
259    * @param _newOwner The address to transfer ownership to.
260    */
261   function transferOwnership(address _newOwner) public onlyOwner {
262     _transferOwnership(_newOwner);
263   }
264 
265   /**
266    * @dev Transfers control of the contract to a newOwner.
267    * @param _newOwner The address to transfer ownership to.
268    */
269   function _transferOwnership(address _newOwner) internal {
270     require(_newOwner != address(0));
271     emit OwnershipTransferred(owner, _newOwner);
272     owner = _newOwner;
273   }
274 }
275 
276 contract Pausable is Ownable {
277   event Pause();
278   event Unpause();
279 
280   bool public paused = false;
281 
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is not paused.
285    */
286   modifier whenNotPaused() {
287     require(!paused);
288     _;
289   }
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is paused.
293    */
294   modifier whenPaused() {
295     require(paused);
296     _;
297   }
298 
299   /**
300    * @dev called by the owner to pause, triggers stopped state
301    */
302   function pause() onlyOwner whenNotPaused public {
303     paused = true;
304     emit Pause();
305   }
306 
307   /**
308    * @dev called by the owner to unpause, returns to normal state
309    */
310   function unpause() onlyOwner whenPaused public {
311     paused = false;
312     emit Unpause();
313   }
314 }
315 
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(
319     address _to,
320     uint256 _value
321   )
322     public
323     whenNotPaused
324     returns (bool)
325   {
326     return super.transfer(_to, _value);
327   }
328 
329   function transferFrom(
330     address _from,
331     address _to,
332     uint256 _value
333   )
334     public
335     whenNotPaused
336     returns (bool)
337   {
338     return super.transferFrom(_from, _to, _value);
339   }
340 
341   function approve(
342     address _spender,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.approve(_spender, _value);
350   }
351 
352   function increaseApproval(
353     address _spender,
354     uint _addedValue
355   )
356     public
357     whenNotPaused
358     returns (bool success)
359   {
360     return super.increaseApproval(_spender, _addedValue);
361   }
362 
363   function decreaseApproval(
364     address _spender,
365     uint _subtractedValue
366   )
367     public
368     whenNotPaused
369     returns (bool success)
370   {
371     return super.decreaseApproval(_spender, _subtractedValue);
372   }
373 }
374 
375 contract BurnableToken is BasicToken {
376 
377   event Burn(address indexed burner, uint256 value);
378 
379   /**
380    * @dev Burns a specific amount of tokens.
381    * @param _value The amount of token to be burned.
382    */
383   function burn(uint256 _value) public {
384     _burn(msg.sender, _value);
385   }
386 
387   function _burn(address _who, uint256 _value) internal {
388     require(_value <= balances[_who]);
389     // no need to require value <= totalSupply, since that would imply the
390     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392     balances[_who] = balances[_who].sub(_value);
393     totalSupply_ = totalSupply_.sub(_value);
394     emit Burn(_who, _value);
395     emit Transfer(_who, address(0), _value);
396   }
397 }
398 
399 contract PGCoin is PausableToken, BurnableToken {
400 
401     string public name = 'Pangaea Coin';
402     string public symbol = 'PGC';
403     uint8 public decimals = 18;
404     uint256 public INITIAL_SUPPLY = 50000000000;
405 
406     constructor() public {
407         totalSupply_ = INITIAL_SUPPLY.mul(10**18);
408         balances[msg.sender] = totalSupply_;
409     }
410 
411     function burn(uint256 _value) public whenNotPaused {
412         super.burn(_value);
413     }
414 }