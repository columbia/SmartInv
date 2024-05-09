1 //Name     : XENetwork
2 //Symbol   : XEN
3 //Decimal  : 8
4 //Supply   : 1000000 XEN
5 
6 pragma solidity ^0.4.19;
7 
8 
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ForeignToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47     function allowance(address owner, address spender) public constant returns (uint256);
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49     function approve(address spender, uint256 value) public returns (bool);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 interface Token { 
54     function distr(address _to, uint256 _value) public returns (bool);
55     function totalSupply() constant public returns (uint256 supply);
56     function balanceOf(address _owner) constant public returns (uint256 balance);
57 }
58 
59 contract XEN is ERC20 {
60     
61     using SafeMath for uint256;
62     address owner = msg.sender;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     mapping (address => bool) public blacklist;
67 
68     string public constant name = "XENetwork";
69     string public constant symbol = "XEN";
70     uint public constant decimals = 8;
71     
72     uint256 public totalSupply = 1000000e8;
73     uint256 public totalDistributed = 298000e8;
74     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
75     uint256 public value;
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     
80     event Distr(address indexed to, uint256 amount);
81     event DistrFinished();
82     
83     event Burn(address indexed burner, uint256 value);
84 
85     bool public distributionFinished = false;
86     
87     modifier canDistr() {
88         require(!distributionFinished);
89         _;
90     }
91     
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     modifier onlyWhitelist() {
98         require(blacklist[msg.sender] == false);
99         _;
100     }
101     
102     function XEN () public {
103         owner = msg.sender;
104         value = 1e8;
105         distr(owner, totalDistributed);
106     }
107     
108     function transferOwnership(address newOwner) onlyOwner public {
109         if (newOwner != address(0)) {
110             owner = newOwner;
111         }
112     }
113     
114     function enableWhitelist(address[] addresses) onlyOwner public {
115         for (uint i = 0; i < addresses.length; i++) {
116             blacklist[addresses[i]] = false;
117         }
118     }
119 
120     function disableWhitelist(address[] addresses) onlyOwner public {
121         for (uint i = 0; i < addresses.length; i++) {
122             blacklist[addresses[i]] = true;
123         }
124     }
125 
126     function finishDistribution() onlyOwner canDistr public returns (bool) {
127         distributionFinished = true;
128         DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);
134         totalRemaining = totalRemaining.sub(_amount);
135         balances[_to] = balances[_to].add(_amount);
136         Distr(_to, _amount);
137         Transfer(address(0), _to, _amount);
138         return true;
139         
140         if (totalDistributed >= totalSupply) {
141             distributionFinished = true;
142         }
143     }
144     
145     function airdrop(address[] addresses) onlyOwner canDistr public {
146         
147         require(addresses.length <= 255);
148         require(value <= totalRemaining);
149         
150         for (uint i = 0; i < addresses.length; i++) {
151             require(value <= totalRemaining);
152             distr(addresses[i], value);
153         }
154 	
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158     }
159     
160     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
161         
162         require(addresses.length <= 255);
163         require(amount <= totalRemaining);
164         
165         for (uint i = 0; i < addresses.length; i++) {
166             require(amount <= totalRemaining);
167             distr(addresses[i], amount);
168         }
169 	
170         if (totalDistributed >= totalSupply) {
171             distributionFinished = true;
172         }
173     }
174     
175     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
176 
177         require(addresses.length <= 255);
178         require(addresses.length == amounts.length);
179         
180         for (uint8 i = 0; i < addresses.length; i++) {
181             require(amounts[i] <= totalRemaining);
182             distr(addresses[i], amounts[i]);
183             
184             if (totalDistributed >= totalSupply) {
185                 distributionFinished = true;
186             }
187         }
188     }
189     
190     function () external payable {
191             getTokens();
192      }
193     
194     function getTokens() payable canDistr onlyWhitelist public {
195         
196         if (value > totalRemaining) {
197             value = totalRemaining;
198         }
199         
200         require(value <= totalRemaining);
201         
202         address investor = msg.sender;
203         uint256 toGive = value;
204         
205         distr(investor, toGive);
206         
207         if (toGive > 0) {
208             blacklist[investor] = true;
209         }
210 
211         if (totalDistributed >= totalSupply) {
212             distributionFinished = true;
213         }
214         
215         value = value.div(100000).mul(99999);
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