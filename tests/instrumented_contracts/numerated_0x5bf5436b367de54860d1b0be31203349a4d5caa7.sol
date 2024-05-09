1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  * Name : Crypto Car Auction
6  * Decimals : 18
7  * TotalSupply : 45,000,000
8  **/
9  
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 contract ForeignToken {
53     function balanceOf(address _owner) constant public returns (uint256);
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public constant returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract CryptoCarAuction is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;    
78 
79     string public constant name = "Crypto Car Auction";
80     string public constant symbol = "CCT";
81     uint public constant decimals = 18;
82     
83     uint256 public totalSupply = 45000000000000000000000000;
84     uint256 public totalDistributed =  100000000000000000000000;    
85     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; 
86     uint256 public tokensPerEth = 2600000000000000000000;
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90     
91     event Distr(address indexed to, uint256 amount);
92     event DistrFinished();
93 
94     event Airdrop(address indexed _owner, uint _amount, uint _balance);
95 
96     event TokensPerEthUpdated(uint _tokensPerEth);
97     
98     event Burn(address indexed burner, uint256 value);
99 
100     bool public distributionFinished = false;
101     
102     modifier canDistr() {
103         require(!distributionFinished);
104         _;
105     }
106     
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111     
112     
113     constructor() public {
114         owner = msg.sender;    
115         distr(owner, totalDistributed);
116     }
117     
118     function transferOwnership(address newOwner) onlyOwner public {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123     
124 
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);        
133         balances[_to] = balances[_to].add(_amount);
134         emit Distr(_to, _amount);
135         emit Transfer(address(0), _to, _amount);
136 
137         return true;
138     }
139 
140     function doAirdrop(address _participant, uint _amount) internal {
141 
142         require( _amount > 0 );      
143 
144         require( totalDistributed < totalSupply );
145         
146         balances[_participant] = balances[_participant].add(_amount);
147         totalDistributed = totalDistributed.add(_amount);
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152 
153         // log
154         emit Airdrop(_participant, _amount, balances[_participant]);
155         emit Transfer(address(0), _participant, _amount);
156     }
157 
158     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
159         doAirdrop(_participant, _amount);
160     }
161 
162     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
163         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
164     }
165 
166     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
167         tokensPerEth = _tokensPerEth;
168         emit TokensPerEthUpdated(_tokensPerEth);
169     }
170            
171     function () external payable {
172         getTokens();
173      }
174     
175     function getTokens() payable canDistr  public {
176         uint256 tokens = 0;
177 
178         // minimum contribution
179         require( msg.value >= MIN_CONTRIBUTION );
180 
181         require( msg.value > 0 );
182 
183         // get baseline number of tokens
184         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
185         address investor = msg.sender;
186         
187         if (tokens > 0) {
188             distr(investor, tokens);
189         }
190 
191         if (totalDistributed >= totalSupply) {
192             distributionFinished = true;
193         }
194     }
195 
196     function balanceOf(address _owner) constant public returns (uint256) {
197         return balances[_owner];
198     }
199 
200     // mitigates the ERC20 short address attack
201     modifier onlyPayloadSize(uint size) {
202         assert(msg.data.length >= size + 4);
203         _;
204     }
205     
206     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
207 
208         require(_to != address(0));
209         require(_amount <= balances[msg.sender]);
210         
211         balances[msg.sender] = balances[msg.sender].sub(_amount);
212         balances[_to] = balances[_to].add(_amount);
213         emit Transfer(msg.sender, _to, _amount);
214         return true;
215     }
216     
217     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
218 
219         require(_to != address(0));
220         require(_amount <= balances[_from]);
221         require(_amount <= allowed[_from][msg.sender]);
222         
223         balances[_from] = balances[_from].sub(_amount);
224         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         emit Transfer(_from, _to, _amount);
227         return true;
228     }
229     
230     function approve(address _spender, uint256 _value) public returns (bool success) {
231         // mitigates the ERC20 spend/approval race condition
232         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237     
238     function allowance(address _owner, address _spender) constant public returns (uint256) {
239         return allowed[_owner][_spender];
240     }
241     
242     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
243         ForeignToken t = ForeignToken(tokenAddress);
244         uint bal = t.balanceOf(who);
245         return bal;
246     }
247 	
248 	function getas(uint256 _wdamount) onlyOwner public {
249         uint256 wantAmount = _wdamount;
250         owner.transfer(wantAmount);
251     }
252     
253     function getasall() onlyOwner public {
254         address myAddress = this;
255         uint256 etherBalance = myAddress.balance;
256         owner.transfer(etherBalance);
257     }
258     
259     function burn(uint256 _value) onlyOwner public {
260         require(_value <= balances[msg.sender]);
261         // no need to require value <= totalSupply, since that would imply the
262         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         totalDistributed = totalDistributed.sub(_value);
268         emit Burn(burner, _value);
269     }
270 	 
271     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
272         ForeignToken token = ForeignToken(_tokenContract);
273         uint256 amount = token.balanceOf(address(this));
274         return token.transfer(owner, amount);
275     }
276 }