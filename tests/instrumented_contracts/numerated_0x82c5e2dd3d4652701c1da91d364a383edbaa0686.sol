1 /**
2  * @title RingMusic
3  * @team RMTK Team www.ringmusic.co
4  */
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
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
72 contract RingMusic is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "RingMusic";
81     string public constant symbol = "RMTK";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 20000000000e8;
85     uint256 public totalDistributed = 0;    
86     uint256 public constant MIN_PURCHASE = 1 ether / 100;
87     uint256 public tokensPerEth = 20000000e8;
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
114    
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
156     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
157         doAirdrop(_participant, _amount);
158     }
159 
160     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
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
177         require( msg.value >= MIN_PURCHASE );
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