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
52 contract JGCoinOld is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "JGCoinOld";
62     string public constant symbol = "JGCO";
63     uint public constant decimals = 18;
64     
65     uint256 public totalSupply = 500000000e18;
66     uint256 public totalDistributed = 250000000e18;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 public value = 800e18;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     
76     event Burn(address indexed burner, uint256 value);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     modifier onlyWhitelist() {
91         require(blacklist[msg.sender] == false);
92         _;
93     }
94     
95     function JGCoinOld() public {
96         owner = msg.sender;
97         balances[owner] = totalDistributed;
98     }
99     
100     function transferOwnership(address newOwner) onlyOwner public {
101         if (newOwner != address(0)) {
102             owner = newOwner;
103         }
104     }
105     
106     function finishDistribution() onlyOwner canDistr public returns (bool) {
107         distributionFinished = true;
108         emit DistrFinished();
109         return true;
110     }
111     
112     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
113         totalDistributed = totalDistributed.add(_amount);
114         totalRemaining = totalRemaining.sub(_amount);
115         balances[_to] = balances[_to].add(_amount);
116         emit Distr(_to, _amount);
117         emit Transfer(address(0), _to, _amount);
118         return true;
119         
120         if (totalDistributed >= totalSupply) {
121             distributionFinished = true;
122         }
123     }
124     
125     function () external payable {
126         getTokens();
127      }
128     
129     function getTokens() payable canDistr onlyWhitelist public {
130         if (value > totalRemaining) {
131             value = totalRemaining;
132         }
133         
134         require(value <= totalRemaining);
135         
136         address investor = msg.sender;
137         uint256 toGive = value;
138         
139         distr(investor, toGive);
140         
141         if (toGive > 0) {
142             blacklist[investor] = true;
143         }
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148         
149     }
150 
151     function balanceOf(address _owner) constant public returns (uint256) {
152         return balances[_owner];
153     }
154 
155     modifier onlyPayloadSize(uint size) {
156         assert(msg.data.length >= size + 4);
157         _;
158     }
159     
160     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
161         require(_to != address(0));
162         require(_amount <= balances[msg.sender]);
163         
164         balances[msg.sender] = balances[msg.sender].sub(_amount);
165         balances[_to] = balances[_to].add(_amount);
166         emit Transfer(msg.sender, _to, _amount);
167         return true;
168     }
169     
170     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
171         require(_to != address(0));
172         require(_amount <= balances[_from]);
173         require(_amount <= allowed[_from][msg.sender]);
174         
175         balances[_from] = balances[_from].sub(_amount);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         emit Transfer(_from, _to, _amount);
179         return true;
180     }
181     
182     function approve(address _spender, uint256 _value) public returns (bool success) {
183         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
184         allowed[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188     
189     function allowance(address _owner, address _spender) constant public returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192     
193     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
194         ForeignToken t = ForeignToken(tokenAddress);
195         uint bal = t.balanceOf(who);
196         return bal;
197     }
198     
199     function withdraw() onlyOwner public {
200         uint256 etherBalance = address(this).balance;
201         owner.transfer(etherBalance);
202     }
203     
204     function burn(uint256 _value) onlyOwner public {
205         require(_value <= balances[msg.sender]);
206 
207         address burner = msg.sender;
208         balances[burner] = balances[burner].sub(_value);
209         totalSupply = totalSupply.sub(_value);
210         totalDistributed = totalDistributed.sub(_value);
211         emit Burn(burner, _value);
212     }
213     
214     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
215         ForeignToken token = ForeignToken(_tokenContract);
216         uint256 amount = token.balanceOf(address(this));
217         return token.transfer(owner, amount);
218     }
219 }