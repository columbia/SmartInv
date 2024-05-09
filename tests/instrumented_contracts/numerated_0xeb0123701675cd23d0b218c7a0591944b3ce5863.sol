1 pragma solidity ^0.4.18;
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
25 
26 contract AltcoinToken {
27     function balanceOf(address _owner) constant public returns (uint256);
28     function transfer(address _to, uint256 _value) public returns (bool);
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract EijiChain is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 
53     string public constant name = "EijiChain";
54     string public constant symbol = "EIT";
55     uint public constant decimals = 8;
56 	string public logoPng = "https://raw.githubusercontent.com/EijiChain/EIT/master/assets/F500.png";
57     
58     uint256 public totalSupply = 1000000000e8; // 1,000,000,000
59     uint256 public totalDistributed = 0;        
60     uint256 public tokensPerEth = 20000000e8; // 20,000,000
61     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     
66     event Distr(address indexed to, uint256 amount);
67     event DistrFinished();
68 
69     event Airdrop(address indexed _owner, uint _amount, uint _balance);
70 
71     event TokensPerEthUpdated(uint _tokensPerEth);
72     
73     event Burn(address indexed burner, uint256 value);
74 
75     bool public distributionFinished = false;
76     
77     modifier canDistr() {
78         require(!distributionFinished);
79         _;
80     }
81     
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86         
87     function EijiChain () public {
88         owner = msg.sender;
89         uint256 devTokens = 250000000e8; // 25% = 250,000,000
90         distr(owner, devTokens);
91     }
92     
93     function transferOwnership(address newOwner) onlyOwner public {
94         if (newOwner != address(0)) {
95             owner = newOwner;
96         }
97     }    
98 
99     function finishDistribution() onlyOwner canDistr public returns (bool) {
100         distributionFinished = true;
101         emit DistrFinished();
102         return true;
103     }
104     
105     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
106         totalDistributed = totalDistributed.add(_amount);        
107         balances[_to] = balances[_to].add(_amount);
108         emit Distr(_to, _amount);
109         emit Transfer(address(0), _to, _amount);
110 
111         return true;
112     }
113 
114     function doAirdrop(address _participant, uint _amount) internal {
115 
116         require( _amount > 0 );      
117 
118         require( totalDistributed < totalSupply );
119         
120         balances[_participant] = balances[_participant].add(_amount);
121         totalDistributed = totalDistributed.add(_amount);
122 
123         if (totalDistributed >= totalSupply) {
124             distributionFinished = true;
125         }
126 
127         // log
128         emit Airdrop(_participant, _amount, balances[_participant]);
129         emit Transfer(address(0), _participant, _amount);
130     }
131 
132     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
133         doAirdrop(_participant, _amount);
134     }
135 
136     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
137         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
138     }
139 
140     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
141         tokensPerEth = _tokensPerEth;
142         emit TokensPerEthUpdated(_tokensPerEth);
143     }
144            
145     function () external payable {
146         getTokens();
147      }
148     
149     function getTokens() payable canDistr  public {
150         uint256 tokens = 0;
151 		uint256 tokens1 = 300000e8;
152 		uint256 tokens2 = 3000000e8;
153 
154         require( msg.value >= minContribution );
155 
156         require( msg.value > 0 );
157         
158         tokens = tokensPerEth.mul(msg.value) / 1 ether; // 20,000,000 * 0,01 / 1 = 200,000
159         address investor = msg.sender;
160         
161         if (tokens > 0) {
162             distr(investor, tokens);
163         }
164 		
165 		if (msg.value >= 1 ether / 10 && msg.value < 1 ether) {
166 			// Bonus Stage 1			
167             distr(investor, tokens1);
168         }
169 		
170 		if (msg.value >= 1 ether) {
171 			// Bonus Stage 2
172             distr(investor, tokens2);
173         }
174 
175         if (totalDistributed >= totalSupply) {
176             distributionFinished = true;
177         }
178     }
179 
180     function balanceOf(address _owner) constant public returns (uint256) {
181         return balances[_owner];
182     }
183 
184     modifier onlyPayloadSize(uint size) {
185         assert(msg.data.length >= size + 4);
186         _;
187     }
188     
189     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
190         require(_to != address(0));
191         require(_amount <= balances[msg.sender]);
192         
193         balances[msg.sender] = balances[msg.sender].sub(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         emit Transfer(msg.sender, _to, _amount);
196         return true;
197     }
198     
199     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
200         require(_to != address(0));
201         require(_amount <= balances[_from]);
202         require(_amount <= allowed[_from][msg.sender]);
203         
204         balances[_from] = balances[_from].sub(_amount);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(_from, _to, _amount);
208         return true;
209     }
210     
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
213         allowed[msg.sender][_spender] = _value;
214         emit Approval(msg.sender, _spender, _value);
215         return true;
216     }
217     
218     function allowance(address _owner, address _spender) constant public returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221     
222     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
223         AltcoinToken t = AltcoinToken(tokenAddress);
224         uint bal = t.balanceOf(who);
225         return bal;
226     }
227     
228     function withdraw() onlyOwner public {
229         address myAddress = this;
230         uint256 etherBalance = myAddress.balance;
231         owner.transfer(etherBalance);
232     }
233     
234     function burn(uint256 _value) onlyOwner public {
235         require(_value <= balances[msg.sender]);
236         
237         address burner = msg.sender;
238         balances[burner] = balances[burner].sub(_value);
239         totalSupply = totalSupply.sub(_value);
240         totalDistributed = totalDistributed.sub(_value);
241         emit Burn(burner, _value);
242     }
243     
244     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
245         AltcoinToken token = AltcoinToken(_tokenContract);
246         uint256 amount = token.balanceOf(address(this));
247         return token.transfer(owner, amount);
248     }
249 }