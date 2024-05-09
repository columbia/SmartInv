1 //     INFORMATION
2 //  Name: YlifeToken
3 //  Symbol: YLF
4 //  Decimal: 8
5 //  Supply: 8,000,000,000
6 // 
7 //
8 //
9 //
10 //
11 //  Website = http://ylifetoken.com/   Twitter = https://twitter.com/YLIFEOFFICIAL
12 //
13 //
14 //  Telegram = https://t.me/YLIFEOFFICIAL  Medium = https://medium.com/@YLIFEOFFICIAL
15 //
16 //
17 // 
18 // 
19 //
20 // YlifeToken 
21 
22 pragma solidity ^0.4.18;
23 
24 /**
25  * @title SafeMath
26  */
27 library SafeMath {
28 
29     /**
30     * Multiplies two numbers, throws on overflow.
31     */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33         if (a == 0) {
34             return 0;
35         }
36         c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     /**
42     * Integer division of two numbers, truncating the quotient.
43     */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         // assert(b > 0); // Solidity automatically throws when dividing by 0
46         // uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return a / b;
49     }
50 
51     /**
52     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     /**
60     * Adds two numbers, throws on overflow.
61     */
62     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63         c = a + b;
64         assert(c >= a);
65         return c;
66     }
67 }
68 
69 contract AltcoinToken {
70     function balanceOf(address _owner) constant public returns (uint256);
71     function transfer(address _to, uint256 _value) public returns (bool);
72 }
73 
74 contract ERC20Basic {
75     uint256 public totalSupply;
76     function balanceOf(address who) public constant returns (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) public constant returns (uint256);
83     function transferFrom(address from, address to, uint256 value) public returns (bool);
84     function approve(address spender, uint256 value) public returns (bool);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 contract YlifeToken is ERC20 {
89     
90     using SafeMath for uint256;
91     address owner = msg.sender;
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;    
95 
96     string public constant name = "YlifeToken";
97     string public constant symbol = "YLF";
98     uint public constant decimals = 8;
99     
100     uint256 public totalSupply = 8000000000e8;
101     uint256 public totalDistributed = 0;        
102     uint256 public tokensPerEth = 12500000e8;
103     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
104 
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107     
108     event Distr(address indexed to, uint256 amount);
109     event DistrFinished();
110 
111     event Airdrop(address indexed _owner, uint _amount, uint _balance);
112 
113     event TokensPerEthUpdated(uint _tokensPerEth);
114     
115     event Burn(address indexed burner, uint256 value);
116 
117     bool public distributionFinished = false;
118     
119     modifier canDistr() {
120         require(!distributionFinished);
121         _;
122     }
123     
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128     
129     
130     function YlifeToken () public {
131         owner = msg.sender;
132         uint256 devTokens = 2800000000e8;
133         distr(owner, devTokens);
134     }
135     
136     function transferOwnership(address newOwner) onlyOwner public {
137         if (newOwner != address(0)) {
138             owner = newOwner;
139         }
140     }
141     
142 
143     function finishDistribution() onlyOwner canDistr public returns (bool) {
144         distributionFinished = true;
145         emit DistrFinished();
146         return true;
147     }
148     
149     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
150         totalDistributed = totalDistributed.add(_amount);        
151         balances[_to] = balances[_to].add(_amount);
152         emit Distr(_to, _amount);
153         emit Transfer(address(0), _to, _amount);
154 
155         return true;
156     }
157 
158     function doAirdrop(address _participant, uint _amount) internal {
159 
160         require( _amount > 0 );      
161 
162         require( totalDistributed < totalSupply );
163         
164         balances[_participant] = balances[_participant].add(_amount);
165         totalDistributed = totalDistributed.add(_amount);
166 
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170 
171         // log
172         emit Airdrop(_participant, _amount, balances[_participant]);
173         emit Transfer(address(0), _participant, _amount);
174     }
175 
176     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
177         doAirdrop(_participant, _amount);
178     }
179 
180     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
181         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
182     }
183 
184     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
185         tokensPerEth = _tokensPerEth;
186         emit TokensPerEthUpdated(_tokensPerEth);
187     }
188            
189     function () external payable {
190         getTokens();
191      }
192     
193     function getTokens() payable canDistr  public {
194         uint256 tokens = 0;
195 
196         require( msg.value >= minContribution );
197 
198         require( msg.value > 0 );
199         
200         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
201         address investor = msg.sender;
202         
203         if (tokens > 0) {
204             distr(investor, tokens);
205         }
206 
207         if (totalDistributed >= totalSupply) {
208             distributionFinished = true;
209         }
210     }
211 
212     function balanceOf(address _owner) constant public returns (uint256) {
213         return balances[_owner];
214     }
215 
216     // mitigates the ERC20 short address attack
217     modifier onlyPayloadSize(uint size) {
218         assert(msg.data.length >= size + 4);
219         _;
220     }
221     
222     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
223 
224         require(_to != address(0));
225         require(_amount <= balances[msg.sender]);
226         
227         balances[msg.sender] = balances[msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         emit Transfer(msg.sender, _to, _amount);
230         return true;
231     }
232     
233     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
234 
235         require(_to != address(0));
236         require(_amount <= balances[_from]);
237         require(_amount <= allowed[_from][msg.sender]);
238         
239         balances[_from] = balances[_from].sub(_amount);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Transfer(_from, _to, _amount);
243         return true;
244     }
245     
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         // mitigates the ERC20 spend/approval race condition
248         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
249         allowed[msg.sender][_spender] = _value;
250         emit Approval(msg.sender, _spender, _value);
251         return true;
252     }
253     
254     function allowance(address _owner, address _spender) constant public returns (uint256) {
255         return allowed[_owner][_spender];
256     }
257     
258     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
259         AltcoinToken t = AltcoinToken(tokenAddress);
260         uint bal = t.balanceOf(who);
261         return bal;
262     }
263     
264     function withdraw() onlyOwner public {
265         address myAddress = this;
266         uint256 etherBalance = myAddress.balance;
267         owner.transfer(etherBalance);
268     }
269     
270     function burn(uint256 _value) onlyOwner public {
271         require(_value <= balances[msg.sender]);
272         
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         totalSupply = totalSupply.sub(_value);
276         totalDistributed = totalDistributed.sub(_value);
277         emit Burn(burner, _value);
278     }
279     
280     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
281         AltcoinToken token = AltcoinToken(_tokenContract);
282         uint256 amount = token.balanceOf(address(this));
283         return token.transfer(owner, amount);
284     }
285 }