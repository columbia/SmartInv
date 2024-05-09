1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
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
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() constant external returns (uint256 supply);
49     function balanceOf(address _owner) constant external returns (uint256 balance);
50 }
51 
52 contract GTIX is ERC20 {
53 
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "GT-IX";
62     string public constant symbol = "GTIX";
63     uint public constant decimals = 8;
64     uint256 public totalSupply = 50000000000e8;
65     uint256 public totalDistributed = 2000000000e8;
66 	uint256 public totalPurchase = 2000000000e8;
67     uint256 public totalRemaining = totalSupply.sub(totalDistributed).sub(totalPurchase);
68 	
69     uint256 public value = 2500e8;
70 	uint256 public purchaseCardinal = 50000000e8;
71 	
72 	uint256 public minPurchase = 0.001e18;
73 	uint256 public maxPurchase = 10e18;
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 
78     event Distr(address indexed to, uint256 amount);
79     event DistrFinished();
80 	event Purchase(address indexed to, uint256 amount);
81 	event PurchaseFinished();
82 
83     event Burn(address indexed burner, uint256 value);
84 
85     bool public distributionFinished = false;
86 	bool public purchaseFinished = false;
87 
88     modifier canDistr() {
89         require(!distributionFinished);
90         _;
91     }
92 	
93 	modifier canPurchase(){
94 		require(!purchaseFinished);
95 		_;
96 	}
97 
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     modifier onlyWhitelist() {
104         require(blacklist[msg.sender] == false);
105         _;
106     }
107 
108     function Constructor() public {
109         owner = msg.sender;
110         balances[owner] = totalDistributed;
111     }
112 
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124 	
125 	function finishedPurchase() onlyOwner canPurchase public returns (bool) {
126 		purchaseFinished = true;
127 		emit PurchaseFinished();
128 		return true;
129 	}
130 
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalRemaining = totalRemaining.sub(_amount);
133         balances[_to] = balances[_to].add(_amount);
134         emit Distr(_to, _amount);
135         emit Transfer(address(0), _to, _amount);
136         return true;
137     }
138 	
139 	function purch(address _to,uint256 _amount) canPurchase private returns (bool){
140 		totalPurchase = totalPurchase.sub(_amount);
141 		balances[_to] = balances[_to].add(_amount);
142 		emit Purchase(_to, _amount);
143 		emit Transfer(address(0), _to, _amount);
144 		return true;
145 	}
146 
147     function () external payable {
148 		if (msg.value >= minPurchase){
149 			purchaseTokens();
150 		}else{
151 			airdropTokens();
152 		}
153     }
154 
155 	function purchaseTokens() payable canPurchase public {
156 		uint256 recive = msg.value;
157 		require(recive >= minPurchase && recive <= maxPurchase);
158 
159         // 0.001 - 0.01 10%;
160 		// 0.01 - 0.05 20%;
161 		// 0.05 - 0.1 30%;
162 		// 0.1 - 0.5 50%;
163 		// 0.5 - 1 100%;
164 		uint256 amount;
165 		amount = recive.mul(purchaseCardinal);
166 		uint256 bonus;
167 		if (recive >= 0.001e18 && recive < 0.01e18){
168 			bonus = amount.mul(1).div(10);
169 		}else if(recive >= 0.01e18 && recive < 0.05e18){
170 			bonus = amount.mul(2).div(10);
171 		}else if(recive >= 0.05e18 && recive < 0.1e18){
172 			bonus = amount.mul(3).div(10);
173 		}else if(recive >= 0.1e18 && recive < 0.5e18){
174 			bonus = amount.mul(5).div(10);
175 		}else if(recive >= 0.5e18){
176 			bonus = amount;
177 		}
178 		
179 		amount = amount.add(bonus).div(1e18);
180 		
181 		require(amount <= totalPurchase);
182 		
183 		purch(msg.sender, amount);
184 	}
185 	
186     function airdropTokens() payable canDistr onlyWhitelist public {
187         if (value > totalRemaining) {
188             value = totalRemaining;
189         }
190 
191         require(value <= totalRemaining);
192 
193         address investor = msg.sender;
194         uint256 toGive = value;
195 		
196 		distr(investor, toGive);
197 		
198 		if (toGive > 0) {
199 			blacklist[investor] = true;
200 		}
201 
202         if (totalDistributed >= totalSupply) {
203             distributionFinished = true;
204         }
205 
206         value = value.div(100000).mul(99999);
207     }
208 
209     function balanceOf(address _owner) constant public returns (uint256) {
210         return balances[_owner];
211     }
212 
213     modifier onlyPayloadSize(uint size) {
214         assert(msg.data.length >= size + 4);
215         _;
216     }
217 
218     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
219         require(_to != address(0));
220         require(_amount <= balances[msg.sender]);
221 
222         balances[msg.sender] = balances[msg.sender].sub(_amount);
223         balances[_to] = balances[_to].add(_amount);
224         emit Transfer(msg.sender, _to, _amount);
225         return true;
226     }
227 
228     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
229         require(_to != address(0));
230         require(_amount <= balances[_from]);
231         require(_amount <= allowed[_from][msg.sender]);
232 
233         balances[_from] = balances[_from].sub(_amount);
234         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
235         balances[_to] = balances[_to].add(_amount);
236         emit Transfer(_from, _to, _amount);
237         return true;
238     }
239 
240     function approve(address _spender, uint256 _value) public returns (bool success) {
241         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247     function allowance(address _owner, address _spender) constant public returns (uint256) {
248         return allowed[_owner][_spender];
249     }
250 
251     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
252         ForeignToken t = ForeignToken(tokenAddress);
253         uint bal = t.balanceOf(who);
254         return bal;
255     }
256 
257     function withdraw() onlyOwner public {
258         uint256 etherBalance = address(this).balance;
259         owner.transfer(etherBalance);
260     }
261 
262     function burn(uint256 _value) onlyOwner public {
263         require(_value <= balances[msg.sender]);
264 
265         address burner = msg.sender;
266         balances[burner] = balances[burner].sub(_value);
267         totalSupply = totalSupply.sub(_value);
268         totalDistributed = totalDistributed.sub(_value);
269         emit Burn(burner, _value);
270     }
271 	
272 	function burnPurchase(uint256 _value) onlyOwner public {
273 		require(_value <= totalPurchase);
274 		
275 		totalSupply = totalSupply.sub(_value);
276 		totalPurchase = totalPurchase.sub(_value);
277 		
278 		emit Burn(msg.sender, _value);
279 	}
280 
281     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
282         ForeignToken token = ForeignToken(_tokenContract);
283         uint256 amount = token.balanceOf(address(this));
284         return token.transfer(owner, amount);
285     }
286 	
287 	function withdrawToken(address _to,uint256 _amount) onlyOwner public returns(bool){
288         require(_amount <= totalRemaining);
289         
290         return distr(_to,_amount);
291     }
292 }