1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address _owner) constant public returns (uint256);
51     function transfer(address _to, uint256 _value) public returns (bool);
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract GMBEL is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed;    
76 
77     string public constant name = "G-Mbel";
78     string public constant symbol = "GMBEL";
79     uint public constant decimals = 18;
80     
81     uint256 public totalSupply = 7000000000000e18;
82     uint256 public totalDistributed;    
83     uint256 public constant MIN_CONTRIBUTION = 1 ether / 10000; // 0.0001 Ether
84     uint256 public tokensPerEth = 100000000e18;
85     uint256 public initialBonus = 1000000e18;
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     
90     event Distr(address indexed to, uint256 amount);
91     event DistrFinished();
92     
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96 
97     event InitialBonusUpdated(uint _initialBonus);
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
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         emit DistrFinished();
123         return true;
124     }
125     
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);        
128         balances[_to] = balances[_to].add(_amount);
129         emit Distr(_to, _amount);
130         emit Transfer(address(0), _to, _amount);
131 
132         return true;
133     }
134     
135     function Distribute(address _participant, uint _amount) onlyOwner internal {
136 
137         require( _amount > 0 );      
138 
139         require( totalDistributed < totalSupply );
140         
141         balances[_participant] = balances[_participant].add(_amount);
142         totalDistributed = totalDistributed.add(_amount);
143 
144         if (totalDistributed >= totalSupply) {
145             distributionFinished = true;
146         }
147 
148         // log
149         emit Airdrop(_participant, _amount, balances[_participant]);
150         emit Transfer(address(0), _participant, _amount);
151     }
152     
153     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
154         Distribute(_participant, _amount);
155     }
156 
157     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
158         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
159     }
160 
161     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
162         tokensPerEth = _tokensPerEth;
163         emit TokensPerEthUpdated(_tokensPerEth);
164     }
165 
166     function updateInitialBonus(uint _initialBonus) public onlyOwner {        
167         initialBonus = _initialBonus;
168         emit InitialBonusUpdated(_initialBonus);
169     }
170            
171     function () external payable {
172         getTokens();
173      }
174     
175     function getTokens() payable canDistr  public {
176         uint256 tokens = 0;
177         uint256 bonus = 0;
178 
179         require( msg.value >= MIN_CONTRIBUTION );
180         require( msg.value > 0 );
181 
182         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
183         address investor = msg.sender;
184         bonus = tokens + initialBonus;
185 
186         if (Claimed[investor] == false) {
187             distr(investor, bonus);
188             Claimed[investor] = true;
189         }else{
190             distr(investor, tokens);
191         }
192 
193         if (totalDistributed >= totalSupply) {
194             distributionFinished = true;
195         }
196     }
197     
198     function balanceOf(address _owner) constant public returns (uint256) {
199         return balances[_owner];
200     }
201 
202     modifier onlyPayloadSize(uint size) {
203         assert(msg.data.length >= size + 4);
204         _;
205     }
206     
207     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
208 
209         require(_to != address(0));
210         require(_amount <= balances[msg.sender]);
211         
212         balances[msg.sender] = balances[msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Transfer(msg.sender, _to, _amount);
215         return true;
216     }
217     
218     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
219 
220         require(_to != address(0));
221         require(_amount <= balances[_from]);
222         require(_amount <= allowed[_from][msg.sender]);
223         
224         balances[_from] = balances[_from].sub(_amount);
225         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
226         balances[_to] = balances[_to].add(_amount);
227         emit Transfer(_from, _to, _amount);
228         return true;
229     }
230     
231     function approve(address _spender, uint256 _value) public returns (bool success) {
232         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237     
238     function allowance(address _owner, address _spender) constant public returns (uint256) {
239         return allowed[_owner][_spender];
240     }
241     
242     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
243         ForeignToken t = ForeignToken(tokenAddress);
244         uint bal = t.balanceOf(who);
245         return bal;
246     }
247     
248     function withdraw() onlyOwner public {
249         address myAddress = this;
250         uint256 etherBalance = myAddress.balance;
251         owner.transfer(etherBalance);
252     }
253     
254     function burn(uint256 _value) onlyOwner public {
255         require(_value <= balances[msg.sender]);
256         address burner = msg.sender;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         totalDistributed = totalDistributed.sub(_value);
260         emit Burn(burner, _value);
261     }
262     
263     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
264         ForeignToken token = ForeignToken(_tokenContract);
265         uint256 amount = token.balanceOf(address(this));
266         return token.transfer(owner, amount);
267     }
268 }