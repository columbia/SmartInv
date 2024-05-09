1 /* 
2 @New Smartcontract ESCX Token
3 @Registered Company PT.Edukasi Digital Aset Indonesia
4 @Project Expert Student Class :School learning about blockchain technology,trading,management risk,and investment.
5 @Created 8 November 2019 by ESCX Team
6 @Official Website https://escx.co.id
7  */
8 pragma solidity ^0.4.18;
9 
10 /*
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     /*
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /*
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /*
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /*
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract AltcoinToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract ESCX is ERC20 {
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;    
82 
83     string public constant name = "ESCX Token";
84     string public constant symbol = "ESCX";
85     uint public constant decimals = 8;
86     
87     uint256 public totalSupply = 200000000e8;
88     uint256 public totalDistributed = 0;    
89     uint256 public constant MIN_PURCHASE = 1 ether / 100;
90     uint256 public tokensPerEth = 25000e8;
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     
95     event Distr(address indexed to, uint256 amount);
96     event DistrFinished();
97     event StartICO();
98     event ResetICO();
99 
100     event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102     event TokensPerEthUpdated(uint _tokensPerEth);
103     
104     event Burn(address indexed burner, uint256 value);
105 
106     bool public distributionFinished = false;
107 
108     bool public icoStart = false;
109     
110     modifier canDistr() {
111         require(!distributionFinished);
112         require(icoStart);
113         _;
114     }
115     
116     modifier onlyOwner() {
117         require(msg.sender == owner);
118         _;
119     }
120     
121     
122     constructor () public {
123         owner = msg.sender;
124     }
125     
126     function transferOwnership(address newOwner) onlyOwner public {
127         if (newOwner != address(0)) {
128             owner = newOwner;
129         }
130     }
131 
132     function startICO() onlyOwner public returns (bool) {
133         icoStart = true;
134         emit StartICO();
135         return true;
136     }
137 
138     function resetICO() onlyOwner public returns (bool) {
139         icoStart = false;
140         distributionFinished = false;
141         emit ResetICO();
142         return true;
143     }
144 
145     function finishDistribution() onlyOwner canDistr public returns (bool) {
146         distributionFinished = true;
147         emit DistrFinished();
148         return true;
149     }
150     
151     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
152         totalDistributed = totalDistributed.add(_amount);        
153         balances[_to] = balances[_to].add(_amount);
154         emit Distr(_to, _amount);
155         emit Transfer(address(0), _to, _amount);
156 
157         return true;
158     }
159 
160     function doAirdrop(address _participant, uint _amount) internal {
161 
162         require( _amount > 0 );      
163 
164         require( totalDistributed < totalSupply );
165         
166         balances[_participant] = balances[_participant].add(_amount);
167         totalDistributed = totalDistributed.add(_amount);
168 
169         if (totalDistributed >= totalSupply) {
170             distributionFinished = true;
171         }
172 
173         // log
174         emit Airdrop(_participant, _amount, balances[_participant]);
175         emit Transfer(address(0), _participant, _amount);
176     }
177 
178     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
179         doAirdrop(_participant, _amount);
180     }
181 
182     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
183         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
184     }
185 
186     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
187         tokensPerEth = _tokensPerEth;
188         emit TokensPerEthUpdated(_tokensPerEth);
189     }
190            
191     function () external payable {
192         getTokens();
193      }
194     
195     function getTokens() payable canDistr  public {
196         uint256 tokens = 0;
197 
198         // minimum contribution
199         require( msg.value >= MIN_PURCHASE );
200 
201         require( msg.value > 0 );
202 
203         // get baseline number of tokens
204         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
205         address investor = msg.sender;
206         
207         if (tokens > 0) {
208             distr(investor, tokens);
209         }
210 
211         if (totalDistributed >= totalSupply) {
212             distributionFinished = true;
213         }
214     }
215 
216     function balanceOf(address _owner) constant public returns (uint256) {
217         return balances[_owner];
218     }
219 
220     // mitigates the ERC20 short address attack
221     modifier onlyPayloadSize(uint size) {
222         assert(msg.data.length >= size + 4);
223         _;
224     }
225     
226     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
227 
228         require(_to != address(0));
229         require(_amount <= balances[msg.sender]);
230         
231         balances[msg.sender] = balances[msg.sender].sub(_amount);
232         balances[_to] = balances[_to].add(_amount);
233         emit Transfer(msg.sender, _to, _amount);
234         return true;
235     }
236     
237     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
238 
239         require(_to != address(0));
240         require(_amount <= balances[_from]);
241         require(_amount <= allowed[_from][msg.sender]);
242         
243         balances[_from] = balances[_from].sub(_amount);
244         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
245         balances[_to] = balances[_to].add(_amount);
246         emit Transfer(_from, _to, _amount);
247         return true;
248     }
249     
250     function approve(address _spender, uint256 _value) public returns (bool success) {
251         // mitigates the ERC20 spend/approval race condition
252         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
253         allowed[msg.sender][_spender] = _value;
254         emit Approval(msg.sender, _spender, _value);
255         return true;
256     }
257     
258     function allowance(address _owner, address _spender) constant public returns (uint256) {
259         return allowed[_owner][_spender];
260     }
261     
262     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
263         AltcoinToken t = AltcoinToken(tokenAddress);
264         uint bal = t.balanceOf(who);
265         return bal;
266     }
267     
268     function withdraw() onlyOwner public {
269         address myAddress = this;
270         uint256 etherBalance = myAddress.balance;
271         owner.transfer(etherBalance);
272     }
273     
274     function burn(uint256 _value) onlyOwner public {
275         require(_value <= balances[msg.sender]);
276         // no need to require value <= totalSupply, since that would imply the
277         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
278 
279         address burner = msg.sender;
280         balances[burner] = balances[burner].sub(_value);
281         totalSupply = totalSupply.sub(_value);
282         totalDistributed = totalDistributed.sub(_value);
283         emit Burn(burner, _value);
284     }
285     
286     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
287         AltcoinToken token = AltcoinToken(_tokenContract);
288         uint256 amount = token.balanceOf(address(this));
289         return token.transfer(owner, amount);
290     }
291 }