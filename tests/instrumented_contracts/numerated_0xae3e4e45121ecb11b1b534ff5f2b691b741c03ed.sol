1 pragma solidity ^0.4.11;
2 
3 
4 contract SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         return x <= y ? x : y;
30     }
31 }
32 
33 // contract ERC20 {
34 //     function totalSupply() constant returns (uint supply);
35 //     function balanceOf( address who ) constant returns (uint value);
36 //     function allowance( address owner, address spender ) constant returns (uint _allowance);
37 
38 //     function transfer( address to, uint value) returns (bool ok);
39 //     function transferFrom( address from, address to, uint value) returns (bool ok);
40 //     function approve( address spender, uint value ) returns (bool ok);
41 
42 //     event Transfer( address indexed from, address indexed to, uint value);
43 //     event Approval( address indexed owner, address indexed spender, uint value);
44 // }
45 
46 //https://github.com/ethereum/ethereum-org/blob/master/solidity/token-erc20.sol
47 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
48 contract TokenERC20 {
49     // Public variables of the token
50     string public name;
51     string public symbol;
52     uint8 public decimals = 18;
53     // 18 decimals is the strongly suggested default, avoid changing it
54     uint256 public totalSupply;
55 
56     // This creates an array with all balances
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     // This generates a public event on the blockchain that will notify clients
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     
63     // This generates a public event on the blockchain that will notify clients
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66     // This notifies clients about the amount burnt
67     event Burn(address indexed from, uint256 value);
68 
69     /**
70      * Constructor function
71      *
72      * Initializes contract with initial supply tokens to the creator of the contract
73      */
74     function TokenERC20(
75         uint256 initialSupply,
76         string tokenName,
77         string tokenSymbol
78     ) public {
79         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
80         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
81         name = tokenName;                                   // Set the name for display purposes
82         symbol = tokenSymbol;                               // Set the symbol for display purposes
83     }
84 
85     /**
86      * Internal transfer, only can be called by this contract
87      */
88     function _transfer(address _from, address _to, uint _value) internal {
89         // Prevent transfer to 0x0 address. Use burn() instead
90         require(_to != 0x0);
91         // Check if the sender has enough
92         require(balanceOf[_from] >= _value);
93         // Check for overflows
94         require(balanceOf[_to] + _value >= balanceOf[_to]);
95         // Save this for an assertion in the future
96         uint previousBalances = balanceOf[_from] + balanceOf[_to];
97         // Subtract from the sender
98         balanceOf[_from] -= _value;
99         // Add the same to the recipient
100         balanceOf[_to] += _value;
101         emit Transfer(_from, _to, _value);
102         // Asserts are used to use static analysis to find bugs in your code. They should never fail
103         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
104     }
105 
106     /**
107      * Transfer tokens
108      *
109      * Send `_value` tokens to `_to` from your account
110      *
111      * @param _to The address of the recipient
112      * @param _value the amount to send
113      */
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115         _transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Transfer tokens from other address
121      *
122      * Send `_value` tokens to `_to` on behalf of `_from`
123      *
124      * @param _from The address of the sender
125      * @param _to The address of the recipient
126      * @param _value the amount to send
127      */
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_value <= allowance[_from][msg.sender]);     // Check allowance
130         allowance[_from][msg.sender] -= _value;
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address
137      *
138      * Allows `_spender` to spend no more than `_value` tokens on your behalf
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      */
143     function approve(address _spender, uint256 _value) public
144         returns (bool success) {
145         allowance[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151      * Set allowance for other address and notify
152      *
153      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
154      *
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
160         public
161         returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, this, _extraData);
165             return true;
166         }
167     }
168 
169     /**
170      * Destroy tokens
171      *
172      * Remove `_value` tokens from the system irreversibly
173      *
174      * @param _value the amount of money to burn
175      */
176     function burn(uint256 _value) public returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
178         balanceOf[msg.sender] -= _value;            // Subtract from the sender
179         totalSupply -= _value;                      // Updates totalSupply
180         emit Burn(msg.sender, _value);
181         return true;
182     }
183 
184     /**
185      * Destroy tokens from other account
186      *
187      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
188      *
189      * @param _from the address of the sender
190      * @param _value the amount of money to burn
191      */
192     function burnFrom(address _from, uint256 _value) public returns (bool success) {
193         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
194         require(_value <= allowance[_from][msg.sender]);    // Check allowance
195         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
196         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
197         totalSupply -= _value;                              // Update totalSupply
198         emit Burn(_from, _value);
199         return true;
200     }
201 }
202 
203 contract Erc20Dist is SafeMath {
204     TokenERC20  public  _erc20token; //被操作的erc20代币
205 
206     address public _ownerDist;// 这个合约最高权限人，开始是创建者，可以移交给他人
207     uint256 public _distDay;//发布时间
208     uint256 public _mode = 0;//模型是1表示使用模式1，2表示使用模式2
209     uint256 public _lockAllAmount;//锁仓的总量
210 
211     struct Detail{//发放情况详情结构体声明
212         address founder;//创始人地址
213         uint256 lockDay;//锁仓时间
214         uint256 lockPercent;//锁仓百分比数（0到100之间）
215         uint256 distAmount;//总分配数量
216         uint256 lockAmount;//锁住的代币总量
217         uint256 initAmount;//初始款的代币量
218         uint256 distRate;//锁仓解锁后每天分配代币百分比数（按锁住的总额算，0到100之间）
219         uint256 oneDayTransferAmount;//锁仓解锁后每天应发放的代币数量
220         uint256 transferedAmount;//已转账代币数量
221         uint256 lastTransferDay;//最后一笔代币分配的时间
222         bool isFinish;// 是否本人都发放完成
223         bool isCancelDist;//是否同意撤销发行
224     }
225     Detail private detail = Detail(address(0),0,0,0,0,0,0,0,0,0, false, false);//中间变量初始化，用来在函数中临时承接计算结果，以便传送给_details
226     Detail[] public _details;//发放情况详情列表,并初始化为空值
227 	uint256 public _detailsLength = 0;//发放详情长度
228 
229     bool public _fDist = false;// 是否已经发布过的标识符号
230     bool public _fConfig = false;// 是否已经配置过的标识符号
231     bool public _fFinish = false;// 是否所有人都发放完成
232     bool public _fCancelDist = false;// 是否撤销发行
233     
234     function Erc20Dist() public {
235         _ownerDist = msg.sender; // 默认创建者为权限最高人
236     }
237 
238     function () public{}//callback函数，由于合约没有eth价值传入，所以没有什么安全问题
239 
240     // 设置合约所有者
241     function setOwner(address owner_) public {
242         require (msg.sender == _ownerDist, "you must _ownerDist");// 必须原来所有者授权
243         require(_fDist == false, "not dist"); // 必须还没开始发布
244         require(_fConfig == false, "not config");// 必须还没配置过
245         _ownerDist = owner_;
246     }
247     //设置操作代币函数
248     function setErc20(TokenERC20  erc20Token) public {
249         require (msg.sender == _ownerDist, "you must _ownerDist");
250         require(address(_erc20token) == address(0),"you have set erc20Token");//必须之前没有设置过
251         require(erc20Token.balanceOf(address(this)) > 0, "this contract must own tokens");
252         _erc20token = erc20Token;//在全局设置erc20代币
253         _lockAllAmount = erc20Token.balanceOf(address(this));
254     }
255 
256     // 撤销发行，必须所有参与人同意，才能撤销发行
257     function cancelDist() public {
258         require(_fDist == true, "must dist"); // 必须发布
259         require(_fCancelDist == false, "must not cancel dist");
260 
261         // 循环判断是否
262         for(uint256 i=0;i<_details.length;i++){
263             // 判断是否发行者
264             if ( _details[i].founder == msg.sender ) {
265                 // 设置标志
266                 _details[i].isCancelDist = true;
267                 break;
268             }
269         }
270         // 更新状态
271         updateCancelDistFlag();
272         if (_fCancelDist == true) {
273             require(_erc20token.balanceOf(address(this)) > 0, "must have balance");
274             // 返回所有代币给最高权限人
275             _erc20token.transfer(
276                 _ownerDist, 
277                 _erc20token.balanceOf(address(this))
278             );
279         }
280     }
281 
282     // 更新是否撤销发行标志
283     function updateCancelDistFlag() private {
284         bool allCancelDist = true;
285         for(uint256 i=0; i<_details.length; i++){
286             // 判断有没有人没撤销
287             if (_details[i].isCancelDist == false) {
288                 allCancelDist = false;
289                 break;
290             }
291         }
292         // 更新合约完成标志
293         _fCancelDist = allCancelDist;
294     }
295 
296     // 还没调用发行情况下，返还所有代币，到最高权限账号，并且清除配置
297     function clearConfig() public {
298         require (msg.sender == _ownerDist, "you must _ownerDist");
299         require(_fDist == false, "not dist"); // 必须还没开始发布
300         require(address(_erc20token) != address(0),"you must set erc20Token");//必须之前设置过
301         require(_erc20token.balanceOf(address(this)) > 0, "must have balance");
302         // 返回所有代币给最高权限人
303         _erc20token.transfer(
304             msg.sender, 
305             _erc20token.balanceOf(address(this))
306         );
307         // 清空变量
308         _lockAllAmount = 0;
309         TokenERC20  nullErc20token;
310         _erc20token = nullErc20token;
311         Detail[] nullDetails;
312         _details = nullDetails;
313         _detailsLength = 0;
314         _mode = 0;
315         _fConfig = false;
316     }
317 
318     // 客户之前多转到合约的币，可以通过这个接口，提取回最高权限人账号，但必须在合约执行完成之后
319     function withDraw() public {
320         require (msg.sender == _ownerDist, "you must _ownerDist");
321         require(_fFinish == true, "dist must be finished"); // 合约必须执行完毕
322         require(address(_erc20token) != address(0),"you must set erc20Token");//必须之前设置过
323         require(_erc20token.balanceOf(address(this)) > 0, "must have balance");
324         // 返回所有代币给最高权限人
325         _erc20token.transfer(
326             _ownerDist, 
327             _erc20token.balanceOf(address(this))
328         );
329     }
330 
331     //配置相关创始人及代币发放、锁仓信息等相关情况的函数。auth认证，必须是合约持有人才能进行该操作
332     function configContract(uint256 mode,address[] founders,uint256[] distWad18Amounts,uint256[] lockPercents,uint256[] lockDays,uint256[] distRates) public {
333     //函数变量说明：founders（创始人地址列表），
334     //distWad18Amounts（总发放数量列表（不输入18位小数位）），
335     //lockPercents（锁仓百分比列表（值在0到100之间）），
336     //lockDays（锁仓天数列表）,distRates（每天发放数占锁仓总数的万分比数列表（值在0到10000之间））
337         require (msg.sender == _ownerDist, "you must _ownerDist");
338         require(mode==1||mode==2,"there is only mode 1 or 2");//只有模式1和2两种申领余款方式
339         _mode = mode;//将申领方式注册到全局
340         require(_fConfig == false,"you have configured it already");//必须还未配置过
341         require(address(_erc20token) != address(0), "you must setErc20 first");//必须已经设置好被操作erc20代币
342         require(founders.length!=0,"array length can not be zero");//创始人列表不能为空
343         require(founders.length==distWad18Amounts.length,"founders length dismatch distWad18Amounts length");//创始人列表长度必须等于发放数量列表长度
344         require(distWad18Amounts.length==lockPercents.length,"distWad18Amounts length dismatch lockPercents length");//发放数量列表长度必须等于锁仓百分比列表长度
345         require(lockPercents.length==lockDays.length,"lockPercents length dismatch lockDays length");//锁仓百分比列表长度必须等于锁仓天数列表长度
346         require(lockDays.length==distRates.length,"lockDays length dismatch distRates length");//锁仓百分比列表长度必须等于每日发放比率列表长度
347 
348         //遍历
349         for(uint256 i=0;i<founders.length;i++){
350             require(distWad18Amounts[i]!=0,"dist token amount can not be zero");//确保发放数量不为0
351             for(uint256 j=0;j<i;j++){
352                 require(founders[i]!=founders[j],"you could not give the same address of founders");//必须确保创始人中没有地址相同的
353             }
354         }
355         
356 
357         //以下为循环中服务全局变量的中间临时变量
358         uint256 totalAmount = 0;//发放代币总量
359         uint256 distAmount = 0;//给当前创始人发放代币量（带18位精度）
360         uint256 oneDayTransferAmount = 0;//解锁后每天应发放的数量（将在后续进行计算）
361         uint256 lockAmount = 0;//当前创始人锁住的代币量
362         uint256 initAmount = 0;//当前创始人初始款代币量
363 
364         //遍历
365         for(uint256 k=0;k<lockPercents.length;k++){
366             require(lockPercents[k]<=100,"lockPercents unit must <= 100");//锁仓百分比数必须小于等于100
367             require(distRates[k]<=10000,"distRates unit must <= 10000");//发放万分比数必须小于等于10000
368             distAmount = mul(distWad18Amounts[k],10**18);//给当前创始人发放代币量（带18位精度）
369             totalAmount = add(totalAmount,distAmount);//发放总量累加
370             lockAmount = div(mul(lockPercents[k],distAmount),100);//锁住的代币数量
371             initAmount = sub(distAmount, lockAmount);//初始款的代币数量
372             oneDayTransferAmount = div(mul(distRates[k],lockAmount),10000);//解锁后每天应发放的数量
373 
374             //下面为中间变量detail的9个成员赋值
375             detail.founder = founders[k];
376             detail.lockDay = lockDays[k];
377             detail.lockPercent = lockPercents[k];
378             detail.distRate = distRates[k];
379             detail.distAmount = distAmount;
380             detail.lockAmount = lockAmount;
381             detail.initAmount = initAmount;
382             detail.oneDayTransferAmount = oneDayTransferAmount;
383             detail.transferedAmount = 0;//初始还未开始发放，所以已分配数量为0
384             detail.lastTransferDay = 0;//初始还未开始发放，最后的发放日设为0
385             detail.isFinish = false;
386             detail.isCancelDist = false;
387             //将赋好的中间信息压入全局信息列表_details
388             _details.push(detail);
389         }
390         require(totalAmount <= _lockAllAmount, "distributed total amount should be equal lock amount");// 发行总量应该等于锁仓总量
391         require(totalAmount <= _erc20token.totalSupply(),"distributed total amount should be less than token totalSupply");//发放的代币总量必须小于总代币量
392 		_detailsLength = _details.length;
393         _fConfig = true;//配置完毕，将配置完成标识符设为真
394         _fFinish = false;// 默认没发放完成
395         _fCancelDist = false;// 撤销发行清空
396     }
397 
398     //开始发放函数，将未锁仓头款发放给个创始人，如果有锁仓天数为0的，将锁款的解锁后的头天代币也一同发放。auth认证，必须是合约持有人才能进行该操作
399     function startDistribute() public {
400         require (msg.sender == _ownerDist, "you must _ownerDist");
401         require(_fDist == false,"you have distributed erc20token already");//必须还未初始发放过
402         require(_details.length != 0,"you have not configured");//必须还未配置过
403         _distDay = today();//将当前区块链系统时间记录为发放时间
404         uint256 initDistAmount=0;//以下循环中使用的当前创始人“初始发放代币量”临时变量
405 
406         for(uint256 i=0;i<_details.length;i++){
407             initDistAmount = _details[i].initAmount;//首发量
408 
409             if(_details[i].lockDay==0){//如果当前创始人锁仓天数为0
410                 initDistAmount = add(initDistAmount, _details[i].oneDayTransferAmount);//初始发放代币量为首发量+一天的发放量
411             }
412             _erc20token.transfer(
413                 _details[i].founder,
414                initDistAmount
415             );
416             _details[i].transferedAmount = initDistAmount;//已发放数量在全局细节中进行登记
417             _details[i].lastTransferDay =_distDay;//最新一次发放日期在全局细节中进行登记
418         }
419 
420         _fDist = true;//已初始发放标识符设为真
421         updateFinishFlag();// 更新下完成标志
422     }
423 
424     // 更新是否发行完成标志
425     function updateFinishFlag() private {
426         //
427         bool allFinish = true;
428         for(uint256 i=0; i<_details.length; i++){
429             // 不需要锁仓的，直接设置完成
430             if (_details[i].lockPercent == 0) {
431                 _details[i].isFinish = true;
432                 continue;
433             }
434             // 有锁仓的，发行数量等于解锁数量，也设置完成
435             if (_details[i].distAmount == _details[i].transferedAmount) {
436                 _details[i].isFinish = true;
437                 continue;
438             }
439             allFinish = false;
440         }
441         // 更新合约完成标志
442         _fFinish = allFinish;
443     }
444 
445     //模式1：任意人可调用该函数申领当天应发放额
446     function applyForTokenOneDay() public{
447         require(_mode == 1,"this function can be called only when _mode==1");//模式1下可调用
448         require(_distDay != 0,"you haven't distributed");//必须已经发布初始款了
449         require(_fFinish == false, "not finish");//必须合约还没执行完
450         require(_fCancelDist == false, "must not cancel dist");
451         uint256 daysAfterDist;//距离初始金发放时间
452         uint256 tday = today();//调用该函数时系统当前时间
453       
454         for(uint256 i=0;i<_details.length;i++){
455             // 对于已经完成的可以pass
456             if (_details[i].isFinish == true) {
457                 continue;
458             }
459 
460             require(tday!=_details[i].lastTransferDay,"you have applied for todays token");//必须今天还未申领
461             daysAfterDist = sub(tday,_distDay);//计算距离初始金发放时间天数
462             if(daysAfterDist >= _details[i].lockDay){//距离发放日天数要大于等于锁仓天数
463                 if(add(_details[i].transferedAmount, _details[i].oneDayTransferAmount) <= _details[i].distAmount){
464                 //如果当前创始人剩余的发放数量大于等于每天应发放数量，则将当天应发放数量发给他
465                     _erc20token.transfer(
466                         _details[i].founder,
467                         _details[i].oneDayTransferAmount
468                     );
469                     //已发放数量在全局细节中进行登记更新
470                     _details[i].transferedAmount = add(_details[i].transferedAmount, _details[i].oneDayTransferAmount);
471                 }
472                 else if(_details[i].transferedAmount < _details[i].distAmount){
473                 //否则，如果已发放数量未达到锁仓应发总量，则将当前创始人剩余的应发放代币都发放给他
474                     _erc20token.transfer(
475                         _details[i].founder,
476                         sub( _details[i].distAmount, _details[i].transferedAmount)
477                     );
478                     //已发放数量在全局细节中进行登记更新
479                     _details[i].transferedAmount = _details[i].distAmount;
480                 }
481                 //最新一次发放日期在全局细节中进行登记更新
482                 _details[i].lastTransferDay = tday;
483             }
484         }   
485         // 更新下完成标志
486         updateFinishFlag();
487     }
488 
489     ///模式2：任意人可调用该函数补领到当前时间应该拥有但未发的代币
490     function applyForToken() public {
491         require(_mode == 2,"this function can be called only when _mode==2");//模式2下可调用
492         require(_distDay != 0,"you haven't distributed");//必须已经发布初始款了
493         require(_fFinish == false, "not finish");//必须合约还没执行完
494         require(_fCancelDist == false, "must not cancel dist");
495         uint256 daysAfterDist;//距离初始金发放时间
496         uint256 expectAmount;//下面循环中当前创始人到今天为止应该被发放的数量
497         uint256 tday = today();//调用该函数时系统当前时间
498         uint256 expectReleaseTimesNoLimit = 0;//解锁后到今天为止应该放的尾款次数(不考虑已放完款的情况)
499 
500         for(uint256 i=0;i<_details.length;i++){
501             // 对于已经完成的可以pass
502             if (_details[i].isFinish == true) {
503                 continue;
504             }
505             //必须今天还未申领
506             require(tday!=_details[i].lastTransferDay,"you have applied for todays token");
507             daysAfterDist = sub(tday,_distDay);//计算距离初始金发放时间天数
508             if(daysAfterDist >= _details[i].lockDay){//距离发放日天数要大于等于锁仓天数
509                 expectReleaseTimesNoLimit = add(sub(daysAfterDist,_details[i].lockDay),1);//解锁后到今天为止应该放的尾款次数
510                 //到目前为止应该发放的总数=（（应该释放款的次数x每次应该释放的币数）+初始款数量）与 当前创始人应得总发放数量 中的较小值
511                 //因为释放款次数可能很大了，超过领完时间了
512                 expectAmount = min(add(mul(expectReleaseTimesNoLimit,_details[i].oneDayTransferAmount),_details[i].initAmount),_details[i].distAmount);
513 
514                 //将欠下的代币统统发放给当前创始人
515                 _erc20token.transfer(
516                     _details[i].founder,
517                     sub(expectAmount, _details[i].transferedAmount)
518                 );
519                 //已发放数量在全局细节中进行登记更新
520                 _details[i].transferedAmount = expectAmount;
521                 //最新一次发放日期在全局细节中进行登记更新
522                 _details[i].lastTransferDay = tday;
523             }
524         }
525         // 更新下完成标志
526         updateFinishFlag();
527     }
528 
529     //一天进行计算
530     function today() public constant returns (uint256) {
531         return div(time(), 24 hours);//24 hours 
532     }
533     
534     //获取当前系统时间
535     function time() public constant returns (uint256) {
536         return block.timestamp;
537     }
538  
539 }