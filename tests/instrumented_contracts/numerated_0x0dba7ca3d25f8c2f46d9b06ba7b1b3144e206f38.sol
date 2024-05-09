1 pragma solidity ^0.4.18;
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
29     function balanceOf(address _0x395d5881be6ca42d96ba01a2de69416f10cebe29) constant public returns (uint256);
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
53 contract BFTToken is ERC20 {
54     
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61     string public constant name = "Burma first token";
62     string public constant symbol = "BFT";
63     uint public constant decimals = 8;
64     
65     uint256 public totalSupply = 1000000000e8;
66     uint256 public totalDistributed = 300000000e8;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
68     uint256 public value;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     
76     event Burn(address indexed burner, uint256 value);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == 0x395d5881be6ca42d96ba01a2de69416f10cebe29);
87         _;
88     }
89     
90     modifier onlyWhitelist() {
91         require(blacklist[msg.sender] == false);
92         _;
93     }
94     
95     function BFTcoin () public {
96         owner = msg.sender;
97         value = 5000e8;
98         distr(0x395d5881be6ca42d96ba01a2de69416f10cebe29, totalDistributed);
99     }
100     
101     function transferOwnership(address newOwner) onlyOwner public {
102         if (newOwner != address(0)) {
103             owner = newOwner;
104         }
105     }
106     
107     function enableWhitelist(address[] addresses) onlyOwner public {
108         for (uint i = 0; i < addresses.length; i++) {
109             blacklist[addresses[i]] = false;
110         }
111     }
112 
113     function disableWhitelist(address[] addresses) onlyOwner public {
114         for (uint i = 0; i < addresses.length; i++) {
115             blacklist[addresses[i]] = true;
116         }
117     }
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         DistrFinished();
122         return true;
123     }
124     
125     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126         totalDistributed = totalDistributed.add(_amount);
127         totalRemaining = totalRemaining.sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         Distr(_to, _amount);
130         Transfer(address(0), _to, _amount);
131         return true;
132         
133         if (totalDistributed >= totalSupply) {
134             distributionFinished = true;
135         }
136     }
137     
138     function airdrop(address[] addresses) onlyOwner canDistr public {
139         
140         require(addresses.length <= 255);
141         require(value <= totalRemaining);
142         
143         for (uint i = 0; i < addresses.length; i++) {
144             require(value <= totalRemaining);
145             distr(addresses[i], value);
146         }
147 	
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151     }
152     
153     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
154         
155         require(addresses.length <= 255);
156         require(amount <= totalRemaining);
157         
158         for (uint i = 0; i < addresses.length; i++) {
159             require(amount <= totalRemaining);
160             distr(addresses[i], amount);
161         }
162 	
163         if (totalDistributed >= totalSupply) {
164             distributionFinished = true;
165         }
166     }
167     
168     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
169 
170         require(addresses.length <= 255);
171         require(addresses.length == amounts.length);
172         
173         for (uint8 i = 0; i < addresses.length; i++) {
174             require(amounts[i] <= totalRemaining);
175             distr(addresses[i], amounts[i]);
176             
177             if (totalDistributed >= totalSupply) {
178                 distributionFinished = true;
179             }
180         }
181     }
182     
183     function () external payable {
184             getTokens();
185      }
186     
187     function getTokens() payable canDistr onlyWhitelist public {
188         
189         if (value > totalRemaining) {
190             value = totalRemaining;
191         }
192         
193         require(value <= totalRemaining);
194         
195         address investor = msg.sender;
196         uint256 toGive = value;
197         
198         distr(investor, toGive);
199         
200         if (toGive > 0) {
201             blacklist[investor] = true;
202         }
203 
204         if (totalDistributed >= totalSupply) {
205             distributionFinished = true;
206         }
207         
208         value = value.div(100000).mul(99999);
209     }
210 
211     function balanceOf(address _owner) constant public returns (uint256) {
212 	    return balances[_owner];
213     }
214 
215     // mitigates the ERC20 short address attack
216     modifier onlyPayloadSize(uint size) {
217         assert(msg.data.length >= size + 4);
218         _;
219     }
220     
221     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
222 
223         require(_to != address(0));
224         require(_amount <= balances[msg.sender]);
225         
226         balances[msg.sender] = balances[msg.sender].sub(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         Transfer(msg.sender, _to, _amount);
229         return true;
230     }
231     
232     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
233 
234         require(_to != address(0));
235         require(_amount <= balances[_from]);
236         require(_amount <= allowed[_from][msg.sender]);
237         
238         balances[_from] = balances[_from].sub(_amount);
239         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
240         balances[_to] = balances[_to].add(_amount);
241         Transfer(_from, _to, _amount);
242         return true;
243     }
244     
245     function approve(address _spender, uint256 _value) public returns (bool success) {
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248         return true;
249     }
250     
251     function allowance(address _owner, address _spender) constant public returns (uint256) {
252         return allowed[_owner][_spender];
253     }
254     
255     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
256         ForeignToken t = ForeignToken(tokenAddress);
257         uint bal = t.balanceOf(who);
258         return bal;
259     }
260     
261     function withdraw() onlyOwner public {
262         uint256 etherBalance = this.balance;
263         owner.transfer(etherBalance);
264     }
265     
266     function burn(uint256 _value) onlyOwner public {
267         require(_value <= balances[msg.sender]);
268 
269         address burner = msg.sender;
270         balances[burner] = balances[burner].sub(_value);
271         totalSupply = totalSupply.sub(_value);
272         totalDistributed = totalDistributed.sub(_value);
273         Burn(burner, _value);
274     }
275     
276     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
277         ForeignToken token = ForeignToken(_tokenContract);
278         uint256 amount = token.balanceOf(address(this));
279         return token.transfer(owner, amount);
280     }
281     
282     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
283         allowed[msg.sender][_spender] = _value;
284         Approval(msg.sender, _spender, _value);
285         
286         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
287         return true;
288     }
289 
290 }