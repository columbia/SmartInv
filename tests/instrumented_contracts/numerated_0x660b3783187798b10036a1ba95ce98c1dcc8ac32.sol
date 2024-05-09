1 pragma solidity ^0.4.19;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a / b;
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 contract ForeignToken {
27     function balanceOf(address _owner) constant public returns (uint256);
28     function transfer(address _to, uint256 _value) public returns (bool);
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface Token { 
46     function distr(address _to, uint256 _value) public returns (bool);
47     function totalSupply() constant public returns (uint256 supply);
48     function balanceOf(address _owner) constant public returns (uint256 balance);
49 }
50 
51 contract Bitcoinsummit is ERC20 {
52     
53     using SafeMath for uint256;
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     mapping (address => bool) public blacklist;
59 
60     string public constant name = "Bitcoin Summit";
61     string public constant symbol = "BTCS";
62     uint public constant decimals = 8;
63     
64     uint256 public totalSupply = 1000000000e8;
65     uint256 public totalDistributed = 0;
66     uint256 public totalDistributedr = 980000000e8;
67     
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value;
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73     
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76     
77     event Burn(address indexed burner, uint256 value);
78 
79     bool public distributionFinished = false;
80     
81     modifier canDistr() {
82         require(!distributionFinished);
83         _;
84     }
85     
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90     
91     modifier onlyWhitelist() {
92         require(blacklist[msg.sender] == false);
93         _;
94     }
95     
96     function Bitcoinsummit () public {
97         owner = msg.sender;
98         value = 2000e8;
99         distr(owner, totalDistributedr);
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
209         value = value.div(100000).mul(99999);
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