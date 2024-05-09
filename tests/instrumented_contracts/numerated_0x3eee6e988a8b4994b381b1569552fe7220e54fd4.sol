1 /* 
2 //PHOENIX
3  */
4 pragma solidity ^0.4.18;
5 
6 /**
7  * @title SafeMath
8  */
9 library SafeMath {
10 
11     /**
12     * Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33     /**
34     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45         c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract AltcoinToken {
52     function balanceOf(address _owner) constant public returns (uint256);
53     function transfer(address _to, uint256 _value) public returns (bool);
54 }
55 
56 contract ERC20Basic {
57     uint256 public totalSupply;
58     function balanceOf(address who) public constant returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract ERC20 is ERC20Basic {
64     function allowance(address owner, address spender) public constant returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 contract PHOENIX is ERC20 {
71     
72     using SafeMath for uint256;
73     address owner = msg.sender;
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;    
77 
78     string public constant name = "PHOENIX";
79     string public constant symbol = "PHNX";
80     uint public constant decimals = 8;
81     
82     uint256 public totalSupply = 15000000000e8;
83     uint256 public totalDistributed = 0;        
84     uint256 public tokensPerEth = 20000000e8;
85     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     
90     event Distr(address indexed to, uint256 amount);
91     event DistrFinished();
92 
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96     
97     event Burn(address indexed burner, uint256 value);
98 
99     bool public distributionFinished = false;
100     
101     modifier canDistr() {
102         require(!distributionFinished);
103         _;
104     }
105     
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     
111     
112     
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120 
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         emit DistrFinished();
124         return true;
125     }
126     
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);        
129         balances[_to] = balances[_to].add(_amount);
130         emit Distr(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132 
133         return true;
134     }
135 
136     function doAirdrop(address _participant, uint _amount) internal {
137 
138         require( _amount > 0 );      
139 
140         require( totalDistributed < totalSupply );
141         
142         balances[_participant] = balances[_participant].add(_amount);
143         totalDistributed = totalDistributed.add(_amount);
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148 
149         // log
150         emit Airdrop(_participant, _amount, balances[_participant]);
151         emit Transfer(address(0), _participant, _amount);
152     }
153 
154     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
155         doAirdrop(_participant, _amount);
156     }
157 
158     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
159         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
160     }
161 
162     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
163         tokensPerEth = _tokensPerEth;
164         emit TokensPerEthUpdated(_tokensPerEth);
165     }
166            
167     function () external payable {
168         getTokens();
169      }
170     
171     function getTokens() payable canDistr  public {
172         uint256 tokens = 0;
173 
174         require( msg.value >= minContribution );
175 
176         require( msg.value > 0 );
177         
178         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
179         address investor = msg.sender;
180         
181         if (tokens > 0) {
182             distr(investor, tokens);
183         }
184 
185         if (totalDistributed >= totalSupply) {
186             distributionFinished = true;
187         }
188     }
189 
190     function balanceOf(address _owner) constant public returns (uint256) {
191         return balances[_owner];
192     }
193 
194     // mitigates the ERC20 short address attack
195     modifier onlyPayloadSize(uint size) {
196         assert(msg.data.length >= size + 4);
197         _;
198     }
199     
200     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
201 
202         require(_to != address(0));
203         require(_amount <= balances[msg.sender]);
204         
205         balances[msg.sender] = balances[msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(msg.sender, _to, _amount);
208         return true;
209     }
210     
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212 
213         require(_to != address(0));
214         require(_amount <= balances[_from]);
215         require(_amount <= allowed[_from][msg.sender]);
216         
217         balances[_from] = balances[_from].sub(_amount);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Transfer(_from, _to, _amount);
221         return true;
222     }
223     
224     function approve(address _spender, uint256 _value) public returns (bool success) {
225         // mitigates the ERC20 spend/approval race condition
226         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231     
232     function allowance(address _owner, address _spender) constant public returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235     
236     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
237         AltcoinToken t = AltcoinToken(tokenAddress);
238         uint bal = t.balanceOf(who);
239         return bal;
240     }
241     
242     function withdraw() onlyOwner public {
243         address myAddress = this;
244         uint256 etherBalance = myAddress.balance;
245         owner.transfer(etherBalance);
246     }
247     
248     function burn(uint256 _value) onlyOwner public {
249         require(_value <= balances[msg.sender]);
250         
251         address burner = msg.sender;
252         balances[burner] = balances[burner].sub(_value);
253         totalSupply = totalSupply.sub(_value);
254         totalDistributed = totalDistributed.sub(_value);
255         emit Burn(burner, _value);
256     }
257     
258     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
259         AltcoinToken token = AltcoinToken(_tokenContract);
260         uint256 amount = token.balanceOf(address(this));
261         return token.transfer(owner, amount);
262     }
263 }