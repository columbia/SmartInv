1 pragma solidity ^0.4.18;
2 
3 /*
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /*
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
21     /*
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /*
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /*
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract AltcoinToken {
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
68 contract EPAAY is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "EPAAY";
77     string public constant symbol = "EAY";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 10000000000e8;
81     uint256 public totalDistributed = 0;    
82     uint256 public constant MIN_PURCHASE = 1 ether / 100;
83     uint256 public tokensPerEth = 10000000e8;
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     
88     event Distr(address indexed to, uint256 amount);
89     event DistrFinished();
90     event StartICO();
91     event ResetICO();
92 
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96     
97     event Burn(address indexed burner, uint256 value);
98 
99     bool public distributionFinished = false;
100 
101     bool public icoStart = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         require(icoStart);
106         _;
107     }
108     
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113     
114     
115     constructor () public {
116         owner = msg.sender;
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124 
125     function startICO() onlyOwner public returns (bool) {
126         icoStart = true;
127         emit StartICO();
128         return true;
129     }
130 
131     function resetICO() onlyOwner public returns (bool) {
132         icoStart = false;
133         distributionFinished = false;
134         emit ResetICO();
135         return true;
136     }
137 
138     function finishDistribution() onlyOwner canDistr public returns (bool) {
139         distributionFinished = true;
140         emit DistrFinished();
141         return true;
142     }
143     
144     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
145         totalDistributed = totalDistributed.add(_amount);        
146         balances[_to] = balances[_to].add(_amount);
147         emit Distr(_to, _amount);
148         emit Transfer(address(0), _to, _amount);
149 
150         return true;
151     }
152 
153     function doAirdrop(address _participant, uint _amount) internal {
154 
155         require( _amount > 0 );      
156 
157         require( totalDistributed < totalSupply );
158         
159         balances[_participant] = balances[_participant].add(_amount);
160         totalDistributed = totalDistributed.add(_amount);
161 
162         if (totalDistributed >= totalSupply) {
163             distributionFinished = true;
164         }
165 
166         // log
167         emit Airdrop(_participant, _amount, balances[_participant]);
168         emit Transfer(address(0), _participant, _amount);
169     }
170 
171     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
172         doAirdrop(_participant, _amount);
173     }
174 
175     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
176         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
177     }
178 
179     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
180         tokensPerEth = _tokensPerEth;
181         emit TokensPerEthUpdated(_tokensPerEth);
182     }
183            
184     function () external payable {
185         getTokens();
186      }
187     
188     function getTokens() payable canDistr  public {
189         uint256 tokens = 0;
190 
191         // minimum contribution
192         require( msg.value >= MIN_PURCHASE );
193 
194         require( msg.value > 0 );
195 
196         // get baseline number of tokens
197         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
198         address investor = msg.sender;
199         
200         if (tokens > 0) {
201             distr(investor, tokens);
202         }
203 
204         if (totalDistributed >= totalSupply) {
205             distributionFinished = true;
206         }
207     }
208 
209     function balanceOf(address _owner) constant public returns (uint256) {
210         return balances[_owner];
211     }
212 
213     // mitigates the ERC20 short address attack
214     modifier onlyPayloadSize(uint size) {
215         assert(msg.data.length >= size + 4);
216         _;
217     }
218     
219     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
220 
221         require(_to != address(0));
222         require(_amount <= balances[msg.sender]);
223         
224         balances[msg.sender] = balances[msg.sender].sub(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         emit Transfer(msg.sender, _to, _amount);
227         return true;
228     }
229     
230     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
231 
232         require(_to != address(0));
233         require(_amount <= balances[_from]);
234         require(_amount <= allowed[_from][msg.sender]);
235         
236         balances[_from] = balances[_from].sub(_amount);
237         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         emit Transfer(_from, _to, _amount);
240         return true;
241     }
242     
243     function approve(address _spender, uint256 _value) public returns (bool success) {
244         // mitigates the ERC20 spend/approval race condition
245         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
246         allowed[msg.sender][_spender] = _value;
247         emit Approval(msg.sender, _spender, _value);
248         return true;
249     }
250     
251     function allowance(address _owner, address _spender) constant public returns (uint256) {
252         return allowed[_owner][_spender];
253     }
254     
255     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
256         AltcoinToken t = AltcoinToken(tokenAddress);
257         uint bal = t.balanceOf(who);
258         return bal;
259     }
260     
261     function withdraw() onlyOwner public {
262         address myAddress = this;
263         uint256 etherBalance = myAddress.balance;
264         owner.transfer(etherBalance);
265     }
266     
267     function burn(uint256 _value) onlyOwner public {
268         require(_value <= balances[msg.sender]);
269         // no need to require value <= totalSupply, since that would imply the
270         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
271 
272         address burner = msg.sender;
273         balances[burner] = balances[burner].sub(_value);
274         totalSupply = totalSupply.sub(_value);
275         totalDistributed = totalDistributed.sub(_value);
276         emit Burn(burner, _value);
277     }
278     
279     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
280         AltcoinToken token = AltcoinToken(_tokenContract);
281         uint256 amount = token.balanceOf(address(this));
282         return token.transfer(owner, amount);
283     }
284 }