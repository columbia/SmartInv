1 pragma solidity ^0.5.6;
2 
3 library SafeMath {
4 	/**
5 	  * @dev Multiplies two unsigned integers, reverts on overflow.
6 	  */
7 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9 		// benefit is lost if 'b' is also tested.
10 		if (a == 0) {
11 			return 0;
12 		}
13 
14 		uint256 c = a * b;
15 		require(c / a == b);
16 		return c;
17   }
18 
19 	/**
20 		* @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
21 		*/
22 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 		// Solidity only automatically asserts when dividing by 0
24 		require(b > 0);
25 		uint256 c = a / b;
26 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 		return c;
28 	}
29 
30 	/**
31 		* @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
32 		*/
33 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34 		require(b <= a);
35 		uint256 c = a - b;
36 		return c;
37 	}
38 
39 	/**
40 		* @dev Adds two unsigned integers, reverts on overflow.
41 		*/
42 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
43 		uint256 c = a + b;
44 		require(c >= a);
45 		return c;
46 	}
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52   event OwnershipTransferred(
53     address indexed previousOwner,
54     address indexed newOwner
55   );
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() public onlyOwner whenNotPaused {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() public onlyOwner whenPaused {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  */
136 contract StandardToken {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) internal balances;
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143   uint256 internal totalSupply_;
144 
145   event Transfer(
146     address indexed from,
147     address indexed to,
148     uint256 value
149   );
150 
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 vaule
155   );
156 
157   event Burn(address indexed from, uint256 value);
158 
159   /**
160   * @dev Total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256) {
172     return balances[_owner];
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(
182     address _owner,
183     address _spender
184    )
185     public
186     view
187     returns (uint256)
188   {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193   * @dev Transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[msg.sender]);
200 
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     emit Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_to != address(0));
237     require(_value <= balances[_from]);
238     require(_value <= allowed[_from][msg.sender]);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(
257     address _spender,
258     uint256 _addedValue
259   )
260     public
261     returns (bool)
262   {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint256 _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint256 oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue >= oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Burns a specific amount of tokens.
296    * @param _value The amount of token to be burned.
297    */
298   function burn(uint256 _value) public {
299   	require(balances[msg.sender] >= _value);
300   	balances[msg.sender] = balances[msg.sender].sub(_value);
301   	totalSupply_ = totalSupply_.sub(_value);
302   	emit Transfer(msg.sender, address(0x00), _value);
303   	emit Burn(msg.sender, _value);
304   }
305 
306   /**
307    * @dev Burns a specific amount of tokens from the target address and decrements allowance
308    * @param _from address The account whose tokens will be burned.
309    * @param _value uint256 The amount of token to be burned.
310    */
311    function burnFrom(address _from, uint256 _value) public {
312   	require(allowed[_from][msg.sender] >= _value);
313   	require(balances[_from] >= _value);
314 
315   	allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
316   	balances[_from] = balances[_from].sub(_value);
317   	totalSupply_ = totalSupply_.sub(_value);
318   	emit Transfer(_from, address(0x00), _value);
319   	emit Burn(_from, _value);
320   }
321 
322 }
323 
324 /**
325  * Overriding ERC-20 specification that lets owner Pause all trading.
326  */
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(
330     address _to,
331     uint256 _value
332   )
333     public
334     whenNotPaused
335     returns (bool)
336   {
337     return super.transfer(_to, _value);
338   }
339 
340   function transferFrom(
341     address _from,
342     address _to,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(
353     address _spender,
354     uint256 _value
355   )
356     public
357     whenNotPaused
358     returns (bool)
359   {
360     return super.approve(_spender, _value);
361   }
362 
363   function increaseApproval(
364     address _spender,
365     uint _addedValue
366   )
367     public
368     whenNotPaused
369     returns (bool success)
370   {
371     return super.increaseApproval(_spender, _addedValue);
372   }
373 
374   function decreaseApproval(
375     address _spender,
376     uint _subtractedValue
377   )
378     public
379     whenNotPaused
380     returns (bool success)
381   {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 contract FreezeToken is PausableToken {
387   mapping(address=>bool) public frozenAccount;
388   event FrozenAccount(address indexed target, bool frozen);
389 
390   function frozenCheck(address target) internal view {
391     require(!frozenAccount[target]);
392   }
393 
394   function freezeAccount(address target, bool frozen) public onlyOwner {
395   	frozenAccount[target] = frozen;
396   	emit FrozenAccount(target, frozen);
397   }
398 
399   function transfer(
400     address _to,
401     uint256 _value
402   )
403     public
404     returns (bool)
405   {
406     frozenCheck(msg.sender);
407     frozenCheck(_to);
408     return super.transfer(_to, _value);
409   }
410 
411   function transferFrom(
412     address _from,
413     address _to,
414     uint256 _value
415   )
416     public
417     whenNotPaused
418     returns (bool)
419   {
420     frozenCheck(_from);
421     frozenCheck(_to);
422     return super.transferFrom(_from, _to, _value);
423   }
424 }
425 
426 contract KOMP is FreezeToken {
427   string public name = "kompass";
428   string public symbol = "KOMP"; 
429   uint8 public decimals = 18;
430   uint256 public initialSupply = 1000000000;
431   mapping (address => string) public keys;
432   
433   event Register (address user, string key);
434   
435   constructor() public {
436     totalSupply_ =  initialSupply * 10 ** uint256(decimals);
437     balances[msg.sender] = totalSupply_;
438     emit Transfer(address(0x00),msg.sender,totalSupply_);
439   }
440   
441   function register(string memory key) public {
442     keys[msg.sender] = key;
443     emit Register(msg.sender, key);
444   }
445 }