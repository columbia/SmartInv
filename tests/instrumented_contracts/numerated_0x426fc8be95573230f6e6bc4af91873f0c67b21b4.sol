1 pragma solidity ^0.5.1;
2 
3 /// @title BEAN - Beans are designed for global trusted talent chain
4 /// @author zhouhang
5 
6 /**
7  * @title 安全数学库
8  * @dev 用于uint256的安全计算，合约内的积分操作均使用这个库的函数代替加减乘除，来避免上溢、下溢等问题
9  */
10 library SafeMath {
11 
12 	/**
13 	 * @dev 乘法
14 	 */
15 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16 		if (a == 0) {
17 			return 0;
18 		}
19 		uint256 c = a * b;
20 		require(c / a == b);
21 		return c;
22 	}
23 
24 	/**
25 	 * @dev 除法
26 	 */
27 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
28 		require(b > 0); // Solidity only automatically asserts when dividing by 0
29     uint256 c = a / b;
30 
31 		return c;
32 	}
33 
34 	/**
35 	 * @dev 减法
36 	 */
37 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38 		require(b <= a);
39 		uint256 c = a - b;
40     require(c <= a);
41 
42     return c;
43 	}
44 
45 	/**
46 	 * @dev 加法
47 	 */
48 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
49 		uint256 c = a + b;
50     require(c >= a);
51 
52     return c;
53 	}
54 }
55 
56 /**
57  * @title 所有权合约
58  * @dev 用于控制合约的所有权，包括转让所有权
59  */
60 contract Ownable {
61 	address internal owner_; //合约所有者
62 
63 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //合约所有权转让事件
64 
65 	/**
66 	 * @dev 构造函数
67 	 */
68 	constructor() public {
69 		owner_ = msg.sender; //合约所有者为合约创建者
70 	}
71 
72 	/**
73      * @dev 合约所有者
74      */
75 	function owner() public view returns (address) {
76 		return owner_;
77 	}
78 
79 	/**
80      * @dev onlyOwner函数修改器：判断合约使用者是不是合约拥有者，是合约拥有者才能执行
81      */
82 	modifier onlyOwner() {
83 		require(msg.sender == owner_);
84 		_;
85 	}
86 
87 	/**
88 	 * @dev 转让合约所有权：只有合约所有者能使用，转让合约所有权给newOwner
89 	 * @param  newOwner 新的合约所有者
90 	 */
91 	function transferOwnership(address newOwner) public onlyOwner {
92 		require(newOwner != address(0));
93 		emit OwnershipTransferred(owner_, newOwner);
94 		owner_ = newOwner;
95 	}
96 }
97 
98 /**
99  * @title BALC可暂停标准积分合约
100  * @dev 可暂停的标准积分合约包括查询余额、积分转账、授权额度、查询授额、授额转账、增加授额、减少授额、暂停合约、重启合约功能，继承Ownable合约功能
101  */
102 contract BALC is Ownable {
103 
104 	using SafeMath for uint256; //uint256类型使用SafeMath库
105 
106 	string private name_; //积分名称
107 	string private symbol_; //积分符号，类似货币符号
108 	uint256 private decimals_; //小数点后位数
109 	uint256 private totalSupply_; //发行总量
110 	bool private paused_; //是否暂停合约
111 
112 	mapping(address => uint256) internal balances; //地址余额映射
113 	mapping(address => mapping(address => uint256)) internal allowed; //授权额度映射
114 
115 	event Transfer(address indexed from, address indexed to, uint256 value); //积分转账事件
116 	event Approval(address indexed owner, address indexed spender, uint256 value); //授权额度事件
117 	event Pause(); //合约暂停事件
118 	event Unpause(); //合约重启事件
119 
120 	/**
121 	 * @dev 构造函数：web3代码生成后，需要自定义_name,_symbol,_decimals,_totalSupply
122 	 */
123 	constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _totalSupply, address _owner) public {
124 		name_ = _name;
125 		symbol_ = _symbol;
126 		decimals_ = _decimals;
127 		totalSupply_ = _totalSupply.mul(10 ** decimals_); //发行总量按小数点后位数转换
128 		paused_ = false; //默认合约不暂停
129 		owner_ = _owner;
130 		balances[owner_] = totalSupply_; //合约发布者持有初始所有积分
131 	}
132 
133 	/**
134 	 * @dev 积分名称
135 	 */
136 	function name() public view returns (string memory) {
137 		return name_;
138 	}
139 
140 	/**
141 	 * @dev 积分符号
142 	 */
143 	function symbol() public view returns (string memory) {
144 		return symbol_;
145 	}
146 
147 	/**
148 	 * @dev 小数点后位数
149 	 */
150 	function decimals() public view returns (uint256) {
151 		return decimals_;
152 	}
153 
154 	/**
155 	 * @dev 发行总量
156 	 */
157 	function totalSupply() public view returns (uint256) {
158 		return totalSupply_;
159 	}
160 
161 	/**
162 	 * @dev 是否暂停
163 	 */
164 	function isPaused() public view returns (bool) {
165 		return paused_;
166 	}
167 
168 	/**
169 	 * @dev whenNotPaused函数修改器：判断合约是否未暂停，未暂停时才能执行
170 	 */
171 	modifier whenNotPaused() {
172 		require(!paused_);
173 		_;
174 	}
175 
176 	/**
177 	 * @dev whenNotPaused函数修改器：判断合约是否暂停，暂停时才能执行
178 	 */
179 	modifier whenPaused() {
180 		require(paused_);
181 		_;
182 	}
183 
184 	/**
185 	 * @dev 积分转账：在合约未暂停时，由合约使用者msg.sender，向_to转入_value数量的积分
186 	 * @param  _to 转入地址 _value 积分数量
187 	 * @return  bool 是否转账成功
188 	 */
189 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
190 		require(_to != address(0));
191 		require(_value <= balances[msg.sender]);
192 
193 		balances[msg.sender] = balances[msg.sender].sub(_value);
194 		balances[_to] = balances[_to].add(_value);
195 		emit Transfer(msg.sender, _to, _value);
196 		return true;
197 	}
198 
199 	/**
200 	 * @dev 余额查询：查询_account地址的积分余额
201 	 * @param  _account 积分账户地址
202 	 * @return  uint256 积分余额
203 	 */
204 	function balanceOf(address _account) public view returns (uint256) {
205 		return balances[_account];
206 	}
207 
208 	/**
209 	 * @dev 授权额度：在合约未暂停时，由合约使用者msg.sender，向_spender授权_value数量积分额度
210 	 * @param  _spender 被授权地址 _value 授权额度
211 	 * @return  bool 是否授权成功
212 	 */
213 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
214 		require(_spender != address(0));
215 		require(_value < totalSupply_);
216 		allowed[msg.sender][_spender] = _value;
217 		emit Approval(msg.sender, _spender, _value);
218 		return true;
219 	}
220 
221 	/**
222      * @dev 授额转账：在合约未暂停时，由合约使用者msg.sender，从_from向_to转入_value数量的积分，转账数量不能超过_from的授权额度和余额
223      * @param  _from 授额地址 _to转入地址 _value 积分数量
224      * @return  bool 是否转账成功
225      */
226 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
227 		require(_to != address(0));
228 		require(_value <= balances[_from]);
229 		require(_value <= allowed[_from][msg.sender]);
230     
231         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232 		balances[_from] = balances[_from].sub(_value);
233 		balances[_to] = balances[_to].add(_value);
234 		emit Transfer(_from, _to, _value);
235 		return true;
236 	}
237 
238 	/**
239 	 * @dev 查询授额：查询由_owner向_spender授权的积分额度
240 	 * @param  _owner 授权地址 _spender 被授权地址
241 	 * @return  uint256 授权额度
242 	 */
243 	function allowance(address _owner, address _spender) public view returns (uint256) {
244 		return allowed[_owner][_spender];
245 	}
246 
247 	/**
248 	 * @dev 增加授额：在合约未暂停时，由合约使用者msg.sender向_spender增加_addValue数量的积分额度
249 	 * @param  _spender 被授权地址 _addedValue 增加的授权额度
250 	 * @return  bool 是否增加授额成功
251 	 */
252 	function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
253         require(_spender != address(0));
254 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256 		return true;
257 	}
258 
259 	/**
260 	 * @dev 减少授额：在合约未暂停时，由合约使用者msg.sender向_spender减少_subtractedValue数量的积分额度
261 	 * @param  _spender 被授权地址 _subtractedValue 减少的授权额度
262 	 * @return  bool 是否减少授额成功
263 	 */
264 	function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
265         require(_spender != address(0));
266 		uint256 oldValue = allowed[msg.sender][_spender];
267 		if (_subtractedValue > oldValue) {
268 			allowed[msg.sender][_spender] = 0;
269 		} else {
270 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271 		}
272 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273 		return true;
274 	}
275 
276 	/**
277 	 * @dev 暂停合约：只有合约所有者能使用，在合约未暂停时，暂停合约
278 	 */
279 	function pause() onlyOwner whenNotPaused public returns (bool) {
280 		paused_ = true;
281 		emit Pause();
282 		return true;
283 	}
284 
285 	/**a
286 	 * @dev 重启合约：只有合约所有者能使用，在合约暂停时，重启合约
287 	 */
288 	function unpause() onlyOwner whenPaused public returns (bool) {
289 		paused_ = false;
290 		emit Unpause();
291 		return true;
292 	}
293 }