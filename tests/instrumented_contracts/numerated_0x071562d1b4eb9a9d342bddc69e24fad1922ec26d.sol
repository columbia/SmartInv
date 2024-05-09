1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Name : BARRELNETWORK (BARL)
9  * Decimals : 18
10  * TotalSupply : 2000000000
11  * 
12  * 
13  * 
14  * 
15  */
16 library SafeMath {
17 
18     /**
19     * @dev Multiplies two numbers, throws on overflow.
20     */
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         // uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return a / b;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 contract ForeignToken {
59     function balanceOf(address _owner) constant public returns (uint256);
60     function transfer(address _to, uint256 _value) public returns (bool);
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) public constant returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ERC20 is ERC20Basic {
71     function allowance(address owner, address spender) public constant returns (uint256);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract BARL is ERC20 {
78     
79     using SafeMath for uint256;
80     address owner = msg.sender;
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;    
84 
85     string public constant name = "BARRELNETWORK";
86     string public constant symbol = "BARL";
87     uint public constant decimals = 0;
88     
89     uint256 public totalSupply = 2000000000;
90     uint256 public totalDistributed = 400000000;    
91     uint256 public tokensPerEth = 1000000;
92     
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     event Distr(address indexed to, uint256 amount);
98     event DistrFinished();
99 
100     event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102     event TokensPerEthUpdated(uint _tokensPerEth);
103     
104     event Burn(address indexed burner, uint256 value);
105 
106     bool public distributionFinished = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     
119     function BARL () public {
120         owner = msg.sender;    
121         distr(owner, totalDistributed);
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129     
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145 
146     function doAirdrop(address _participant, uint _amount) internal {
147 
148         require( _amount > 0 );      
149 
150         require( totalDistributed < totalSupply );
151         
152         balances[_participant] = balances[_participant].add(_amount);
153         totalDistributed = totalDistributed.add(_amount);
154 
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158 
159         // log
160         emit Airdrop(_participant, _amount, balances[_participant]);
161         emit Transfer(address(0), _participant, _amount);
162     }
163 
164     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
165         doAirdrop(_participant, _amount);
166     }
167 
168     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
169         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
170     }
171 
172     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
173         tokensPerEth = _tokensPerEth;
174         emit TokensPerEthUpdated(_tokensPerEth);
175     }
176            
177     function () external payable {
178         getTokens();
179      }
180     
181     function getTokens() payable canDistr  public {
182         uint256 tokens = 0;
183 
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