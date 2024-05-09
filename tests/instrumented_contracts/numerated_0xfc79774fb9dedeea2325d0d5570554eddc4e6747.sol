1 pragma solidity ^0.4.22;
2 
3 // ==> Token Price 0.00001 ETH
4 // ==> Send 0 ETH to claim free VPC0x
5 // ==> If you send above 0.02 ETH you will receive VPC0x and fill in the form here https://goo.gl/NzznV9
6 // ==> Vote Your Token for Pumps with VPC0x
7 // ==> Website https://votepumpcoin.me
8 // ==> Telegram Channel : https://t.me/VPC0x
9 
10 
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract VotePumpCoin0xToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 interface Token { 
56     function distr(address _to, uint256 _value) external returns (bool);
57     function totalSupply() constant external returns (uint256 supply);
58     function balanceOf(address _owner) constant external returns (uint256 balance);
59 }
60 
61 contract VotePumpCoin0x is ERC20 {
62 
63  
64     
65     using SafeMath for uint256;
66     address owner = msg.sender;
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     mapping (address => bool) public blacklist;
71 
72     string public constant name = "VotePumpCoin0x";
73     string public constant symbol = "VPC0x";
74     uint public constant decimals = 18;
75     
76 uint256 public totalSupply = 75000000e18;
77     
78 uint256 public totalDistributed = 45000000e18;
79     
80 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
81     
82 uint256 public value = 200e18;
83 
84 
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91     
92     event Burn(address indexed burner, uint256 value);
93 
94 bool public distributionFinished = false;
95     
96     modifier canDistr() {
97         require(!distributionFinished);
98         _;
99     }
100     
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105     
106     modifier onlyWhitelist() {
107         require(blacklist[msg.sender] == false);
108         _;
109     }
110     
111     function VPC0x() public {
112         owner = msg.sender;
113         balances[owner] = totalDistributed;
114     }
115     
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121     
122     function finishDistribution() onlyOwner canDistr public returns (bool) {
123         distributionFinished = true;
124         emit DistrFinished();
125         return true;
126     }
127     
128     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
129         totalDistributed = totalDistributed.add(_amount);
130         totalRemaining = totalRemaining.sub(_amount);
131         balances[_to] = balances[_to].add(_amount);
132         emit Distr(_to, _amount);
133         emit Transfer(address(0), _to, _amount);
134         return true;
135         
136         if (totalDistributed >= totalSupply) {
137             distributionFinished = true;
138         }
139     }
140     
141     function () external payable {
142         getTokens();
143      }
144     
145     function getTokens() payable canDistr onlyWhitelist public {
146         if (value > totalRemaining) {
147             value = totalRemaining;
148         }
149         
150         require(value <= totalRemaining);
151         
152         address investor = msg.sender;
153         uint256 toGive = value;
154         
155         distr(investor, toGive);
156         
157         if (toGive > 0) {
158             blacklist[investor] = true;
159         }
160 
161         if (totalDistributed >= totalSupply) {
162             distributionFinished = true;
163         }
164         
165         value = value.div(100000).mul(99999);
166     }
167 
168     function balanceOf(address _owner) constant public returns (uint256) {
169         return balances[_owner];
170     }
171 
172     modifier onlyPayloadSize(uint size) {
173         assert(msg.data.length >= size + 4);
174         _;
175     }
176     
177     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
178         require(_to != address(0));
179         require(_amount <= balances[msg.sender]);
180         
181         balances[msg.sender] = balances[msg.sender].sub(_amount);
182         balances[_to] = balances[_to].add(_amount);
183         emit Transfer(msg.sender, _to, _amount);
184         return true;
185     }
186     
187     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
188         require(_to != address(0));
189         require(_amount <= balances[_from]);
190         require(_amount <= allowed[_from][msg.sender]);
191         
192         balances[_from] = balances[_from].sub(_amount);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         emit Transfer(_from, _to, _amount);
196         return true;
197     }
198     
199     function approve(address _spender, uint256 _value) public returns (bool success) {
200         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205     
206     function allowance(address _owner, address _spender) constant public returns (uint256) {
207         return allowed[_owner][_spender];
208     }
209     
210     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
211         VotePumpCoin0xToken t = VotePumpCoin0xToken(tokenAddress);
212         uint bal = t.balanceOf(who);
213         return bal;
214     }
215     
216     function withdraw() onlyOwner public {
217         uint256 etherBalance = address(this).balance;
218         owner.transfer(etherBalance);
219     }
220     
221     function burn(uint256 _value) onlyOwner public {
222         require(_value <= balances[msg.sender]);
223 
224 address burner = msg.sender;
225         balances[burner] = balances[burner].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227         totalDistributed = totalDistributed.sub(_value);
228         emit Burn(burner, _value);
229     }
230     
231     function withdrawVPC0xTokens(address _tokenContract) onlyOwner public returns (bool) {
232         VotePumpCoin0xToken token = VotePumpCoin0xToken(_tokenContract);
233         uint256 amount = token.balanceOf(address(this));
234         return token.transfer(owner, amount);
235     }
236 }