1 /* 
2 © 2019 Libra Association
3  */
4 pragma solidity ^0.4.18;
5 
6 /*
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /*
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /*
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /*
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /*
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 contract AltcoinToken {
53     function balanceOf(address _owner) constant public returns (uint256);
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public constant returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract Libra is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;    
78 
79     string public constant name = "Libra";
80     string public constant symbol = "LIBRA";
81     uint public constant decimals = 8;
82     
83     uint256 public totalSupply = 100000000e8;
84     uint256 public totalDistributed = 0;    
85     uint256 public constant MIN_PURCHASE = 1 ether / 10000;
86     uint256 public tokensPerEth = 100000e8;
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90     
91     event Distr(address indexed to, uint256 amount);
92     event DistrFinished();
93     event StartICO();
94     event ResetICO();
95 
96     event Airdrop(address indexed _owner, uint _amount, uint _balance);
97 
98     event TokensPerEthUpdated(uint _tokensPerEth);
99     
100     event Burn(address indexed burner, uint256 value);
101 
102     bool public distributionFinished = false;
103 
104     bool public icoStart = false;
105     
106     modifier canDistr() {
107         require(!distributionFinished);
108         require(icoStart);
109         _;
110     }
111     
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     
118     constructor () public {
119         owner = msg.sender;
120     }
121     
122     function transferOwnership(address newOwner) onlyOwner public {
123         if (newOwner != address(0)) {
124             owner = newOwner;
125         }
126     }
127 
128     function startICO() onlyOwner public returns (bool) {
129         icoStart = true;
130         emit StartICO();
131         return true;
132     }
133 
134     function resetICO() onlyOwner public returns (bool) {
135         icoStart = false;
136         distributionFinished = false;
137         emit ResetICO();
138         return true;
139     }
140 
141     function finishDistribution() onlyOwner canDistr public returns (bool) {
142         distributionFinished = true;
143         emit DistrFinished();
144         return true;
145     }
146     
147     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
148         totalDistributed = totalDistributed.add(_amount);        
149         balances[_to] = balances[_to].add(_amount);
150         emit Distr(_to, _amount);
151         emit Transfer(address(0), _to, _amount);
152 
153         return true;
154     }
155 
156     function doAirdrop(address _participant, uint _amount) internal {
157 
158         require( _amount > 0 );      
159 
160         require( totalDistributed < totalSupply );
161         
162         balances[_participant] = balances[_participant].add(_amount);
163         totalDistributed = totalDistributed.add(_amount);
164 
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168 
169         // log
170         emit Airdrop(_participant, _amount, balances[_participant]);
171         emit Transfer(address(0), _participant, _amount);
172     }
173 
174     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
175         doAirdrop(_participant, _amount);
176     }
177 
178     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
179         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
180     }
181 
182     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
183         tokensPerEth = _tokensPerEth;
184         emit TokensPerEthUpdated(_tokensPerEth);
185     }
186            
187     function () external payable {
188         getTokens();
189      }
190     
191     function getTokens() payable canDistr  public {
192         uint256 tokens = 0;
193 
194         // minimum contribution
195         require( msg.value >= MIN_PURCHASE );
196 
197         require( msg.value > 0 );
198 
199         // get baseline number of tokens
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
272         // no need to require value <= totalSupply, since that would imply the
273         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
274 
275         address burner = msg.sender;
276         balances[burner] = balances[burner].sub(_value);
277         totalSupply = totalSupply.sub(_value);
278         totalDistributed = totalDistributed.sub(_value);
279         emit Burn(burner, _value);
280     }
281     
282     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
283         AltcoinToken token = AltcoinToken(_tokenContract);
284         uint256 amount = token.balanceOf(address(this));
285         return token.transfer(owner, amount);
286     }
287 }