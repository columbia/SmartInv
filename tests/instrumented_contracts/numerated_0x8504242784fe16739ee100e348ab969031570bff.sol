1 /*
2 @TrueTone_network TrueTone NETWORK
3 
4 Send 0.01 Ether to Contract address for receive 150,000 TTN
5 */
6 
7 pragma solidity ^0.4.22;
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ForeignToken {
34     function balanceOf(address _owner) constant public returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Token { 
53     function distr(address _to, uint256 _value) external returns (bool);
54     function totalSupply() constant external returns (uint256 supply);
55     function balanceOf(address _owner) constant external returns (uint256 balance);
56 }
57 
58 contract TrueTone_network is ERC20 {
59     
60     using SafeMath for uint256;
61     address owner = msg.sender;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     mapping (address => bool) public blacklist;
66 
67     string public constant name = "TrueTone_network";
68     string public constant symbol = "TTN";
69     uint public constant decimals = 18;
70     
71     uint256 public totalSupply = 25000000000e18;
72     uint256 public totalDistributed = 25000000000e18;
73     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
74     uint256 public value = 25000000000e18;
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78     
79     event Distr(address indexed to, uint256 amount);
80     event DistrFinished();
81     
82     event Burn(address indexed burner, uint256 value);
83 
84     bool public distributionFinished = false;
85     
86     modifier canDistr() {
87         require(!distributionFinished);
88         _;
89     }
90     
91     modifier onlyOwner() {
92         require(msg.sender == owner);
93         _;
94     }
95     
96     modifier onlyWhitelist() {
97         require(blacklist[msg.sender] == false);
98         _;
99     }
100     
101     function TodaNetwork() public {
102         owner = msg.sender;
103         balances[owner] = totalDistributed;
104     }
105     
106     function transferOwnership(address newOwner) onlyOwner public {
107         if (newOwner != address(0)) {
108             owner = newOwner;
109         }
110     }
111     
112     function finishDistribution() onlyOwner canDistr public returns (bool) {
113         distributionFinished = true;
114         emit DistrFinished();
115         return true;
116     }
117     
118     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
119         totalDistributed = totalDistributed.add(_amount);
120         totalRemaining = totalRemaining.sub(_amount);
121         balances[_to] = balances[_to].add(_amount);
122         emit Distr(_to, _amount);
123         emit Transfer(address(0), _to, _amount);
124         return true;
125         
126         if (totalDistributed >= totalSupply) {
127             distributionFinished = true;
128         }
129     }
130     
131     function () external payable {
132         getTokens();
133      }
134     
135     function getTokens() payable canDistr onlyWhitelist public {
136         if (value > totalRemaining) {
137             value = totalRemaining;
138         }
139         
140         require(value <= totalRemaining);
141         
142         address investor = msg.sender;
143         uint256 toGive = value;
144         
145         distr(investor, toGive);
146         
147         if (toGive > 0) {
148             blacklist[investor] = true;
149         }
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154         
155         value = value.div(5000).mul(5000);
156     }
157 
158     function balanceOf(address _owner) constant public returns (uint256) {
159         return balances[_owner];
160     }
161 
162     modifier onlyPayloadSize(uint size) {
163         assert(msg.data.length >= size + 4);
164         _;
165     }
166     
167     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
168         require(_to != address(0));
169         require(_amount <= balances[msg.sender]);
170         
171         balances[msg.sender] = balances[msg.sender].sub(_amount);
172         balances[_to] = balances[_to].add(_amount);
173         emit Transfer(msg.sender, _to, _amount);
174         return true;
175     }
176     
177     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
178         require(_to != address(0));
179         require(_amount <= balances[_from]);
180         require(_amount <= allowed[_from][msg.sender]);
181         
182         balances[_from] = balances[_from].sub(_amount);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
184         balances[_to] = balances[_to].add(_amount);
185         emit Transfer(_from, _to, _amount);
186         return true;
187     }
188     
189     function approve(address _spender, uint256 _value) public returns (bool success) {
190         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
191         allowed[msg.sender][_spender] = _value;
192         emit Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     function allowance(address _owner, address _spender) constant public returns (uint256) {
197         return allowed[_owner][_spender];
198     }
199     
200     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
201         ForeignToken t = ForeignToken(tokenAddress);
202         uint bal = t.balanceOf(who);
203         return bal;
204     }
205     
206     function withdraw() onlyOwner public {
207         uint256 etherBalance = address(this).balance;
208         owner.transfer(etherBalance);
209     }
210     
211     function burn(uint256 _value) onlyOwner public {
212         require(_value <= balances[msg.sender]);
213 
214         address burner = msg.sender;
215         balances[burner] = balances[burner].sub(_value);
216         totalSupply = totalSupply.sub(_value);
217         totalDistributed = totalDistributed.sub(_value);
218         emit Burn(burner, _value);
219     }
220     
221     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
222         ForeignToken token = ForeignToken(_tokenContract);
223         uint256 amount = token.balanceOf(address(this));
224         return token.transfer(owner, amount);
225     }
226 }