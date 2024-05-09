1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two numbers, truncating the quotient.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28 
29     /**
30     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract ForeignToken {
48     function balanceOf(address _owner) constant public returns (uint256);
49     function transfer(address _to, uint256 _value) public returns (bool);
50 }
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) public constant returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public constant returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract Socialife is ERC20 {
67     
68     using SafeMath for uint256;
69     address owner = msg.sender;
70 
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;    
73 
74     string public constant name = "Socialife";
75     string public constant symbol = "SLIFE";
76     uint public constant decimals = 8;
77     
78     uint256 public totalSupply = 10000000000e8;
79     uint256 public totalDistributed = 0;    
80     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
81     uint256 public tokensPerEth = 18000000e8;
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85     
86     event Distr(address indexed to, uint256 amount);
87     event DistrFinished();
88 
89     event Airdrop(address indexed _owner, uint _amount, uint _balance);
90 
91     event TokensPerEthUpdated(uint _tokensPerEth);
92     
93     event Burn(address indexed burner, uint256 value);
94 
95     bool public distributionFinished = false;
96     
97     modifier canDistr() {
98         require(!distributionFinished);
99         _;
100     }
101     
102     modifier onlyOwner() {
103         require(msg.sender == owner);
104         _;
105     }
106     
107     
108     function Socialife () public {
109         owner = msg.sender;    
110         distr(owner, totalDistributed);
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
173         // minimum contribution
174         require( msg.value >= MIN_CONTRIBUTION );
175 
176         require( msg.value > 0 );
177 
178         // get baseline number of tokens
179         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
180         address investor = msg.sender;
181         
182         if (tokens > 0) {
183             distr(investor, tokens);
184         }
185 
186         if (totalDistributed >= totalSupply) {
187             distributionFinished = true;
188         }
189     }
190 
191     function balanceOf(address _owner) constant public returns (uint256) {
192         return balances[_owner];
193     }
194 
195     // mitigates the ERC20 short address attack
196     modifier onlyPayloadSize(uint size) {
197         assert(msg.data.length >= size + 4);
198         _;
199     }
200     
201     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
202 
203         require(_to != address(0));
204         require(_amount <= balances[msg.sender]);
205         
206         balances[msg.sender] = balances[msg.sender].sub(_amount);
207         balances[_to] = balances[_to].add(_amount);
208         emit Transfer(msg.sender, _to, _amount);
209         return true;
210     }
211     
212     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
213 
214         require(_to != address(0));
215         require(_amount <= balances[_from]);
216         require(_amount <= allowed[_from][msg.sender]);
217         
218         balances[_from] = balances[_from].sub(_amount);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
220         balances[_to] = balances[_to].add(_amount);
221         emit Transfer(_from, _to, _amount);
222         return true;
223     }
224     
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         // mitigates the ERC20 spend/approval race condition
227         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
228         allowed[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232     
233     function allowance(address _owner, address _spender) constant public returns (uint256) {
234         return allowed[_owner][_spender];
235     }
236     
237     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
238         ForeignToken t = ForeignToken(tokenAddress);
239         uint bal = t.balanceOf(who);
240         return bal;
241     }
242     
243     function withdraw() onlyOwner public {
244         address myAddress = this;
245         uint256 etherBalance = myAddress.balance;
246         owner.transfer(etherBalance);
247     }
248     
249     function burn(uint256 _value) onlyOwner public {
250         require(_value <= balances[msg.sender]);
251         // no need to require value <= totalSupply, since that would imply the
252         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
253 
254         address burner = msg.sender;
255         balances[burner] = balances[burner].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         totalDistributed = totalDistributed.sub(_value);
258         emit Burn(burner, _value);
259     }
260     
261     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
262         ForeignToken token = ForeignToken(_tokenContract);
263         uint256 amount = token.balanceOf(address(this));
264         return token.transfer(owner, amount);
265     }
266 }