1 // VEXANIUM  - VEXANIUM Gold
2 // Symbol VEXG
3 
4 // Send 0 ETH to contract address  
5 // (sending any extra amount of ETH will be considered as donations)
6 
7 // 1 address already 1 claim Token
8 
9 // Listed binance comingsoon
10 
11 
12 
13 
14 
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 
26 
27 
28 
29 
30 
31 
32 
33 
34 
35 
36 
37 
38 
39 
40 pragma solidity ^0.4.18;
41 
42 
43 
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a / b;
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 contract ForeignToken {
69     function balanceOf(address _owner) constant public returns (uint256);
70     function transfer(address _to, uint256 _value) public returns (bool);
71 }
72 
73 contract ERC20Basic {
74     uint256 public totalSupply;
75     function balanceOf(address who) public constant returns (uint256);
76     function transfer(address to, uint256 value) public returns (bool);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 contract ERC20 is ERC20Basic {
81     function allowance(address owner, address spender) public constant returns (uint256);
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83     function approve(address spender, uint256 value) public returns (bool);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface Token { 
88     function distr(address _to, uint256 _value) public returns (bool);
89     function totalSupply() constant public returns (uint256 supply);
90     function balanceOf(address _owner) constant public returns (uint256 balance);
91 }
92 
93 contract VEXG is ERC20 {
94     
95     using SafeMath for uint256;
96     address owner = msg.sender;
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100     mapping (address => bool) public blacklist;
101 
102     string public constant name = "Vexanium Gold";
103     string public constant symbol = "VEXG";
104     uint public constant decimals = 8;
105     
106     uint256 public totalSupply = 900000000000e8;
107     uint256 public totalDistributed = 90000000000e8;
108     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
109     uint256 public value;
110 
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113     
114     event Distr(address indexed to, uint256 amount);
115     event DistrFinished();
116     
117     event Burn(address indexed burner, uint256 value);
118 
119     bool public distributionFinished = false;
120     
121     modifier canDistr() {
122         require(!distributionFinished);
123         _;
124     }
125     
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130     
131     modifier onlyWhitelist() {
132         require(blacklist[msg.sender] == false);
133         _;
134     }
135     
136     function VEXG () public {
137         owner = msg.sender;
138         value = 50000e8;
139         distr(owner, totalDistributed);
140     }
141     
142     function transferOwnership(address newOwner) onlyOwner public {
143         if (newOwner != address(0)) {
144             owner = newOwner;
145         }
146     }
147     
148     function enableWhitelist(address[] addresses) onlyOwner public {
149         for (uint i = 0; i < addresses.length; i++) {
150             blacklist[addresses[i]] = false;
151         }
152     }
153 
154     function disableWhitelist(address[] addresses) onlyOwner public {
155         for (uint i = 0; i < addresses.length; i++) {
156             blacklist[addresses[i]] = true;
157         }
158     }
159 
160     function finishDistribution() onlyOwner canDistr public returns (bool) {
161         distributionFinished = true;
162         DistrFinished();
163         return true;
164     }
165     
166     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
167         totalDistributed = totalDistributed.add(_amount);
168         totalRemaining = totalRemaining.sub(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         Distr(_to, _amount);
171         Transfer(address(0), _to, _amount);
172         return true;
173         
174         if (totalDistributed >= totalSupply) {
175             distributionFinished = true;
176         }
177     }
178     
179     function airdrop(address[] addresses) onlyOwner canDistr public {
180         
181         require(addresses.length <= 255);
182         require(value <= totalRemaining);
183         
184         for (uint i = 0; i < addresses.length; i++) {
185             require(value <= totalRemaining);
186             distr(addresses[i], value);
187         }
188 	
189         if (totalDistributed >= totalSupply) {
190             distributionFinished = true;
191         }
192     }
193     
194     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
195         
196         require(addresses.length <= 255);
197         require(amount <= totalRemaining);
198         
199         for (uint i = 0; i < addresses.length; i++) {
200             require(amount <= totalRemaining);
201             distr(addresses[i], amount);
202         }
203 	
204         if (totalDistributed >= totalSupply) {
205             distributionFinished = true;
206         }
207     }
208     
209     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
210 
211         require(addresses.length <= 255);
212         require(addresses.length == amounts.length);
213         
214         for (uint8 i = 0; i < addresses.length; i++) {
215             require(amounts[i] <= totalRemaining);
216             distr(addresses[i], amounts[i]);
217             
218             if (totalDistributed >= totalSupply) {
219                 distributionFinished = true;
220             }
221         }
222     }
223     
224     function () external payable {
225             getTokens();
226      }
227     
228     function getTokens() payable canDistr onlyWhitelist public {
229         
230         if (value > totalRemaining) {
231             value = totalRemaining;
232         }
233         
234         require(value <= totalRemaining);
235         
236         address investor = msg.sender;
237         uint256 toGive = value;
238         
239         distr(investor, toGive);
240         
241         if (toGive > 0) {
242             blacklist[investor] = true;
243         }
244 
245         if (totalDistributed >= totalSupply) {
246             distributionFinished = true;
247         }
248         
249         value = value.div(100000).mul(99999);
250     }
251 
252     function balanceOf(address _owner) constant public returns (uint256) {
253 	    return balances[_owner];
254     }
255 
256     // mitigates the ERC20 short address attack
257     modifier onlyPayloadSize(uint size) {
258         assert(msg.data.length >= size + 4);
259         _;
260     }
261     
262     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
263 
264         require(_to != address(0));
265         require(_amount <= balances[msg.sender]);
266         
267         balances[msg.sender] = balances[msg.sender].sub(_amount);
268         balances[_to] = balances[_to].add(_amount);
269         Transfer(msg.sender, _to, _amount);
270         return true;
271     }
272     
273     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
274 
275         require(_to != address(0));
276         require(_amount <= balances[_from]);
277         require(_amount <= allowed[_from][msg.sender]);
278         
279         balances[_from] = balances[_from].sub(_amount);
280         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
281         balances[_to] = balances[_to].add(_amount);
282         Transfer(_from, _to, _amount);
283         return true;
284     }
285     
286     function approve(address _spender, uint256 _value) public returns (bool success) {
287         // mitigates the ERC20 spend/approval race condition
288         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
289         allowed[msg.sender][_spender] = _value;
290         Approval(msg.sender, _spender, _value);
291         return true;
292     }
293     
294     function allowance(address _owner, address _spender) constant public returns (uint256) {
295         return allowed[_owner][_spender];
296     }
297     
298     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
299         ForeignToken t = ForeignToken(tokenAddress);
300         uint bal = t.balanceOf(who);
301         return bal;
302     }
303     
304     function withdraw() onlyOwner public {
305         uint256 etherBalance = this.balance;
306         owner.transfer(etherBalance);
307     }
308     
309     function burn(uint256 _value) onlyOwner public {
310         require(_value <= balances[msg.sender]);
311         // no need to require value <= totalSupply, since that would imply the
312         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
313 
314         address burner = msg.sender;
315         balances[burner] = balances[burner].sub(_value);
316         totalSupply = totalSupply.sub(_value);
317         totalDistributed = totalDistributed.sub(_value);
318         Burn(burner, _value);
319     }
320     
321     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
322         ForeignToken token = ForeignToken(_tokenContract);
323         uint256 amount = token.balanceOf(address(this));
324         return token.transfer(owner, amount);
325     }
326 
327 
328 }