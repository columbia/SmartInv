1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4     
5     // 乘法（internal修饰的函数只能够在当前合约或子合约中使用）
6     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) { 
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11   
12     // 除法
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0);
15         uint256 c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19  
20     // 减法
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         assert(b >=0);
24         return a - b;
25     }
26  
27     // 加法
28     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c>=a && c>=b);
31         return c;
32     }
33 }
34  
35 contract AO is SafeMath{
36     // 代币的名字
37     string public name = "AGC"; 
38     // 代币的符号
39     string public symbol = "AGC";
40     // 代币支持的小数位
41     uint8 public decimals = 18;
42     // 代表发行的总量
43     uint256 public totalSupply = 2100000000;
44     // 管理者
45     address public owner;
46  
47     // 该mapping保存账户余额，Key表示账户地址，Value表示token个数
48     mapping (address => uint256) public balanceOf;
49     // 该mappin保存指定帐号被授权的token个数
50     // key1表示授权人，key2表示被授权人，value2表示被授权token的个数
51     mapping (address => mapping (address => uint256)) public allowance;
52     // 冻结指定帐号token的个数
53     mapping (address => uint256) public freezeOf;
54  
55     // 定义事件
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Burn(address indexed from, uint256 value);
58     event Freeze(address indexed from, uint256 value);
59     event Unfreeze(address indexed from, uint256 value);
60  
61     // 构造函数（1000000, "ZhongB", 18, "ZB"）
62     constructor( 
63         uint256 initialSupply,  // 发行数量
64         string tokenName,       // token的名字 BinanceToken
65         uint8 decimalUnits,     // 最小分割，小数点后面的尾数 1ether = 10** 18wei
66         string tokenSymbol      // ZB
67     ) public {
68         decimals = decimalUnits;                           
69         balanceOf[msg.sender] = initialSupply * 10 ** 18;    
70         totalSupply = initialSupply * 10 ** 18;   
71         name = tokenName;      
72         symbol = tokenSymbol;
73         owner = msg.sender;
74     }
75  
76     // 转账：某个人花费自己的币
77     function transfer(address _to, uint256 _value) public {
78         // 防止_to无效
79         assert(_to != 0x0);
80         // 防止_value无效                       
81         assert(_value > 0);
82         // 防止转账人的余额不足
83         assert(balanceOf[msg.sender] >= _value);
84         // 防止数据溢出
85         assert(balanceOf[_to] + _value >= balanceOf[_to]);
86         // 从转账人的账户中减去一定的token的个数
87         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     
88         // 往接收帐号增加一定的token个数
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
90         // 转账成功后触发Transfer事件，通知其他人有转账交易发生
91         emit Transfer(msg.sender, _to, _value);// Notify anyone listening that this transfer took place
92     }
93  
94     // 授权：授权某人花费自己账户中一定数量的token
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         assert(_value > 0);
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100  
101      //增发
102     function mintToken(address _to, uint256 _value) public returns (bool success){
103         // 防止_to无效
104         assert(_to != 0x0);
105         // 防止_value无效                       
106         assert(_value > 0);
107         balanceOf[_to] += _value;
108         totalSupply += _value;
109         emit Transfer(0, msg.sender, _value);
110         emit Transfer(msg.sender, _to, _value);
111         return true;
112     }
113  
114     // 授权转账：被授权人从_from帐号中给_to帐号转了_value个token
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116         // 防止地址无效
117         assert(_to != 0x0);
118         // 防止转账金额无效
119         assert(_value > 0);
120         // 检查授权人账户的余额是否足够
121         assert(balanceOf[_from] >= _value);
122         // 检查数据是否溢出
123         assert(balanceOf[_to] + _value >= balanceOf[_to]);
124         // 检查被授权人在allowance中可以使用的token数量是否足够
125         assert(_value <= allowance[_from][msg.sender]);
126         // 从授权人帐号中减去一定数量的token
127         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); 
128         // 往接收人帐号中增加一定数量的token
129         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
130         // 从allowance中减去被授权人可使用token的数量
131         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
132         // 交易成功后触发Transfer事件，并返回true
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136  
137     // 消毁币
138     function burn(uint256 _value) public returns (bool success) {
139         // 检查当前帐号余额是否足够
140         assert(balanceOf[msg.sender] >= _value);
141         // 检查_value是否有效
142         assert(_value > 0);
143         // 从sender账户中中减去一定数量的token
144         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
145         // 更新发行币的总量
146         totalSupply = SafeMath.safeSub(totalSupply,_value);
147         // 消币成功后触发Burn事件，并返回true
148         emit Burn(msg.sender, _value);
149         return true;
150     }
151  
152     // 冻结
153     function freeze(uint256 _value) public returns (bool success) {
154         // 检查sender账户余额是否足够
155         assert(balanceOf[msg.sender] >= _value);
156         // 检查_value是否有效
157         assert(_value > 0);
158         // 从sender账户中减去一定数量的token
159         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); 
160         // 往freezeOf中给sender账户增加指定数量的token
161         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); 
162         // freeze成功后触发Freeze事件，并返回true
163         emit Freeze(msg.sender, _value);
164         return true;
165     }
166  
167     // 解冻
168     function unfreeze(uint256 _value) public returns (bool success) {
169         // 检查解冻金额是否有效
170         assert(freezeOf[msg.sender] >= _value);
171         // 检查_value是否有效
172         assert(_value > 0); 
173         // 从freezeOf中减去指定sender账户一定数量的token
174         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); 
175         // 向sender账户中增加一定数量的token
176         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);    
177         // 解冻成功后触发事件
178         emit Unfreeze(msg.sender, _value);
179         return true;
180     }
181  
182     // 管理者自己取钱
183     function withdrawEther(uint256 amount) public {
184         // 检查sender是否是当前合约的管理者
185         assert(msg.sender == owner);
186         // sender给owner发送token
187         owner.transfer(amount);
188     }
189 }