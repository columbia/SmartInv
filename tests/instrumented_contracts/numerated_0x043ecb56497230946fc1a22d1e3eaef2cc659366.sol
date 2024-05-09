1 //VEXA
2 pragma solidity ^0.4.18;
3 
4 /**
5  * @title SafeMath
6  */
7 library SafeMath {
8 
9     /**
10     * Multiplies two numbers, throws on overflow.
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
22     * Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract AltcoinToken {
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
68 contract SeaxExchange is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "Seax Exchange";
77     string public constant symbol = "SEAX";
78     uint public constant decimals = 8;
79     
80     uint256 public totalSupply = 50000000000e8;
81     uint256 public totalDistributed = 0;        
82     uint256 public tokensPerEth = 50000000e8;
83     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
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
110     
111     
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124     
125     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126         totalDistributed = totalDistributed.add(_amount);        
127         balances[_to] = balances[_to].add(_amount);
128         emit Distr(_to, _amount);
129         emit Transfer(address(0), _to, _amount);
130 
131         return true;
132     }
133 
134     function doAirdrop(address _participant, uint _amount) internal {
135 
136         require( _amount > 0 );      
137 
138         require( totalDistributed < totalSupply );
139         
140         balances[_participant] = balances[_participant].add(_amount);
141         totalDistributed = totalDistributed.add(_amount);
142 
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146 
147         // log
148         emit Airdrop(_participant, _amount, balances[_participant]);
149         emit Transfer(address(0), _participant, _amount);
150     }
151 
152     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
153         doAirdrop(_participant, _amount);
154     }
155 
156     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
157         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
158     }
159 
160     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
161         tokensPerEth = _tokensPerEth;
162         emit TokensPerEthUpdated(_tokensPerEth);
163     }
164            
165     function () external payable {
166         getTokens();
167      }
168     
169     function getTokens() payable canDistr  public {
170         uint256 tokens = 0;
171 
172         require( msg.value >= minContribution );
173 
174         require( msg.value > 0 );
175         
176         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
177         address investor = msg.sender;
178         
179         if (tokens > 0) {
180             distr(investor, tokens);
181         }
182 
183         if (totalDistributed >= totalSupply) {
184             distributionFinished = true;
185         }
186     }
187 
188     function balanceOf(address _owner) constant public returns (uint256) {
189         return balances[_owner];
190     }
191 
192     // mitigates the ERC20 short address attack
193     modifier onlyPayloadSize(uint size) {
194         assert(msg.data.length >= size + 4);
195         _;
196     }
197     
198     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
199 
200         require(_to != address(0));
201         require(_amount <= balances[msg.sender]);
202         
203         balances[msg.sender] = balances[msg.sender].sub(_amount);
204         balances[_to] = balances[_to].add(_amount);
205         emit Transfer(msg.sender, _to, _amount);
206         return true;
207     }
208     
209     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
210 
211         require(_to != address(0));
212         require(_amount <= balances[_from]);
213         require(_amount <= allowed[_from][msg.sender]);
214         
215         balances[_from] = balances[_from].sub(_amount);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(_from, _to, _amount);
219         return true;
220     }
221     
222     function approve(address _spender, uint256 _value) public returns (bool success) {
223         // mitigates the ERC20 spend/approval race condition
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
235         AltcoinToken t = AltcoinToken(tokenAddress);
236         uint bal = t.balanceOf(who);
237         return bal;
238     }
239     
240     function withdraw() onlyOwner public {
241         address myAddress = this;
242         uint256 etherBalance = myAddress.balance;
243         owner.transfer(etherBalance);
244     }
245     
246     function burn(uint256 _value) onlyOwner public {
247         require(_value <= balances[msg.sender]);
248         
249         address burner = msg.sender;
250         balances[burner] = balances[burner].sub(_value);
251         totalSupply = totalSupply.sub(_value);
252         totalDistributed = totalDistributed.sub(_value);
253         emit Burn(burner, _value);
254     }
255     
256     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
257         AltcoinToken token = AltcoinToken(_tokenContract);
258         uint256 amount = token.balanceOf(address(this));
259         return token.transfer(owner, amount);
260     }
261 }