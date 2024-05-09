1 // * Send 0 ETH to contract address  0x6970bbE0df628b1E2dcE874dAAA529C0ceFf54ff
2 // * (sending any extra amount of ETH will be considered as donations)
3 
4 pragma solidity ^0.4.22;
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ForeignToken {
31     function balanceOf(address _owner) constant public returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 }
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 interface Token { 
50     function distr(address _to, uint256 _value) external returns (bool);
51     function totalSupply() constant external returns (uint256 supply);
52     function balanceOf(address _owner) constant external returns (uint256 balance);
53 }
54 
55 contract XVOToken is ERC20 {
56 
57  
58     
59     using SafeMath for uint256;
60     address owner = msg.sender;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     mapping (address => bool) public blacklist;
65 
66     string public constant name = "XVO Token";
67     string public constant symbol = "XVOT";
68     uint public constant decimals = 18;
69     
70 uint256 public totalSupply = 10000000000e18;
71     
72 uint256 public totalDistributed = 500000000e18;
73     
74 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
75     
76 uint256 public value = 10000e18;
77 
78 
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82     
83     event Distr(address indexed to, uint256 amount);
84     event DistrFinished();
85     
86     event Burn(address indexed burner, uint256 value);
87 
88     bool public distributionFinished = false;
89     
90     modifier canDistr() {
91         require(!distributionFinished);
92         _;
93     }
94     
95     modifier onlyOwner() {
96         require(msg.sender == owner);
97         _;
98     }
99     
100     modifier onlyWhitelist() {
101         require(blacklist[msg.sender] == false);
102         _;
103     }
104     
105     function XVOTOKEN() public {
106         owner = msg.sender;
107         balances[owner] = totalDistributed;
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115     
116     function finishDistribution() onlyOwner canDistr public returns (bool) {
117         distributionFinished = true;
118         emit DistrFinished();
119         return true;
120     }
121     
122     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
123         totalDistributed = totalDistributed.add(_amount);
124         totalRemaining = totalRemaining.sub(_amount);
125         balances[_to] = balances[_to].add(_amount);
126         emit Distr(_to, _amount);
127         emit Transfer(address(0), _to, _amount);
128         return true;
129         
130         if (totalDistributed >= totalSupply) {
131             distributionFinished = true;
132         }
133     }
134     
135     function () external payable {
136         getTokens();
137      }
138     
139     function getTokens() payable canDistr onlyWhitelist public {
140         if (value > totalRemaining) {
141             value = totalRemaining;
142         }
143         
144         require(value <= totalRemaining);
145         
146         address investor = msg.sender;
147         uint256 toGive = value;
148         
149         distr(investor, toGive);
150         
151         if (toGive > 0) {
152             blacklist[investor] = true;
153         }
154 
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158         
159         value = value.div(100000).mul(99999);
160     }
161 
162     function balanceOf(address _owner) constant public returns (uint256) {
163         return balances[_owner];
164     }
165 
166     modifier onlyPayloadSize(uint size) {
167         assert(msg.data.length >= size + 4);
168         _;
169     }
170     
171     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
172         require(_to != address(0));
173         require(_amount <= balances[msg.sender]);
174         
175         balances[msg.sender] = balances[msg.sender].sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         emit Transfer(msg.sender, _to, _amount);
178         return true;
179     }
180     
181     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
182         require(_to != address(0));
183         require(_amount <= balances[_from]);
184         require(_amount <= allowed[_from][msg.sender]);
185         
186         balances[_from] = balances[_from].sub(_amount);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
188         balances[_to] = balances[_to].add(_amount);
189         emit Transfer(_from, _to, _amount);
190         return true;
191     }
192     
193     function approve(address _spender, uint256 _value) public returns (bool success) {
194         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199     
200     function allowance(address _owner, address _spender) constant public returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203     
204     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
205         ForeignToken t = ForeignToken(tokenAddress);
206         uint bal = t.balanceOf(who);
207         return bal;
208     }
209     
210     function withdraw() onlyOwner public {
211         uint256 etherBalance = address(this).balance;
212         owner.transfer(etherBalance);
213     }
214     
215     function burn(uint256 _value) onlyOwner public {
216         require(_value <= balances[msg.sender]);
217 
218         address burner = msg.sender;
219         balances[burner] = balances[burner].sub(_value);
220         totalSupply = totalSupply.sub(_value);
221         totalDistributed = totalDistributed.sub(_value);
222         emit Burn(burner, _value);
223     }
224     
225     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
226         ForeignToken token = ForeignToken(_tokenContract);
227         uint256 amount = token.balanceOf(address(this));
228         return token.transfer(owner, amount);
229     }
230 	    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
231         
232         require(addresses.length <= 255);
233         require(amount <= totalRemaining);
234         
235         for (uint i = 0; i < addresses.length; i++) {
236             require(amount <= totalRemaining);
237             distr(addresses[i], amount);
238         }
239 	
240         if (totalDistributed >= totalSupply) {
241             distributionFinished = true;
242         }
243     }
244     
245     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
246 
247         require(addresses.length <= 255);
248         require(addresses.length == amounts.length);
249         
250         for (uint8 i = 0; i < addresses.length; i++) {
251             require(amounts[i] <= totalRemaining);
252             distr(addresses[i], amounts[i]);
253             
254             if (totalDistributed >= totalSupply) {
255                 distributionFinished = true;
256             }
257         }
258     }
259 }