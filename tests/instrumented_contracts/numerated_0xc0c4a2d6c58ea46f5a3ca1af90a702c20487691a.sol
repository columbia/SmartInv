1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * Name : AlphaChain (ACH)
7  * Decimals : 18
8  * TotalSupply : 20000000000
9  *
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
72 contract AlphaChain is ERC20 {
73 
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79 
80     string public constant name = "AlphaChain";
81     string public constant symbol = "ACH";
82     uint public constant decimals = 18;
83 
84     uint256 public totalSupply = 20000000000e18;
85     uint256 public totalDistributed = 15000000000e18;
86     uint256 public tokensPerEth = 2000000e18;
87     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
88     uint256 public constant MAX_CONTRIBUTION = 1 ether ; // 1 Ether
89 
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     event Distr(address indexed to, uint256 amount);
95     event DistrFinished();
96 
97     event Airdrop(address indexed _owner, uint _amount, uint _balance);
98 
99     event TokensPerEthUpdated(uint _tokensPerEth);
100 
101     event Burn(address indexed burner, uint256 value);
102 
103     bool public distributionFinished = false;
104 
105     modifier canDistr() {
106         require(!distributionFinished);
107         _;
108     }
109 
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114 
115 
116     function AlphaChainConstructor () public {
117         owner = msg.sender;
118         distr(owner, totalDistributed);
119     }
120 
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126 
127 
128     function finishDistribution() onlyOwner canDistr public returns (bool) {
129         distributionFinished = true;
130         emit DistrFinished();
131         return true;
132     }
133 
134     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
135         totalDistributed = totalDistributed.add(_amount);
136         balances[_to] = balances[_to].add(_amount);
137         emit Distr(_to, _amount);
138         emit Transfer(address(0), _to, _amount);
139 
140         return true;
141     }
142 
143     function doAirdrop(address _participant, uint _amount) internal {
144 
145         require( _amount > 0 );
146 
147         require( totalDistributed < totalSupply );
148 
149         balances[_participant] = balances[_participant].add(_amount);
150         totalDistributed = totalDistributed.add(_amount);
151 
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155 
156         // log
157         emit Airdrop(_participant, _amount, balances[_participant]);
158         emit Transfer(address(0), _participant, _amount);
159     }
160 
161     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {
162         doAirdrop(_participant, _amount);
163     }
164 
165     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {
166         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
167     }
168 
169     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {
170         tokensPerEth = _tokensPerEth;
171         emit TokensPerEthUpdated(_tokensPerEth);
172     }
173 
174     function () external payable {
175         getTokens();
176      }
177 
178     function getTokens() payable canDistr  public {
179         uint256 tokens = 0;
180 
181         require( msg.value >= MIN_CONTRIBUTION );
182         require( msg.value <= MAX_CONTRIBUTION );
183         require( msg.value > 0 );
184         uint256 bonusTokens = 0;
185         
186         tokens = tokensPerEth.mul(msg.value) / 1 ether;
187         if (msg.value >= 1 ether){bonusTokens = tokens.div(2);}
188         else if (msg.value >= 0.5 ether){bonusTokens = tokens.div(4);}
189         else if (msg.value >= 0.25 ether){bonusTokens = tokens.div(10);}
190         else if (msg.value >= 0.05 ether){bonusTokens = tokens.div(20);}
191         
192         tokens += bonusTokens;
193             
194         address investor = msg.sender;
195 
196         if (tokens > 0) {
197             distr(investor, tokens);
198         }
199 
200         if (totalDistributed >= totalSupply) {
201             distributionFinished = true;
202         }
203     }
204 
205     function balanceOf(address _owner) constant public returns (uint256) {
206         return balances[_owner];
207     }
208 
209     // mitigates the ERC20 short address attack
210     modifier onlyPayloadSize(uint size) {
211         assert(msg.data.length >= size + 4);
212         _;
213     }
214 
215     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
216 
217         require(_to != address(0));
218         require(_amount <= balances[msg.sender]);
219 
220         balances[msg.sender] = balances[msg.sender].sub(_amount);
221         balances[_to] = balances[_to].add(_amount);
222         emit Transfer(msg.sender, _to, _amount);
223         return true;
224     }
225 
226     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
227 
228         require(_to != address(0));
229         require(_amount <= balances[_from]);
230         require(_amount <= allowed[_from][msg.sender]);
231 
232         balances[_from] = balances[_from].sub(_amount);
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         emit Transfer(_from, _to, _amount);
236         return true;
237     }
238 
239     function approve(address _spender, uint256 _value) public returns (bool success) {
240         // mitigates the ERC20 spend/approval race condition
241         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247     function allowance(address _owner, address _spender) constant public returns (uint256) {
248         return allowed[_owner][_spender];
249     }
250 
251     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
252         ForeignToken t = ForeignToken(tokenAddress);
253         uint bal = t.balanceOf(who);
254         return bal;
255     }
256 
257     function withdraw() onlyOwner public {
258         address myAddress = this;
259         uint256 etherBalance = myAddress.balance;
260         owner.transfer(etherBalance);
261     }
262 
263     function burn(uint256 _value) onlyOwner public {
264         require(_value <= balances[msg.sender]);
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