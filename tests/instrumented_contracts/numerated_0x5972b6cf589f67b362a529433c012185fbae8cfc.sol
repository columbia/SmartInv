1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract ForeignToken {
29     function balanceOf(address _owner) constant public returns (uint256);
30     function transfer(address _to, uint256 _value) public returns (bool);
31 }
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public constant returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface Token {
48     function distr(address _to, uint256 _value) public returns (bool);
49     function totalSupply() constant public returns (uint256 supply);
50     function balanceOf(address _owner) constant public returns (uint256 balance);
51 }
52 
53 contract HKDCChain is ERC20 {
54 
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61 
62     string public constant name = "Hong Kong Dollar Coin";
63     string public constant symbol = "HKDC";
64     uint public constant decimals = 18;
65 
66     uint256 public totalSupply = 100000000e18;
67     uint256 public totalDistributed = 100000000e18;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value;
70 
71     mapping (address => bool) public frozenAccount;
72     event FrozenFunds(address target, bool frozen);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77     event Distr(address indexed to, uint256 amount);
78     event DistrFinished();
79 
80     event Burn(address indexed burner, uint256 value);
81 
82     bool public distributionFinished = false;
83 
84     modifier canDistr() {
85         require(!distributionFinished);
86         _;
87     }
88 
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     modifier onlyWhitelist() {
95         require(blacklist[msg.sender] == false);
96         _;
97     }
98 
99     constructor () public {
100         owner = msg.sender;
101         value = 100e18;
102         //distr(owner, totalDistributed);
103         balances[owner] += totalDistributed;
104         emit Transfer(address(0), owner, totalDistributed);
105     }
106 
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
112 
113     function freezeAccount(address target, bool freeze) onlyOwner public {
114         frozenAccount[target] = freeze;
115         emit FrozenFunds(target, freeze);
116     }
117 
118 
119     function enableWhitelist(address[] addresses) onlyOwner public {
120         for (uint i = 0; i < addresses.length; i++) {
121             blacklist[addresses[i]] = false;
122         }
123     }
124 
125     function disableWhitelist(address[] addresses) onlyOwner public {
126         for (uint i = 0; i < addresses.length; i++) {
127             blacklist[addresses[i]] = true;
128         }
129     }
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136 
137     function mintToken(address target, uint256 mintedAmount) onlyOwner public{
138         balances[target] += mintedAmount;
139         totalSupply += mintedAmount;
140         emit Transfer(0, owner, mintedAmount);
141         emit Transfer(owner, target, mintedAmount);
142     }
143 
144     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
145         totalDistributed = totalDistributed.add(_amount);
146         totalRemaining = totalRemaining.sub(_amount);
147         balances[_to] = balances[_to].add(_amount);
148         emit Distr(_to, _amount);
149         emit Transfer(address(0), _to, _amount);
150         return true;
151 
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155     }
156 
157     function airdrop(address[] addresses) onlyOwner canDistr public {
158 
159         require(addresses.length <= 255);
160         require(value <= totalRemaining);
161 
162         for (uint i = 0; i < addresses.length; i++) {
163             require(value <= totalRemaining);
164             distr(addresses[i], value);
165         }
166 
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170     }
171 
172     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
173 
174         require(addresses.length <= 255);
175         require(amount <= totalRemaining);
176 
177         for (uint i = 0; i < addresses.length; i++) {
178             require(amount <= totalRemaining);
179             distr(addresses[i], amount);
180         }
181 
182         if (totalDistributed >= totalSupply) {
183             distributionFinished = true;
184         }
185     }
186 
187     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
188 
189         require(addresses.length <= 255);
190         require(addresses.length == amounts.length);
191 
192         for (uint8 i = 0; i < addresses.length; i++) {
193             require(amounts[i] <= totalRemaining);
194             distr(addresses[i], amounts[i]);
195 
196             if (totalDistributed >= totalSupply) {
197                 distributionFinished = true;
198             }
199         }
200     }
201 
202     function () external payable {
203         getTokens();
204     }
205 
206     function getTokens() payable canDistr onlyWhitelist public {
207 
208         if (value > totalRemaining) {
209             value = totalRemaining;
210         }
211 
212         require(value <= totalRemaining);
213 
214         address investor = msg.sender;
215         uint256 toGive = value;
216 
217         distr(investor, toGive);
218 
219         if (toGive > 0) {
220             blacklist[investor] = true;
221         }
222 
223         if (totalDistributed >= totalSupply) {
224             distributionFinished = true;
225         }
226 
227         value = value.div(100000).mul(99999);
228     }
229 
230     function balanceOf(address _owner) constant public returns (uint256) {
231         return balances[_owner];
232     }
233 
234     // mitigates the ERC20 short address attack
235     modifier onlyPayloadSize(uint size) {
236         assert(msg.data.length >= size + 4);
237         _;
238     }
239 
240     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
241 
242         require(_to != address(0));
243         require(_amount <= balances[msg.sender]);
244         require(!frozenAccount[msg.sender]);
245         require(!frozenAccount[_to]);
246 
247         balances[msg.sender] = balances[msg.sender].sub(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Transfer(msg.sender, _to, _amount);
250         return true;
251     }
252 
253     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(2 * 32)  public returns (bool success) {
254 
255         require(_to != address(0));
256         require(_amount <= balances[_from]);
257         require(_amount <= allowed[_from][msg.sender]);
258         require(!frozenAccount[msg.sender]);
259         require(!frozenAccount[_from]);
260         require(!frozenAccount[_to]);
261 
262         balances[_from] = balances[_from].sub(_amount);
263         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         emit Transfer(_from, _to, _amount);
266         return true;
267     }
268 
269     function approve(address _spender, uint256 _value) public returns (bool success) {
270         // mitigates the ERC20 spend/approval race condition
271         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
272         allowed[msg.sender][_spender] = _value;
273         emit Approval(msg.sender, _spender, _value);
274         return true;
275     }
276 
277     function allowance(address _owner, address _spender) constant public returns (uint256) {
278         return allowed[_owner][_spender];
279     }
280 
281     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
282         ForeignToken t = ForeignToken(tokenAddress);
283         uint bal = t.balanceOf(who);
284         return bal;
285     }
286 
287     function withdraw() onlyOwner public {
288         uint256 etherBalance = address(this).balance;
289         owner.transfer(etherBalance);
290     }
291 
292 
293     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
294         ForeignToken token = ForeignToken(_tokenContract);
295         uint256 amount = token.balanceOf(address(this));
296         return token.transfer(owner, amount);
297     }
298 }