1 /*
2 
3 In our view, there are fundamentally two different types of exchanges: the ones that deal with ﬁat currency; and the ones that deal purely in crypto. We are building a hybrid of the both with more focus on the crypto. Even though they are small now, we strongly believe that pure crypto exchanges will be bigger, many times bigger, than ﬁat based exchanges in the near future. They will play an ever more important role in world of ﬁnance and we call this new paradigm Bitfxt; Bitcoin - Forex technology. With your help, Bitfxt will build a world-class crypto exchange, powering the future of crypto ﬁnance.
4 
5 */
6 pragma solidity ^0.4.24;
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
72 contract BITFXTCOIN is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;    
79 
80     string public constant name = "BITFXT COIN";
81     string public constant symbol = "BXT";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 20000000e8;
85     uint256 public totalDistributed = 0;        
86     uint256 public tokensPerEth = 3000e8;
87     uint256 public constant minContribution = 1 ether / 100; // 0.1 Ether
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
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120 
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         emit DistrFinished();
124         return true;
125     }
126     
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);        
129         balances[_to] = balances[_to].add(_amount);
130         emit Distr(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132 
133         return true;
134     }
135 
136     function doAirdrop(address _participant, uint _amount) internal {
137 
138         require( _amount > 0 );      
139 
140         require( totalDistributed < totalSupply );
141         
142         balances[_participant] = balances[_participant].add(_amount);
143         totalDistributed = totalDistributed.add(_amount);
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148 
149         // log
150         emit Airdrop(_participant, _amount, balances[_participant]);
151         emit Transfer(address(0), _participant, _amount);
152     }
153 
154     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
155         doAirdrop(_participant, _amount);
156     }
157 
158     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
159         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
160     }
161 
162     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
163         tokensPerEth = _tokensPerEth;
164         emit TokensPerEthUpdated(_tokensPerEth);
165     }
166            
167     function () external payable {
168         getTokens();
169      }
170     
171     function getTokens() payable canDistr  public {
172         uint256 tokens = 0;
173 
174         require( msg.value >= minContribution );
175 
176         require( msg.value > 0 );
177         
178         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
179         address investor = msg.sender;
180         
181         if (tokens > 0) {
182             distr(investor, tokens);
183         }
184 
185         if (totalDistributed >= totalSupply) {
186             distributionFinished = true;
187         }
188     }
189 
190     function balanceOf(address _owner) constant public returns (uint256) {
191         return balances[_owner];
192     }
193 
194     // mitigates the ERC20 short address attack
195     modifier onlyPayloadSize(uint size) {
196         assert(msg.data.length >= size + 4);
197         _;
198     }
199     
200     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
201 
202         require(_to != address(0));
203         require(_amount <= balances[msg.sender]);
204         
205         balances[msg.sender] = balances[msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(msg.sender, _to, _amount);
208         return true;
209     }
210     
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212 
213         require(_to != address(0));
214         require(_amount <= balances[_from]);
215         require(_amount <= allowed[_from][msg.sender]);
216         
217         balances[_from] = balances[_from].sub(_amount);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Transfer(_from, _to, _amount);
221         return true;
222     }
223     
224     function approve(address _spender, uint256 _value) public returns (bool success) {
225         // mitigates the ERC20 spend/approval race condition
226         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231     
232     function allowance(address _owner, address _spender) constant public returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235     
236     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
237         AltcoinToken t = AltcoinToken(tokenAddress);
238         uint bal = t.balanceOf(who);
239         return bal;
240     }
241     
242     function withdraw() onlyOwner public {
243         address myAddress = this;
244         uint256 etherBalance = myAddress.balance;
245         owner.transfer(etherBalance);
246     }
247     
248     function burn(uint256 _value) onlyOwner public {
249         require(_value <= balances[msg.sender]);
250         
251         address burner = msg.sender;
252         balances[burner] = balances[burner].sub(_value);
253         totalSupply = totalSupply.sub(_value);
254         totalDistributed = totalDistributed.sub(_value);
255         emit Burn(burner, _value);
256     }
257     
258     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
259         AltcoinToken token = AltcoinToken(_tokenContract);
260         uint256 amount = token.balanceOf(address(this));
261         return token.transfer(owner, amount);
262     }
263 }