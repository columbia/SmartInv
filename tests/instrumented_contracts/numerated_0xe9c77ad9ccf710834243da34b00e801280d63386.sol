1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address _owner) constant public returns (uint256);
51     function transfer(address _to, uint256 _value) public returns (bool);
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract LabtorumToken is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "LabtorumToken";
77     string public constant symbol = "LTR";
78     uint public constant decimals = 8;
79     uint public deadline = now + 67 * 1 days;
80     
81     uint256 public totalSupply = 3000000000e8;
82     uint256 public totalDistributed = 1000000000e8;    
83     uint256 public constant MIN_CONTRIBUTION = 1 ether / 1000; // 0.001 Ether
84     uint256 public tokensPerEth = 300000e8;
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
111     function LabtorumToken () public {
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
156     function adminClaimAirdrop(address _participant, uint _amount) external {        
157         doAirdrop(_participant, _amount);
158     }
159 
160     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) external {        
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
185 	    if (now >= deadline) {
186             distributionFinished = true;
187         }
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
198     
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
260         // no need to require value <= totalSupply, since that would imply the
261         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263         address burner = msg.sender;
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         totalDistributed = totalDistributed.sub(_value);
267         emit Burn(burner, _value);
268     }
269     
270     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
271         ForeignToken token = ForeignToken(_tokenContract);
272         uint256 amount = token.balanceOf(address(this));
273         return token.transfer(owner, amount);
274     }
275 }