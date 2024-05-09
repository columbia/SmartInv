1 /**
2  * ERC20 token
3  *
4  * https://github.com/ethereum/EIPs/issues/20
5  */
6 contract ERC20 {
7   // token总量
8   uint public totalSupply;
9   // 获取账户_owner拥有token的数量
10   function balanceOf(address _owner) constant returns (uint);
11   //获取账户_spender可以从账户_owner中转出token的数量
12   function allowance(address _owner, address _spender) constant returns (uint);
13   // 从发送者账户中往_to账户转数量为_value的token
14   function transfer(address _to, uint _value) returns (bool ok);
15   //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
16   function transferFrom(address _from, address _to, uint _value) returns (bool ok);
17   // 消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
18   function approve(address _spender, uint _value) returns (bool ok);
19   //发生转账时必须要触发的事件, 由transfer函数的最后一行代码触发。
20   event Transfer(address indexed _from, address indexed _to, uint _value);
21   //当函数approve(address spender, uint value)成功执行时必须触发的事件
22   event Approval(address indexed _owner, address indexed _spender, uint _value);
23 }
24 
25 
26 
27 /**
28  * 带安全检查的数学运算符
29  */
30 contract SafeMath {
31   function safeMul(uint a, uint b) internal returns (uint) {
32     uint c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function safeDiv(uint a, uint b) internal returns (uint) {
38     assert(b > 0);
39     uint c = a / b;
40     assert(a == b * c + a % b);
41     return c;
42   }
43 
44   function safeSub(uint a, uint b) internal returns (uint) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function safeAdd(uint a, uint b) internal returns (uint) {
50     uint c = a + b;
51     assert(c>=a && c>=b);
52     return c;
53   }
54 
55   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
68     return a < b ? a : b;
69   }
70 
71   function assert(bool assertion) internal {
72     if (!assertion) {
73       throw;
74     }
75   }
76 }
77 
78 
79 
80 /**
81  * 修复了ERC20 short address attack问题的标准ERC20 Token.
82  *
83  * Based on:
84  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract StandardToken is ERC20, SafeMath {
87 
88   //创建一个状态变量，该类型将一些address映射到无符号整数uint256。
89   mapping(address => uint) balances;
90   mapping (address => mapping (address => uint)) allowed;
91 
92   /**
93    *
94    * 修复ERC20 short address attack
95    *
96    * http://vessenes.com/the-erc20-short-address-attack-explained/
97    */
98   modifier onlyPayloadSize(uint size) {
99      if(msg.data.length < size + 4) {
100        throw;
101      }
102      _;
103   }
104 
105   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
106     //从消息发送者账户中减去token数量_value
107     balances[msg.sender] = safeSub(balances[msg.sender], _value);
108     //往接收账户增加token数量_value
109     balances[_to] = safeAdd(balances[_to], _value);
110     //触发转币交易事件
111     Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
116     var _allowance = allowed[_from][msg.sender];
117 
118     //接收账户增加token数量_value
119     balances[_to] = safeAdd(balances[_to], _value);
120     //支出账户_from减去token数量_value
121     balances[_from] = safeSub(balances[_from], _value);
122     //消息发送者可以从账户_from中转出的数量减少_value
123     allowed[_from][msg.sender] = safeSub(_allowance, _value);
124     //触发转币交易事件
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function balanceOf(address _owner) constant returns (uint balance) {
130     return balances[_owner];
131   }
132 
133   function approve(address _spender, uint _value) returns (bool success) {
134     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   function allowance(address _owner, address _spender) constant returns (uint remaining) {
141     //允许_spender从_owner中转出的token数
142     return allowed[_owner][_spender];
143   }
144 
145 }
146 
147 
148 /**
149  * 允许token拥有者减少token总量
150  * 加Burned事件使其区别于正常的transfers
151  */
152 contract BurnableToken is StandardToken {
153 
154   address public constant BURN_ADDRESS = 0;
155 
156   event Burned(address burner, uint burnedAmount);
157 
158   /**
159    * 销毁Token
160    *
161    */
162   function burn(uint burnAmount) {
163     address burner = msg.sender;
164     balances[burner] = safeSub(balances[burner], burnAmount);
165     totalSupply = safeSub(totalSupply, burnAmount);
166     Burned(burner, burnAmount);
167     Transfer(burner, BURN_ADDRESS, burnAmount);
168   }
169 }
170 
171 
172 
173 
174 /**
175  * 发行Ethereum token.
176  *
177  * 创建token总量并分配给owner.
178  * owner之后可以把token分配给其他人
179  * owner可以销毁token
180  *
181  */
182 contract HLCToken is BurnableToken {
183 
184   string public name;  // Token名称，例如：Halal chain token
185   string public symbol;  // Token标识，例如：HLC
186   uint8 public decimals = 18;  // 最多的小数位数 18 是建议的默认值
187   uint256 public totalSupply;
188   function HLCToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) {
189     name = _name;
190     symbol = _symbol;
191     totalSupply = _totalSupply * 10 ** uint256(_decimals);
192     decimals = _decimals;
193 
194     // 把创建token的总量分配给owner
195     balances[_owner] = totalSupply;
196   }
197 }