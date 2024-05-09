1 pragma solidity ^0.4.23;
2 
3 contract CoinOtg // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0xc5259e85f9E3bC882d151D09f475A16B4001aF61; // @eachvar
8     address public account_address = 0xc5259e85f9E3bC882d151D09f475A16B4001aF61; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "欧特股"; // @eachvar
15     string public symbol = "OTG"; // @eachvar
16     uint8 public decimals = 18; // @eachvar
17     uint256 initSupply = 500000000; // @eachvar
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
152     // ========== 代码销毁相关逻辑 ================
153     event Burn(address indexed burner, uint256 value);
154 
155     function burn(uint256 _value) public 
156     {
157         _burn(msg.sender, _value);
158     }
159 
160     function _burn(address _who, uint256 _value) internal 
161     {
162         require(_value <= balances[_who]);
163         
164         balances[_who] = sub(balances[_who], _value);
165 
166             
167 
168         totalSupply = sub(totalSupply, _value);
169         emit Burn(_who, _value);
170         emit Transfer(_who, address(0), _value);
171     }
172     
173     
174     // ============== admin 相关函数 ==================
175     modifier admin_only()
176     {
177         require(msg.sender==admin_address);
178         _;
179     }
180 
181     function setAdmin( address new_admin_address ) 
182     public 
183     admin_only 
184     returns (bool)
185     {
186         require(new_admin_address != address(0));
187         admin_address = new_admin_address;
188         return true;
189     }
190 
191     
192     // 虽然没有开启直投，但也可能转错钱的，给合约留一个提现口总是好的
193     function withDraw()
194     public
195     admin_only
196     {
197         require(address(this).balance > 0);
198         admin_address.transfer(address(this).balance);
199     }
200         // ======================================
201     /// 默认函数
202     function () external payable
203     {
204                 
205         
206         
207            
208     }
209 
210     // ========== 公用函数 ===============
211     // 主要就是 safemath
212     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
213     {
214         if (a == 0) 
215         {
216             return 0;
217         }
218 
219         c = a * b;
220         assert(c / a == b);
221         return c;
222     }
223 
224     function div(uint256 a, uint256 b) internal pure returns (uint256) 
225     {
226         return a / b;
227     }
228 
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
230     {
231         assert(b <= a);
232         return a - b;
233     }
234 
235     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
236     {
237         c = a + b;
238         assert(c >= a);
239         return c;
240     }
241 
242 }