1 pragma solidity ^0.4.22;
2 
3 //防止溢出
4 library SafeMath {
5 //乘以
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11   
12  //除以
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 //减
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 	//加
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ForeignToken {
31     function balanceOf(address _owner) constant public returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 }
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 
50 contract MOT is ERC20 {
51     
52     using SafeMath for uint256;
53 	//拥有者
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 	//黑名单
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "MOT";
62     string public constant symbol = "MOT";
63     uint public constant decimals = 18;
64     
65     uint256 public totalSupply = 100000000e18;
66 	//分配的数量
67     uint256 public totalDistributed = 20000000e18;
68 	//余额 = 总量减去已经分配出去的
69     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
70 	
71     uint256 public value = 1500e18;
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     
76     event Distr(address indexed to, uint256 amount);
77     event DistrFinished();
78     
79     event Burn(address indexed burner, uint256 value);
80 
81 	//分配完成
82     bool public distributionFinished = false;
83     
84 	//是否可以分配
85     modifier canDistr() {
86         require(!distributionFinished);
87         _;
88     }
89     //仅仅拥有者 
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94     //判断是否在白名单
95     modifier onlyWhitelist() {
96         require(blacklist[msg.sender] == false);
97         _;
98     }
99     
100 	//构造方法
101      constructor() public {
102         owner = msg.sender;
103 		//把设定好的数量分配给创建者
104         balances[owner] = totalDistributed;
105     }
106     //设置拥有者
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
112     //完成分配
113     function finishDistribution() onlyOwner canDistr public returns (bool) {
114         distributionFinished = true;
115         emit DistrFinished();
116         return true;
117     }
118     //分配
119     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
120         totalDistributed = totalDistributed.add(_amount);
121         totalRemaining = totalRemaining.sub(_amount);
122         balances[_to] = balances[_to].add(_amount);
123         emit Distr(_to, _amount);
124         emit Transfer(address(0), _to, _amount);
125         return true;
126         
127 		//分配的数量大于或者等于总量的时候设置分配结束
128         if (totalDistributed >= totalSupply) {
129             distributionFinished = true;
130         }
131     }
132     
133     function () external payable {
134         getTokens();
135      }
136     
137 	//获取token 没有分配结束，并且没有获取过。
138     function getTokens() payable canDistr onlyWhitelist public {
139         if (value > totalRemaining) {
140             value = totalRemaining;
141         }
142         
143         require(value <= totalRemaining);
144         
145 		//分配给谁的
146         address investor = msg.sender;
147 		//分配的数量
148         uint256 toGive = value;
149         
150 		//分配
151         distr(investor, toGive);
152         
153         if (toGive > 0) {
154             blacklist[investor] = true;
155         }
156 
157         if (totalDistributed >= totalSupply) {
158             distributionFinished = true;
159         }
160         
161         value = value.div(100000).mul(99999);
162     }
163 
164     function balanceOf(address _owner) constant public returns (uint256) {
165         return balances[_owner];
166     }
167 
168     modifier onlyPayloadSize(uint size) {
169         assert(msg.data.length >= size + 4);
170         _;
171     }
172     
173     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
174         require(_to != address(0));
175         require(_amount <= balances[msg.sender]);
176         
177         balances[msg.sender] = balances[msg.sender].sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         emit Transfer(msg.sender, _to, _amount);
180         return true;
181     }
182     
183     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
184         require(_to != address(0));
185         require(_amount <= balances[_from]);
186         require(_amount <= allowed[_from][msg.sender]);
187         
188         balances[_from] = balances[_from].sub(_amount);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
190         balances[_to] = balances[_to].add(_amount);
191         emit Transfer(_from, _to, _amount);
192         return true;
193     }
194     
195     function approve(address _spender, uint256 _value) public returns (bool success) {
196         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201     
202     function allowance(address _owner, address _spender) constant public returns (uint256) {
203         return allowed[_owner][_spender];
204     }
205     //获取某一个token的余额
206     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
207         ForeignToken t = ForeignToken(tokenAddress);
208         uint bal = t.balanceOf(who);
209         return bal;
210     }
211     //提取eth
212     function withdraw() onlyOwner public {
213         uint256 etherBalance = address(this).balance;
214         owner.transfer(etherBalance);
215     }
216     //销毁多少个代币
217     function burn(uint256 _value) onlyOwner public {
218         require(_value <= balances[msg.sender]);
219 
220         address burner = msg.sender;
221         balances[burner] = balances[burner].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         totalDistributed = totalDistributed.sub(_value);
224         emit Burn(burner, _value);
225     }
226     
227 	//提取代币
228     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
229         ForeignToken token = ForeignToken(_tokenContract);
230         uint256 amount = token.balanceOf(address(this));
231         return token.transfer(owner, amount);
232     }
233 }