1 // © atomux.net. 2018 All Rights Reserved
2 // https://atomux.net
3 // Contact: info@atomux.net
4 // twitter.com/atomuxnet
5 // By Atomux DEV.
6 // Token: AtomUX(AUX)
7 // Decimals : 8
8 // TotalSupply : 10000000000
9 
10 pragma solidity ^0.4.18;
11 
12 /**
13  * @title SafeMath
14  */
15 library SafeMath {
16 
17     /**
18     * Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     /**
48     * Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract AltcoinToken {
58     function balanceOf(address _owner) constant public returns (uint256);
59     function transfer(address _to, uint256 _value) public returns (bool);
60 }
61 
62 contract ERC20Basic {
63     uint256 public totalSupply;
64     function balanceOf(address who) public constant returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public constant returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract AtomUX is ERC20 {
77     
78     using SafeMath for uint256;
79     address owner = msg.sender;
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;    
83 
84     string public constant name = "AtomUX";
85     string public constant symbol = "AUX";
86     uint public constant decimals = 8;
87     
88     uint256 public totalSupply = 10000000000e8;
89     uint256 public totalDistributed = 0;        
90     uint256 public tokensPerEth = 20000000e8;
91     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
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
118     function AtomUX () public {
119         owner = msg.sender;
120         uint256 devTokens = 100000000e8;
121         distr(owner, devTokens);
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129     
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145 
146     function doAirdrop(address _participant, uint _amount) internal {
147 
148         require( _amount > 0 );      
149 
150         require( totalDistributed < totalSupply );
151         
152         balances[_participant] = balances[_participant].add(_amount);
153         totalDistributed = totalDistributed.add(_amount);
154 
155         if (totalDistributed >= totalSupply) {
156             distributionFinished = true;
157         }
158 
159         // log
160         emit Airdrop(_participant, _amount, balances[_participant]);
161         emit Transfer(address(0), _participant, _amount);
162     }
163 
164     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
165         doAirdrop(_participant, _amount);
166     }
167 
168     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
169         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
170     }
171 
172     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
173         tokensPerEth = _tokensPerEth;
174         emit TokensPerEthUpdated(_tokensPerEth);
175     }
176            
177     function () external payable {
178         getTokens();
179      }
180     
181     function getTokens() payable canDistr  public {
182         uint256 tokens = 0;
183 
184         require( msg.value >= minContribution );
185 
186         require( msg.value > 0 );
187         
188         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
189         address investor = msg.sender;
190         
191         if (tokens > 0) {
192             distr(investor, tokens);
193         }
194 
195         if (totalDistributed >= totalSupply) {
196             distributionFinished = true;
197         }
198     }
199 
200     function balanceOf(address _owner) constant public returns (uint256) {
201         return balances[_owner];
202     }
203 
204     // mitigates the ERC20 short address attack
205     modifier onlyPayloadSize(uint size) {
206         assert(msg.data.length >= size + 4);
207         _;
208     }
209     
210     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
211 
212         require(_to != address(0));
213         require(_amount <= balances[msg.sender]);
214         
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         emit Transfer(msg.sender, _to, _amount);
218         return true;
219     }
220     
221     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
222 
223         require(_to != address(0));
224         require(_amount <= balances[_from]);
225         require(_amount <= allowed[_from][msg.sender]);
226         
227         balances[_from] = balances[_from].sub(_amount);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Transfer(_from, _to, _amount);
231         return true;
232     }
233     
234     function approve(address _spender, uint256 _value) public returns (bool success) {
235         // mitigates the ERC20 spend/approval race condition
236         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241     
242     function allowance(address _owner, address _spender) constant public returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245     
246     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
247         AltcoinToken t = AltcoinToken(tokenAddress);
248         uint bal = t.balanceOf(who);
249         return bal;
250     }
251     
252     function withdraw() onlyOwner public {
253         address myAddress = this;
254         uint256 etherBalance = myAddress.balance;
255         owner.transfer(etherBalance);
256     }
257     
258     function burn(uint256 _value) onlyOwner public {
259         require(_value <= balances[msg.sender]);
260         
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         totalDistributed = totalDistributed.sub(_value);
265         emit Burn(burner, _value);
266     }
267     
268     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
269         AltcoinToken token = AltcoinToken(_tokenContract);
270         uint256 amount = token.balanceOf(address(this));
271         return token.transfer(owner, amount);
272     }
273 }