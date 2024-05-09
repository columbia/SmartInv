1 pragma solidity ^0.4.21;
2 
3 //------ Verified Smart Contract -----
4 //------ SourceCode by bayurheza ------
5   
6 // ----------------------------------------------------------------------------
7 // 'XGO' Token contract with following features
8 //      => ERC20 Compliance
9 //      => SafeMath implementation 
10 //      => Airdrop and Bounty Program
11 //      => Math operations with safety checks
12 //      => Aigo Smartcontract Development
13 //
14 // Name        : AIGO Protocol
15 // Symbol      : XGO
16 // Total supply: 200,000,000 
17 // Decimals    : 18
18 
19 /**
20  * Math operations with safety checks
21  * AIGO Smartcontract Development
22  */
23 library SafeMath {
24 
25     /**
26     * Multiplies two numbers, throws on overflow.
27     */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     /**
38     * Integer division of two numbers, truncating the quotient.
39     */
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         // uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return a / b;
45     }
46 
47     /**
48     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     /**
56     * Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 
65 contract AltcoinToken {
66     function balanceOf(address _owner) constant public returns (uint256);
67     function transfer(address _to, uint256 _value) public returns (bool);
68 }
69 
70 contract ERC20Basic {
71     uint256 public totalSupply;
72     function balanceOf(address who) public constant returns (uint256);
73     function transfer(address to, uint256 value) public returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public constant returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract AIGOPay is ERC20 {
85     
86     using SafeMath for uint256;
87     address owner = msg.sender;
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;    
91 
92     string public constant name = "AIGOPay";
93     string public constant symbol = "XGO";
94     uint public constant decimals = 18;
95     
96     uint256 public totalSupply = 200000000e18;
97     uint256 public totalDistributed = 0;        
98     uint256 public tokensPerEth = 0e8;
99     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
100 
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103     
104     event Distr(address indexed to, uint256 amount);
105     event DistrFinished();
106 
107     event Airdrop(address indexed _owner, uint _amount, uint _balance);
108 
109     event TokensPerEthUpdated(uint _tokensPerEth);
110     
111     event Burn(address indexed burner, uint256 value);
112 
113     bool public distributionFinished = false;
114     
115     modifier canDistr() {
116         require(!distributionFinished);
117         _;
118     }
119     
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124     
125     
126     function AIGOPay () public {
127         owner = msg.sender;
128         uint256 devTokens = 1000000e18;
129         distr(owner, devTokens);
130     }
131     
132     function transferOwnership(address newOwner) onlyOwner public {
133         if (newOwner != address(0)) {
134             owner = newOwner;
135         }
136     }
137     
138 
139     function finishDistribution() onlyOwner canDistr public returns (bool) {
140         distributionFinished = true;
141         emit DistrFinished();
142         return true;
143     }
144     
145     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
146         totalDistributed = totalDistributed.add(_amount);        
147         balances[_to] = balances[_to].add(_amount);
148         emit Distr(_to, _amount);
149         emit Transfer(address(0), _to, _amount);
150 
151         return true;
152     }
153 
154     function doAirdrop(address _participant, uint _amount) internal {
155 
156         require( _amount > 0 );      
157 
158         require( totalDistributed < totalSupply );
159         
160         balances[_participant] = balances[_participant].add(_amount);
161         totalDistributed = totalDistributed.add(_amount);
162 
163         if (totalDistributed >= totalSupply) {
164             distributionFinished = true;
165         }
166 
167         // log
168         emit Airdrop(_participant, _amount, balances[_participant]);
169         emit Transfer(address(0), _participant, _amount);
170     }
171 
172     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
173         doAirdrop(_participant, _amount);
174     }
175 
176     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
177         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
178     }
179 
180     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
181         tokensPerEth = _tokensPerEth;
182         emit TokensPerEthUpdated(_tokensPerEth);
183     }
184            
185     function () external payable {
186         getTokens();
187      }
188     
189     function getTokens() payable canDistr  public {
190         uint256 tokens = 0;
191 
192         require( msg.value >= minContribution );
193 
194         require( msg.value > 0 );
195         
196         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
197         address investor = msg.sender;
198         
199         if (tokens > 0) {
200             distr(investor, tokens);
201         }
202 
203         if (totalDistributed >= totalSupply) {
204             distributionFinished = true;
205         }
206     }
207 
208     function balanceOf(address _owner) constant public returns (uint256) {
209         return balances[_owner];
210     }
211 
212     // mitigates the ERC20 short address attack
213     modifier onlyPayloadSize(uint size) {
214         assert(msg.data.length >= size + 4);
215         _;
216     }
217     
218     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
219 
220         require(_to != address(0));
221         require(_amount <= balances[msg.sender]);
222         
223         balances[msg.sender] = balances[msg.sender].sub(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         emit Transfer(msg.sender, _to, _amount);
226         return true;
227     }
228     
229     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
230 
231         require(_to != address(0));
232         require(_amount <= balances[_from]);
233         require(_amount <= allowed[_from][msg.sender]);
234         
235         balances[_from] = balances[_from].sub(_amount);
236         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         emit Transfer(_from, _to, _amount);
239         return true;
240     }
241     
242     function approve(address _spender, uint256 _value) public returns (bool success) {
243         // mitigates the ERC20 spend/approval race condition
244         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249     
250     function allowance(address _owner, address _spender) constant public returns (uint256) {
251         return allowed[_owner][_spender];
252     }
253     
254     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
255         AltcoinToken t = AltcoinToken(tokenAddress);
256         uint bal = t.balanceOf(who);
257         return bal;
258     }
259     
260     function withdraw() onlyOwner public {
261         address myAddress = this;
262         uint256 etherBalance = myAddress.balance;
263         owner.transfer(etherBalance);
264     }
265     
266     function burn(uint256 _value) onlyOwner public {
267         require(_value <= balances[msg.sender]);
268         
269         address burner = msg.sender;
270         balances[burner] = balances[burner].sub(_value);
271         totalSupply = totalSupply.sub(_value);
272         totalDistributed = totalDistributed.sub(_value);
273         emit Burn(burner, _value);
274     }
275     
276     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
277         AltcoinToken token = AltcoinToken(_tokenContract);
278         uint256 amount = token.balanceOf(address(this));
279         return token.transfer(owner, amount);
280     }
281 }