1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  *
7  * Official Token of Cryptrust Platform
8  * Decentralized Trust-Based Social Network
9  * https://www.cryptrust.io
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract ForeignToken {
54     function balanceOf(address _owner) constant public returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56 }
57 
58 contract ERC20Basic {
59     uint256 public totalSupply;
60     function balanceOf(address who) public constant returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract CryptrustToken is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "Cryptrust";
81     string public constant symbol = "CTRT";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 37000000000e8;
85     uint256 public totalDistributed =  7000000000e8;    
86     uint256 public constant MIN_CONTRIBUTION = 1 ether / 50; // 0.02 Ether
87     uint256 public tokensPerEth = 10000000e8;
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94 
95     event Airdrop(address indexed _owner, uint _amount, uint _balance);
96 
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     
99     event Burn(address indexed burner, uint256 value);
100 
101     bool public distributionFinished = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     
114     function CryptrustToken () public {
115         owner = msg.sender;    
116         distr(owner, totalDistributed);
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124     
125 
126     function finishDistribution() onlyOwner canDistr public returns (bool) {
127         distributionFinished = true;
128         emit DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);        
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137 
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
159     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
160         doAirdrop(_participant, _amount);
161     }
162 
163     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
164         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
165     }
166 
167     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
168         tokensPerEth = _tokensPerEth;
169         emit TokensPerEthUpdated(_tokensPerEth);
170     }
171            
172     function () external payable {
173         getTokens();
174      }
175     
176     function getTokens() payable canDistr  public {
177         uint256 tokens = 0;
178 
179         // minimum contribution
180         require( msg.value >= MIN_CONTRIBUTION );
181 
182         require( msg.value > 0 );
183 
184         // get baseline number of tokens
185         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
186         address investor = msg.sender;
187         
188         if (tokens > 0) {
189             distr(investor, tokens);
190         }
191 
192         if (totalDistributed >= totalSupply) {
193             distributionFinished = true;
194         }
195     }
196 
197     function balanceOf(address _owner) constant public returns (uint256) {
198         return balances[_owner];
199     }
200 
201     // mitigates the ERC20 short address attack
202     modifier onlyPayloadSize(uint size) {
203         assert(msg.data.length >= size + 4);
204         _;
205     }
206     
207     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
208 
209         require(_to != address(0));
210         require(_amount <= balances[msg.sender]);
211         
212         balances[msg.sender] = balances[msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Transfer(msg.sender, _to, _amount);
215         return true;
216     }
217     
218     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
219 
220         require(_to != address(0));
221         require(_amount <= balances[_from]);
222         require(_amount <= allowed[_from][msg.sender]);
223         
224         balances[_from] = balances[_from].sub(_amount);
225         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
226         balances[_to] = balances[_to].add(_amount);
227         emit Transfer(_from, _to, _amount);
228         return true;
229     }
230     
231     function approve(address _spender, uint256 _value) public returns (bool success) {
232         // mitigates the ERC20 spend/approval race condition
233         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
234         allowed[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     function allowance(address _owner, address _spender) constant public returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242     
243     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
244         ForeignToken t = ForeignToken(tokenAddress);
245         uint bal = t.balanceOf(who);
246         return bal;
247     }
248     
249     function withdraw() onlyOwner public {
250         address myAddress = this;
251         uint256 etherBalance = myAddress.balance;
252         owner.transfer(etherBalance);
253     }
254     
255     function burn(uint256 _value) onlyOwner public {
256         require(_value <= balances[msg.sender]);
257         // no need to require value <= totalSupply, since that would imply the
258         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
259 
260         address burner = msg.sender;
261         balances[burner] = balances[burner].sub(_value);
262         totalSupply = totalSupply.sub(_value);
263         totalDistributed = totalDistributed.sub(_value);
264         emit Burn(burner, _value);
265     }
266     
267     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
268         ForeignToken token = ForeignToken(_tokenContract);
269         uint256 amount = token.balanceOf(address(this));
270         return token.transfer(owner, amount);
271     }
272 }