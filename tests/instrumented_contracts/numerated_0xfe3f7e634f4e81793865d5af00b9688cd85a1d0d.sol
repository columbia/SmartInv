1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address _owner) constant public returns (uint256);
51     function transfer(address _to, uint256 _value) public returns (bool);
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract BCDXTOKEN is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;   
75     mapping (address => bool) public Claimed;
76 
77     string public constant name = "BCEDEX Token";
78     string public constant symbol = "BCDX";
79     uint public constant decimals = 8;
80     
81     uint256 public totalSupply = 10000000000e8;
82     uint256 public totalDistributed = 0;    
83     uint256 public constant MIN_CONTRIBUTION = 1 ether / 10000; // 0.0001 Ether
84     uint256 public tokensPerEth = 200000e8;
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91 
92     event Airdrop(address indexed _owner, uint _amount, uint _balance);
93 
94     event TokensPerEthUpdated(uint _tokensPerEth);
95     
96     event Burn(address indexed burner, uint256 value);
97     
98     event Add(uint256 value);
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
112      constructor() public {
113         uint256 teamFund = 1800000000e8;
114         owner = msg.sender;
115         distr(owner, teamFund);
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
140     function doAirdrop(address _participant, uint _amount) onlyOwner internal {
141 
142         require(_amount > 0 );      
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
158     function adminClaimAirdrop(address _participant, uint _amount) onlyOwner external {        
159         doAirdrop(_participant, _amount);
160     }
161 
162     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
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
175     function getTokens() payable canDistr public {
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
248     function withdraw() onlyOwner public {
249         address myAddress = this;
250         uint256 etherBalance = myAddress.balance;
251         owner.transfer(etherBalance);
252     }
253     
254     function burn(uint256 _value) onlyOwner public {
255         require(_value <= balances[msg.sender]);
256         // no need to require value <= totalSupply, since that would imply the
257         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258 
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         totalSupply = totalSupply.sub(_value);
262         totalDistributed = totalDistributed.sub(_value);
263         emit Burn(burner, _value);
264     }
265     
266     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
267         ForeignToken token = ForeignToken(_tokenContract);
268         uint256 amount = token.balanceOf(address(this));
269         return token.transfer(owner, amount);
270     }
271 }