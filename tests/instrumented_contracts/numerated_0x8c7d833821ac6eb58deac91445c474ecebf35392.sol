1 /*
2  *@title Token3DAX
3  *@dev 3DAX Dev Team
4  */
5 
6 pragma solidity ^0.4.25;
7 
8 /*
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     /*
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19             return 0;
20         }
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /*
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /*
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /*
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract AltcoinToken {
55     function balanceOf(address _owner) constant public returns (uint256);
56     function transfer(address _to, uint256 _value) public returns (bool);
57 }
58 
59 contract ERC20Basic {
60     uint256 public totalSupply;
61     function balanceOf(address who) public constant returns (uint256);
62     function transfer(address to, uint256 value) public returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public constant returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract Token3DAX is ERC20 {
74     
75     using SafeMath for uint256;
76     address owner = msg.sender;
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;    
80 
81     string public constant name = "3DAX";
82     string public constant symbol = "3DX";
83     uint public constant decimals = 8;
84     
85     uint256 public totalSupply = 10000000000e8;        //10,000,000,000 3DX
86     uint256 public totalDistributed = 0;    
87     uint256 public constant minInvest = 1 ether / 100; //minInvest 0.01 ETH
88     uint256 public tokensPerEth = 200000e8;            //200,000 3DX / ETH
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     
93     event Distr(address indexed to, uint256 amount);
94     event DistrFinished();
95     event StartICO();
96     event ResetICO();
97 
98     event Airdrop(address indexed _owner, uint _amount, uint _balance);
99 
100     event TokensPerEthUpdated(uint _tokensPerEth);
101     
102     event Burn(address indexed burner, uint256 value);
103 
104     bool public distributionFinished = false;
105 
106     bool public icoStart = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         require(icoStart);
111         _;
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     
120     constructor  () public {
121         owner = msg.sender;
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129 
130     function startICO() onlyOwner public returns (bool) {
131         icoStart = true;
132         emit StartICO();
133         return true;
134     }
135 
136     function resetICO() onlyOwner public returns (bool) {
137         icoStart = false;
138         distributionFinished = false;
139         emit ResetICO();
140         return true;
141     }
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
176     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
177         doAirdrop(_participant, _amount);
178     }
179 
180     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
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
196         // minimum contribution
197         require( msg.value >= minInvest );
198 
199         require( msg.value > 0 );
200         
201         // get baseline number of tokens
202         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
203         address investor = msg.sender;
204         
205         if (tokens > 0) {
206             distr(investor, tokens);
207         }
208 
209         if (totalDistributed >= totalSupply) {
210             distributionFinished = true;
211         }
212     }
213 
214     function balanceOf(address _owner) constant public returns (uint256) {
215         return balances[_owner];
216     }
217 
218     // mitigates the ERC20 short address attack
219     modifier onlyPayloadSize(uint size) {
220         assert(msg.data.length >= size + 4);
221         _;
222     }
223     
224     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
225 
226         require(_to != address(0));
227         require(_amount <= balances[msg.sender]);
228         
229         balances[msg.sender] = balances[msg.sender].sub(_amount);
230         balances[_to] = balances[_to].add(_amount);
231         emit Transfer(msg.sender, _to, _amount);
232         return true;
233     }
234     
235     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
236 
237         require(_to != address(0));
238         require(_amount <= balances[_from]);
239         require(_amount <= allowed[_from][msg.sender]);
240         
241         balances[_from] = balances[_from].sub(_amount);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
243         balances[_to] = balances[_to].add(_amount);
244         emit Transfer(_from, _to, _amount);
245         return true;
246     }
247     
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         // mitigates the ERC20 spend/approval race condition
250         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
251         allowed[msg.sender][_spender] = _value;
252         emit Approval(msg.sender, _spender, _value);
253         return true;
254     }
255     
256     function allowance(address _owner, address _spender) constant public returns (uint256) {
257         return allowed[_owner][_spender];
258     }
259     
260     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
261         AltcoinToken t = AltcoinToken(tokenAddress);
262         uint bal = t.balanceOf(who);
263         return bal;
264     }
265     
266     function withdraw() onlyOwner public {
267         address myAddress = this;
268         uint256 etherBalance = myAddress.balance;
269         owner.transfer(etherBalance);
270     }
271     
272     function burn(uint256 _value) onlyOwner public {
273         require(_value <= balances[msg.sender]);
274         // no need to require value <= totalSupply, since that would imply the
275         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
276 
277         address burner = msg.sender;
278         balances[burner] = balances[burner].sub(_value);
279         totalSupply = totalSupply.sub(_value);
280         totalDistributed = totalDistributed.sub(_value);
281         emit Burn(burner, _value);
282     }
283     
284     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
285         AltcoinToken token = AltcoinToken(_tokenContract);
286         uint256 amount = token.balanceOf(address(this));
287         return token.transfer(owner, amount);
288     }
289 }