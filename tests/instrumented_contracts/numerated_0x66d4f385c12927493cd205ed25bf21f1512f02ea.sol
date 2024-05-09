1 pragma solidity ^0.4.25;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  D:\Project\java\FanMei\src\main\solidity\FMC.sol
6 // flattened :  Wednesday, 09-Jan-19 14:12:44 UTC
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * See https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61   mapping(address => uint256) balances;
62   uint256 totalSupply_;
63   /**
64   * @dev Total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69   /**
70   * @dev Transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 }
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender)
97     public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value)
99     public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * https://github.com/ethereum/EIPs/issues/20
112  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, BasicToken {
115   mapping (address => mapping (address => uint256)) internal allowed;
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     emit Transfer(_from, _to, _value);
137     return true;
138   }
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     emit Approval(msg.sender, _spender, _value);
151     return true;
152   }
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(
160     address _owner,
161     address _spender
162    )
163     public
164     view
165     returns (uint256)
166   {
167     return allowed[_owner][_spender];
168   }
169   /**
170    * @dev Increase the amount of tokens that an owner allowed to a spender.
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param _spender The address which will spend the funds.
176    * @param _addedValue The amount of tokens to increase the allowance by.
177    */
178   function increaseApproval(
179     address _spender,
180     uint256 _addedValue
181   )
182     public
183     returns (bool)
184   {
185     allowed[msg.sender][_spender] = (
186       allowed[msg.sender][_spender].add(_addedValue));
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(
200     address _spender,
201     uint256 _subtractedValue
202   )
203     public
204     returns (bool)
205   {
206     uint256 oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 }
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   constructor() public {
229     owner = msg.sender;
230   }
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238   /**
239    * @dev Allows the current owner to transfer control of the contract to a newOwner.
240    * @param newOwner The address to transfer ownership to.
241    */
242   function transferOwnership(address newOwner) public onlyOwner {
243     require(newOwner != address(0));
244     emit OwnershipTransferred(owner, newOwner);
245     owner = newOwner;
246   }
247 }
248 contract FMC is StandardToken, Ownable {
249     using SafeMath for uint256;
250     string public constant name = "Fan Mei Chain (FMC)";
251     string public constant symbol = "FMC";
252     uint8 public constant decimals = 18;
253     //总配额2亿
254     uint256 constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
255     //设置代币官网短URL(32字节以内)，供管理平台自动查询
256     string public website = "www.fanmeichain.com";
257     //设置代币icon短URL(32字节以内)，供管理平台自动查询
258     string public icon = "/icon/fmc.png";
259     //冻结账户
260     address public frozenAddress;
261     //锁仓信息
262     mapping(address=>Info) internal fellowInfo;
263     // fellow info
264     struct Info{
265         uint256[] defrozenDates;                    //解冻日期
266         mapping(uint256=>uint256) frozenValues;     //冻结金额
267         uint256 totalFrozenValue;                   //全部冻结资产总额
268     }
269     // 事件定义
270     event Frozen(address user, uint256 value, uint256 defrozenDate, uint256 totalFrozenValue);
271     event Defrozen(address user, uint256 value, uint256 defrozenDate, uint256 totalFrozenValue);
272     // Constructor that gives msg.sender all of existing tokens.
273     constructor(address _frozenAddress) public {
274         require(_frozenAddress != address(0) && _frozenAddress != msg.sender);
275         frozenAddress = _frozenAddress;
276         totalSupply_ = INITIAL_SUPPLY;
277         balances[msg.sender] = INITIAL_SUPPLY;
278         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
279     }
280     /**
281    * @dev Transfer token for a specified address
282    * @param _to The address to transfer to.
283    * @param _value The amount to be transferred.
284    */
285     function transfer(address _to, uint256 _value) public returns (bool) {
286         require(_to != address(0));
287         require(_value <= balances[msg.sender]);
288         //normal transfer
289         balances[msg.sender] = balances[msg.sender].sub(_value);
290         balances[_to] = balances[_to].add(_value);
291         emit Transfer(msg.sender, _to, _value);
292         if(_to == frozenAddress){
293             //defrozing
294             Info storage _info = fellowInfo[msg.sender];
295             if(_info.totalFrozenValue > 0){
296                 for(uint i=0; i< _info.defrozenDates.length; i++){
297                     uint256 _date0 = _info.defrozenDates[i];
298                     if(_info.frozenValues[_date0] > 0 && now >= _date0){
299                         //defrozen...
300                         uint256 _defrozenValue = _info.frozenValues[_date0];
301                         require(balances[frozenAddress] >= _defrozenValue);
302                         balances[frozenAddress] = balances[frozenAddress].sub(_defrozenValue);
303                         balances[msg.sender] = balances[msg.sender].add(_defrozenValue);
304                         _info.totalFrozenValue = _info.totalFrozenValue.sub(_defrozenValue);
305                         _info.frozenValues[_date0] = 0;
306                         emit Transfer(frozenAddress, msg.sender, _defrozenValue);
307                         emit Defrozen(msg.sender, _defrozenValue, _date0, _info.totalFrozenValue);
308                     }
309                 }
310             }
311         }
312         return true;
313     }
314     // issue in batch with forzen
315     function issue(address[] payees, uint256[] values, uint16[] deferDays) public onlyOwner returns(bool) {
316         require(payees.length > 0 && payees.length == values.length);
317         uint256 _now0 = _getNow0();
318         for (uint i = 0; i<payees.length; i++) {
319             require(balances[owner] >= values[i], "Issuer balance is insufficient.");
320             //地址为空或者发行额度为零
321             if (payees[i] == address(0) || values[i] == uint256(0)) {
322                 continue;
323             }
324             balances[owner] = balances[owner].sub(values[i]);
325             balances[payees[i]] = balances[payees[i]].add(values[i]);
326             emit Transfer(owner, payees[i], values[i]);
327             uint256 _date0 = _now0.add(deferDays[i]*24*3600);
328             //判断是否需要冻结
329             if(_date0 > _now0){
330                 //frozen balance
331                 Info storage _info = fellowInfo[payees[i]];
332                 uint256 _fValue = _info.frozenValues[_date0];
333                 if(_fValue == 0){
334                     //_date0 doesn't exist in defrozenDates
335                     _info.defrozenDates.push(_date0);
336                 }
337                 //冻结总量增加_value
338                 _info.totalFrozenValue = _info.totalFrozenValue.add(values[i]);
339                 _info.frozenValues[_date0] = _info.frozenValues[_date0].add(values[i]);
340 
341                 balances[payees[i]] = balances[payees[i]].sub(values[i]);
342                 balances[frozenAddress] = balances[frozenAddress].add(values[i]);
343                 emit Transfer(payees[i], frozenAddress, values[i]);
344                 emit Frozen(payees[i], values[i], _date0, _info.totalFrozenValue);
345             }
346         }
347         return true;
348     }
349     // airdrop in with same value and deferDays
350     function airdrop(address[] payees, uint256 value, uint16 deferDays) public onlyOwner returns(bool) {
351         require(payees.length > 0 && value > 0);
352         uint256 _amount = value.mul(payees.length);
353         require(balances[owner] > _amount);
354         uint256 _now0 = _getNow0();
355         uint256 _date0 = _now0.add(deferDays*24*3600);
356         for (uint i = 0; i<payees.length; i++) {
357             require(balances[owner] >= value, "Issuer balance is insufficient.");
358             //地址为空或者发行额度为零
359             if (payees[i] == address(0)) {
360                 _amount = _amount.sub(value);
361                 continue;
362             }
363             //circulating
364             balances[payees[i]] = balances[payees[i]].add(value);
365             emit Transfer(owner, payees[i], value);
366             //判断是否需要冻结
367             if(_date0 > _now0){
368                 //frozen balance
369                 Info storage _info = fellowInfo[payees[i]];
370                 uint256 _fValue = _info.frozenValues[_date0];
371                 if(_fValue == 0){
372                     //_date0 doesn't exist in defrozenDates
373                     _info.defrozenDates.push(_date0);
374                 }
375                 //冻结总量增加_value
376                 _info.totalFrozenValue = _info.totalFrozenValue.add(value);
377                 _info.frozenValues[_date0] = _info.frozenValues[_date0].add(value);
378                 balances[payees[i]] = balances[payees[i]].sub(value);
379                 balances[frozenAddress] = balances[frozenAddress].add(value);
380                 emit Transfer(payees[i], frozenAddress, value);
381                 emit Frozen(payees[i], value, _date0, _info.totalFrozenValue);
382             }
383         }
384         balances[owner] = balances[owner].sub(_amount);
385         return true;
386     }
387     // update frozen address
388     function updateFrozenAddress(address newFrozenAddress) public onlyOwner returns(bool){
389         //要求：
390         //1. 新地址不能为空
391         //2. 新地址不能为owner
392         //3. 新地址不能与旧地址相同
393         require(newFrozenAddress != address(0) && newFrozenAddress != owner && newFrozenAddress != frozenAddress);
394         //要求：新地址账本为零
395         require(balances[newFrozenAddress] == 0);
396         //转移冻结账本
397         balances[newFrozenAddress] = balances[frozenAddress];
398         balances[frozenAddress] = 0;
399         emit Transfer(frozenAddress, newFrozenAddress, balances[newFrozenAddress]);
400         frozenAddress = newFrozenAddress;
401         return true;
402     }
403     //平台解冻指定资产
404     function defrozen(address fellow) public onlyOwner returns(bool){
405         require(fellow != address(0));
406         Info storage _info = fellowInfo[fellow];
407         require(_info.totalFrozenValue > 0);
408         for(uint i = 0; i< _info.defrozenDates.length; i++){
409             uint256 _date0 = _info.defrozenDates[i];
410             if(_info.frozenValues[_date0] > 0 && now >= _date0){
411                 //defrozen...
412                 uint256 _defrozenValue = _info.frozenValues[_date0];
413                 require(balances[frozenAddress] >= _defrozenValue);
414                 balances[frozenAddress] = balances[frozenAddress].sub(_defrozenValue);
415                 balances[fellow] = balances[fellow].add(_defrozenValue);
416                 _info.totalFrozenValue = _info.totalFrozenValue.sub(_defrozenValue);
417                 _info.frozenValues[_date0] = 0;
418                 emit Transfer(frozenAddress, fellow, _defrozenValue);
419                 emit Defrozen(fellow, _defrozenValue, _date0, _info.totalFrozenValue);
420             }
421         }
422         return true;
423     }
424     // check own assets include: balance, totalForzenValue, defrozenDates, defrozenValues
425     function getOwnAssets() public view returns(uint256, uint256, uint256[], uint256[]){
426         return getAssets(msg.sender);
427     }
428     // check own assets include: balance, totalForzenValue, defrozenDates, defrozenValues
429     function getAssets(address fellow) public view returns(uint256, uint256, uint256[], uint256[]){
430         uint256 _value = balances[fellow];
431         Info storage _info = fellowInfo[fellow];
432         uint256 _totalFrozenValue = _info.totalFrozenValue;
433         uint256 _size = _info.defrozenDates.length;
434         uint256[] memory _values = new uint256[](_size);
435         for(uint i = 0; i < _size; i++){
436             _values[i] = _info.frozenValues[_info.defrozenDates[i]];
437         }
438         return (_value, _totalFrozenValue, _info.defrozenDates, _values);
439     }
440     // 设置token官网和icon信息
441     function setWebInfo(string _website, string _icon) public onlyOwner returns(bool){
442         website = _website;
443         icon = _icon;
444         return true;
445     }
446     //返回当前区块链时间: 年月日时
447     function getNow() public view returns(uint256){
448         return now;
449     }
450     // @dev An internal pure function to calculate date in XX:00:00
451     function _calcDate0(uint256 _timestamp) internal pure returns(uint256){
452         return _timestamp.sub(_timestamp % (60*24));
453     }
454     // 获取当前日期零点时间戳
455     function _getNow0() internal view returns(uint256){
456         return _calcDate0(now);
457     }
458 }