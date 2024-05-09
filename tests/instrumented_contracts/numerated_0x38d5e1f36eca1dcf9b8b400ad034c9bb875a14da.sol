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
68 contract FUTURAX is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "FUTURAX";
77     string public constant symbol = "FXC";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 10000000000e8; // Supply
81     uint256 public totalDistributed = 4000000000e8;    
82     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
83     uint256 public tokensPerEth = 20000000e8;
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     event Distr(address indexed to, uint256 amount);
88     event DistrFinished();
89     event Airdrop(address indexed _owner, uint _amount, uint _balance);
90     event TokensPerEthUpdated(uint _tokensPerEth);
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105     
106     function FUTURAX () public {
107         owner = msg.sender;        
108         distr(owner, totalDistributed);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116     
117 
118     function finishDistribution() onlyOwner canDistr public returns (bool) {
119         distributionFinished = true;
120         emit DistrFinished();
121         return true;
122     }
123     
124     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
125         totalDistributed = totalDistributed.add(_amount);        
126         balances[_to] = balances[_to].add(_amount);
127         emit Distr(_to, _amount);
128         emit Transfer(address(0), _to, _amount);
129 
130         return true;
131     }
132 
133     function doAirdrop(address _participant, uint _amount) internal {
134 
135         require( _amount > 0 );      
136 
137         require( totalDistributed < totalSupply );
138         
139         balances[_participant] = balances[_participant].add(_amount);
140         totalDistributed = totalDistributed.add(_amount);
141 
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145 
146         emit Airdrop(_participant, _amount, balances[_participant]);
147         emit Transfer(address(0), _participant, _amount);
148     }
149 
150     function adminClaimAirdrop(address _participant, uint _amount) external {        
151         doAirdrop(_participant, _amount);
152     }
153 
154     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) external {        
155         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
156     }
157 
158     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
159         tokensPerEth = _tokensPerEth;
160         emit TokensPerEthUpdated(_tokensPerEth);
161     }
162            
163     function () external payable {
164         getTokens();
165      }
166     
167     function getTokens() payable canDistr  public {
168         uint256 tokens = 0;
169 
170         require( msg.value >= MIN_CONTRIBUTION );
171 
172         require( msg.value > 0 );
173 
174         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
175         address investor = msg.sender;
176         
177         if (tokens > 0) {
178             distr(investor, tokens);
179         }
180 
181         if (totalDistributed >= totalSupply) {
182             distributionFinished = true;
183         }
184     }
185 
186     function balanceOf(address _owner) constant public returns (uint256) {
187         return balances[_owner];
188     }
189 
190     modifier onlyPayloadSize(uint size) {
191         assert(msg.data.length >= size + 4);
192         _;
193     }
194     
195     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
196 
197         require(_to != address(0));
198         require(_amount <= balances[msg.sender]);
199         
200         balances[msg.sender] = balances[msg.sender].sub(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         emit Transfer(msg.sender, _to, _amount);
203         return true;
204     }
205     
206     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
207 
208         require(_to != address(0));
209         require(_amount <= balances[_from]);
210         require(_amount <= allowed[_from][msg.sender]);
211         
212         balances[_from] = balances[_from].sub(_amount);
213         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(_from, _to, _amount);
216         return true;
217     }
218     
219     function approve(address _spender, uint256 _value) public returns (bool success) {
220         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
221         allowed[msg.sender][_spender] = _value;
222         emit Approval(msg.sender, _spender, _value);
223         return true;
224     }
225     
226     function allowance(address _owner, address _spender) constant public returns (uint256) {
227         return allowed[_owner][_spender];
228     }
229     
230     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
231         ForeignToken t = ForeignToken(tokenAddress);
232         uint bal = t.balanceOf(who);
233         return bal;
234     }
235     
236     function withdraw() onlyOwner public {
237         address myAddress = this;
238         uint256 etherBalance = myAddress.balance;
239         owner.transfer(etherBalance);
240     }
241     
242     function burn(uint256 _value) onlyOwner public {
243         require(_value <= balances[msg.sender]);
244 
245 
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         totalDistributed = totalDistributed.sub(_value);
250         emit Burn(burner, _value);
251     }
252     
253     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
254         ForeignToken token = ForeignToken(_tokenContract);
255         uint256 amount = token.balanceOf(address(this));
256         return token.transfer(owner, amount);
257     }
258 }