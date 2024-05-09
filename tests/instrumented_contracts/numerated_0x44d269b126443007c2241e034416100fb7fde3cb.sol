1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6     
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23 
24     
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     
31     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract ForeignToken {
39     function balanceOf(address _owner) constant public returns (uint256);
40     function transfer(address _to, uint256 _value) public returns (bool);
41 }
42 
43 contract ERC20Basic {
44     uint256 public totalSupply;
45     function balanceOf(address who) public constant returns (uint256);
46     function transfer(address to, uint256 value) public returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) public constant returns (uint256);
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53     function approve(address spender, uint256 value) public returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract Ind3X is ERC20 {
58     
59     using SafeMath for uint256;
60     address owner = msg.sender;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;    
64 
65     string public constant name = "Ind3X Exchange Token";
66     string public constant symbol = "Ind3X";
67     uint public constant decimals = 8;
68     
69     uint256 public totalSupply = 10000000000e8; // Total Supply
70     uint256 public totalDistributed = 0;    
71     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
72     uint256 public tokensPerEth = 20000000e8;
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77     event Distr(address indexed to, uint256 amount);
78     event DistrFinished();
79 
80     event Airdrop(address indexed _owner, uint _amount, uint _balance);
81     event TokensPerEthUpdated(uint _tokensPerEth);
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
106         emit DistrFinished();
107         return true;
108     }
109     
110     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
111         totalDistributed = totalDistributed.add(_amount);        
112         balances[_to] = balances[_to].add(_amount);
113         emit Distr(_to, _amount);
114         emit Transfer(address(0), _to, _amount);
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
132         emit Airdrop(_participant, _amount, balances[_participant]);
133         emit Transfer(address(0), _participant, _amount);
134     }
135 
136     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
137         doAirdrop(_participant, _amount);
138     }
139 
140 
141     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
142         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
143     }
144 
145     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
146         tokensPerEth = _tokensPerEth;
147         emit TokensPerEthUpdated(_tokensPerEth);
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
190         emit Transfer(msg.sender, _to, _amount);
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
203         emit Transfer(_from, _to, _amount);
204         return true;
205     }
206     
207     function approve(address _spender, uint256 _value) public returns (bool success) {
208         // mitigates the ERC20 spend/approval race condition
209         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214     
215     function allowance(address _owner, address _spender) constant public returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218     
219     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
220         ForeignToken t = ForeignToken(tokenAddress);
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
234 
235         address burner = msg.sender;
236         balances[burner] = balances[burner].sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         totalDistributed = totalDistributed.sub(_value);
239         emit Burn(burner, _value);
240     }
241     
242     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
243         ForeignToken token = ForeignToken(_tokenContract);
244         uint256 amount = token.balanceOf(address(this));
245         return token.transfer(owner, amount);
246     }
247 }