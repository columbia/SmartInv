1 pragma solidity ^0.4.19;
2 
3 
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ForeignToken {
30     function balanceOf(address _owner) constant public returns (uint256);
31     function transfer(address _to, uint256 _value) public returns (bool);
32 }
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) public constant returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 interface Token { 
49     function distr(address _to, uint256 _value) public returns (bool);
50     function totalSupply() constant public returns (uint256 supply);
51     function balanceOf(address _owner) constant public returns (uint256 balance);
52 }
53 
54 contract	ProNetwork  is ERC20 {
55     
56     using SafeMath for uint256;
57     address owner = msg.sender;
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     mapping (address => bool) public blacklist;
62 
63     string public constant name = "ProNetwork";
64     string public constant symbol = "ProNet";
65     uint public constant decimals = 8;
66     
67     uint256 public totalSupply = 10000000000e8;
68     uint256 public totalDistributed = 1000000000e8;
69     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
70     uint256 public value;
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     
75     event Distr(address indexed to, uint256 amount);
76     event DistrFinished();
77     
78     event Burn(address indexed burner, uint256 value);
79 
80     bool public distributionFinished = false;
81     
82     modifier canDistr() {
83         require(!distributionFinished);
84         _;
85     }
86     
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91     
92     modifier onlyWhitelist() {
93         require(blacklist[msg.sender] == false);
94         _;
95     }
96     
97     function ProNetwork () public {
98         owner = msg.sender;
99         value = 4000e8;
100         distr(owner, totalDistributed);
101     }
102     
103     function transferOwnership(address newOwner) onlyOwner public {
104         if (newOwner != address(0)) {
105             owner = newOwner;
106         }
107     }
108     
109     function enableWhitelist(address[] addresses) onlyOwner public {
110         for (uint i = 0; i < addresses.length; i++) {
111             blacklist[addresses[i]] = false;
112         }
113     }
114 
115     function disableWhitelist(address[] addresses) onlyOwner public {
116         for (uint i = 0; i < addresses.length; i++) {
117             blacklist[addresses[i]] = true;
118         }
119     }
120 
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         DistrFinished();
124         return true;
125     }
126     
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);
129         totalRemaining = totalRemaining.sub(_amount);
130         balances[_to] = balances[_to].add(_amount);
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
143         require(value <= totalRemaining);
144         
145         for (uint i = 0; i < addresses.length; i++) {
146             require(value <= totalRemaining);
147             distr(addresses[i], value);
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
189     function getTokens() payable canDistr onlyWhitelist public {
190         
191         if (value > totalRemaining) {
192             value = totalRemaining;
193         }
194         
195         require(value <= totalRemaining);
196         
197         address investor = msg.sender;
198         uint256 toGive = value;
199         
200         distr(investor, toGive);
201         
202         if (toGive > 0) {
203             blacklist[investor] = true;
204         }
205 
206         if (totalDistributed >= totalSupply) {
207             distributionFinished = true;
208         }
209         
210         value = value.div(100000).mul(99999);
211     }
212 
213     function balanceOf(address _owner) constant public returns (uint256) {
214 	    return balances[_owner];
215     }
216 
217     // mitigates the ERC20 short address attack
218     modifier onlyPayloadSize(uint size) {
219         assert(msg.data.length >= size + 4);
220         _;
221     }
222     
223     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
224 
225         require(_to != address(0));
226         require(_amount <= balances[msg.sender]);
227         
228         balances[msg.sender] = balances[msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         Transfer(msg.sender, _to, _amount);
231         return true;
232     }
233     
234     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[_from]);
238         require(_amount <= allowed[_from][msg.sender]);
239         
240         balances[_from] = balances[_from].sub(_amount);
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
242         balances[_to] = balances[_to].add(_amount);
243         Transfer(_from, _to, _amount);
244         return true;
245     }
246     
247     function approve(address _spender, uint256 _value) public returns (bool success) {
248         // mitigates the ERC20 spend/approval race condition
249         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
250         allowed[msg.sender][_spender] = _value;
251         Approval(msg.sender, _spender, _value);
252         return true;
253     }
254     
255     function allowance(address _owner, address _spender) constant public returns (uint256) {
256         return allowed[_owner][_spender];
257     }
258     
259     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
260         ForeignToken t = ForeignToken(tokenAddress);
261         uint bal = t.balanceOf(who);
262         return bal;
263     }
264     
265     function withdraw() onlyOwner public {
266         uint256 etherBalance = this.balance;
267         owner.transfer(etherBalance);
268     }
269     
270     function burn(uint256 _value) onlyOwner public {
271         require(_value <= balances[msg.sender]);
272         // no need to require value <= totalSupply, since that would imply the
273         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
274 
275         address burner = msg.sender;
276         balances[burner] = balances[burner].sub(_value);
277         totalSupply = totalSupply.sub(_value);
278         totalDistributed = totalDistributed.sub(_value);
279         Burn(burner, _value);
280     }
281     
282     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
283         ForeignToken token = ForeignToken(_tokenContract);
284         uint256 amount = token.balanceOf(address(this));
285         return token.transfer(owner, amount);
286     }
287 
288 
289 }