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
68 contract LabtorumToken is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "LabtorumToken";
77     string public constant symbol = "LTR";
78     uint public constant decimals = 8;
79     uint public deadline = now + 65 * 1 days;
80     
81     uint256 public totalSupply = 3000000000e8;
82     uint256 public totalDistributed = 1000000000e8;    
83     uint256 public constant MIN_CONTRIBUTION = 1 ether / 1000; // 0.001 Ether
84     uint256 public tokensPerEth = 300000e8;
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
111     function LabtorumToken() public {
112         owner = msg.sender;        
113         distr(owner, totalDistributed);
114     }
115     
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
133     function doAirdrop(address _participant, uint _amount) onlyOwner internal {
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
151     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
152         doAirdrop(_participant, _amount);
153     }
154 
155     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
156         tokensPerEth = _tokensPerEth;
157         emit TokensPerEthUpdated(_tokensPerEth);
158     }
159            
160     function () external payable {
161         getTokens();
162      }
163     
164     function getTokens() payable canDistr  public {
165         uint256 tokens = 0;
166 
167         // minimum contribution
168         require( msg.value >= MIN_CONTRIBUTION );
169 
170         require( msg.value > 0 );
171 
172         // get baseline number of tokens
173         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
174         address investor = msg.sender;
175 
176 	    if (now >= deadline) {
177             distributionFinished = true;
178         }
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
189     
190 
191     function balanceOf(address _owner) constant public returns (uint256) {
192         return balances[_owner];
193     }
194 
195     // mitigates the ERC20 short address attack
196     modifier onlyPayloadSize(uint size) {
197         assert(msg.data.length >= size + 4);
198         _;
199     }
200     
201     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
202 
203         require(_to != address(0));
204         require(_amount <= balances[msg.sender]);
205         
206         balances[msg.sender] = balances[msg.sender].sub(_amount);
207         balances[_to] = balances[_to].add(_amount);
208         emit Transfer(msg.sender, _to, _amount);
209         return true;
210     }
211     
212     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
213 
214         require(_to != address(0));
215         require(_amount <= balances[_from]);
216         require(_amount <= allowed[_from][msg.sender]);
217         
218         balances[_from] = balances[_from].sub(_amount);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
220         balances[_to] = balances[_to].add(_amount);
221         emit Transfer(_from, _to, _amount);
222         return true;
223     }
224     
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         // mitigates the ERC20 spend/approval race condition
227         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
228         allowed[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232     
233     function allowance(address _owner, address _spender) constant public returns (uint256) {
234         return allowed[_owner][_spender];
235     }
236     
237     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
238         ForeignToken t = ForeignToken(tokenAddress);
239         uint bal = t.balanceOf(who);
240         return bal;
241     }
242     
243     function withdraw() onlyOwner public {
244         address myAddress = this;
245         uint256 etherBalance = myAddress.balance;
246         owner.transfer(etherBalance);
247     }
248     
249     function burn(uint256 _value) onlyOwner public {
250         require(_value <= balances[msg.sender]);
251         // no need to require value <= totalSupply, since that would imply the
252         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
253 
254         address burner = msg.sender;
255         balances[burner] = balances[burner].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         totalDistributed = totalDistributed.sub(_value);
258         emit Burn(burner, _value);
259     }
260     
261     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
262         ForeignToken token = ForeignToken(_tokenContract);
263         uint256 amount = token.balanceOf(address(this));
264         return token.transfer(owner, amount);
265     }
266 }