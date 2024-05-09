1 pragma solidity ^0.4.24;
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
18   * @dev Total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev Transfer token for a specified address
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
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender)
52     public view returns (uint256);
53 
54   function transferFrom(address from, address to, uint256 value)
55     public returns (bool);
56 
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint256 value
62   );
63 }
64 
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    * @notice Renouncing to ownership will leave the contract without an owner.
95    * It will not be possible to call the functions with the `onlyOwner`
96    * modifier anymore.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
128     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
129     // benefit is lost if 'b' is also tested.
130     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
131     if (a == 0) {
132       return 0;
133     }
134 
135     c = a * b;
136     assert(c / a == b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     // uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return a / b;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
162     c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(
220     address _owner,
221     address _spender
222    )
223     public
224     view
225     returns (uint256)
226   {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint256 _addedValue
242   )
243     public
244     returns (bool)
245   {
246     allowed[msg.sender][_spender] = (
247       allowed[msg.sender][_spender].add(_addedValue));
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint256 _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint256 oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 contract MintableToken is StandardToken, Ownable {
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   bool public mintingFinished = false;
285 
286 
287   modifier canMint() {
288     require(!mintingFinished);
289     _;
290   }
291 
292   modifier hasMintPermission() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Function to mint tokens
299    * @param _to The address that will receive the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(
304     address _to,
305     uint256 _amount
306   )
307     hasMintPermission
308     canMint
309     public
310     returns (bool)
311   {
312     totalSupply_ = totalSupply_.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     emit Mint(_to, _amount);
315     emit Transfer(address(0), _to, _amount);
316     return true;
317   }
318 
319   /**
320    * @dev Function to stop minting new tokens.
321    * @return True if the operation was successful.
322    */
323   function finishMinting() onlyOwner canMint public returns (bool) {
324     mintingFinished = true;
325     emit MintFinished();
326     return true;
327   }
328 }
329 
330 contract CappedToken is MintableToken {
331 
332   uint256 public cap;
333 
334   constructor(uint256 _cap) public {
335     require(_cap > 0);
336     cap = _cap;
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will receive the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(
346     address _to,
347     uint256 _amount
348   )
349     public
350     returns (bool)
351   {
352     require(totalSupply_.add(_amount) <= cap);
353 
354     return super.mint(_to, _amount);
355   }
356 
357 }
358 
359 contract OnacleToken is CappedToken {
360     string public name = "Onacle Network Core";
361     string public symbol = "ONC";
362     uint8 public constant decimals = 18;
363 
364     uint256 public constant decimalFactor = 10 ** uint256(decimals);
365 
366     uint256 public initialSupply = 6 * (10**8) * decimalFactor; // 600k
367 
368     uint256 public maxSupply = 1 * (10**9) * decimalFactor; // 1B
369 
370     constructor()
371       public
372       CappedToken(maxSupply)
373     {
374         totalSupply_ = initialSupply;
375         balances[msg.sender] = initialSupply;
376         emit Mint(msg.sender, initialSupply);
377         emit Transfer(address(0), msg.sender, initialSupply);
378     }
379 
380    /**
381     * @dev Function to mint tokens. Only part of amount would be minted
382     * if amount exceeds cap
383     *
384     * @param _to The address that will receive the minted tokens.
385     * @param _amount The amount of tokens to mint.
386     * @return A boolean that indicates if the operation was successful.
387     */
388     function mintFull(address _to, uint256 _amount)
389         onlyOwner
390         canMint
391         public
392         returns (bool)
393     {
394         require(totalSupply_ < cap);
395 
396         uint256 amountToMint;
397 
398         if (totalSupply_.add(_amount) >= cap) {
399             amountToMint = cap.sub(totalSupply_);
400         } else {
401             amountToMint = _amount;
402         }
403 
404         return MintableToken.mint(_to, amountToMint);
405     }
406 
407     /**
408      * @dev Function to distribute tokens to the list of addresses by the provided uniform amount
409      * @param _addresses List of addresses
410      * @param _amount Uniform amount of tokens
411      * @return A bool specifying the result of transfer
412      */
413      function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
414 
415          uint256 totalAmount = _amount.mul(_addresses.length);
416          require(balances[msg.sender] >= totalAmount);
417 
418          for (uint j = 0; j < _addresses.length; j++) {
419              balances[msg.sender] = balances[msg.sender].sub(_amount);
420              balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
421              emit Transfer(msg.sender, _addresses[j], _amount);
422          }
423          return true;
424      }
425 
426 
427     /**
428      * @dev Function to distribute tokens to the list of addresses by the provided various amount
429      * @param _addresses list of addresses
430      * @param _amounts list of token amounts
431      */
432      function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
433 
434          uint256 totalAmount = 0;
435 
436          for(uint j = 0; j < _addresses.length; j++){
437 
438              totalAmount = totalAmount.add(_amounts[j]);
439          }
440          require(balances[msg.sender] >= totalAmount);
441 
442          for (j = 0; j < _addresses.length; j++) {
443              balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
444              balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
445              emit Transfer(msg.sender, _addresses[j], _amounts[j]);
446          }
447          return true;
448      }
449 
450     
451 }