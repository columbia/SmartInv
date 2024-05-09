1 /* 
2 @Rental and Booking (RNB)
3 @2018 by TOTO team
4  */
5 pragma solidity ^0.4.18;
6 
7 /*
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /*
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
25     /*
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /*
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /*
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract AltcoinToken {
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
72 contract RNBToken is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "RNBToken";
81     string public constant symbol = "RNB";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 25000000000e8;
85     uint256 public totalDistributed = 0;    
86     uint256 public constant MIN_PURCHASE = 1 ether / 100;
87     uint256 public tokensPerEth = 20000000e8;
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94     event StartICO();
95     event ResetICO();
96 
97     event Airdrop(address indexed _owner, uint _amount, uint _balance);
98 
99     event TokensPerEthUpdated(uint _tokensPerEth);
100     
101     event Burn(address indexed burner, uint256 value);
102 
103     bool public distributionFinished = false;
104 
105     bool public icoStart = false;
106     
107     modifier canDistr() {
108         require(!distributionFinished);
109         require(icoStart);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     
119     constructor () public {
120         owner = msg.sender;
121     }
122     
123     function transferOwnership(address newOwner) onlyOwner public {
124         if (newOwner != address(0)) {
125             owner = newOwner;
126         }
127     }
128 
129     function startICO() onlyOwner public returns (bool) {
130         icoStart = true;
131         emit StartICO();
132         return true;
133     }
134 
135     function resetICO() onlyOwner public returns (bool) {
136         icoStart = false;
137         distributionFinished = false;
138         emit ResetICO();
139         return true;
140     }
141 
142     function finishDistribution() onlyOwner canDistr public returns (bool) {
143         distributionFinished = true;
144         emit DistrFinished();
145         return true;
146     }
147     
148     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
149         totalDistributed = totalDistributed.add(_amount);        
150         balances[_to] = balances[_to].add(_amount);
151         emit Distr(_to, _amount);
152         emit Transfer(address(0), _to, _amount);
153 
154         return true;
155     }
156 
157     function doAirdrop(address _participant, uint _amount) internal {
158 
159         require( _amount > 0 );      
160 
161         require( totalDistributed < totalSupply );
162         
163         balances[_participant] = balances[_participant].add(_amount);
164         totalDistributed = totalDistributed.add(_amount);
165 
166         if (totalDistributed >= totalSupply) {
167             distributionFinished = true;
168         }
169 
170         // log
171         emit Airdrop(_participant, _amount, balances[_participant]);
172         emit Transfer(address(0), _participant, _amount);
173     }
174 
175     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
176         doAirdrop(_participant, _amount);
177     }
178 
179     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
180         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
181     }
182 
183     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
184         tokensPerEth = _tokensPerEth;
185         emit TokensPerEthUpdated(_tokensPerEth);
186     }
187            
188     function () external payable {
189         getTokens();
190      }
191     
192     function getTokens() payable canDistr  public {
193         uint256 tokens = 0;
194 
195         // minimum contribution
196         require( msg.value >= MIN_PURCHASE );
197 
198         require( msg.value > 0 );
199 
200         // get baseline number of tokens
201         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
202         address investor = msg.sender;
203         
204         if (tokens > 0) {
205             distr(investor, tokens);
206         }
207 
208         if (totalDistributed >= totalSupply) {
209             distributionFinished = true;
210         }
211     }
212 
213     function balanceOf(address _owner) constant public returns (uint256) {
214         return balances[_owner];
215     }
216 
217     // mitigates the ERC20 short address attack
218     modifier onlyPayloadSize(uint size) {
219         assert(msg.data.length >= size + 4);
220         _;
221     }
222     
223     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
224 
225         require(_to != address(0));
226         require(_amount <= balances[msg.sender]);
227         
228         balances[msg.sender] = balances[msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Transfer(msg.sender, _to, _amount);
231         return true;
232     }
233     
234     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[_from]);
238         require(_amount <= allowed[_from][msg.sender]);
239         
240         balances[_from] = balances[_from].sub(_amount);
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
242         balances[_to] = balances[_to].add(_amount);
243         emit Transfer(_from, _to, _amount);
244         return true;
245     }
246     
247     function approve(address _spender, uint256 _value) public returns (bool success) {
248         // mitigates the ERC20 spend/approval race condition
249         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
250         allowed[msg.sender][_spender] = _value;
251         emit Approval(msg.sender, _spender, _value);
252         return true;
253     }
254     
255     function allowance(address _owner, address _spender) constant public returns (uint256) {
256         return allowed[_owner][_spender];
257     }
258     
259     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
260         AltcoinToken t = AltcoinToken(tokenAddress);
261         uint bal = t.balanceOf(who);
262         return bal;
263     }
264     
265     function withdraw() onlyOwner public {
266         address myAddress = this;
267         uint256 etherBalance = myAddress.balance;
268         owner.transfer(etherBalance);
269     }
270     
271     function burn(uint256 _value) onlyOwner public {
272         require(_value <= balances[msg.sender]);
273         // no need to require value <= totalSupply, since that would imply the
274         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
275 
276         address burner = msg.sender;
277         balances[burner] = balances[burner].sub(_value);
278         totalSupply = totalSupply.sub(_value);
279         totalDistributed = totalDistributed.sub(_value);
280         emit Burn(burner, _value);
281     }
282     
283     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
284         AltcoinToken token = AltcoinToken(_tokenContract);
285         uint256 amount = token.balanceOf(address(this));
286         return token.transfer(owner, amount);
287     }
288 }