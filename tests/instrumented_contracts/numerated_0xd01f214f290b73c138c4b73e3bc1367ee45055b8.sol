1 pragma solidity ^0.4.23;
2 
3 contract CoinMeb // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x5E9b9d10247A7C5638a9BCdea4bf55981496eAa3; // @eachvar
8     address public account_address = 0x5E9b9d10247A7C5638a9BCdea4bf55981496eAa3; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "MIEX全球通用积分系统"; // @eachvar
15     string public symbol = "MEB"; // @eachvar
16     uint8 public decimals = 8; // @eachvar
17     uint256 initSupply = 210000000; // @eachvar
18     uint256 public totalSupply = 0; // @eachvar
19 
20     // 生成代币，并转入到 account_address 地址
21     constructor() 
22     payable 
23     public
24     {
25         totalSupply = mul(initSupply, 10**uint256(decimals));
26         balances[account_address] = totalSupply;
27 
28         
29     }
30 
31     function balanceOf( address _addr ) public view returns ( uint )
32     {
33         return balances[_addr];
34     }
35 
36     // ========== 转账相关逻辑 ====================
37     event Transfer(
38         address indexed from, 
39         address indexed to, 
40         uint256 value
41     ); 
42 
43     function transfer(
44         address _to, 
45         uint256 _value
46     ) 
47     public 
48     returns (bool) 
49     {
50         require(_to != address(0));
51         require(_value <= balances[msg.sender]);
52 
53         balances[msg.sender] = sub(balances[msg.sender],_value);
54 
55             
56 
57         balances[_to] = add(balances[_to], _value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     // ========= 授权转账相关逻辑 =============
63     
64     mapping (address => mapping (address => uint256)) internal allowed;
65     event Approval(
66         address indexed owner,
67         address indexed spender,
68         uint256 value
69     );
70 
71     function transferFrom(
72         address _from,
73         address _to,
74         uint256 _value
75     )
76     public
77     returns (bool)
78     {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82 
83         balances[_from] = sub(balances[_from], _value);
84         
85         
86         balances[_to] = add(balances[_to], _value);
87         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
88         emit Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(
93         address _spender, 
94         uint256 _value
95     ) 
96     public 
97     returns (bool) 
98     {
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(
105         address _owner,
106         address _spender
107     )
108     public
109     view
110     returns (uint256)
111     {
112         return allowed[_owner][_spender];
113     }
114 
115     function increaseApproval(
116         address _spender,
117         uint256 _addedValue
118     )
119     public
120     returns (bool)
121     {
122         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
123         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 
127     function decreaseApproval(
128         address _spender,
129         uint256 _subtractedValue
130     )
131     public
132     returns (bool)
133     {
134         uint256 oldValue = allowed[msg.sender][_spender];
135 
136         if (_subtractedValue > oldValue) {
137             allowed[msg.sender][_spender] = 0;
138         } 
139         else 
140         {
141             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
142         }
143         
144         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147 
148     
149     
150 
151      
152     
153     
154     // ============== admin 相关函数 ==================
155     modifier admin_only()
156     {
157         require(msg.sender==admin_address);
158         _;
159     }
160 
161     function setAdmin( address new_admin_address ) 
162     public 
163     admin_only 
164     returns (bool)
165     {
166         require(new_admin_address != address(0));
167         admin_address = new_admin_address;
168         return true;
169     }
170 
171     
172     // 虽然没有开启直投，但也可能转错钱的，给合约留一个提现口总是好的
173     function withDraw()
174     public
175     admin_only
176     {
177         require(address(this).balance > 0);
178         admin_address.transfer(address(this).balance);
179     }
180         // ======================================
181     /// 默认函数
182     function () external payable
183     {
184                 
185         
186         
187            
188     }
189 
190     // ========== 公用函数 ===============
191     // 主要就是 safemath
192     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
193     {
194         if (a == 0) 
195         {
196             return 0;
197         }
198 
199         c = a * b;
200         assert(c / a == b);
201         return c;
202     }
203 
204     function div(uint256 a, uint256 b) internal pure returns (uint256) 
205     {
206         return a / b;
207     }
208 
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
210     {
211         assert(b <= a);
212         return a - b;
213     }
214 
215     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
216     {
217         c = a + b;
218         assert(c >= a);
219         return c;
220     }
221 
222 }