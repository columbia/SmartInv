1 /*
2 
3 CRYPSTONE
4 
5 */
6 pragma solidity ^0.4.25;
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
72 contract CRYPSTONE is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "CRYPSTONE";
81     string public constant symbol = "CST";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 800000000e8;
85     uint256 public totalDistributed = 0;        
86     uint256 public tokensPerEth = 3000e8;
87     uint256 public constant minContribution = 1 ether / 10; // 0.1 Ether
88 
89 	/**
90     * Tokens Per ETH Can be updated, Default is 3000 per ETH.
91     */
92 	
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98 
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104 
105     bool public distributionFinished = false;
106     
107     modifier canDistr() {
108         require(!distributionFinished);
109         _;
110     }
111     
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116 
117     
118     function transferOwnership(address newOwner) onlyOwner public {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123     
124 
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);        
133         balances[_to] = balances[_to].add(_amount);
134         emit Distr(_to, _amount);
135         emit Transfer(address(0), _to, _amount);
136 
137         return true;
138     }
139 
140     function doAirdrop(address _participant, uint _amount) internal {
141 
142         require( _amount > 0 );      
143 
144         require( totalDistributed < totalSupply );
145         
146         balances[_participant] = balances[_participant].add(_amount);
147         totalDistributed = totalDistributed.add(_amount);
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152 
153         // log
154         emit Airdrop(_participant, _amount, balances[_participant]);
155         emit Transfer(address(0), _participant, _amount);
156     }
157 
158     function adminSingleClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
159         doAirdrop(_participant, _amount);
160     }
161 
162     function adminMultipleClaimAirdrop(address[] _addresses, uint _amount) public onlyOwner {        
163         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
164     }
165 
166     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
167         tokensPerEth = _tokensPerEth;
168         emit TokensPerEthUpdated(_tokensPerEth);
169     }
170            
171     function () external payable {
172         getTokens();
173      }
174     
175     function getTokens() payable canDistr  public {
176         uint256 tokens = 0;
177 
178         require( msg.value >= minContribution );
179 
180         require( msg.value > 0 );
181         
182         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
183         address investor = msg.sender;
184         
185         if (tokens > 0) {
186             distr(investor, tokens);
187         }
188 
189         if (totalDistributed >= totalSupply) {
190             distributionFinished = true;
191         }
192     }
193 
194     function balanceOf(address _owner) constant public returns (uint256) {
195         return balances[_owner];
196     }
197 
198     // mitigates the ERC20 short address attack
199     modifier onlyPayloadSize(uint size) {
200         assert(msg.data.length >= size + 4);
201         _;
202     }
203     
204     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
205 
206         require(_to != address(0));
207         require(_amount <= balances[msg.sender]);
208         
209         balances[msg.sender] = balances[msg.sender].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         emit Transfer(msg.sender, _to, _amount);
212         return true;
213     }
214     
215     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
216 
217         require(_to != address(0));
218         require(_amount <= balances[_from]);
219         require(_amount <= allowed[_from][msg.sender]);
220         
221         balances[_from] = balances[_from].sub(_amount);
222         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
223         balances[_to] = balances[_to].add(_amount);
224         emit Transfer(_from, _to, _amount);
225         return true;
226     }
227     
228     function approve(address _spender, uint256 _value) public returns (bool success) {
229         // mitigates the ERC20 spend/approval race condition
230         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
231         allowed[msg.sender][_spender] = _value;
232         emit Approval(msg.sender, _spender, _value);
233         return true;
234     }
235     
236     function allowance(address _owner, address _spender) constant public returns (uint256) {
237         return allowed[_owner][_spender];
238     }
239     
240     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
241         AltcoinToken t = AltcoinToken(tokenAddress);
242         uint bal = t.balanceOf(who);
243         return bal;
244     }
245     
246     function withdraw() onlyOwner public {
247         address myAddress = this;
248         uint256 etherBalance = myAddress.balance;
249         owner.transfer(etherBalance);
250     }
251     
252     function burn(uint256 _value) onlyOwner public {
253         require(_value <= balances[msg.sender]);
254         
255         address burner = msg.sender;
256         balances[burner] = balances[burner].sub(_value);
257         totalSupply = totalSupply.sub(_value);
258         totalDistributed = totalDistributed.sub(_value);
259         emit Burn(burner, _value);
260     }
261     
262     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
263         AltcoinToken token = AltcoinToken(_tokenContract);
264         uint256 amount = token.balanceOf(address(this));
265         return token.transfer(owner, amount);
266     }
267 }