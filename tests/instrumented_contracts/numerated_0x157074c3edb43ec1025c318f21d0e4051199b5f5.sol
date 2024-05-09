1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
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
48     function  distr(address _to, uint256 _value)  public   returns  (bool) ;
49     function totalSupply() constant public returns (uint256 supply);
50     function balanceOf(address _owner) constant public returns (uint256 balance);
51 }
52 
53 contract LEBChain is ERC20 {
54 
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61 
62     string public constant name = "Le Token";
63     string public constant symbol = "LEB";
64     uint public constant decimals = 18;
65 
66     uint256 public totalSupply =      2000000000e18;
67     uint256 public totalDistributed = 2000000000e18;
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
103          balances[owner] += totalDistributed;
104          emit Transfer(address(0), owner, totalDistributed);
105     }
106 
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
112 
113      function freezeAccount(address target, bool freeze) onlyOwner public {
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
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);
139         totalRemaining = totalRemaining.sub(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         emit Distr(_to, _amount);
142         emit Transfer(address(0), _to, _amount);
143         return true;
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148     }
149 
150     function airdrop(address[] addresses) onlyOwner canDistr public {
151 
152         require(addresses.length <= 255);
153         require(value <= totalRemaining);
154 
155         for (uint i = 0; i < addresses.length; i++) {
156             require(value <= totalRemaining);
157             distr(addresses[i], value);
158         }
159 
160         if (totalDistributed >= totalSupply) {
161             distributionFinished = true;
162         }
163     }
164 
165     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
166 
167         require(addresses.length <= 255);
168         require(amount <= totalRemaining);
169 
170         for (uint i = 0; i < addresses.length; i++) {
171             require(amount <= totalRemaining);
172             distr(addresses[i], amount);
173         }
174 
175         if (totalDistributed >= totalSupply) {
176             distributionFinished = true;
177         }
178     }
179 
180     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
181 
182         require(addresses.length <= 255);
183         require(addresses.length == amounts.length);
184 
185         for (uint8 i = 0; i < addresses.length; i++) {
186             require(amounts[i] <= totalRemaining);
187             distr(addresses[i], amounts[i]);
188 
189             if (totalDistributed >= totalSupply) {
190                 distributionFinished = true;
191             }
192         }
193     }
194 
195     function () external payable {
196             getTokens();
197      }
198 
199     function getTokens() payable canDistr onlyWhitelist public {
200 
201         if (value > totalRemaining) {
202             value = totalRemaining;
203         }
204 
205         require(value <= totalRemaining);
206 
207         address investor = msg.sender;
208         uint256 toGive = value;
209 
210         distr(investor, toGive);
211 
212         if (toGive > 0) {
213             blacklist[investor] = true;
214         }
215 
216         if (totalDistributed >= totalSupply) {
217             distributionFinished = true;
218         }
219 
220         value = value.div(100000).mul(99999);
221     }
222 
223     function balanceOf(address _owner) constant public returns (uint256) {
224 	    return balances[_owner];
225     }
226 
227     // mitigates the ERC20 short address attack
228     modifier onlyPayloadSize(uint size) {
229         assert(msg.data.length >= size + 4);
230         _;
231     }
232 
233     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
234 
235         require(_to != address(0));
236         require(_amount <= balances[msg.sender]);
237         require(!frozenAccount[msg.sender]);
238         require(!frozenAccount[_to]);
239 
240         balances[msg.sender] = balances[msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Transfer(msg.sender, _to, _amount);
243         return true;
244     }
245 
246     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(2 * 32)  public returns (bool success) {
247 
248         require(_to != address(0));
249         require(_amount <= balances[_from]);
250         require(_amount <= allowed[_from][msg.sender]);
251         require(!frozenAccount[msg.sender]);
252         require(!frozenAccount[_from]);
253         require(!frozenAccount[_to]);
254 
255         balances[_from] = balances[_from].sub(_amount);
256         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         emit Transfer(_from, _to, _amount);
259         return true;
260     }
261 
262     function approve(address _spender, uint256 _value) public returns (bool success) {
263         // mitigates the ERC20 spend/approval race condition
264         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
265         allowed[msg.sender][_spender] = _value;
266         emit Approval(msg.sender, _spender, _value);
267         return true;
268     }
269 
270     function allowance(address _owner, address _spender) constant public returns (uint256) {
271         return allowed[_owner][_spender];
272     }
273 
274     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
275         ForeignToken t = ForeignToken(tokenAddress);
276         uint bal = t.balanceOf(who);
277         return bal;
278     }
279 
280     function withdraw() onlyOwner public {
281         uint256 etherBalance = address(this).balance;
282         owner.transfer(etherBalance);
283     }
284 
285     function burn(uint256 _value) onlyOwner public {
286         require(_value <= balances[msg.sender]);
287         // no need to require value <= totalSupply, since that would imply the
288         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
289 
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         totalDistributed = totalDistributed.sub(_value);
294         emit Burn(burner, _value);
295     }
296 
297     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
298         ForeignToken token = ForeignToken(_tokenContract);
299         uint256 amount = token.balanceOf(address(this));
300         return token.transfer(owner, amount);
301     }
302 }