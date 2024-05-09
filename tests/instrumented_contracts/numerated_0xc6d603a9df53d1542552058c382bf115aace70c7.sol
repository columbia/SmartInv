1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ForeignToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract TRET is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Tourist Review";
76     string public constant symbol = "TRET";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 20000000000e8;
80     uint256 public totalDistributed =  0;    
81     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
82     uint256 public tokensPerEth     = 20000000e8;
83     uint256 public tokenPublicSale  = 14000000000e8;
84     bool    public _openTrade   = false;
85     uint256 public soldToken    = 0;
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
112     function TRET () public {
113         owner = msg.sender;    
114     }
115     
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121     
122 
123     function finishDistribution() onlyOwner canDistr public returns (bool) {
124         distributionFinished = true;
125         emit DistrFinished();
126         return true;
127     }
128     
129     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
130         totalDistributed = totalDistributed.add(_amount);        
131         balances[_to] = balances[_to].add(_amount);
132         emit Distr(_to, _amount);
133         emit Transfer(address(0), _to, _amount);
134 
135         if (totalDistributed >= totalSupply) {
136             distributionFinished = true;
137         }
138         return true;
139     }
140 
141     function doAirdrop(address _participant, uint _amount) internal {
142 
143         require( _amount > 0 );      
144 
145         require( totalDistributed < totalSupply );
146         
147         balances[_participant] = balances[_participant].add(_amount);
148         totalDistributed = totalDistributed.add(_amount);
149 
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153 
154         // log
155         emit Airdrop(_participant, _amount, balances[_participant]);
156         emit Transfer(address(0), _participant, _amount);
157     }
158 	
159 
160 	function adminBurnToken(uint _amount) public onlyOwner{
161 	
162 		address burner = msg.sender;
163 		balances[burner] = balances[burner].add(_amount);
164 		burn(_amount);
165 	}
166 	 
167     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
168         doAirdrop(_participant, _amount);
169     }
170 
171     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
172         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
173     }
174 
175     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
176         tokensPerEth = _tokensPerEth;
177         emit TokensPerEthUpdated(_tokensPerEth);
178     }
179     
180     
181     function updateTradeStatus(bool _value) public onlyOwner{
182         _openTrade = _value;
183     }
184     
185     function updatePublicSale(uint256 _value) public onlyOwner{
186         tokenPublicSale = _value;
187     }
188            
189     function () external payable {
190         getTokens();
191      }
192     
193     function getTokens() payable canDistr  public {
194         uint256 tokens = 0;
195         
196         require(_openTrade);
197         
198         // minimum contribution
199         require( msg.value >= MIN_CONTRIBUTION );
200 
201         require( msg.value > 0 );
202 
203         // get baseline number of tokens
204         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
205         address investor = msg.sender;
206         
207         if (tokens > 0) {
208             distr(investor, tokens);
209             soldToken += tokens;
210         }
211 
212         if (soldToken >= tokenPublicSale) {
213             _openTrade = false;
214         }
215         owner.transfer(msg.value);
216     }
217 
218     function balanceOf(address _owner) constant public returns (uint256) {
219         return balances[_owner];
220     }
221 
222     // mitigates the ERC20 short address attack
223     modifier onlyPayloadSize(uint size) {
224         assert(msg.data.length >= size + 4);
225         _;
226     }
227     
228     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
229 
230         require(_to != address(0));
231         require(_amount <= balances[msg.sender]);
232         
233         balances[msg.sender] = balances[msg.sender].sub(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         emit Transfer(msg.sender, _to, _amount);
236         return true;
237     }
238     
239     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
240 
241         require(_to != address(0));
242         require(_amount <= balances[_from]);
243         require(_amount <= allowed[_from][msg.sender]);
244         
245         balances[_from] = balances[_from].sub(_amount);
246         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         emit Transfer(_from, _to, _amount);
249         return true;
250     }
251     
252     function approve(address _spender, uint256 _value) public returns (bool success) {
253         // mitigates the ERC20 spend/approval race condition
254         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
255         allowed[msg.sender][_spender] = _value;
256         emit Approval(msg.sender, _spender, _value);
257         return true;
258     }
259     
260     function allowance(address _owner, address _spender) constant public returns (uint256) {
261         return allowed[_owner][_spender];
262     }
263     
264     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
265         ForeignToken t = ForeignToken(tokenAddress);
266         uint bal = t.balanceOf(who);
267         return bal;
268     }
269     
270     function withdraw() onlyOwner public {
271         address myAddress = this;
272         uint256 etherBalance = myAddress.balance;
273         owner.transfer(etherBalance);
274     }
275     
276     function burn(uint256 _value) onlyOwner public {
277         require(_value <= balances[msg.sender]);
278         // no need to require value <= totalSupply, since that would imply the
279         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
280 
281         address burner = msg.sender;
282         balances[burner] = balances[burner].sub(_value);
283         totalSupply = totalSupply.sub(_value);
284         //totalDistributed = totalDistributed.sub(_value);
285         emit Burn(burner, _value);
286     }
287     
288     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
289         ForeignToken token = ForeignToken(_tokenContract);
290         uint256 amount = token.balanceOf(address(this));
291         return token.transfer(owner, amount);
292     }
293 }