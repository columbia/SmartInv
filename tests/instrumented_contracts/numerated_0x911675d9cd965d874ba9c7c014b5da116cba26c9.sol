1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ForeignToken {
26     function balanceOf(address _owner) constant public returns (uint256);
27     function transfer(address _to, uint256 _value) public returns (bool);
28 }
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32     function balanceOf(address who) public constant returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38     function allowance(address owner, address spender) public constant returns (uint256);
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40     function approve(address spender, uint256 value) public returns (bool);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 interface Token { 
45     function distr(address _to, uint256 _value) external returns (bool);
46     function totalSupply() constant external returns (uint256 supply);
47     function balanceOf(address _owner) constant external returns (uint256 balance);
48 }
49 
50 contract  Model is ERC20 {
51     
52     using SafeMath for uint256;
53     address owner = msg.sender;
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     mapping (address => bool) public blacklist;
58 
59     string public constant name = "Model";
60     string public constant symbol = "Model";
61     uint public constant decimals = 18;
62     
63     uint256 public totalSupply = 1000000000e18;
64     uint256 public totalDistributed = 100000000e18;
65     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
66     uint256 public value = 1000000e18;
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     
71     event Distr(address indexed to, uint256 amount);
72     event DistrFinished();
73     
74     event Burn(address indexed burner, uint256 value);
75 
76     bool public distributionFinished = false;
77     
78     modifier canDistr() {
79         require(!distributionFinished);
80         _;
81     }
82     
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87     
88     modifier onlyWhitelist() {
89         require(blacklist[msg.sender] == false);
90         _;
91     }
92     
93     function Model() public {
94         owner = msg.sender;
95         balances[owner] = totalDistributed;
96     }
97     
98     function transferOwnership(address newOwner) onlyOwner public {
99         if (newOwner != address(0)) {
100             owner = newOwner;
101         }
102     }
103     
104     function finishDistribution() onlyOwner canDistr public returns (bool) {
105         distributionFinished = true;
106         emit DistrFinished();
107         return true;
108     }
109     
110     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
111         totalDistributed = totalDistributed.add(_amount);
112         totalRemaining = totalRemaining.sub(_amount);
113         balances[_to] = balances[_to].add(_amount);
114         emit Distr(_to, _amount);
115         emit Transfer(address(0), _to, _amount);
116         return true;
117         
118         if (totalDistributed >= totalSupply) {
119             distributionFinished = true;
120         }
121     }
122     
123     function () external payable {
124         getTokens();
125      }
126     
127     function getTokens() payable canDistr onlyWhitelist public {
128         if (value > totalRemaining) {
129             value = totalRemaining;
130         }
131         
132         require(value <= totalRemaining);
133         
134         address investor = msg.sender;
135         uint256 toGive = value;
136         
137         distr(investor, toGive);
138         
139         if (toGive > 0) {
140             blacklist[investor] = true;
141         }
142 
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146         
147         value = value.div(100000).mul(99999);
148     }
149 
150     function balanceOf(address _owner) constant public returns (uint256) {
151         return balances[_owner];
152     }
153 
154     modifier onlyPayloadSize(uint size) {
155         assert(msg.data.length >= size + 4);
156         _;
157     }
158     
159     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
160         require(_to != address(0));
161         require(_amount <= balances[msg.sender]);
162         
163         balances[msg.sender] = balances[msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         emit Transfer(msg.sender, _to, _amount);
166         return true;
167     }
168     
169     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
170         require(_to != address(0));
171         require(_amount <= balances[_from]);
172         require(_amount <= allowed[_from][msg.sender]);
173         
174         balances[_from] = balances[_from].sub(_amount);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         emit Transfer(_from, _to, _amount);
178         return true;
179     }
180     
181     function approve(address _spender, uint256 _value) public returns (bool success) {
182         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
183         allowed[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187     
188     function allowance(address _owner, address _spender) constant public returns (uint256) {
189         return allowed[_owner][_spender];
190     }
191     
192     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
193         ForeignToken t = ForeignToken(tokenAddress);
194         uint bal = t.balanceOf(who);
195         return bal;
196     }
197     
198     function withdraw() onlyOwner public {
199         uint256 etherBalance = address(this).balance;
200         owner.transfer(etherBalance);
201     }
202     
203     function burn(uint256 _value) onlyOwner public {
204         require(_value <= balances[msg.sender]);
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         totalDistributed = totalDistributed.sub(_value);
210         emit Burn(burner, _value);
211     }
212     
213     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
214         ForeignToken token = ForeignToken(_tokenContract);
215         uint256 amount = token.balanceOf(address(this));
216         return token.transfer(owner, amount);
217     }
218 }