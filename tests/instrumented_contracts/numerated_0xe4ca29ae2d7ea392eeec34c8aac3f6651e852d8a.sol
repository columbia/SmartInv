1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
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
49 contract CATREUM is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "CATREUM";
58     string public constant symbol = "CATR";
59     uint public constant decimals = 8;
60     
61     uint256 public totalSupply = 1000000000e8;
62     uint256 public totalDistributed;    
63     uint256 public constant MinimumParticipate = 1 ether / 100;
64     uint256 public tokensPerEth = 1200000e8;
65 
66     address multisig = msg.sender;
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     event Distr(address indexed to, uint256 amount);
71     event DistrFinished();
72     event Airdrop(address indexed _owner, uint _amount, uint _balance);
73     event TokensPerEthUpdated(uint _tokensPerEth);
74     event Burn(address indexed burner, uint256 value);
75     event Send(uint256 _amount, address indexed _receiver);
76 
77     bool public distributionFinished = false;
78     
79     modifier canDistr() {
80         require(!distributionFinished);
81         _;
82     }
83     
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88     
89     constructor() public {
90         uint256 teamFund = 100000000e8;
91         owner = msg.sender;
92         distr(owner, teamFund);
93     }
94     
95     function transferOwnership(address newOwner) onlyOwner public {
96         if (newOwner != address(0)) {
97             owner = newOwner;
98         }
99     }   
100 
101     function finishDistribution() onlyOwner canDistr public returns (bool) {
102         distributionFinished = true;
103         emit DistrFinished();
104         return true;
105     }
106     
107     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
108         totalDistributed = totalDistributed.add(_amount);        
109         balances[_to] = balances[_to].add(_amount);
110         emit Distr(_to, _amount);
111         emit Transfer(address(0), _to, _amount);
112 
113         return true;
114     }
115 
116     function doAirdrop(address _participant, uint _amount) internal {
117 
118         require( _amount > 0 );      
119 
120         require( totalDistributed < totalSupply );
121         
122         balances[_participant] = balances[_participant].add(_amount);
123         totalDistributed = totalDistributed.add(_amount);
124 
125         if (totalDistributed >= totalSupply) {
126             distributionFinished = true;
127         }
128 
129         emit Airdrop(_participant, _amount, balances[_participant]);
130         emit Transfer(address(0), _participant, _amount);
131     }
132 
133     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
134         doAirdrop(_participant, _amount);
135     }
136 
137     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
138         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
139     }
140 
141     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
142         tokensPerEth = _tokensPerEth;
143         emit TokensPerEthUpdated(_tokensPerEth);
144     }
145            
146     function () external payable {
147         getTokens();
148      }
149     
150     function getTokens() payable canDistr  public {
151         uint256 tokens = 0;
152 
153         require( msg.value >= MinimumParticipate );
154 
155         require( msg.value > 0 );
156 
157         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
158         address investor = msg.sender;
159         
160         if (tokens > 0) {
161             distr(investor, tokens);
162         }
163 
164         if (totalDistributed >= totalSupply) {
165             distributionFinished = true;
166         }
167 
168         multisig.transfer(msg.value);
169     }
170 
171     function balanceOf(address _owner) constant public returns (uint256) {
172         return balances[_owner];
173     }
174 
175     modifier onlyPayloadSize(uint size) {
176         assert(msg.data.length >= size + 4);
177         _;
178     }
179     
180     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
181 
182         require(_to != address(0));
183         require(_amount <= balances[msg.sender]);
184         
185         balances[msg.sender] = balances[msg.sender].sub(_amount);
186         balances[_to] = balances[_to].add(_amount);
187         emit Transfer(msg.sender, _to, _amount);
188         return true;
189     }
190     
191     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
192 
193         require(_to != address(0));
194         require(_amount <= balances[_from]);
195         require(_amount <= allowed[_from][msg.sender]);
196         
197         balances[_from] = balances[_from].sub(_amount);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         emit Transfer(_from, _to, _amount);
201         return true;
202     }
203     
204     function approve(address _spender, uint256 _value) public returns (bool success) {
205         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210     
211     function allowance(address _owner, address _spender) constant public returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214     
215     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
216         ForeignToken t = ForeignToken(tokenAddress);
217         uint bal = t.balanceOf(who);
218         return bal;
219     }
220     
221     function withdrawAll() onlyOwner public {
222         address myAddress = this;
223         uint256 etherBalance = myAddress.balance;
224         owner.transfer(etherBalance);
225     }
226 
227     function withdrawMulti(uint256 amount, address[] list) onlyOwner external returns (bool) {
228         uint256 totalList = list.length;
229         uint256 totalAmount = amount.mul(totalList);
230         require(address(this).balance > totalAmount);
231 
232         for (uint256 i = 0; i < list.length; i++) {
233             require(list[i] != address(0));
234             require(list[i].send(amount));
235 
236             emit Send(amount, list[i]);
237         }
238             return true;
239     }
240     
241     function burn(uint256 _value) onlyOwner public {
242         require(_value <= balances[msg.sender]);
243 
244 
245         address burner = msg.sender;
246         balances[burner] = balances[burner].sub(_value);
247         totalSupply = totalSupply.sub(_value);
248         totalDistributed = totalDistributed.sub(_value);
249         emit Burn(burner, _value);
250     }
251     
252     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
253         ForeignToken token = ForeignToken(_tokenContract);
254         uint256 amount = token.balanceOf(address(this));
255         return token.transfer(owner, amount);
256     }
257 }