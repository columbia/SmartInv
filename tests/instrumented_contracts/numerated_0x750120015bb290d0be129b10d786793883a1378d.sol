1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23 
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract ForeignToken {
38     function balanceOf(address _owner) constant public returns (uint256);
39     function transfer(address _to, uint256 _value) public returns (bool);
40 }
41 
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public constant returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public constant returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract Ignite is ERC20 {
57     
58     using SafeMath for uint256;
59     address owner = msg.sender;
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;    
63 
64     string public constant name = "Ignite";
65     string public constant symbol = "IGT";
66     uint public constant decimals = 8;
67     
68     uint256 public totalSupply = 800000000e8;
69     uint256 public totalDistributed =  400000000e8;    
70     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
71     uint256 public tokensPerEth = 100000e8;
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     
76     event Distr(address indexed to, uint256 amount);
77     event DistrFinished();
78 
79     event Airdrop(address indexed _owner, uint _amount, uint _balance);
80 
81     event TokensPerEthUpdated(uint _tokensPerEth);
82     
83     event Burn(address indexed burner, uint256 value);
84 
85     bool public distributionFinished = false;
86     
87     modifier canDistr() {
88         require(!distributionFinished);
89         _;
90     }
91     
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     function Ignite() public {
98         owner = msg.sender;    
99         distr(owner, totalDistributed);
100     }
101     
102     function transferOwnership(address newOwner) onlyOwner public {
103         if (newOwner != address(0)) {
104             owner = newOwner;
105         }
106     }
107     
108 
109     function finishDistribution() onlyOwner canDistr public returns (bool) {
110         distributionFinished = true;
111         emit DistrFinished();
112         return true;
113     }
114     
115     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
116         totalDistributed = totalDistributed.add(_amount);        
117         balances[_to] = balances[_to].add(_amount);
118         emit Distr(_to, _amount);
119         emit Transfer(address(0), _to, _amount);
120 
121         return true;
122     }
123 
124     function doAirdrop(address _participant, uint _amount) internal {
125 
126         require( _amount > 0 );      
127 
128         require( totalDistributed < totalSupply );
129         
130         balances[_participant] = balances[_participant].add(_amount);
131         totalDistributed = totalDistributed.add(_amount);
132 
133         if (totalDistributed >= totalSupply) {
134             distributionFinished = true;
135         }
136 
137         // log
138         emit Airdrop(_participant, _amount, balances[_participant]);
139         emit Transfer(address(0), _participant, _amount);
140     }
141 
142     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
143         doAirdrop(_participant, _amount);
144     }
145 
146     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
147         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
148     }
149 
150     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
151         tokensPerEth = _tokensPerEth;
152         emit TokensPerEthUpdated(_tokensPerEth);
153     }
154            
155     function () external payable {
156         getTokens();
157      }
158     
159     function getTokens() payable canDistr  public {
160         uint256 tokens = 0;
161 
162         // minimum contribution
163         require( msg.value >= MIN_CONTRIBUTION );
164 
165         require( msg.value > 0 );
166 
167         // get baseline number of tokens
168         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
169         address investor = msg.sender;
170         
171         if (tokens > 0) {
172             distr(investor, tokens);
173         }
174 
175         if (totalDistributed >= totalSupply) {
176             distributionFinished = true;
177         }
178     }
179 
180     function balanceOf(address _owner) constant public returns (uint256) {
181         return balances[_owner];
182     }
183 
184     // mitigates the ERC20 short address attack
185     modifier onlyPayloadSize(uint size) {
186         assert(msg.data.length >= size + 4);
187         _;
188     }
189     
190     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
191 
192         require(_to != address(0));
193         require(_amount <= balances[msg.sender]);
194         
195         balances[msg.sender] = balances[msg.sender].sub(_amount);
196         balances[_to] = balances[_to].add(_amount);
197         emit Transfer(msg.sender, _to, _amount);
198         return true;
199     }
200     
201     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
202 
203         require(_to != address(0));
204         require(_amount <= balances[_from]);
205         require(_amount <= allowed[_from][msg.sender]);
206         
207         balances[_from] = balances[_from].sub(_amount);
208         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
209         balances[_to] = balances[_to].add(_amount);
210         emit Transfer(_from, _to, _amount);
211         return true;
212     }
213     
214     function approve(address _spender, uint256 _value) public returns (bool success) {
215         // mitigates the ERC20 spend/approval race condition
216         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
217         allowed[msg.sender][_spender] = _value;
218         emit Approval(msg.sender, _spender, _value);
219         return true;
220     }
221     
222     function allowance(address _owner, address _spender) constant public returns (uint256) {
223         return allowed[_owner][_spender];
224     }
225     
226     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
227         ForeignToken t = ForeignToken(tokenAddress);
228         uint bal = t.balanceOf(who);
229         return bal;
230     }
231     
232     function withdraw() onlyOwner public {
233         address myAddress = this;
234         uint256 etherBalance = myAddress.balance;
235         owner.transfer(etherBalance);
236     }
237     
238     function burn(uint256 _value) onlyOwner public {
239         require(_value <= balances[msg.sender]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         address burner = msg.sender;
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         totalDistributed = totalDistributed.sub(_value);
247         emit Burn(burner, _value);
248     }
249     
250     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
251         ForeignToken token = ForeignToken(_tokenContract);
252         uint256 amount = token.balanceOf(address(this));
253         return token.transfer(owner, amount);
254     }
255 }