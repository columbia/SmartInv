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
203      * 从合约调用者发送给别人代币
204      * @param _to address 接受代币的地址
205      * @param _value uint 接受代币的数量
206      * @return success 交易成功
207      */
208     function transfer(address _to, uint _value) public returns (bool success) {
209         _transfer(msg.sender, _to, _value);
210 
211         return true;
212     }
213 
214     /**
215      * 账号之间代币交易转移，调用过程，会检查设置的允许最大交易额
216      * @param _from address 发送者地址
217      * @param _to address 接受者地址
218      * @param _value uint 要转移的代币数量
219      * @return success 交易成功
220      */
221     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
222         
223         if (_from == msg.sender) {
224             // 自己转账时不需要approve，可以直接进行转账
225             _transfer(_from, _to, _value);
226 
227         } else {
228             // 授权给第三方时，需检查发送者是否拥有足够余额
229             require(allowed[_from][msg.sender] >= _value);
230             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231 
232             _transfer(_from, _to, _value);
233 
234         }
235 
236         return true;
237     }
238 
239     /**
240      * 从主帐户合约发行代币
241      * @param _to address 接受代币的地址
242      * @param _value uint 接受代币的数量
243      * @return success 交易成功
244      */
245     function issue(address _to, uint _value) public returns (bool success) {
246         // 外部合约调用，需满足合约调用者和代币合约所设置的外部调用合约地址一致性
247         require(msg.sender == externalContractAddress);
248 
249         _transfer(owner, _to, _value);
250 
251         return true;
252     }
253 
254     /**
255     * 允许帐户授权其他帐户代表他们提取代币
256     * @param _spender 授权帐户地址
257     * @param _value 代币数量
258     * @return success 允许成功
259     */
260     function approve(address _spender, uint _value) public returns (bool success) {
261         allowed[msg.sender][_spender] = _value;
262 
263         emit Approval(msg.sender, _spender, _value);
264 
265         return true;
266     }
267 
268     /**
269     * 查询被授权帐户的允许提取的代币数
270     * @param _owner 授权者帐户地址
271     * @param _spender 被授权者帐户地址
272     * @return remaining 代币数量
273     */
274     function allowance(address _owner, address _spender) public view returns (uint remaining) {
275         return allowed[_owner][_spender];
276     }
277 
278     /**
279      * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。
280      * @param _spender 被授权的地址（合约）
281      * @param _value 最大可花费代币数
282      * @param _extraData 发送给合约的附加数据
283      * @return success 设置成功
284      */
285     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
286         tokenRecipient spender = tokenRecipient(_spender);
287         if (approve(_spender, _value)) {
288             // 通知合约
289             spender.receiveApproval(msg.sender, _value, this, _extraData);
290             return true;
291         }
292     }
293 
294     /**
295      * 设置允许外部合约地址调用当前合约
296      * @param _contractAddress 合约地址
297      * @return success 设置成功
298      */
299     function approveContractCall(address _contractAddress) public onlyOwner returns (bool){
300         externalContractAddress = _contractAddress;
301         
302         return true;
303     }
304 
305     /**
306      * 不接收 Ether
307      */
308     function () public payable {
309         revert();
310     }
311 }
312 
313 // ----------------------------------------------------------------------------
314 // 发行记录合约
315 // ----------------------------------------------------------------------------
316 contract IMCIssuingRecord is Owned{
317     using SafeMath for uint;
318 
319     // 发行记录添加日志
320     event IssuingRecordAdd(uint _date, bytes32 _hash, uint _depth, uint _userCount, uint _token, string _fileFormat, uint _stripLen);
321 
322     // 定义IMCToken实例
323     IMCToken public imcToken;
324 
325     // 平台账户地址
326     address public platformAddr;
327 
328     // 执行者地址
329     address public executorAddress;
330 
331     // Token发行统计记录
332     struct RecordInfo {
333         uint date;  // 记录日期（解锁ID）
334         bytes32 hash;  // 文件hash
335         uint depth; // 深度
336         uint userCount; // 用户数
337         uint token; // 发行token数量
338         string fileFormat; // 上链存证的文件格式
339         uint stripLen; // 上链存证的文件分区
340     }
341     
342     // 分配记录
343     mapping(uint => RecordInfo) public issuingRecord;
344     
345     // 用户数
346     uint public userCount;
347     
348     // 发行总币数
349     uint public totalIssuingBalance;
350     
351     /**
352      * 构造函数
353      * @param _tokenAddr address ERC20合约地址
354      * @param _platformAddr address 平台帐户地址
355      */
356     constructor(address _tokenAddr, address _platformAddr) public{
357         // 初始化IMCToken实例
358         imcToken = IMCToken(_tokenAddr);
359 
360         // 初始化平台账户地址
361         platformAddr = _platformAddr;
362         
363         // 初始化合约执行者
364         executorAddress = msg.sender;
365     }
366     
367     /**
368      * 修改platformAddr，只有owner能够修改
369      * @param _addr address 地址
370      */
371     function modifyPlatformAddr(address _addr) public onlyOwner {
372         platformAddr = _addr;
373     }
374     
375     /**
376      * 修改executorAddress，只有owner能够修改
377      * @param _addr address 地址
378      */
379     function modifyExecutorAddr(address _addr) public onlyOwner {
380         executorAddress = _addr;
381     }
382 
383     /**
384      * 转账到中间帐户
385      * @param _tokens uint 币数量
386      * @return success 交易成功
387      */
388     function sendTokenToPlatform(uint _tokens) internal returns (bool) {
389 
390         imcToken.issue(platformAddr, _tokens);
391         
392         return true;
393     }
394 
395     /**
396      * 发行记录添加
397      * @param _date uint 记录日期（解锁ID）
398      * @param _hash bytes32 文件hash
399      * @param _depth uint 深度
400      * @param _userCount uint 用户数
401      * @param _token uint 发行token数量
402      * @param _fileFormat string 上链存证的文件格式
403      * @param _stripLen uint 上链存证的文件分区
404      * @return success 添加成功
405      */
406     function issuingRecordAdd(uint _date, bytes32 _hash, uint _depth, uint _userCount, uint _token, string _fileFormat, uint _stripLen) public returns (bool) {
407         // 调用者需和Owner设置的执行者地址一致
408         require(msg.sender == executorAddress);
409         // 防止重复记录
410         require(issuingRecord[_date].date != _date);
411 
412         // 累计用户数
413         userCount = userCount.add(_userCount);
414 
415         // 累计发行币数
416         totalIssuingBalance = totalIssuingBalance.add(_token);
417         
418         // 记录发行信息
419         issuingRecord[_date] = RecordInfo(_date, _hash, _depth, _userCount, _token, _fileFormat, _stripLen);
420 
421         // 转账到中间帐户
422         sendTokenToPlatform(_token);
423 
424         emit IssuingRecordAdd(_date, _hash, _depth, _userCount, _token, _fileFormat, _stripLen);
425         
426         return true;
427         
428     }
429 
430 }