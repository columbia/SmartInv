1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Name : BLOCKMALL (BKM)
9  * Decimals : 18
10  * TotalSupply : 2000000000
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
77 contract BLOCKMALLToken is ERC20 {
78     
79     using SafeMath for uint256;
80     address owner = msg.sender;
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;    
84 
85     string public constant name = "BlockMall";
86     string public constant symbol = "BKM";
87     uint public constant decimals = 18;
88     
89     uint256 public totalSupply = 2000000000e18;
90     uint256 public totalDistributed = 100000000e18;    
91     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
92     uint256 public tokensPerEth = 10000000e18;
93     
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
120     function BLOCKMALLToken () public {
121         owner = msg.sender;    
122         distr(owner, totalDistributed);
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130     
131 
132     function finishDistribution() onlyOwner canDistr public returns (bool) {
133         distributionFinished = true;
134         emit DistrFinished();
135         return true;
136     }
137     
138     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
139         totalDistributed = totalDistributed.add(_amount);        
140         balances[_to] = balances[_to].add(_amount);
141         emit Distr(_to, _amount);
142         emit Transfer(address(0), _to, _amount);
143 
144         return true;
145     }
146 
147     function doAirdrop(address _participant, uint _amount) internal {
148 
149         require( _amount > 0 );      
150 
151         require( totalDistributed < totalSupply );
152         
153         balances[_participant] = balances[_participant].add(_amount);
154         totalDistributed = totalDistributed.add(_amount);
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159 
160         // log
161         emit Airdrop(_participant, _amount, balances[_participant]);
162         emit Transfer(address(0), _participant, _amount);
163     }
164 
165     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
166         doAirdrop(_participant, _amount);
167     }
168 
169     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
170         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
171     }
172 
173     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
174         tokensPerEth = _tokensPerEth;
175         emit TokensPerEthUpdated(_tokensPerEth);
176     }
177            
178     function () external payable {
179         getTokens();
180      }
181     
182     function getTokens() payable canDistr  public {
183         uint256 tokens = 0;
184 
185         // minimum contribution
186         require( msg.value >= MIN_CONTRIBUTION );
187 
188         require( msg.value > 0 );
189 
190         // get baseline number of tokens
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
250         ForeignToken t = ForeignToken(tokenAddress);
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
263         // no need to require value <= totalSupply, since that would imply the
264         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
265 
266         address burner = msg.sender;
267         balances[burner] = balances[burner].sub(_value);
268         totalSupply = totalSupply.sub(_value);
269         totalDistributed = totalDistributed.sub(_value);
270         emit Burn(burner, _value);
271     }
272     
273     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
274         ForeignToken token = ForeignToken(_tokenContract);
275         uint256 amount = token.balanceOf(address(this));
276         return token.transfer(owner, amount);
277     }
278 }