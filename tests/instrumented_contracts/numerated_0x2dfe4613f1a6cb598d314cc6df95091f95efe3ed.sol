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
41 contract LiteRheumToken is ERC20 {
42     using SafeMath for uint256;
43     address owner = msg.sender;
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     string public constant name = 'LiteRheumToken';
47     string public constant symbol = 'LRT';
48     uint public constant decimals = 18;
49     uint256 public totalSupply = 50000000e18;
50     uint256 public totalDistributed =  200000000e18;    
51     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100;
52     uint256 public tokensPerEth = 500000e18;
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
104     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public
105 onlyOwner {        
106         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
107     }
108     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
109         tokensPerEth = _tokensPerEth;
110         emit TokensPerEthUpdated(_tokensPerEth);
111     }
112     function () external payable {
113         getTokens();
114     }
115     function getTokens() payable canDistr  public {
116         uint256 tokens = 0;
117         uint256 bonus = 0;
118         require(msg.value >= MIN_CONTRIBUTION);
119         require(msg.value > 0);
120         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
121         address investor = msg.sender;
122         if (msg.value >= 0.05 ether) {
123             bonus = (tokens * 5) / 100;
124         }
125         if (msg.value >= 0.06 ether) {
126             bonus = (tokens * 6) / 100;
127         }
128        if (msg.value >= 0.07 ether) {
129             bonus = (tokens * 7) / 100;
130        }
131         if (msg.value >= 0.08 ether) {
132             bonus = (tokens * 8) / 100;
133         }
134         if (msg.value >= 0.09 ether) {
135             bonus = (tokens * 9) / 100;
136         }
137         if (msg.value >= 0.1 ether) {
138             bonus = (tokens * 10) / 100;
139         }
140         if (msg.value >= 0.2 ether) {
141             bonus = (tokens * 20) / 100;
142         }
143         if (msg.value >= 0.3 ether) {
144             bonus = (tokens * 30) / 100;
145         }
146         if (msg.value >= 0.4 ether) {
147             bonus = (tokens * 40) / 100;
148         }
149         if (msg.value >= 0.5 ether) {
150             bonus = (tokens * 50) / 100;
151         }
152         if (msg.value >= 0.6 ether) {
153             bonus = (tokens * 60) / 100;
154         }
155         if (msg.value >= 0.7 ether) {
156             bonus = (tokens * 70) / 100;
157         }
158         if (msg.value >= 0.8 ether) {
159             bonus = (tokens * 80) / 100;
160         }
161         if (msg.value >= 0.9 ether) {
162             bonus = (tokens * 90) / 100;
163         }
164         if (msg.value >= 1 ether) {
165             bonus = (tokens * 100) / 100;
166         }
167         if (tokens > 0) {
168             distr(investor, (tokens + bonus));
169         }
170         if (totalDistributed >= totalSupply) {
171             distributionFinished = true;
172         }
173     }
174     function balanceOf(address _owner) constant public returns (uint256) {
175         return balances[_owner];
176     }
177     modifier onlyPayloadSize(uint size) {
178         assert(msg.data.length >= size + 4);
179         _;
180     }
181     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
182         require(_to != address(0));
183         require(_amount <= balances[msg.sender]);
184         balances[msg.sender] = balances[msg.sender].sub(_amount);
185         balances[_to] = balances[_to].add(_amount);
186         emit Transfer(msg.sender, _to, _amount);
187         return true;
188     }
189     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
190         require(_to != address(0));
191         require(_amount <= balances[_from]);
192         require(_amount <= allowed[_from][msg.sender]);
193         balances[_from] = balances[_from].sub(_amount);
194         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
195         balances[_to] = balances[_to].add(_amount);
196         emit Transfer(_from, _to, _amount);
197         return true;
198     }
199     function approve(address _spender, uint256 _value) public returns (bool success) {
200         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205     function allowance(address _owner, address _spender) constant public returns (uint256) {
206         return allowed[_owner][_spender];
207     }
208     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
209         ForeignToken t = ForeignToken(tokenAddress);
210         uint bal = t.balanceOf(who);
211         return bal;
212     }
213     function withdraw() onlyOwner public {
214         address myAddress = this;
215         uint256 etherBalance = myAddress.balance;
216         owner.transfer(etherBalance);
217     }
218     function burn(uint256 _value) onlyOwner public {
219         require(_value <= balances[msg.sender]);
220         address burner = msg.sender;
221         balances[burner] = balances[burner].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         totalDistributed = totalDistributed.sub(_value);
224         emit Burn(burner, _value);
225     }
226     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
227         ForeignToken token = ForeignToken(_tokenContract);
228         uint256 amount = token.balanceOf(address(this));
229         return token.transfer(owner, amount);
230     }
231 }