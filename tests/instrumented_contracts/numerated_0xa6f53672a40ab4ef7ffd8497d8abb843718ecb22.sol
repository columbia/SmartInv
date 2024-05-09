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
52 contract CASAS is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56     
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61 
62     string public constant name = "CASAS Token";
63     string public constant symbol = "CASAS";
64     uint public constant decimals = 8;
65     
66     uint256 public totalSupply = 2000000000e8;
67     uint256 public totalDistributed = 1200000000e8;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value = 15000e8;
70     
71 
72     uint public dailyDistribution;
73     uint public timestep;
74     
75     mapping(address => uint) public lastClaimed;
76     uint public claimedYesterday;
77     uint public claimedToday;
78     uint public dayStartTime;
79     bool public activated=false;
80     address public creator;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
87     
88     event Burn(address indexed burner, uint256 value);
89 
90     bool public distributionFinished = false;
91     
92 
93     
94     modifier canDistr() {
95         require(!distributionFinished);
96         _;
97     }
98     
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     modifier onlyWhitelist() {
105         require(blacklist[msg.sender] == false);
106         _;
107     }
108     
109     function  CASAS() public {
110         owner = msg.sender;
111         balances[owner] = totalDistributed;
112     }
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         emit DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         emit Distr(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132         return true;
133         
134         if (totalDistributed >= totalSupply) {
135             distributionFinished = true;
136         }
137     }
138     
139     function () external payable {
140         getTokens();
141          
142      }
143      
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
165         value = value.div(1).mul(1);
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
211         ForeignToken t = ForeignToken(tokenAddress);
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
224         address burner = msg.sender;
225         balances[burner] = balances[burner].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227         totalDistributed = totalDistributed.sub(_value);
228         emit Burn(burner, _value);
229     }
230     
231     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
232         ForeignToken token = ForeignToken(_tokenContract);
233         uint256 amount = token.balanceOf(address(this));
234         return token.transfer(owner, amount);
235     }
236 }