1 pragma solidity ^0.4.19;
2 
3 // Magic10 (Magic10 for Purchasing all)
4 // Token name: Magic10
5 // Symbol: 10
6 // Decimals: 8
7 // Twitter : @Magic10
8 
9 
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ForeignToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract ERC20Basic {
41     uint256 public totalSupply;
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 interface Token {
55     function distr(address _to, uint256 _value) public returns (bool);
56     function totalSupply() constant public returns (uint256 supply);
57     function balanceOf(address _owner) constant public returns (uint256 balance);
58 }
59 
60 contract Magic10 {
61 
62     using SafeMath for uint256;
63     address owner = msg.sender;
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67     mapping (address => bool) public blacklist;
68 
69     string public constant name = "Magic10";
70     string public constant symbol = "10";
71     uint public constant decimals = 8;
72 
73     uint256 public totalSupply = 10e8;
74     uint256 public totalDistributed = 4e8;
75     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
76     uint256 public value;
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81     event Distr(address indexed to, uint256 amount);
82     event DistrFinished();
83 
84     event Burn(address indexed burner, uint256 value);
85 
86     bool public distributionFinished = false;
87 
88     modifier canDistr() {
89         require(!distributionFinished);
90         _;
91     }
92 
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     modifier onlyWhitelist() {
99         require(blacklist[msg.sender] == false);
100         _;
101     }
102 
103     function Magic10 (uint random, address randomAddr) public {
104         owner = msg.sender;
105         value = 0.00005e8;
106         distr(owner, totalDistributed);
107     }
108 
109     function transferOwnership(address newOwner) onlyOwner public {
110         if (newOwner != address(0)) {
111             owner = newOwner;
112         }
113     }
114 
115     function enableWhitelist(address[] addresses) onlyOwner public {
116         for (uint i = 0; i < addresses.length; i++) {
117             blacklist[addresses[i]] = false;
118         }
119     }
120 
121     function disableWhitelist(address[] addresses) onlyOwner public {
122         for (uint i = 0; i < addresses.length; i++) {
123             blacklist[addresses[i]] = true;
124         }
125     }
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         DistrFinished();
130         return true;
131     }
132 
133     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
134         totalDistributed = totalDistributed.add(_amount);
135         totalRemaining = totalRemaining.sub(_amount);
136         balances[_to] = balances[_to].add(_amount);
137         Distr(_to, _amount);
138         Transfer(address(0), _to, _amount);
139         return true;
140 
141         if (totalDistributed >= totalSupply) {
142             distributionFinished = true;
143         }
144     }
145 
146     function airdrop(address[] addresses) onlyOwner canDistr public {
147 
148         require(addresses.length <= 255);
149         require(value <= totalRemaining);
150 
151         for (uint i = 0; i < addresses.length; i++) {
152             require(value <= totalRemaining);
153             distr(addresses[i], value);
154         }
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159     }
160 
161     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
162 
163         require(addresses.length <= 255);
164         require(amount <= totalRemaining);
165 
166         for (uint i = 0; i < addresses.length; i++) {
167             require(amount <= totalRemaining);
168             distr(addresses[i], amount);
169         }
170 
171         if (totalDistributed >= totalSupply) {
172             distributionFinished = true;
173         }
174     }
175 
176     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
177 
178         require(addresses.length <= 255);
179         require(addresses.length == amounts.length);
180 
181         for (uint8 i = 0; i < addresses.length; i++) {
182             require(amounts[i] <= totalRemaining);
183             distr(addresses[i], amounts[i]);
184 
185             if (totalDistributed >= totalSupply) {
186                 distributionFinished = true;
187             }
188         }
189     }
190 
191     function () external payable {
192             getTokens();
193      }
194 
195     function getTokens() payable canDistr onlyWhitelist public {
196 
197         if (value > totalRemaining) {
198             value = totalRemaining;
199         }
200 
201         require(value <= totalRemaining);
202 
203         address investor = msg.sender;
204         uint256 toGive = value;
205 
206         distr(investor, toGive);
207 
208         if (toGive > 0) {
209             blacklist[investor] = true;
210         }
211 
212         if (totalDistributed >= totalSupply) {
213             distributionFinished = true;
214         }
215 
216         value = value.div(100000).mul(99999);
217     }
218 
219     function balanceOf(address _owner) constant public returns (uint256) {
220 	    return balances[_owner];
221     }
222 
223     // mitigates the ERC20 short address attack
224     modifier onlyPayloadSize(uint size) {
225         assert(msg.data.length >= size + 4);
226         _;
227     }
228 
229     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
230 
231         require(_to != address(0));
232         require(_amount <= balances[msg.sender]);
233 
234         balances[msg.sender] = balances[msg.sender].sub(_amount);
235         balances[_to] = balances[_to].add(_amount);
236         Transfer(msg.sender, _to, _amount);
237         return true;
238     }
239 
240     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool
241 success) {
242 
243         require(_to != address(0));
244         require(_amount <= balances[_from]);
245         require(_amount <= allowed[_from][msg.sender]);
246 
247         balances[_from] = balances[_from].sub(_amount);
248         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
249         balances[_to] = balances[_to].add(_amount);
250         Transfer(_from, _to, _amount);
251         return true;
252     }
253 
254     function approve(address _spender, uint256 _value) public returns (bool success) {
255         // mitigates the ERC20 spend/approval race condition
256         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
257         allowed[msg.sender][_spender] = _value;
258         Approval(msg.sender, _spender, _value);
259         return true;
260     }
261 
262     function allowance(address _owner, address _spender) constant public returns (uint256) {
263         return allowed[_owner][_spender];
264     }
265 
266     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
267         ForeignToken t = ForeignToken(tokenAddress);
268         uint bal = t.balanceOf(who);
269         return bal;
270     }
271 
272     function withdraw() onlyOwner public {
273         uint256 etherBalance = this.balance;
274         owner.transfer(etherBalance);
275     }
276 
277     function burn(uint256 _value) onlyOwner public {
278         require(_value <= balances[msg.sender]);
279         // no need to require value <= totalSupply, since that would imply the
280         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282         address burner = msg.sender;
283         balances[burner] = balances[burner].sub(_value);
284         totalSupply = totalSupply.sub(_value);
285         totalDistributed = totalDistributed.sub(_value);
286         Burn(burner, _value);
287     }
288 
289     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
290         ForeignToken token = ForeignToken(_tokenContract);
291         uint256 amount = token.balanceOf(address(this));
292         return token.transfer(owner, amount);
293     }
294 
295 }