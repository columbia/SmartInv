1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) public returns (bool);
48     function totalSupply() constant public returns (uint256 supply);
49     function balanceOf(address _owner) constant public returns (uint256 balance);
50 }
51 
52 contract Enumivo is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "Enumivo";
62     string public constant symbol = "ENU";
63     uint public constant decimals = 8;
64     
65     uint256 public totalSupply = 1000000000e8;
66     uint256 public totalDistributed = 100000000e8;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 public value;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     
76     event Burn(address indexed burner, uint256 value);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     modifier onlyWhitelist() {
91         require(blacklist[msg.sender] == false);
92         _;
93     }
94     
95     function UselessAirdroppedToken () public {
96         owner = msg.sender;
97         value = 5000e8;
98         //balances[msg.sender] = totalDistributed;
99         distr(owner, totalDistributed);
100     }
101     
102     function transferOwnership(address newOwner) onlyOwner public {
103         if (newOwner != address(0)) {
104             owner = newOwner;
105         }
106     }
107     
108     function enableWhitelist(address[] addresses) onlyOwner public {
109         for (uint i = 0; i < addresses.length; i++) {
110             blacklist[addresses[i]] = false;
111         }
112     }
113 
114     function disableWhitelist(address[] addresses) onlyOwner public {
115         for (uint i = 0; i < addresses.length; i++) {
116             blacklist[addresses[i]] = true;
117         }
118     }
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         Distr(_to, _amount);
131         Transfer(address(0), _to, _amount);
132         return true;
133         
134         if (totalDistributed >= totalSupply) {
135             distributionFinished = true;
136         }
137     }
138     
139     function airdrop(address[] addresses) onlyOwner canDistr public {
140         
141         require(addresses.length <= 255);
142         require(value <= totalRemaining);
143         
144         for (uint i = 0; i < addresses.length; i++) {
145             require(value <= totalRemaining);
146             distr(addresses[i], value);
147         }
148 	
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152     }
153     
154     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
155         
156         require(addresses.length <= 255);
157         require(amount <= totalRemaining);
158         
159         for (uint i = 0; i < addresses.length; i++) {
160             require(amount <= totalRemaining);
161             distr(addresses[i], amount);
162         }
163 	
164         if (totalDistributed >= totalSupply) {
165             distributionFinished = true;
166         }
167     }
168     
169     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
170 
171         require(addresses.length <= 255);
172         require(addresses.length == amounts.length);
173         
174         for (uint8 i = 0; i < addresses.length; i++) {
175             require(amounts[i] <= totalRemaining);
176             distr(addresses[i], amounts[i]);
177             
178             if (totalDistributed >= totalSupply) {
179                 distributionFinished = true;
180             }
181         }
182     }
183     
184     function () external payable {
185             getTokens();
186      }
187     
188     function getTokens() payable canDistr onlyWhitelist public {
189         
190         if (value > totalRemaining) {
191             value = totalRemaining;
192         }
193         
194         require(value <= totalRemaining);
195         
196         address investor = msg.sender;
197         uint256 toGive = value;
198         
199         distr(investor, toGive);
200         
201         if (toGive > 0) {
202             blacklist[investor] = true;
203         }
204 
205         if (totalDistributed >= totalSupply) {
206             distributionFinished = true;
207         }
208         
209         value = value.div(1000).mul(999);
210     }
211 
212     function balanceOf(address _owner) constant public returns (uint256) {
213 	    return balances[_owner];
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
229         Transfer(msg.sender, _to, _amount);
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
242         Transfer(_from, _to, _amount);
243         return true;
244     }
245     
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         // mitigates the ERC20 spend/approval race condition
248         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
249         allowed[msg.sender][_spender] = _value;
250         Approval(msg.sender, _spender, _value);
251         return true;
252     }
253     
254     function allowance(address _owner, address _spender) constant public returns (uint256) {
255         return allowed[_owner][_spender];
256     }
257     
258     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
259         ForeignToken t = ForeignToken(tokenAddress);
260         uint bal = t.balanceOf(who);
261         return bal;
262     }
263     
264     function withdraw() onlyOwner public {
265         uint256 etherBalance = this.balance;
266         owner.transfer(etherBalance);
267     }
268     
269     function burn(uint256 _value) onlyOwner public {
270         require(_value <= balances[msg.sender]);
271         // no need to require value <= totalSupply, since that would imply the
272         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
273 
274         address burner = msg.sender;
275         balances[burner] = balances[burner].sub(_value);
276         totalSupply = totalSupply.sub(_value);
277         totalDistributed = totalDistributed.sub(_value);
278         Burn(burner, _value);
279     }
280     
281     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
282         ForeignToken token = ForeignToken(_tokenContract);
283         uint256 amount = token.balanceOf(address(this));
284         return token.transfer(owner, amount);
285     }
286 
287 
288 }