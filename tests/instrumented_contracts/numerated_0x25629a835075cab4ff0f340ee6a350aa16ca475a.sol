1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * See https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address _who) public view returns (uint256);
81   function transfer(address _to, uint256 _value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
86 
87 pragma solidity ^0.4.24;
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender)
97     public view returns (uint256);
98 
99   function transferFrom(address _from, address _to, uint256 _value)
100     public returns (bool);
101 
102   function approve(address _spender, uint256 _value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
111 
112 pragma solidity ^0.4.24;
113 
114 
115 
116 /**
117  * @title DetailedERC20 token
118  * @dev The decimals are only for visualization purposes.
119  * All the operations are done using the smallest and indivisible token unit,
120  * just as on Ethereum all the operations are done in wei.
121  */
122 contract DetailedERC20 is ERC20 {
123   string public name;
124   string public symbol;
125   uint8 public decimals;
126 
127   constructor(string _name, string _symbol, uint8 _decimals) public {
128     name = _name;
129     symbol = _symbol;
130     decimals = _decimals;
131   }
132 }
133 
134 // File: zeppelin-solidity/contracts/math/Math.sol
135 
136 pragma solidity ^0.4.24;
137 
138 
139 /**
140  * @title Math
141  * @dev Assorted math operations
142  */
143 library Math {
144   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
145     return _a >= _b ? _a : _b;
146   }
147 
148   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
149     return _a < _b ? _a : _b;
150   }
151 
152   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
153     return _a >= _b ? _a : _b;
154   }
155 
156   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     return _a < _b ? _a : _b;
158   }
159 }
160 
161 // File: zeppelin-solidity/contracts/math/SafeMath.sol
162 
163 pragma solidity ^0.4.24;
164 
165 
166 /**
167  * @title SafeMath
168  * @dev Math operations with safety checks that throw on error
169  */
170 library SafeMath {
171 
172   /**
173   * @dev Multiplies two numbers, throws on overflow.
174   */
175   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
176     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
177     // benefit is lost if 'b' is also tested.
178     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
179     if (_a == 0) {
180       return 0;
181     }
182 
183     c = _a * _b;
184     assert(c / _a == _b);
185     return c;
186   }
187 
188   /**
189   * @dev Integer division of two numbers, truncating the quotient.
190   */
191   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
192     // assert(_b > 0); // Solidity automatically throws when dividing by 0
193     // uint256 c = _a / _b;
194     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
195     return _a / _b;
196   }
197 
198   /**
199   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
200   */
201   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
202     assert(_b <= _a);
203     return _a - _b;
204   }
205 
206   /**
207   * @dev Adds two numbers, throws on overflow.
208   */
209   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
210     c = _a + _b;
211     assert(c >= _a);
212     return c;
213   }
214 }
215 
216 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
217 
218 pragma solidity ^0.4.24;
219 
220 
221 
222 
223 /**
224  * @title Basic token
225  * @dev Basic version of StandardToken, with no allowances.
226  */
227 contract BasicToken is ERC20Basic {
228   using SafeMath for uint256;
229 
230   mapping(address => uint256) internal balances;
231 
232   uint256 internal totalSupply_;
233 
234   /**
235   * @dev Total number of tokens in existence
236   */
237   function totalSupply() public view returns (uint256) {
238     return totalSupply_;
239   }
240 
241   /**
242   * @dev Transfer token for a specified address
243   * @param _to The address to transfer to.
244   * @param _value The amount to be transferred.
245   */
246   function transfer(address _to, uint256 _value) public returns (bool) {
247     require(_value <= balances[msg.sender]);
248     require(_to != address(0));
249 
250     balances[msg.sender] = balances[msg.sender].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     emit Transfer(msg.sender, _to, _value);
253     return true;
254   }
255 
256   /**
257   * @dev Gets the balance of the specified address.
258   * @param _owner The address to query the the balance of.
259   * @return An uint256 representing the amount owned by the passed address.
260   */
261   function balanceOf(address _owner) public view returns (uint256) {
262     return balances[_owner];
263   }
264 
265 }
266 
267 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
268 
269 pragma solidity ^0.4.24;
270 
271 
272 
273 
274 /**
275  * @title Standard ERC20 token
276  *
277  * @dev Implementation of the basic standard token.
278  * https://github.com/ethereum/EIPs/issues/20
279  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
280  */
281 contract StandardToken is ERC20, BasicToken {
282 
283   mapping (address => mapping (address => uint256)) internal allowed;
284 
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(
293     address _from,
294     address _to,
295     uint256 _value
296   )
297     public
298     returns (bool)
299   {
300     require(_value <= balances[_from]);
301     require(_value <= allowed[_from][msg.sender]);
302     require(_to != address(0));
303 
304     balances[_from] = balances[_from].sub(_value);
305     balances[_to] = balances[_to].add(_value);
306     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
307     emit Transfer(_from, _to, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
313    * Beware that changing an allowance with this method brings the risk that someone may use both the old
314    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
315    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
316    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317    * @param _spender The address which will spend the funds.
318    * @param _value The amount of tokens to be spent.
319    */
320   function approve(address _spender, uint256 _value) public returns (bool) {
321     allowed[msg.sender][_spender] = _value;
322     emit Approval(msg.sender, _spender, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Function to check the amount of tokens that an owner allowed to a spender.
328    * @param _owner address The address which owns the funds.
329    * @param _spender address The address which will spend the funds.
330    * @return A uint256 specifying the amount of tokens still available for the spender.
331    */
332   function allowance(
333     address _owner,
334     address _spender
335    )
336     public
337     view
338     returns (uint256)
339   {
340     return allowed[_owner][_spender];
341   }
342 
343   /**
344    * @dev Increase the amount of tokens that an owner allowed to a spender.
345    * approve should be called when allowed[_spender] == 0. To increment
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _addedValue The amount of tokens to increase the allowance by.
351    */
352   function increaseApproval(
353     address _spender,
354     uint256 _addedValue
355   )
356     public
357     returns (bool)
358   {
359     allowed[msg.sender][_spender] = (
360       allowed[msg.sender][_spender].add(_addedValue));
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    * approve should be called when allowed[_spender] == 0. To decrement
368    * allowed value is better to use this function to avoid 2 calls (and wait until
369    * the first transaction is mined)
370    * From MonolithDAO Token.sol
371    * @param _spender The address which will spend the funds.
372    * @param _subtractedValue The amount of tokens to decrease the allowance by.
373    */
374   function decreaseApproval(
375     address _spender,
376     uint256 _subtractedValue
377   )
378     public
379     returns (bool)
380   {
381     uint256 oldValue = allowed[msg.sender][_spender];
382     if (_subtractedValue >= oldValue) {
383       allowed[msg.sender][_spender] = 0;
384     } else {
385       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
386     }
387     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388     return true;
389   }
390 
391 }
392 
393 // File: contracts/Hashtag.sol
394 
395 pragma solidity >=0.4.24 <0.6.0;
396 
397 
398 
399 
400 
401 contract Hashtag is DetailedERC20, StandardToken, Ownable {
402     using Math for uint256;
403     using SafeMath for uint256;
404 
405     uint256 public cap;
406     uint256 public blockIncome;
407     uint public processedBlockNumber;
408 
409     constructor(string _name, string _symbol, uint8 _decimals, uint _blockIncome, uint _cap) DetailedERC20(_name, _symbol, _decimals) StandardToken() Ownable() public {
410         require(_cap > 0);
411         require(_blockIncome > 0);
412 
413         cap = _cap;
414         blockIncome = _blockIncome;
415         processedBlockNumber = block.number;
416     }
417 
418     function mine() public onlyOwner returns (uint256) {
419         uint blocksCount = block.number - processedBlockNumber;
420         uint256 proposedIncome = blocksCount.mul(blockIncome);
421         uint256 nextTotalSupply = totalSupply_.add(proposedIncome);
422         uint256 cappedTotalSupply = nextTotalSupply.min256(cap);
423         uint256 actualIncome = cappedTotalSupply - totalSupply_;
424 
425         require(actualIncome > 0);
426 
427         balances[owner] = balances[owner].add(actualIncome);
428         totalSupply_ = cappedTotalSupply;
429         processedBlockNumber = block.number;
430 
431         return actualIncome;
432     }
433 }