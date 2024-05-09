1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ForeignToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract DTRACK is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;    
71 
72     string public constant name = "DTRACK";
73     string public constant symbol = "DTK";
74     uint public constant decimals = 8;
75     
76     uint256 public totalSupply = 20000000000e8;
77     uint256 public totalDistributed = 0;    
78     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
79     uint256 public tokensPerEth = 8000000e8;
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     
84     event Distr(address indexed to, uint256 amount);
85     event DistrFinished();
86 
87     event Airdrop(address indexed _owner, uint _amount, uint _balance);
88 
89     event TokensPerEthUpdated(uint _tokensPerEth);
90     
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
106     function DTRACK() public {
107         owner = msg.sender;    
108         distr(owner, totalDistributed);
109         
110     }
111     
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124     
125     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126         totalDistributed = totalDistributed.add(_amount);        
127         balances[_to] = balances[_to].add(_amount);
128         emit Distr(_to, _amount);
129         emit Transfer(address(0), _to, _amount);
130 
131         return true;
132     }
133 
134     function doAirdrop(address _participant, uint _amount) internal {
135 
136         require( _amount > 0 );      
137 
138         require( totalDistributed < totalSupply );
139         
140         balances[_participant] = balances[_participant].add(_amount);
141         totalDistributed = totalDistributed.add(_amount);
142 
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146 
147         // log
148         emit Airdrop(_participant, _amount, balances[_participant]);
149         emit Transfer(address(0), _participant, _amount);
150     }
151 
152     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
153         doAirdrop(_participant, _amount);
154     }
155 
156     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
157         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
158     }
159 
160     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
161         tokensPerEth = _tokensPerEth;
162         emit TokensPerEthUpdated(_tokensPerEth);
163     }
164            
165     function () external payable {
166         getTokens();
167      }
168     
169     function getTokens() payable canDistr  public {
170         uint256 tokens = 0;
171 
172         // minimum contribution
173         require( msg.value >= MIN_CONTRIBUTION );
174 
175         require( msg.value > 0 );
176 
177         // get baseline number of tokens
178         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
179         address investor = msg.sender;
180         
181         if (tokens > 0) {
182             distr(investor, tokens);
183         }
184 
185         if (totalDistributed >= totalSupply) {
186             distributionFinished = true;
187         }
188     }
189 
190     function balanceOf(address _owner) constant public returns (uint256) {
191         return balances[_owner];
192     }
193 
194     // mitigates the ERC20 short address attack
195     modifier onlyPayloadSize(uint size) {
196         assert(msg.data.length >= size + 4);
197         _;
198     }
199     
200     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
201 
202         require(_to != address(0));
203         require(_amount <= balances[msg.sender]);
204         
205         balances[msg.sender] = balances[msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(msg.sender, _to, _amount);
208         return true;
209     }
210     
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212 
213         require(_to != address(0));
214         require(_amount <= balances[_from]);
215         require(_amount <= allowed[_from][msg.sender]);
216         
217         balances[_from] = balances[_from].sub(_amount);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Transfer(_from, _to, _amount);
221         return true;
222     }
223     
224     function approve(address _spender, uint256 _value) public returns (bool success) {
225         // mitigates the ERC20 spend/approval race condition
226         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231     
232     function allowance(address _owner, address _spender) constant public returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235     
236     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
237         ForeignToken t = ForeignToken(tokenAddress);
238         uint bal = t.balanceOf(who);
239         return bal;
240     }
241     
242     function withdraw() onlyOwner public {
243         address myAddress = this;
244         uint256 etherBalance = myAddress.balance;
245         owner.transfer(etherBalance);
246     }
247     
248     function burn(uint256 _value) onlyOwner public {
249         require(_value <= balances[msg.sender]);
250         // no need to require value <= totalSupply, since that would imply the
251         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
252 
253         address burner = msg.sender;
254         balances[burner] = balances[burner].sub(_value);
255         totalSupply = totalSupply.sub(_value);
256         totalDistributed = totalDistributed.sub(_value);
257         emit Burn(burner, _value);
258     }
259     
260     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
261         ForeignToken token = ForeignToken(_tokenContract);
262         uint256 amount = token.balanceOf(address(this));
263         return token.transfer(owner, amount);
264     }
265 }