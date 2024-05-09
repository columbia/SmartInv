1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() constant external returns (uint256 supply);
49     function balanceOf(address _owner) constant external returns (uint256 balance);
50 }
51 
52 contract GemsPlay is ERC20 {
53 
54  
55     
56     using SafeMath for uint256;
57     address owner = msg.sender;
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     mapping (address => bool) public blacklist;
62 
63     string public constant name = "GemsPlay";
64     string public constant symbol = "XGP";
65     uint public constant decimals = 8;
66     
67 uint256 public totalSupply = 100000000000e8;
68     
69 uint256 public totalDistributed = 50000000000e8;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public value = 1000000e8;
74 
75 
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     
80     event Distr(address indexed to, uint256 amount);
81     event DistrFinished();
82     
83     event Burn(address indexed burner, uint256 value);
84 
85     bool public distributionFinished = false;
86     
87     modifier canDistr() {
88         require(!distributionFinished);
89         _;
90     }
91     
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     modifier onlyWhitelist() {
98         require(blacklist[msg.sender] == false);
99         _;
100     }
101     
102     function GemsPlay() public {
103         owner = msg.sender;
104         balances[owner] = totalDistributed;
105     }
106     
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
112     
113     function finishDistribution() onlyOwner canDistr public returns (bool) {
114         distributionFinished = true;
115         emit DistrFinished();
116         return true;
117     }
118     
119     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
120         totalDistributed = totalDistributed.add(_amount);
121         totalRemaining = totalRemaining.sub(_amount);
122         balances[_to] = balances[_to].add(_amount);
123         emit Distr(_to, _amount);
124         emit Transfer(address(0), _to, _amount);
125         return true;
126         
127         if (totalDistributed >= totalSupply) {
128             distributionFinished = true;
129         }
130     }
131     
132     function () external payable {
133         getTokens();
134      }
135     
136     function getTokens() payable canDistr onlyWhitelist public {
137         if (value > totalRemaining) {
138             value = totalRemaining;
139         }
140         
141         require(value <= totalRemaining);
142         
143         address investor = msg.sender;
144         uint256 toGive = value;
145         
146         distr(investor, toGive);
147         
148         if (toGive > 0) {
149             blacklist[investor] = true;
150         }
151 
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155         
156         value = value.div(10000).mul(10000);
157     }
158 
159     function balanceOf(address _owner) constant public returns (uint256) {
160         return balances[_owner];
161     }
162 
163     modifier onlyPayloadSize(uint size) {
164         assert(msg.data.length >= size + 4);
165         _;
166     }
167     
168     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
169         require(_to != address(0));
170         require(_amount <= balances[msg.sender]);
171         
172         balances[msg.sender] = balances[msg.sender].sub(_amount);
173         balances[_to] = balances[_to].add(_amount);
174         emit Transfer(msg.sender, _to, _amount);
175         return true;
176     }
177     
178     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
179         require(_to != address(0));
180         require(_amount <= balances[_from]);
181         require(_amount <= allowed[_from][msg.sender]);
182         
183         balances[_from] = balances[_from].sub(_amount);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
185         balances[_to] = balances[_to].add(_amount);
186         emit Transfer(_from, _to, _amount);
187         return true;
188     }
189     
190     function approve(address _spender, uint256 _value) public returns (bool success) {
191         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
192         allowed[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196     
197     function allowance(address _owner, address _spender) constant public returns (uint256) {
198         return allowed[_owner][_spender];
199     }
200     
201     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
202         ForeignToken t = ForeignToken(tokenAddress);
203         uint bal = t.balanceOf(who);
204         return bal;
205     }
206     
207     function withdraw() onlyOwner public {
208         uint256 etherBalance = address(this).balance;
209         owner.transfer(etherBalance);
210     }
211     
212     function burn(uint256 _value) onlyOwner public {
213         require(_value <= balances[msg.sender]);
214 
215         address burner = msg.sender;
216         balances[burner] = balances[burner].sub(_value);
217         totalSupply = totalSupply.sub(_value);
218         totalDistributed = totalDistributed.sub(_value);
219         emit Burn(burner, _value);
220     }
221     
222     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
223         ForeignToken token = ForeignToken(_tokenContract);
224         uint256 amount = token.balanceOf(address(this));
225         return token.transfer(owner, amount);
226     }
227 }