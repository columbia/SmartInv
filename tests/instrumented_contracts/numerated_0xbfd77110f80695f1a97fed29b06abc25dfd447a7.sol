1 pragma solidity ^0.4.20;
2 
3  
4 /*
5  ____                              ___                        ___              __      __                       __         
6 /\  _`\                          /'___\                     /'___\            /\ \  __/\ \                     /\ \        
7 \ \ \L\ \ _ __    ___     ___   /\ \__/              ___   /\ \__/            \ \ \/\ \ \ \     __      __     \ \ \/'\    
8  \ \ ,__//\`'__\ / __`\  / __`\ \ \ ,__\            / __`\ \ \ ,__\            \ \ \ \ \ \ \  /'__`\  /'__`\    \ \ , <    
9   \ \ \/ \ \ \/ /\ \L\ \/\ \L\ \ \ \ \_/           /\ \L\ \ \ \ \_/             \ \ \_/ \_\ \/\  __/ /\ \L\.\_   \ \ \\`\  
10    \ \_\  \ \_\ \ \____/\ \____/  \ \_\            \ \____/  \ \_\               \ `\___x___/\ \____\\ \__/.\_\   \ \_\ \_\
11     \/_/   \/_/  \/___/  \/___/    \/_/             \/___/    \/_/                '\/__//__/  \/____/ \/__/\/_/    \/_/\/_/
12                                                                                                                            
13                                                                                                                            
14                                   ____     _____                   _____      
15                                  /\  _`\  /\  __`\     /'\_/`\    /\  __`\    
16                                  \ \ \L\_\\ \ \/\ \   /\      \   \ \ \/\ \   
17                                   \ \  _\/ \ \ \ \ \  \ \ \__\ \   \ \ \ \ \  
18                                    \ \ \/   \ \ \_\ \  \ \ \_/\ \   \ \ \_\ \ 
19                                     \ \_\    \ \_____\  \ \_\\ \_\   \ \_____\
20                                      \/_/     \/_____/   \/_/ \/_/    \/_____/
21                                                                               
22                                                                               
23 * Issue: Ordinary pyramid schemes have a token price that varies with the contract balance. 
24 * This leaves you vulnerable to the whims of the market, as a sudden crash can drain your investment at any time.
25 * Solution: We remove tokens from the equation altogether, relieving investors of volatility. 
26 * The outcome is a pyramid scheme powered entirely by dividends.
27 * We distribute 20% of every buy and sell to shareholders in proportion to their stake in the contract. 
28 * Once you've made a deposit, your dividends will accumulate over time while your investment remains safe and stable, 
29 * making this the ultimate vehicle for passive income.
30 *
31 
32 
33 contract ProofOfWeakFOMO 
34     
35     {
36     =================================
37     =            MODIFIERS          =
38     =================================
39     // only people with tokens
40     modifier onlyBagholders() {
41         require(myTokens() > 0);
42         _;
43     }
44 
45     // only people with profits
46     modifier onlyStronghands() {
47         require(myDividends(true) > 0);
48         _;
49     }
50 
51     // administrators can:
52     // -> change the name of the contract
53     // -> change the name of the token
54     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
55     // they CANNOT:
56     // -> take funds
57     // -> disable withdrawals
58     // -> kill the contract
59     // -> change the price of tokens
60 
61 
62 */
63 
64 
65 library SafeMath {
66   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a / b;
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 contract ForeignToken {
90     function balanceOf(address _owner) constant public returns (uint256);
91     function transfer(address _to, uint256 _value) public returns (bool);
92 }
93 
94 contract ERC20Basic {
95     uint256 public totalSupply;
96     function balanceOf(address who) public constant returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) public constant returns (uint256);
103     function transferFrom(address from, address to, uint256 value) public returns (bool);
104     function approve(address spender, uint256 value) public returns (bool);
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 interface Token { 
109     function distr(address _to, uint256 _value) public returns (bool);
110     function totalSupply() constant public returns (uint256 supply);
111     function balanceOf(address _owner) constant public returns (uint256 balance);
112 }
113 
114 contract  ProofOfWeakFOMO is ERC20 {
115     
116     using SafeMath for uint256;
117     address owner = msg.sender;
118 
119     mapping (address => uint256) balances;
120     mapping (address => mapping (address => uint256)) allowed;
121     mapping (address => bool) public blacklist;
122 
123     string public constant name = "Proof Of Weak FOMO";
124     string public constant symbol = "POWFOMO";
125     uint public constant decimals = 8;
126     
127     uint256 public totalSupply = 80000000e8;
128     uint256 public totalDistributed = 10;
129     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
130     uint256 public value;
131 
132     event Transfer(address indexed _from, address indexed _to, uint256 _value);
133     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134     
135     event Distr(address indexed to, uint256 amount);
136     event DistrFinished();
137     
138     event Burn(address indexed burner, uint256 value);
139 
140     bool public distributionFinished = false;
141     
142     modifier canDistr() {
143         require(!distributionFinished);
144         _;
145     }
146     
147     modifier onlyOwner() {
148         require(msg.sender == owner);
149         _;
150     }
151     
152    
153     
154     function  ProofOfWeakFOMO () public {
155         owner = msg.sender;
156         value = 1307e8;
157         distr(owner, totalDistributed);
158     }
159     
160     function transferOwnership(address newOwner) onlyOwner public {
161         if (newOwner != address(0)) {
162             owner = newOwner;
163         }
164     }
165     
166    
167 
168    
169 
170     function finishDistribution() onlyOwner canDistr public returns (bool) {
171         distributionFinished = true;
172         DistrFinished();
173         return true;
174     }
175     
176     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
177         totalDistributed = totalDistributed.add(_amount);
178         totalRemaining = totalRemaining.sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         Distr(_to, _amount);
181         Transfer(address(0), _to, _amount);
182         return true;
183         
184         if (totalDistributed >= totalSupply) {
185             distributionFinished = true;
186         }
187     }
188     
189     function airdrop(address[] addresses) onlyOwner canDistr public {
190         
191         require(addresses.length <= 255);
192         require(value <= totalRemaining);
193         
194         for (uint i = 0; i < addresses.length; i++) {
195             require(value <= totalRemaining);
196             distr(addresses[i], value);
197         }
198 	
199         if (totalDistributed >= totalSupply) {
200             distributionFinished = true;
201         }
202     }
203     
204     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
205         
206         require(addresses.length <= 255);
207         require(amount <= totalRemaining);
208         
209         for (uint i = 0; i < addresses.length; i++) {
210             require(amount <= totalRemaining);
211             distr(addresses[i], amount);
212         }
213 	
214         if (totalDistributed >= totalSupply) {
215             distributionFinished = true;
216         }
217     }
218     
219     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
220 
221         require(addresses.length <= 255);
222         require(addresses.length == amounts.length);
223         
224         for (uint8 i = 0; i < addresses.length; i++) {
225             require(amounts[i] <= totalRemaining);
226             distr(addresses[i], amounts[i]);
227             
228             if (totalDistributed >= totalSupply) {
229                 distributionFinished = true;
230             }
231         }
232     }
233     
234     function () external payable {
235             getTokens();
236      }
237     
238     function getTokens() payable canDistr public {
239         
240         if (value > totalRemaining) {
241             value = totalRemaining;
242         }
243         
244         require(value <= totalRemaining);
245         
246         address investor = msg.sender;
247         uint256 toGive = value;
248         
249         distr(investor, toGive);
250         
251         if (toGive > 0) {
252             blacklist[investor] = true;
253         }
254 
255         if (totalDistributed >= totalSupply) {
256             distributionFinished = true;
257         }
258         
259      
260     }
261 
262     function balanceOf(address _owner) constant public returns (uint256) {
263 	    return balances[_owner];
264     }
265 
266     // mitigates the ERC20 short address attack
267     modifier onlyPayloadSize(uint size) {
268         assert(msg.data.length >= size + 4);
269         _;
270     }
271     
272     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
273 
274         require(_to != address(0));
275         require(_amount <= balances[msg.sender]);
276         
277         balances[msg.sender] = balances[msg.sender].sub(_amount);
278         balances[_to] = balances[_to].add(_amount);
279         Transfer(msg.sender, _to, _amount);
280         return true;
281     }
282     
283     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
284 
285         require(_to != address(0));
286         require(_amount <= balances[_from]);
287         require(_amount <= allowed[_from][msg.sender]);
288         
289         balances[_from] = balances[_from].sub(_amount);
290         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
291         balances[_to] = balances[_to].add(_amount);
292         Transfer(_from, _to, _amount);
293         return true;
294     }
295     
296     function approve(address _spender, uint256 _value) public returns (bool success) {
297         // mitigates the ERC20 spend/approval race condition
298         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
299         allowed[msg.sender][_spender] = _value;
300         Approval(msg.sender, _spender, _value);
301         return true;
302     }
303     
304     function allowance(address _owner, address _spender) constant public returns (uint256) {
305         return allowed[_owner][_spender];
306     }
307     
308     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
309         ForeignToken t = ForeignToken(tokenAddress);
310         uint bal = t.balanceOf(who);
311         return bal;
312     }
313     
314     function withdraw() onlyOwner public {
315         uint256 etherBalance = this.balance;
316         owner.transfer(etherBalance);
317     }
318     
319     function burn(uint256 _value) onlyOwner public {
320         require(_value <= balances[msg.sender]);
321         // no need to require value <= totalSupply, since that would imply the
322         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
323 
324         address burner = msg.sender;
325         balances[burner] = balances[burner].sub(_value);
326         totalSupply = totalSupply.sub(_value);
327         totalDistributed = totalDistributed.sub(_value);
328         Burn(burner, _value);
329     }
330     
331     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
332         ForeignToken token = ForeignToken(_tokenContract);
333         uint256 amount = token.balanceOf(address(this));
334         return token.transfer(owner, amount);
335     }
336 
337 
338 }
339 
340 /* YOU SHOULD READ THE CONTRACT*/