1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/KoreanLiberationDayToken.sol
322 
323 contract KoreanLiberationDayToken is StandardToken, Ownable {
324   string public constant name = "Token to commemorate the 73th Korean Liberation Day";
325   string public constant symbol = "815";
326   uint8 public constant decimals = 0;
327   uint16 internal constant TOTAL_SUPPLY = 815;
328 
329   mapping (uint16 => address) internal tokenIndexToOwner;
330 
331   bytes32[TOTAL_SUPPLY] tokens;
332 
333   event changeOwnerShip(address _from, address _to, uint16 indexed _tokenId);
334 
335   constructor() public {
336     totalSupply_ = 0;
337     balances[owner] = totalSupply_;
338     emit Transfer(address(0), owner, totalSupply_);
339   }
340 
341   function _firstTokenId(address _owner) private view returns(uint16) {
342     require(balanceOf(_owner) > 0);
343     for (uint16 tokenId = 0; tokenId < totalSupply(); tokenId++) {
344       if (this.ownerOf(tokenId) == _owner) {
345         return tokenId;
346       }
347     }
348   }
349 
350   function _bytes32ToString(bytes32 x) private pure returns(string) {
351     bytes memory bytesString = new bytes(32);
352     uint charCount = 0;
353     for (uint j = 0; j < 32; j++) {
354       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
355       if (char != 0) {
356         bytesString[charCount] = char;
357         charCount++;
358       }
359     }
360     bytes memory bytesStringTrimmed = new bytes(charCount);
361     for (j = 0; j < charCount; j++) {
362         bytesStringTrimmed[j] = bytesString[j];
363     }
364     return string(bytesStringTrimmed);
365   }
366 
367   function speech(uint16 tokenId) public view returns(string) {
368       return _bytes32ToString(tokens[tokenId]);
369   }
370 
371   function createTokens(bytes32[] _tokens) public onlyOwner {
372       require(_tokens.length > 0);
373       require(totalSupply_ + _tokens.length <= TOTAL_SUPPLY);
374       for (uint16 i = 0; i < _tokens.length; i++) {
375           tokens[totalSupply_++] = _tokens[i];
376           balances[owner]++;
377       }
378   }
379 
380   function transferTokenOwnership(address _from, address _to, uint16 _tokenId) public returns(bool) {
381     require(_from != address(0));
382     require(_to != address(0));
383     require(balanceOf(_from) > 0);
384 
385     tokenIndexToOwner[_tokenId] = _to;
386     emit changeOwnerShip(_from, _to, _tokenId);
387     return true;
388   }
389 
390   function transfer(address _to, uint256 _value) public returns(bool) {
391     require(balanceOf(msg.sender) >= _value);
392     for (uint16 i = 0; i < _value; i++) {
393       transferTokenOwnership(msg.sender, _to, _firstTokenId(msg.sender));
394       super.transfer(_to, 1);
395     }
396     return true;
397   }
398 
399   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
400     require(balanceOf(_from) >= _value);
401     for (uint16 i = 0; i < _value; i++) {
402       transferTokenOwnership(_from, _to, _firstTokenId(_from));
403       super.transferFrom(_from, _to, 1);
404     }
405     return true;
406   }
407 
408   function transferBatch(address [] _to) public returns(bool) {
409     require(_to.length > 0);
410     require(balanceOf(msg.sender) >= _to.length);
411 
412     for (uint16 i = 0; i < _to.length; i++) {
413       transferTokenOwnership(msg.sender, _to[i], _firstTokenId(msg.sender));
414       super.transfer(_to[i], 1);
415     }
416     return true;
417   }
418 
419   function approveBatch(address [] _to) public returns(bool) {
420     require(_to.length > 0);
421     require(balanceOf(msg.sender) >= _to.length);
422     for (uint16 i = 0; i < _to.length; i++) {
423       allowed[msg.sender][_to[i]] = 1;
424       emit Approval(msg.sender, _to[i], 1);
425     }
426     return true;
427   }
428 
429   function ownerOf(uint16 _tokenId) external view returns(address tokenOwner) {
430     require(_tokenId < totalSupply());
431     tokenOwner = tokenIndexToOwner[_tokenId];
432     if (tokenOwner == address(0)) {
433         return owner;
434     }
435   }
436 
437   function tokensOfOwner(address _owner) external view returns(uint16[]) {
438     uint256 tokenCount = balanceOf(_owner);
439     uint16 idx = 0;
440 
441     if (tokenCount == 0) {
442       return new uint16[](0);
443     } else {
444       uint16[] memory result = new uint16[](tokenCount);
445       for(uint16 tokenId = 0; tokenId < totalSupply(); tokenId++) {
446         if (this.ownerOf(tokenId) == _owner) {
447           result[idx++] = tokenId;
448         }
449       }
450     }
451 
452     return result;
453   }
454 
455   function speechOfOwner(address _owner) external view returns(bytes32[]) {
456     uint256 tokenCount = balanceOf(_owner);
457     uint16 idx = 0;
458 
459     if (tokenCount == 0) {
460       return new bytes32[](0);
461     } else {
462       bytes32[] memory result = new bytes32[](tokenCount);
463       for(uint16 tokenId = 0; tokenId < totalSupply(); tokenId++) {
464         if (this.ownerOf(tokenId) == _owner) {
465           result[idx++] = tokens[tokenId];
466         }
467       }
468     }
469 
470     return result;
471   }
472 }