1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract ECF {
6 	using SafeMath for uint256;
7     string public name;
8     string public symbol;
9     uint8 public decimals;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
10     uint256 public totalSupply;
11 	address public owner;
12 	
13 
14     // 用mapping保存每个地址对应的余额
15     mapping (address => uint256) public balanceOf;
16     // 存储对账号的控制
17     mapping (address => mapping (address => uint256)) public allowance;
18 	mapping (address => uint256) public freezeOf;
19 
20     // 事件，用来通知客户端交易发生
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // 事件，用来通知客户端代币被消费
24     event Burn(address indexed from, uint256 value);
25     
26     //表示相应的授权的请求被同意，可以正式授权
27     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
28 	
29 	/* 冻结 */
30     event Freeze(address indexed from, uint256 value);
31 	
32 	/* 解冻 */
33     event Unfreeze(address indexed from, uint256 value);
34 
35     /**
36      * 初始化构造
37      */
38     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 uintDecimal) public {
39         decimals = uintDecimal;
40 		totalSupply = initialSupply * 10 ** uint256(uintDecimal);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
41         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
42         name = tokenName;                                   // 代币名称
43         symbol = tokenSymbol;                               // 代币符号
44 		owner = msg.sender;
45 	}
46 	
47 	modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53 		require(newOwner != address(0));
54         owner = newOwner;
55     }
56 
57     /**
58      * 代币交易转移的内部实现
59      */
60     function _transfer(address _from, address _to, uint _value) internal {
61         // 确保目标地址不为0x0，因为0x0地址代表销毁
62         require(_to != 0x0);
63         // 检查发送者余额
64         require(balanceOf[_from] >= _value);
65         // 确保转移为正数个
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67 
68         // 以下用来检查交易，
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] = balanceOf[_from].sub(_value);
72         // Add the same to the recipient
73         balanceOf[_to] = balanceOf[_to].add(_value);
74         emit Transfer(_from, _to, _value);
75 
76         // 用assert来检查代码逻辑。
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      *  代币交易转移
82      * 从创建交易者账号发送`_value`份额代币到 `_to`账号
83      *
84      * @param _to 接收者地址
85      * @param _value 转移数额
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * 账号之间代币交易转移
93      * @param _from 发送者地址
94      * @param _to 接收者地址
95      * @param _value 转移数额
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * 设置某个地址（合约）可以交易者名义花费的代币数。
106      *
107      * 允许发送者`_spender` 花费不多于 `_value` 份额代币
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender,_spender,_value);
116         return true;
117     }
118 
119     /**
120      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
121      *
122      * @param _spender 被授权的地址（合约）
123      * @param _value 最大可花费代币数
124      * @param _extraData 发送给合约的附加数据
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     /**
137      * 销毁创建者账户中指定个代币
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
142         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
143         emit Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * 销毁用户账户中指定个代币
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
159         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
160         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
161         emit Burn(_from, _value);
162         return true;
163     }
164 	//增发
165 	function mintToken(address target, uint256 mintedAmount) public onlyOwner {
166         balanceOf[target] = balanceOf[target].add(mintedAmount);
167         totalSupply = totalSupply.add(mintedAmount);
168         emit Transfer(0, owner, mintedAmount);
169         emit Transfer(owner, target, mintedAmount);
170     }
171 	//冻结
172 	function freeze(address target,uint256 _value) onlyOwner public returns (bool success) {
173         if (balanceOf[target] < _value) revert();            // Check if the sender has enough
174 		if (_value <= 0) revert(); 
175         balanceOf[target] = balanceOf[target].sub(_value);                      // Subtract from the sender
176         freezeOf[target] = freezeOf[target].add(_value);                                // Updates totalSupply
177         emit Freeze(target, _value);
178         return true;
179     }
180 	//解冻
181 	function unfreeze(address target,uint256 _value) onlyOwner public returns (bool success) {
182         if (freezeOf[target] < _value) revert();            // Check if the sender has enough
183 		if (_value <= 0) revert(); 
184         freezeOf[target] = freezeOf[target].sub(_value);                      // Subtract from the sender
185 		balanceOf[target] = balanceOf[target].add(_value);
186         emit Unfreeze(target, _value);
187         return true;
188     }
189 	
190 	// can accept ether
191 	function() payable public{
192     }
193 }
194 
195 /**
196  * @title SafeMath
197  * @dev Math operations with safety checks that throw on error
198  */
199 library SafeMath {
200 
201   /**
202   * @dev Multiplies two numbers, throws on overflow.
203   */
204   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205     if (a == 0) {
206       return 0;
207     }
208     uint256 c = a * b;
209     assert(c / a == b);
210     return c;
211   }
212 
213   /**
214   * @dev Integer division of two numbers, truncating the quotient.
215   */
216   function div(uint256 a, uint256 b) internal pure returns (uint256) {
217     // assert(b > 0); // Solidity automatically throws when dividing by 0
218     uint256 c = a / b;
219     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220     return c;
221   }
222 
223   /**
224   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
225   */
226   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227     assert(b <= a);
228     return a - b;
229   }
230 
231   /**
232   * @dev Adds two numbers, throws on overflow.
233   */
234   function add(uint256 a, uint256 b) internal pure returns (uint256) {
235     uint256 c = a + b;
236     assert(c >= a);
237     return c;
238   }
239 }