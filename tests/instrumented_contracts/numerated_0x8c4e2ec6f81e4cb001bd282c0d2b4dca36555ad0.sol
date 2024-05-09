1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6 
7  * POLY ANALYTIX PROJECT 
8  * Decimals : 8
9  * Total Supply: 20,000,000,000 PLA
10 
11  */
12 library SafeMath {
13 
14     /**
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19             return 0;
20         }
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract ForeignToken {
55     function balanceOf(address _owner) constant public returns (uint256);
56     function transfer(address _to, uint256 _value) public returns (bool);
57 }
58 
59 contract ERC20Basic {
60     uint256 public totalSupply;
61     function balanceOf(address who) public constant returns (uint256);
62     function transfer(address to, uint256 value) public returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public constant returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract PolyAnalytixProjectToken is ERC20 {
74     
75     using SafeMath for uint256;
76     address owner = msg.sender;
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;    
80 
81     string public constant name = "Poly Analytix";
82     string public constant symbol = "PLA";
83     uint public constant decimals = 8;
84     
85     uint256 public totalSupply = 20000000000e8;
86     uint256 public totalDistributed =  4000000000e8;    
87     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; 
88     uint256 public tokensPerEth = 20000000e8;
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     
93     event Distr(address indexed to, uint256 amount);
94     event DistrFinished();
95 
96     event Airdrop(address indexed _owner, uint _amount, uint _balance);
97 
98     event TokensPerEthUpdated(uint _tokensPerEth);
99     
100     event Burn(address indexed burner, uint256 value);
101 
102     bool public distributionFinished = false;
103     
104     modifier canDistr() {
105         require(!distributionFinished);
106         _;
107     }
108     
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113     
114     
115     function PolyAnalytixProjectToken () public {
116         owner = msg.sender;    
117         distr(owner, totalDistributed);
118     }
119     
120     function transferOwnership(address newOwner) onlyOwner public {
121         if (newOwner != address(0)) {
122             owner = newOwner;
123         }
124     }
125     
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         emit DistrFinished();
130         return true;
131     }
132     
133     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
134         totalDistributed = totalDistributed.add(_amount);        
135         balances[_to] = balances[_to].add(_amount);
136         emit Distr(_to, _amount);
137         emit Transfer(address(0), _to, _amount);
138 
139         return true;
140     }
141 
142     function doAirdrop(address _participant, uint _amount) internal {
143 
144         require( _amount > 0 );      
145 
146         require( totalDistributed < totalSupply );
147         
148         balances[_participant] = balances[_participant].add(_amount);
149         totalDistributed = totalDistributed.add(_amount);
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154 
155         // log
156         emit Airdrop(_participant, _amount, balances[_participant]);
157         emit Transfer(address(0), _participant, _amount);
158     }
159 
160     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
161         doAirdrop(_participant, _amount);
162     }
163 
164     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
165         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
166     }
167 
168     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
169         tokensPerEth = _tokensPerEth;
170         emit TokensPerEthUpdated(_tokensPerEth);
171     }
172            
173     function () external payable {
174         getTokens();
175      }
176     
177     function getTokens() payable canDistr  public {
178         uint256 tokens = 0;
179 
180         // minimum contribution
181         require( msg.value >= MIN_CONTRIBUTION );
182 
183         require( msg.value > 0 );
184 
185         // get baseline number of tokens
186         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
187         address investor = msg.sender;
188         
189         if (tokens > 0) {
190             distr(investor, tokens);
191         }
192 
193         if (totalDistributed >= totalSupply) {
194             distributionFinished = true;
195         }
196     }
197 
198     function balanceOf(address _owner) constant public returns (uint256) {
199         return balances[_owner];
200     }
201 
202     // mitigates the ERC20 short address attack
203     modifier onlyPayloadSize(uint size) {
204         assert(msg.data.length >= size + 4);
205         _;
206     }
207     
208     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
209 
210         require(_to != address(0));
211         require(_amount <= balances[msg.sender]);
212         
213         balances[msg.sender] = balances[msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(msg.sender, _to, _amount);
216         return true;
217     }
218     
219     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
220 
221         require(_to != address(0));
222         require(_amount <= balances[_from]);
223         require(_amount <= allowed[_from][msg.sender]);
224         
225         balances[_from] = balances[_from].sub(_amount);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         emit Transfer(_from, _to, _amount);
229         return true;
230     }
231     
232     function approve(address _spender, uint256 _value) public returns (bool success) {
233         // mitigates the ERC20 spend/approval race condition
234         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239     
240     function allowance(address _owner, address _spender) constant public returns (uint256) {
241         return allowed[_owner][_spender];
242     }
243     
244     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
245         ForeignToken t = ForeignToken(tokenAddress);
246         uint bal = t.balanceOf(who);
247         return bal;
248     }
249     
250     function withdraw() onlyOwner public {
251         address myAddress = this;
252         uint256 etherBalance = myAddress.balance;
253         owner.transfer(etherBalance);
254     }
255     
256     function burn(uint256 _value) onlyOwner public {
257         require(_value <= balances[msg.sender]);
258         // no need to require value <= totalSupply, since that would imply the
259         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
260 
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         totalDistributed = totalDistributed.sub(_value);
265         emit Burn(burner, _value);
266     }
267     
268     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
269         ForeignToken token = ForeignToken(_tokenContract);
270         uint256 amount = token.balanceOf(address(this));
271         return token.transfer(owner, amount);
272     }
273 }