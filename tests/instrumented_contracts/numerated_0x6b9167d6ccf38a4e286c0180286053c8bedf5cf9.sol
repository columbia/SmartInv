1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract AltcoinToken {
31     function balanceOf(address _owner) constant public returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 }
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Test1 is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "Test1";
58     string public constant symbol = "TST";
59     uint public constant decimals = 8;
60     
61     uint256 public totalSupply = 100000000e8;
62     uint256 public totalDistributed = 0;        
63     uint256 public tokensPerEth = 500000e8;
64     uint256 public constant minContribution = 1 ether / 500; // 0.002 Ether
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68     
69     event Distr(address indexed to, uint256 amount);
70     event DistrFinished();
71 
72     event Airdrop(address indexed _owner, uint _amount, uint _balance);
73 
74     event TokensPerEthUpdated(uint _tokensPerEth);
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
90     
91     function Test1 () public {
92         owner = msg.sender;
93         uint256 devTokens = 5000000e8;
94         distr(owner, devTokens);
95     }
96     
97     function transferOwnership(address newOwner) onlyOwner public {
98         if (newOwner != address(0)) {
99             owner = newOwner;
100         }
101     }
102     
103 
104     function finishDistribution() onlyOwner canDistr public returns (bool) {
105         distributionFinished = true;
106         DistrFinished();
107         return true;
108     }
109     
110     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
111         totalDistributed = totalDistributed.add(_amount);        
112         balances[_to] = balances[_to].add(_amount);
113         Distr(_to, _amount);
114         Transfer(address(0), _to, _amount);
115 
116         return true;
117     }
118 
119     function doAirdrop(address _participant, uint _amount) internal {
120 
121         require( _amount > 0 );      
122 
123         require( totalDistributed < totalSupply );
124         
125         balances[_participant] = balances[_participant].add(_amount);
126         totalDistributed = totalDistributed.add(_amount);
127 
128         if (totalDistributed >= totalSupply) {
129             distributionFinished = true;
130         }
131 
132         // log
133         Airdrop(_participant, _amount, balances[_participant]);
134         Transfer(address(0), _participant, _amount);
135     }
136 
137     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
138         doAirdrop(_participant, _amount);
139     }
140 
141     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
142         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
143     }
144 
145     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
146         tokensPerEth = _tokensPerEth;
147         TokensPerEthUpdated(_tokensPerEth);
148     }
149            
150     function () external payable {
151         getTokens();
152      }
153     
154     function getTokens() payable canDistr  public {
155         uint256 tokens = 0;
156 
157         require( msg.value >= minContribution );
158 
159         require( msg.value > 0 );
160         
161         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
162         address investor = msg.sender;
163         
164         if (tokens > 0) {
165             distr(investor, tokens);
166         }
167 
168         if (totalDistributed >= totalSupply) {
169             distributionFinished = true;
170         }
171     }
172 
173     function balanceOf(address _owner) constant public returns (uint256) {
174         return balances[_owner];
175     }
176 
177     // mitigates the ERC20 short address attack
178     modifier onlyPayloadSize(uint size) {
179         assert(msg.data.length >= size + 4);
180         _;
181     }
182     
183     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
184 
185         require(_to != address(0));
186         require(_amount <= balances[msg.sender]);
187         
188         balances[msg.sender] = balances[msg.sender].sub(_amount);
189         balances[_to] = balances[_to].add(_amount);
190         Transfer(msg.sender, _to, _amount);
191         return true;
192     }
193     
194     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
195 
196         require(_to != address(0));
197         require(_amount <= balances[_from]);
198         require(_amount <= allowed[_from][msg.sender]);
199         
200         balances[_from] = balances[_from].sub(_amount);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
202         balances[_to] = balances[_to].add(_amount);
203         Transfer(_from, _to, _amount);
204         return true;
205     }
206     
207     function approve(address _spender, uint256 _value) public returns (bool success) {
208         // mitigates the ERC20 spend/approval race condition
209         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212         return true;
213     }
214     
215     function allowance(address _owner, address _spender) constant public returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218     
219     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
220         AltcoinToken t = AltcoinToken(tokenAddress);
221         uint bal = t.balanceOf(who);
222         return bal;
223     }
224     
225     function withdraw() onlyOwner public {
226         address myAddress = this;
227         uint256 etherBalance = myAddress.balance;
228         owner.transfer(etherBalance);
229     }
230     
231     function burn(uint256 _value) onlyOwner public {
232         require(_value <= balances[msg.sender]);
233         
234         address burner = msg.sender;
235         balances[burner] = balances[burner].sub(_value);
236         totalSupply = totalSupply.sub(_value);
237         totalDistributed = totalDistributed.sub(_value);
238         Burn(burner, _value);
239     }
240     
241     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
242         AltcoinToken token = AltcoinToken(_tokenContract);
243         uint256 amount = token.balanceOf(address(this));
244         return token.transfer(owner, amount);
245     }
246 }