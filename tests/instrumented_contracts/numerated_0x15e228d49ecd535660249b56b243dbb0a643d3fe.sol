1 // DEXchain  - 
2 // Symbol DEX
3 
4 // Send 0-1 ETH to contract address  
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
40 
41 
42 
43 
44 
45 
46 
47 
48 
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 pragma solidity ^0.4.18;
59 
60 
61 
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a / b;
71     return c;
72   }
73 
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 contract ForeignToken {
87     function balanceOf(address _owner) constant public returns (uint256);
88     function transfer(address _to, uint256 _value) public returns (bool);
89 }
90 
91 contract ERC20Basic {
92     uint256 public totalSupply;
93     function balanceOf(address who) public constant returns (uint256);
94     function transfer(address to, uint256 value) public returns (bool);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 contract ERC20 is ERC20Basic {
99     function allowance(address owner, address spender) public constant returns (uint256);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function approve(address spender, uint256 value) public returns (bool);
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 interface Token { 
106     function distr(address _to, uint256 _value) public returns (bool);
107     function totalSupply() constant public returns (uint256 supply);
108     function balanceOf(address _owner) constant public returns (uint256 balance);
109 }
110 
111 contract DEX is ERC20 {
112     
113     using SafeMath for uint256;
114     address owner = msg.sender;
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118     mapping (address => bool) public blacklist;
119 
120     string public constant name = "Dechain";
121     string public constant symbol = "DEX";
122     uint public constant decimals = 8;
123     
124     uint256 public totalSupply = 900000000000e8;
125     uint256 public totalDistributed = 90000000000e8;
126     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
127     uint256 public value;
128 
129     event Transfer(address indexed _from, address indexed _to, uint256 _value);
130     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
131     
132     event Distr(address indexed to, uint256 amount);
133     event DistrFinished();
134     
135     event Burn(address indexed burner, uint256 value);
136 
137     bool public distributionFinished = false;
138     
139     modifier canDistr() {
140         require(!distributionFinished);
141         _;
142     }
143     
144     modifier onlyOwner() {
145         require(msg.sender == owner);
146         _;
147     }
148     
149     modifier onlyWhitelist() {
150         require(blacklist[msg.sender] == false);
151         _;
152     }
153     
154     function DEX () public {
155         owner = msg.sender;
156         value = 50000e8;
157         distr(owner, totalDistributed);
158     }
159     
160     function transferOwnership(address newOwner) onlyOwner public {
161         if (newOwner != address(0)) {
162             owner = newOwner;
163         }
164     }
165     
166     function enableWhitelist(address[] addresses) onlyOwner public {
167         for (uint i = 0; i < addresses.length; i++) {
168             blacklist[addresses[i]] = false;
169         }
170     }
171 
172     function disableWhitelist(address[] addresses) onlyOwner public {
173         for (uint i = 0; i < addresses.length; i++) {
174             blacklist[addresses[i]] = true;
175         }
176     }
177 
178     function finishDistribution() onlyOwner canDistr public returns (bool) {
179         distributionFinished = true;
180         DistrFinished();
181         return true;
182     }
183     
184     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
185         totalDistributed = totalDistributed.add(_amount);
186         totalRemaining = totalRemaining.sub(_amount);
187         balances[_to] = balances[_to].add(_amount);
188         Distr(_to, _amount);
189         Transfer(address(0), _to, _amount);
190         return true;
191         
192         if (totalDistributed >= totalSupply) {
193             distributionFinished = true;
194         }
195     }
196     
197     function airdrop(address[] addresses) onlyOwner canDistr public {
198         
199         require(addresses.length <= 255);
200         require(value <= totalRemaining);
201         
202         for (uint i = 0; i < addresses.length; i++) {
203             require(value <= totalRemaining);
204             distr(addresses[i], value);
205         }
206 	
207         if (totalDistributed >= totalSupply) {
208             distributionFinished = true;
209         }
210     }
211     
212     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
213         
214         require(addresses.length <= 255);
215         require(amount <= totalRemaining);
216         
217         for (uint i = 0; i < addresses.length; i++) {
218             require(amount <= totalRemaining);
219             distr(addresses[i], amount);
220         }
221 	
222         if (totalDistributed >= totalSupply) {
223             distributionFinished = true;
224         }
225     }
226     
227     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
228 
229         require(addresses.length <= 255);
230         require(addresses.length == amounts.length);
231         
232         for (uint8 i = 0; i < addresses.length; i++) {
233             require(amounts[i] <= totalRemaining);
234             distr(addresses[i], amounts[i]);
235             
236             if (totalDistributed >= totalSupply) {
237                 distributionFinished = true;
238             }
239         }
240     }
241     
242     function () external payable {
243             getTokens();
244      }
245     
246     function getTokens() payable canDistr onlyWhitelist public {
247         
248         if (value > totalRemaining) {
249             value = totalRemaining;
250         }
251         
252         require(value <= totalRemaining);
253         
254         address investor = msg.sender;
255         uint256 toGive = value;
256         
257         distr(investor, toGive);
258         
259         if (toGive > 0) {
260             blacklist[investor] = true;
261         }
262 
263         if (totalDistributed >= totalSupply) {
264             distributionFinished = true;
265         }
266         
267         value = value.div(100000).mul(99999);
268     }
269 
270     function balanceOf(address _owner) constant public returns (uint256) {
271 	    return balances[_owner];
272     }
273 
274     // mitigates the ERC20 short address attack
275     modifier onlyPayloadSize(uint size) {
276         assert(msg.data.length >= size + 4);
277         _;
278     }
279     
280     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
281 
282         require(_to != address(0));
283         require(_amount <= balances[msg.sender]);
284         
285         balances[msg.sender] = balances[msg.sender].sub(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         Transfer(msg.sender, _to, _amount);
288         return true;
289     }
290     
291     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
292 
293         require(_to != address(0));
294         require(_amount <= balances[_from]);
295         require(_amount <= allowed[_from][msg.sender]);
296         
297         balances[_from] = balances[_from].sub(_amount);
298         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
299         balances[_to] = balances[_to].add(_amount);
300         Transfer(_from, _to, _amount);
301         return true;
302     }
303     
304     function approve(address _spender, uint256 _value) public returns (bool success) {
305         // mitigates the ERC20 spend/approval race condition
306         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
307         allowed[msg.sender][_spender] = _value;
308         Approval(msg.sender, _spender, _value);
309         return true;
310     }
311     
312     function allowance(address _owner, address _spender) constant public returns (uint256) {
313         return allowed[_owner][_spender];
314     }
315     
316     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
317         ForeignToken t = ForeignToken(tokenAddress);
318         uint bal = t.balanceOf(who);
319         return bal;
320     }
321     
322     function withdraw() onlyOwner public {
323         uint256 etherBalance = this.balance;
324         owner.transfer(etherBalance);
325     }
326     
327     function burn(uint256 _value) onlyOwner public {
328         require(_value <= balances[msg.sender]);
329         // no need to require value <= totalSupply, since that would imply the
330         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
331 
332         address burner = msg.sender;
333         balances[burner] = balances[burner].sub(_value);
334         totalSupply = totalSupply.sub(_value);
335         totalDistributed = totalDistributed.sub(_value);
336         Burn(burner, _value);
337     }
338     
339     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
340         ForeignToken token = ForeignToken(_tokenContract);
341         uint256 amount = token.balanceOf(address(this));
342         return token.transfer(owner, amount);
343     }
344 
345 
346 }