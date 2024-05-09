1 pragma solidity ^0.4.25;
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
52 contract PT is ERC20 {
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
63     string public name;
64     string public symbol;
65     uint public constant decimals = 18;
66     
67 uint256 public totalSupply = 10000000000e18;
68     
69 uint256 public totalDistributed = 5000000000e18;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public value = 150000e18;
74 
75 event Transfer(address indexed _from, address indexed _to, uint256 _value);
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
100     function PT(
101     
102         uint256 initialSupply,
103         string tokenName,
104         string tokenSymbol
105     ) public {
106         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
107         name = tokenName;                                   // Set the name for display purposes
108         symbol = tokenSymbol;                               // Set the symbol for display purposes
109         owner = msg.sender;
110         balances[owner] = totalDistributed;
111     }
112     
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
118     
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124     
125     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126         totalDistributed = totalDistributed.add(_amount);
127         totalRemaining = totalRemaining.sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         emit Distr(_to, _amount);
130         emit Transfer(address(0), _to, _amount);
131         return true;
132         
133         if (totalDistributed >= totalSupply) {
134             distributionFinished = true;
135         }
136     }
137     
138     function () external payable {
139         getTokens();
140      }
141     
142     function getTokens() payable canDistr onlyWhitelist public {
143         if (value > totalRemaining) {
144             value = totalRemaining;
145         }
146         
147         require(value <= totalRemaining);
148         
149         address investor = msg.sender;
150         uint256 toGive = value;
151         
152         distr(investor, toGive);
153         
154         if (toGive > 0) {
155             blacklist[investor] = true;
156         }
157 
158         if (totalDistributed >= totalSupply) {
159             distributionFinished = true;
160         }
161         
162         value = value.div(100000).mul(99999);
163     }
164 
165     function balanceOf(address _owner) constant public returns (uint256) {
166         return balances[_owner];
167     }
168 
169     modifier onlyPayloadSize(uint size) {
170         assert(msg.data.length >= size + 4);
171         _;
172     }
173     
174     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
175         require(_to != address(0));
176         require(_amount <= balances[msg.sender]);
177         
178         balances[msg.sender] = balances[msg.sender].sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         emit Transfer(msg.sender, _to, _amount);
181         return true;
182     }
183     
184     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
185         require(_to != address(0));
186         require(_amount <= balances[_from]);
187         require(_amount <= allowed[_from][msg.sender]);
188         
189         balances[_from] = balances[_from].sub(_amount);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
191         balances[_to] = balances[_to].add(_amount);
192         emit Transfer(_from, _to, _amount);
193         return true;
194     }
195     
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202     
203     function allowance(address _owner, address _spender) constant public returns (uint256) {
204         return allowed[_owner][_spender];
205     }
206     
207     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
208         ForeignToken t = ForeignToken(tokenAddress);
209         uint bal = t.balanceOf(who);
210         return bal;
211     }
212     
213     function withdraw() onlyOwner public {
214         uint256 etherBalance = address(this).balance;
215         owner.transfer(etherBalance);
216     }
217     
218     function burn(uint256 _value) onlyOwner public {
219         require(_value <= balances[msg.sender]);
220 
221         address burner = msg.sender;
222         balances[burner] = balances[burner].sub(_value);
223         totalSupply = totalSupply.sub(_value);
224         totalDistributed = totalDistributed.sub(_value);
225         emit Burn(burner, _value);
226     }
227     
228     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
229         ForeignToken token = ForeignToken(_tokenContract);
230         uint256 amount = token.balanceOf(address(this));
231         return token.transfer(owner, amount);
232     }
233 }