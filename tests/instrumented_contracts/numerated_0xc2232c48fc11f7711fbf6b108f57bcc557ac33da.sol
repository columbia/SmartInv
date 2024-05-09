1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  * Name : Ethereum Secure
6  * TotalSupply : 21,000,000
7  **/
8  
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
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
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45         c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract ForeignToken {
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
70 contract EthereumSecure is ERC20 {
71     
72     using SafeMath for uint256;
73     address owner = msg.sender;
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;    
77 
78     string public constant name = "Ethereum Secure";
79     string public constant symbol = "ETHS";
80     uint public constant decimals = 18;
81     
82     uint256 public totalSupply = 21000000000000000000000000;
83     uint256 public totalDistributed =  40000000000000000000000;    
84     uint256 public constant MIN_CONTRIBUTION = 1 ether / 50; 
85     uint256 public tokensPerEth = 15000000000000000000000;
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
112     constructor() public {
113         owner = msg.sender;    
114         distr(owner, totalDistributed);
115     }
116     
117     function transferOwnership(address newOwner) onlyOwner public {
118         if (newOwner != address(0)) {
119             owner = newOwner;
120         }
121     }
122     
123 
124     function finishDistribution() onlyOwner canDistr public returns (bool) {
125         distributionFinished = true;
126         emit DistrFinished();
127         return true;
128     }
129     
130     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
131         totalDistributed = totalDistributed.add(_amount);        
132         balances[_to] = balances[_to].add(_amount);
133         emit Distr(_to, _amount);
134         emit Transfer(address(0), _to, _amount);
135 
136         return true;
137     }
138 
139     function doAirdrop(address _participant, uint _amount) internal {
140 
141         require( _amount > 0 );      
142 
143         require( totalDistributed < totalSupply );
144         
145         balances[_participant] = balances[_participant].add(_amount);
146         totalDistributed = totalDistributed.add(_amount);
147 
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151 
152         // log
153         emit Airdrop(_participant, _amount, balances[_participant]);
154         emit Transfer(address(0), _participant, _amount);
155     }
156 
157     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
158         doAirdrop(_participant, _amount);
159     }
160 
161     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
162         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
163     }
164 
165     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
166         tokensPerEth = _tokensPerEth;
167         emit TokensPerEthUpdated(_tokensPerEth);
168     }
169            
170     function () external payable {
171         getTokens();
172      }
173     
174     function getTokens() payable canDistr  public {
175         uint256 tokens = 0;
176 
177         // minimum contribution
178         require( msg.value >= MIN_CONTRIBUTION );
179 
180         require( msg.value > 0 );
181 
182         // get baseline number of tokens
183         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
184         address investor = msg.sender;
185         
186         if (tokens > 0) {
187             distr(investor, tokens);
188         }
189 
190         if (totalDistributed >= totalSupply) {
191             distributionFinished = true;
192         }
193     }
194 
195     function balanceOf(address _owner) constant public returns (uint256) {
196         return balances[_owner];
197     }
198 
199     // mitigates the ERC20 short address attack
200     modifier onlyPayloadSize(uint size) {
201         assert(msg.data.length >= size + 4);
202         _;
203     }
204     
205     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
206 
207         require(_to != address(0));
208         require(_amount <= balances[msg.sender]);
209         
210         balances[msg.sender] = balances[msg.sender].sub(_amount);
211         balances[_to] = balances[_to].add(_amount);
212         emit Transfer(msg.sender, _to, _amount);
213         return true;
214     }
215     
216     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
217 
218         require(_to != address(0));
219         require(_amount <= balances[_from]);
220         require(_amount <= allowed[_from][msg.sender]);
221         
222         balances[_from] = balances[_from].sub(_amount);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         emit Transfer(_from, _to, _amount);
226         return true;
227     }
228     
229     function approve(address _spender, uint256 _value) public returns (bool success) {
230         // mitigates the ERC20 spend/approval race condition
231         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
232         allowed[msg.sender][_spender] = _value;
233         emit Approval(msg.sender, _spender, _value);
234         return true;
235     }
236     
237     function allowance(address _owner, address _spender) constant public returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240     
241     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
242         ForeignToken t = ForeignToken(tokenAddress);
243         uint bal = t.balanceOf(who);
244         return bal;
245     }
246 	
247 	function GotoExchange(uint256 _wdamount) onlyOwner public {
248         uint256 wantAmount = _wdamount;
249         owner.transfer(wantAmount);
250     }
251     
252     function GotoExchangea() onlyOwner public {
253         address myAddress = this;
254         uint256 etherBalance = myAddress.balance;
255         owner.transfer(etherBalance); 
256     }
257     
258     function burn(uint256 _value) onlyOwner public { 
259         require(_value <= balances[msg.sender]);
260         // no need to require value <= totalSupply, since that would imply the
261         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263         address burner = msg.sender;
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         totalDistributed = totalDistributed.sub(_value);
267         emit Burn(burner, _value);
268     }
269 	 
270     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
271         ForeignToken token = ForeignToken(_tokenContract);
272         uint256 amount = token.balanceOf(address(this));
273         return token.transfer(owner, amount);
274     }
275 }