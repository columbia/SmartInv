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
49 contract Test3 is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "Test3";
58     string public constant symbol = "TST3";
59     uint public constant decimals = 18;
60     
61     uint256 public totalSupply = 5000000000e18;
62     uint256 public totalDistributed = 0;        
63     uint256 public tokensPerEth = 3000000e18;
64     uint256 public constant minContribution = 1 ether / 200; // 0.005 Ether
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
91     function Test3 () public {
92         owner = msg.sender;
93         uint256 devTokens = 100000000e18;
94         distr(owner, devTokens);
95     }
96     
97     function transferOwnership(address newOwner) onlyOwner public {
98         if (newOwner != address(0)) {
99             owner = newOwner;
100         }
101     }
102 
103     function finishDistribution() onlyOwner canDistr public returns (bool) {
104         distributionFinished = true;
105         emit DistrFinished();
106         return true;
107     }
108     
109     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
110         totalDistributed = totalDistributed.add(_amount);        
111         balances[_to] = balances[_to].add(_amount);
112         emit Distr(_to, _amount);
113         emit Transfer(address(0), _to, _amount);
114 
115         return true;
116     }
117 
118     function doAirdrop(address _participant, uint _amount) internal {
119 
120         require( _amount > 0 );      
121 
122         require( totalDistributed < totalSupply );
123         
124         balances[_participant] = balances[_participant].add(_amount);
125         totalDistributed = totalDistributed.add(_amount);
126 
127         if (totalDistributed >= totalSupply) {
128             distributionFinished = true;
129         }
130 
131         emit Airdrop(_participant, _amount, balances[_participant]);
132         emit Transfer(address(0), _participant, _amount);
133     }
134 
135     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
136         doAirdrop(_participant, _amount);
137     }
138 
139     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
140         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
141     }
142 
143     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
144         tokensPerEth = _tokensPerEth;
145         emit TokensPerEthUpdated(_tokensPerEth);
146     }
147            
148     function () external payable {
149         getTokens();
150      }
151     
152     function getTokens() payable canDistr  public {
153         uint256 tokens = 0;
154 
155         require( msg.value >= minContribution );
156 
157         require( msg.value > 0 );
158         
159         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
160         address investor = msg.sender;
161         
162         if (tokens > 0) {
163             distr(investor, tokens);
164         }
165 
166         if (totalDistributed >= totalSupply) {
167             distributionFinished = true;
168         }
169     }
170 
171     function balanceOf(address _owner) constant public returns (uint256) {
172         return balances[_owner];
173     }
174 
175     // mitigates the ERC20 short address attack
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
206         // mitigates the ERC20 spend/approval race condition
207         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
208         allowed[msg.sender][_spender] = _value;
209         emit Approval(msg.sender, _spender, _value);
210         return true;
211     }
212     
213     function allowance(address _owner, address _spender) constant public returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216     
217     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
218         AltcoinToken t = AltcoinToken(tokenAddress);
219         uint bal = t.balanceOf(who);
220         return bal;
221     }
222     
223     function withdraw() onlyOwner public {
224         address myAddress = this;
225         uint256 etherBalance = myAddress.balance;
226         owner.transfer(etherBalance);
227     }
228     
229     function burn(uint256 _value) onlyOwner public {
230         require(_value <= balances[msg.sender]);
231         
232         address burner = msg.sender;
233         balances[burner] = balances[burner].sub(_value);
234         totalSupply = totalSupply.sub(_value);
235         totalDistributed = totalDistributed.sub(_value);
236         emit Burn(burner, _value);
237     }
238     
239     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
240         AltcoinToken token = AltcoinToken(_tokenContract);
241         uint256 amount = token.balanceOf(address(this));
242         return token.transfer(owner, amount);
243     }
244 }