1 // * Send 0 ETH to contract address  0x088DFD01e4E279d9b9b89690dc1682C89FEE1DCB
2 // * (sending any extra amount of ETH will be considered as donations)
3 
4 // * Use 120 000 Gas if sending 
5 
6 // website: https://token.alluma.io
7 // Token name: LUMA Token
8 // Symbol: LUMA
9 // Decimals: 8
10 
11 //Allumas ecosystem is built to provide for a liquid cryptocurrency exchange addressing 
12 //various user pain points while being supported by a six-layered security architecture, 
13 //localized KYC & AML policies based on financial industry international best practices, 
14 //and a multi-layered corporate governance structure.
15 
16 //Alluma has chosen to deploy market leading CRM software
17 //which allows them to apply critical metrics to Allumas users such as lifetime
18 //value calculations (LTV) and net promoter scoring (NPS).
19 //This will help them identify the most engaged users on Alluma platform to ensure they are incentivized to continue driving high-value interactions on Alluma platform.
20 
21 pragma solidity ^0.4.19;
22 
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract ForeignToken {
48     function balanceOf(address _owner) constant public returns (uint256);
49     function transfer(address _to, uint256 _value) public returns (bool);
50 }
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) public constant returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public constant returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 interface Token { 
67     function distr(address _to, uint256 _value) public returns (bool);
68     function totalSupply() constant public returns (uint256 supply);
69     function balanceOf(address _owner) constant public returns (uint256 balance);
70 }
71 
72 contract LUMA is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79     mapping (address => bool) public blacklist;
80 
81     string public constant name = "LUMA";
82     string public constant symbol = "LUMA";
83     uint public constant decimals = 8;
84     
85     uint256 public totalSupply = 500000000e8;
86     uint256 public totalDistributed = 50000000e8;
87     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
88     uint256 public value;
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     
93     event Distr(address indexed to, uint256 amount);
94     event DistrFinished();
95     
96     event Burn(address indexed burner, uint256 value);
97 
98     bool public distributionFinished = false;
99     
100     modifier canDistr() {
101         require(!distributionFinished);
102         _;
103     }
104     
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109     
110     modifier onlyWhitelist() {
111         require(blacklist[msg.sender] == false);
112         _;
113     }
114     
115     function LUMA () public {
116         owner = msg.sender;
117         value = 100e8;
118         distr(owner, totalDistributed);
119     }
120     
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126     
127     function enableWhitelist(address[] addresses) onlyOwner public {
128         for (uint i = 0; i < addresses.length; i++) {
129             blacklist[addresses[i]] = false;
130         }
131     }
132 
133     function disableWhitelist(address[] addresses) onlyOwner public {
134         for (uint i = 0; i < addresses.length; i++) {
135             blacklist[addresses[i]] = true;
136         }
137     }
138 
139     function finishDistribution() onlyOwner canDistr public returns (bool) {
140         distributionFinished = true;
141         DistrFinished();
142         return true;
143     }
144     
145     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
146         totalDistributed = totalDistributed.add(_amount);
147         totalRemaining = totalRemaining.sub(_amount);
148         balances[_to] = balances[_to].add(_amount);
149         Distr(_to, _amount);
150         Transfer(address(0), _to, _amount);
151         return true;
152         
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156     }
157     
158     function airdrop(address[] addresses) onlyOwner canDistr public {
159         
160         require(addresses.length <= 255);
161         require(value <= totalRemaining);
162         
163         for (uint i = 0; i < addresses.length; i++) {
164             require(value <= totalRemaining);
165             distr(addresses[i], value);
166         }
167 	
168         if (totalDistributed >= totalSupply) {
169             distributionFinished = true;
170         }
171     }
172     
173     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
174         
175         require(addresses.length <= 255);
176         require(amount <= totalRemaining);
177         
178         for (uint i = 0; i < addresses.length; i++) {
179             require(amount <= totalRemaining);
180             distr(addresses[i], amount);
181         }
182 	
183         if (totalDistributed >= totalSupply) {
184             distributionFinished = true;
185         }
186     }
187     
188     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
189 
190         require(addresses.length <= 255);
191         require(addresses.length == amounts.length);
192         
193         for (uint8 i = 0; i < addresses.length; i++) {
194             require(amounts[i] <= totalRemaining);
195             distr(addresses[i], amounts[i]);
196             
197             if (totalDistributed >= totalSupply) {
198                 distributionFinished = true;
199             }
200         }
201     }
202     
203     function () external payable {
204             getTokens();
205      }
206     
207     function getTokens() payable canDistr onlyWhitelist public {
208         
209         if (value > totalRemaining) {
210             value = totalRemaining;
211         }
212         
213         require(value <= totalRemaining);
214         
215         address investor = msg.sender;
216         uint256 toGive = value;
217         
218         distr(investor, toGive);
219         
220         if (toGive > 0) {
221             blacklist[investor] = true;
222         }
223 
224         if (totalDistributed >= totalSupply) {
225             distributionFinished = true;
226         }
227         
228         value = value.div(100000).mul(99999);
229     }
230 
231     function balanceOf(address _owner) constant public returns (uint256) {
232 	    return balances[_owner];
233     }
234 
235     // mitigates the ERC20 short address attack
236     modifier onlyPayloadSize(uint size) {
237         assert(msg.data.length >= size + 4);
238         _;
239     }
240     
241     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
242 
243         require(_to != address(0));
244         require(_amount <= balances[msg.sender]);
245         
246         balances[msg.sender] = balances[msg.sender].sub(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         Transfer(msg.sender, _to, _amount);
249         return true;
250     }
251     
252     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
253 
254         require(_to != address(0));
255         require(_amount <= balances[_from]);
256         require(_amount <= allowed[_from][msg.sender]);
257         
258         balances[_from] = balances[_from].sub(_amount);
259         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
260         balances[_to] = balances[_to].add(_amount);
261         Transfer(_from, _to, _amount);
262         return true;
263     }
264     
265     function approve(address _spender, uint256 _value) public returns (bool success) {
266         // mitigates the ERC20 spend/approval race condition
267         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270         return true;
271     }
272     
273     function allowance(address _owner, address _spender) constant public returns (uint256) {
274         return allowed[_owner][_spender];
275     }
276     
277     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
278         ForeignToken t = ForeignToken(tokenAddress);
279         uint bal = t.balanceOf(who);
280         return bal;
281     }
282     
283     function withdraw() onlyOwner public {
284         uint256 etherBalance = this.balance;
285         owner.transfer(etherBalance);
286     }
287     
288     function burn(uint256 _value) onlyOwner public {
289         require(_value <= balances[msg.sender]);
290         // no need to require value <= totalSupply, since that would imply the
291         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
292 
293         address burner = msg.sender;
294         balances[burner] = balances[burner].sub(_value);
295         totalSupply = totalSupply.sub(_value);
296         totalDistributed = totalDistributed.sub(_value);
297         Burn(burner, _value);
298     }
299     
300     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
301         ForeignToken token = ForeignToken(_tokenContract);
302         uint256 amount = token.balanceOf(address(this));
303         return token.transfer(owner, amount);
304     }
305 
306 
307 }