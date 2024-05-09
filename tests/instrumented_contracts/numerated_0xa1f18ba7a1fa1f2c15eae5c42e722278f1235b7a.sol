1 /* 
2 @Registered Company PT.Edukasi Digital Aset Indonesia
3 @Project Expert Student Class :School learning about blockchain technology,trading,management risk,and investment.
4 @Created march 2019 by ESCX Team
5 @Official Website https://escx.co.id
6  */
7 pragma solidity ^0.4.18;
8 
9 /*
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /*
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /*
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /*
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /*
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract AltcoinToken {
56     function balanceOf(address _owner) constant public returns (uint256);
57     function transfer(address _to, uint256 _value) public returns (bool);
58 }
59 
60 contract ERC20Basic {
61     uint256 public totalSupply;
62     function balanceOf(address who) public constant returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public constant returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract ESCX is ERC20 {
75     
76     using SafeMath for uint256;
77     address owner = msg.sender;
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;    
81 
82     string public constant name = "ESCX Token";
83     string public constant symbol = "ESCX";
84     uint public constant decimals = 8;
85     
86     uint256 public totalSupply = 200000000e8;
87     uint256 public totalDistributed = 0;    
88     uint256 public constant MIN_PURCHASE = 1 ether / 100; // 0.05 Ether
89     uint256 public tokensPerEth = 22000e8;
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93     
94     event Distr(address indexed to, uint256 amount);
95     event DistrFinished();
96     event StartICO();
97     event ResetICO();
98 
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104 
105     bool public distributionFinished = false;
106 
107     bool public icoStart = false;
108     
109     modifier canDistr() {
110         require(!distributionFinished);
111         require(icoStart);
112         _;
113     }
114     
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119     
120     
121     constructor () public {
122         owner = msg.sender;
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130 
131     function startICO() onlyOwner public returns (bool) {
132         icoStart = true;
133         emit StartICO();
134         return true;
135     }
136 
137     function resetICO() onlyOwner public returns (bool) {
138         icoStart = false;
139         distributionFinished = false;
140         emit ResetICO();
141         return true;
142     }
143 
144     function finishDistribution() onlyOwner canDistr public returns (bool) {
145         distributionFinished = true;
146         emit DistrFinished();
147         return true;
148     }
149     
150     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
151         totalDistributed = totalDistributed.add(_amount);        
152         balances[_to] = balances[_to].add(_amount);
153         emit Distr(_to, _amount);
154         emit Transfer(address(0), _to, _amount);
155 
156         return true;
157     }
158 
159     function doAirdrop(address _participant, uint _amount) internal {
160 
161         require( _amount > 0 );      
162 
163         require( totalDistributed < totalSupply );
164         
165         balances[_participant] = balances[_participant].add(_amount);
166         totalDistributed = totalDistributed.add(_amount);
167 
168         if (totalDistributed >= totalSupply) {
169             distributionFinished = true;
170         }
171 
172         // log
173         emit Airdrop(_participant, _amount, balances[_participant]);
174         emit Transfer(address(0), _participant, _amount);
175     }
176 
177     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
178         doAirdrop(_participant, _amount);
179     }
180 
181     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
182         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
183     }
184 
185     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
186         tokensPerEth = _tokensPerEth;
187         emit TokensPerEthUpdated(_tokensPerEth);
188     }
189            
190     function () external payable {
191         getTokens();
192      }
193     
194     function getTokens() payable canDistr  public {
195         uint256 tokens = 0;
196 
197         // minimum contribution
198         require( msg.value >= MIN_PURCHASE );
199 
200         require( msg.value > 0 );
201 
202         // get baseline number of tokens
203         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
204         address investor = msg.sender;
205         
206         if (tokens > 0) {
207             distr(investor, tokens);
208         }
209 
210         if (totalDistributed >= totalSupply) {
211             distributionFinished = true;
212         }
213     }
214 
215     function balanceOf(address _owner) constant public returns (uint256) {
216         return balances[_owner];
217     }
218 
219     // mitigates the ERC20 short address attack
220     modifier onlyPayloadSize(uint size) {
221         assert(msg.data.length >= size + 4);
222         _;
223     }
224     
225     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
226 
227         require(_to != address(0));
228         require(_amount <= balances[msg.sender]);
229         
230         balances[msg.sender] = balances[msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         emit Transfer(msg.sender, _to, _amount);
233         return true;
234     }
235     
236     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
237 
238         require(_to != address(0));
239         require(_amount <= balances[_from]);
240         require(_amount <= allowed[_from][msg.sender]);
241         
242         balances[_from] = balances[_from].sub(_amount);
243         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
244         balances[_to] = balances[_to].add(_amount);
245         emit Transfer(_from, _to, _amount);
246         return true;
247     }
248     
249     function approve(address _spender, uint256 _value) public returns (bool success) {
250         // mitigates the ERC20 spend/approval race condition
251         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
252         allowed[msg.sender][_spender] = _value;
253         emit Approval(msg.sender, _spender, _value);
254         return true;
255     }
256     
257     function allowance(address _owner, address _spender) constant public returns (uint256) {
258         return allowed[_owner][_spender];
259     }
260     
261     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
262         AltcoinToken t = AltcoinToken(tokenAddress);
263         uint bal = t.balanceOf(who);
264         return bal;
265     }
266     
267     function withdraw() onlyOwner public {
268         address myAddress = this;
269         uint256 etherBalance = myAddress.balance;
270         owner.transfer(etherBalance);
271     }
272     
273     function burn(uint256 _value) onlyOwner public {
274         require(_value <= balances[msg.sender]);
275         // no need to require value <= totalSupply, since that would imply the
276         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
277 
278         address burner = msg.sender;
279         balances[burner] = balances[burner].sub(_value);
280         totalSupply = totalSupply.sub(_value);
281         totalDistributed = totalDistributed.sub(_value);
282         emit Burn(burner, _value);
283     }
284     
285     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
286         AltcoinToken token = AltcoinToken(_tokenContract);
287         uint256 amount = token.balanceOf(address(this));
288         return token.transfer(owner, amount);
289     }
290 }