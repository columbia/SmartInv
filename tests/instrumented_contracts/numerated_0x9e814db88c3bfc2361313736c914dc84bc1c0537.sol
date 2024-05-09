1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract IERC20{
51   function allowance(address owner, address spender) external view returns (uint);
52   function transferFrom(address from, address to, uint value) external returns (bool);
53   function approve(address spender, uint value) external returns (bool);
54   function totalSupply() external view returns (uint);
55   function balanceOf(address who) external view returns (uint);
56   function transfer(address to, uint value) external returns (bool);
57   
58   event Transfer(address indexed from, address indexed to, uint value);
59   event Approval(address indexed owner, address indexed spender, uint value);
60 }
61 
62 
63 contract IERC20Sec is IERC20 {
64   event ReleaseDividendsRights(address indexed _for, uint256 value);
65   event AcceptDividends(uint256 value);
66 
67   function dividendsRightsOf(address _owner) external view returns (uint balance);
68   function releaseDividendsRights(uint _value) external returns(bool);
69 }
70 
71 /**
72  * @title Standard ERC20 token
73  *
74  * @dev Implementation of the basic standard token.
75  * @dev https://github.com/ethereum/EIPs/issues/20
76  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract ERC20 is IERC20{
79   using SafeMath for uint;
80 
81   mapping(address => uint) internal balances;
82   mapping (address => mapping (address => uint)) internal allowed;
83 
84   uint internal totalSupply_;
85 
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() external view returns (uint) {
91     return totalSupply_;
92   }
93 
94   /**
95    * @dev Transfer tokens from one address to another
96    * @param _from address The address which you want to send tokens from
97    * @param _to address The address which you want to transfer to
98    * @param _value The amount of tokens to be transferred
99    */
100   function transfer_(address _from, address _to, uint _value) internal returns (bool) {
101     if(_from != _to) {
102       uint _bfrom = balances[_from];
103       uint _bto = balances[_to];
104       require(_to != address(0));
105       require(_value <= _bfrom);
106       balances[_from] = _bfrom.sub(_value);
107       balances[_to] = _bto.add(_value);
108     }
109     emit Transfer(_from, _to, _value);
110     return true;
111   }
112 
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint _value) external returns (bool) {
120     return transfer_(msg.sender, _to, _value);
121   }
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint _value) external returns (bool) {
130     uint _allowed = allowed[_from][msg.sender];
131     require(_value <= _allowed);
132     allowed[_from][msg.sender] = _allowed.sub(_value);
133     return transfer_(_from, _to, _value);
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) external view returns (uint balance) {
142     return balances[_owner];
143   }
144 
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint _value) external returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) external view returns (uint) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
183     uint _allowed = allowed[msg.sender][_spender];
184     _allowed = _allowed.add(_addedValue);
185     allowed[msg.sender][_spender] = _allowed;
186     emit Approval(msg.sender, _spender, _allowed);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
201     uint _allowed = allowed[msg.sender][_spender];
202     if (_subtractedValue > _allowed) {
203       _allowed = 0;
204     } else {
205       _allowed = _allowed.sub(_subtractedValue);
206     }
207     allowed[msg.sender][_spender] = _allowed;
208     emit Approval(msg.sender, _spender, _allowed);
209     return true;
210   }
211 
212 }
213 
214 contract ICassette {
215   uint8 constant CT_ETHER = 0x01;
216   uint8 constant CT_TOKEN = 0x02;
217   
218 
219   function getCassetteSize_() internal view returns(uint);
220   function acceptAbstractToken_(uint _value) internal returns(bool);
221   function releaseAbstractToken_(address _for, uint _value) internal returns(bool);
222   function getCassetteType_() internal pure returns(uint8);
223 
224 }
225 
226 
227 /**
228  * @title Standard token with dividends distribution support
229  */
230 contract ERC20Sec is IERC20, IERC20Sec, ERC20, ICassette {
231   using SafeMath for uint;
232 
233   uint constant DECIMAL_MULTIPLIER = 10 ** 18;
234   uint constant INT256_MAX = 1 << 255 - 1;
235 
236   mapping (address => uint) internal dividendsRightsFix;
237   uint internal dividendsPerToken;
238 
239   /**
240   * @dev Gets the dividends rights of the specified address.
241   * @param _owner The address to query the the balance of.
242   * @return An uint representing the amount of dividends rights owned by the passed address.
243   */
244   function dividendsRightsOf(address _owner) external view returns (uint) {
245     return dividendsRightsOf_(_owner);
246   }
247 
248   function dividendsRightsOf_(address _owner) internal view returns (uint) {
249     uint rights = dividendsPerToken * balances[_owner] / DECIMAL_MULTIPLIER + dividendsRightsFix[_owner];
250     return int(rights) < 0 ? 0 : rights;
251   }
252 
253 
254   /**
255   * @dev release dividends rights
256   * @param _value The amount of dividends to be transferred.
257   * @param _for The address to transfer for.
258   */
259   function releaseDividendsRights_(address _for, uint _value) internal returns(bool) {
260     uint _dividendsRights = dividendsRightsOf_(_for);
261     require(_dividendsRights >= _value);
262     dividendsRightsFix[_for] -= _value;
263     releaseAbstractToken_(_for, _value);
264     emit ReleaseDividendsRights(_for, _value);
265     return true;
266   }
267 
268 
269   /**
270   * @dev release dividends rights
271   * @param _value The amount of dividends to be transferred.
272   */
273   function releaseDividendsRights(uint _value) external returns(bool) {
274     return releaseDividendsRights_(msg.sender, _value);
275   }
276 
277 
278   /**
279    * @dev Update dividends rights fix
280    * @param _from address The address which you want to send tokens from
281    * @param _to address The address which you want to transfer to
282    * @param _value uint the amount of tokens to be transferred
283    */
284   function dividendsRightsFixUpdate_(address _from, address _to, uint _value) private {
285     if (_from != _to) {
286       uint _dividendsPerToken = dividendsPerToken;
287       uint _balanceFrom = balances[_from];
288       uint _balanceTo = balances[_to];
289       dividendsRightsFix[_from] += _dividendsPerToken * _balanceFrom / DECIMAL_MULTIPLIER - 
290         _dividendsPerToken * (_balanceFrom - _value) / DECIMAL_MULTIPLIER;
291       dividendsRightsFix[_to] += _dividendsPerToken * _balanceTo / DECIMAL_MULTIPLIER - 
292         _dividendsPerToken * (_balanceTo + _value) / DECIMAL_MULTIPLIER; 
293     }
294   }
295 
296   /**
297   * @dev transfer token for a specified address
298   * @param _to The address to transfer to.
299   * @param _value The amount to be transferred.
300   */
301   function transfer(address _to, uint _value) external returns (bool) {
302     dividendsRightsFixUpdate_(msg.sender, _to, _value);
303     return transfer_(msg.sender, _to, _value);
304   }
305 
306 
307   /**
308    * @dev Transfer tokens from one address to another
309    * @param _from address The address which you want to send tokens from
310    * @param _to address The address which you want to transfer to
311    * @param _value uint the amount of tokens to be transferred
312    */
313   function transferFrom(address _from, address _to, uint _value) external returns (bool) {
314     uint _allowed = allowed[_from][msg.sender];
315     require(_value <= _allowed);
316     allowed[_from][msg.sender] = _allowed.sub(_value);
317     dividendsRightsFixUpdate_(_from, _to, _value);
318     return transfer_(_from, _to, _value);
319   }
320 
321 
322 
323   function () public payable {
324     releaseDividendsRights_(msg.sender, dividendsRightsOf_(msg.sender));
325     if(msg.value > 0){
326       msg.sender.transfer(msg.value);
327     }
328   }
329 
330   /**
331    * @dev Accept dividends in ether
332    */
333 
334   function acceptDividends(uint _tvalue) public payable {
335     uint _value;
336     if(getCassetteType_()==CT_ETHER) {
337       _value = msg.value;
338     } else if (getCassetteType_()==CT_TOKEN) {
339       _value = _tvalue;
340       require(acceptAbstractToken_(_value));
341     } else revert();
342     uint _dividendsPerToken = dividendsPerToken;
343     uint _totalSupply = totalSupply_;
344     require(_totalSupply > 0);
345     _dividendsPerToken = _dividendsPerToken.add(_value.mul(DECIMAL_MULTIPLIER)/_totalSupply);
346     require(_dividendsPerToken.mul(_totalSupply) <= INT256_MAX);
347     dividendsPerToken = _dividendsPerToken;
348     emit AcceptDividends(_value);
349   }
350 }
351 
352 
353 contract MultiOwnable{
354 
355   mapping(address => bool) public owners;
356   uint internal ownersLength_;
357 
358   modifier onlyOwner() {
359     require(owners[msg.sender]);
360     _;
361   }
362   
363   event AddOwner(address indexed sender, address indexed owner);
364   event RemoveOwner(address indexed sender, address indexed owner);
365 
366   function addOwner_(address _for) internal returns(bool) {
367     if(!owners[_for]) {
368       ownersLength_ += 1;
369       owners[_for] = true;
370       emit AddOwner(msg.sender, _for);
371       return true;
372     }
373     return false;
374   }
375 
376   function addOwner(address _for) onlyOwner external returns(bool) {
377     return addOwner_(_for);
378   }
379 
380   function removeOwner_(address _for) internal returns(bool) {
381     if((owners[_for]) && (ownersLength_ > 1)){
382       ownersLength_ -= 1;
383       owners[_for] = false;
384       emit RemoveOwner(msg.sender, _for);
385       return true;
386     }
387     return false;
388   }
389 
390   function removeOwner(address _for) onlyOwner external returns(bool) {
391     return removeOwner_(_for);
392   }
393 
394 }
395 
396 
397 contract EtherCassette is ICassette {
398   function getCassetteSize_() internal view returns(uint) {
399     return address(this).balance;
400   }
401 
402   function acceptAbstractToken_(uint _value) internal returns(bool){
403     return true;
404   }
405   function releaseAbstractToken_(address _for, uint _value) internal returns(bool){
406     _for.transfer(_value);
407     return true;
408   }
409 
410   function getCassetteType_() internal pure returns(uint8){
411     return CT_ETHER;
412   }
413 
414 }
415 
416 contract TechHives is ERC20Sec, EtherCassette, MultiOwnable {
417   using SafeMath for uint;
418   uint constant DECIMAL_MULTIPLIER = 10 ** 18;
419   string public name = "TechHives";
420   string public symbol = "THV";
421   uint8 public decimals = 18;
422 
423   uint mintSupply_;
424 
425   /**
426   * @dev release dividends rights for a specified address
427   * @param _for The address to transfer for.
428   * @param _value The amount of dividends to be transferred.
429   */
430   function releaseDividendsRightsForce(address _for, uint _value) external onlyOwner returns(bool) {
431     return releaseDividendsRights_(_for, _value);
432   }
433 
434   function dividendsRightsFixUpdate_(address _for, uint _value) private {
435     uint _dividendsPerToken = dividendsPerToken;
436     uint _balanceFor = balances[_for];
437     dividendsRightsFix[_for] += _dividendsPerToken * _balanceFor / DECIMAL_MULTIPLIER - 
438       _dividendsPerToken * (_balanceFor + _value) / DECIMAL_MULTIPLIER; 
439   }
440   
441   function mint_(address _for, uint _value) internal returns(bool) {
442     require (mintSupply_ >= _value);
443     dividendsRightsFixUpdate_(_for, _value);
444     mintSupply_ = mintSupply_.sub(_value);
445     balances[_for] = balances[_for].add(_value);
446     totalSupply_ = totalSupply_.add(_value);
447     emit Transfer(address(0), _for, _value);
448     return true;
449   }
450 
451   function mint(address _for, uint _value) external onlyOwner returns(bool) {
452     return mint_(_for, _value);
453   }
454   
455   
456   function mintSupply() external view returns(uint) {
457       return mintSupply_;
458   }
459 
460   constructor() public {
461     mintSupply_ = 25000 * DECIMAL_MULTIPLIER;
462     addOwner_(0x47FC2e245b983A92EB3359F06E31F34B107B6EF6);
463     mint_(0x47FC2e245b983A92EB3359F06E31F34B107B6EF6, 10000e18);
464     addOwner_(msg.sender);
465   }
466 }