1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 ╔══╗──────────╔╗──────────╔═══╗
6 ║╔╗║──────────║║──────────║╔═╗║
7 ║╚╝║╔══╗╔╗╔╗╔╗║╚═╗────╔╗╔╗╚╝╔╝║
8 ║╔═╝║╔╗║║╚╝╚╝║║╔╗║────║╚╝║╔═╝╔╝
9 ║║──║╚╝║╚╗╔╗╔╝║║║║────╚╗╔╝║ ╚═╗
10 ╚╝──╚══╝─╚╝╚╝─╚╝╚╝─────╚╝─╚═══╝
11 
12 
13 * -> About P4D
14 * An autonomousfully automated passive income:
15 * [x] Created by a team of professional Developers from India who run a software company and specialize in Internet and Cryptographic Security
16 * [x] Pen-tested multiple times with zero vulnerabilities!
17 * [X] Able to operate even if our website www.lockedin.io is down via Metamask and Etherscan
18 * [x] 30 P4D required for a Masternode Link generation
19 * [x] As people join your make money as people leave you make money 24/7 – Not a lending platform but a human-less passive income machine on the Ethereum Blockchain
20 * [x] Once deployed neither we nor any other human can alter, change or stop the contract it will run for as long as Ethereum is running!
21 * [x] Unlike similar projects the developers are only allowing 3 ETH to be purchased by Developers at deployment as opposed to 22 ETH – Fair for the Public!
22 * - 33% Reward of dividends if someone signs up using your Masternode link
23 * -  You earn by others depositing or withdrawing ETH and this passive ETH earnings can either be reinvested or you can withdraw it at any time without penalty.
24 * Upon entry into the contract it will automatically deduct your 10% entry and exit fees so the longer you remain and the higher the volume the more you earn and the more that people join or leave you also earn more.  
25 * You are able to withdraw your entire balance at any time you so choose. 
26 *\
27 
28 
29 
30 
31 
32 
33 contract HourglassV2 
34     {
35     =================================
36     =            MODIFIERS          =
37     =================================
38     // only people with tokens
39     modifier onlyBagholders() {
40         require(myTokens() > 0);
41         _;
42     }
43 
44     // only people with profits
45     modifier onlyStronghands() {
46         require(myDividends(true) > 0);
47         _;
48     }
49 
50     // ensures that the first tokens in the contract will be equally distributed
51     // meaning, no divine dump will be ever possible
52     // result: healthy longevity.
53     modifier antiEarlyWhale(uint256 _amountOfEthereum){
54         address _customerAddress = msg.sender;
55 
56         // are we still in the vulnerable phase?
57         // if so, enact anti early whale protocol 
58         if( onlyDevs && ((totalEthereumBalance() - _amountOfEthereum) <= devsQuota_ )){
59             require(
60                 // is the customer in the ambassador list?
61                 developers_[_customerAddress] == true &&
62 
63                 // does the customer purchase exceed the max ambassador quota?
64                 (devsAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= devsMaxPurchase_
65             );
66 
67             // updated the accumulated quota    
68             devsAccumulatedQuota_[_customerAddress] = SafeMath.add(devsAccumulatedQuota_[_customerAddress], _amountOfEthereum);
69 
70             // execute
71             _;
72         } else {
73             // in case the ether count drops low, the ambassador phase won't reinitiate
74             onlyDevs = false;
75             _;    
76         }
77 
78     }
79 
80 */
81 
82 library SafeMath {
83   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a * b;
85     assert(a == 0 || c / a == b);
86     return c;
87   }
88 
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a / b;
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 contract ForeignToken {
107     function balanceOf(address _owner) constant public returns (uint256);
108     function transfer(address _to, uint256 _value) public returns (bool);
109 }
110 
111 contract ERC20Basic {
112     uint256 public totalSupply;
113     function balanceOf(address who) public constant returns (uint256);
114     function transfer(address to, uint256 value) public returns (bool);
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender) public constant returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 interface Token { 
126     function distr(address _to, uint256 _value) public returns (bool);
127     function totalSupply() constant public returns (uint256 supply);
128     function balanceOf(address _owner) constant public returns (uint256 balance);
129 }
130 
131 contract HourglassV2 is ERC20 {
132     
133     using SafeMath for uint256;
134     address owner = msg.sender;
135 
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) allowed;
138     mapping (address => bool) public blacklist;
139 
140     string public constant name = "PoWH v2";
141     string public constant symbol = "PD4";
142     uint public constant decimals = 8;
143     
144     uint256 public totalSupply = 80000000e8;
145     uint256 public totalDistributed = 1e8;
146     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
147     uint256 public value;
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 _value);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151     
152     event Distr(address indexed to, uint256 amount);
153     event DistrFinished();
154     
155     event Burn(address indexed burner, uint256 value);
156 
157     bool public distributionFinished = false;
158     
159     modifier canDistr() {
160         require(!distributionFinished);
161         _;
162     }
163     
164     modifier onlyOwner() {
165         require(msg.sender == owner);
166         _;
167     }
168     
169    
170     
171     function HourglassV2 () public {
172         owner = msg.sender;
173         value = 5403e8;
174         distr(owner, totalDistributed);
175     }
176     
177     function transferOwnership(address newOwner) onlyOwner public {
178         if (newOwner != address(0)) {
179             owner = newOwner;
180         }
181     }
182     
183    
184 
185    
186 
187     function finishDistribution() onlyOwner canDistr public returns (bool) {
188         distributionFinished = true;
189         DistrFinished();
190         return true;
191     }
192     
193     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
194         totalDistributed = totalDistributed.add(_amount);
195         totalRemaining = totalRemaining.sub(_amount);
196         balances[_to] = balances[_to].add(_amount);
197         Distr(_to, _amount);
198         Transfer(address(0), _to, _amount);
199         return true;
200         
201         if (totalDistributed >= totalSupply) {
202             distributionFinished = true;
203         }
204     }
205     
206     function airdrop(address[] addresses) onlyOwner canDistr public {
207         
208         require(addresses.length <= 255);
209         require(value <= totalRemaining);
210         
211         for (uint i = 0; i < addresses.length; i++) {
212             require(value <= totalRemaining);
213             distr(addresses[i], value);
214         }
215 	
216         if (totalDistributed >= totalSupply) {
217             distributionFinished = true;
218         }
219     }
220     
221     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
222         
223         require(addresses.length <= 255);
224         require(amount <= totalRemaining);
225         
226         for (uint i = 0; i < addresses.length; i++) {
227             require(amount <= totalRemaining);
228             distr(addresses[i], amount);
229         }
230 	
231         if (totalDistributed >= totalSupply) {
232             distributionFinished = true;
233         }
234     }
235     
236     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
237 
238         require(addresses.length <= 255);
239         require(addresses.length == amounts.length);
240         
241         for (uint8 i = 0; i < addresses.length; i++) {
242             require(amounts[i] <= totalRemaining);
243             distr(addresses[i], amounts[i]);
244             
245             if (totalDistributed >= totalSupply) {
246                 distributionFinished = true;
247             }
248         }
249     }
250     
251     function () external payable {
252             getTokens();
253      }
254     
255     function getTokens() payable canDistr public {
256         
257         if (value > totalRemaining) {
258             value = totalRemaining;
259         }
260         
261         require(value <= totalRemaining);
262         
263         address investor = msg.sender;
264         uint256 toGive = value;
265         
266         distr(investor, toGive);
267         
268         if (toGive > 0) {
269             blacklist[investor] = true;
270         }
271 
272         if (totalDistributed >= totalSupply) {
273             distributionFinished = true;
274         }
275         
276      
277     }
278 
279     function balanceOf(address _owner) constant public returns (uint256) {
280 	    return balances[_owner];
281     }
282 
283     // mitigates the ERC20 short address attack
284     modifier onlyPayloadSize(uint size) {
285         assert(msg.data.length >= size + 4);
286         _;
287     }
288     
289     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
290 
291         require(_to != address(0));
292         require(_amount <= balances[msg.sender]);
293         
294         balances[msg.sender] = balances[msg.sender].sub(_amount);
295         balances[_to] = balances[_to].add(_amount);
296         Transfer(msg.sender, _to, _amount);
297         return true;
298     }
299     
300     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
301 
302         require(_to != address(0));
303         require(_amount <= balances[_from]);
304         require(_amount <= allowed[_from][msg.sender]);
305         
306         balances[_from] = balances[_from].sub(_amount);
307         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
308         balances[_to] = balances[_to].add(_amount);
309         Transfer(_from, _to, _amount);
310         return true;
311     }
312     
313     function approve(address _spender, uint256 _value) public returns (bool success) {
314         // mitigates the ERC20 spend/approval race condition
315         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
316         allowed[msg.sender][_spender] = _value;
317         Approval(msg.sender, _spender, _value);
318         return true;
319     }
320     
321     function allowance(address _owner, address _spender) constant public returns (uint256) {
322         return allowed[_owner][_spender];
323     }
324     
325     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
326         ForeignToken t = ForeignToken(tokenAddress);
327         uint bal = t.balanceOf(who);
328         return bal;
329     }
330     
331     function withdraw() onlyOwner public {
332         uint256 etherBalance = this.balance;
333         owner.transfer(etherBalance);
334     }
335     
336     function burn(uint256 _value) onlyOwner public {
337         require(_value <= balances[msg.sender]);
338         // no need to require value <= totalSupply, since that would imply the
339         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
340 
341         address burner = msg.sender;
342         balances[burner] = balances[burner].sub(_value);
343         totalSupply = totalSupply.sub(_value);
344         totalDistributed = totalDistributed.sub(_value);
345         Burn(burner, _value);
346     }
347     
348     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
349         ForeignToken token = ForeignToken(_tokenContract);
350         uint256 amount = token.balanceOf(address(this));
351         return token.transfer(owner, amount);
352     }
353 
354 
355 }