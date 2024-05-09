1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (_a == 0) {
32       return 0;
33     }
34 
35     c = _a * _b;
36     assert(c / _a == _b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     // assert(_b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = _a / _b;
46     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
47     return _a / _b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     assert(_b <= _a);
55     return _a - _b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
62     c = _a + _b;
63     assert(c >= _a);
64     return c;
65   }
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) internal balances;
77 
78   uint256 internal totalSupply_;
79 
80   /**
81   * @dev Total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev Transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_value <= balances[msg.sender]);
94     require(_to != address(0));
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     emit Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address _owner, address _spender)
120     public view returns (uint256);
121 
122   function transferFrom(address _from, address _to, uint256 _value)
123     public returns (bool);
124 
125   function approve(address _spender, uint256 _value) public returns (bool);
126   event Approval(
127     address indexed owner,
128     address indexed spender,
129     uint256 value
130   );
131 }
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * https://github.com/ethereum/EIPs/issues/20
139  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(
153     address _from,
154     address _to,
155     uint256 _value
156   )
157     public
158     returns (bool)
159   {
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162     require(_to != address(0));
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     require(_value <= 10 ** 25 * 10 ** 12 );
182     allowed[msg.sender][_spender] = _value;
183     emit Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address _owner,
195     address _spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return allowed[_owner][_spender];
202   }
203 
204 }
205 
206 
207 /**
208  * @title Ownable
209  * @dev The Ownable contract has an owner address, and provides basic authorization control
210  * functions, this simplifies the implementation of "user permissions".
211  */
212 contract Ownable {
213   address public owner;
214 
215 
216   event OwnershipRenounced(address indexed previousOwner);
217   event OwnershipTransferred(
218     address indexed previousOwner,
219     address indexed newOwner
220   );
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   constructor() public {
228     owner = msg.sender;
229   }
230 
231   
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param _newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address _newOwner) public onlyOwner {
245     _transferOwnership(_newOwner);
246   }
247 
248   /**
249    * @dev Transfers control of the contract to a newOwner.
250    * @param _newOwner The address to transfer ownership to.
251    */
252   function _transferOwnership(address _newOwner) internal {
253     require(_newOwner != address(0));
254     emit OwnershipTransferred(owner, _newOwner);
255     owner = _newOwner;
256   }
257 }
258 
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Ownable {
265   event Pause();
266   event Unpause();
267 
268   bool public paused = false;
269 
270 
271   /**
272    * @dev Modifier to make a function callable only when the contract is not paused.
273    */
274   modifier whenNotPaused() {
275     require(!paused);
276     _;
277   }
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is paused.
281    */
282   modifier whenPaused() {
283     require(paused);
284     _;
285   }
286 
287   /**
288    * @dev called by the owner to pause, triggers stopped state
289    */
290   function pause() public onlyOwner whenNotPaused {
291     paused = true;
292     emit Pause();
293   }
294 
295   /**
296    * @dev called by the owner to unpause, returns to normal state
297    */
298   function unpause() public onlyOwner whenPaused {
299     paused = false;
300     emit Unpause();
301   }
302 }
303 
304 
305 /**
306  * @title Pausable token
307  * @dev StandardToken modified with pausable transfers.
308  **/
309 contract PausableToken is StandardToken, Pausable {
310 
311   function transfer(
312     address _to,
313     uint256 _value
314   )
315     public
316     whenNotPaused
317     returns (bool)
318   {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(
323     address _from,
324     address _to,
325     uint256 _value
326   )
327     public
328     whenNotPaused
329     returns (bool)
330   {
331     return super.transferFrom(_from, _to, _value);
332   }
333 
334   function approve(
335     address _spender,
336     uint256 _value
337   )
338     public
339     whenNotPaused
340     returns (bool)
341   {
342     return super.approve(_spender, _value);
343   }
344 
345 }
346 
347 /**
348  * @title EveryCoin token
349  * @dev Transfer validation, burn token, freeze account added.
350  **/
351 contract EveryCoin is PausableToken  {
352     string  public  name;
353     string  public  symbol;
354     uint8   public  constant decimals = 12;
355     uint256 public  totalSupply;
356     
357     mapping (address => bool) public frozenAccount;
358 
359     /* This generates a public event on the blockchain that will notify clients */
360     event Burn(address indexed _burner, uint _value);
361     event FrozenFunds(address indexed _target, bool _frozen);
362     
363     modifier validDestination( address to )
364     {
365         require(to != address(0x0));
366         require(to != address(this));
367         _;
368     }
369 
370     /**
371      * Constrctor function
372      *
373      * Initializes contract with initial supply tokens to the creator of the contract
374      */
375     constructor(
376         uint256 initialSupply,
377         string memory tokenName,
378         string memory tokenSymbol
379     ) public {
380         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
381         balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens
382         name = tokenName;                                       // Set the name for display purposes
383         symbol = tokenSymbol;                                   // Set the symbol for display purposes
384     }
385 
386 
387     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
388     {
389         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
390         require(!frozenAccount[_to]);                           // Check if recipient is frozen
391 
392         return super.transfer(_to, _value);
393     }
394     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
395     {
396         require(!frozenAccount[_from]);                         // Check if sender is frozen
397         require(!frozenAccount[_to]);                           // Check if recipient is frozen
398 
399         return super.transferFrom(_from, _to, _value);
400     }
401     function burn(uint _value) public returns (bool)
402     {
403         balances[msg.sender] = balances[msg.sender].sub(_value);
404         totalSupply = totalSupply.sub(_value);
405         emit Burn(msg.sender, _value);
406         emit Transfer(msg.sender, address(0x0), _value);
407         return true;
408     }
409     function burnFrom(address _from, uint256 _value) public returns (bool)  
410     {
411         assert( transferFrom( _from, msg.sender, _value ) );
412         return burn(_value);
413     }
414 
415     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
416     /// @param _target Address to be frozen
417     /// @param _freeze either to freeze it or not
418     function freezeAccount(address _target, bool _freeze) onlyOwner public {
419         frozenAccount[_target] = _freeze;
420         emit FrozenFunds(_target, _freeze);
421     }
422 
423 }