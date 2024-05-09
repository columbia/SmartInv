1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ViewChain
5  */
6 library SafeMath {
7 
8     
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18    
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         // uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return a / b;
24     }
25 
26     
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32    
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract AltcoinToken {
41     function balanceOf(address _owner) constant public returns (uint256);
42     function transfer(address _to, uint256 _value) public returns (bool);
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract ViewChain is ERC20 {
60     
61     using SafeMath for uint256;
62     address owner = msg.sender;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;    
66 
67     string public constant name = "ViewChain";
68     string public constant symbol = "VHN";
69     uint public constant decimals = 8;
70     
71     uint256 public totalSupply = 20000000000e8;
72     uint256 public totalDistributed = 0;        
73     uint256 public tokensPerEth = 20000000e8;
74     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78     
79     event Distr(address indexed to, uint256 amount);
80     event DistrFinished();
81 
82     event Airdrop(address indexed _owner, uint _amount, uint _balance);
83 
84     event TokensPerEthUpdated(uint _tokensPerEth);
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
100     
101     function ViewChain () public {
102         owner = msg.sender;
103         uint256 devTokens = 2000000000e8;
104         distr(owner, devTokens);
105     }
106     
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
112     
113 
114     function finishDistribution() onlyOwner canDistr public returns (bool) {
115         distributionFinished = true;
116         emit DistrFinished();
117         return true;
118     }
119     
120     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
121         totalDistributed = totalDistributed.add(_amount);        
122         balances[_to] = balances[_to].add(_amount);
123         emit Distr(_to, _amount);
124         emit Transfer(address(0), _to, _amount);
125 
126         return true;
127     }
128 
129     function doAirdrop(address _participant, uint _amount) internal {
130 
131         require( _amount > 0 );      
132 
133         require( totalDistributed < totalSupply );
134         
135         balances[_participant] = balances[_participant].add(_amount);
136         totalDistributed = totalDistributed.add(_amount);
137 
138         if (totalDistributed >= totalSupply) {
139             distributionFinished = true;
140         }
141 
142         // log
143         emit Airdrop(_participant, _amount, balances[_participant]);
144         emit Transfer(address(0), _participant, _amount);
145     }
146 
147     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
148         doAirdrop(_participant, _amount);
149     }
150 
151     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
152         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
153     }
154 
155     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
156         tokensPerEth = _tokensPerEth;
157         emit TokensPerEthUpdated(_tokensPerEth);
158     }
159            
160     function () external payable {
161         getTokens();
162      }
163     
164     function getTokens() payable canDistr  public {
165         uint256 tokens = 0;
166 
167         require( msg.value >= minContribution );
168 
169         require( msg.value > 0 );
170         
171         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
172         address investor = msg.sender;
173         
174         if (tokens > 0) {
175             distr(investor, tokens);
176         }
177 
178         if (totalDistributed >= totalSupply) {
179             distributionFinished = true;
180         }
181     }
182 
183     function balanceOf(address _owner) constant public returns (uint256) {
184         return balances[_owner];
185     }
186 
187     
188     modifier onlyPayloadSize(uint size) {
189         assert(msg.data.length >= size + 4);
190         _;
191     }
192     
193     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
194 
195         require(_to != address(0));
196         require(_amount <= balances[msg.sender]);
197         
198         balances[msg.sender] = balances[msg.sender].sub(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         emit Transfer(msg.sender, _to, _amount);
201         return true;
202     }
203     
204     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
205 
206         require(_to != address(0));
207         require(_amount <= balances[_from]);
208         require(_amount <= allowed[_from][msg.sender]);
209         
210         balances[_from] = balances[_from].sub(_amount);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
212         balances[_to] = balances[_to].add(_amount);
213         emit Transfer(_from, _to, _amount);
214         return true;
215     }
216     
217     function approve(address _spender, uint256 _value) public returns (bool success) {
218         // mitigates the ERC20 spend/approval race condition
219         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224     
225     function allowance(address _owner, address _spender) constant public returns (uint256) {
226         return allowed[_owner][_spender];
227     }
228     
229     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
230         AltcoinToken t = AltcoinToken(tokenAddress);
231         uint bal = t.balanceOf(who);
232         return bal;
233     }
234     
235     function withdraw() onlyOwner public {
236         address myAddress = this;
237         uint256 etherBalance = myAddress.balance;
238         owner.transfer(etherBalance);
239     }
240     
241     function burn(uint256 _value) onlyOwner public {
242         require(_value <= balances[msg.sender]);
243         
244         address burner = msg.sender;
245         balances[burner] = balances[burner].sub(_value);
246         totalSupply = totalSupply.sub(_value);
247         totalDistributed = totalDistributed.sub(_value);
248         emit Burn(burner, _value);
249     }
250     
251     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
252         AltcoinToken token = AltcoinToken(_tokenContract);
253         uint256 amount = token.balanceOf(address(this));
254         return token.transfer(owner, amount);
255     }
256 }