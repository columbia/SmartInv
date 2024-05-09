1 pragma solidity ^0.4.24;
2 
3 //SafeMath库，用于防止数据溢出等安全漏洞
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 //下面是一个标准的ERC20合约
39 contract ERC20  {
40   //使用SafeMath防止数据溢出
41   using SafeMath for uint256;
42   //总发行量
43   uint256 totalSupply_;
44   //用户token余额
45   mapping(address => uint256) balances;
46   //授权token转移
47   mapping (address => mapping (address => uint256)) internal allowed;
48   
49   //token转移事件
50   event Transfer(address indexed from, address indexed to, uint256 value);
51   
52   //token授权事件
53   event Approval(
54     address indexed owner,
55     address indexed spender,
56     uint256 value
57   );
58   
59   //查询token总发行量
60   function totalSupply() public view returns (uint256) {
61     return totalSupply_;
62   }
63   
64   //token转移
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     //检查余额
68     require(_value <= balances[msg.sender]);
69     //转移token到目标地址
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     emit Transfer(msg.sender, _to, _value);
73     return true;
74   }
75   
76   //查询余额
77   function balanceOf(address _owner) public view returns (uint256) {
78     return balances[_owner];
79   }
80   
81   //代为转移token，前提是已获得他人授权
82   function transferFrom(address _from, address _to,
83     uint256 _value ) public returns (bool) {
84     require(_to != address(0));
85     //检查余额是否足够
86     require(_value <= balances[_from]);
87     //检查是否已获得转移token的授权
88     require(_value <= allowed[_from][msg.sender]);
89     //转移指定账户的token到目标账户
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93     emit Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   //授权指定数量的token转移权限给某个地址
98   function approve(address _spender, uint256 _value) public returns (bool) {
99     allowed[msg.sender][_spender] = _value;
100     emit Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   //查询授权token转移的数量
105   function allowance( address _owner, address _spender) 
106   public view returns (uint256)  {
107     return allowed[_owner][_spender];
108   }
109 
110   //增加授权转移token的数量
111   function increaseApproval(address _spender,
112     uint256 _addedValue)
113     public returns (bool) {
114     allowed[msg.sender][_spender] = (
115       allowed[msg.sender][_spender].add(_addedValue));
116     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119   
120   //减少授权转移Token的数量
121   function decreaseApproval(address _spender,
122     uint256 _subtractedValue)
123     public returns (bool) {
124     uint256 oldValue = allowed[msg.sender][_spender];
125     if (_subtractedValue > oldValue) {
126       allowed[msg.sender][_spender] = 0;
127     } else {
128       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
129     }
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 }
134 
135 
136 // 以下合约拓展ERC20标准，增加了一些特定的功能，如增发、锁定等。
137 contract NewToken is ERC20 {
138     address public admin; // 管理员
139     string public name = "AARK"; // 代币名称
140     string public symbol = "AARK"; // 代币符号
141     uint8 public decimals = 18; // 代币精度
142     uint256 public INITIAL_SUPPLY = 0; // 发行总量
143 
144 
145     //只能由积分发行方调用
146     modifier onlyAdmin(){
147         if (msg.sender == admin) _;
148     }
149 
150     // 构造函数
151     constructor(uint256 _INITIAL_SUPPLY,
152                 string _name,
153                 string _symbol,
154                 address _admin) public {
155         require(_INITIAL_SUPPLY>0);
156         name = _name;
157         symbol = _symbol;
158         INITIAL_SUPPLY = _INITIAL_SUPPLY;
159         totalSupply_ = INITIAL_SUPPLY;
160         admin = _admin;
161         balances[admin] = INITIAL_SUPPLY;
162     }
163 
164 
165 
166     //修改管理员
167     function changeAdmin( address _newAdmin )
168     onlyAdmin public returns (bool)  {
169         balances[_newAdmin] = balances[_newAdmin].add(balances[admin]);
170         balances[admin] = 0;
171         admin = _newAdmin;
172         return true;
173     }
174     // 增发
175     function generateToken( address _target, uint256 _amount)
176     onlyAdmin public returns (bool)  {
177         balances[_target] = balances[_target].add(_amount);
178         totalSupply_ = totalSupply_.add(_amount);
179         INITIAL_SUPPLY = totalSupply_;
180         return true;
181     }
182 
183 
184     //批量转账
185     function multiTransfer( address[] _tos, uint256[] _values)
186     public returns (bool) {
187 
188         require(_tos.length == _values.length);
189         uint256 len = _tos.length;
190         require(len > 0);
191         uint256 amount = 0;
192         for (uint256 i = 0; i < len; i = i.add(1)) {
193             amount = amount.add(_values[i]);
194         }
195         require(amount <= balances[msg.sender]);
196         for (uint256 j = 0; j < len; j = j.add(1)) {
197             address _to = _tos[j];
198             require(_to != address(0));
199             balances[_to] = balances[_to].add(_values[j]);
200             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
201             emit Transfer(msg.sender, _to, _values[j]);
202         }
203         return true;
204     }
205 
206     //从调用者转账至_to
207     function transfer(address _to, uint256 _value )
208     public returns (bool) {
209 
210         require(_to != address(0));
211         require(_value <= balances[msg.sender]);
212 
213         balances[msg.sender] = balances[msg.sender].sub(_value);
214         balances[_to] = balances[_to].add(_value);
215 
216         emit Transfer(msg.sender, _to, _value);
217         return true;
218     }
219 
220     //从调用者作为from代理将from账户中的token转账至to
221     //调用者在from的许可额度中必须>=value
222     function transferFrom(address _from,address _to,
223     uint256 _value)
224     public returns (bool)
225     {
226 
227         require(_to != address(0));
228         require(_value <= balances[_from]);
229         require(_value <= allowed[_from][msg.sender]);
230 
231         balances[_from] = balances[_from].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234 
235         emit Transfer(_from, _to, _value);
236         return true;
237     }
238 
239 
240     
241 
242     
243     // 修改name
244     function setName ( string _value )
245     onlyAdmin  public returns (bool) {
246         name = _value;
247         return true;
248     }
249     
250     // 修改symbol
251     function setSymbol ( string _value )
252     onlyAdmin public returns (bool) {
253         symbol = _value;
254         return true;
255     }
256 
257 
258     
259 
260 
261 
262 }