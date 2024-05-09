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
67 contract Bluechipstoken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "BLUECHIPS";
76     string public constant symbol = "BCHIP";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 10000000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth = 25000000e8;
82     uint256 public constant minContribution = 1 ether / 1; // 1 Ether
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
109        function Bluechipstoken () public {
110         owner = msg.sender;
111         uint256 devTokens = 4000000000e8;
112         distr(owner, devTokens);
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
124         emit DistrFinished();
125         return true;
126         distributionFinished = false;
127         emit DistrFinished();
128         return false;
129     }
130     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
131         totalDistributed = totalDistributed.add(_amount);        
132         balances[_to] = balances[_to].add(_amount);
133         emit Distr(_to, _amount);
134         emit Transfer(address(0), _to, _amount);
135 
136         return true;
137     }
138 
139     function doAirdrop(address _participant, uint _amount) internal {
140 
141         require( _amount > 0 );      
142 
143         require( totalDistributed < totalSupply );
144         
145         balances[_participant] = balances[_participant].add(_amount);
146         totalDistributed = totalDistributed.add(_amount);
147 
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151 
152         // log
153         emit Airdrop(_participant, _amount, balances[_participant]);
154         emit Transfer(address(0), _participant, _amount);
155     }
156 
157     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
158         doAirdrop(_participant, _amount);
159     }
160 
161     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
162         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
163     }
164 
165     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
166         tokensPerEth = _tokensPerEth;
167         emit TokensPerEthUpdated(_tokensPerEth);
168     }
169            
170     function () external payable {
171         getTokens();
172      }
173     
174     function getTokens() payable canDistr  public {
175         uint256 tokens = 0;
176 
177         require( msg.value >= minContribution );
178 
179         require( msg.value > 0 );
180         
181         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
182         address investor = msg.sender;
183         
184         if (tokens > 0) {
185             distr(investor, tokens);
186         }
187 
188         if (totalDistributed >= totalSupply) {
189             distributionFinished = true;
190         }
191     }
192 
193     function balanceOf(address _owner) constant public returns (uint256) {
194         return balances[_owner];
195     }
196 
197     // mitigates the ERC20 short address attack
198     modifier onlyPayloadSize(uint size) {
199         assert(msg.data.length >= size + 4);
200         _;
201     }
202     
203     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
204 
205         require(_to != address(0));
206         require(_amount <= balances[msg.sender]);
207         
208         balances[msg.sender] = balances[msg.sender].sub(_amount);
209         balances[_to] = balances[_to].add(_amount);
210         emit Transfer(msg.sender, _to, _amount);
211         return true;
212     }
213     
214     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
215 
216         require(_to != address(0));
217         require(_amount <= balances[_from]);
218         require(_amount <= allowed[_from][msg.sender]);
219         
220         balances[_from] = balances[_from].sub(_amount);
221         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
222         balances[_to] = balances[_to].add(_amount);
223         emit Transfer(_from, _to, _amount);
224         return true;
225     }
226     
227     function approve(address _spender, uint256 _value) public returns (bool success) {
228         // mitigates the ERC20 spend/approval race condition
229         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
230         allowed[msg.sender][_spender] = _value;
231         emit Approval(msg.sender, _spender, _value);
232         return true;
233     }
234     
235     function allowance(address _owner, address _spender) constant public returns (uint256) {
236         return allowed[_owner][_spender];
237     }
238     
239     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
240         AltcoinToken t = AltcoinToken(tokenAddress);
241         uint bal = t.balanceOf(who);
242         return bal;
243     }
244     
245     function withdraw() onlyOwner public {
246         address myAddress = this;
247         uint256 etherBalance = myAddress.balance;
248         owner.transfer(etherBalance);
249     }
250     
251     function burn(uint256 _value) onlyOwner public {
252         require(_value <= balances[msg.sender]);
253         
254         address burner = msg.sender;
255         balances[burner] = balances[burner].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         totalDistributed = totalDistributed.sub(_value);
258         emit Burn(burner, _value);
259     }
260     
261     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
262         AltcoinToken token = AltcoinToken(_tokenContract);
263         uint256 amount = token.balanceOf(address(this));
264         return token.transfer(owner, amount);
265     }
266 }