1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : VENX
6 // Name        : VeChainX
7 // Total supply: 1000000000
8 // Decimals    : 18
9 //
10 //
11 // (c) VeChainX
12 
13 /**
14  * @title SafeMath
15  */
16 library SafeMath {
17 
18     /**
19     * Multiplies two numbers, throws on overflow.
20     */
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     /**
31     * Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         // uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return a / b;
38     }
39 
40     /**
41     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     /**
49     * Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 contract AltcoinToken {
59     function balanceOf(address _owner) constant public returns (uint256);
60     function transfer(address _to, uint256 _value) public returns (bool);
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) public constant returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ERC20 is ERC20Basic {
71     function allowance(address owner, address spender) public constant returns (uint256);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract VeChainX is ERC20 {
78     
79     using SafeMath for uint256;
80     address owner = msg.sender;
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;    
84 
85     string public constant name = "VeChainX";
86     string public constant symbol = "VENX";
87     uint public constant decimals = 18;
88     
89     uint256 public totalSupply = 1000000000e18;
90     uint256 public totalDistributed = 0;        
91     uint256 public tokensPerEth = 3000000e18;
92     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     event Distr(address indexed to, uint256 amount);
98     event DistrFinished();
99 
100     event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102     event TokensPerEthUpdated(uint _tokensPerEth);
103     
104     event Burn(address indexed burner, uint256 value);
105 
106     bool public distributionFinished = false;
107     
108     modifier canDistr() {
109         require(!distributionFinished);
110         _;
111     }
112     
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     
119     function VeChainX () public {
120         owner = msg.sender;
121         uint256 devTokens = 250000000e18;
122         distr(owner, devTokens);
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130     
131 
132     function finishDistribution() onlyOwner canDistr public returns (bool) {
133         distributionFinished = true;
134         emit DistrFinished();
135         return true;
136     }
137     
138     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
139         totalDistributed = totalDistributed.add(_amount);        
140         balances[_to] = balances[_to].add(_amount);
141         emit Distr(_to, _amount);
142         emit Transfer(address(0), _to, _amount);
143 
144         return true;
145     }
146 
147     function doAirdrop(address _participant, uint _amount) internal {
148 
149         require( _amount > 0 );      
150 
151         require( totalDistributed < totalSupply );
152         
153         balances[_participant] = balances[_participant].add(_amount);
154         totalDistributed = totalDistributed.add(_amount);
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159 
160         // log
161         emit Airdrop(_participant, _amount, balances[_participant]);
162         emit Transfer(address(0), _participant, _amount);
163     }
164 
165     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
166         doAirdrop(_participant, _amount);
167     }
168 
169     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
170         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
171     }
172 
173     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
174         tokensPerEth = _tokensPerEth;
175         emit TokensPerEthUpdated(_tokensPerEth);
176     }
177            
178     function () external payable {
179         getTokens();
180      }
181     
182     function getTokens() payable canDistr  public {
183         uint256 tokens = 0;
184 
185         require( msg.value >= minContribution );
186 
187         require( msg.value > 0 );
188         
189         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
190         address investor = msg.sender;
191         
192         if (tokens > 0) {
193             distr(investor, tokens);
194         }
195 
196         if (totalDistributed >= totalSupply) {
197             distributionFinished = true;
198         }
199     }
200 
201     function balanceOf(address _owner) constant public returns (uint256) {
202         return balances[_owner];
203     }
204 
205     // mitigates the ERC20 short address attack
206     modifier onlyPayloadSize(uint size) {
207         assert(msg.data.length >= size + 4);
208         _;
209     }
210     
211     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
212 
213         require(_to != address(0));
214         require(_amount <= balances[msg.sender]);
215         
216         balances[msg.sender] = balances[msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221     
222     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
223 
224         require(_to != address(0));
225         require(_amount <= balances[_from]);
226         require(_amount <= allowed[_from][msg.sender]);
227         
228         balances[_from] = balances[_from].sub(_amount);
229         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
230         balances[_to] = balances[_to].add(_amount);
231         emit Transfer(_from, _to, _amount);
232         return true;
233     }
234     
235     function approve(address _spender, uint256 _value) public returns (bool success) {
236         // mitigates the ERC20 spend/approval race condition
237         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
238         allowed[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242     
243     function allowance(address _owner, address _spender) constant public returns (uint256) {
244         return allowed[_owner][_spender];
245     }
246     
247     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
248         AltcoinToken t = AltcoinToken(tokenAddress);
249         uint bal = t.balanceOf(who);
250         return bal;
251     }
252     
253     function withdraw() onlyOwner public {
254         address myAddress = this;
255         uint256 etherBalance = myAddress.balance;
256         owner.transfer(etherBalance);
257     }
258     
259     function burn(uint256 _value) onlyOwner public {
260         require(_value <= balances[msg.sender]);
261         
262         address burner = msg.sender;
263         balances[burner] = balances[burner].sub(_value);
264         totalSupply = totalSupply.sub(_value);
265         totalDistributed = totalDistributed.sub(_value);
266         emit Burn(burner, _value);
267     }
268     
269     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
270         AltcoinToken token = AltcoinToken(_tokenContract);
271         uint256 amount = token.balanceOf(address(this));
272         return token.transfer(owner, amount);
273     }
274 }