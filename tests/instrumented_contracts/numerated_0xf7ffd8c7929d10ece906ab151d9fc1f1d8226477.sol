1 /*******************************************************************************
2 
3  *
4  * @notice ZeroGold DOES NOT HOLD ANY "OFFICIAL" AFFILIATION with ZeroNet Core,
5  *         ZeroNet.io nor any of its brands and affiliates.
6  *
7  *         ZeroGold DOES currently stand as the "OFFICIAL" token of
8  *         Zeronet Explorer, Zer0net.com, 0net.io and each of their
9  *         respective brands and affiliates.
10  *
11  *         Symbol       : 0GOLD
12  *         Name         : ZeroGold
13  *         Total supply : 200,000,000,000
14  *         Decimals     : 8
15  *
16  *Donation for Listed Exchange and Verified CoinMarketCap
17  * 
18  * 1 Ether balance contract already listed Exchange
19  * 2 Ether blance contract already listed coinmarketcap and binance
20  *          
21  *          
22  */
23 
24 /*******************************************************************************/
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
50 pragma solidity ^0.4.19;
51 
52 
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a * b;
57     assert(a == 0 || c / a == b);
58     return c;
59   }
60 
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a / b;
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 contract ForeignToken {
79     function balanceOf(address _owner) constant public returns (uint256);
80     function transfer(address _to, uint256 _value) public returns (bool);
81 }
82 
83 contract ERC20Basic {
84     uint256 public totalSupply;
85     function balanceOf(address who) public constant returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 interface Token { 
98     function distr(address _to, uint256 _value) public returns (bool);
99     function totalSupply() constant public returns (uint256 supply);
100     function balanceOf(address _owner) constant public returns (uint256 balance);
101 }
102 
103 contract ZeroGold is ERC20 {
104     
105     using SafeMath for uint256;
106     address owner = msg.sender;
107 
108     mapping (address => uint256) balances;
109     mapping (address => mapping (address => uint256)) allowed;
110     mapping (address => bool) public blacklist;
111     string public constant name = "ZeroGold";
112     string public constant symbol = "0GOLD";
113     uint public constant decimals = 8;
114     
115     uint256 public totalSupply = 200000000000e8;
116     uint256 public totalDistributed = 20000000000e8;
117     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
118     uint256 public value;
119 
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122     
123     event Distr(address indexed to, uint256 amount);
124     event DistrFinished();
125     
126     event Burn(address indexed burner, uint256 value);
127 
128     bool public distributionFinished = false;
129     
130     modifier canDistr() {
131         require(!distributionFinished);
132         _;
133     }
134     
135     modifier onlyOwner() {
136         require(msg.sender == owner);
137         _;
138     }
139     
140     modifier onlyWhitelist() {
141         require(blacklist[msg.sender] == false);
142         _;
143     }
144     
145     function ZeroGold () public {
146         owner = msg.sender;
147         value = 10921e8;
148         distr(owner, totalDistributed);
149     }
150     
151     function transferOwnership(address newOwner) onlyOwner public {
152         if (newOwner != address(0)) {
153             owner = newOwner;
154         }
155     }
156     
157     function enableWhitelist(address[] addresses) onlyOwner public {
158         for (uint i = 0; i < addresses.length; i++) {
159             blacklist[addresses[i]] = false;
160         }
161     }
162 
163     function disableWhitelist(address[] addresses) onlyOwner public {
164         for (uint i = 0; i < addresses.length; i++) {
165             blacklist[addresses[i]] = true;
166         }
167     }
168 
169     function finishDistribution() onlyOwner canDistr public returns (bool) {
170         distributionFinished = true;
171         DistrFinished();
172         return true;
173     }
174     
175     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
176         totalDistributed = totalDistributed.add(_amount);
177         totalRemaining = totalRemaining.sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         Distr(_to, _amount);
180         Transfer(address(0), _to, _amount);
181         return true;
182         
183         if (totalDistributed >= totalSupply) {
184             distributionFinished = true;
185         }
186     }
187     
188     function airdrop(address[] addresses) onlyOwner canDistr public {
189         
190         require(addresses.length <= 255);
191         require(value <= totalRemaining);
192         
193         for (uint i = 0; i < addresses.length; i++) {
194             require(value <= totalRemaining);
195             distr(addresses[i], value);
196         }
197 	
198         if (totalDistributed >= totalSupply) {
199             distributionFinished = true;
200         }
201     }
202     
203     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
204         
205         require(addresses.length <= 255);
206         require(amount <= totalRemaining);
207         
208         for (uint i = 0; i < addresses.length; i++) {
209             require(amount <= totalRemaining);
210             distr(addresses[i], amount);
211         }
212 	
213         if (totalDistributed >= totalSupply) {
214             distributionFinished = true;
215         }
216     }
217     
218     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
219 
220         require(addresses.length <= 255);
221         require(addresses.length == amounts.length);
222         
223         for (uint8 i = 0; i < addresses.length; i++) {
224             require(amounts[i] <= totalRemaining);
225             distr(addresses[i], amounts[i]);
226             
227             if (totalDistributed >= totalSupply) {
228                 distributionFinished = true;
229             }
230         }
231     }
232     
233     function () external payable {
234             getTokens();
235      }
236     
237     function getTokens() payable canDistr onlyWhitelist public {
238         
239         if (value > totalRemaining) {
240             value = totalRemaining;
241         }
242         
243         require(value <= totalRemaining);
244         
245         address investor = msg.sender;
246         uint256 toGive = value;
247         
248         distr(investor, toGive);
249         
250         if (toGive > 0) {
251             blacklist[investor] = true;
252         }
253 
254         if (totalDistributed >= totalSupply) {
255             distributionFinished = true;
256         }
257         
258         value = value.div(100000).mul(99999);
259     }
260 
261     function balanceOf(address _owner) constant public returns (uint256) {
262 	    return balances[_owner];
263     }
264 
265     // mitigates the ERC20 short address attack
266     modifier onlyPayloadSize(uint size) {
267         assert(msg.data.length >= size + 4);
268         _;
269     }
270     
271     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
272 
273         require(_to != address(0));
274         require(_amount <= balances[msg.sender]);
275         
276         balances[msg.sender] = balances[msg.sender].sub(_amount);
277         balances[_to] = balances[_to].add(_amount);
278         Transfer(msg.sender, _to, _amount);
279         return true;
280     }
281     
282     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
283 
284         require(_to != address(0));
285         require(_amount <= balances[_from]);
286         require(_amount <= allowed[_from][msg.sender]);
287         
288         balances[_from] = balances[_from].sub(_amount);
289         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
290         balances[_to] = balances[_to].add(_amount);
291         Transfer(_from, _to, _amount);
292         return true;
293     }
294     
295     function approve(address _spender, uint256 _value) public returns (bool success) {
296         // mitigates the ERC20 spend/approval race condition
297         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
298         allowed[msg.sender][_spender] = _value;
299         Approval(msg.sender, _spender, _value);
300         return true;
301     }
302     
303     function allowance(address _owner, address _spender) constant public returns (uint256) {
304         return allowed[_owner][_spender];
305     }
306     
307     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
308         ForeignToken t = ForeignToken(tokenAddress);
309         uint bal = t.balanceOf(who);
310         return bal;
311     }
312     
313     function withdraw() onlyOwner public {
314         uint256 etherBalance = this.balance;
315         owner.transfer(etherBalance);
316     }
317     
318     function burn(uint256 _value) onlyOwner public {
319         require(_value <= balances[msg.sender]);
320         // no need to require value <= totalSupply, since that would imply the
321         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
322 
323         address burner = msg.sender;
324         balances[burner] = balances[burner].sub(_value);
325         totalSupply = totalSupply.sub(_value);
326         totalDistributed = totalDistributed.sub(_value);
327         Burn(burner, _value);
328     }
329     
330     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
331         ForeignToken token = ForeignToken(_tokenContract);
332         uint256 amount = token.balanceOf(address(this));
333         return token.transfer(owner, amount);
334     }
335 
336 
337 }