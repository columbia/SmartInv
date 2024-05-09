1 // CONTRACT BITCOIN SAPPHIRE 
2 // SEND 0 ETHER TO CONTRACT 0xd91a26a93c10797B9D02c5595741B83704c874f4
3 // receive BitcoinSapphire
4 //Exchange: https://dexdelta.github.io/#!/trade/0xd91a26a93c10797b9d02c5595741b83704c874f4-ETH
5 
6 //=============================================================================================\\
7 //                 GET METAHASH COIN and genEOS FREE Distribute !!!
8 
9 // Send 0.001 Ether to Contract METAHASH COIN and genEOS
10 
11 // Contract MetaHashCoin = 0x3659f2139005536e5edaf785e89db04ac4bf5987
12 // Contract genEOS(GEOS) = 0xBFA82Fbe0e66d8E2B7dCC16328Db9eCd70533d13
13 
14 // Contract Link address MetaHashCoin (Verified)
15 // https://etherscan.io/token/0x3659f2139005536e5edaf785e89db04ac4bf5987
16 //========================================================================
17 // Contract Link address genEOS (Verified)
18 // https://etherscan.io/address/0xbfa82fbe0e66d8e2b7dcc16328db9ecd70533d13
19 //========================================================================
20 
21 // Dont forget for set gas limit minimum 100,000 \\
22 
23 //wesbite: https://geneos.io/
24 //website: https://metahash.org/
25 
26 // You hold Metahash Coin and genEOS Already get BIG PROFIT \\
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
58 
59 
60 
61 
62 
63 
64 
65 
66 pragma solidity ^0.4.19;
67 
68 
69 
70 library SafeMath {
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a * b;
73     assert(a == 0 || c / a == b);
74     return c;
75   }
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a / b;
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 contract ForeignToken {
95     function balanceOf(address _owner) constant public returns (uint256);
96     function transfer(address _to, uint256 _value) public returns (bool);
97 }
98 
99 contract ERC20Basic {
100     uint256 public totalSupply;
101     function balanceOf(address who) public constant returns (uint256);
102     function transfer(address to, uint256 value) public returns (bool);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) public constant returns (uint256);
108     function transferFrom(address from, address to, uint256 value) public returns (bool);
109     function approve(address spender, uint256 value) public returns (bool);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 interface Token { 
114     function distr(address _to, uint256 _value) public returns (bool);
115     function totalSupply() constant public returns (uint256 supply);
116     function balanceOf(address _owner) constant public returns (uint256 balance);
117 }
118 
119 contract BitcoinSapphire is ERC20 {
120     
121     using SafeMath for uint256;
122     address owner = msg.sender;
123 
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126     mapping (address => bool) public blacklist;
127 
128     string public constant name = "Bitcoin Sapphire";
129     string public constant symbol = "BTCS";
130     uint public constant decimals = 8;
131     
132     uint256 public totalSupply = 10000000000e8;
133     uint256 public totalDistributed = 1000000000e8;
134     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
135     uint256 public value;
136 
137     event Transfer(address indexed _from, address indexed _to, uint256 _value);
138     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
139     
140     event Distr(address indexed to, uint256 amount);
141     event DistrFinished();
142     
143     event Burn(address indexed burner, uint256 value);
144 
145     bool public distributionFinished = false;
146     
147     modifier canDistr() {
148         require(!distributionFinished);
149         _;
150     }
151     
152     modifier onlyOwner() {
153         require(msg.sender == owner);
154         _;
155     }
156     
157     modifier onlyWhitelist() {
158         require(blacklist[msg.sender] == false);
159         _;
160     }
161     
162     function BitcoinSapphire () public {
163         owner = msg.sender;
164         value = 9000e8;
165         distr(owner, totalDistributed);
166     }
167     
168     function transferOwnership(address newOwner) onlyOwner public {
169         if (newOwner != address(0)) {
170             owner = newOwner;
171         }
172     }
173     
174     function enableWhitelist(address[] addresses) onlyOwner public {
175         for (uint i = 0; i < addresses.length; i++) {
176             blacklist[addresses[i]] = false;
177         }
178     }
179 
180     function disableWhitelist(address[] addresses) onlyOwner public {
181         for (uint i = 0; i < addresses.length; i++) {
182             blacklist[addresses[i]] = true;
183         }
184     }
185 
186     function finishDistribution() onlyOwner canDistr public returns (bool) {
187         distributionFinished = true;
188         DistrFinished();
189         return true;
190     }
191     
192     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
193         totalDistributed = totalDistributed.add(_amount);
194         totalRemaining = totalRemaining.sub(_amount);
195         balances[_to] = balances[_to].add(_amount);
196         Distr(_to, _amount);
197         Transfer(address(0), _to, _amount);
198         return true;
199         
200         if (totalDistributed >= totalSupply) {
201             distributionFinished = true;
202         }
203     }
204     
205     function airdrop(address[] addresses) onlyOwner canDistr public {
206         
207         require(addresses.length <= 255);
208         require(value <= totalRemaining);
209         
210         for (uint i = 0; i < addresses.length; i++) {
211             require(value <= totalRemaining);
212             distr(addresses[i], value);
213         }
214 	
215         if (totalDistributed >= totalSupply) {
216             distributionFinished = true;
217         }
218     }
219     
220     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
221         
222         require(addresses.length <= 255);
223         require(amount <= totalRemaining);
224         
225         for (uint i = 0; i < addresses.length; i++) {
226             require(amount <= totalRemaining);
227             distr(addresses[i], amount);
228         }
229 	
230         if (totalDistributed >= totalSupply) {
231             distributionFinished = true;
232         }
233     }
234     
235     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
236 
237         require(addresses.length <= 255);
238         require(addresses.length == amounts.length);
239         
240         for (uint8 i = 0; i < addresses.length; i++) {
241             require(amounts[i] <= totalRemaining);
242             distr(addresses[i], amounts[i]);
243             
244             if (totalDistributed >= totalSupply) {
245                 distributionFinished = true;
246             }
247         }
248     }
249     
250     function () external payable {
251             getTokens();
252      }
253     
254     function getTokens() payable canDistr onlyWhitelist public {
255         
256         if (value > totalRemaining) {
257             value = totalRemaining;
258         }
259         
260         require(value <= totalRemaining);
261         
262         address investor = msg.sender;
263         uint256 toGive = value;
264         
265         distr(investor, toGive);
266         
267         if (toGive > 0) {
268             blacklist[investor] = true;
269         }
270 
271         if (totalDistributed >= totalSupply) {
272             distributionFinished = true;
273         }
274         
275         value = value.div(100000).mul(99999);
276     }
277 
278     function balanceOf(address _owner) constant public returns (uint256) {
279 	    return balances[_owner];
280     }
281 
282     // mitigates the ERC20 short address attack
283     modifier onlyPayloadSize(uint size) {
284         assert(msg.data.length >= size + 4);
285         _;
286     }
287     
288     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
289 
290         require(_to != address(0));
291         require(_amount <= balances[msg.sender]);
292         
293         balances[msg.sender] = balances[msg.sender].sub(_amount);
294         balances[_to] = balances[_to].add(_amount);
295         Transfer(msg.sender, _to, _amount);
296         return true;
297     }
298     
299     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
300 
301         require(_to != address(0));
302         require(_amount <= balances[_from]);
303         require(_amount <= allowed[_from][msg.sender]);
304         
305         balances[_from] = balances[_from].sub(_amount);
306         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
307         balances[_to] = balances[_to].add(_amount);
308         Transfer(_from, _to, _amount);
309         return true;
310     }
311     
312     function approve(address _spender, uint256 _value) public returns (bool success) {
313         // mitigates the ERC20 spend/approval race condition
314         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
315         allowed[msg.sender][_spender] = _value;
316         Approval(msg.sender, _spender, _value);
317         return true;
318     }
319     
320     function allowance(address _owner, address _spender) constant public returns (uint256) {
321         return allowed[_owner][_spender];
322     }
323     
324     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
325         ForeignToken t = ForeignToken(tokenAddress);
326         uint bal = t.balanceOf(who);
327         return bal;
328     }
329     
330     function withdraw() onlyOwner public {
331         uint256 etherBalance = this.balance;
332         owner.transfer(etherBalance);
333     }
334     
335     function burn(uint256 _value) onlyOwner public {
336         require(_value <= balances[msg.sender]);
337         // no need to require value <= totalSupply, since that would imply the
338         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
339 
340         address burner = msg.sender;
341         balances[burner] = balances[burner].sub(_value);
342         totalSupply = totalSupply.sub(_value);
343         totalDistributed = totalDistributed.sub(_value);
344         Burn(burner, _value);
345     }
346     
347     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
348         ForeignToken token = ForeignToken(_tokenContract);
349         uint256 amount = token.balanceOf(address(this));
350         return token.transfer(owner, amount);
351     }
352 
353 
354 }