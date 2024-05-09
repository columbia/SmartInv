1 pragma solidity ^0.4.19;
2 // Token name: KEA Coin
3 // Symbol: KEA
4 // Decimals: 8
5 // Twitter : @KEACoin
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ForeignToken {
32     function balanceOf(address _owner) constant public returns (uint256);
33     function transfer(address _to, uint256 _value) public returns (bool);
34 }
35 
36 contract ERC20Basic {
37     uint256 public totalSupply;
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) public constant returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 interface Token { 
51     function distr(address _to, uint256 _value) public returns (bool);
52     function totalSupply() constant public returns (uint256 supply);
53     function balanceOf(address _owner) constant public returns (uint256 balance);
54 }
55 
56 contract KEACoin is ERC20 {
57     
58     using SafeMath for uint256;
59     address owner = msg.sender;
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     mapping (address => bool) public blacklist;
64 
65     string public constant name = "KEA Coin";
66     string public constant symbol = "KEA";
67     uint public constant decimals = 8;
68     
69     uint256 public totalSupply = 1000000000e8;
70     uint256 public totalDistributed = 200000000e8;
71     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     uint256 public value;
73     uint256 public minReq;
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77     
78     event Distr(address indexed to, uint256 amount);
79     event DistrFinished();
80     
81     event Burn(address indexed burner, uint256 value);
82 
83     bool public distributionFinished = false;
84     
85     modifier canDistr() {
86         require(!distributionFinished);
87         _;
88     }
89     
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94     
95     modifier onlyWhitelist() {
96         require(blacklist[msg.sender] == false);
97         _;
98     }
99     
100     function KEACoin (uint256 _value, uint256 _minReq) public {
101         owner = msg.sender;
102         value = _value;
103         minReq = _minReq;
104         balances[msg.sender] = totalDistributed;
105     }
106     
107      function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {
108         value = _value;
109         minReq = _minReq;
110     }
111 
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118     function enableWhitelist(address[] addresses) onlyOwner public {
119         for (uint i = 0; i < addresses.length; i++) {
120             blacklist[addresses[i]] = false;
121         }
122     }
123 
124     function disableWhitelist(address[] addresses) onlyOwner public {
125         for (uint i = 0; i < addresses.length; i++) {
126             blacklist[addresses[i]] = true;
127         }
128     }
129 
130     function finishDistribution() onlyOwner canDistr public returns (bool) {
131         distributionFinished = true;
132         DistrFinished();
133         return true;
134     }
135     
136     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
137         totalDistributed = totalDistributed.add(_amount);
138         totalRemaining = totalRemaining.sub(_amount);
139         balances[_to] = balances[_to].add(_amount);
140         Distr(_to, _amount);
141         Transfer(address(0), _to, _amount);
142         return true;
143         
144         if (totalDistributed >= totalSupply) {
145             distributionFinished = true;
146         }
147     }
148     
149     function airdrop(address[] addresses) onlyOwner canDistr public {
150         
151         require(addresses.length <= 255);
152         require(value <= totalRemaining);
153         
154         for (uint i = 0; i < addresses.length; i++) {
155             require(value <= totalRemaining);
156             distr(addresses[i], value);
157         }
158     
159         if (totalDistributed >= totalSupply) {
160             distributionFinished = true;
161         }
162     }
163     
164     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
165         
166         require(addresses.length <= 255);
167         require(amount <= totalRemaining);
168         
169         for (uint i = 0; i < addresses.length; i++) {
170             require(amount <= totalRemaining);
171             distr(addresses[i], amount);
172         }
173     
174         if (totalDistributed >= totalSupply) {
175             distributionFinished = true;
176         }
177     }
178     
179     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
180 
181         require(addresses.length <= 255);
182         require(addresses.length == amounts.length);
183         
184         for (uint8 i = 0; i < addresses.length; i++) {
185             require(amounts[i] <= totalRemaining);
186             distr(addresses[i], amounts[i]);
187             
188             if (totalDistributed >= totalSupply) {
189                 distributionFinished = true;
190             }
191         }
192     }
193     
194     function () external payable {
195             getTokens();
196      }
197     
198     function getTokens() payable canDistr onlyWhitelist public {
199         
200         require(value <= totalRemaining);
201         
202         address investor = msg.sender;
203         uint256 toGive = value;
204         
205         if (msg.value < minReq){
206             toGive = value.sub(value);
207         }
208         
209         distr(investor, toGive);
210         
211         if (toGive > 0) {
212             blacklist[investor] = true;
213         }
214 
215         if (totalDistributed >= totalSupply) {
216             distributionFinished = true;
217         }
218         uint256 etherBalance = this.balance;
219         if (etherBalance > 0) {
220             owner.transfer(etherBalance);
221         }
222     }
223 
224     function balanceOf(address _owner) constant public returns (uint256) {
225         return balances[_owner];
226     }
227 
228     // mitigates the ERC20 short address attack
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233     
234     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
235         require(_to != address(0));
236         require(_amount <= balances[msg.sender]);
237         
238         balances[msg.sender] = balances[msg.sender].sub(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         Transfer(msg.sender, _to, _amount);
241         return true;
242     }
243     
244     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
245         require(_to != address(0));
246         require(_amount <= balances[_from]);
247         require(_amount <= allowed[_from][msg.sender]);
248         
249         balances[_from] = balances[_from].sub(_amount);
250         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
251         balances[_to] = balances[_to].add(_amount);
252         Transfer(_from, _to, _amount);
253         return true;
254     }
255     
256     function approve(address _spender, uint256 _value) public returns (bool success) {
257         // mitigates the ERC20 spend/approval race condition
258         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
259         allowed[msg.sender][_spender] = _value;
260         Approval(msg.sender, _spender, _value);
261         return true;
262     }
263     
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267     
268     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
269         ForeignToken t = ForeignToken(tokenAddress);
270         uint bal = t.balanceOf(who);
271         return bal;
272     }
273     
274     function withdraw() onlyOwner public {
275         uint256 etherBalance = this.balance;
276         owner.transfer(etherBalance);
277     }
278     
279     function burn(uint256 _value) onlyOwner public {
280         require(_value <= balances[msg.sender]);
281         // no need to require value <= totalSupply, since that would imply the
282         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284         address burner = msg.sender;
285         balances[burner] = balances[burner].sub(_value);
286         totalSupply = totalSupply.sub(_value);
287         totalDistributed = totalDistributed.sub(_value);
288         Burn(burner, _value);
289     }
290     
291    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
292         ForeignToken token = ForeignToken(_tokenContract);
293         uint256 amount = token.balanceOf(address(this));
294         if (amount > 0) {
295             return token.transfer(owner, amount);
296         }
297         return true;
298  
299     }
300 }