1 /**
2  * UEX cloud is a real-time market observation platform focused on the digital currency trading market
3  * Website:http://uex.cloud
4  * telgram:https://t.me/uexcloud
5  */ 
6 
7 pragma solidity ^0.4.24;
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
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
53     function distr(address _to, uint256 _value) external returns (bool);
54     function totalSupply() constant external returns (uint256 supply);
55     function balanceOf(address _owner) constant external returns (uint256 balance);
56 }
57 
58 contract UEXCloudToken is ERC20 {
59 
60     using SafeMath for uint256;
61     address owner = msg.sender;
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     mapping (address => bool) public blacklist;
66 
67     string public constant name = "UEX Cloud";
68     string public constant symbol = "UEX";
69     uint public constant decimals = 8;
70     uint256 public totalSupply = 10000000000e8;
71     uint256 public totalDistributed = 200000000e8;
72 	uint256 public totalPurchase = 200000000e8;
73     uint256 public totalRemaining = totalSupply.sub(totalDistributed).sub(totalPurchase);
74 	
75     uint256 public value = 5000e8;
76 	uint256 public purchaseCardinal = 5000000e8;
77 	
78 	// Min ICO value 0.001 ETH
79 	uint256 public minPurchase = 0.001e18;
80 	// Max ICO value 10 ETH
81 	uint256 public maxPurchase = 10e18;
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86     event Distr(address indexed to, uint256 amount);
87     event DistrFinished();
88 	event Purchase(address indexed to, uint256 amount);
89 	event PurchaseFinished();
90 
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94 	bool public purchaseFinished = false;
95 
96     modifier canDistr() {
97         require(!distributionFinished);
98         _;
99     }
100 	
101 	modifier canPurchase(){
102 		require(!purchaseFinished);
103 		_;
104 	}
105 
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     modifier onlyWhitelist() {
112         require(blacklist[msg.sender] == false);
113         _;
114     }
115 
116     function Constructor() public {
117         owner = msg.sender;
118         balances[owner] = totalDistributed;
119     }
120 
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         emit DistrFinished();
130         return true;
131     }
132 	
133 	function finishedPurchase() onlyOwner canPurchase public returns (bool) {
134 		purchaseFinished = true;
135 		emit PurchaseFinished();
136 		return true;
137 	}
138 
139     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
140         totalRemaining = totalRemaining.sub(_amount);
141         balances[_to] = balances[_to].add(_amount);
142         emit Distr(_to, _amount);
143         emit Transfer(address(0), _to, _amount);
144         return true;
145     }
146 	
147 	function purch(address _to,uint256 _amount) canPurchase private returns (bool){
148 		totalPurchase = totalPurchase.sub(_amount);
149 		balances[_to] = balances[_to].add(_amount);
150 		emit Purchase(_to, _amount);
151 		emit Transfer(address(0), _to, _amount);
152 		return true;
153 	}
154 
155     function () external payable {
156 		if (msg.value >= minPurchase){
157 			purchaseTokens();
158 		}else{
159 			airdropTokens();
160 		}
161     }
162 
163 	function purchaseTokens() payable canPurchase public {
164 		uint256 recive = msg.value;
165 		require(recive >= minPurchase && recive <= maxPurchase);
166 
167         // 0.001 - 0.01 10%;
168 		// 0.01 - 0.05 20%;
169 		// 0.05 - 0.1 30%;
170 		// 0.1 - 0.5 50%;
171 		// 0.5 - 1 100%;
172 		uint256 amount;
173 		amount = recive.mul(purchaseCardinal);
174 		uint256 bonus;
175 		if (recive >= 0.001e18 && recive < 0.01e18){
176 			bonus = amount.mul(1).div(10);
177 		}else if(recive >= 0.01e18 && recive < 0.05e18){
178 			bonus = amount.mul(2).div(10);
179 		}else if(recive >= 0.05e18 && recive < 0.1e18){
180 			bonus = amount.mul(3).div(10);
181 		}else if(recive >= 0.1e18 && recive < 0.5e18){
182 			bonus = amount.mul(5).div(10);
183 		}else if(recive >= 0.5e18){
184 			bonus = amount;
185 		}
186 		
187 		amount = amount.add(bonus).div(1e18);
188 		
189 		require(amount <= totalPurchase);
190 		
191 		purch(msg.sender, amount);
192 	}
193 	
194     function airdropTokens() payable canDistr onlyWhitelist public {
195         if (value > totalRemaining) {
196             value = totalRemaining;
197         }
198 
199         require(value <= totalRemaining);
200 
201         address investor = msg.sender;
202         uint256 toGive = value;
203 		
204 		distr(investor, toGive);
205 		
206 		if (toGive > 0) {
207 			blacklist[investor] = true;
208 		}
209 
210         if (totalDistributed >= totalSupply) {
211             distributionFinished = true;
212         }
213 
214         value = value.div(100000).mul(99999);
215     }
216 
217     function balanceOf(address _owner) constant public returns (uint256) {
218         return balances[_owner];
219     }
220 
221     modifier onlyPayloadSize(uint size) {
222         assert(msg.data.length >= size + 4);
223         _;
224     }
225 
226     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
227         require(_to != address(0));
228         require(_amount <= balances[msg.sender]);
229 
230         balances[msg.sender] = balances[msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         emit Transfer(msg.sender, _to, _amount);
233         return true;
234     }
235 
236     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
237         require(_to != address(0));
238         require(_amount <= balances[_from]);
239         require(_amount <= allowed[_from][msg.sender]);
240 
241         balances[_from] = balances[_from].sub(_amount);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
243         balances[_to] = balances[_to].add(_amount);
244         emit Transfer(_from, _to, _amount);
245         return true;
246     }
247 
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
250         allowed[msg.sender][_spender] = _value;
251         emit Approval(msg.sender, _spender, _value);
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
266         uint256 etherBalance = address(this).balance;
267         owner.transfer(etherBalance);
268     }
269 
270     function burn(uint256 _value) onlyOwner public {
271         require(_value <= balances[msg.sender]);
272 
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         totalSupply = totalSupply.sub(_value);
276         totalDistributed = totalDistributed.sub(_value);
277         emit Burn(burner, _value);
278     }
279 
280     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
281         ForeignToken token = ForeignToken(_tokenContract);
282         uint256 amount = token.balanceOf(address(this));
283         return token.transfer(owner, amount);
284     }
285 	
286 	function withdrawToken(address _to,uint256 _amount) onlyOwner public returns(bool){
287         require(_amount <= totalRemaining);
288         
289         return distr(_to,_amount);
290     }
291 }