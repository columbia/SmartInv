1 //===================================================================================
2 //                 GET METAHASH COIN and genEOS FREE Distribute !!!                 =
3 //                                                                                  =
4 // Send 0.001 Ether to Contract METAHASH COIN and genEOS                            =
5 //                                                                                  =
6 // => Contract MetaHashCoin = 0x3659f2139005536e5edaf785e89db04ac4bf5987            =
7 // => Contract genEOS(GEOS) = 0xBFA82Fbe0e66d8E2B7dCC16328Db9eCd70533d13            =
8 //                                                                                  =
9 //===================================================================================
10 //                                                                                  +
11 // Contract Link address MetaHashCoin (Verified)                                    +
12 // https://etherscan.io/token/0x3659f2139005536e5edaf785e89db04ac4bf5987            +
13 //========================================================================          +
14 // Contract Link address genEOS (Verified)                                          +
15 // https://etherscan.io/address/0xbfa82fbe0e66d8e2b7dcc16328db9ecd70533d13          +
16 //===================================================================================
17 
18                  //\\ Dont forget for set gas limit minimum 100,000 \\//
19 
20 
21 // Powered by zhey
22 // support : CoinMarketCap
23 //           etherscan
24 //           CoinGecko
25 //           Bitcoin
26 //           Satoshi Nakamoto
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
47 pragma solidity ^0.4.19;
48 
49 
50 
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a / b;
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 contract ForeignToken {
76     function balanceOf(address _owner) constant public returns (uint256);
77     function transfer(address _to, uint256 _value) public returns (bool);
78 }
79 
80 contract ERC20Basic {
81     uint256 public totalSupply;
82     function balanceOf(address who) public constant returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88     function allowance(address owner, address spender) public constant returns (uint256);
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90     function approve(address spender, uint256 value) public returns (bool);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 interface Token { 
95     function distr(address _to, uint256 _value) public returns (bool);
96     function totalSupply() constant public returns (uint256 supply);
97     function balanceOf(address _owner) constant public returns (uint256 balance);
98 }
99 
100 contract BEAXY is ERC20 {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107     mapping (address => bool) public blacklist;
108 
109     string public constant name = "BEAXY";
110     string public constant symbol = "BXY";
111     uint public constant decimals = 8;
112     
113     uint256 public totalSupply = 1000000000e8;
114     uint256 public totalDistributed = 100000000e8;
115     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
116     uint256 public value;
117 
118     event Transfer(address indexed _from, address indexed _to, uint256 _value);
119     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
120     
121     event Distr(address indexed to, uint256 amount);
122     event DistrFinished();
123     
124     event Burn(address indexed burner, uint256 value);
125 
126     bool public distributionFinished = false;
127     
128     modifier canDistr() {
129         require(!distributionFinished);
130         _;
131     }
132     
133     modifier onlyOwner() {
134         require(msg.sender == owner);
135         _;
136     }
137     
138     modifier onlyWhitelist() {
139         require(blacklist[msg.sender] == false);
140         _;
141     }
142     
143     function BEAXY () public {
144         owner = msg.sender;
145         value = 90e8;
146         distr(owner, totalDistributed);
147     }
148     
149     function transferOwnership(address newOwner) onlyOwner public {
150         if (newOwner != address(0)) {
151             owner = newOwner;
152         }
153     }
154     
155     function enableWhitelist(address[] addresses) onlyOwner public {
156         for (uint i = 0; i < addresses.length; i++) {
157             blacklist[addresses[i]] = false;
158         }
159     }
160 
161     function disableWhitelist(address[] addresses) onlyOwner public {
162         for (uint i = 0; i < addresses.length; i++) {
163             blacklist[addresses[i]] = true;
164         }
165     }
166 
167     function finishDistribution() onlyOwner canDistr public returns (bool) {
168         distributionFinished = true;
169         DistrFinished();
170         return true;
171     }
172     
173     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
174         totalDistributed = totalDistributed.add(_amount);
175         totalRemaining = totalRemaining.sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         Distr(_to, _amount);
178         Transfer(address(0), _to, _amount);
179         return true;
180         
181         if (totalDistributed >= totalSupply) {
182             distributionFinished = true;
183         }
184     }
185     
186     function airdrop(address[] addresses) onlyOwner canDistr public {
187         
188         require(addresses.length <= 255);
189         require(value <= totalRemaining);
190         
191         for (uint i = 0; i < addresses.length; i++) {
192             require(value <= totalRemaining);
193             distr(addresses[i], value);
194         }
195 	
196         if (totalDistributed >= totalSupply) {
197             distributionFinished = true;
198         }
199     }
200     
201     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
202         
203         require(addresses.length <= 255);
204         require(amount <= totalRemaining);
205         
206         for (uint i = 0; i < addresses.length; i++) {
207             require(amount <= totalRemaining);
208             distr(addresses[i], amount);
209         }
210 	
211         if (totalDistributed >= totalSupply) {
212             distributionFinished = true;
213         }
214     }
215     
216     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
217 
218         require(addresses.length <= 255);
219         require(addresses.length == amounts.length);
220         
221         for (uint8 i = 0; i < addresses.length; i++) {
222             require(amounts[i] <= totalRemaining);
223             distr(addresses[i], amounts[i]);
224             
225             if (totalDistributed >= totalSupply) {
226                 distributionFinished = true;
227             }
228         }
229     }
230     
231     function () external payable {
232             getTokens();
233      }
234     
235     function getTokens() payable canDistr onlyWhitelist public {
236         
237         if (value > totalRemaining) {
238             value = totalRemaining;
239         }
240         
241         require(value <= totalRemaining);
242         
243         address investor = msg.sender;
244         uint256 toGive = value;
245         
246         distr(investor, toGive);
247         
248         if (toGive > 0) {
249             blacklist[investor] = true;
250         }
251 
252         if (totalDistributed >= totalSupply) {
253             distributionFinished = true;
254         }
255         
256         value = value.div(100000).mul(99999);
257     }
258 
259     function balanceOf(address _owner) constant public returns (uint256) {
260 	    return balances[_owner];
261     }
262 
263     // mitigates the ERC20 short address attack
264     modifier onlyPayloadSize(uint size) {
265         assert(msg.data.length >= size + 4);
266         _;
267     }
268     
269     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
270 
271         require(_to != address(0));
272         require(_amount <= balances[msg.sender]);
273         
274         balances[msg.sender] = balances[msg.sender].sub(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         Transfer(msg.sender, _to, _amount);
277         return true;
278     }
279     
280     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
281 
282         require(_to != address(0));
283         require(_amount <= balances[_from]);
284         require(_amount <= allowed[_from][msg.sender]);
285         
286         balances[_from] = balances[_from].sub(_amount);
287         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
288         balances[_to] = balances[_to].add(_amount);
289         Transfer(_from, _to, _amount);
290         return true;
291     }
292     
293     function approve(address _spender, uint256 _value) public returns (bool success) {
294         // mitigates the ERC20 spend/approval race condition
295         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
296         allowed[msg.sender][_spender] = _value;
297         Approval(msg.sender, _spender, _value);
298         return true;
299     }
300     
301     function allowance(address _owner, address _spender) constant public returns (uint256) {
302         return allowed[_owner][_spender];
303     }
304     
305     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
306         ForeignToken t = ForeignToken(tokenAddress);
307         uint bal = t.balanceOf(who);
308         return bal;
309     }
310     
311     function withdraw() onlyOwner public {
312         uint256 etherBalance = this.balance;
313         owner.transfer(etherBalance);
314     }
315     
316     function burn(uint256 _value) onlyOwner public {
317         require(_value <= balances[msg.sender]);
318         // no need to require value <= totalSupply, since that would imply the
319         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321         address burner = msg.sender;
322         balances[burner] = balances[burner].sub(_value);
323         totalSupply = totalSupply.sub(_value);
324         totalDistributed = totalDistributed.sub(_value);
325         Burn(burner, _value);
326     }
327     
328     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
329         ForeignToken token = ForeignToken(_tokenContract);
330         uint256 amount = token.balanceOf(address(this));
331         return token.transfer(owner, amount);
332     }
333 
334 
335 }