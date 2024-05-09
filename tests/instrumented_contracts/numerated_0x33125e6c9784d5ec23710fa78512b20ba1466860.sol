1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15    
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17       
18         return a / b;
19     }
20 
21     
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27    
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract AltcoinToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract ERC20Basic {
41     uint256 public totalSupply;
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract TESTToken is ERC20 {
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;    
60 
61     string public constant name = "TEST Token";                                                 
62     string public constant symbol = "TT";                                                      
63     uint public constant decimals = 18;                                                         
64     
65     uint256 public totalSupply = 10000000000000000000000000000;                                  
66     uint256 public totalDistributed = 0;        
67     uint256 public tokensPerEth = 10000000000000000000000000;
68     uint256 public constant minContribution = 1 ether / 100; 
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     //Enough Hard Cap to stop ico
76     event Airdrop(address indexed _owner, uint _amount, uint _balance);
77 
78     event TokensPerEthUpdated(uint _tokensPerEth);
79     
80     event Burn(address indexed burner, uint256 value);
81 
82     bool public distributionFinished = false;
83     
84     modifier canDistr() {
85         require(!distributionFinished);
86         _;
87     }
88     
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93     
94     
95     function TESTToken () public {
96         owner = msg.sender;
97         uint256 devTokens = 1000000000000000000000000000;
98         distr(owner, devTokens);
99     }
100     
101     function transferOwnership(address newOwner) onlyOwner public {
102         if (newOwner != address(0)) {
103             owner = newOwner;
104         }
105     }
106     
107 
108     function finishDistribution() onlyOwner canDistr public returns (bool) {
109         distributionFinished = true;
110         emit DistrFinished();
111         return true;
112     }
113     
114     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
115         totalDistributed = totalDistributed.add(_amount);        
116         balances[_to] = balances[_to].add(_amount);
117         emit Distr(_to, _amount);
118         emit Transfer(address(0), _to, _amount);
119 
120         return true;
121     }
122 
123     function doAirdrop(address _participant, uint _amount) internal {
124 
125         require( _amount > 0 );      
126 
127         require( totalDistributed < totalSupply );
128         
129         balances[_participant] = balances[_participant].add(_amount);
130         totalDistributed = totalDistributed.add(_amount);
131 
132         if (totalDistributed >= totalSupply) {
133             distributionFinished = true;
134         }
135 
136       
137         emit Airdrop(_participant, _amount, balances[_participant]);
138         emit Transfer(address(0), _participant, _amount);
139     }
140 
141     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
142         doAirdrop(_participant, _amount);
143     }
144 
145     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
146         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
147     }
148 
149     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
150         tokensPerEth = _tokensPerEth;
151         emit TokensPerEthUpdated(_tokensPerEth);
152     }
153            
154     function () external payable {
155         getTokens();
156      }
157     
158     function getTokens() payable canDistr  public {
159         uint256 tokens = 0;
160 
161         require( msg.value >= minContribution );
162 
163         require( msg.value > 0 );
164         
165         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
166         address investor = msg.sender;
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
181     
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
235     function burn(uint256 _value) onlyOwner public {
236         require(_value <= balances[msg.sender]);
237        
238         address burner = msg.sender;
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply = totalSupply.sub(_value);
241         totalDistributed = totalDistributed.sub(_value);
242         emit Burn(burner, _value);
243     }
244     
245     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
246         AltcoinToken token = AltcoinToken(_tokenContract);
247         uint256 amount = token.balanceOf(address(this));
248         return token.transfer(owner, amount);
249     }
250 }