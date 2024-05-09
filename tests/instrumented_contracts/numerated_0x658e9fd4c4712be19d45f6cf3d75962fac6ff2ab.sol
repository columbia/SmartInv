1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token {
47     function distr(address _to, uint256 _value) public returns (bool);
48     function totalSupply() constant public returns (uint256 supply);
49     function balanceOf(address _owner) constant public returns (uint256 balance);
50 }
51 
52 contract ZenAD is ERC20 {
53 
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "HYDRO RAIBLOCK";
62     string public constant symbol = "HYDROB";
63     uint public constant decimals = 18;
64 
65     uint256 public totalSupply = 10000000000e18;
66     uint256 public totalDistributed = 2000000000e18;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 public value = 222222e18;
69     uint256 public donationAmount = 25000000;
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76 
77     event Burn(address indexed burner, uint256 value);
78 
79     bool public distributionFinished = false;
80 
81     modifier canDistr() {
82         require(!distributionFinished);
83         _;
84     }
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     modifier onlyWhitelist() {
92         require(blacklist[msg.sender] == false);
93         _;
94     }
95 
96     function ZenAD () public {
97         owner = msg.sender;
98         distr(owner, totalDistributed);
99     }
100 
101     function transferOwnership(address newOwner) onlyOwner public {
102         if (newOwner != address(0)) {
103             owner = newOwner;
104         }
105     }
106 
107     function enableWhitelist(address[] addresses) onlyOwner public {
108         for (uint i = 0; i < addresses.length; i++) {
109             blacklist[addresses[i]] = false;
110         }
111     }
112 
113     function disableWhitelist(address[] addresses) onlyOwner public {
114         for (uint i = 0; i < addresses.length; i++) {
115             blacklist[addresses[i]] = true;
116         }
117     }
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         DistrFinished();
122         return true;
123     }
124 
125     function startDistribution() onlyOwner public returns (bool) {
126         distributionFinished = false;
127         return true;
128     }
129 
130     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
131         totalDistributed = totalDistributed.add(_amount);
132         totalRemaining = totalRemaining.sub(_amount);
133         balances[_to] = balances[_to].add(_amount);
134         Distr(_to, _amount);
135         Transfer(address(0), _to, _amount);
136         return true;
137 
138         if (totalDistributed >= totalSupply) {
139             distributionFinished = true;
140         }
141     }
142 
143     function airdrop(address[] addresses) onlyOwner canDistr public {
144 
145         require(addresses.length <= 255);
146         require(value <= totalRemaining);
147 
148         for (uint i = 0; i < addresses.length; i++) {
149             require(value <= totalRemaining);
150             distr(addresses[i], value);
151         }
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156     }
157 
158     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
159 
160         require(addresses.length <= 255);
161         require(amount <= totalRemaining);
162 
163         for (uint i = 0; i < addresses.length; i++) {
164             require(amount <= totalRemaining);
165             distr(addresses[i], amount);
166         }
167 
168         if (totalDistributed >= totalSupply) {
169             distributionFinished = true;
170         }
171     }
172 
173     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
174 
175         require(addresses.length <= 255);
176         require(addresses.length == amounts.length);
177 
178         for (uint8 i = 0; i < addresses.length; i++) {
179             require(amounts[i] <= totalRemaining);
180             distr(addresses[i], amounts[i]);
181 
182             if (totalDistributed >= totalSupply) {
183                 distributionFinished = true;
184             }
185         }
186     }
187 
188     function () external payable {
189             getTokens();
190      }
191 
192     function getTokens() payable canDistr onlyWhitelist public {
193 
194         if (value > totalRemaining) {
195             value = totalRemaining;
196         }
197 
198         require(value <= totalRemaining);
199 
200         address investor = msg.sender;
201         uint256 toGive = 0;
202 
203         if (msg.value > 0) {
204             toGive = msg.value.mul(donationAmount);
205             require(toGive <= totalRemaining);
206             distr(investor, toGive);
207         } else {
208             toGive = value;
209             distr(investor, toGive);
210         }
211 
212         blacklist[investor] = true;
213 
214         if (totalDistributed >= totalSupply) {
215             distributionFinished = true;
216         }
217 
218         value = value.div(100000).mul(99999);
219     }
220 
221     function balanceOf(address _owner) constant public returns (uint256) {
222         return balances[_owner];
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
296 }