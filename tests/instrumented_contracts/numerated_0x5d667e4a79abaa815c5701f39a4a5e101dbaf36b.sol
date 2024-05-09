1 pragma solidity ^0.4.18;
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
52 contract Dasabi_ioToken is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "dasabi.io Token";
62     string public constant symbol = "SBi";
63     uint public constant decimals = 18;
64     
65     uint256 public totalSupply = 1000000000e18;
66     uint256 public totalDistributed;
67     uint256 public totalRemaining = 1000000000e18;
68     uint256 public candy;
69 	uint256 public tokenPrice = 2e13;
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
96     function Dasabi_ioToken () public {
97         owner = msg.sender;
98         candy = 80e18;
99         distr(owner, 500000000e18);
100     }
101     
102     function transferOwnership(address newOwner) onlyOwner public {
103         if (newOwner != address(0)) {
104             owner = newOwner;
105         }
106     }
107     
108     function enableWhitelist(address[] addresses) onlyOwner public {
109         for (uint i = 0; i < addresses.length; i++) {
110             blacklist[addresses[i]] = false;
111         }
112     }
113 
114     function disableWhitelist(address[] addresses) onlyOwner public {
115         for (uint i = 0; i < addresses.length; i++) {
116             blacklist[addresses[i]] = true;
117         }
118     }
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130        
131         Distr(_to, _amount);
132         Transfer(address(0), _to, _amount);
133         return true;
134         
135         if (totalDistributed >= totalSupply) {
136             distributionFinished = true;
137         }
138     }
139     
140     function airdrop(address[] addresses) onlyOwner canDistr public {
141         
142         require(addresses.length <= 255);
143         require(candy <= totalRemaining);
144         
145         for (uint i = 0; i < addresses.length; i++) {
146             require(candy <= totalRemaining);
147             distr(addresses[i], candy);
148         }
149 	
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153     }
154     
155     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
156         
157         require(addresses.length <= 255);
158         require(amount <= totalRemaining);
159         
160         for (uint i = 0; i < addresses.length; i++) {
161             require(amount <= totalRemaining);
162             distr(addresses[i], amount);
163         }
164 	
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168     }
169     
170     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
171 
172         require(addresses.length <= 255);
173         require(addresses.length == amounts.length);
174         
175         for (uint8 i = 0; i < addresses.length; i++) {
176             require(amounts[i] <= totalRemaining);
177             distr(addresses[i], amounts[i]);
178             
179             if (totalDistributed >= totalSupply) {
180                 distributionFinished = true;
181             }
182         }
183     }
184     
185     function () external payable {
186             getTokens();
187      }
188     
189     function getTokens() payable canDistr public {
190         
191         if (candy > totalRemaining) {
192             candy = totalRemaining;
193         }
194         
195         require(candy <= totalRemaining);
196         
197         address investor = msg.sender;
198         uint256 toGive = candy;
199         uint256 FreetoGive = candy;
200         
201         if (msg.value > 0) {
202         	toGive = msg.value * 1e18 / tokenPrice;
203         	distr(investor, toGive);
204         }
205         
206         if(!blacklist[msg.sender]){
207 		        
208 	        distr(investor, FreetoGive);
209 	        blacklist[investor] = true;
210 	
211 	        if (totalDistributed >= totalSupply) {
212 	            distributionFinished = true;
213 	        }
214         }
215         
216         candy = candy.div(10000).mul(9999);
217         
218         if(totalRemaining>0){
219             tokenPrice = tokenPrice.mul(totalDistributed).div(totalRemaining);
220         }
221         
222     }
223 
224     function balanceOf(address _owner) constant public returns (uint256) {
225 	    return balances[_owner];
226     }
227 
228     // mitigates the ERC20 short address attack
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233     
234     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[msg.sender]);
238         
239         balances[msg.sender] = balances[msg.sender].sub(_amount);
240         balances[_to] = balances[_to].add(_amount);
241         Transfer(msg.sender, _to, _amount);
242         return true;
243     }
244     
245     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
246 
247         require(_to != address(0));
248         require(_amount <= balances[_from]);
249         require(_amount <= allowed[_from][msg.sender]);
250         
251         balances[_from] = balances[_from].sub(_amount);
252         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         Transfer(_from, _to, _amount);
255         return true;
256     }
257     
258     function approve(address _spender, uint256 _value) public returns (bool success) {
259         // mitigates the ERC20 spend/approval race condition
260         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
261         allowed[msg.sender][_spender] = _value;
262         Approval(msg.sender, _spender, _value);
263         return true;
264     }
265     
266     function allowance(address _owner, address _spender) constant public returns (uint256) {
267         return allowed[_owner][_spender];
268     }
269     
270     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
271         ForeignToken t = ForeignToken(tokenAddress);
272         uint bal = t.balanceOf(who);
273         return bal;
274     }
275     
276     function withdraw() onlyOwner public {
277         uint256 etherBalance = this.balance;
278         owner.transfer(etherBalance);
279     }
280     
281     function burn(uint256 _value) onlyOwner public {
282         require(_value <= balances[msg.sender]);
283         // no need to require value <= totalSupply, since that would imply the
284         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
285 
286         address burner = msg.sender;
287         balances[burner] = balances[burner].sub(_value);
288         totalSupply = totalSupply.sub(_value);
289         totalDistributed = totalDistributed.sub(_value);
290         Burn(burner, _value);
291     }
292     
293     function Remain_burn(uint256 _value) onlyOwner public {
294         require(_value <= totalRemaining);
295 		totalRemaining = totalRemaining.sub(_value);
296         totalSupply = totalSupply.sub(_value);
297     }
298     
299     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
300         ForeignToken token = ForeignToken(_tokenContract);
301         uint256 amount = token.balanceOf(address(this));
302         return token.transfer(owner, amount);
303     }
304 
305 
306 }