1 pragma solidity ^0.4.23;
2 
3 contract CoinMed // @eachvar
4 {
5     // ======== 初始化代币相关逻辑 ==============
6     // 地址信息
7     address public admin_address = 0x6e68FfF2dC3Bf3aa0e9aCECAae9A3ffE52Fc48ae; // @eachvar
8     address public account_address = 0x6e68FfF2dC3Bf3aa0e9aCECAae9A3ffE52Fc48ae; // @eachvar 初始化后转入代币的地址
9     
10     // 定义账户余额
11     mapping(address => uint256) balances;
12     
13     // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了
14     string public name = "Med Chain"; // @eachvar
15     string public symbol = "MED"; // @eachvar
16     uint8 public decimals = 18; // @eachvar
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
27     }
28 
29     function balanceOf( address _addr ) public view returns ( uint )
30     {
31         return balances[_addr];
32     }
33 
34     // ========== 转账相关逻辑 ====================
35     event Transfer(
36         address indexed from, 
37         address indexed to, 
38         uint256 value
39     ); 
40 
41     function transfer(
42         address _to, 
43         uint256 _value
44     ) 
45     public 
46     returns (bool) 
47     {
48         require(_to != address(0));
49         require(_value <= balances[msg.sender]);
50 
51         balances[msg.sender] = sub(balances[msg.sender],_value);
52 
53             
54 
55         balances[_to] = add(balances[_to], _value);
56         emit Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     // ========= 授权转账相关逻辑 =============
61     
62     mapping (address => mapping (address => uint256)) internal allowed;
63     event Approval(
64         address indexed owner,
65         address indexed spender,
66         uint256 value
67     );
68 
69     function transferFrom(
70         address _from,
71         address _to,
72         uint256 _value
73     )
74     public
75     returns (bool)
76     {
77         require(_to != address(0));
78         require(_value <= balances[_from]);
79         require(_value <= allowed[_from][msg.sender]);
80 
81         balances[_from] = sub(balances[_from], _value);
82         
83         
84         balances[_to] = add(balances[_to], _value);
85         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(
91         address _spender, 
92         uint256 _value
93     ) 
94     public 
95     returns (bool) 
96     {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(
103         address _owner,
104         address _spender
105     )
106     public
107     view
108     returns (uint256)
109     {
110         return allowed[_owner][_spender];
111     }
112 
113     function increaseApproval(
114         address _spender,
115         uint256 _addedValue
116     )
117     public
118     returns (bool)
119     {
120         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
121         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122         return true;
123     }
124 
125     function decreaseApproval(
126         address _spender,
127         uint256 _subtractedValue
128     )
129     public
130     returns (bool)
131     {
132         uint256 oldValue = allowed[msg.sender][_spender];
133 
134         if (_subtractedValue > oldValue) {
135             allowed[msg.sender][_spender] = 0;
136         } 
137         else 
138         {
139             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
140         }
141         
142         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 
146     
147     
148 
149      
150     
151     
152     // ============== admin 相关函数 ==================
153     modifier admin_only()
154     {
155         require(msg.sender==admin_address);
156         _;
157     }
158 
159     function setAdmin( address new_admin_address ) 
160     public 
161     admin_only 
162     returns (bool)
163     {
164         require(new_admin_address != address(0));
165         admin_address = new_admin_address;
166         return true;
167     }
168 
169     
170     // 虽然没有开启直投，但也可能转错钱的，给合约留一个提现口总是好的
171     function withDraw()
172     public
173     admin_only
174     {
175         require(address(this).balance > 0);
176         admin_address.transfer(address(this).balance);
177     }
178         // ======================================
179     /// 默认函数
180     function () external payable
181     {
182                 
183         
184         
185            
186     }
187 
188     // ========== 公用函数 ===============
189     // 主要就是 safemath
190     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
191     {
192         if (a == 0) 
193         {
194             return 0;
195         }
196 
197         c = a * b;
198         assert(c / a == b);
199         return c;
200     }
201 
202     function div(uint256 a, uint256 b) internal pure returns (uint256) 
203     {
204         return a / b;
205     }
206 
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
208     {
209         assert(b <= a);
210         return a - b;
211     }
212 
213     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
214     {
215         c = a + b;
216         assert(c >= a);
217         return c;
218     }
219 
220 }