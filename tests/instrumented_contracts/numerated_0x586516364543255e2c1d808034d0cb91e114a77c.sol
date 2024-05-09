1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     emit OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46   /**
47    * @dev Allows the current owner to relinquish control of the contract.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     if (a == 0) {
66       return 0;
67     }
68     c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     // uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return a / b;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender)
119     public view returns (uint256);
120 
121   function transferFrom(address from, address to, uint256 value)
122     public returns (bool);
123 
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address _from,
196     address _to,
197     uint256 _value
198   )
199     public
200     returns (bool)
201   {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(
236     address _owner,
237     address _spender
238    )
239     public
240     view
241     returns (uint256)
242   {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(
257     address _spender,
258     uint _addedValue
259   )
260     public
261     returns (bool)
262   {
263     allowed[msg.sender][_spender] = (
264       allowed[msg.sender][_spender].add(_addedValue));
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Decrease the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(
280     address _spender,
281     uint _subtractedValue
282   )
283     public
284     returns (bool)
285   {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 contract DetailedERC20 is ERC20 {
299   string public name;
300   string public symbol;
301   uint8 public decimals;
302 
303   constructor(string _name, string _symbol, uint8 _decimals) public {
304     name = _name;
305     symbol = _symbol;
306     decimals = _decimals;
307   }
308 }
309 
310 contract BasicMultiToken is StandardToken, DetailedERC20 {
311     
312     ERC20[] public tokens;
313 
314     event Mint(address indexed minter, uint256 value);
315     event Burn(address indexed burner, uint256 value);
316     
317     constructor(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public
318         DetailedERC20(_name, _symbol, _decimals)
319     {
320         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
321         tokens = _tokens;
322     }
323 
324     function mint(address _to, uint256 _amount) public {
325         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
326         uint256[] memory tokenAmounts = new uint256[](tokens.length);
327         for (uint i = 0; i < tokens.length; i++) {
328             tokenAmounts[i] = _amount.mul(tokens[i].balanceOf(this)).div(totalSupply_);
329         }
330         _mint(_to, _amount, tokenAmounts);
331     }
332 
333     function mintFirstTokens(address _to, uint256 _amount, uint256[] _tokenAmounts) public {
334         require(totalSupply_ == 0, "This method can be used with zero total supply only");
335         _mint(_to, _amount, _tokenAmounts);
336     }
337 
338     function _mint(address _to, uint256 _amount, uint256[] _tokenAmounts) internal {
339         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
340         for (uint i = 0; i < tokens.length; i++) {
341             require(tokens[i].transferFrom(msg.sender, this, _tokenAmounts[i]));
342         }
343 
344         totalSupply_ = totalSupply_.add(_amount);
345         balances[_to] = balances[_to].add(_amount);
346         emit Mint(_to, _amount);
347         emit Transfer(address(0), _to, _amount);
348     }
349 
350     function burn(uint256 _value) public {
351         burnSome(_value, tokens);
352     }
353 
354     function burnSome(uint256 _value, ERC20[] someTokens) public {
355         require(_value <= balances[msg.sender]);
356 
357         for (uint i = 0; i < someTokens.length; i++) {
358             uint256 tokenAmount = _value.mul(someTokens[i].balanceOf(this)).div(totalSupply_);
359             require(someTokens[i].transfer(msg.sender, tokenAmount));
360         }
361         
362         balances[msg.sender] = balances[msg.sender].sub(_value);
363         totalSupply_ = totalSupply_.sub(_value);
364         emit Burn(msg.sender, _value);
365         emit Transfer(msg.sender, address(0), _value);
366     }
367 
368 }
369 
370 
371 interface ERC228 {
372     function changeableTokenCount() external view returns (uint16 count);
373     function changeableToken(uint16 _tokenIndex) external view returns (address tokenAddress);
374     function getReturn(address _fromToken, address _toToken, uint256 _amount) external view returns (uint256 amount);
375     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) external returns (uint256 amount);
376 
377     event Update();
378     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
379 }
380 
381 
382 contract MultiToken is BasicMultiToken, ERC228 {
383 
384     mapping(address => uint256) public weights;
385     
386     constructor(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public
387         BasicMultiToken(_tokens, _name, _symbol, _decimals)
388     {
389         _setWeights(_weights);
390     }
391 
392     function _setWeights(uint256[] _weights) internal {
393         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
394         for (uint i = 0; i < tokens.length; i++) {
395             require(_weights[i] != 0, "The _weights array should not contains zeros");
396             weights[tokens[i]] = _weights[i];
397         }
398     }
399 
400     function changeableTokenCount() public view returns (uint16 count) {
401         count = uint16(tokens.length);
402     }
403 
404     function changeableToken(uint16 _tokenIndex) public view returns (address tokenAddress) {
405         tokenAddress = tokens[_tokenIndex];
406     }
407 
408     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
409         uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
410         uint256 toBalance = ERC20(_toToken).balanceOf(this);
411         returnAmount = toBalance.mul(_amount).mul(weights[_toToken]).div(weights[_fromToken]).div(fromBalance.add(_amount));
412     }
413 
414     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
415         returnAmount = getReturn(_fromToken, _toToken, _amount);
416         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
417         require(ERC20(_fromToken).transferFrom(msg.sender, this, _amount));
418         require(ERC20(_toToken).transfer(msg.sender, returnAmount));
419         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
420     }
421 
422 }