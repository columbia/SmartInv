1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract AltcoinToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract NexToken is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;    
71 
72     string public constant name = "Nex Token";
73     string public constant symbol = "NEX";
74     uint public constant decimals = 18;
75     
76     uint256 public totalSupply = 12000000000e18;
77     uint256 public totalDistributed = 0;        
78     uint256 public tokensPerEth = 10000000e18;
79     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     
84     event Distr(address indexed to, uint256 amount);
85     event DistrFinished();
86 
87     event Airdrop(address indexed _owner, uint _amount, uint _balance);
88 
89     event TokensPerEthUpdated(uint _tokensPerEth);
90     
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105     function NexToken () public {
106         owner = msg.sender;
107         uint256 devTokens = 4200000000e18;
108         distr(owner, devTokens);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116     
117 
118     function finishDistribution() onlyOwner canDistr public returns (bool) {
119         distributionFinished = true;
120         emit DistrFinished();
121         return true;
122     }
123     
124     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
125         totalDistributed = totalDistributed.add(_amount);        
126         balances[_to] = balances[_to].add(_amount);
127         emit Distr(_to, _amount);
128         emit Transfer(address(0), _to, _amount);
129 
130         return true;
131     }
132 
133     function doAirdrop(address _participant, uint _amount) internal {
134 
135         require( _amount > 0 );      
136 
137         require( totalDistributed < totalSupply );
138         
139         balances[_participant] = balances[_participant].add(_amount);
140         totalDistributed = totalDistributed.add(_amount);
141 
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145 
146         // log
147         emit Airdrop(_participant, _amount, balances[_participant]);
148         emit Transfer(address(0), _participant, _amount);
149     }
150 
151     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
152         doAirdrop(_participant, _amount);
153     }
154 
155     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
156         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
157     }
158 
159     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
160         tokensPerEth = _tokensPerEth;
161         emit TokensPerEthUpdated(_tokensPerEth);
162     }
163            
164     function () external payable {
165         getTokens();
166      }
167     
168     function getTokens() payable canDistr  public {
169         uint256 tokens = 0;
170 
171         require( msg.value >= minContribution );
172 
173         require( msg.value > 0 );
174         
175         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
176         address investor = msg.sender;
177         
178         if (tokens > 0) {
179             distr(investor, tokens);
180         }
181 
182         if (totalDistributed >= totalSupply) {
183             distributionFinished = true;
184         }
185     }
186 
187     function balanceOf(address _owner) constant public returns (uint256) {
188         return balances[_owner];
189     }
190 
191     // mitigates the ERC20 short address attack
192     modifier onlyPayloadSize(uint size) {
193         assert(msg.data.length >= size + 4);
194         _;
195     }
196     
197     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
198 
199         require(_to != address(0));
200         require(_amount <= balances[msg.sender]);
201         
202         balances[msg.sender] = balances[msg.sender].sub(_amount);
203         balances[_to] = balances[_to].add(_amount);
204         emit Transfer(msg.sender, _to, _amount);
205         return true;
206     }
207     
208     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
209 
210         require(_to != address(0));
211         require(_amount <= balances[_from]);
212         require(_amount <= allowed[_from][msg.sender]);
213         
214         balances[_from] = balances[_from].sub(_amount);
215         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         emit Transfer(_from, _to, _amount);
218         return true;
219     }
220     
221     function approve(address _spender, uint256 _value) public returns (bool success) {
222         // mitigates the ERC20 spend/approval race condition
223         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
224         allowed[msg.sender][_spender] = _value;
225         emit Approval(msg.sender, _spender, _value);
226         return true;
227     }
228     
229     function allowance(address _owner, address _spender) constant public returns (uint256) {
230         return allowed[_owner][_spender];
231     }
232     
233     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
234         AltcoinToken t = AltcoinToken(tokenAddress);
235         uint bal = t.balanceOf(who);
236         return bal;
237     }
238     
239     function withdraw() onlyOwner public {
240         address myAddress = this;
241         uint256 etherBalance = myAddress.balance;
242         owner.transfer(etherBalance);
243     }
244     
245     function burn(uint256 _value) onlyOwner public {
246         require(_value <= balances[msg.sender]);
247         
248         address burner = msg.sender;
249         balances[burner] = balances[burner].sub(_value);
250         totalSupply = totalSupply.sub(_value);
251         totalDistributed = totalDistributed.sub(_value);
252         emit Burn(burner, _value);
253     }
254     
255     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
256         AltcoinToken token = AltcoinToken(_tokenContract);
257         uint256 amount = token.balanceOf(address(this));
258         return token.transfer(owner, amount);
259     }
260 }