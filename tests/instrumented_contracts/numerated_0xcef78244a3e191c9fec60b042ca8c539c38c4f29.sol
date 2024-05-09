1 pragma solidity ^0.4.24;
2 /**
3  * Token name: CYGNAL
4  * Token totalSupply: 300000000e8
5  * Token symbol: CYG
6  * Token decimals: 8
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract ForeignToken {
51     function balanceOf(address _owner) constant public returns (uint256);
52     function transfer(address _to, uint256 _value) public returns (bool);
53 }
54 
55 contract ERC20Basic {
56     uint256 public totalSupply;
57     function balanceOf(address who) public constant returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 contract ERC20 is ERC20Basic {
63     function allowance(address owner, address spender) public constant returns (uint256);
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65     function approve(address spender, uint256 value) public returns (bool);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract Cygnal is ERC20 {
70     
71     using SafeMath for uint256;
72     address owner = msg.sender;
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;    
76 
77     string public constant name = "CYGNAL";
78     string public constant symbol = "CYG";
79     uint public constant decimals = 8;
80     
81     uint256 public totalSupply = 300000000e8;
82     uint256 public totalDistributed =  30000000e8;    
83     uint256 public constant MIN_CONTRIBUTION = 1 ether / 200; // 0.005 Ether
84     uint256 public tokensPerEth = 200000e8;
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91 
92     event Airdrop(address indexed _owner, uint _amount, uint _balance);
93 
94     event TokensPerEthUpdated(uint _tokensPerEth);
95     
96     event Burn(address indexed burner, uint256 value);
97 
98     bool public distributionFinished = false;
99     
100     modifier canDistr() {
101         require(!distributionFinished);
102         _;
103     }
104     
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109     
110     
111     function Cygnal() public {
112         owner = msg.sender;    
113         distr(owner, totalDistributed);
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
135         return true;
136     }
137 
138     function doAirdrop(address _participant, uint _amount) internal {
139 
140         require( _amount > 0 );      
141 
142         require( totalDistributed < totalSupply );
143         
144         balances[_participant] = balances[_participant].add(_amount);
145         totalDistributed = totalDistributed.add(_amount);
146 
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150 
151         // log
152         emit Airdrop(_participant, _amount, balances[_participant]);
153         emit Transfer(address(0), _participant, _amount);
154     }
155 
156     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
157         doAirdrop(_participant, _amount);
158     }
159 
160     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
161         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
162     }
163 
164     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
165         tokensPerEth = _tokensPerEth;
166         emit TokensPerEthUpdated(_tokensPerEth);
167     }
168            
169     function () external payable {
170         getTokens();
171      }
172     
173     function getTokens() payable canDistr  public {
174         uint256 tokens = 0;
175 
176         // minimum contribution
177         require( msg.value >= MIN_CONTRIBUTION );
178 
179         require( msg.value > 0 );
180 
181         // get baseline number of tokens
182         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
183         address investor = msg.sender;
184         
185         if (tokens > 0) {
186             distr(investor, tokens);
187         }
188 
189         if (totalDistributed >= totalSupply) {
190             distributionFinished = true;
191         }
192     }
193 
194     function balanceOf(address _owner) constant public returns (uint256) {
195         return balances[_owner];
196     }
197 
198     // mitigates the ERC20 short address attack
199     modifier onlyPayloadSize(uint size) {
200         assert(msg.data.length >= size + 4);
201         _;
202     }
203     
204     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
205 
206         require(_to != address(0));
207         require(_amount <= balances[msg.sender]);
208         
209         balances[msg.sender] = balances[msg.sender].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         emit Transfer(msg.sender, _to, _amount);
212         return true;
213     }
214     
215     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
216 
217         require(_to != address(0));
218         require(_amount <= balances[_from]);
219         require(_amount <= allowed[_from][msg.sender]);
220         
221         balances[_from] = balances[_from].sub(_amount);
222         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
223         balances[_to] = balances[_to].add(_amount);
224         emit Transfer(_from, _to, _amount);
225         return true;
226     }
227     
228     function approve(address _spender, uint256 _value) public returns (bool success) {
229         // mitigates the ERC20 spend/approval race condition
230         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
231         allowed[msg.sender][_spender] = _value;
232         emit Approval(msg.sender, _spender, _value);
233         return true;
234     }
235     
236     function allowance(address _owner, address _spender) constant public returns (uint256) {
237         return allowed[_owner][_spender];
238     }
239     
240     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
241         ForeignToken t = ForeignToken(tokenAddress);
242         uint bal = t.balanceOf(who);
243         return bal;
244     }
245     
246     function withdraw() onlyOwner public {
247         address myAddress = this;
248         uint256 etherBalance = myAddress.balance;
249         owner.transfer(etherBalance);
250     }
251     
252     function burn(uint256 _value) onlyOwner public {
253         require(_value <= balances[msg.sender]);
254         // no need to require value <= totalSupply, since that would imply the
255         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
256 
257         address burner = msg.sender;
258         balances[burner] = balances[burner].sub(_value);
259         totalSupply = totalSupply.sub(_value);
260         totalDistributed = totalDistributed.sub(_value);
261         emit Burn(burner, _value);
262     }
263     
264     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
265         ForeignToken token = ForeignToken(_tokenContract);
266         uint256 amount = token.balanceOf(address(this));
267         return token.transfer(owner, amount);
268     }
269 }