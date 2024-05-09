1 // Website: http://www.ETERNETWORK.net
2 // Token name: ETERNETWORK
3 // Token Symbol: ETK
4 // Token Decimals: 18
5 
6 pragma solidity ^0.4.25;
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ForeignToken {
33     function balanceOf(address _owner) constant public returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35 }
36 
37 contract ERC20Basic {
38     uint256 public totalSupply;
39     function balanceOf(address who) public constant returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 contract ERC20 is ERC20Basic {
45     function allowance(address owner, address spender) public constant returns (uint256);
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47     function approve(address spender, uint256 value) public returns (bool);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface Token { 
52     function distr(address _to, uint256 _value) external returns (bool);
53     function totalSupply() constant external returns (uint256 supply);
54     function balanceOf(address _owner) constant external returns (uint256 balance);
55 }
56 
57 contract ETERNETWORK is ERC20 {
58 
59  
60     
61     using SafeMath for uint256;
62     address owner = msg.sender;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     mapping (address => bool) public blacklist;
67 
68     string public constant name = "ETERNETWORK";
69     string public constant symbol = "ETK";
70     uint public constant decimals = 18;
71     
72 uint256 public totalSupply = 10000000000e18;
73     
74 uint256 public totalDistributed = 2000000000e18;
75     
76 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
77     
78 uint256 public value = 10000e18;
79 
80 
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     event DistrFinished();
87     
88     event Airdrop(address indexed _owner, uint _amount, uint _balance);
89     
90     event Burn(address indexed burner, uint256 value);
91 
92     bool public distributionFinished = false;
93     
94     modifier canDistr() {
95         require(!distributionFinished);
96         _;
97     }
98     
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     modifier onlyWhitelist() {
105         require(blacklist[msg.sender] == false);
106         _;
107     }
108     
109     constructor() public {
110         owner = msg.sender;
111         balances[owner] = totalDistributed;
112     }
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         emit DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         emit Distr(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132         return true;
133         
134         if (totalDistributed >= totalSupply) {
135             distributionFinished = true;
136         }
137     }
138     
139     function () external payable {
140         getTokens();
141      }
142     
143     function getTokens() payable canDistr onlyWhitelist public {
144         if (value > totalRemaining) {
145             value = totalRemaining;
146         }
147         
148         require(value <= totalRemaining);
149         
150         address investor = msg.sender;
151         uint256 toGive = value;
152         
153         distr(investor, toGive);
154         
155         if (toGive > 0) {
156             blacklist[investor] = true;
157         }
158 
159         if (totalDistributed >= totalSupply) {
160             distributionFinished = true;
161         }
162         
163         value = value.div(100000).mul(99999);
164     }
165     
166     function doAirdrop(address _participant, uint _amount) internal {
167 
168         require( _amount > 0 );      
169 
170         require( totalDistributed < totalSupply );
171         
172         balances[_participant] = balances[_participant].add(_amount);
173         totalDistributed = totalDistributed.add(_amount);
174 
175         if (totalDistributed >= totalSupply) {
176             distributionFinished = true;
177         }
178 
179         // log
180         emit Airdrop(_participant, _amount, balances[_participant]);
181         emit Transfer(address(0), _participant, _amount);
182     }
183 
184     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
185         doAirdrop(_participant, _amount);
186     }
187 
188     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
189         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
190     }
191 
192     function balanceOf(address _owner) constant public returns (uint256) {
193         return balances[_owner];
194     }
195 
196     modifier onlyPayloadSize(uint size) {
197         assert(msg.data.length >= size + 4);
198         _;
199     }
200     
201     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
202         require(_to != address(0));
203         require(_amount <= balances[msg.sender]);
204         
205         balances[msg.sender] = balances[msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(msg.sender, _to, _amount);
208         return true;
209     }
210     
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212         require(_to != address(0));
213         require(_amount <= balances[_from]);
214         require(_amount <= allowed[_from][msg.sender]);
215         
216         balances[_from] = balances[_from].sub(_amount);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(_from, _to, _amount);
220         return true;
221     }
222     
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229     
230     function allowance(address _owner, address _spender) constant public returns (uint256) {
231         return allowed[_owner][_spender];
232     }
233     
234     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
235         ForeignToken t = ForeignToken(tokenAddress);
236         uint bal = t.balanceOf(who);
237         return bal;
238     }
239     
240     function withdraw() onlyOwner public {
241         uint256 etherBalance = address(this).balance;
242         owner.transfer(etherBalance);
243     }
244     
245     function burn(uint256 _value) onlyOwner public {
246         require(_value <= balances[msg.sender]);
247 
248         address burner = msg.sender;
249         balances[burner] = balances[burner].sub(_value);
250         totalSupply = totalSupply.sub(_value);
251         totalDistributed = totalDistributed.sub(_value);
252         emit Burn(burner, _value);
253     }
254     
255     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
256         ForeignToken token = ForeignToken(_tokenContract);
257         uint256 amount = token.balanceOf(address(this));
258         return token.transfer(owner, amount);
259     }
260 }