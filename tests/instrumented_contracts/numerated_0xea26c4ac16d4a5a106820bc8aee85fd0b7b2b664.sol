1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 }
48 
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     emit Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     emit Unpause();
86   }
87 }
88 
89 contract ERC20Basic {
90   function totalSupply() public view returns (uint256);
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     emit Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender)
138     public view returns (uint256);
139 
140   function transferFrom(address from, address to, uint256 value)
141     public returns (bool);
142 
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(
163     address _from,
164     address _to,
165     uint256 _value
166   )
167     public
168     returns (bool)
169   {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     emit Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     emit Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(
204     address _owner,
205     address _spender
206    )
207     public
208     view
209     returns (uint256)
210   {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseApproval(
248     address _spender,
249     uint _subtractedValue
250   )
251     public
252     returns (bool)
253   {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 contract PausableToken is StandardToken, Pausable {
267 
268   function transfer(
269     address _to,
270     uint256 _value
271   )
272     public
273     whenNotPaused
274     returns (bool)
275   {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(
280     address _from,
281     address _to,
282     uint256 _value
283   )
284     public
285     whenNotPaused
286     returns (bool)
287   {
288     return super.transferFrom(_from, _to, _value);
289   }
290 
291   function approve(
292     address _spender,
293     uint256 _value
294   )
295     public
296     whenNotPaused
297     returns (bool)
298   {
299     return super.approve(_spender, _value);
300   }
301 
302   function increaseApproval(
303     address _spender,
304     uint _addedValue
305   )
306     public
307     whenNotPaused
308     returns (bool success)
309   {
310     return super.increaseApproval(_spender, _addedValue);
311   }
312 
313   function decreaseApproval(
314     address _spender,
315     uint _subtractedValue
316   )
317     public
318     whenNotPaused
319     returns (bool success)
320   {
321     return super.decreaseApproval(_spender, _subtractedValue);
322   }
323 }
324 
325 contract DetailedERC20 is ERC20 {
326   string public name;
327   string public symbol;
328   uint8 public decimals;
329 
330   constructor(string _name, string _symbol, uint8 _decimals) public {
331     name = _name;
332     symbol = _symbol;
333     decimals = _decimals;
334   }
335 }
336 
337 contract QuarkChainToken is DetailedERC20, PausableToken {
338 
339     using SafeMath for uint256;
340 
341     // One time switch to enable token transferability.
342     bool public transferable = false;
343 
344     // Record private sale wallet to allow transfering.
345     address public privateSaleWallet;
346 
347     // Crowdsale contract address set externally.
348     address public crowdsaleAddress;
349 
350     // 10 billion tokens, 18 decimals.
351     uint public constant INITIAL_SUPPLY = 1e28;
352 
353     modifier onlyWhenTransferEnabled() {
354         if (!transferable) {
355             require(msg.sender == owner || msg.sender == crowdsaleAddress || msg.sender == privateSaleWallet);
356         }
357         _;
358     }
359 
360     modifier validDestination(address to) {
361         require(to != address(this));
362         _;
363     }
364 
365     constructor() public DetailedERC20("QuarkChain Token", "QKC", 18) {
366         totalSupply_ = INITIAL_SUPPLY;
367     }
368 
369     /// @dev Override to only allow tranfer after being switched on.
370     function transferFrom(address _from, address _to, uint256 _value)
371         public
372         validDestination(_to)
373         onlyWhenTransferEnabled
374         returns (bool)
375     {
376         return super.transferFrom(_from, _to, _value);
377     }
378 
379     /// @dev Override to only allow tranfer after being switched on.
380     function transfer(address _to, uint256 _value)
381         public
382         validDestination(_to)
383         onlyWhenTransferEnabled
384         returns (bool)
385     {
386         return super.transfer(_to, _value);
387     }
388 
389     /**
390      * @dev One-time switch to enable transfer.
391      */
392     function enableTransfer() external onlyOwner {
393         transferable = true;
394     }
395 
396     /**
397      * @dev Run this before crowdsale begins, so crowdsale contract could transfer tokens.
398      */
399     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
400         // Can only set one time.
401         require(crowdsaleAddress == 0x0);
402         require(_crowdsaleAddress != 0x0);
403         crowdsaleAddress = _crowdsaleAddress;
404         balances[crowdsaleAddress] = INITIAL_SUPPLY;
405     }
406 
407     /**
408      * @dev Run this before crowdsale begins, so private sale wallet could transfer tokens.
409      */
410     function setPrivateSaleAddress(address _privateSaleWallet) external onlyOwner {
411         // Can only set one time.
412         require(privateSaleWallet == 0x0);
413         privateSaleWallet = _privateSaleWallet;
414     }
415 
416 }
417 
418 library SafeMath {
419 
420   /**
421   * @dev Multiplies two numbers, throws on overflow.
422   */
423   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
424     if (a == 0) {
425       return 0;
426     }
427     c = a * b;
428     assert(c / a == b);
429     return c;
430   }
431 
432   /**
433   * @dev Integer division of two numbers, truncating the quotient.
434   */
435   function div(uint256 a, uint256 b) internal pure returns (uint256) {
436     // assert(b > 0); // Solidity automatically throws when dividing by 0
437     // uint256 c = a / b;
438     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439     return a / b;
440   }
441 
442   /**
443   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
444   */
445   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446     assert(b <= a);
447     return a - b;
448   }
449 
450   /**
451   * @dev Adds two numbers, throws on overflow.
452   */
453   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
454     c = a + b;
455     assert(c >= a);
456     return c;
457   }
458 }