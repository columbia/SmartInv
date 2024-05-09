1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract AltcoinToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract WellethToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Welleth Token";
76     string public constant symbol = "WEX";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 10000000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth =  6666666.67e8;
82     uint256 public constant MinContribution = 1 ether / 100; // min purchase (0.01 Ether)
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86     
87     event Distr(address indexed to, uint256 amount);
88     event DistrFinished();
89 
90     event Airdrop(address indexed _owner, uint _amount, uint _balance);
91 
92     event TokensPerEthUpdated(uint _tokensPerEth);
93     
94     event Burn(address indexed burner, uint256 value);
95 
96     bool public distributionFinished = false;
97     
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     
108     
109     constructor () public {
110         owner = msg.sender;
111         uint256 reserve = 1500000000e8;
112         distr(owner, reserve);
113     }
114     
115     function transferOwnership(address newOwner) onlyOwner public {
116         if (newOwner != address(0)) {
117             owner = newOwner;
118         }
119     }
120     
121 
122     function finishDistribution() onlyOwner canDistr public returns (bool) {
123         distributionFinished = true;
124         emit DistrFinished ();
125         return true;
126     }
127     
128     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
129         totalDistributed = totalDistributed.add(_amount);        
130         balances[_to] = balances[_to].add(_amount);
131         emit Distr(_to, _amount);
132         emit Transfer(address(0), _to, _amount);
133 
134         return true;
135     }
136 
137     function doAirdrop(address _participant, uint _amount) internal {
138 
139         require( _amount > 0 );      
140 
141         require( totalDistributed < totalSupply );
142         
143         balances[_participant] = balances[_participant].add(_amount);
144         totalDistributed = totalDistributed.add(_amount);
145 
146         if (totalDistributed >= totalSupply) {
147             distributionFinished = true;
148         }
149 
150         // log
151         emit Airdrop(_participant, _amount, balances[_participant]);
152         emit Transfer(address(0), _participant, _amount);
153     }
154 
155     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
156         doAirdrop(_participant, _amount);
157     }
158 
159     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
160         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
161     }
162 
163     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
164         tokensPerEth = _tokensPerEth;
165         emit TokensPerEthUpdated(_tokensPerEth);
166     }
167            
168     function () external payable {
169         getTokens();
170      }
171     
172     function getTokens() payable canDistr  public {
173         uint256 tokens = 0;
174 
175         require( msg.value >= MinContribution );
176 
177         require( msg.value > 0 );
178         
179         tokens = tokensPerEth.mul(msg.value) / 1 ether;  
180         
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