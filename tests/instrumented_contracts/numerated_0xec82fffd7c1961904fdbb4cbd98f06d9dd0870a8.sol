1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Name : DeltaChain (Delta)
9  * Decimals : 8
10  * TotalSupply : 30000000000
11  * 
12  * 
13  * 
14  * 
15  */
16 library SafeMath {
17 
18     /**
19     * @dev Multiplies two numbers, throws on overflow.
20     */
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         // uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return a / b;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 contract ForeignToken {
59     function balanceOf(address _owner) constant public returns (uint256);
60     function transfer(address _to, uint256 _value) public returns (bool);
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) public constant returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ERC20 is ERC20Basic {
71     function allowance(address owner, address spender) public constant returns (uint256);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract DeltaChainToken is ERC20 {
78     
79     using SafeMath for uint256;
80     address owner = msg.sender;
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;    
84 
85     string public constant name = "DeltaChain";
86     string public constant symbol = "Delta";
87     uint public constant decimals = 8;
88     
89     uint256 public totalSupply = 30000000000e8;
90     uint256 public totalDistributed =  8000000000e8;    
91     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
92     uint256 public tokensPerEth = 300000000e8;
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     event Distr(address indexed to, uint256 amount);
98     event DistrFinished();
99 
100     event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102     event TokensPerEthUpdated(uint _tokensPerEth);
103     
104     event Burn(address indexed burner, uint256 value);
105 
106     bool public distributionFinished = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     
119     function DeltaChainToken () public {
120         owner = msg.sender;    
121         distr(owner, totalDistributed);
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129     
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145 
146     function doAirdrop(address _participant, uint _amount) internal {
147 
148         require( _amount > 0 );      
149 
150         require( totalDistributed < totalSupply );
151         
152         balances[_participant] = balances[_participant].add(_amount);
153         totalDistributed = totalDistributed.add(_amount);
154 
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158 
159         // log
160         emit Airdrop(_participant, _amount, balances[_participant]);
161         emit Transfer(address(0), _participant, _amount);
162     }
163 
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
247     function withdraw() onlyOwner public {
248         address myAddress = this;
249         uint256 etherBalance = myAddress.balance;
250         owner.transfer(etherBalance);
251     }
252     
253     function burn(uint256 _value) onlyOwner public {
254         require(_value <= balances[msg.sender]);
255         // no need to require value <= totalSupply, since that would imply the
256         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
257 
258         address burner = msg.sender;
259         balances[burner] = balances[burner].sub(_value);
260         totalSupply = totalSupply.sub(_value);
261         totalDistributed = totalDistributed.sub(_value);
262         emit Burn(burner, _value);
263     }
264     
265     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
266         ForeignToken token = ForeignToken(_tokenContract);
267         uint256 amount = token.balanceOf(address(this));
268         return token.transfer(owner, amount);
269     }
270 }