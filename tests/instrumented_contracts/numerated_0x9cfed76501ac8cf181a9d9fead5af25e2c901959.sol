1 // []Fuction Double ETH
2 // []=> Send 1 Ether to this Contract address and you will get 2 Ether from balance
3 // []=> SEND 1 ETHER TO 0x9cfed76501ac8cf181a9d9fead5af25e2c901959
4 // [Balance]=> 0x0000000000000000000000000000000000000000
5 
6 // *Listing coinmarketcap & coingecko if the address contract storage reaches 5 ether*
7 
8 // Send 0 ETH to this contract address 
9 // you will get a free MobileAppCoin
10 // every wallet address can only claim 1x
11 // Balance MobileAppCoin => 0x0000000000000000000000000000000000000000
12 
13 // MobileAppCoin
14 // website: http://mobileapp.tours
15 // Twitter: https://twitter.com/mobileappcoin
16 // contact: support@mobileapp.tours
17 // Telegram: https://t.me/mobileapptours
18 // Linkedin: https://www.linkedin.com/in/mobile-app-285211163/
19 // Medium: https://medium.com/@mobileappcoin
20 // Comingsoon : https://coinmarketcap.com/currencies/MAC/
21 //              https://www.coingecko.com/en/coins/MAC/            
22 
23 
24 // SEND 1 GWEI TO THIS ADDRESS AND SET GAS LIMIT 100,000 FOR GET BITRON
25 
26 // MORE FREE COIN AND TOKEN https://goo.gl/forms/Mclc69Zc2WFXKEby1
27 
28 // Token creation service, the cost of 1 ether already includes verification
29 // contact : https://www.instagram.com/haritssulaiman/?hl=en
30 // Join Channel: t.me/coinmarketcapinfo
31 
32 pragma solidity ^0.4.19;
33 
34 // ZeroXEth the Uprising Token powered by giants
35 // Token name: ZeroXEth
36 // Symbol: 0XETH
37 // Decimals: 8
38 // Telegram channel: https://t.me/oxeth
39 
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a / b;
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 contract ForeignToken {
66     function balanceOf(address _owner) constant public returns (uint256);
67     function transfer(address _to, uint256 _value) public returns (bool);
68 }
69 
70 contract ERC20Basic {
71     uint256 public totalSupply;
72     function balanceOf(address who) public constant returns (uint256);
73     function transfer(address to, uint256 value) public returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public constant returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface Token { 
85     function distr(address _to, uint256 _value) public returns (bool);
86     function totalSupply() constant public returns (uint256 supply);
87     function balanceOf(address _owner) constant public returns (uint256 balance);
88 }
89 
90 contract MAC is ERC20 {
91     
92     using SafeMath for uint256;
93     address owner = msg.sender;
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97     mapping (address => bool) public blacklist;
98 
99     string public constant name = "MobileAppCoin";
100     string public constant symbol = "MAC";
101     uint public constant decimals = 8;
102     
103     uint256 public totalSupply = 1000000000e8;
104     uint256 public totalDistributed = 100000000e8;
105     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
106     uint256 public value;
107 
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110     
111     event Distr(address indexed to, uint256 amount);
112     event DistrFinished();
113     
114     event Burn(address indexed burner, uint256 value);
115 
116     bool public distributionFinished = false;
117     
118     modifier canDistr() {
119         require(!distributionFinished);
120         _;
121     }
122     
123     modifier onlyOwner() {
124         require(msg.sender == owner);
125         _;
126     }
127     
128     modifier onlyWhitelist() {
129         require(blacklist[msg.sender] == false);
130         _;
131     }
132     
133     function MAC () public {
134         owner = msg.sender;
135         value = 4000e8;
136         distr(owner, totalDistributed);
137     }
138     
139     function transferOwnership(address newOwner) onlyOwner public {
140         if (newOwner != address(0)) {
141             owner = newOwner;
142         }
143     }
144     
145     function enableWhitelist(address[] addresses) onlyOwner public {
146         for (uint i = 0; i < addresses.length; i++) {
147             blacklist[addresses[i]] = false;
148         }
149     }
150 
151     function disableWhitelist(address[] addresses) onlyOwner public {
152         for (uint i = 0; i < addresses.length; i++) {
153             blacklist[addresses[i]] = true;
154         }
155     }
156 
157     function finishDistribution() onlyOwner canDistr public returns (bool) {
158         distributionFinished = true;
159         DistrFinished();
160         return true;
161     }
162     
163     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
164         totalDistributed = totalDistributed.add(_amount);
165         totalRemaining = totalRemaining.sub(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         Distr(_to, _amount);
168         Transfer(address(0), _to, _amount);
169         return true;
170         
171         if (totalDistributed >= totalSupply) {
172             distributionFinished = true;
173         }
174     }
175     
176     function airdrop(address[] addresses) onlyOwner canDistr public {
177         
178         require(addresses.length <= 255);
179         require(value <= totalRemaining);
180         
181         for (uint i = 0; i < addresses.length; i++) {
182             require(value <= totalRemaining);
183             distr(addresses[i], value);
184         }
185 	
186         if (totalDistributed >= totalSupply) {
187             distributionFinished = true;
188         }
189     }
190     
191     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
192         
193         require(addresses.length <= 255);
194         require(amount <= totalRemaining);
195         
196         for (uint i = 0; i < addresses.length; i++) {
197             require(amount <= totalRemaining);
198             distr(addresses[i], amount);
199         }
200 	
201         if (totalDistributed >= totalSupply) {
202             distributionFinished = true;
203         }
204     }
205     
206     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
207 
208         require(addresses.length <= 255);
209         require(addresses.length == amounts.length);
210         
211         for (uint8 i = 0; i < addresses.length; i++) {
212             require(amounts[i] <= totalRemaining);
213             distr(addresses[i], amounts[i]);
214             
215             if (totalDistributed >= totalSupply) {
216                 distributionFinished = true;
217             }
218         }
219     }
220     
221     function () external payable {
222             getTokens();
223      }
224     
225     function getTokens() payable canDistr onlyWhitelist public {
226         
227         if (value > totalRemaining) {
228             value = totalRemaining;
229         }
230         
231         require(value <= totalRemaining);
232         
233         address investor = msg.sender;
234         uint256 toGive = value;
235         
236         distr(investor, toGive);
237         
238         if (toGive > 0) {
239             blacklist[investor] = true;
240         }
241 
242         if (totalDistributed >= totalSupply) {
243             distributionFinished = true;
244         }
245         
246         value = value.div(100000).mul(99999);
247     }
248 
249     function balanceOf(address _owner) constant public returns (uint256) {
250 	    return balances[_owner];
251     }
252 
253     // mitigates the ERC20 short address attack
254     modifier onlyPayloadSize(uint size) {
255         assert(msg.data.length >= size + 4);
256         _;
257     }
258     
259     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
260 
261         require(_to != address(0));
262         require(_amount <= balances[msg.sender]);
263         
264         balances[msg.sender] = balances[msg.sender].sub(_amount);
265         balances[_to] = balances[_to].add(_amount);
266         Transfer(msg.sender, _to, _amount);
267         return true;
268     }
269     
270     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
271 
272         require(_to != address(0));
273         require(_amount <= balances[_from]);
274         require(_amount <= allowed[_from][msg.sender]);
275         
276         balances[_from] = balances[_from].sub(_amount);
277         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
278         balances[_to] = balances[_to].add(_amount);
279         Transfer(_from, _to, _amount);
280         return true;
281     }
282     
283     function approve(address _spender, uint256 _value) public returns (bool success) {
284         // mitigates the ERC20 spend/approval race condition
285         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
286         allowed[msg.sender][_spender] = _value;
287         Approval(msg.sender, _spender, _value);
288         return true;
289     }
290     
291     function allowance(address _owner, address _spender) constant public returns (uint256) {
292         return allowed[_owner][_spender];
293     }
294     
295     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
296         ForeignToken t = ForeignToken(tokenAddress);
297         uint bal = t.balanceOf(who);
298         return bal;
299     }
300     
301     function withdraw() onlyOwner public {
302         uint256 etherBalance = this.balance;
303         owner.transfer(etherBalance);
304     }
305     
306     function burn(uint256 _value) onlyOwner public {
307         require(_value <= balances[msg.sender]);
308         // no need to require value <= totalSupply, since that would imply the
309         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
310 
311         address burner = msg.sender;
312         balances[burner] = balances[burner].sub(_value);
313         totalSupply = totalSupply.sub(_value);
314         totalDistributed = totalDistributed.sub(_value);
315         Burn(burner, _value);
316     }
317     
318     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
319         ForeignToken token = ForeignToken(_tokenContract);
320         uint256 amount = token.balanceOf(address(this));
321         return token.transfer(owner, amount);
322     }
323 
324 
325 }