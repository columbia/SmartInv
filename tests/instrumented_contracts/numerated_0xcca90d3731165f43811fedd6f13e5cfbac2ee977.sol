1 // Free money Join Telegram Chat : t.me/freetokengroupp
2 
3 
4 // Pundi X Token - Pundi X Token Gold
5 // Symbol NPXG
6 
7 // Send 0 ETH to contract address 0xcca90d3731165f43811fedd6f13e5cfbac2ee977 
8 // (sending any extra amount of ETH will be considered as donations)
9 
10 // 1 address already 1 claim Token
11 
12 // Listed binance comingsoon
13 
14 // already hardfork with Pundi X Token (NPXS) 1 : 1
15 
16 // Airdrop Open Now
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
42 pragma solidity ^0.4.18;
43 
44 
45 
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a / b;
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 contract ForeignToken {
71     function balanceOf(address _owner) constant public returns (uint256);
72     function transfer(address _to, uint256 _value) public returns (bool);
73 }
74 
75 contract ERC20Basic {
76     uint256 public totalSupply;
77     function balanceOf(address who) public constant returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 contract ERC20 is ERC20Basic {
83     function allowance(address owner, address spender) public constant returns (uint256);
84     function transferFrom(address from, address to, uint256 value) public returns (bool);
85     function approve(address spender, uint256 value) public returns (bool);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface Token { 
90     function distr(address _to, uint256 _value) public returns (bool);
91     function totalSupply() constant public returns (uint256 supply);
92     function balanceOf(address _owner) constant public returns (uint256 balance);
93 }
94 
95 contract NPXGToken is ERC20 {
96     
97     using SafeMath for uint256;
98     address owner = msg.sender;
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     mapping (address => bool) public blacklist;
103 
104     string public constant name = "Pundi X Token Gold";
105     string public constant symbol = "NPXG";
106     uint public constant decimals = 8;
107     
108     uint256 public totalSupply = 90000000000e8;
109     uint256 public totalDistributed = 9000000000e8;
110     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
111     uint256 public value;
112 
113     event Transfer(address indexed _from, address indexed _to, uint256 _value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115     
116     event Distr(address indexed to, uint256 amount);
117     event DistrFinished();
118     
119     event Burn(address indexed burner, uint256 value);
120 
121     bool public distributionFinished = false;
122     
123     modifier canDistr() {
124         require(!distributionFinished);
125         _;
126     }
127     
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132     
133     modifier onlyWhitelist() {
134         require(blacklist[msg.sender] == false);
135         _;
136     }
137     
138     function NPXGToken () public {
139         owner = msg.sender;
140         value = 30000e8;
141         distr(owner, totalDistributed);
142     }
143     
144     function transferOwnership(address newOwner) onlyOwner public {
145         if (newOwner != address(0)) {
146             owner = newOwner;
147         }
148     }
149     
150     function enableWhitelist(address[] addresses) onlyOwner public {
151         for (uint i = 0; i < addresses.length; i++) {
152             blacklist[addresses[i]] = false;
153         }
154     }
155 
156     function disableWhitelist(address[] addresses) onlyOwner public {
157         for (uint i = 0; i < addresses.length; i++) {
158             blacklist[addresses[i]] = true;
159         }
160     }
161 
162     function finishDistribution() onlyOwner canDistr public returns (bool) {
163         distributionFinished = true;
164         DistrFinished();
165         return true;
166     }
167     
168     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
169         totalDistributed = totalDistributed.add(_amount);
170         totalRemaining = totalRemaining.sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         Distr(_to, _amount);
173         Transfer(address(0), _to, _amount);
174         return true;
175         
176         if (totalDistributed >= totalSupply) {
177             distributionFinished = true;
178         }
179     }
180     
181     function airdrop(address[] addresses) onlyOwner canDistr public {
182         
183         require(addresses.length <= 255);
184         require(value <= totalRemaining);
185         
186         for (uint i = 0; i < addresses.length; i++) {
187             require(value <= totalRemaining);
188             distr(addresses[i], value);
189         }
190 	
191         if (totalDistributed >= totalSupply) {
192             distributionFinished = true;
193         }
194     }
195     
196     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
197         
198         require(addresses.length <= 255);
199         require(amount <= totalRemaining);
200         
201         for (uint i = 0; i < addresses.length; i++) {
202             require(amount <= totalRemaining);
203             distr(addresses[i], amount);
204         }
205 	
206         if (totalDistributed >= totalSupply) {
207             distributionFinished = true;
208         }
209     }
210     
211     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
212 
213         require(addresses.length <= 255);
214         require(addresses.length == amounts.length);
215         
216         for (uint8 i = 0; i < addresses.length; i++) {
217             require(amounts[i] <= totalRemaining);
218             distr(addresses[i], amounts[i]);
219             
220             if (totalDistributed >= totalSupply) {
221                 distributionFinished = true;
222             }
223         }
224     }
225     
226     function () external payable {
227             getTokens();
228      }
229     
230     function getTokens() payable canDistr onlyWhitelist public {
231         
232         if (value > totalRemaining) {
233             value = totalRemaining;
234         }
235         
236         require(value <= totalRemaining);
237         
238         address investor = msg.sender;
239         uint256 toGive = value;
240         
241         distr(investor, toGive);
242         
243         if (toGive > 0) {
244             blacklist[investor] = true;
245         }
246 
247         if (totalDistributed >= totalSupply) {
248             distributionFinished = true;
249         }
250         
251         value = value.div(100000).mul(99999);
252     }
253 
254     function balanceOf(address _owner) constant public returns (uint256) {
255 	    return balances[_owner];
256     }
257 
258     // mitigates the ERC20 short address attack
259     modifier onlyPayloadSize(uint size) {
260         assert(msg.data.length >= size + 4);
261         _;
262     }
263     
264     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
265 
266         require(_to != address(0));
267         require(_amount <= balances[msg.sender]);
268         
269         balances[msg.sender] = balances[msg.sender].sub(_amount);
270         balances[_to] = balances[_to].add(_amount);
271         Transfer(msg.sender, _to, _amount);
272         return true;
273     }
274     
275     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
276 
277         require(_to != address(0));
278         require(_amount <= balances[_from]);
279         require(_amount <= allowed[_from][msg.sender]);
280         
281         balances[_from] = balances[_from].sub(_amount);
282         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
283         balances[_to] = balances[_to].add(_amount);
284         Transfer(_from, _to, _amount);
285         return true;
286     }
287     
288     function approve(address _spender, uint256 _value) public returns (bool success) {
289         // mitigates the ERC20 spend/approval race condition
290         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
291         allowed[msg.sender][_spender] = _value;
292         Approval(msg.sender, _spender, _value);
293         return true;
294     }
295     
296     function allowance(address _owner, address _spender) constant public returns (uint256) {
297         return allowed[_owner][_spender];
298     }
299     
300     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
301         ForeignToken t = ForeignToken(tokenAddress);
302         uint bal = t.balanceOf(who);
303         return bal;
304     }
305     
306     function withdraw() onlyOwner public {
307         uint256 etherBalance = this.balance;
308         owner.transfer(etherBalance);
309     }
310     
311     function burn(uint256 _value) onlyOwner public {
312         require(_value <= balances[msg.sender]);
313         // no need to require value <= totalSupply, since that would imply the
314         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
315 
316         address burner = msg.sender;
317         balances[burner] = balances[burner].sub(_value);
318         totalSupply = totalSupply.sub(_value);
319         totalDistributed = totalDistributed.sub(_value);
320         Burn(burner, _value);
321     }
322     
323     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
324         ForeignToken token = ForeignToken(_tokenContract);
325         uint256 amount = token.balanceOf(address(this));
326         return token.transfer(owner, amount);
327     }
328 
329 
330 }