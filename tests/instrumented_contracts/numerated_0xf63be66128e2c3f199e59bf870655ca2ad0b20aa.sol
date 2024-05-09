1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         // uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return a / b;
20     }
21 
22     /**
23     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24     */
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     /**
31     * Adds two numbers, throws on overflow.
32     */
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract AltcoinToken {
41     function balanceOf(address _owner) constant public returns (uint256);
42     function transfer(address _to, uint256 _value) public returns (bool);
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract TranslatixToken is ERC20 {
60     
61     using SafeMath for uint256;
62     address public owner = msg.sender;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;    
66 
67     string public constant name = "Translatix";
68     string public constant symbol = "TNX";
69     uint public constant decimals = 8;
70     
71     uint256 public totalSupply = 13000000000 * (10**decimals);      
72     uint256 public tokensPerEth = 10000000 * (10**decimals);
73     uint256 public tokensForSale = 7800000000 * (10**decimals);
74     uint256 public totalDistributed = 0;
75     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
76     uint256 public totalTokenSold; 
77     uint256 public totalWeiReceived;  
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84     event ICOStarted();
85 
86     event Airdrop(address indexed _owner, uint _amount, uint _balance);
87 
88     event TokensPerEthUpdated(uint _tokensPerEth);
89     
90     event Burn(address indexed burner, uint256 value);
91 
92     bool public distributionFinished = false;
93     bool public icoStarted = false;
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
106     constructor () public {
107         owner = msg.sender;
108         uint256 devTokens = 1300000000 * (10**decimals);
109         distr(owner, devTokens);
110     }
111     
112 
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
118 
119     function startICO() onlyOwner public returns (bool) {
120         icoStarted = true;
121         distributionFinished = false;
122         emit ICOStarted();
123         return true;
124     }
125 
126     function finishDistribution() onlyOwner public returns (bool) {
127         distributionFinished = true;
128         emit DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137 
138         return true;
139     }
140 
141     function doAirdrop(address _participant, uint _amount) internal {
142 
143         require( _amount > 0 );      
144 
145         require( totalDistributed < totalSupply );
146         
147         balances[_participant] = balances[_participant].add(_amount);
148         totalDistributed = totalDistributed.add(_amount);
149 
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153 
154         // log
155         emit Airdrop(_participant, _amount, balances[_participant]);
156         emit Transfer(address(0), _participant, _amount);
157     }
158 
159     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
160         doAirdrop(_participant, _amount);
161     }
162 
163     function adminClaimAirdropMultipleAddressMultiAmount(address[] _addresses, uint[] _amount) public onlyOwner {        
164         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount[i]);
165     }
166 
167     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
168         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
169     }
170 
171     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
172         tokensPerEth = _tokensPerEth;
173         emit TokensPerEthUpdated(_tokensPerEth);
174     }
175            
176     function () external payable {
177         getTokens();
178      }
179     
180     function getTokens() payable canDistr  public {
181     	require(icoStarted);
182         uint256 tokens = 0;
183 
184         require( msg.value >= minContribution );
185 
186         require( msg.value > 0 );
187         if(msg.value >= 1 ether){
188             tokens = tokensPerEth.mul((msg.value*5)/4) / 1 ether; 
189         } else {
190             tokens = tokensPerEth.mul(msg.value) / 1 ether; 
191         }
192 
193         address investor = msg.sender;
194         
195         if (tokens > 0) {
196             distr(investor, tokens);
197             totalWeiReceived = totalWeiReceived.add(msg.value);
198             totalTokenSold = totalTokenSold.add(tokens);        
199         }
200 
201         if (totalTokenSold >= tokensForSale) {
202             distributionFinished = true;
203         }
204     }
205 
206     function balanceOf(address _owner) constant public returns (uint256) {
207         return balances[_owner];
208     }
209 
210     // mitigates the ERC20 short address attack
211     modifier onlyPayloadSize(uint size) {
212         assert(msg.data.length >= size + 4);
213         _;
214     }
215     
216     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
217 
218         require(_to != address(0));
219         require(_amount <= balances[msg.sender]);
220         
221         balances[msg.sender] = balances[msg.sender].sub(_amount);
222         balances[_to] = balances[_to].add(_amount);
223 
224 
225         emit Transfer(msg.sender, _to, _amount);
226         return true;
227     }
228     
229     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
230 
231         require(_to != address(0));
232         require(_amount <= balances[_from]);
233         require(_amount <= allowed[_from][msg.sender]);
234         
235         balances[_from] = balances[_from].sub(_amount);
236         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         emit Transfer(_from, _to, _amount);
239         return true;
240     }
241     
242     function approve(address _spender, uint256 _value) public returns (bool success) {
243         // mitigates the ERC20 spend/approval race condition
244         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249     
250     function allowance(address _owner, address _spender) constant public returns (uint256) {
251         return allowed[_owner][_spender];
252     }
253     
254     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
255         AltcoinToken t = AltcoinToken(tokenAddress);
256         uint bal = t.balanceOf(who);
257         return bal;
258     }
259 
260     function withdraw(uint amount) onlyOwner public returns(bool) {
261         // uint amount = pendingWithdraws[msg.sender];
262         // pendingWithdraws[msg.sender] = 0;
263         // msg.sender.transfer(amount);
264         require(amount < address(this).balance);
265         owner.transfer(amount);
266         return true;
267 
268     }
269     
270     function burn(uint256 _value) onlyOwner public {
271         require(_value <= balances[msg.sender]);
272         
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         totalSupply = totalSupply.sub(_value);
276         totalDistributed = totalDistributed.sub(_value);
277         emit Burn(burner, _value);
278     }
279     
280     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
281         AltcoinToken token = AltcoinToken(_tokenContract);
282         uint256 amount = token.balanceOf(address(this));
283         return token.transfer(owner, amount);
284     }
285 }