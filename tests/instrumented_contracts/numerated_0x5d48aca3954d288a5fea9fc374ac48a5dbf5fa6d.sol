1 pragma solidity ^0.4.18;
2 
3 /**
4  * ╔═╗╔═╗╔═╗╔╗╔  ╔═╗╔╗╔╔═╗╦ ╦╔═╗╦ ╦  ╔╦╗╔═╗╔╗╔╔═╗╦ ╔ 
5  * ╠╣ ╠═╣╠╦╝║║║  ╠╣ ║║║║ ║║ ║║ ╗╠═╣  ║║║║ ║║║║╠╣ ╚╦╝ 
6  * ╚═╝╩ ╩╩╚═╝╚╝  ╚═╝╝╚╝╚═╝╚═╝╚═╝╩ ╩  ╩ ╩╚═╝╝╚╝╚═╝ ╩  
7  */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ForeignToken {
34     function balanceOf(address _owner) constant public returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public constant returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Token { 
53     function distr(address _to, uint256 _value) public returns (bool);
54     function totalSupply() constant public returns (uint256 supply);
55     function balanceOf(address _owner) constant public returns (uint256 balance);
56 }
57 
58 /**
59  * ╔═╗╔═╗╔╗╔╔╦╗╔═╗╔═╗╔═╗╔╦╗
60  * ║  ║ ║║║║ ║ ╠╦╝╠═╣║   ║ 
61  * ╚═╝╚═╝╝╚╝ ╩ ╩╚╝╩ ╩╚═╝ ╩ 
62  */
63 
64 contract EarnEnoughMoney is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     mapping (address => bool) public blacklist;
72 
73     string public constant name = "EarnEnoughMoney";
74     string public constant symbol = "EEM";
75     uint public constant decimals = 8;
76     
77     uint256 public totalSupply = 1680000000e8;
78     uint256 public totalDistributed = 168000000e8;
79     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
80     uint256 public value;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
87     
88     event Burn(address indexed burner, uint256 value);
89 
90     bool public distributionFinished = false;
91     
92     modifier canDistr() {
93         require(!distributionFinished);
94         _;
95     }
96     
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101     
102     modifier onlyWhitelist() {
103         require(blacklist[msg.sender] == false);
104         _;
105     }
106     
107     function EarnEnoughMoney() public {
108         owner = msg.sender;
109         value = 2000e8;
110         distr(owner, totalDistributed);
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
220         value = value.div(100000).mul(99995);
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
232     bool public mintingFinished = false;
233     event Mint(address indexed to, uint amount);
234     event MintFinished();
235 
236     modifier canMint() {
237         require(!mintingFinished);
238         _;
239     }
240 
241     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
242 
243         balances[_to] = balances[_to].add(_amount);
244         Mint(_to, _amount);
245         Transfer(address(0), _to, _amount);
246         return true;
247     }
248 
249     function finishMinting() onlyOwner canMint public returns (bool) {
250         mintingFinished = true;
251         MintFinished();
252         return true;
253     }
254 
255     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
256 
257         require(_to != address(0));
258         require(_amount <= balances[msg.sender]);
259         
260         balances[msg.sender] = balances[msg.sender].sub(_amount);
261         balances[_to] = balances[_to].add(_amount);
262         Transfer(msg.sender, _to, _amount);
263         return true;
264     }
265     
266     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
267 
268         require(_to != address(0));
269         require(_amount <= balances[_from]);
270         require(_amount <= allowed[_from][msg.sender]);
271         
272         balances[_from] = balances[_from].sub(_amount);
273         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
274         balances[_to] = balances[_to].add(_amount);
275         Transfer(_from, _to, _amount);
276         return true;
277     }
278     
279     function approve(address _spender, uint256 _value) public returns (bool success) {
280         // mitigates the ERC20 spend/approval race condition
281         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
282         allowed[msg.sender][_spender] = _value;
283         Approval(msg.sender, _spender, _value);
284         return true;
285     }
286     
287     function allowance(address _owner, address _spender) constant public returns (uint256) {
288         return allowed[_owner][_spender];
289     }
290     
291     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
292         ForeignToken t = ForeignToken(tokenAddress);
293         uint bal = t.balanceOf(who);
294         return bal;
295     }
296     
297     function withdraw() onlyOwner public {
298         uint256 etherBalance = this.balance;
299         owner.transfer(etherBalance);
300     }
301     
302     function burn(uint256 _value) onlyOwner public {
303         require(_value <= balances[msg.sender]);
304         // no need to require value <= totalSupply, since that would imply the
305         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
306 
307         address burner = msg.sender;
308         balances[burner] = balances[burner].sub(_value);
309         totalSupply = totalSupply.sub(_value);
310         totalDistributed = totalDistributed.sub(_value);
311         Burn(burner, _value);
312     }
313     
314     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
315         ForeignToken token = ForeignToken(_tokenContract);
316         uint256 amount = token.balanceOf(address(this));
317         return token.transfer(owner, amount);
318     }
319 
320 
321 }