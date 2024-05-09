1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Project : Genki (GENKI)
9  * Decimals : 8
10  * TotalSupply : 5000000000
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
77 contract GenkiProject is ERC20 {
78     
79     using SafeMath for uint256;
80     address owner = msg.sender;
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;    
84 
85     string public constant name = "Genki";
86     string public constant symbol = "GENKI";
87     uint public constant decimals = 8;
88     
89     uint256 public totalSupply = 5000000000e8;
90     uint256 public totalDistributed =  1000000000e8;    
91     uint256 public constant MIN_CONTRIBUTION = 1 ether / 1000; 
92     uint256 public tokensPerEth = 200000e8;
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
119     function GenkiProject () public {
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
164     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
165         doAirdrop(_participant, _amount);
166     }
167 
168     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
169         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
170     }
171 
172     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
173         tokensPerEth = _tokensPerEth;
174         emit TokensPerEthUpdated(_tokensPerEth);
175     }
176            
177     function () external payable {
178         getTokens();
179      }
180     
181     function getTokens() payable canDistr  public {
182         uint256 tokens = 0;
183 
184         // minimum contribution
185         require( msg.value >= MIN_CONTRIBUTION );
186 
187         require( msg.value > 0 );
188 
189         // get baseline number of tokens
190         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
191         address investor = msg.sender;
192         
193         if (tokens > 0) {
194             distr(investor, tokens);
195         }
196 
197         if (totalDistributed >= totalSupply) {
198             distributionFinished = true;
199         }
200     }
201 
202     function balanceOf(address _owner) constant public returns (uint256) {
203         return balances[_owner];
204     }
205 
206     // mitigates the ERC20 short address attack
207     modifier onlyPayloadSize(uint size) {
208         assert(msg.data.length >= size + 4);
209         _;
210     }
211     
212     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
213 
214         require(_to != address(0));
215         require(_amount <= balances[msg.sender]);
216         
217         balances[msg.sender] = balances[msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(msg.sender, _to, _amount);
220         return true;
221     }
222     
223     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
224 
225         require(_to != address(0));
226         require(_amount <= balances[_from]);
227         require(_amount <= allowed[_from][msg.sender]);
228         
229         balances[_from] = balances[_from].sub(_amount);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         emit Transfer(_from, _to, _amount);
233         return true;
234     }
235     
236     function approve(address _spender, uint256 _value) public returns (bool success) {
237         // mitigates the ERC20 spend/approval race condition
238         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
239         allowed[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243     
244     function allowance(address _owner, address _spender) constant public returns (uint256) {
245         return allowed[_owner][_spender];
246     }
247     
248     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
249         ForeignToken t = ForeignToken(tokenAddress);
250         uint bal = t.balanceOf(who);
251         return bal;
252     }
253     
254     function withdraw() onlyOwner public {
255         address myAddress = this;
256         uint256 etherBalance = myAddress.balance;
257         owner.transfer(etherBalance);
258     }
259     
260     function burn(uint256 _value) onlyOwner public {
261         require(_value <= balances[msg.sender]);
262         // no need to require value <= totalSupply, since that would imply the
263         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
264 
265         address burner = msg.sender;
266         balances[burner] = balances[burner].sub(_value);
267         totalSupply = totalSupply.sub(_value);
268         totalDistributed = totalDistributed.sub(_value);
269         emit Burn(burner, _value);
270     }
271     
272     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
273         ForeignToken token = ForeignToken(_tokenContract);
274         uint256 amount = token.balanceOf(address(this));
275         return token.transfer(owner, amount);
276     }
277 }