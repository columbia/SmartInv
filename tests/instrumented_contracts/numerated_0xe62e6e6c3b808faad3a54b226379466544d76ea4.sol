1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 contract Alchemy {
25     using SafeMath for uint256;
26 
27     // 代币的公共变量：名称、代号、小数点后面的位数、代币发行总量
28     string public name;
29     string public symbol;
30     uint8 public decimals = 6; // 官方建议18位
31     uint256 public totalSupply;
32     address public owner;
33 
34     address[] public ownerContracts;// 允许调用的智能合约
35     address public userPool;
36     address public platformPool;
37     address public smPool;
38 
39     //  燃烧池配置
40     mapping(string => address) burnPoolAddreses;
41 
42     // 代币余额的数据
43     mapping (address => uint256) public balanceOf;
44     // 代付金额限制
45     // 比如map[A][B]=60，意思是用户B可以使用A的钱进行消费，使用上限是60，此条数据由A来设置，一般B可以使中间担保平台
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     // 交易成功事件，会通知给客户端
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     // 交易ETH成功事件，会通知给客户端
52     event TransferETH(address indexed from, address indexed to, uint256 value);
53 
54     // 将销毁的代币量通知给客户端
55     event Burn(address indexed from, uint256 value);
56 
57     /**
58      * 构造函数
59      * 初始化代币发行的参数
60      */
61     //990000000,"AlchemyChain","ALC"
62     constructor(
63         uint256 initialSupply,
64         string tokenName,
65         string tokenSymbol
66     ) payable public  {
67         totalSupply = initialSupply * 10 ** uint256(decimals);  // 计算发行量
68         balanceOf[msg.sender] = totalSupply;                // 将发行的币给创建者
69         name = tokenName;                                   // 设置代币名称
70         symbol = tokenSymbol;                               // 设置代币符号
71         owner = msg.sender;
72     }
73 
74     // 修改器
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     //查询当前的以以太余额
81     function getETHBalance() view public returns(uint){
82         return address(this).balance;
83     }
84 
85     //批量平分以太余额
86     function transferETH(address[] _tos) public onlyOwner returns (bool) {
87         require(_tos.length > 0);
88         require(address(this).balance > 0);
89         for(uint32 i=0;i<_tos.length;i++){
90             _tos[i].transfer(address(this).balance/_tos.length);
91             emit TransferETH(owner, _tos[i], address(this).balance/_tos.length);
92         }
93         return true;
94     }
95 
96     //直接转账指定数量
97     function transferETH(address _to, uint256 _value) payable public onlyOwner returns (bool){
98         require(_value > 0);
99         require(address(this).balance >= _value);
100         require(_to != address(0));
101         _to.transfer(_value);
102         emit TransferETH(owner, _to, _value);
103         return true;
104     }
105 
106     //直接转账全部数量
107     function transferETH(address _to) payable public onlyOwner returns (bool){
108         require(_to != address(0));
109         require(address(this).balance > 0);
110         _to.transfer(address(this).balance);
111         emit TransferETH(owner, _to, address(this).balance);
112         return true;
113     }
114 
115     //直接转账全部数量
116     function transferETH() payable public onlyOwner returns (bool){
117         require(address(this).balance > 0);
118         owner.transfer(address(this).balance);
119         emit TransferETH(owner, owner, address(this).balance);
120         return true;
121     }
122 
123     // 接收以太
124     function () payable public {
125         // 其他逻
126     }
127 
128     // 众筹
129     function funding() payable public returns (bool) {
130         require(msg.value <= balanceOf[owner]);
131         // SafeMath.sub will throw if there is not enough balance.
132         balanceOf[owner] = balanceOf[owner].sub(msg.value);
133         balanceOf[tx.origin] = balanceOf[tx.origin].add(msg.value);
134         emit Transfer(owner, tx.origin, msg.value);
135         return true;
136     }
137 
138     function _contains() internal view returns (bool) {
139         for(uint i = 0; i < ownerContracts.length; i++){
140             if(ownerContracts[i] == msg.sender){
141                 return true;
142             }
143         }
144         return false;
145     }
146 
147     function setOwnerContracts(address _adr) public onlyOwner {
148         if(_adr != 0x0){
149             ownerContracts.push(_adr);
150         }
151     }
152 
153     //修改管理帐号
154     function transferOwnership(address _newOwner) public onlyOwner {
155         if (_newOwner != address(0)) {
156             owner = _newOwner;
157         }
158     }
159 
160     /**
161      * 内部转账，只能被本合约调用
162      */
163     function _transfer(address _from, address _to, uint _value) internal {
164         require(userPool != 0x0);
165         require(platformPool != 0x0);
166         require(smPool != 0x0);
167         // 检测是否空地址
168         require(_to != 0x0);
169         // 检测余额是否充足
170         require(_value > 0);
171         require(balanceOf[_from] >= _value);
172         // 检测溢出
173         require(balanceOf[_to] + _value >= balanceOf[_to]);
174         // 保存一个临时变量，用于最后检测值是否溢出
175         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
176         // 出账
177         balanceOf[_from] = balanceOf[_from].sub(_value);
178         uint256 burnTotal = 0;
179         uint256 platformToal = 0;
180         // 入账如果接受方是智能合约地址，则直接销毁
181         if (this == _to) {
182             //totalSupply -= _value;                      // 从发行的币中删除
183             burnTotal = _value*3;
184             platformToal = burnTotal.mul(15).div(100);
185             require(balanceOf[owner] >= (burnTotal + platformToal));
186             balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
187             balanceOf[platformPool] = balanceOf[platformPool].add(platformToal);
188             balanceOf[owner] -= (burnTotal + platformToal);
189             emit Transfer(_from, _to, _value);
190             emit Transfer(owner, userPool, burnTotal);
191             emit Transfer(owner, platformPool, platformToal);
192             emit Burn(_from, _value);
193         } else if (smPool == _from) {//私募方代用户投入燃烧数量代币
194             address smBurnAddress = burnPoolAddreses["smBurn"];
195             require(smBurnAddress != 0x0);
196             burnTotal = _value*3;
197             platformToal = burnTotal.mul(15).div(100);
198             require(balanceOf[owner] >= (burnTotal + platformToal));
199             balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
200             balanceOf[platformPool] = balanceOf[platformPool].add(platformToal);
201             balanceOf[owner] -= (burnTotal + platformToal);
202             emit Transfer(_from, _to, _value);
203             emit Transfer(_to, smBurnAddress, _value);
204             emit Transfer(owner, userPool, burnTotal);
205             emit Transfer(owner, platformPool, platformToal);
206             emit Burn(_to, _value);
207         } else {
208             address appBurnAddress = burnPoolAddreses["appBurn"];
209             address webBurnAddress = burnPoolAddreses["webBurn"];
210             address normalBurnAddress = burnPoolAddreses["normalBurn"];
211             //燃烧转帐特殊处理
212             if (_to == appBurnAddress || _to == webBurnAddress || _to == normalBurnAddress) {
213                 burnTotal = _value*3;
214                 platformToal = burnTotal.mul(15).div(100);
215                 require(balanceOf[owner] >= (burnTotal + platformToal));
216                 balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
217                 balanceOf[platformPool] = balanceOf[platformPool].add(platformToal);
218                 balanceOf[owner] -= (burnTotal + platformToal);
219                 emit Transfer(_from, _to, _value);
220                 emit Transfer(owner, userPool, burnTotal);
221                 emit Transfer(owner, platformPool, platformToal);
222                 emit Burn(_from, _value);
223             } else {
224                 balanceOf[_to] = balanceOf[_to].add(_value);
225                 emit Transfer(_from, _to, _value);
226                 // 检测值是否溢出，或者有数据计算错误
227                 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
228             }
229 
230         }
231     }
232 
233     /**
234      * 代币转账
235      * 从自己的账户上给别人转账
236      * @param _to 转入账户
237      * @param _value 转账金额
238      */
239     function transfer(address _to, uint256 _value) public {
240         _transfer(msg.sender, _to, _value);
241     }
242 
243     /**
244      * 代币转账
245      * 从自己的账户上给别人转账
246      * @param _to 转入账户
247      * @param _value 转账金额
248      */
249     function transferTo(address _to, uint256 _value) public {
250         require(_contains());
251         _transfer(tx.origin, _to, _value);
252     }
253 
254     /**
255      * 从其他账户转账
256      * 从其他的账户上给别人转账
257      * @param _from 转出账户
258      * @param _to 转入账户
259      * @param _value 转账金额
260      */
261     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
262         require(_value <= allowance[_from][msg.sender]);     // 检查允许交易的金额
263         allowance[_from][msg.sender] -= _value;
264         _transfer(_from, _to, _value);
265         return true;
266     }
267 
268     /**
269      * 设置代付金额限制
270      * 允许消费者使用的代币金额
271      * @param _spender 允许代付的账号
272      * @param _value 允许代付的金额
273      */
274     function approve(address _spender, uint256 _value) public
275     returns (bool success) {
276         allowance[msg.sender][_spender] = _value;
277         return true;
278     }
279 
280     /**
281      * 设置代付金额限制并通知对方（合约）
282      * 设置代付金额限制
283      * @param _spender 允许代付的账号
284      * @param _value 允许代付的金额
285      * @param _extraData 回执数据
286      */
287     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
288     public
289     returns (bool success) {
290         tokenRecipient spender = tokenRecipient(_spender);
291         if (approve(_spender, _value)) {
292             spender.receiveApproval(msg.sender, _value, this, _extraData);
293             return true;
294         }
295     }
296 
297     /**
298      * 销毁自己的代币
299      * 从系统中销毁代币
300      * @param _value 销毁量
301      */
302     function burn(uint256 _value) public returns (bool) {
303         require(balanceOf[msg.sender] >= _value);   // 检测余额是否充足
304         balanceOf[msg.sender] -= _value;            // 销毁代币
305         totalSupply -= _value;                      // 从发行的币中删除
306         emit Burn(msg.sender, _value);
307         return true;
308     }
309 
310     /**
311      * 销毁别人的代币
312      * 从系统中销毁代币
313      * @param _from 销毁的地址
314      * @param _value 销毁量
315      */
316     function burnFrom(address _from, uint256 _value) public returns (bool) {
317         require(balanceOf[_from] >= _value);                // 检测余额是否充足
318         require(_value <= allowance[_from][msg.sender]);    // 检测代付额度
319         balanceOf[_from] -= _value;                         // 销毁代币
320         allowance[_from][msg.sender] -= _value;             // 销毁额度
321         totalSupply -= _value;                              // 从发行的币中删除
322         emit Burn(_from, _value);
323         return true;
324     }
325 
326     /**
327      * 批量转账
328      * 从自己的账户上给别人转账
329      * @param _to 转入账户
330      * @param _value 转账金额
331      */
332     function transferArray(address[] _to, uint256[] _value) public {
333         require(_to.length == _value.length);
334         uint256 sum = 0;
335         for(uint256 i = 0; i< _value.length; i++) {
336             sum += _value[i];
337         }
338         require(balanceOf[msg.sender] >= sum);
339         for(uint256 k = 0; k < _to.length; k++){
340             _transfer(msg.sender, _to[k], _value[k]);
341         }
342     }
343 
344     /**
345      * 设置炼金池，平台收益池地址
346      */
347     function setUserPoolAddress(address _userPoolAddress, address _platformPoolAddress, address _smPoolAddress) public onlyOwner {
348         require(_userPoolAddress != 0x0);
349         require(_platformPoolAddress != 0x0);
350         require(_smPoolAddress != 0x0);
351         userPool = _userPoolAddress;
352         platformPool = _platformPoolAddress;
353         smPool = _smPoolAddress;
354     }
355 
356     /**
357      * 设置燃烧池地址,key为smBurn,appBurn,webBurn,normalBurn
358      */
359     function setBurnPoolAddress(string key, address _burnPoolAddress) public onlyOwner {
360         if (_burnPoolAddress != 0x0)
361         burnPoolAddreses[key] = _burnPoolAddress;
362     }
363 
364     /**
365      *  获取燃烧池地址,key为smBurn,appBurn,webBurn,normalBurn
366      */
367     function  getBurnPoolAddress(string key) public view returns (address) {
368         return burnPoolAddreses[key];
369     }
370 
371     /**
372      * 私募转帐特殊处理
373      */
374     function smTransfer(address _to, uint256 _value) public returns (bool)  {
375         require(smPool == msg.sender);
376         _transfer(msg.sender, _to, _value);
377         return true;
378     }
379 
380     /**
381      * 燃烧转帐特殊处理
382      */
383     function burnTransfer(address _from, uint256 _value, string key) public returns (bool)  {
384         require(burnPoolAddreses[key] != 0x0);
385         _transfer(_from, burnPoolAddreses[key], _value);
386         return true;
387     }
388 
389 }