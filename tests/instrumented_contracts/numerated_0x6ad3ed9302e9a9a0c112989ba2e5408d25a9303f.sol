1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'imChat' token contract
5 //
6 // Symbol      : IMC
7 // Name        : IMC
8 // Total supply: 1000,000,000.000000000000000000
9 // Decimals    : 8
10 //
11 // imChat Technology Service Limited
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     
20     /**
21     * @dev Adds two numbers, reverts on overflow.
22     */
23     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
24         uint256 c = _a + _b;
25         require(c >= _a);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
34         require(_b <= _a);
35         uint256 c = _a - _b;
36 
37         return c;
38     }
39 
40     /**
41     * @dev Multiplies two numbers, reverts on overflow.
42     */
43     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (_a == 0) {
48             return 0;
49         }
50 
51         uint256 c = _a * _b;
52         require(c / _a == _b);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
59     */
60     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
61         require(_b > 0); // Solidity only automatically asserts when dividing by 0
62         uint256 c = _a / _b;
63         assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // ERC Token Standard #20 Interface
72 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
73 // ----------------------------------------------------------------------------
74 contract ERC20Interface {
75     function totalSupply() public constant returns (uint);
76     function balanceOf(address _owner) public constant returns (uint balance);
77     function transfer(address _to, uint _value) public returns (bool success);
78     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
79     function approve(address _spender, uint _value) public returns (bool success);
80     function allowance(address _owner, address _spender) public constant returns (uint remaining);
81 
82     event Transfer(address indexed _from, address indexed _to, uint _value);
83     event Approval(address indexed _owner, address indexed _spender, uint _value);
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // Contract function to receive approval and execute function in one call
89 //
90 // Borrowed from MiniMeToken
91 // ----------------------------------------------------------------------------
92 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
93 
94 
95 // ----------------------------------------------------------------------------
96 // Owned contract
97 // ----------------------------------------------------------------------------
98 contract Owned {
99     address public owner;
100     address public newOwner;
101 
102     event OwnershipTransferred(address indexed _from, address indexed _to);
103 
104     constructor() public {
105         owner = msg.sender;
106     }
107 
108     modifier onlyOwner {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     function transferOwnership(address _newOwner) public onlyOwner {
114         newOwner = _newOwner;
115     }
116     function acceptOwnership() public {
117         require(msg.sender == newOwner);
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120         newOwner = address(0);
121     }
122 }
123 
124 
125 // ----------------------------------------------------------------------------
126 // ERC20 Token, with the addition of symbol, name and decimals and a
127 // fixed supply
128 // ----------------------------------------------------------------------------
129 contract IMCToken is ERC20Interface, Owned {
130     using SafeMath for uint;
131 
132     string public symbol;
133     string public  name;
134     uint8 public decimals;
135     uint _totalSupply;
136 
137     mapping(address => uint) balances;
138     mapping(address => mapping(address => uint)) allowed;
139 
140     address public externalContractAddress;
141 
142 
143     /**
144      * 构造函数
145      */
146     constructor() public {
147         symbol = "IMC";
148         name = "IMC";
149         decimals = 8;
150         _totalSupply = 1000000000 * (10 ** uint(decimals));
151         balances[owner] = _totalSupply;
152         
153         emit Transfer(address(0), owner, _totalSupply);
154     }
155 
156     /**
157      * 查询代币总发行量
158      * @return unit 余额
159      */
160     function totalSupply() public view returns (uint) {
161         return _totalSupply.sub(balances[address(0)]);
162     }
163 
164     /**
165      * 查询代币余额
166      * @param _owner address 查询代币的地址
167      * @return balance 余额
168      */
169     function balanceOf(address _owner) public view returns (uint balance) {
170         return balances[_owner];
171     }
172 
173     /**
174      * 私有方法从一个帐户发送给另一个帐户代币
175      * @param _from address 发送代币的地址
176      * @param _to address 接受代币的地址
177      * @param _value uint 接受代币的数量
178      */
179     function _transfer(address _from, address _to, uint _value) internal{
180         // 确保目标地址不为0x0，因为0x0地址代表销毁
181         require(_to != 0x0);
182         // 检查发送者是否拥有足够余额
183         require(balances[_from] >= _value);
184         // 检查是否溢出
185         require(balances[_to] + _value > balances[_to]);
186 
187         // 保存数据用于后面的判断
188         uint previousBalance = balances[_from].add(balances[_to]);
189 
190         // 从发送者减掉发送额
191         balances[_from] = balances[_from].sub(_value);
192         // 给接收者加上相同的量
193         balances[_to] = balances[_to].add(_value);
194 
195         // 通知任何监听该交易的客户端
196         emit Transfer(_from, _to, _value);
197 
198         // 判断发送、接收方的数据是否和转换前一致
199         assert(balances[_from].add(balances[_to]) == previousBalance);
200     }
201 
202     /**
203      * 从主帐户合约调用者发送给别人代币
204      * @param _to address 接受代币的地址
205      * @param _value uint 接受代币的数量
206      * @return success 交易成功
207      */
208     function transfer(address _to, uint _value) public returns (bool success) {
209         // _transfer(msg.sender, _to, _value);
210 
211         if (msg.sender == owner) {
212             // ERC20合约owner调用
213             _transfer(msg.sender, _to, _value);
214 
215             return true;
216         } else {
217             // 外部合约调用，需满足合约调用者和代币合约所设置的外部调用合约地址一致性
218             require(msg.sender == externalContractAddress);
219 
220             _transfer(owner, _to, _value);
221 
222             return true;
223         }
224     }
225 
226     /**
227      * 账号之间代币交易转移，调用过程，会检查设置的允许最大交易额
228      * @param _from address 发送者地址
229      * @param _to address 接受者地址
230      * @param _value uint 要转移的代币数量
231      * @return success 交易成功
232      */
233     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
234         
235         if (_from == msg.sender) {
236             // 自己转账时不需要approve，可以直接进行转账
237             _transfer(_from, _to, _value);
238 
239         } else {
240             // 授权给第三方时，需检查发送者是否拥有足够余额
241             require(allowed[_from][msg.sender] >= _value);
242             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243 
244             _transfer(_from, _to, _value);
245 
246         }
247 
248         return true;
249     }
250 
251     /**
252     * 允许帐户授权其他帐户代表他们提取代币
253     * @param _spender 授权帐户地址
254     * @param _value 代币数量
255     * @return success 允许成功
256     */
257     function approve(address _spender, uint _value) public returns (bool success) {
258         allowed[msg.sender][_spender] = _value;
259 
260         emit Approval(msg.sender, _spender, _value);
261 
262         return true;
263     }
264 
265     /**
266     * 查询被授权帐户的允许提取的代币数
267     * @param _owner 授权者帐户地址
268     * @param _spender 被授权者帐户地址
269     * @return remaining 代币数量
270     */
271     function allowance(address _owner, address _spender) public view returns (uint remaining) {
272         return allowed[_owner][_spender];
273     }
274 
275     /**
276      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
277      * @param _spender 被授权的地址（合约）
278      * @param _value 最大可花费代币数
279      * @param _extraData 发送给合约的附加数据
280      * @return success 设置成功
281      */
282     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
283         tokenRecipient spender = tokenRecipient(_spender);
284         if (approve(_spender, _value)) {
285             // 通知合约
286             spender.receiveApproval(msg.sender, _value, this, _extraData);
287             return true;
288         }
289     }
290 
291     /**
292      * 设置允许外部合约地址调用当前合约
293      * @param _contractAddress 合约地址
294      * @return success 设置成功
295      */
296     function approveContractCall(address _contractAddress) public onlyOwner returns (bool){
297         externalContractAddress = _contractAddress;
298         
299         return true;
300     }
301 
302     /**
303      * 不接收 Ether
304      */
305     function () public payable {
306         revert();
307     }
308 }
309 
310 
311 // ----------------------------------------------------------------------------
312 // 发行记录合约
313 // ----------------------------------------------------------------------------
314 contract IMCIssuingRecord is Owned{
315     using SafeMath for uint;
316 
317     // 发行记录添加日志
318     event IssuingRecordAdd(uint _date, bytes32 _hash, uint _depth, uint _userCount, uint _token, string _fileFormat, uint _stripLen);
319 
320     // 定义IMCToken实例
321     IMCToken public imcToken;
322 
323     // 平台账户地址
324     address public platformAddr;
325 
326     // 执行者地址
327     address public executorAddress;
328 
329     // Token发行统计记录
330     struct RecordInfo {
331         uint date;  // 记录日期（解锁ID）
332         bytes32 hash;  // 文件hash
333         uint depth; // 深度
334         uint userCount; // 用户数
335         uint token; // 发行token数量
336         string fileFormat; // 上链存证的文件格式
337         uint stripLen; // 上链存证的文件分区
338     }
339     
340     // 分配记录
341     mapping(uint => RecordInfo) public issuingRecord;
342     
343     // 用户数
344     uint public userCount;
345     
346     // 发行总币数
347     uint public totalIssuingBalance;
348     
349     /**
350      * 构造函数
351      * @param _tokenAddr address ERC20合约地址
352      * @param _platformAddr address 平台帐户地址
353      */
354     constructor(address _tokenAddr, address _platformAddr) public{
355         // 初始化IMCToken实例
356         imcToken = IMCToken(_tokenAddr);
357 
358         // 初始化平台账户地址
359         platformAddr = _platformAddr;
360         
361         // 初始化合约执行者
362         executorAddress = msg.sender;
363     }
364     
365     /**
366      * 修改platformAddr，只有owner能够修改
367      * @param _addr address 地址
368      */
369     function modifyPlatformAddr(address _addr) public onlyOwner {
370         platformAddr = _addr;
371     }
372     
373     /**
374      * 修改executorAddress，只有owner能够修改
375      * @param _addr address 地址
376      */
377     function modifyExecutorAddr(address _addr) public onlyOwner {
378         executorAddress = _addr;
379     }
380 
381     /**
382      * 转账到中间帐户
383      * @param _tokens uint 币数量
384      * @return success 交易成功
385      */
386     function sendTokenToPlatform(uint _tokens) internal returns (bool) {
387 
388         imcToken.transfer(platformAddr, _tokens);
389         
390         return true;
391     }
392 
393     /**
394      * 发行记录添加
395      * @param _date uint 记录日期（解锁ID）
396      * @param _hash bytes32 文件hash
397      * @param _depth uint 深度
398      * @param _userCount uint 用户数
399      * @param _token uint 发行token数量
400      * @param _fileFormat string 上链存证的文件格式
401      * @param _stripLen uint 上链存证的文件分区
402      * @return success 添加成功
403      */
404     function issuingRecordAdd(uint _date, bytes32 _hash, uint _depth, uint _userCount, uint _token, string _fileFormat, uint _stripLen) public returns (bool) {
405         // 调用者需和Owner设置的执行者地址一致
406         require(msg.sender == executorAddress);
407         // 防止重复记录
408         require(issuingRecord[_date].date != _date);
409 
410         // 累计用户数
411         userCount = userCount.add(_userCount);
412 
413         // 累计发行币数
414         totalIssuingBalance = totalIssuingBalance.add(_token);
415         
416         // 记录发行信息
417         issuingRecord[_date] = RecordInfo(_date, _hash, _depth, _userCount, _token, _fileFormat, _stripLen);
418 
419         // 转账到中间帐户
420         sendTokenToPlatform(_token);
421 
422         emit IssuingRecordAdd(_date, _hash, _depth, _userCount, _token, _fileFormat, _stripLen);
423         
424         return true;
425         
426     }
427 
428 }