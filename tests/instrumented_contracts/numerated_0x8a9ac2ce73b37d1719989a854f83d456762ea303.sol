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
52 contract ORACON is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "ORACON";
62     string public constant symbol = "ORC";
63     uint public constant decimals = 18;
64     
65     uint256 public totalSupply = 200000000e18;
66     uint256 private totalReserved = (totalSupply.div(100)).mul(10);
67     uint256 private totalBounties = (totalSupply.div(100)).mul(25);
68     uint256 public totalDistributed = totalReserved.add(totalBounties);
69     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
70     uint256 public value;
71     uint256 public minReq;
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     
76     event Distr(address indexed to, uint256 amount);
77     event DistrFinished();
78     
79     event Burn(address indexed burner, uint256 value);
80 
81     bool public distributionFinished = false;
82     
83     modifier canDistr() {
84         require(!distributionFinished);
85         _;
86     }
87     
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     modifier onlyWhitelist() {
94         require(blacklist[msg.sender] == false);
95         _;
96     }
97     
98     function ORACON (uint256 _value, uint256 _minReq) public {
99         owner = msg.sender;
100         value = _value;
101         minReq = _minReq;
102         balances[msg.sender] = totalDistributed;
103     }
104     
105      function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {
106         value = _value;
107         minReq = _minReq;
108     }
109 
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115     
116     function enableWhitelist(address[] addresses) onlyOwner public {
117         for (uint i = 0; i < addresses.length; i++) {
118             blacklist[addresses[i]] = false;
119         }
120     }
121 
122     function disableWhitelist(address[] addresses) onlyOwner public {
123         for (uint i = 0; i < addresses.length; i++) {
124             blacklist[addresses[i]] = true;
125         }
126     }
127 
128     function finishDistribution() onlyOwner canDistr public returns (bool) {
129         distributionFinished = true;
130         DistrFinished();
131         return true;
132     }
133     
134     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
135         totalDistributed = totalDistributed.add(_amount);
136         totalRemaining = totalRemaining.sub(_amount);
137         balances[_to] = balances[_to].add(_amount);
138         Distr(_to, _amount);
139         Transfer(address(0), _to, _amount);
140         return true;
141         
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145     }
146     
147     function airdrop(address[] addresses) onlyOwner canDistr public {
148         
149         require(addresses.length <= 255);
150         require(value <= totalRemaining);
151         
152         for (uint i = 0; i < addresses.length; i++) {
153             require(value <= totalRemaining);
154             distr(addresses[i], value);
155         }
156 	
157         if (totalDistributed >= totalSupply) {
158             distributionFinished = true;
159         }
160     }
161     
162     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
163         
164         require(addresses.length <= 255);
165         require(amount <= totalRemaining);
166         
167         for (uint i = 0; i < addresses.length; i++) {
168             require(amount <= totalRemaining);
169             distr(addresses[i], amount);
170         }
171 	
172         if (totalDistributed >= totalSupply) {
173             distributionFinished = true;
174         }
175     }
176     
177     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
178 
179         require(addresses.length <= 255);
180         require(addresses.length == amounts.length);
181         
182         for (uint8 i = 0; i < addresses.length; i++) {
183             require(amounts[i] <= totalRemaining);
184             distr(addresses[i], amounts[i]);
185             
186             if (totalDistributed >= totalSupply) {
187                 distributionFinished = true;
188             }
189         }
190     }
191     
192     function () external payable {
193             getTokens();
194      }
195     
196     function getTokens() payable canDistr onlyWhitelist public {
197         
198         require(value <= totalRemaining);
199         
200         address investor = msg.sender;
201         uint256 toGive = value;
202         
203         if (msg.value < minReq){
204             toGive = value.sub(value);
205         }
206         
207         distr(investor, toGive);
208         
209         if (toGive > 0) {
210             blacklist[investor] = true;
211         }
212 
213         if (totalDistributed >= totalSupply) {
214             distributionFinished = true;
215         }
216     }
217 
218     function balanceOf(address _owner) constant public returns (uint256) {
219 	    return balances[_owner];
220     }
221 
222     // mitigates the ERC20 short address attack
223     modifier onlyPayloadSize(uint size) {
224         assert(msg.data.length >= size + 4);
225         _;
226     }
227     
228     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
229 
230         require(_to != address(0));
231         require(_amount <= balances[msg.sender]);
232         
233         balances[msg.sender] = balances[msg.sender].sub(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         Transfer(msg.sender, _to, _amount);
236         return true;
237     }
238     
239     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
240 
241         require(_to != address(0));
242         require(_amount <= balances[_from]);
243         require(_amount <= allowed[_from][msg.sender]);
244         
245         balances[_from] = balances[_from].sub(_amount);
246         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         Transfer(_from, _to, _amount);
249         return true;
250     }
251     
252     function approve(address _spender, uint256 _value) public returns (bool success) {
253         // mitigates the ERC20 spend/approval race condition
254         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
255         allowed[msg.sender][_spender] = _value;
256         Approval(msg.sender, _spender, _value);
257         return true;
258     }
259     
260     function allowance(address _owner, address _spender) constant public returns (uint256) {
261         return allowed[_owner][_spender];
262     }
263     
264     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
265         ForeignToken t = ForeignToken(tokenAddress);
266         uint bal = t.balanceOf(who);
267         return bal;
268     }
269     
270     function withdraw() onlyOwner public {
271         uint256 etherBalance = this.balance;
272         owner.transfer(etherBalance);
273     }
274     
275     function burn(uint256 _value) onlyOwner public {
276         require(_value <= balances[msg.sender]);
277         // no need to require value <= totalSupply, since that would imply the
278         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
279 
280         address burner = msg.sender;
281         balances[burner] = balances[burner].sub(_value);
282         totalSupply = totalSupply.sub(_value);
283         totalDistributed = totalDistributed.sub(_value);
284         Burn(burner, _value);
285     }
286     
287     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
288         ForeignToken token = ForeignToken(_tokenContract);
289         uint256 amount = token.balanceOf(address(this));
290         return token.transfer(owner, amount);
291     }
292 
293 
294 }