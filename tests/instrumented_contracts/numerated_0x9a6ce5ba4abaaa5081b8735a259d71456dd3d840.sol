1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'KYRO TOKEN' CROWDSALE token contract
5 //
6 // Deployed to : 0x3734c3109D0ACA78e1800Aa292Cc56ee16529fDB
7 // Symbol      : KRO
8 // Name        : KYRO Token
9 // Total supply: 2,000,000,000
10 // Decimals    : 8
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 library SafeMath {
18 
19     /**
20     * Multiplies two numbers, throws on overflow.
21     */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32     * Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50     * Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 contract AltcoinToken {
60     function balanceOf(address _owner) constant public returns (uint256);
61     function transfer(address _to, uint256 _value) public returns (bool);
62 }
63 
64 contract ERC20Basic {
65     uint256 public totalSupply;
66     function balanceOf(address who) public constant returns (uint256);
67     function transfer(address to, uint256 value) public returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender) public constant returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract KYRO is ERC20 {
79     
80     using SafeMath for uint256;
81     address owner = msg.sender;
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;    
85 
86     string public constant name = "KYRO Token";
87     string public constant symbol = "KRO";
88     uint public constant decimals = 8;
89     
90     uint256 public totalSupply = 2000000000e8;
91     uint256 public totalDistributed = 0;        
92     uint256 public tokensPerEth = 1800000e8;
93     uint256 public constant minContribution = 0.0001 ether / 100; // 0.01 ether
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97     
98     event Distr(address indexed to, uint256 amount);
99     event DistrFinished();
100 
101     event Airdrop(address indexed _owner, uint _amount, uint _balance);
102 
103     event TokensPerEthUpdated(uint _tokensPerEth);
104     
105     event Burn(address indexed burner, uint256 value);
106 
107     bool public distributionFinished = false;
108     
109     modifier canDistr() {
110         require(!distributionFinished);
111         _;
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     
120     
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
170     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
171         tokensPerEth = _tokensPerEth;
172         emit TokensPerEthUpdated(_tokensPerEth);
173     }
174            
175     function () external payable {
176         getTokens();
177      }
178     
179     function getTokens() payable canDistr  public {
180         uint256 tokens = 0;
181 
182         require( msg.value >= minContribution );
183 
184         require( msg.value > 0 );
185         
186         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
187         address investor = msg.sender;
188         
189         if (tokens > 0) {
190             distr(investor, tokens);
191         }
192 
193         if (totalDistributed >= totalSupply) {
194             distributionFinished = true;
195         }
196     }
197 
198     function balanceOf(address _owner) constant public returns (uint256) {
199         return balances[_owner];
200     }
201 
202     // mitigates the ERC20 short address attack
203     modifier onlyPayloadSize(uint size) {
204         assert(msg.data.length >= size + 4);
205         _;
206     }
207     
208     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
209 
210         require(_to != address(0));
211         require(_amount <= balances[msg.sender]);
212         
213         balances[msg.sender] = balances[msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(msg.sender, _to, _amount);
216         return true;
217     }
218     
219     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
220 
221         require(_to != address(0));
222         require(_amount <= balances[_from]);
223         require(_amount <= allowed[_from][msg.sender]);
224         
225         balances[_from] = balances[_from].sub(_amount);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         emit Transfer(_from, _to, _amount);
229         return true;
230     }
231     
232     function approve(address _spender, uint256 _value) public returns (bool success) {
233         // mitigates the ERC20 spend/approval race condition
234         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239     
240     function allowance(address _owner, address _spender) constant public returns (uint256) {
241         return allowed[_owner][_spender];
242     }
243     
244     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
245         AltcoinToken t = AltcoinToken(tokenAddress);
246         uint bal = t.balanceOf(who);
247         return bal;
248     }
249     
250     function withdraw() onlyOwner public {
251         address myAddress = this;
252         uint256 etherBalance = myAddress.balance;
253         owner.transfer(etherBalance);
254     }
255     
256     function burn(uint256 _value) onlyOwner public {
257         require(_value <= balances[msg.sender]);
258         
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         totalSupply = totalSupply.sub(_value);
262         totalDistributed = totalDistributed.sub(_value);
263         emit Burn(burner, _value);
264     }
265     
266     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
267         AltcoinToken token = AltcoinToken(_tokenContract);
268         uint256 amount = token.balanceOf(address(this));
269         return token.transfer(owner, amount);
270     }
271 }