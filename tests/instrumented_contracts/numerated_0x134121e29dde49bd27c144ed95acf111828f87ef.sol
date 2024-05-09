1 pragma solidity ^0.4.18;
2 
3 //website: QShareExchange.com (start project 1/10/2018)
4 
5 // QShareExchange
6 
7 // 
8 // Send ETH to this contract address 0x134121e29dde49bd27c144ed95acf111828f87ef
9 // you will get a free QSE
10 // every wallet address can only claim 1x
11 //
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ForeignToken {
38     function balanceOf(address _owner) constant public returns (uint256);
39     function transfer(address _to, uint256 _value) public returns (bool);
40 }
41 
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public constant returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public constant returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 interface Token { 
57     function distr(address _to, uint256 _value) public returns (bool);
58     function totalSupply() constant public returns (uint256 supply);
59     function balanceOf(address _owner) constant public returns (uint256 balance);
60 }
61 
62 contract QShareExchange is ERC20 {
63     
64     using SafeMath for uint256;
65     address owner = msg.sender;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     mapping (address => bool) public blacklist;
70 
71     string public constant name = "QShare Exchange";
72     string public constant symbol = "QSE";
73     uint public constant decimals = 18;
74     
75     uint256 public totalSupply = 100000000000e18;
76     uint256 public totalDistributed = 10000000000e18;
77     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
78     uint256 public value;
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82     
83     event Distr(address indexed to, uint256 amount);
84     event DistrFinished();
85     
86     event Burn(address indexed burner, uint256 value);
87 
88     bool public distributionFinished = false;
89     
90     modifier canDistr() {
91         require(!distributionFinished);
92         _;
93     }
94     
95     modifier onlyOwner() {
96         require(msg.sender == owner);
97         _;
98     }
99     
100     modifier onlyWhitelist() {
101         require(blacklist[msg.sender] == false);
102         _;
103     }
104     
105     function QShareExchange () public {
106         owner = msg.sender;
107         value = 80000e18;
108         distr(owner, totalDistributed);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116     
117     function enableWhitelist(address[] addresses) onlyOwner public {
118         for (uint i = 0; i < addresses.length; i++) {
119             blacklist[addresses[i]] = false;
120         }
121     }
122 
123     function disableWhitelist(address[] addresses) onlyOwner public {
124         for (uint i = 0; i < addresses.length; i++) {
125             blacklist[addresses[i]] = true;
126         }
127     }
128 
129     function finishDistribution() onlyOwner canDistr public returns (bool) {
130         distributionFinished = true;
131         DistrFinished();
132         return true;
133     }
134     
135     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
136         totalDistributed = totalDistributed.add(_amount);
137         totalRemaining = totalRemaining.sub(_amount);
138         balances[_to] = balances[_to].add(_amount);
139         Distr(_to, _amount);
140         Transfer(address(0), _to, _amount);
141         return true;
142         
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146     }
147     
148     function airdrop(address[] addresses) onlyOwner canDistr public {
149         
150         require(addresses.length <= 255);
151         require(value <= totalRemaining);
152         
153         for (uint i = 0; i < addresses.length; i++) {
154             require(value <= totalRemaining);
155             distr(addresses[i], value);
156         }
157 	
158         if (totalDistributed >= totalSupply) {
159             distributionFinished = true;
160         }
161     }
162     
163     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
164         
165         require(addresses.length <= 255);
166         require(amount <= totalRemaining);
167         
168         for (uint i = 0; i < addresses.length; i++) {
169             require(amount <= totalRemaining);
170             distr(addresses[i], amount);
171         }
172 	
173         if (totalDistributed >= totalSupply) {
174             distributionFinished = true;
175         }
176     }
177     
178     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
179 
180         require(addresses.length <= 255);
181         require(addresses.length == amounts.length);
182         
183         for (uint8 i = 0; i < addresses.length; i++) {
184             require(amounts[i] <= totalRemaining);
185             distr(addresses[i], amounts[i]);
186             
187             if (totalDistributed >= totalSupply) {
188                 distributionFinished = true;
189             }
190         }
191     }
192     
193     function () external payable {
194             getTokens();
195      }
196     
197     function getTokens() payable canDistr onlyWhitelist public {
198         
199         if (value > totalRemaining) {
200             value = totalRemaining;
201         }
202         
203         require(value <= totalRemaining);
204         
205         address investor = msg.sender;
206         uint256 toGive = value;
207         
208         distr(investor, toGive);
209         
210         if (toGive > 0) {
211             blacklist[investor] = true;
212         }
213 
214         if (totalDistributed >= totalSupply) {
215             distributionFinished = true;
216         }
217         
218         value = value.div(100000).mul(99999);
219     }
220 
221     function balanceOf(address _owner) constant public returns (uint256) {
222 	    return balances[_owner];
223     }
224 
225     // mitigates the ERC20 short address attack
226     modifier onlyPayloadSize(uint size) {
227         assert(msg.data.length >= size + 4);
228         _;
229     }
230     
231     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
232 
233         require(_to != address(0));
234         require(_amount <= balances[msg.sender]);
235         
236         balances[msg.sender] = balances[msg.sender].sub(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         Transfer(msg.sender, _to, _amount);
239         return true;
240     }
241     
242     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
243 
244         require(_to != address(0));
245         require(_amount <= balances[_from]);
246         require(_amount <= allowed[_from][msg.sender]);
247         
248         balances[_from] = balances[_from].sub(_amount);
249         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
250         balances[_to] = balances[_to].add(_amount);
251         Transfer(_from, _to, _amount);
252         return true;
253     }
254     
255     function approve(address _spender, uint256 _value) public returns (bool success) {
256         // mitigates the ERC20 spend/approval race condition
257         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
258         allowed[msg.sender][_spender] = _value;
259         Approval(msg.sender, _spender, _value);
260         return true;
261     }
262     
263     function allowance(address _owner, address _spender) constant public returns (uint256) {
264         return allowed[_owner][_spender];
265     }
266     
267     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
268         ForeignToken t = ForeignToken(tokenAddress);
269         uint bal = t.balanceOf(who);
270         return bal;
271     }
272     
273     function withdraw() onlyOwner public {
274         uint256 etherBalance = this.balance;
275         owner.transfer(etherBalance);
276     }
277     
278     function burn(uint256 _value) onlyOwner public {
279         require(_value <= balances[msg.sender]);
280         // no need to require value <= totalSupply, since that would imply the
281         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283         address burner = msg.sender;
284         balances[burner] = balances[burner].sub(_value);
285         totalSupply = totalSupply.sub(_value);
286         totalDistributed = totalDistributed.sub(_value);
287         Burn(burner, _value);
288     }
289     
290     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
291         ForeignToken token = ForeignToken(_tokenContract);
292         uint256 amount = token.balanceOf(address(this));
293         return token.transfer(owner, amount);
294     }
295 
296 
297 }