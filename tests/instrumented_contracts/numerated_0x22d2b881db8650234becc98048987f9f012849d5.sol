1 /**
2  * @title SafeMath
3  */
4 library SafeMath {
5 
6     /**
7     * Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     /**
29     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract AltcoinToken {
47     function balanceOf(address _owner) constant public returns (uint256);
48     function transfer(address _to, uint256 _value) public returns (bool);
49 }
50 
51 contract ERC20Basic {
52     uint256 public totalSupply;
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public constant returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract Fixie is ERC20 {
66     
67     using SafeMath for uint256;
68     address owner = msg.sender;
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;    
72 
73     string public constant name = "Fixie Network";
74     string public constant symbol = "XFN";
75     uint public constant decimals = 8;
76     
77     uint256 public totalSupply = 7000000000e8;
78     uint256 public totalDistributed = 0;        
79     uint256 public tokensPerEth = 15000000e8;
80     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
87 
88     event Airdrop(address indexed _owner, uint _amount, uint _balance);
89 
90     event TokensPerEthUpdated(uint _tokensPerEth);
91     
92     event Burn(address indexed burner, uint256 value);
93 
94     bool public distributionFinished = false;
95     
96     modifier canDistr() {
97         require(!distributionFinished);
98         _;
99     }
100     
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105     
106     
107     function Fixie () public {
108         owner = msg.sender;
109         uint256 devTokens = 1000000000e8;
110         distr(owner, devTokens);
111     }
112     
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
118     
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         emit DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);        
128         balances[_to] = balances[_to].add(_amount);
129         emit Distr(_to, _amount);
130         emit Transfer(address(0), _to, _amount);
131 
132         return true;
133     }
134 
135     function doAirdrop(address _participant, uint _amount) internal {
136 
137         require( _amount > 0 );      
138 
139         require( totalDistributed < totalSupply );
140         
141         balances[_participant] = balances[_participant].add(_amount);
142         totalDistributed = totalDistributed.add(_amount);
143 
144         if (totalDistributed >= totalSupply) {
145             distributionFinished = true;
146         }
147 
148         // log
149         emit Airdrop(_participant, _amount, balances[_participant]);
150         emit Transfer(address(0), _participant, _amount);
151     }
152 
153     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
154         doAirdrop(_participant, _amount);
155     }
156 
157     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
158         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
159     }
160 
161     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
162         tokensPerEth = _tokensPerEth;
163         emit TokensPerEthUpdated(_tokensPerEth);
164     }
165            
166     function () external payable {
167         getTokens();
168      }
169     
170     function getTokens() payable canDistr  public {
171         uint256 tokens = 0;
172 
173         require( msg.value >= minContribution );
174 
175         require( msg.value > 0 );
176         
177         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
178         address investor = msg.sender;
179         
180         if (tokens > 0) {
181             distr(investor, tokens);
182         }
183 
184         if (totalDistributed >= totalSupply) {
185             distributionFinished = true;
186         }
187     }
188 
189     function balanceOf(address _owner) constant public returns (uint256) {
190         return balances[_owner];
191     }
192 
193     // mitigates the ERC20 short address attack
194     modifier onlyPayloadSize(uint size) {
195         assert(msg.data.length >= size + 4);
196         _;
197     }
198     
199     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
200 
201         require(_to != address(0));
202         require(_amount <= balances[msg.sender]);
203         
204         balances[msg.sender] = balances[msg.sender].sub(_amount);
205         balances[_to] = balances[_to].add(_amount);
206         emit Transfer(msg.sender, _to, _amount);
207         return true;
208     }
209     
210     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[_from]);
214         require(_amount <= allowed[_from][msg.sender]);
215         
216         balances[_from] = balances[_from].sub(_amount);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(_from, _to, _amount);
220         return true;
221     }
222     
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224         // mitigates the ERC20 spend/approval race condition
225         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230     
231     function allowance(address _owner, address _spender) constant public returns (uint256) {
232         return allowed[_owner][_spender];
233     }
234     
235     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
236         AltcoinToken t = AltcoinToken(tokenAddress);
237         uint bal = t.balanceOf(who);
238         return bal;
239     }
240     
241     function withdraw() onlyOwner public {
242         address myAddress = this;
243         uint256 etherBalance = myAddress.balance;
244         owner.transfer(etherBalance);
245     }
246     
247     function burn(uint256 _value) onlyOwner public {
248         require(_value <= balances[msg.sender]);
249         
250         address burner = msg.sender;
251         balances[burner] = balances[burner].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         totalDistributed = totalDistributed.sub(_value);
254         emit Burn(burner, _value);
255     }
256     
257     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
258         AltcoinToken token = AltcoinToken(_tokenContract);
259         uint256 amount = token.balanceOf(address(this));
260         return token.transfer(owner, amount);
261     }
262 }