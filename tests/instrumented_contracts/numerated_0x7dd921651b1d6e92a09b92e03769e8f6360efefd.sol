1 pragma solidity ^0.4.18;
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
30 contract ALTokens {
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
49 contract NEXTARIUM is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "NEXTARIUM";
58     string public constant symbol = "NEXTA";
59     uint public constant decimals = 8;
60     
61     uint256 public totalSupply = 11000000000e8;
62     uint256 public totalDistributed = 0;        
63     uint256 public tokensPerEth = 20000000e8;
64     uint256 public constant minContribution = 1 ether / 100;
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68     
69     event Distr(address indexed to, uint256 amount);
70     event DistrFinished();
71 
72     event Airdrop(address indexed _owner, uint _amount, uint _balance);
73 
74     event TokensPerEthUpdated(uint _tokensPerEth);
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
86         require(msg.sender == owner);
87         _;
88     }
89     
90     
91     function TeamTokensAllocation () public {
92         owner = msg.sender;
93         uint256 TeamTokens = 1000000000e8;
94         distr(owner, TeamTokens);
95     }
96     
97     function transferOwnership(address newOwner) onlyOwner public {
98         if (newOwner != address(0)) {
99             owner = newOwner;
100         }
101     }
102     
103 
104     function finishDistribution() onlyOwner canDistr public returns (bool) {
105         distributionFinished = true;
106         emit DistrFinished();
107         return true;
108     }
109     
110     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
111         totalDistributed = totalDistributed.add(_amount);        
112         balances[_to] = balances[_to].add(_amount);
113         emit Distr(_to, _amount);
114         emit Transfer(address(0), _to, _amount);
115 
116         return true;
117     }
118 
119     function doAirdrop(address _participant, uint _amount) internal {
120 
121         require( _amount > 0 );      
122 
123         require( totalDistributed < totalSupply );
124         
125         balances[_participant] = balances[_participant].add(_amount);
126         totalDistributed = totalDistributed.add(_amount);
127 
128         if (totalDistributed >= totalSupply) {
129             distributionFinished = true;
130         }
131 
132         emit Airdrop(_participant, _amount, balances[_participant]);
133         emit Transfer(address(0), _participant, _amount);
134     }
135 
136     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
137         doAirdrop(_participant, _amount);
138     }
139 
140     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
141         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
142     }
143 
144     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
145         tokensPerEth = _tokensPerEth;
146         emit TokensPerEthUpdated(_tokensPerEth);
147     }
148            
149     function () external payable {
150         getTokens();
151      }
152     
153     function getTokens() payable canDistr  public {
154         uint256 tokens = 0;
155 
156         require( msg.value >= minContribution );
157 
158         require( msg.value > 0 );
159         
160         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
161         address investor = msg.sender;
162         
163         if (tokens > 0) {
164             distr(investor, tokens);
165         }
166 
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170     }
171 
172     function balanceOf(address _owner) constant public returns (uint256) {
173         return balances[_owner];
174     }
175 
176     modifier onlyPayloadSize(uint size) {
177         assert(msg.data.length >= size + 4);
178         _;
179     }
180     
181     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
182 
183         require(_to != address(0));
184         require(_amount <= balances[msg.sender]);
185         
186         balances[msg.sender] = balances[msg.sender].sub(_amount);
187         balances[_to] = balances[_to].add(_amount);
188         emit Transfer(msg.sender, _to, _amount);
189         return true;
190     }
191     
192     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
193 
194         require(_to != address(0));
195         require(_amount <= balances[_from]);
196         require(_amount <= allowed[_from][msg.sender]);
197         
198         balances[_from] = balances[_from].sub(_amount);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
200         balances[_to] = balances[_to].add(_amount);
201         emit Transfer(_from, _to, _amount);
202         return true;
203     }
204     
205     function approve(address _spender, uint256 _value) public returns (bool success) {
206         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
207         allowed[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211     
212     function allowance(address _owner, address _spender) constant public returns (uint256) {
213         return allowed[_owner][_spender];
214     }
215     
216     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
217         ALTokens t = ALTokens(tokenAddress);
218         uint bal = t.balanceOf(who);
219         return bal;
220     }
221     
222     function withdraw() onlyOwner public {
223         address myAddress = this;
224         uint256 etherBalance = myAddress.balance;
225         owner.transfer(etherBalance);
226     }
227     
228     function burn(uint256 _value) onlyOwner public {
229         require(_value <= balances[msg.sender]);
230         
231         address burner = msg.sender;
232         balances[burner] = balances[burner].sub(_value);
233         totalSupply = totalSupply.sub(_value);
234         totalDistributed = totalDistributed.sub(_value);
235         emit Burn(burner, _value);
236     }
237     
238     function withdrawALTokenss(address _tokenContract) onlyOwner public returns (bool) {
239         ALTokens token = ALTokens(_tokenContract);
240         uint256 amount = token.balanceOf(address(this));
241         return token.transfer(owner, amount);
242     }
243 }