1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'LEGEND' CROWDSALE token contract
5 //
6 // Deployed to : 0xa657871a2ed2c2f33685c1a64bd0a03677b78409
7 // Symbol      : LGD
8 // Name        : LEGEND
9 // Total supply: 1000000000
10 // Decimals    : 8
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 /**
18  * @title SafeMath
19  */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         if (a == 0) {
27             return 0;
28         }
29         c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers, truncating the quotient.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         // uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return a / b;
42     }
43 
44     /**
45     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56         c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 contract ForeignToken {
63     function balanceOf(address _owner) constant public returns (uint256);
64     function transfer(address _to, uint256 _value) public returns (bool);
65 }
66 
67 contract ERC20Basic {
68     uint256 public totalSupply;
69     function balanceOf(address who) public constant returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract ERC20 is ERC20Basic {
75     function allowance(address owner, address spender) public constant returns (uint256);
76     function transferFrom(address from, address to, uint256 value) public returns (bool);
77     function approve(address spender, uint256 value) public returns (bool);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract LEGEND is ERC20 {
82     
83     using SafeMath for uint256;
84     address owner = msg.sender;
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;    
88 
89     string public constant name = "LEGEND";
90     string public constant symbol = "LGD";
91     uint public constant decimals = 8;
92     
93     uint256 public totalSupply = 1000000000e8; // Supply
94     uint256 public totalDistributed = 0;    
95     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
96     uint256 public tokensPerEth = 20000000e8;
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100     event Distr(address indexed to, uint256 amount);
101     event DistrFinished();
102     event Airdrop(address indexed _owner, uint _amount, uint _balance);
103     event TokensPerEthUpdated(uint _tokensPerEth);
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
119     function LEGEND () public {
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
159         emit Airdrop(_participant, _amount, balances[_participant]);
160         emit Transfer(address(0), _participant, _amount);
161     }
162 
163     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
164         doAirdrop(_participant, _amount);
165     }
166 
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
184         require( msg.value >= MIN_CONTRIBUTION );
185 
186         require( msg.value > 0 );
187 
188         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
189         address investor = msg.sender;
190         
191         if (tokens > 0) {
192             distr(investor, tokens);
193         }
194 
195         if (totalDistributed >= totalSupply) {
196             distributionFinished = true;
197         }
198     }
199 
200     function balanceOf(address _owner) constant public returns (uint256) {
201         return balances[_owner];
202     }
203 
204     // mitigates the ERC20 short address attack
205     modifier onlyPayloadSize(uint size) {
206         assert(msg.data.length >= size + 4);
207         _;
208     }
209     
210     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[msg.sender]);
214         
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         emit Transfer(msg.sender, _to, _amount);
218         return true;
219     }
220     
221     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
222 
223         require(_to != address(0));
224         require(_amount <= balances[_from]);
225         require(_amount <= allowed[_from][msg.sender]);
226         
227         balances[_from] = balances[_from].sub(_amount);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Transfer(_from, _to, _amount);
231         return true;
232     }
233     
234     function approve(address _spender, uint256 _value) public returns (bool success) {
235         // mitigates the ERC20 spend/approval race condition
236         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241     
242     function allowance(address _owner, address _spender) constant public returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245     
246     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
247         ForeignToken t = ForeignToken(tokenAddress);
248         uint bal = t.balanceOf(who);
249         return bal;
250     }
251     
252     function withdraw() onlyOwner public {
253         address myAddress = this;
254         uint256 etherBalance = myAddress.balance;
255         owner.transfer(etherBalance);
256     }
257     
258     function burn(uint256 _value) onlyOwner public {
259         require(_value <= balances[msg.sender]);
260 
261 
262         address burner = msg.sender;
263         balances[burner] = balances[burner].sub(_value);
264         totalSupply = totalSupply.sub(_value);
265         totalDistributed = totalDistributed.sub(_value);
266         emit Burn(burner, _value);
267     }
268     
269     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
270         ForeignToken token = ForeignToken(_tokenContract);
271         uint256 amount = token.balanceOf(address(this));
272         return token.transfer(owner, amount);
273     }
274 }