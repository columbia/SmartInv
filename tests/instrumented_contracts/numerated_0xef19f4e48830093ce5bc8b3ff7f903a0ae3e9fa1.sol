1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ForeignToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract botXcoin is ERC20 {
68 
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 	mapping (address => bool) public holdAccount;
75  
76     string public constant name = "botXcoin";
77     string public constant symbol = "BOTX";
78     uint public constant decimals = 18;
79 
80     uint256 public totalSupply = 5000000000e18; // Supply
81     uint256 public totalDistributed = 0;
82     uint256 public min_contribution = 1 ether / 100; // 0.01 Ether
83     uint256 public tokensPerEth = 10000e18;
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     event Distr(address indexed to, uint256 amount);
88     event DistrFinished();
89     event Airdrop(address indexed _owner, uint _amount, uint _balance);
90     event ICO(address indexed _owner, uint _amount, uint _balance);
91 	event MinContributionUpdated(uint _mincontribution);
92     event TokensPerEthUpdated(uint _tokensPerEth);
93     event Burn(address indexed burner, uint256 value);
94 	event HoldFunds(address target, bool hold);
95 
96     bool public distributionFinished = false;
97 
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102 
103     modifier cantDistr() {
104         require(distributionFinished);
105         _;
106     }
107 
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113 //    function RandiCoin () public {
114 //        owner = msg.sender;
115 //        distr(owner, totalDistributed);
116 //    }
117 
118     function transferOwnership(address newOwner) onlyOwner public {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123 
124     function finishDistribution() onlyOwner canDistr public returns (bool) {
125         distributionFinished = true;
126         emit DistrFinished();
127         return true;
128     }
129 
130     function startDistribution() onlyOwner cantDistr public returns (bool) {
131         distributionFinished = false;
132         emit DistrFinished();
133         return true;
134     }
135 
136     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
137         totalDistributed = totalDistributed.add(_amount);
138         balances[_to] = balances[_to].add(_amount);
139         emit Distr(_to, _amount);
140         emit Transfer(address(0), _to, _amount);
141         return true;
142     }
143 
144     function doAirdrop(address _participant, uint _amount) internal {
145 
146         require( _amount > 0 );
147         require( totalDistributed < totalSupply );
148         balances[_participant] = balances[_participant].add(_amount);
149         totalDistributed = totalDistributed.add(_amount);
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153 
154         emit Airdrop(_participant, _amount, balances[_participant]);
155         emit Transfer(address(0), _participant, _amount);
156     }
157 
158     function doICO(address _participant, uint _amount) internal {
159 
160         require( _amount > 0 );
161         require( totalDistributed < totalSupply );
162         balances[_participant] = balances[_participant].add(_amount);
163         totalDistributed = totalDistributed.add(_amount);
164         if (totalDistributed >= totalSupply) {
165             distributionFinished = true;
166         }
167         emit ICO(_participant, _amount, balances[_participant]);
168         emit Transfer(address(0), _participant, _amount);
169     }
170 
171     function adminClaimICO(address[] _addresses, uint[] _amount) public onlyOwner {
172         for (uint i = 0; i < _addresses.length; i++) doICO(_addresses[i], _amount[i]); 
173     }
174 
175     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {
176         doAirdrop(_participant, _amount);
177     }
178 
179     function adminClaimAirdropMultiple1(address[] _addresses, uint _amount) public onlyOwner {
180         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
181     }
182 
183     function adminClaimAirdropMultiple2(address[] _addresses, uint[] _amount) public onlyOwner {
184         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount[i]);
185     }
186 
187     function updateMinContribution(uint _mincontribution) public onlyOwner {
188         min_contribution = _mincontribution;
189         emit MinContributionUpdated(_mincontribution);
190     }
191 
192     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {
193         tokensPerEth = _tokensPerEth;
194         emit TokensPerEthUpdated(_tokensPerEth);
195     }
196 	
197     function () external payable {
198         getTokens();
199      }
200 
201     function getTokens() payable canDistr  public {
202         uint256 tokens = 0;
203 
204         require( msg.value >= min_contribution );
205 
206         require( msg.value > 0 );
207 
208         tokens = tokensPerEth.mul(msg.value) / 1 ether;
209         address investor = msg.sender;
210 
211         if (tokens > 0) {
212             distr(investor, tokens);
213         }
214 
215         if (totalDistributed >= totalSupply) {
216             distributionFinished = true;
217         }
218     }
219 
220     function balanceOf(address _owner) constant public returns (uint256) {
221         return balances[_owner];
222     }
223 
224     function holdAccountOf(address _owner) constant public returns (bool) {
225         return holdAccount[_owner];
226     }
227 
228     // mitigates the ERC20 short address attack
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233 
234     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[msg.sender]);
238 		require(!holdAccount[msg.sender]);
239 
240         balances[msg.sender] = balances[msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Transfer(msg.sender, _to, _amount);
243         return true;
244     }
245 
246     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
247 
248         require(_to != address(0));
249         require(_amount <= balances[_from]);
250         require(_amount <= allowed[_from][msg.sender]);
251 
252         balances[_from] = balances[_from].sub(_amount);
253         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         emit Transfer(_from, _to, _amount);
256         return true;
257     }
258 
259     function approve(address _spender, uint256 _value) public returns (bool success) {
260         // mitigates the ERC20 spend/approval race condition
261         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
262         allowed[msg.sender][_spender] = _value;
263         emit Approval(msg.sender, _spender, _value);
264         return true;
265     }
266 
267     function HoldAccount(address target, bool hold) onlyOwner public {
268         holdAccount[target] = hold;
269         emit HoldFunds(target, hold);
270     }
271 	
272     function HoldAccountMulti(address[] _target, bool _hold) onlyOwner public {
273         for (uint i = 0; i < _target.length; i++) {
274 			holdAccount[_target[i]] = _hold;
275 			emit HoldFunds(_target[i], _hold);
276 		}
277     }
278 
279     function allowance(address _owner, address _spender) constant public returns (uint256) {
280         return allowed[_owner][_spender];
281     }
282 
283     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
284         ForeignToken t = ForeignToken(tokenAddress);
285         uint bal = t.balanceOf(who);
286         return bal;
287     }
288 
289     function withdraw() onlyOwner public {
290         address myAddress = this;
291         uint256 etherBalance = myAddress.balance;
292         owner.transfer(etherBalance);
293     }
294 
295     function burn(uint256 _value) onlyOwner public {
296         require(_value <= balances[msg.sender]);
297 
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         totalSupply = totalSupply.sub(_value);
301         totalDistributed = totalDistributed.sub(_value);
302         emit Burn(burner, _value);
303     }
304 
305     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
306         ForeignToken token = ForeignToken(_tokenContract);
307         uint256 amount = token.balanceOf(address(this));
308         return token.transfer(owner, amount);
309     }
310 }