1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ADPay Token Contract
5 //
6 // Symbol      : ADPY
7 // Name        : ADPay
8 // Total supply: 400,000,000.000000000000000000
9 // Decimals    : 8
10 //
11 // Enjoy.
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 
20 pragma solidity ^0.4.19;
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract ForeignToken {
47     function balanceOf(address _owner) constant public returns (uint256);
48     function transfer(address _to, uint256 _value) public returns (bool);
49 }
50 
51 contract ERC20Basic {
52     uint256 public totalSupply;
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public constant returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 interface Token { 
66     function distr(address _to, uint256 _value) public returns (bool);
67     function totalSupply() constant public returns (uint256 supply);
68     function balanceOf(address _owner) constant public returns (uint256 balance);
69 }
70 
71 contract ADPay is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping (address => bool) public blacklist;
79 
80     string public constant name = "ADPay";
81     string public constant symbol = "ADPY";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 400000000e8;
85     uint256 public totalDistributed = 100000000e8;
86     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
87     uint256 public value;
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94     
95     event Burn(address indexed burner, uint256 value);
96 
97     bool public distributionFinished = false;
98     
99     modifier canDistr() {
100         require(!distributionFinished);
101         _;
102     }
103     
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }
108     
109     modifier onlyWhitelist() {
110         require(blacklist[msg.sender] == false);
111         _;
112     }
113     
114     function ADPay () public {
115         owner = msg.sender;
116         value = 10000e8;
117         distr(owner, totalDistributed);
118     }
119     
120     function transferOwnership(address newOwner) onlyOwner public {
121         if (newOwner != address(0)) {
122             owner = newOwner;
123         }
124     }
125     
126     function enableWhitelist(address[] addresses) onlyOwner public {
127         for (uint i = 0; i < addresses.length; i++) {
128             blacklist[addresses[i]] = false;
129         }
130     }
131 
132     function disableWhitelist(address[] addresses) onlyOwner public {
133         for (uint i = 0; i < addresses.length; i++) {
134             blacklist[addresses[i]] = true;
135         }
136     }
137 
138     function finishDistribution() onlyOwner canDistr public returns (bool) {
139         distributionFinished = true;
140         DistrFinished();
141         return true;
142     }
143     
144     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
145         totalDistributed = totalDistributed.add(_amount);
146         totalRemaining = totalRemaining.sub(_amount);
147         balances[_to] = balances[_to].add(_amount);
148         Distr(_to, _amount);
149         Transfer(address(0), _to, _amount);
150         return true;
151         
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155     }
156     
157     function airdrop(address[] addresses) onlyOwner canDistr public {
158         
159         require(addresses.length <= 255);
160         require(value <= totalRemaining);
161         
162         for (uint i = 0; i < addresses.length; i++) {
163             require(value <= totalRemaining);
164             distr(addresses[i], value);
165         }
166 	
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170     }
171     
172     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
173         
174         require(addresses.length <= 255);
175         require(amount <= totalRemaining);
176         
177         for (uint i = 0; i < addresses.length; i++) {
178             require(amount <= totalRemaining);
179             distr(addresses[i], amount);
180         }
181 	
182         if (totalDistributed >= totalSupply) {
183             distributionFinished = true;
184         }
185     }
186     
187     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
188 
189         require(addresses.length <= 255);
190         require(addresses.length == amounts.length);
191         
192         for (uint8 i = 0; i < addresses.length; i++) {
193             require(amounts[i] <= totalRemaining);
194             distr(addresses[i], amounts[i]);
195             
196             if (totalDistributed >= totalSupply) {
197                 distributionFinished = true;
198             }
199         }
200     }
201     
202     function () external payable {
203             getTokens();
204      }
205     
206     function getTokens() payable canDistr onlyWhitelist public {
207         
208         if (value > totalRemaining) {
209             value = totalRemaining;
210         }
211         
212         require(value <= totalRemaining);
213         
214         address investor = msg.sender;
215         uint256 toGive = value;
216         
217         distr(investor, toGive);
218         
219         if (toGive > 0) {
220             blacklist[investor] = true;
221         }
222 
223         if (totalDistributed >= totalSupply) {
224             distributionFinished = true;
225         }
226         
227         value = value.div(100000).mul(99999);
228     }
229 
230     function balanceOf(address _owner) constant public returns (uint256) {
231 	    return balances[_owner];
232     }
233 
234     // mitigates the ERC20 short address attack
235     modifier onlyPayloadSize(uint size) {
236         assert(msg.data.length >= size + 4);
237         _;
238     }
239     
240     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
241 
242         require(_to != address(0));
243         require(_amount <= balances[msg.sender]);
244         
245         balances[msg.sender] = balances[msg.sender].sub(_amount);
246         balances[_to] = balances[_to].add(_amount);
247         Transfer(msg.sender, _to, _amount);
248         return true;
249     }
250     
251     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
252 
253         require(_to != address(0));
254         require(_amount <= balances[_from]);
255         require(_amount <= allowed[_from][msg.sender]);
256         
257         balances[_from] = balances[_from].sub(_amount);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         Transfer(_from, _to, _amount);
261         return true;
262     }
263     
264     function approve(address _spender, uint256 _value) public returns (bool success) {
265         // mitigates the ERC20 spend/approval race condition
266         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
267         allowed[msg.sender][_spender] = _value;
268         Approval(msg.sender, _spender, _value);
269         return true;
270     }
271     
272     function allowance(address _owner, address _spender) constant public returns (uint256) {
273         return allowed[_owner][_spender];
274     }
275     
276     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
277         ForeignToken t = ForeignToken(tokenAddress);
278         uint bal = t.balanceOf(who);
279         return bal;
280     }
281     
282     function withdraw() onlyOwner public {
283         uint256 etherBalance = this.balance;
284         owner.transfer(etherBalance);
285     }
286     
287     function burn(uint256 _value) onlyOwner public {
288         require(_value <= balances[msg.sender]);
289         // no need to require value <= totalSupply, since that would imply the
290         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
291 
292         address burner = msg.sender;
293         balances[burner] = balances[burner].sub(_value);
294         totalSupply = totalSupply.sub(_value);
295         totalDistributed = totalDistributed.sub(_value);
296         Burn(burner, _value);
297     }
298     
299     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
300         ForeignToken token = ForeignToken(_tokenContract);
301         uint256 amount = token.balanceOf(address(this));
302         return token.transfer(owner, amount);
303     }
304 
305 
306 }