1 //  https://histoken.online/
2 
3 pragma solidity ^0.4.18;
4 
5 /**
6  * @title SafeMath
7  */
8 library SafeMath {
9 
10     /**
11     * Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract AltcoinToken {
51     function balanceOf(address _owner) constant public returns (uint256);
52     function transfer(address _to, uint256 _value) public returns (bool);
53 }
54 
55 contract ERC20Basic {
56     uint256 public totalSupply;
57     function balanceOf(address who) public constant returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 contract ERC20 is ERC20Basic {
63     function allowance(address owner, address spender) public constant returns (uint256);
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65     function approve(address spender, uint256 value) public returns (bool);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract healthinsurance is ERC20 {
70     
71     using SafeMath for uint256;
72     address owner = msg.sender;
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;    
76 
77     string public constant name = "health insurance";
78     string public constant symbol = "HIS";
79     uint public constant decimals = 8;
80     
81     uint256 public totalSupply = 10000000000e8;
82     uint256 public totalDistributed = 0;        
83     uint256 public tokensPerEth = 20000000e8;
84     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
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
111     
112     
113     function transferOwnership(address newOwner) onlyOwner public {
114         if (newOwner != address(0)) {
115             owner = newOwner;
116         }
117     }
118     
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
135     function doAirdrop(address _participant, uint _amount) internal {
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
153     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
154         doAirdrop(_participant, _amount);
155     }
156 
157     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
158         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
159     }
160 
161     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
162         tokensPerEth = _tokensPerEth;
163         emit TokensPerEthUpdated(_tokensPerEth);
164     }
165            
166     function () external payable {
167         getTokens();
168      }
169     
170     function getTokens() payable canDistr  public {
171         uint256 tokens = 0;
172 
173         require( msg.value >= minContribution );
174 
175         require( msg.value > 0 );
176         
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
236         AltcoinToken t = AltcoinToken(tokenAddress);
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
249         
250         address burner = msg.sender;
251         balances[burner] = balances[burner].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         totalDistributed = totalDistributed.sub(_value);
254         emit Burn(burner, _value);
255     }
256     
257     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
258         AltcoinToken token = AltcoinToken(_tokenContract);
259         uint256 amount = token.balanceOf(address(this));
260         return token.transfer(owner, amount);
261     }
262 }