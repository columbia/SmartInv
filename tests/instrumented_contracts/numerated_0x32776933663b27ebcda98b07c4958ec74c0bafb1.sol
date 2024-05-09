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
52 contract EDD is ERC20 {
53 
54     //15% for BD 
55     //15% for Community
56     //20% for Team Lock 2year
57     //50% for Airdrop
58     
59     using SafeMath for uint256;
60     address owner = msg.sender;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     mapping (address => bool) public blacklist;
65 
66     string public constant name = "eddbit";
67     string public constant symbol = "EDD";
68     uint public constant decimals = 18;
69     
70     uint256 public totalSupply = 100000000e18;
71     uint256 public totalDistributed = 50000000e18;
72     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
73     uint256 public value = 500e18;
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77     
78     event Distr(address indexed to, uint256 amount);
79     event DistrFinished();
80     
81     event Burn(address indexed burner, uint256 value);
82 
83     bool public distributionFinished = false;
84     
85     modifier canDistr() {
86         require(!distributionFinished);
87         _;
88     }
89     
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94     
95     modifier onlyWhitelist() {
96         require(blacklist[msg.sender] == false);
97         _;
98     }
99     
100     function EDD() public {
101         owner = msg.sender;
102         balances[owner] = totalDistributed;
103     }
104     
105     function transferOwnership(address newOwner) onlyOwner public {
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110     
111     function finishDistribution() onlyOwner canDistr public returns (bool) {
112         distributionFinished = true;
113         emit DistrFinished();
114         return true;
115     }
116     
117     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
118         totalDistributed = totalDistributed.add(_amount);
119         totalRemaining = totalRemaining.sub(_amount);
120         balances[_to] = balances[_to].add(_amount);
121         emit Distr(_to, _amount);
122         emit Transfer(address(0), _to, _amount);
123         return true;
124         
125         if (totalDistributed >= totalSupply) {
126             distributionFinished = true;
127         }
128     }
129     
130     function () external payable {
131         getTokens();
132      }
133     
134     function getTokens() payable canDistr onlyWhitelist public {
135         if (value > totalRemaining) {
136             value = totalRemaining;
137         }
138         
139         require(value <= totalRemaining);
140         
141         address investor = msg.sender;
142         uint256 toGive = value;
143         
144         distr(investor, toGive);
145         
146         if (toGive > 0) {
147             blacklist[investor] = true;
148         }
149 
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153         
154         value = value.div(100000).mul(99999);
155     }
156 
157     function balanceOf(address _owner) constant public returns (uint256) {
158         return balances[_owner];
159     }
160 
161     modifier onlyPayloadSize(uint size) {
162         assert(msg.data.length >= size + 4);
163         _;
164     }
165     
166     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
167         require(_to != address(0));
168         require(_amount <= balances[msg.sender]);
169         
170         balances[msg.sender] = balances[msg.sender].sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         emit Transfer(msg.sender, _to, _amount);
173         return true;
174     }
175     
176     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
177         require(_to != address(0));
178         require(_amount <= balances[_from]);
179         require(_amount <= allowed[_from][msg.sender]);
180         
181         balances[_from] = balances[_from].sub(_amount);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
183         balances[_to] = balances[_to].add(_amount);
184         emit Transfer(_from, _to, _amount);
185         return true;
186     }
187     
188     function approve(address _spender, uint256 _value) public returns (bool success) {
189         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195     function allowance(address _owner, address _spender) constant public returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198     
199     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
200         ForeignToken t = ForeignToken(tokenAddress);
201         uint bal = t.balanceOf(who);
202         return bal;
203     }
204     
205     function withdraw() onlyOwner public {
206         uint256 etherBalance = address(this).balance;
207         owner.transfer(etherBalance);
208     }
209     
210     function burn(uint256 _value) onlyOwner public {
211         require(_value <= balances[msg.sender]);
212 
213         address burner = msg.sender;
214         balances[burner] = balances[burner].sub(_value);
215         totalSupply = totalSupply.sub(_value);
216         totalDistributed = totalDistributed.sub(_value);
217         emit Burn(burner, _value);
218     }
219     
220     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
221         ForeignToken token = ForeignToken(_tokenContract);
222         uint256 amount = token.balanceOf(address(this));
223         return token.transfer(owner, amount);
224     }
225 }