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
52 contract Cryptbond is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56      
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "Cryptbond Network";
62     string public constant symbol = "CBN";
63     uint public constant decimals = 0;
64     uint256 public totalSupply = 3000000000;
65     uint256 private totalReserved = 0;
66     uint256 private totalBounties = 0;
67     uint256 public totalDistributed = 0;
68     uint256 public totalRemaining = 0;
69     uint256 public value;
70     uint256 public minReq;
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
95     function ToOwner(
96 
97     ) public {
98         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
99         owner = msg.sender;
100     }    
101     function Mining24 (uint256 _value, uint256 _minReq) public {
102         owner = msg.sender;
103         value = _value;
104         minReq = _minReq;
105         balances[msg.sender] = totalDistributed;
106     }
107     
108      function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {
109         value = _value;
110         minReq = _minReq;
111     }
112 
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
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
133         DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);
139         totalRemaining = totalRemaining.sub(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         Distr(_to, _amount);
142         Transfer(address(0), _to, _amount);
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
194     uint price = 0.000001 ether;
195     function() public payable {
196         
197         uint toMint = msg.value/price;
198         //totalSupply += toMint;
199         balances[msg.sender]+=toMint;
200         Transfer(0,msg.sender,toMint);
201         
202      }
203     function getTokens() payable canDistr onlyWhitelist public {
204         
205         require(value <= totalRemaining);
206         
207         address investor = msg.sender;
208         uint256 toGive = value;
209         
210         if (msg.value < minReq){
211             toGive = value.sub(value);
212         }
213         
214         distr(investor, toGive);
215         
216         if (toGive > 0) {
217             blacklist[investor] = true;
218         }
219 
220         if (totalDistributed >= totalSupply) {
221             distributionFinished = true;
222         }
223     }
224 
225     function balanceOf(address _owner) constant public returns (uint256) {
226 	    return balances[_owner];
227     }
228 
229     // mitigates the ERC20 short address attack
230     modifier onlyPayloadSize(uint size) {
231         assert(msg.data.length >= size + 4);
232         _;
233     }
234     
235     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
236 
237         require(_to != address(0));
238         require(_amount <= balances[msg.sender]);
239         
240         balances[msg.sender] = balances[msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         Transfer(msg.sender, _to, _amount);
243         return true;
244     }
245     
246     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
247 
248         require(_to != address(0));
249         require(_amount <= balances[_from]);
250         require(_amount <= allowed[_from][msg.sender]);
251         
252         balances[_from] = balances[_from].sub(_amount);
253         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         Transfer(_from, _to, _amount);
256         return true;
257     }
258     
259     function approve(address _spender, uint256 _value) public returns (bool success) {
260         // mitigates the ERC20 spend/approval race condition
261         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
262         allowed[msg.sender][_spender] = _value;
263         Approval(msg.sender, _spender, _value);
264         return true;
265     }
266     
267     function allowance(address _owner, address _spender) constant public returns (uint256) {
268         return allowed[_owner][_spender];
269     }
270     
271     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
272         ForeignToken t = ForeignToken(tokenAddress);
273         uint bal = t.balanceOf(who);
274         return bal;
275     }
276     
277     function withdraw() onlyOwner public {
278         uint256 etherBalance = this.balance;
279         owner.transfer(etherBalance);
280     }
281     
282     function burn(uint256 _value) onlyOwner public {
283         require(_value <= balances[msg.sender]);
284         // no need to require value <= totalSupply, since that would imply the
285         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
286 
287         address burner = msg.sender;
288         balances[burner] = balances[burner].sub(_value);
289         totalSupply = totalSupply.sub(_value);
290         totalDistributed = totalDistributed.sub(_value);
291         Burn(burner, _value);
292     }
293     
294     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
295         ForeignToken token = ForeignToken(_tokenContract);
296         uint256 amount = token.balanceOf(address(this));
297         return token.transfer(owner, amount);
298     }
299 
300 
301 }