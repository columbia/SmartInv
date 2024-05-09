1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title 安全数学库
5  * @dev 用于uint256的安全计算，合约内的代币操作均使用这个库的函数代替加减乘除，来避免上溢、下溢等问题
6  */
7 library SafeMath {
8 
9  /**
10   * @dev 乘法
11   */
12  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13   if (a == 0) {
14    return 0;
15   }
16   c = a * b;
17   assert(c / a == b);
18   return c;
19  }
20 
21  /**
22   * @dev 除法
23   */
24  function div(uint256 a, uint256 b) internal pure returns (uint256) {
25   return a / b;
26  }
27 
28  /**
29   * @dev 减法
30   */
31  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32   assert(b <= a);
33   return a - b;
34  }
35 
36  /**
37   * @dev 加法
38   */
39  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40   c = a + b;
41   assert(c >= a);
42   return c;
43  }
44 }
45 
46 /**
47  * @title 所有权合约
48  * @dev 用于控制合约的所有权，可以转让所有权
49  */
50 contract Ownable {
51  address owner_; //合约所有者
52 
53  event OwnershipRenounced(address indexed previousOwner); //合约所有权放弃事件
54  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //合约所有权转让事件
55 
56  /**
57   * @dev 构造函数
58   */
59  constructor() public {
60   owner_ = msg.sender; //合约所有者为合约创建者
61  }
62 
63  /**
64      * @dev 合约所有者
65      */
66  function owner() public view returns (address) {
67   return owner_;
68  }
69 
70  /**
71      * @dev onlyOwner函数修改器：判断合约使用者是不是合约拥有者，是合约拥有者才能执行
72      */
73  modifier onlyOwner() {
74   require(msg.sender == owner_);
75   _;
76  }
77 
78  /**
79   * @dev 转让合约所有权：只有合约所有者能使用，转让合约所有权给newOwner
80   * @param  newOwner 新的合约所有者
81   */
82  function transferOwnership(address newOwner) public onlyOwner {
83   require(newOwner != address(0));
84   emit OwnershipTransferred(owner_, newOwner);
85   owner_ = newOwner;
86  }
87 }
88 
89 /**
90  * @title ERC20代币合约
91  * @dev 这是一个示例合约，众筹合约实际使用时，要用众筹合约的token代码替换这里的合约代码
92  */
93 contract ERC20 is Ownable {
94 
95  using SafeMath for uint256; //uint256类型使用SafeMath库
96 
97  string name_; //代币名称
98  string symbol_; //代币符号，类似货币符号
99  uint8 decimals_; //小数点后位数
100  uint256 totalSupply_; //发行总量
101 
102  mapping(address => uint256) balances; //地址余额映射
103  mapping(address => mapping(address => uint256)) internal allowed; //授权额度映射
104 
105  event Transfer(address indexed from, address indexed to, uint256 value); //代币转账事件
106  event Approval(address indexed owner, address indexed spender, uint256 value); //授权额度事件
107  event OwnershipRenounced(address indexed previousOwner); //合约所有权放弃事件
108  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //合约所有权转让事件
109 
110  /**
111   * @dev 构造函数：web3代码生成后，需要自定义_name,_symbol,_decimals,_totalSupply
112   */
113  constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
114   name_ = _name;
115   symbol_ = _symbol;
116   decimals_ = _decimals;
117   totalSupply_ = _totalSupply.mul(10 ** uint256(decimals_)); //发行总量按小数点后位数转换
118   balances[owner_] = totalSupply_; //合约发布者持有初始所有代币
119  }
120 
121  /**
122   * @dev 代币名称
123   */
124  function name() public view returns (string) {
125   return name_;
126  }
127 
128  /**
129   * @dev 代币符号
130   */
131  function symbol() public view returns (string) {
132   return symbol_;
133  }
134 
135  /**
136   * @dev 小数点后位数
137   */
138  function decimals() public view returns (uint8) {
139   return decimals_;
140  }
141 
142  /**
143   * @dev 发行总量
144   */
145  function totalSupply() public view returns (uint256) {
146   return totalSupply_;
147  }
148 
149  /**
150   * @dev onlyOwner函数修改器：判断合约使用者是不是合约拥有者，是合约拥有者才能执行
151   */
152  modifier onlyOwner() {
153   require(msg.sender == owner_);
154   _;
155  }
156 
157  /**
158   * @dev 代币转账：在合约未暂停时，由合约使用者msg.sender，向_to转入_value数量的代币
159   * @param  _to 转入地址 _value 代币数量
160   * @return  bool 是否转账成功
161   */
162  function transfer(address _to, uint256 _value) public {
163   require(_to != address(0));
164   require(_value <= balances[msg.sender]);
165 
166   balances[msg.sender] = balances[msg.sender].sub(_value);
167   balances[_to] = balances[_to].add(_value);
168   emit Transfer(msg.sender, _to, _value);
169  }
170 
171  /**
172   * @dev 余额查询：查询_account地址的代币余额
173   * @param  _account 代币账户地址
174   * @return  uint256 代币余额
175   */
176  function balanceOf(address _account) public view returns (uint256) {
177   return balances[_account];
178  }
179 
180  /**
181   * @dev 授权额度：在合约未暂停时，由合约使用者msg.sender，向_spender授权_value数量代币额度
182   * @param  _spender 被授权地址 _value 授权额度
183   * @return  bool 是否授权成功
184   */
185  function approve(address _spender, uint256 _value) public returns (bool) {
186   allowed[msg.sender][_spender] = _value;
187   emit Approval(msg.sender, _spender, _value);
188   return true;
189  }
190 
191  /**
192      * @dev 授额转账：在合约未暂停时，由合约使用者msg.sender，从_from向_to转入_value数量的代币，转账数量不能超过_from的授权额度和余额
193      * @param  _from 授额地址 _to转入地址 _value 代币数量
194      * @return  bool 是否转账成功
195      */
196  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197   require(_to != address(0));
198   require(_value <= balances[_from]);
199   require(_value <= allowed[_from][msg.sender]);
200 
201   balances[_from] = balances[_from].sub(_value);
202   balances[_to] = balances[_to].add(_value);
203   allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204   emit Transfer(_from, _to, _value);
205   return true;
206  }
207 
208  /**
209   * @dev 查询授额：查询由_owner向_spender授权的代币额度
210   * @param  _owner 授权地址 _spender 被授权地址
211   * @return  uint256 授权额度
212   */
213  function allowance(address _owner, address _spender) public view returns (uint256) {
214   return allowed[_owner][_spender];
215  }
216 
217  /**
218   * @dev 增加授额：在合约未暂停时，由合约使用者msg.sender向_spender增加_addValue数量的代币额度
219   * @param  _spender 被授权地址 _addedValue 增加的授权额度
220   * @return  bool 是否增加授额成功
221   */
222  function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
223   allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224   emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225   return true;
226  }
227 
228  /**
229   * @dev 减少授额：在合约未暂停时，由合约使用者msg.sender向_spender减少_subtractedValue数量的代币额度
230   * @param  _spender 被授权地址 _subtractedValue 减少的授权额度
231   * @return  bool 是否减少授额成功
232   */
233  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
234   uint oldValue = allowed[msg.sender][_spender];
235   if (_subtractedValue > oldValue) {
236    allowed[msg.sender][_spender] = 0;
237   } else {
238    allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239   }
240   emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241   return true;
242  }
243 }