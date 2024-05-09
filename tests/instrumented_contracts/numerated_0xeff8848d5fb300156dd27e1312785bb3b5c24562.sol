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
68 contract BitDeFi is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "BitDeFi";
77     string public constant symbol = "BDF";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 7000e8;
81     uint256 public totalDistributed = 0;    
82     uint256 public constant MIN_CONTRIBUTION = 1 ether / 10; // 0.1 Ether
83     uint256 public tokensPerEth = 20e8;
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
97     bool public distributionFinished = false;
98     
99     modifier canDistr() {
100         require(!distributionFinished);
101         _;
102     }
103     
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }
108     
109     
110     function BitDeFi () public {
111         owner = msg.sender;    
112         distr(owner, totalDistributed);
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
175         // minimum contribution
176         require( msg.value >= MIN_CONTRIBUTION );
177 
178         require( msg.value > 0 );
179 
180         // get baseline number of tokens
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
240         ForeignToken t = ForeignToken(tokenAddress);
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
253         // no need to require value <= totalSupply, since that would imply the
254         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
255 
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