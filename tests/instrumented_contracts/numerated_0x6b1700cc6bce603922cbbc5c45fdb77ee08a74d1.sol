1 pragma solidity ^0.4.18;
2 // Token name: OVAL Token (OVAL Exchange Token)
3 // Symbol: OVAL
4 // Decimals: 8
5 // Twitter : @OVALToken
6 // Twitter : @OVALExchange
7 
8 /**
9  * @title SafeMath
10  */
11 library SafeMath {
12 
13     /**
14     * Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract AltcoinToken {
54     function balanceOf(address _owner) constant public returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56 }
57 
58 contract ERC20Basic {
59     uint256 public totalSupply;
60     function balanceOf(address who) public constant returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract OVALExchangeToken is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "OVAL Token";
81     string public constant symbol = "OVAL";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 25000000000e8;
85     uint256 public totalDistributed = 0;        
86     uint256 public tokensPerEth = 10000000e8;
87     uint256 public minContribution = 0.01 ether; // 0.01 Ether
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94 
95     event Airdrop(address indexed _owner, uint _amount, uint _balance);
96 
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     
99     event MinContributionUpdated(uint _minContribution);
100 
101     event Burn(address indexed burner, uint256 value);
102 
103     bool public distributionFinished = false;
104     
105     modifier canDistr() {
106         require(!distributionFinished);
107         _;
108     }
109     
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114     
115     
116     function OVALExchangeToken () public {
117         owner = msg.sender;
118         uint256 devTokens = 250000000e8;
119         distr(owner, devTokens);
120     }
121     
122     function transferOwnership(address newOwner) onlyOwner public {
123         if (newOwner != address(0)) {
124             owner = newOwner;
125         }
126     }
127     
128 
129     function finishDistribution() onlyOwner canDistr public returns (bool) {
130         distributionFinished = true;
131         emit DistrFinished();
132         return true;
133     }
134     
135     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
136         totalDistributed = totalDistributed.add(_amount);        
137         balances[_to] = balances[_to].add(_amount);
138         emit Distr(_to, _amount);
139         emit Transfer(address(0), _to, _amount);
140 
141         return true;
142     }
143 
144     function doAirdrop(address _participant, uint _amount) internal {
145 
146         require( _amount > 0 );      
147 
148         require( totalDistributed < totalSupply );
149         
150         balances[_participant] = balances[_participant].add(_amount);
151         totalDistributed = totalDistributed.add(_amount);
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156 
157         // log
158         emit Airdrop(_participant, _amount, balances[_participant]);
159         emit Transfer(address(0), _participant, _amount);
160     }
161 
162     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
163         doAirdrop(_participant, _amount);
164     }
165 
166     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
167         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
168     }
169     
170  function updateMinContribution(uint _minContribution) public onlyOwner {        
171         minContribution = _minContribution;
172         emit MinContributionUpdated(_minContribution);
173     }
174 
175     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
176         tokensPerEth = _tokensPerEth;
177         emit TokensPerEthUpdated(_tokensPerEth);
178     }
179            
180     function () external payable {
181         getTokens();
182      }
183     
184     function getTokens() payable canDistr  public {
185         uint256 tokens = 0;
186 
187         require( msg.value >= minContribution );
188 
189         require( msg.value > 0 );
190         
191         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
192         address investor = msg.sender;
193         
194         if (tokens > 0) {
195             distr(investor, tokens);
196         }
197 
198         if (totalDistributed >= totalSupply) {
199             distributionFinished = true;
200         }
201     }
202 
203     function balanceOf(address _owner) constant public returns (uint256) {
204         return balances[_owner];
205     }
206 
207     // mitigates the ERC20 short address attack
208     modifier onlyPayloadSize(uint size) {
209         assert(msg.data.length >= size + 4);
210         _;
211     }
212     
213     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
214 
215         require(_to != address(0));
216         require(_amount <= balances[msg.sender]);
217         
218         balances[msg.sender] = balances[msg.sender].sub(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Transfer(msg.sender, _to, _amount);
221         return true;
222     }
223     
224     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
225 
226         require(_to != address(0));
227         require(_amount <= balances[_from]);
228         require(_amount <= allowed[_from][msg.sender]);
229         
230         balances[_from] = balances[_from].sub(_amount);
231         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
232         balances[_to] = balances[_to].add(_amount);
233         emit Transfer(_from, _to, _amount);
234         return true;
235     }
236     
237     function approve(address _spender, uint256 _value) public returns (bool success) {
238         // mitigates the ERC20 spend/approval race condition
239         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
240         allowed[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242         return true;
243     }
244     
245     function allowance(address _owner, address _spender) constant public returns (uint256) {
246         return allowed[_owner][_spender];
247     }
248     
249     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
250         AltcoinToken t = AltcoinToken(tokenAddress);
251         uint bal = t.balanceOf(who);
252         return bal;
253     }
254     
255     function withdraw() onlyOwner public {
256         address myAddress = this;
257         uint256 etherBalance = myAddress.balance;
258         owner.transfer(etherBalance);
259     }
260     
261     function burn(uint256 _value) onlyOwner public {
262         require(_value <= balances[msg.sender]);
263         
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         totalDistributed = totalDistributed.sub(_value);
268         emit Burn(burner, _value);
269     }
270     
271     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
272         AltcoinToken token = AltcoinToken(_tokenContract);
273         uint256 amount = token.balanceOf(address(this));
274         return token.transfer(owner, amount);
275     }
276 }