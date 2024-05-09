1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'HUMBLE' Token contract with following features
5 //      => ERC20 Compliance
6 //      => SafeMath implementation 
7 //      => Airdrop and Bounty Program
8 //      => Math operations with safety checks
9 //
10 // Name        : HumbleCoin
11 // Symbol      : HMB
12 // Total supply: 25,000,000,000 (25 Billion)
13 // Decimals    : 8
14 
15 /**
16  * @title SafeMath
17  */
18 library SafeMath {
19 
20     /**
21     * Multiplies two numbers, throws on overflow.
22     */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         if (a == 0) {
25             return 0;
26         }
27         c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     /**
33     * Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         // uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return a / b;
40     }
41 
42     /**
43     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     /**
51     * Adds two numbers, throws on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract AltcoinToken {
61     function balanceOf(address _owner) constant public returns (uint256);
62     function transfer(address _to, uint256 _value) public returns (bool);
63 }
64 
65 contract ERC20Basic {
66     uint256 public totalSupply;
67     function balanceOf(address who) public constant returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public constant returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract HumbleCoin is ERC20 {
80     
81     using SafeMath for uint256;
82     address owner = msg.sender;
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;    
86 
87     string public constant name = "HumbleCoin Token";
88     string public constant symbol = "HMB";
89     uint public constant decimals = 8;
90     
91     uint256 public totalSupply = 25000000000e8;
92     uint256 public totalDistributed = 0;        
93     uint256 public tokensPerEth = 25000000e8;
94     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98     
99     event Distr(address indexed to, uint256 amount);
100     event DistrFinished();
101 
102     event Airdrop(address indexed _owner, uint _amount, uint _balance);
103 
104     event TokensPerEthUpdated(uint _tokensPerEth);
105     
106     event Burn(address indexed burner, uint256 value);
107 
108     bool public distributionFinished = false;
109     
110     modifier canDistr() {
111         require(!distributionFinished);
112         _;
113     }
114     
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119     
120     
121     function HumbleCoin () public {
122         owner = msg.sender;
123         uint256 devTokens = 2000000000e8;
124         distr(owner, devTokens);
125     }
126     
127     function transferOwnership(address newOwner) onlyOwner public {
128         if (newOwner != address(0)) {
129             owner = newOwner;
130         }
131     }
132     
133 
134     function finishDistribution() onlyOwner canDistr public returns (bool) {
135         distributionFinished = true;
136         emit DistrFinished();
137         return true;
138     }
139     
140     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
141         totalDistributed = totalDistributed.add(_amount);        
142         balances[_to] = balances[_to].add(_amount);
143         emit Distr(_to, _amount);
144         emit Transfer(address(0), _to, _amount);
145 
146         return true;
147     }
148 
149     function doAirdrop(address _participant, uint _amount) internal {
150 
151         require( _amount > 0 );      
152 
153         require( totalDistributed < totalSupply );
154         
155         balances[_participant] = balances[_participant].add(_amount);
156         totalDistributed = totalDistributed.add(_amount);
157 
158         if (totalDistributed >= totalSupply) {
159             distributionFinished = true;
160         }
161 
162         // log
163         emit Airdrop(_participant, _amount, balances[_participant]);
164         emit Transfer(address(0), _participant, _amount);
165     }
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
180     function () external payable {
181         getTokens();
182      }
183     
184     function getTokens() payable canDistr  public {
185         uint256 tokens = 0;
186 
187         require( msg.value >= minContribution );
188 
189         require( msg.value > 0 );
190         
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
250         AltcoinToken t = AltcoinToken(tokenAddress);
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
263         
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         totalDistributed = totalDistributed.sub(_value);
268         emit Burn(burner, _value);
269     }
270     
271     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
272         AltcoinToken token = AltcoinToken(_tokenContract);
273         uint256 amount = token.balanceOf(address(this));
274         return token.transfer(owner, amount);
275     }
276 }