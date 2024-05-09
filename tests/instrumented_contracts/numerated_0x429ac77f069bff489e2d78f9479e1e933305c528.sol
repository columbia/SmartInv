1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract AltcoinToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract Rizubot is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Rizubot";
76     string public constant symbol = "RZB";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 100000000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth = 100000000e8;
82     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86     
87     event Distr(address indexed to, uint256 amount);
88     event DistrFinished();
89 
90     event Airdrop(address indexed _owner, uint _amount, uint _balance);
91 
92     event TokensPerEthUpdated(uint _tokensPerEth);
93     
94     event Burn(address indexed burner, uint256 value);
95 
96     bool public distributionFinished = false;
97     
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     
108     function transferOwnership(address newOwner) onlyOwner public {
109         if (newOwner != address(0)) {
110             owner = newOwner;
111         }
112     }
113     
114 
115     function finishDistribution() onlyOwner canDistr public returns (bool) {
116         distributionFinished = true;
117         emit DistrFinished();
118         return true;
119         distributionFinished = false;
120         emit DistrFinished();
121         return false;
122     }
123     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
124         totalDistributed = totalDistributed.add(_amount);        
125         balances[_to] = balances[_to].add(_amount);
126         emit Distr(_to, _amount);
127         emit Transfer(address(0), _to, _amount);
128 
129         return true;
130     }
131 
132     function doAirdrop(address _participant, uint _amount) internal {
133 
134         require( _amount > 0 );      
135 
136         require( totalDistributed < totalSupply );
137         
138         balances[_participant] = balances[_participant].add(_amount);
139         totalDistributed = totalDistributed.add(_amount);
140 
141         if (totalDistributed >= totalSupply) {
142             distributionFinished = true;
143         }
144 
145         // log
146         emit Airdrop(_participant, _amount, balances[_participant]);
147         emit Transfer(address(0), _participant, _amount);
148     }
149 
150     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
151         doAirdrop(_participant, _amount);
152     }
153 
154     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
155         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
156     }
157 
158     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
159         tokensPerEth = _tokensPerEth;
160         emit TokensPerEthUpdated(_tokensPerEth);
161     }
162            
163     function () external payable {
164         getTokens();
165      }
166     
167     function getTokens() payable canDistr  public {
168         uint256 tokens = 0;
169 
170         require( msg.value >= minContribution );
171 
172         require( msg.value > 0 );
173         
174         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
175         address investor = msg.sender;
176         
177         if (tokens > 0) {
178             distr(investor, tokens);
179         }
180 
181         if (totalDistributed >= totalSupply) {
182             distributionFinished = true;
183         }
184     }
185 
186     function balanceOf(address _owner) constant public returns (uint256) {
187         return balances[_owner];
188     }
189 
190     // mitigates the ERC20 short address attack
191     modifier onlyPayloadSize(uint size) {
192         assert(msg.data.length >= size + 4);
193         _;
194     }
195     
196     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
197 
198         require(_to != address(0));
199         require(_amount <= balances[msg.sender]);
200         
201         balances[msg.sender] = balances[msg.sender].sub(_amount);
202         balances[_to] = balances[_to].add(_amount);
203         emit Transfer(msg.sender, _to, _amount);
204         return true;
205     }
206     
207     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
208 
209         require(_to != address(0));
210         require(_amount <= balances[_from]);
211         require(_amount <= allowed[_from][msg.sender]);
212         
213         balances[_from] = balances[_from].sub(_amount);
214         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(_from, _to, _amount);
217         return true;
218     }
219     
220     function approve(address _spender, uint256 _value) public returns (bool success) {
221         // mitigates the ERC20 spend/approval race condition
222         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227     
228     function allowance(address _owner, address _spender) constant public returns (uint256) {
229         return allowed[_owner][_spender];
230     }
231     
232     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
233         AltcoinToken t = AltcoinToken(tokenAddress);
234         uint bal = t.balanceOf(who);
235         return bal;
236     }
237     
238     function withdraw() onlyOwner public {
239         address myAddress = this;
240         uint256 etherBalance = myAddress.balance;
241         owner.transfer(etherBalance);
242     }
243     
244     function burn(uint256 _value) onlyOwner public {
245         require(_value <= balances[msg.sender]);
246         
247         address burner = msg.sender;
248         balances[burner] = balances[burner].sub(_value);
249         totalSupply = totalSupply.sub(_value);
250         totalDistributed = totalDistributed.sub(_value);
251         emit Burn(burner, _value);
252     }
253     
254     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
255         AltcoinToken token = AltcoinToken(_tokenContract);
256         uint256 amount = token.balanceOf(address(this));
257         return token.transfer(owner, amount);
258     }
259 }