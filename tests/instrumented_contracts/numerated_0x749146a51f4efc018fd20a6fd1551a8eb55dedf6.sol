1 pragma solidity ^0.4.23;
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
68 contract Diatom is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "Diatom";
77     string public constant symbol = "DTM";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 20000000e8;
81     uint256 public totalDistributed = 8000000e8;    
82     uint256 public tokensPerEth = 15000e8;
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86     
87     event Distr(address indexed to, uint256 amount);
88     event DistrFinished();
89 
90     event Airdrop(address indexed _owner, uint _amount, uint _balance);
91 
92     event TokensPerEthUpdated(uint _tokensPerEth);
93     
94     event Burn(address indexed burner, uint256 value);
95 
96     bool public distributionFinished = false;
97     
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     
108     
109     function Diatom () public {
110         owner = msg.sender;        
111         distr(owner, totalDistributed);
112     }
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120 
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         emit DistrFinished();
124         return true;
125     }
126     
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);        
129         balances[_to] = balances[_to].add(_amount);
130         emit Distr(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132 
133         return true;
134     }
135 
136     function doAirdrop(address _participant, uint _amount) internal {
137 
138         require( _amount > 0 );      
139 
140         require( totalDistributed < totalSupply );
141         
142         balances[_participant] = balances[_participant].add(_amount);
143         totalDistributed = totalDistributed.add(_amount);
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148 
149         // log
150         emit Airdrop(_participant, _amount, balances[_participant]);
151         emit Transfer(address(0), _participant, _amount);
152     }
153 
154     function adminClaimAirdrop(address _participant, uint _amount) external {        
155         doAirdrop(_participant, _amount);
156     }
157 
158     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) external {        
159         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
160     }
161 
162     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
163         tokensPerEth = _tokensPerEth;
164         emit TokensPerEthUpdated(_tokensPerEth);
165     }
166            
167     function () external payable {
168         getTokens();
169      }
170     
171     function getTokens() payable canDistr  public {
172         uint256 tokens = 0;
173 
174         require( msg.value > 0 );
175 
176         // get baseline number of tokens
177         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
178         address investor = msg.sender;
179         
180         if (tokens > 0) {
181             distr(investor, tokens);
182         }
183 
184         if (totalDistributed >= totalSupply) {
185             distributionFinished = true;
186         }
187     }
188 
189     function balanceOf(address _owner) constant public returns (uint256) {
190         return balances[_owner];
191     }
192 
193     // mitigates the ERC20 short address attack
194     modifier onlyPayloadSize(uint size) {
195         assert(msg.data.length >= size + 4);
196         _;
197     }
198     
199     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
200 
201         require(_to != address(0));
202         require(_amount <= balances[msg.sender]);
203         
204         balances[msg.sender] = balances[msg.sender].sub(_amount);
205         balances[_to] = balances[_to].add(_amount);
206         emit Transfer(msg.sender, _to, _amount);
207         return true;
208     }
209     
210     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[_from]);
214         require(_amount <= allowed[_from][msg.sender]);
215         
216         balances[_from] = balances[_from].sub(_amount);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(_from, _to, _amount);
220         return true;
221     }
222     
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224         // mitigates the ERC20 spend/approval race condition
225         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230     
231     function allowance(address _owner, address _spender) constant public returns (uint256) {
232         return allowed[_owner][_spender];
233     }
234     
235     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
236         ForeignToken t = ForeignToken(tokenAddress);
237         uint bal = t.balanceOf(who);
238         return bal;
239     }
240     
241     function withdraw() onlyOwner public {
242         address myAddress = this;
243         uint256 etherBalance = myAddress.balance;
244         owner.transfer(etherBalance);
245     }
246     
247     function burn(uint256 _value) onlyOwner public {
248         require(_value <= balances[msg.sender]);
249         // no need to require value <= totalSupply, since that would imply the
250         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
251 
252         address burner = msg.sender;
253         balances[burner] = balances[burner].sub(_value);
254         totalSupply = totalSupply.sub(_value);
255         totalDistributed = totalDistributed.sub(_value);
256         emit Burn(burner, _value);
257     }
258     
259     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
260         ForeignToken token = ForeignToken(_tokenContract);
261         uint256 amount = token.balanceOf(address(this));
262         return token.transfer(owner, amount);
263     }
264 }