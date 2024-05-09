1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 //-------------------------------------------------------------------------------------------------
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 //-------------------------------------------------------------------------------------------------
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 //-------------------------------------------------------------------------------------------------
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   /**
98   * @dev total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 //-------------------------------------------------------------------------------------------------
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(
151     address _from,
152     address _to,
153     uint256 _value
154   )
155     public
156     returns (bool)
157   {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(
192     address _owner,
193     address _spender
194    )
195     public
196     view
197     returns (uint256)
198   {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 //-------------------------------------------------------------------------------------------------
255 
256 /**
257  * @title Burnable Token
258  * @dev Token that can be irreversibly burned (destroyed).
259  */
260 contract BurnableToken is BasicToken {
261 
262   event Burn(address indexed burner, uint256 value);
263 
264   /**
265    * @dev Burns a specific amount of tokens.
266    * @param _value The amount of token to be burned.
267    */
268   function burn(uint256 _value) public {
269     _burn(msg.sender, _value);
270   }
271 
272   function _burn(address _who, uint256 _value) internal {
273     require(_value <= balances[_who]);
274     // no need to require value <= totalSupply, since that would imply the
275     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
276 
277     balances[_who] = balances[_who].sub(_value);
278     totalSupply_ = totalSupply_.sub(_value);
279     emit Burn(_who, _value);
280     emit Transfer(_who, address(0), _value);
281   }
282 }
283 
284 //-------------------------------------------------------------------------------------------------
285 
286 /**
287  * @title Ownable
288  * @dev The Ownable contract has an owner address, and provides basic authorization control
289  * functions, this simplifies the implementation of "user permissions".
290  */
291 contract Ownable {
292   address public owner;
293 
294 
295   event OwnershipRenounced(address indexed previousOwner);
296   event OwnershipTransferred(
297     address indexed previousOwner,
298     address indexed newOwner
299   );
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   constructor() public {
307     owner = msg.sender;
308   }
309 
310   /**
311    * @dev Throws if called by any account other than the owner.
312    */
313   modifier onlyOwner() {
314     require(msg.sender == owner);
315     _;
316   }
317 
318   /**
319    * @dev Allows the current owner to transfer control of the contract to a newOwner.
320    * @param newOwner The address to transfer ownership to.
321    */
322   function transferOwnership(address newOwner) public onlyOwner {
323     require(newOwner != address(0));
324     emit OwnershipTransferred(owner, newOwner);
325     owner = newOwner;
326   }
327 
328   /**
329    * @dev Allows the current owner to relinquish control of the contract.
330    */
331   function renounceOwnership() public onlyOwner {
332     emit OwnershipRenounced(owner);
333     owner = address(0);
334   }
335 }
336 
337 //-------------------------------------------------------------------------------------------------
338 
339 contract AifiAsset is Ownable {
340   using SafeMath for uint256;
341 
342   enum AssetState { Pending, Active, Expired }
343   string public assetType;
344   uint256 public totalSupply;
345   AssetState public state;
346 
347   constructor() public {
348     state = AssetState.Pending;
349   }
350 
351   function setState(AssetState _state) public onlyOwner {
352     state = _state;
353     emit SetStateEvent(_state);
354   }
355 
356   event SetStateEvent(AssetState indexed state);
357 }
358 
359 //-------------------------------------------------------------------------------------------------
360 
361 contract AifiToken is StandardToken, Ownable, BurnableToken {
362   using SafeMath for uint256;
363 
364   string public name = "AIFIToken";
365   string public symbol = "AIFI";
366   uint8 public decimals = 18;
367   uint public initialSupply = 0;
368   AifiAsset[] public aifiAssets;
369 
370   constructor() public {
371     totalSupply_ = initialSupply;
372     balances[owner] = initialSupply;
373   }
374 
375   function _ownerSupply() internal view returns (uint256) {
376     return balances[owner];
377   }
378 
379   function _mint(uint256 _amount) internal onlyOwner {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[owner] = balances[owner].add(_amount);
382   }
383 
384   function addAsset(AifiAsset _asset) public onlyOwner {
385     require(_asset.state() == AifiAsset.AssetState.Pending);
386     aifiAssets.push(_asset);
387     _mint(_asset.totalSupply());
388     emit AddAifiAssetEvent(_asset);
389   }
390 
391   function mint(uint256 _amount) public onlyOwner {
392     _mint(_amount);
393     emit MintEvent(_amount);
394   }
395 
396   function mintInterest(uint256 _amount) public onlyOwner {
397     _mint(_amount);
398     emit MintInterestEvent(_amount);
399   }
400 
401   function payInterest(address _to, uint256 _amount) public onlyOwner {
402     require(_ownerSupply() >= _amount);
403     balances[owner] = balances[owner].sub(_amount);
404     balances[_to] = balances[_to].add(_amount);
405     emit PayInterestEvent(_to, _amount);
406   }
407 
408   function burn(uint256 _value) public onlyOwner {
409     super.burn(_value);
410   }
411 
412   function setAssetToExpire(uint _index) public onlyOwner {
413     AifiAsset asset = aifiAssets[_index];
414     require(asset.state() == AifiAsset.AssetState.Active);
415     super.burn(asset.totalSupply());
416     emit SetAssetToExpireEvent(_index, asset);
417   }
418 
419   // Event
420   event AddAifiAssetEvent(AifiAsset indexed assetAddress);
421   event MintEvent(uint256 indexed amount);
422   event MintInterestEvent(uint256 indexed amount);
423   event PayInterestEvent(address indexed to, uint256 indexed amount);
424   event SetAssetToExpireEvent(uint indexed index, AifiAsset indexed asset);
425 }