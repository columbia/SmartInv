1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint oldValue = allowed[msg.sender][_spender];
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
280 // File: contracts/BasicMultiToken.sol
281 
282 contract BasicMultiToken is StandardToken, DetailedERC20 {
283     
284     ERC20[] public tokens;
285 
286     event Mint(address indexed minter, uint256 value);
287     event Burn(address indexed burner, uint256 value);
288     
289     constructor() public DetailedERC20("", "", 0) {
290     }
291 
292     function init(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public {
293         require(decimals == 0, "init: contract was already initialized");
294         require(_decimals > 0, "init: _decimals should not be zero");
295         require(bytes(_name).length > 0, "init: _name should not be empty");
296         require(bytes(_symbol).length > 0, "init: _symbol should not be empty");
297         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
298 
299         name = _name;
300         symbol = _symbol;
301         decimals = _decimals;
302         tokens = _tokens;
303     }
304 
305     function mintFirstTokens(address _to, uint256 _amount, uint256[] _tokenAmounts) public {
306         require(totalSupply_ == 0, "This method can be used with zero total supply only");
307         _mint(_to, _amount, _tokenAmounts);
308     }
309 
310     function mint(address _to, uint256 _amount) public {
311         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
312         uint256[] memory tokenAmounts = new uint256[](tokens.length);
313         for (uint i = 0; i < tokens.length; i++) {
314             tokenAmounts[i] = tokens[i].balanceOf(this).mul(_amount).div(totalSupply_);
315         }
316         _mint(_to, _amount, tokenAmounts);
317     }
318 
319     function burn(uint256 _value) public {
320         burnSome(_value, tokens);
321     }
322 
323     function burnSome(uint256 _value, ERC20[] someTokens) public {
324         require(someTokens.length > 0, "Array of tokens can't be empty");
325 
326         uint256 totalSupply = totalSupply_;
327         balances[msg.sender] = balances[msg.sender].sub(_value);
328         totalSupply_ = totalSupply.sub(_value);
329         emit Burn(msg.sender, _value);
330         emit Transfer(msg.sender, address(0), _value);
331 
332         for (uint i = 0; i < someTokens.length; i++) {
333             uint256 prevBalance = someTokens[i].balanceOf(this);
334             uint256 tokenAmount = prevBalance.mul(_value).div(totalSupply);
335             someTokens[i].transfer(msg.sender, tokenAmount); // Can't use require because not all ERC20 tokens return bool
336             require(someTokens[i].balanceOf(this) == prevBalance.sub(tokenAmount), "Invalid token behavior");
337         }
338     }
339 
340     function _mint(address _to, uint256 _amount, uint256[] _tokenAmounts) internal {
341         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
342 
343         for (uint i = 0; i < tokens.length; i++) {
344             uint256 prevBalance = tokens[i].balanceOf(this);
345             tokens[i].transferFrom(msg.sender, this, _tokenAmounts[i]); // Can't use require because not all ERC20 tokens return bool
346             require(tokens[i].balanceOf(this) == prevBalance.add(_tokenAmounts[i]), "Invalid token behavior");
347         }
348 
349         totalSupply_ = totalSupply_.add(_amount);
350         balances[_to] = balances[_to].add(_amount);
351         emit Mint(_to, _amount);
352         emit Transfer(address(0), _to, _amount);
353     }
354 
355     function allTokens() public view returns(ERC20[]) {
356         return tokens;
357     }
358 
359     function allBalances() public view returns(uint256[]) {
360         uint256[] memory balances = new uint256[](tokens.length);
361         for (uint i = 0; i < tokens.length; i++) {
362             balances[i] = tokens[i].balanceOf(this);
363         }
364         return balances;
365     }
366 
367 }
368 
369 // File: contracts/ERC228.sol
370 
371 interface ERC228 {
372     function changeableTokenCount() external view returns (uint16 count);
373     function changeableToken(uint16 _tokenIndex) external view returns (address tokenAddress);
374     function getReturn(address _fromToken, address _toToken, uint256 _amount) external view returns (uint256 returnAmount);
375     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) external returns (uint256 returnAmount);
376 
377     event Update();
378     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
379 }
380 
381 // File: contracts/MultiToken.sol
382 
383 contract MultiToken is BasicMultiToken, ERC228 {
384 
385     mapping(address => uint256) public weights;
386 
387     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
388         super.init(_tokens, _name, _symbol, _decimals);
389         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
390         for (uint i = 0; i < tokens.length; i++) {
391             require(_weights[i] != 0, "The _weights array should not contains zeros");
392             require(weights[tokens[i]] == 0, "The _tokens array have duplicates");
393             weights[tokens[i]] = _weights[i];
394         }
395     }
396 
397     function init2(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
398         init(_tokens, _weights, _name, _symbol, _decimals);
399     }
400 
401     function changeableTokenCount() public view returns (uint16 count) {
402         count = uint16(tokens.length);
403     }
404 
405     function changeableToken(uint16 _tokenIndex) public view returns (address tokenAddress) {
406         tokenAddress = tokens[_tokenIndex];
407     }
408 
409     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
410         if (weights[_fromToken] > 0 && weights[_toToken] > 0 && _fromToken != _toToken) {
411             uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
412             uint256 toBalance = ERC20(_toToken).balanceOf(this);
413             returnAmount = toBalance.mul(_amount).mul(weights[_fromToken]).div(weights[_toToken]).div(fromBalance.add(_amount));
414         }
415     }
416 
417     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
418         returnAmount = getReturn(_fromToken, _toToken, _amount);
419         require(returnAmount > 0, "The return amount is zero");
420         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
421         
422         uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
423         ERC20(_fromToken).transferFrom(msg.sender, this, _amount);
424         require(ERC20(_fromToken).balanceOf(this) == fromBalance + _amount);
425         
426         uint256 toBalance = ERC20(_toToken).balanceOf(this);
427         ERC20(_toToken).transfer(msg.sender, returnAmount);
428         require(ERC20(_toToken).balanceOf(this) == toBalance - returnAmount);
429 
430         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
431     }
432 
433     function changeOverERC228(address _fromToken, address _toToken, uint256 _amount, address exchange) public returns(uint256 returnAmount) {
434         returnAmount = getReturn(_fromToken, _toToken, _amount);
435         require(returnAmount > 0, "The return amount is zero");
436 
437         uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
438         ERC20(_toToken).approve(exchange, returnAmount);
439         ERC228(exchange).change(_toToken, _fromToken, returnAmount, _amount);
440         uint256 realReturnAmount = ERC20(_fromToken).balanceOf(this).sub(fromBalance);
441         require(realReturnAmount >= _amount);
442 
443         if (realReturnAmount > _amount) {
444             uint256 reward = realReturnAmount.sub(_amount);
445             ERC20(_fromToken).transfer(msg.sender, reward); // Arbiter reward
446             require(ERC20(_fromToken).balanceOf(this) == fromBalance.add(_amount));
447         }
448 
449         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
450     }
451 
452     function allWeights() public view returns(uint256[]) {
453         uint256[] memory result = new uint256[](tokens.length);
454         for (uint i = 0; i < tokens.length; i++) {
455             result[i] = weights[tokens[i]];
456         }
457         return result;
458     }
459 
460 }
461 
462 // File: contracts/FeeMultiToken.sol
463 
464 contract FeeMultiToken is MultiToken {
465     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
466         super.init(_tokens, _weights, _name, _symbol, 18);
467     }
468 
469     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
470         returnAmount = super.getReturn(_fromToken, _toToken, _amount).mul(998).div(1000); // 0.2% exchange fee
471     }
472 }
473 
474 // File: contracts/registry/IDeployer.sol
475 
476 interface IDeployer {
477     function deploy(bytes data) external returns(address mtkn);
478 }
479 
480 // File: contracts/registry/MultiTokenDeployer.sol
481 
482 contract MultiTokenDeployer is IDeployer {
483     function deploy(bytes data) external returns(address mtkn) {
484         require(
485             // init(address[],uint256[],string,string,uint8)
486             (data[0] == 0x6f && data[1] == 0x5f && data[2] == 0x53 && data[3] == 0x5d) ||
487             // init2(address[],uint256[],string,string,uint8)
488             (data[0] == 0x18 && data[1] == 0x2a && data[2] == 0x54 && data[3] == 0x15)
489         );
490 
491         mtkn = new FeeMultiToken();
492         require(mtkn.call(data));
493     }
494 }