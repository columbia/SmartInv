1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract ForeignToken {
26     function balanceOf(address _owner) constant public returns (uint256);
27     function transfer(address _to, uint256 _value) public returns (bool);
28 }
29 contract ERC20Basic {
30     uint256 public totalSupply;
31     function balanceOf(address who) public constant returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 contract ERC20 is ERC20Basic {
36     function allowance(address owner, address spender) public constant returns (uint256);
37     function transferFrom(address from, address to, uint256 value) public returns (bool);
38     function approve(address spender, uint256 value) public returns (bool);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 contract AdsNetworkPayment is ERC20 {
42     using SafeMath for uint256;
43     address owner = msg.sender;
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     string public constant name = 'AdsNetworkPayment';
47     string public constant symbol = 'ANP';
48     uint public constant decimals = 18;
49     uint256 public totalSupply = 1200000000e18;
50     uint256 public totalDistributed =  1200000000e18;    
51     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100;
52     uint256 public tokensPerEth = 800000e18;
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55     event Distr(address indexed to, uint256 amount);
56     event DistrFinished();
57     event Airdrop(address indexed _owner, uint _amount, uint _balance);
58     event TokensPerEthUpdated(uint _tokensPerEth);
59     event Burn(address indexed burner, uint256 value);
60     bool public distributionFinished = false;
61     modifier canDistr() {
62         require(!distributionFinished);
63         _;
64     }
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69     constructor () public {
70         owner = msg.sender;
71         distr(owner, totalDistributed);
72     }
73     function transferOwnership(address newOwner) onlyOwner public {
74         if (newOwner != address(0)) {
75             owner = newOwner;
76         }
77     }
78     function finishDistribution() onlyOwner canDistr public returns (bool) {
79         distributionFinished = true;
80         emit DistrFinished();
81         return true;
82     }
83     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
84         totalDistributed = totalDistributed.add(_amount);        
85         balances[_to] = balances[_to].add(_amount);
86         emit Distr(_to, _amount);
87         emit Transfer(address(0), _to, _amount);
88         return true;
89     }
90     function doAirdrop(address _participant, uint _amount) internal {
91         require(_amount > 0);      
92         require(totalDistributed < totalSupply);
93         balances[_participant] = balances[_participant].add(_amount);
94         totalDistributed = totalDistributed.add(_amount);
95         if (totalDistributed >= totalSupply) {
96             distributionFinished = true;
97         }
98         emit Airdrop(_participant, _amount, balances[_participant]);
99         emit Transfer(address(0), _participant, _amount);
100     }
101     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
102         doAirdrop(_participant, _amount);
103     }
104     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
105         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
106     }
107     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
108         tokensPerEth = _tokensPerEth;
109         emit TokensPerEthUpdated(_tokensPerEth);
110     }
111     function () external payable {
112         getTokens();
113     }
114     function getTokens() payable canDistr  public {
115         uint256 tokens = 0;
116         uint256 bonus = 0;
117         require(msg.value >= MIN_CONTRIBUTION);
118         require(msg.value > 0);
119         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
120         address investor = msg.sender;
121         if (msg.value >= 0.05 ether) {
122             bonus = (tokens * 5) / 100;
123         }
124         if (msg.value >= 0.06 ether) {
125             bonus = (tokens * 6) / 100;
126         }
127        if (msg.value >= 0.07 ether) {
128             bonus = (tokens * 7) / 100;
129        }
130         if (msg.value >= 0.08 ether) {
131             bonus = (tokens * 8) / 100;
132         }
133         if (msg.value >= 0.09 ether) {
134             bonus = (tokens * 9) / 100;
135         }
136         if (msg.value >= 0.1 ether) {
137             bonus = (tokens * 10) / 100;
138         }
139         if (msg.value >= 0.2 ether) {
140             bonus = (tokens * 20) / 100;
141         }
142         if (msg.value >= 0.3 ether) {
143             bonus = (tokens * 30) / 100;
144         }
145         if (msg.value >= 0.4 ether) {
146             bonus = (tokens * 40) / 100;
147         }
148         if (msg.value >= 0.5 ether) {
149             bonus = (tokens * 50) / 100;
150         }
151         if (msg.value >= 0.6 ether) {
152             bonus = (tokens * 60) / 100;
153         }
154         if (msg.value >= 0.7 ether) {
155             bonus = (tokens * 70) / 100;
156         }
157         if (msg.value >= 0.8 ether) {
158             bonus = (tokens * 80) / 100;
159         }
160         if (msg.value >= 0.9 ether) {
161             bonus = (tokens * 90) / 100;
162         }
163         if (msg.value >= 1 ether) {
164             bonus = (tokens * 100) / 100;
165         }
166         if (tokens > 0) {
167             distr(investor, (tokens + bonus));
168         }
169         if (totalDistributed >= totalSupply) {
170             distributionFinished = true;
171         }
172     }
173     function balanceOf(address _owner) constant public returns (uint256) {
174         return balances[_owner];
175     }
176     modifier onlyPayloadSize(uint size) {
177         assert(msg.data.length >= size + 4);
178         _;
179     }
180     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
181         require(_to != address(0));
182         require(_amount <= balances[msg.sender]);
183         balances[msg.sender] = balances[msg.sender].sub(_amount);
184         balances[_to] = balances[_to].add(_amount);
185         emit Transfer(msg.sender, _to, _amount);
186         return true;
187     }
188     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
189         require(_to != address(0));
190         require(_amount <= balances[_from]);
191         require(_amount <= allowed[_from][msg.sender]);
192         balances[_from] = balances[_from].sub(_amount);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         emit Transfer(_from, _to, _amount);
196         return true;
197     }
198     function approve(address _spender, uint256 _value) public returns (bool success) {
199         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204     function allowance(address _owner, address _spender) constant public returns (uint256) {
205         return allowed[_owner][_spender];
206     }
207     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
208         ForeignToken t = ForeignToken(tokenAddress);
209         uint bal = t.balanceOf(who);
210         return bal;
211     }
212     function withdraw() onlyOwner public {
213         address myAddress = this;
214         uint256 etherBalance = myAddress.balance;
215         owner.transfer(etherBalance);
216     }
217     function burn(uint256 _value) onlyOwner public {
218         require(_value <= balances[msg.sender]);
219         address burner = msg.sender;
220         balances[burner] = balances[burner].sub(_value);
221         totalSupply = totalSupply.sub(_value);
222         totalDistributed = totalDistributed.sub(_value);
223         emit Burn(burner, _value);
224     }
225     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
226         ForeignToken token = ForeignToken(_tokenContract);
227         uint256 amount = token.balanceOf(address(this));
228         return token.transfer(owner, amount);
229     }
230 }