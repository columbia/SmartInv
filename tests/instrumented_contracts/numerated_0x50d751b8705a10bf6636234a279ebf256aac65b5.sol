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
52 contract BigWinToken is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "BigWinToken";
62     string public constant symbol = "BWT";
63     uint public constant decimals = 8;
64     
65     uint256 public totalSupply = 20000000000e8;
66     uint256 public totalDistributed = 0;
67     uint256 public totalDistributedi = 15000000000e8;
68     uint256 public unitsOneEthCanBuy = 20000000e8;
69     
70     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
71     uint256 public value;
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
98     function BigWinToken () public {
99         owner = msg.sender;
100        
101         distr(owner, totalDistributedi);
102     }
103     
104     function transferOwnership(address newOwner) onlyOwner public {
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109     
110     function enableWhitelist(address[] addresses) onlyOwner public {
111         for (uint i = 0; i < addresses.length; i++) {
112             blacklist[addresses[i]] = false;
113         }
114     }
115 
116     function disableWhitelist(address[] addresses) onlyOwner public {
117         for (uint i = 0; i < addresses.length; i++) {
118             blacklist[addresses[i]] = true;
119         }
120     }
121 
122     function finishDistribution() onlyOwner canDistr public returns (bool) {
123         distributionFinished = true;
124         DistrFinished();
125         return true;
126     }
127     
128     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
129         totalDistributed = totalDistributed.add(_amount);
130         totalRemaining = totalRemaining.sub(_amount);
131         balances[_to] = balances[_to].add(_amount);
132         Distr(_to, _amount);
133         Transfer(address(0), _to, _amount);
134         return true;
135         
136         if (totalDistributed >= totalSupply) {
137             distributionFinished = true;
138         }
139     }
140     
141     function airdrop(address[] addresses) onlyOwner canDistr public {
142         
143         require(addresses.length <= 255);
144         require(value <= totalRemaining);
145         
146         for (uint i = 0; i < addresses.length; i++) {
147             require(value <= totalRemaining);
148             distr(addresses[i], value);
149         }
150 	
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154     }
155     
156     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
157         
158         require(addresses.length <= 255);
159         require(amount <= totalRemaining);
160         
161         for (uint i = 0; i < addresses.length; i++) {
162             require(amount <= totalRemaining);
163             distr(addresses[i], amount);
164         }
165 	
166         if (totalDistributed >= totalSupply) {
167             distributionFinished = true;
168         }
169     }
170     
171     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
172 
173         require(addresses.length <= 255);
174         require(addresses.length == amounts.length);
175         
176         for (uint8 i = 0; i < addresses.length; i++) {
177             require(amounts[i] <= totalRemaining);
178             distr(addresses[i], amounts[i]);
179             
180             if (totalDistributed >= totalSupply) {
181                 distributionFinished = true;
182             }
183         }
184     }
185     
186     function () external payable {
187             getTokens();
188      }
189     
190     function getTokens() payable canDistr onlyWhitelist public {
191         
192          address investor = msg.sender;
193          uint256 amount = msg.value;
194          require(toGive <= totalRemaining); 
195        
196          
197       uint256 toGive = amount.div(500);
198 
199 
200 	distr(investor, toGive);
201         
202        
203 
204         if (totalDistributed >= totalSupply) {
205             distributionFinished = true;
206         }
207     }
208 
209     function balanceOf(address _owner) constant public returns (uint256) {
210 	    return balances[_owner];
211     }
212 
213     // mitigates the ERC20 short address attack
214     modifier onlyPayloadSize(uint size) {
215         assert(msg.data.length >= size + 4);
216         _;
217     }
218     
219     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
220 
221         require(_to != address(0));
222         require(_amount <= balances[msg.sender]);
223         
224         balances[msg.sender] = balances[msg.sender].sub(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         Transfer(msg.sender, _to, _amount);
227         return true;
228     }
229     
230     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
231 
232         require(_to != address(0));
233         require(_amount <= balances[_from]);
234         require(_amount <= allowed[_from][msg.sender]);
235         
236         balances[_from] = balances[_from].sub(_amount);
237         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         Transfer(_from, _to, _amount);
240         return true;
241     }
242     
243     function approve(address _spender, uint256 _value) public returns (bool success) {
244         // mitigates the ERC20 spend/approval race condition
245         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
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
268         // no need to require value <= totalSupply, since that would imply the
269         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
270 
271         address burner = msg.sender;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         totalDistributed = totalDistributed.sub(_value);
275         Burn(burner, _value);
276     }
277     
278     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
279         ForeignToken token = ForeignToken(_tokenContract);
280         uint256 amount = token.balanceOf(address(this));
281         return token.transfer(owner, amount);
282     }
283 
284 
285 }