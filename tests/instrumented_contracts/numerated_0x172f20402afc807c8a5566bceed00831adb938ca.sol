1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52   event OwnershipRenounced(address indexed previousOwner);
53   event OwnershipTransferred(
54     address indexed previousOwner,
55     address indexed newOwner
56   );
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
75    * @dev Allows the current owner to relinquish control of the contract.
76    * @notice Renouncing to ownership will leave the contract without an owner.
77    * It will not be possible to call the functions with the `onlyOwner`
78    * modifier anymore.
79    */
80   function renounceOwnership() public onlyOwner {
81     emit OwnershipRenounced(owner);
82     owner = address(0);
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address _newOwner) public onlyOwner {
90     _transferOwnership(_newOwner);
91   }
92 
93   /**
94    * @dev Transfers control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function _transferOwnership(address _newOwner) internal {
98     require(_newOwner != address(0));
99     emit OwnershipTransferred(owner, _newOwner);
100     owner = _newOwner;
101   }
102 }
103 
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address _who) public view returns (uint256);
107   function transfer(address _to, uint256 _value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 contract ERC20 is ERC20Basic {
112   function allowance(address _owner, address _spender)
113     public view returns (uint256);
114 
115   function transferFrom(address _from, address _to, uint256 _value)
116     public returns (bool);
117 
118   function approve(address _spender, uint256 _value) public returns (bool);
119   event Approval(
120     address indexed owner,
121     address indexed spender,
122     uint256 value
123   );
124 }
125 
126 library SafeERC20 {
127   function safeTransfer(
128     ERC20Basic _token,
129     address _to,
130     uint256 _value
131   )
132     internal
133   {
134     require(_token.transfer(_to, _value));
135   }
136 
137   function safeTransferFrom(
138     ERC20 _token,
139     address _from,
140     address _to,
141     uint256 _value
142   )
143     internal
144   {
145     require(_token.transferFrom(_from, _to, _value));
146   }
147 
148   function safeApprove(
149     ERC20 _token,
150     address _spender,
151     uint256 _value
152   )
153     internal
154   {
155     require(_token.approve(_spender, _value));
156   }
157 }
158 
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) internal balances;
163 
164   uint256 internal totalSupply_;
165 
166   /**
167   * @dev Total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev Transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_value <= balances[msg.sender]);
180     require(_to != address(0));
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(
211     address _from,
212     address _to,
213     uint256 _value
214   )
215     public
216     returns (bool)
217   {
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220     require(_to != address(0));
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address _owner,
252     address _spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint256 _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint256 _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint256 oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue >= oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 
312 contract MintableToken is StandardToken, Ownable {
313   event Mint(address indexed to, uint256 amount);
314   event MintFinished();
315 
316   bool public mintingFinished = false;
317 
318 
319   modifier canMint() {
320     require(!mintingFinished);
321     _;
322   }
323 
324   modifier hasMintPermission() {
325     require(msg.sender == owner);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param _to The address that will receive the minted tokens.
332    * @param _amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335   function mint(
336     address _to,
337     uint256 _amount
338   )
339     public
340     hasMintPermission
341     canMint
342     returns (bool)
343   {
344     totalSupply_ = totalSupply_.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     emit Mint(_to, _amount);
347     emit Transfer(address(0), _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() public onlyOwner canMint returns (bool) {
356     mintingFinished = true;
357     emit MintFinished();
358     return true;
359   }
360 }
361 
362 contract CappedToken is MintableToken {
363 
364   uint256 public cap;
365 
366   constructor(uint256 _cap) public {
367     require(_cap > 0);
368     cap = _cap;
369   }
370 
371   /**
372    * @dev Function to mint tokens
373    * @param _to The address that will receive the minted tokens.
374    * @param _amount The amount of tokens to mint.
375    * @return A boolean that indicates if the operation was successful.
376    */
377   function mint(
378     address _to,
379     uint256 _amount
380   )
381     public
382     returns (bool)
383   {
384     require(totalSupply_.add(_amount) <= cap);
385 
386     return super.mint(_to, _amount);
387   }
388 
389 }
390 
391 contract TokenRecoverable is Ownable {
392     using SafeERC20 for ERC20Basic;
393 
394     function recoverTokens(ERC20Basic token, address to, uint256 amount) public onlyOwner {
395         uint256 balance = token.balanceOf(address(this));
396         require(balance >= amount);
397         token.safeTransfer(to, amount);
398     }
399 }
400 
401 contract WarfieldToken is CappedToken, TokenRecoverable {
402     uint256 internal constant TOTAL_TOKENS = 2571428571e18; // 2,571,428,571 tokens 
403 
404     string public constant name = "GOLDER COIN";
405     string public constant symbol = "GLDR";
406     uint8 public constant decimals = 18;
407 
408     address public tokenMinter;
409 
410     modifier canTransfer() {
411         require(mintingFinished, "Cannot transfer until minting is not finished");
412         _;
413     }
414 
415     modifier hasMintPermission() {
416         require(msg.sender == owner || msg.sender == tokenMinter, "Only owner or token minter can mint tokens");
417         _;
418     }
419 
420     constructor() public CappedToken(TOTAL_TOKENS) {
421     }
422 
423     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
424         require(_to != address(this), "Tokens cannot be sent to token contract address");
425         return super.transfer(_to, _value);
426     }
427 
428     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
429         require(_to != address(this), "Tokens cannot be sent to token contract address");
430         return super.transferFrom(_from, _to, _value);
431     }
432 
433     function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool) {
434         require(_to != address(0), "Token receiver must not be address(0)");
435         return super.mint(_to, _amount);
436     }
437 
438     function mintTokens(address[] _receivers, uint256[] _amounts) external hasMintPermission canMint returns (bool) {
439         require(_receivers.length > 0 && _receivers.length <= 100, "Receivers count must be in [1, 100] range");
440         require(_receivers.length == _amounts.length, "Receivers and amount count must be equal");
441 
442         for (uint256 i = 0; i < _receivers.length; i++) {
443             mint(_receivers[i], _amounts[i]);
444         }
445         return true;
446     }
447 
448     function setTokenMinter(address _tokenMinter) public onlyOwner {
449         require(_tokenMinter != address(0), "Token minter cannot be set to address(0)");
450         tokenMinter = _tokenMinter;
451     }
452 }