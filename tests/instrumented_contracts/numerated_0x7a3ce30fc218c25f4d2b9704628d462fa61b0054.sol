1 pragma solidity ^0.4.25;
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
68 contract RFTC is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     
76     string public constant name = "Resurrect Future Technology Chain";
77     string public constant symbol = "RFTC";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 9000000e8;
81     uint256 public totalDistributed;
82     uint256 public constant requestMinimum = 1 ether / 5; // 0.2 Ether
83     uint256 public tokensPerEth = 5000e8;
84     
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87     
88     event Distr(address indexed to, uint256 amount);
89     event DistrFinished();
90     
91     event Airdrop(address indexed _owner, uint _amount, uint _balance);
92 
93     event TokensPerEthUpdated(uint _tokensPerEth);
94     
95     event Burn(address indexed burner, uint256 value);
96     
97     event Add(uint256 value);
98 
99     bool public distributionFinished = false;
100     
101     modifier canDistr() {
102         require(!distributionFinished);
103         _;
104     }
105     
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     
111     constructor() public {
112         uint256 teamFund = 5000000e8;
113         owner = msg.sender;
114         distr(owner, teamFund);
115     }
116     
117     function transferOwnership(address newOwner) onlyOwner public {
118         if (newOwner != address(0)) {
119             owner = newOwner;
120         }
121     }
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
138     function Distribute(address _participant, uint _amount) onlyOwner internal {
139 
140         require( _amount > 0 );      
141         require( totalDistributed < totalSupply );
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
154     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
155         Distribute(_participant, _amount);
156     }
157 
158     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
159         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
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
174         require( msg.value >= requestMinimum );
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
194     modifier onlyPayloadSize(uint size) {
195         assert(msg.data.length >= size + 4);
196         _;
197     }
198     
199     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
200 
201         require(_to != address(0));
202         require(_amount <= balances[msg.sender]);
203         
204         balances[msg.sender] = balances[msg.sender].sub(_amount);
205         balances[_to] = balances[_to].add(_amount);
206         emit Transfer(msg.sender, _to, _amount);
207         return true;
208     }
209     
210     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[_from]);
214         require(_amount <= allowed[_from][msg.sender]);
215         
216         balances[_from] = balances[_from].sub(_amount);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(_from, _to, _amount);
220         return true;
221     }
222     
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229     
230     function allowance(address _owner, address _spender) constant public returns (uint256) {
231         return allowed[_owner][_spender];
232     }
233     
234     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
235         ForeignToken t = ForeignToken(tokenAddress);
236         uint bal = t.balanceOf(who);
237         return bal;
238     }
239     
240     function withdrawAll() onlyOwner public {
241         address myAddress = this;
242         uint256 etherBalance = myAddress.balance;
243         owner.transfer(etherBalance);
244     }
245 
246     function withdraw(uint256 _wdamount) onlyOwner public {
247         uint256 wantAmount = _wdamount;
248         owner.transfer(wantAmount);
249     }
250 
251     function burn(uint256 _value) onlyOwner public {
252         require(_value <= balances[msg.sender]);
253         address burner = msg.sender;
254         balances[burner] = balances[burner].sub(_value);
255         totalSupply = totalSupply.sub(_value);
256         totalDistributed = totalDistributed.sub(_value);
257         emit Burn(burner, _value);
258     }
259     
260     function add(uint256 _value) onlyOwner public {
261         uint256 counter = totalSupply.add(_value);
262         totalSupply = counter; 
263         emit Add(_value);
264     }
265     
266     
267     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
268         ForeignToken token = ForeignToken(_tokenContract);
269         uint256 amount = token.balanceOf(address(this));
270         return token.transfer(owner, amount);
271     }
272 }