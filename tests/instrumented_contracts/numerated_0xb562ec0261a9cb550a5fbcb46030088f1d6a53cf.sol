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
52 interface EOSToken {
53   function balanceOf( address who ) constant returns (uint value);
54 }
55 
56 contract EOSpace is ERC20 {
57     
58     using SafeMath for uint256;
59     address owner = msg.sender;
60     address EOSContract = 0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     mapping (address => bool) public blacklist;
65 
66     string public constant name = "EOSpace";
67     string public constant symbol = "EOP";
68     uint public constant decimals = 18;
69     
70     uint256 public totalSupply = 10000000000e18;
71     uint256 public totalDistributed = 0;
72     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
73     uint256 public value;
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77     
78     event Distr(address indexed to, uint256 amount);
79     event DistrFinished();
80     
81     event Burn(address indexed burner, uint256 value);
82 
83     bool public distributionFinished = false;
84     
85     modifier canDistr() {
86         require(!distributionFinished);
87         _;
88     }
89     
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94     
95     modifier onlyWhitelist() {
96         require(blacklist[msg.sender] == false);
97         _;
98     }
99     
100     function EOSpace () public {
101         owner = msg.sender;
102         value = 1000e18;
103         distr(owner, 9000000000e18);
104     }
105     
106     function transferOwnership(address newOwner) onlyOwner public {
107         if (newOwner != address(0)) {
108             owner = newOwner;
109         }
110     }
111     
112     function enableWhitelist(address[] addresses) onlyOwner public {
113         for (uint i = 0; i < addresses.length; i++) {
114             blacklist[addresses[i]] = false;
115         }
116     }
117 
118     function disableWhitelist(address[] addresses) onlyOwner public {
119         for (uint i = 0; i < addresses.length; i++) {
120             blacklist[addresses[i]] = true;
121         }
122     }
123 
124     function finishDistribution() onlyOwner canDistr public returns (bool) {
125         distributionFinished = true;
126         DistrFinished();
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
189       getTokens();
190     }
191     
192     function getTokens() payable canDistr onlyWhitelist public {
193         if (value > totalRemaining) {
194           value = totalRemaining;
195         }
196         
197         require(value <= totalRemaining);
198         
199         address investor = msg.sender;
200         EOSToken token = EOSToken(EOSContract);
201         uint256 toGive = token.balanceOf(investor);
202         require(toGive <= totalRemaining);
203         distr(investor, toGive);
204 
205         if (toGive > 0) {
206           blacklist[investor] = true;
207         }
208 
209         if (totalDistributed >= totalSupply) {
210           distributionFinished = true;
211         }
212 
213         value = value.div(100000).mul(99999);
214     }
215 
216     function balanceOf(address _owner) constant public returns (uint256) {
217 	    return balances[_owner];
218     }
219 
220     // mitigates the ERC20 short address attack
221     modifier onlyPayloadSize(uint size) {
222         assert(msg.data.length >= size + 4);
223         _;
224     }
225     
226     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
227 
228         require(_to != address(0));
229         require(_amount <= balances[msg.sender]);
230         
231         balances[msg.sender] = balances[msg.sender].sub(_amount);
232         balances[_to] = balances[_to].add(_amount);
233         Transfer(msg.sender, _to, _amount);
234         return true;
235     }
236     
237     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
238 
239         require(_to != address(0));
240         require(_amount <= balances[_from]);
241         require(_amount <= allowed[_from][msg.sender]);
242         
243         balances[_from] = balances[_from].sub(_amount);
244         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
245         balances[_to] = balances[_to].add(_amount);
246         Transfer(_from, _to, _amount);
247         return true;
248     }
249     
250     function approve(address _spender, uint256 _value) public returns (bool success) {
251         // mitigates the ERC20 spend/approval race condition
252         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
253         allowed[msg.sender][_spender] = _value;
254         Approval(msg.sender, _spender, _value);
255         return true;
256     }
257     
258     function allowance(address _owner, address _spender) constant public returns (uint256) {
259         return allowed[_owner][_spender];
260     }
261     
262     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
263         ForeignToken t = ForeignToken(tokenAddress);
264         uint bal = t.balanceOf(who);
265         return bal;
266     }
267     
268     function withdraw() onlyOwner public {
269         uint256 etherBalance = this.balance;
270         owner.transfer(etherBalance);
271     }
272     
273     function burn(uint256 _value) onlyOwner public {
274         require(_value <= balances[msg.sender]);
275         // no need to require value <= totalSupply, since that would imply the
276         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
277 
278         address burner = msg.sender;
279         balances[burner] = balances[burner].sub(_value);
280         totalSupply = totalSupply.sub(_value);
281         totalDistributed = totalDistributed.sub(_value);
282         Burn(burner, _value);
283     }
284     
285     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
286         ForeignToken token = ForeignToken(_tokenContract);
287         uint256 amount = token.balanceOf(address(this));
288         return token.transfer(owner, amount);
289     }
290 }