1 // Name : oPAA
2 // Symbol : oPAA
3 // Decimals : 8
4 // TotalSupply : 10000000000
5 
6 pragma solidity ^0.4.18;
7 
8 /**
9  * @title SafeMath
10  */
11 library SafeMath {
12 
13     /**
14     * Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract AltcoinToken {
54     function balanceOf(address _owner) constant public returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56 }
57 
58 contract ERC20Basic {
59     uint256 public totalSupply;
60     function balanceOf(address who) public constant returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract oPAA is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "oPAA";
81     string public constant symbol = "oPAA";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 10000000000e8;
85     uint256 public totalDistributed = 0;        
86     uint256 public tokensPerEth = 20000000e8;
87     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94 
95     event Airdrop(address indexed _owner, uint _amount, uint _balance);
96 
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     
99     event Burn(address indexed burner, uint256 value);
100 
101     bool public distributionFinished = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     
114     
115     
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121     
122 
123     function finishDistribution() onlyOwner canDistr public returns (bool) {
124         distributionFinished = true;
125         emit DistrFinished();
126         return true;
127     }
128     
129     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
130         totalDistributed = totalDistributed.add(_amount);        
131         balances[_to] = balances[_to].add(_amount);
132         emit Distr(_to, _amount);
133         emit Transfer(address(0), _to, _amount);
134 
135         return true;
136     }
137 
138     function doAirdrop(address _participant, uint _amount) internal {
139 
140         require( _amount > 0 );      
141 
142         require( totalDistributed < totalSupply );
143         
144         balances[_participant] = balances[_participant].add(_amount);
145         totalDistributed = totalDistributed.add(_amount);
146 
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150 
151         // log
152         emit Airdrop(_participant, _amount, balances[_participant]);
153         emit Transfer(address(0), _participant, _amount);
154     }
155 
156     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
157         doAirdrop(_participant, _amount);
158     }
159 
160     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
161         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
162     }
163 
164     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
165         tokensPerEth = _tokensPerEth;
166         emit TokensPerEthUpdated(_tokensPerEth);
167     }
168            
169     function () external payable {
170         getTokens();
171      }
172     
173     function getTokens() payable canDistr  public {
174         uint256 tokens = 0;
175 
176         require( msg.value >= minContribution );
177 
178         require( msg.value > 0 );
179         
180         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
181         address investor = msg.sender;
182         
183         if (tokens > 0) {
184             distr(investor, tokens);
185         }
186 
187         if (totalDistributed >= totalSupply) {
188             distributionFinished = true;
189         }
190     }
191 
192     function balanceOf(address _owner) constant public returns (uint256) {
193         return balances[_owner];
194     }
195 
196     // mitigates the ERC20 short address attack
197     modifier onlyPayloadSize(uint size) {
198         assert(msg.data.length >= size + 4);
199         _;
200     }
201     
202     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
203 
204         require(_to != address(0));
205         require(_amount <= balances[msg.sender]);
206         
207         balances[msg.sender] = balances[msg.sender].sub(_amount);
208         balances[_to] = balances[_to].add(_amount);
209         emit Transfer(msg.sender, _to, _amount);
210         return true;
211     }
212     
213     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
214 
215         require(_to != address(0));
216         require(_amount <= balances[_from]);
217         require(_amount <= allowed[_from][msg.sender]);
218         
219         balances[_from] = balances[_from].sub(_amount);
220         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
221         balances[_to] = balances[_to].add(_amount);
222         emit Transfer(_from, _to, _amount);
223         return true;
224     }
225     
226     function approve(address _spender, uint256 _value) public returns (bool success) {
227         // mitigates the ERC20 spend/approval race condition
228         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
229         allowed[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     }
233     
234     function allowance(address _owner, address _spender) constant public returns (uint256) {
235         return allowed[_owner][_spender];
236     }
237     
238     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
239         AltcoinToken t = AltcoinToken(tokenAddress);
240         uint bal = t.balanceOf(who);
241         return bal;
242     }
243     
244     function withdraw() onlyOwner public {
245         address myAddress = this;
246         uint256 etherBalance = myAddress.balance;
247         owner.transfer(etherBalance);
248     }
249     
250     function burn(uint256 _value) onlyOwner public {
251         require(_value <= balances[msg.sender]);
252         
253         address burner = msg.sender;
254         balances[burner] = balances[burner].sub(_value);
255         totalSupply = totalSupply.sub(_value);
256         totalDistributed = totalDistributed.sub(_value);
257         emit Burn(burner, _value);
258     }
259     
260     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
261         AltcoinToken token = AltcoinToken(_tokenContract);
262         uint256 amount = token.balanceOf(address(this));
263         return token.transfer(owner, amount);
264     }
265 }