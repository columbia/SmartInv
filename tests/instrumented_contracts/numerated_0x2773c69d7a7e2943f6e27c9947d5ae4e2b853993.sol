1 pragma solidity ^0.4.18;
2 
3 /**EtherDiamond will be used to invest the Real Assets
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
68 contract EtherDiamond is ERC20 {
69 
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75 
76     string public constant name = "EtherDiamond";
77     string public constant symbol = "ETD";
78     uint public constant decimals = 8;
79 
80     uint256 public totalSupply = 1000000000e8;
81     uint256 public totalDistributed = 0;
82     uint256 public tokensPerEth = 28000e8;
83     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
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
110     function EtherDiamond () public {
111         owner = msg.sender;
112         uint256 devTokens = 200000000e8;
113         distr(owner, devTokens);
114     }
115 
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121 
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
138     function doAirdrop(address _participant, uint _amount) internal {
139 
140         require( _amount > 0 );
141 
142         require( totalDistributed < totalSupply );
143 
144         balances[_participant] = balances[_participant].add(_amount);
145         totalDistributed = totalDistributed.add(_amount);
146 
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150 
151         // log
152         emit Airdrop(_participant, _amount, balances[_participant]);
153         emit Transfer(address(0), _participant, _amount);
154     }
155 
156     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {
157         doAirdrop(_participant, _amount);
158     }
159 
160     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {
161         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
162     }
163 
164 	function adminClaimAirdropMultiple2(address[] _addresses, uint _amount) public onlyOwner {
165         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
166     }
167 	
168     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {
169         tokensPerEth = _tokensPerEth;
170         emit TokensPerEthUpdated(_tokensPerEth);
171     }
172 
173     function () external payable {
174         getTokens();
175      }
176 
177     function getTokens() payable canDistr  public {
178         uint256 tokens = 0;
179 
180         require( msg.value >= minContribution );
181 
182         require( msg.value > 0 );
183 
184         tokens = tokensPerEth.mul(msg.value) / 1 ether;
185         address investor = msg.sender;
186 
187         if (tokens > 0) {
188             distr(investor, tokens);
189         }
190 
191         if (totalDistributed >= totalSupply) {
192             distributionFinished = true;
193         }
194     }
195 
196     function balanceOf(address _owner) constant public returns (uint256) {
197         return balances[_owner];
198     }
199 
200     // mitigates the ERC20 short address attack
201     modifier onlyPayloadSize(uint size) {
202         assert(msg.data.length >= size + 4);
203         _;
204     }
205 
206     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
207 
208         require(_to != address(0));
209         require(_amount <= balances[msg.sender]);
210 
211         balances[msg.sender] = balances[msg.sender].sub(_amount);
212         balances[_to] = balances[_to].add(_amount);
213         emit Transfer(msg.sender, _to, _amount);
214         return true;
215     }
216 
217     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
218 
219         require(_to != address(0));
220         require(_amount <= balances[_from]);
221         require(_amount <= allowed[_from][msg.sender]);
222 
223         balances[_from] = balances[_from].sub(_amount);
224         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         emit Transfer(_from, _to, _amount);
227         return true;
228     }
229 
230     function approve(address _spender, uint256 _value) public returns (bool success) {
231         // mitigates the ERC20 spend/approval race condition
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
243         AltcoinToken t = AltcoinToken(tokenAddress);
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
256 
257         address burner = msg.sender;
258         balances[burner] = balances[burner].sub(_value);
259         totalSupply = totalSupply.sub(_value);
260         totalDistributed = totalDistributed.sub(_value);
261         emit Burn(burner, _value);
262     }
263 
264     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
265         AltcoinToken token = AltcoinToken(_tokenContract);
266         uint256 amount = token.balanceOf(address(this));
267         return token.transfer(owner, amount);
268     }
269 }