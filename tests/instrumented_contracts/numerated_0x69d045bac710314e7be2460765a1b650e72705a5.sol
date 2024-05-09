1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ForeignToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BinTraid is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;    
71 
72     string public constant name = "BinTraid";
73     string public constant symbol = "BINT";
74     uint public constant decimals = 8;
75     
76     uint256 public totalSupply = 20000000000e8;
77     uint256 public totalDistributed =  0;    
78     uint256 public constant MIN_CONTRIBUTION = 1 ether / 50; // 0.01 Ether
79     uint256 public tokensPerEth = 10000000e8;
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     
84     event Distr(address indexed to, uint256 amount);
85     event DistrFinished();
86 
87     event Airdrop(address indexed _owner, uint _amount, uint _balance);
88 
89     event TokensPerEthUpdated(uint _tokensPerEth);
90     
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105     
106     function BinTraid() public {
107         owner = msg.sender;    
108         distr(owner, totalDistributed);
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116     
117 
118     function finishDistribution() onlyOwner canDistr public returns (bool) {
119         distributionFinished = true;
120         emit DistrFinished();
121         return true;
122     }
123     
124     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
125         totalDistributed = totalDistributed.add(_amount);        
126         balances[_to] = balances[_to].add(_amount);
127         emit Distr(_to, _amount);
128         emit Transfer(address(0), _to, _amount);
129 
130         return true;
131     }
132 
133     function doAirdrop(address _participant, uint _amount) internal {
134 
135         require( _amount > 0 );      
136 
137         require( totalDistributed < totalSupply );
138         
139         balances[_participant] = balances[_participant].add(_amount);
140         totalDistributed = totalDistributed.add(_amount);
141 
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145 
146         // log
147         emit Airdrop(_participant, _amount, balances[_participant]);
148         emit Transfer(address(0), _participant, _amount);
149     }
150 
151     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
152         doAirdrop(_participant, _amount);
153     }
154 
155     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
156         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
157     }
158 
159     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
160         tokensPerEth = _tokensPerEth;
161         emit TokensPerEthUpdated(_tokensPerEth);
162     }
163            
164     function () external payable {
165         getTokens();
166      }
167     
168     function getTokens() payable canDistr  public {
169         uint256 tokens = 0;
170 
171         // minimum contribution
172         require( msg.value >= MIN_CONTRIBUTION );
173 
174         require( msg.value > 0 );
175 
176         // get baseline number of tokens
177         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
178         address investor = msg.sender;
179         
180         if (tokens > 0) {
181             distr(investor, tokens);
182         }
183 
184         if (totalDistributed >= totalSupply) {
185             distributionFinished = true;
186         }
187     }
188 
189     function balanceOf(address _owner) constant public returns (uint256) {
190         return balances[_owner];
191     }
192 
193     // mitigates the ERC20 short address attack
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
224         // mitigates the ERC20 spend/approval race condition
225         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230     
231     function allowance(address _owner, address _spender) constant public returns (uint256) {
232         return allowed[_owner][_spender];
233     }
234     
235     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
236         ForeignToken t = ForeignToken(tokenAddress);
237         uint bal = t.balanceOf(who);
238         return bal;
239     }
240     
241     function withdraw() onlyOwner public {
242         address myAddress = this;
243         uint256 etherBalance = myAddress.balance;
244         owner.transfer(etherBalance);
245     }
246     
247     function burn(uint256 _value) onlyOwner public {
248         require(_value <= balances[msg.sender]);
249         // no need to require value <= totalSupply, since that would imply the
250         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
251 
252         address burner = msg.sender;
253         balances[burner] = balances[burner].sub(_value);
254         totalSupply = totalSupply.sub(_value);
255         totalDistributed = totalDistributed.sub(_value);
256         emit Burn(burner, _value);
257     }
258     
259     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
260         ForeignToken token = ForeignToken(_tokenContract);
261         uint256 amount = token.balanceOf(address(this));
262         return token.transfer(owner, amount);
263     }
264 }