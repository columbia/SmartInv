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
30 contract AltcoinToken {
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
49 contract Test11 is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "Test11";
58     string public constant symbol = "TST11";
59     uint public constant decimals = 8;
60     
61     uint256 public totalSupply = 86000000e8;
62     uint256 public totalDistributed = 0;        
63     uint256 public tokensPerEth = 86000e8;
64     uint256 public bonus = 0;   
65     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
66     uint256 public constant extraBonus = 1 ether / 20; // 0.05 Ether
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     
71     event Distr(address indexed to, uint256 amount);
72     event DistrFinished();
73 
74     event Airdrop(address indexed _owner, uint _amount, uint _balance);
75 
76     event TokensPerEthUpdated(uint _tokensPerEth);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     function Test11 () public {
91         owner = msg.sender;
92         uint256 devTokens = 4300000e8;
93         distr(owner, devTokens);
94     }
95     
96     function transferOwnership(address newOwner) onlyOwner public {
97         if (newOwner != address(0)) {
98             owner = newOwner;
99         }
100     }
101 
102     function finishDistribution() onlyOwner canDistr public returns (bool) {
103         distributionFinished = true;
104         emit DistrFinished();
105         return true;
106     }
107     
108     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
109         totalDistributed = totalDistributed.add(_amount);        
110         balances[_to] = balances[_to].add(_amount);
111         emit Distr(_to, _amount);
112         emit Transfer(address(0), _to, _amount);
113 
114         return true;
115     }
116 
117     function doAirdrop(address _participant, uint _amount) internal {
118 
119         require( _amount > 0 );      
120 
121         require( totalDistributed + _amount <= totalSupply );
122         
123         balances[_participant] = balances[_participant].add(_amount);
124         totalDistributed = totalDistributed.add(_amount);
125 
126         if (totalDistributed >= totalSupply) {
127             distributionFinished = true;
128         }
129 
130         emit Airdrop(_participant, _amount, balances[_participant]);
131         emit Transfer(address(0), _participant, _amount);
132     }
133 
134     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
135         doAirdrop(_participant, _amount);
136     }
137 
138     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
139         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
140     }
141 
142     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
143         tokensPerEth = _tokensPerEth;
144         emit TokensPerEthUpdated(_tokensPerEth);
145     }
146            
147     function () external payable {
148         getTokens();
149      }
150     
151     function getTokens() payable canDistr  public {
152         uint256 tokens = 0;
153 
154         require( msg.value >= minContribution );
155 
156         require( msg.value > 0 );
157 
158         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
159         address investor = msg.sender;
160         bonus = 0;
161 
162         if ( msg.value >= extraBonus ) {
163             bonus = tokens / 2;
164         }
165 
166         tokens = tokens + bonus;
167 
168         if (tokens > 0) {
169             distr(investor, tokens);
170         }
171 
172         if (totalDistributed >= totalSupply) {
173             distributionFinished = true;
174         }
175     }
176 
177     function balanceOf(address _owner) constant public returns (uint256) {
178         return balances[_owner];
179     }
180 
181     // mitigates the ERC20 short address attack
182     modifier onlyPayloadSize(uint size) {
183         assert(msg.data.length >= size + 4);
184         _;
185     }
186     
187     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
188 
189         require(_to != address(0));
190         require(_amount <= balances[msg.sender]);
191         
192         balances[msg.sender] = balances[msg.sender].sub(_amount);
193         balances[_to] = balances[_to].add(_amount);
194         emit Transfer(msg.sender, _to, _amount);
195         return true;
196     }
197     
198     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
199 
200         require(_to != address(0));
201         require(_amount <= balances[_from]);
202         require(_amount <= allowed[_from][msg.sender]);
203         
204         balances[_from] = balances[_from].sub(_amount);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(_from, _to, _amount);
208         return true;
209     }
210     
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         // mitigates the ERC20 spend/approval race condition
213         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
214         allowed[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218     
219     function allowance(address _owner, address _spender) constant public returns (uint256) {
220         return allowed[_owner][_spender];
221     }
222     
223     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
224         AltcoinToken t = AltcoinToken(tokenAddress);
225         uint bal = t.balanceOf(who);
226         return bal;
227     }
228     
229     function withdraw() onlyOwner public {
230         address myAddress = this;
231         uint256 etherBalance = myAddress.balance;
232         owner.transfer(etherBalance);
233     }
234     
235     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
236         AltcoinToken token = AltcoinToken(_tokenContract);
237         uint256 amount = token.balanceOf(address(this));
238         return token.transfer(owner, amount);
239     }
240 }