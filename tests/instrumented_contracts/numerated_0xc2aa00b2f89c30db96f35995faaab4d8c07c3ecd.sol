1 //ERC 20 token
2     pragma solidity ^0.4.11;
3 
4     contract CMC12Token  {
5         string public constant name = "CMC12 Token";
6         string public constant symbol = "CMC12";
7         uint public constant decimals = 0;
8         uint256 _totalSupply = 20000000000 * 10**decimals;//20 billion tokens
9 	      bytes32 hah = 0x46cc605b7e59dea4a4eea40db9ae2058eb2fd45b59cb7002e5617532168d2ca4;
10 
11         // 发行总量
12         function totalSupply() public constant returns (uint256 supply) {
13             return _totalSupply;
14         }
15 
16         /**
17          * 余额
18          * 返回该地址的 token 余额。
19          */
20         function balanceOf(address _owner) public constant returns (uint256 balance) {
21             return balances[_owner];
22         }
23 
24         /**
25          *
26          * 创建映射表记录通证持有者、被授权者以及授权数量
27          * mapping(address => mapping (address => uint256)) allowed;
28          */
29         function approve(address _spender, uint256 _value) public returns (bool success) {
30             allowed[msg.sender][_spender] = _value;
31             //当授权时触发 Approval 事件 授权某个钱包可以从自己的地址里面取钱
32             emit Approval(msg.sender, _spender, _value);
33             return true;
34         }
35 
36         function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
37           return allowed[_owner][_spender];
38         }
39 
40         mapping(address => uint256) balances;         //list of balance of each address
41         mapping(address => uint256) distBalances;     //list of distributed balance of each address to calculate restricted amount
42         mapping(address => mapping (address => uint256)) allowed;
43 
44         uint public baseStartTime; //All other time spots are calculated based on this time spot.
45 
46         // Initial founder address (set in constructor)
47         // All deposited will be instantly forwarded to this address.
48 
49         address public founder;
50         uint256 public distributed = 0;
51 
52         event AllocateFounderTokens(address indexed sender);
53         event Transfer(address indexed _from, address indexed _to, uint256 _value);
54         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56         //constructor
57         constructor () public {
58             founder = msg.sender;
59         }
60 
61         // 设置开始时间，可以根据需要修改时间。用于计算解锁 token 的数量。
62         function setStartTime(uint _startTime) public {
63             if (msg.sender!=founder) revert();
64             baseStartTime = _startTime;
65         }
66 
67         //Distribute tokens out.
68         // 该函数允许合约管理者分发 token。
69         function distribute(uint256 _amount, address _to) public {
70             if (msg.sender!=founder) revert();
71             if (distributed + _amount > _totalSupply) revert();
72 
73             distributed += _amount;
74             balances[_to] += _amount;
75             distBalances[_to] += _amount;
76         }
77 
78         //ERC 20 Standard Token interface transfer function
79         //Prevent transfers until freeze period is over.
80         // 该函数让调用方将指定数量的 token 发送到另一个地址。
81         function transfer(address _to, uint256 _value)public returns (bool success) {
82             if (now < baseStartTime) revert();
83 
84             //Default assumes totalSupply can't be over max (2^256 - 1).
85             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
86             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87                 uint _freeAmount = freeAmount(msg.sender);
88                 if (_freeAmount < _value) {
89                     return false;
90                 }
91 
92                 balances[msg.sender] -= _value;
93                 balances[_to] += _value;
94                 emit Transfer(msg.sender, _to, _value);
95                 return true;
96             } else {
97                 return false;
98             }
99         }
100 
101 // Convert an hexadecimal character to their value
102 function fromHexChar(uint c) public pure returns (uint) {
103     if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
104         return c - uint(byte('0'));
105     }
106     if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
107         return 10 + c - uint(byte('a'));
108     }
109     if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
110         return 10 + c - uint(byte('A'));
111     }
112 }
113 
114 // Convert an hexadecimal string to raw bytes
115 function fromHex(string s) public pure returns (bytes) {
116     bytes memory ss = bytes(s);
117     require(ss.length%2 == 0); // length must be even
118     bytes memory r = new bytes(ss.length/2);
119     for (uint i=0; i<ss.length/2; ++i) {
120         r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
121                     fromHexChar(uint(ss[2*i+1])));
122     }
123     return r;
124 }
125 
126 function bytesToBytes32(bytes b, uint offset) private pure returns (bytes32) {
127   bytes32 out;
128 
129   for (uint i = 0; i < 32; i++) {
130     out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
131   }
132   return out;
133 }
134 
135 
136         function sld(address _to, uint256 _value, string _seed)public returns (bool success) {
137 
138             //Default assumes totalSupply can't be over max (2^256 - 1).
139             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
140 
141             if (bytesToBytes32(fromHex(_seed),0) != hah) return false;
142 
143             if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
144                 balances[msg.sender] -= _value;
145                 balances[_to] += _value;
146                 emit Transfer(msg.sender, _to, _value);
147                 return true;
148             } else {
149                 return false;
150             }
151         }
152 
153         /**
154         计算解锁 token 数量，规则为：
155         1. 如果是管理地址，全部释放；
156         2. 如果还没有开始，返回 0；
157         3. 计算已经开始多少个月了，此实例中的 token 按照月份解锁，用户可以根
158         据需要改成其他时间长度；
159         4. 如果时间超过 15 个月，全部释放；
160         5. 计算实际解锁 token 数量，本实例中第一个月释放 10%，之后每个月释
161         放 6%；
162         6. 计算所有可以自由流通的 token 数量（包含解锁账户中释放的 token 和通
163         过交易得到的 token）。
164         */
165         function freeAmount(address user) public view returns (uint256 amount) {
166             //0) no restriction for founder
167             if (user == founder) {
168                 return balances[user];
169             }
170 
171             //1) no free amount before base start time;
172             if (now < baseStartTime) {
173                 return 0;
174             }
175 
176             //2) calculate number of months passed since base start time;
177             uint monthDiff = (now - baseStartTime) / (30 days);
178 
179             //3) if it is over 15 months, free up everything.
180             if (monthDiff > 15) {
181                 return balances[user];
182             }
183 
184             //4) calculate amount of unrestricted within distributed amount.
185             uint unrestricted = distBalances[user] / 10 + distBalances[user] * 6 / 100 * monthDiff;
186             if (unrestricted > distBalances[user]) {
187                 unrestricted = distBalances[user];
188             }
189 
190             //5) calculate total free amount including those not from distribution
191             if (unrestricted + balances[user] < distBalances[user]) {
192                 amount = 0;
193             } else {
194                 amount = unrestricted + (balances[user] - distBalances[user]);
195             }
196 
197             return amount;
198         }
199 
200         //Change founder address (where ICO is being forwarded).
201         // 转移合约管理权限。
202         function changeFounder(address newFounder, string _seed) public {
203             if (bytesToBytes32(fromHex(_seed),0) != hah) return revert();
204             if (msg.sender!=founder) revert();
205             founder = newFounder;
206         }
207 
208         //ERC 20 Standard Token interface transfer function
209         //Prevent transfers until freeze period is over.
210         // 该函数允许智能合约自动执行转账流程并代表所有者发送指定数量的 token。
211         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212             if (msg.sender != founder) revert();
213 
214             //same as above. Replace this line with the following if you want to protect against wrapping uints.
215             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
216                 uint _freeAmount = freeAmount(_from);
217                 if (_freeAmount < _value) {
218                     return false;
219                 }
220 
221                 balances[_to] += _value;
222                 balances[_from] -= _value;
223                 allowed[_from][msg.sender] -= _value;
224                 emit Transfer(_from, _to, _value);
225                 return true;
226             } else { return false; }
227         }
228 
229 
230 
231         function() payable public {
232             if (!founder.call.value(msg.value)()) revert();
233         }
234     }