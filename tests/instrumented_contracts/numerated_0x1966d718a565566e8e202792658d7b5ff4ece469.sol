1 //https://ndexnetwork.com
2 
3 pragma solidity ^0.4.21;
4 
5 /**
6  * @title SafeMath
7  */
8 library SafeMath {
9 
10     /**
11     * Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract AltcoinToken {
51     function balanceOf(address _owner) constant public returns (uint256);
52     function transfer(address _to, uint256 _value) public returns (bool);
53 }
54 
55 contract ERC20Basic {
56     uint256 public totalSupply;
57     function balanceOf(address who) public constant returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 contract ERC20 is ERC20Basic {
63     function allowance(address owner, address spender) public constant returns (uint256);
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65     function approve(address spender, uint256 value) public returns (bool);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract nDEX is ERC20 {
70     
71     using SafeMath for uint256;
72     address owner = msg.sender;
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;    
76 
77     string public constant name = "nDEX";
78     string public constant symbol = "NDX";
79     uint public constant decimals = 18;
80     
81     uint256 public totalSupply = 15000000000e18;
82     uint256 public totalDistributed = 0;        
83     uint256 public tokensPerEth = 5000000e18;
84     uint256 public constant minContribution = 1 ether / 50; // 0.02 Ether
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91 
92     event Airdrop(address indexed _owner, uint _amount, uint _balance);
93 
94     event TokensPerEthUpdated(uint _tokensPerEth);
95     
96     event Burn(address indexed burner, uint256 value);
97 
98     bool public distributionFinished = false;
99     
100     modifier canDistr() {
101         require(!distributionFinished);
102         _;
103     }
104     
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109     
110     
111     function nDEX() public {
112         owner = msg.sender;
113         uint256 devTokens = 5552598050e18;
114         distr(owner, devTokens);
115     }
116     
117     function transferOwnership(address newOwner) onlyOwner public {
118         if (newOwner != address(0)) {
119             owner = newOwner;
120         }
121     }
122     
123 
124     function finishDistribution() onlyOwner canDistr public returns (bool) {
125         distributionFinished = true;
126         emit DistrFinished();
127         return true;
128     }
129     
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
152         // Airdrop log
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