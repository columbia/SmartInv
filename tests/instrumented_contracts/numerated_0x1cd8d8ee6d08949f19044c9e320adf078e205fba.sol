1 pragma solidity ^0.4.24;
2 //Luxuriumgold Official 
3 //TotalSupply :500000000
4 //Symbol      :LUXG
5 //CopyRight   :2018 Official Luxuriumgold
6 
7 /**
8  * @title SafeMath
9  */
10 library SafeMath {
11 
12     /**
13     * Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 contract AltcoinToken {
53     function balanceOf(address _owner) constant public returns (uint256);
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public constant returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract Luxuriumgold is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;    
78 
79     string public constant name = "Luxuriumgold";
80     string public constant symbol = "LUXG";
81     uint public constant decimals = 8;
82     
83     uint256 public totalSupply = 500000000e8;
84     uint256 public totalDistributed = 0;        
85     uint256 public tokensPerEth = 100000e8;
86     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90     
91     event Distr(address indexed to, uint256 amount);
92     event DistrFinished();
93 
94     event Airdrop(address indexed _owner, uint _amount, uint _balance);
95 
96     event TokensPerEthUpdated(uint _tokensPerEth);
97     
98     event Burn(address indexed burner, uint256 value);
99 
100     bool public distributionFinished = false;
101     
102     modifier canDistr() {
103         require(!distributionFinished);
104         _;
105     }
106     
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111     
112     
113     constructor() public {
114         owner = 0xfDaa4324F0dC0AC49aB4Eacf4624120f6F0d8280;
115         uint256 devTokens = 100000000e8;
116         distr(owner, devTokens);
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124     
125 
126     function finishDistribution() onlyOwner canDistr public returns (bool) {
127         distributionFinished = true;
128         emit DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);        
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137 
138         return true;
139     }
140 
141     function doAirdrop(address _participant, uint _amount) internal {
142 
143         require( _amount > 0 );      
144 
145         require( totalDistributed < totalSupply );
146         
147         balances[_participant] = balances[_participant].add(_amount);
148         totalDistributed = totalDistributed.add(_amount);
149 
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153 
154         // log
155         emit Airdrop(_participant, _amount, balances[_participant]);
156         emit Transfer(address(0), _participant, _amount);
157     }
158 
159     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
160         doAirdrop(_participant, _amount);
161     }
162 
163     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
164         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
165     }
166 
167     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
168         tokensPerEth = _tokensPerEth;
169         emit TokensPerEthUpdated(_tokensPerEth);
170     }
171            
172     function () external payable {
173         getTokens();
174      }
175     
176     function getTokens() payable canDistr  public {
177         uint256 tokens = 0;
178 
179         require( msg.value >= minContribution );
180 
181         require( msg.value > 0 );
182         
183         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
184         address investor = msg.sender;
185         
186         if (tokens > 0) {
187             distr(investor, tokens);
188         }
189 
190         if (totalDistributed >= totalSupply) {
191             distributionFinished = true;
192         }
193     }
194 
195     function balanceOf(address _owner) constant public returns (uint256) {
196         return balances[_owner];
197     }
198 
199     // mitigates the ERC20 short address attack
200     modifier onlyPayloadSize(uint size) {
201         assert(msg.data.length >= size + 4);
202         _;
203     }
204     
205     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
206 
207         require(_to != address(0));
208         require(_amount <= balances[msg.sender]);
209         
210         balances[msg.sender] = balances[msg.sender].sub(_amount);
211         balances[_to] = balances[_to].add(_amount);
212         emit Transfer(msg.sender, _to, _amount);
213         return true;
214     }
215     
216     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
217 
218         require(_to != address(0));
219         require(_amount <= balances[_from]);
220         require(_amount <= allowed[_from][msg.sender]);
221         
222         balances[_from] = balances[_from].sub(_amount);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         emit Transfer(_from, _to, _amount);
226         return true;
227     }
228     
229     function approve(address _spender, uint256 _value) public returns (bool success) {
230         // mitigates the ERC20 spend/approval race condition
231         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
232         allowed[msg.sender][_spender] = _value;
233         emit Approval(msg.sender, _spender, _value);
234         return true;
235     }
236     
237     function allowance(address _owner, address _spender) constant public returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240     
241     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
242         AltcoinToken t = AltcoinToken(tokenAddress);
243         uint bal = t.balanceOf(who);
244         return bal;
245     }
246     
247     function withdraw() onlyOwner public {
248         address myAddress = this;
249         uint256 etherBalance = myAddress.balance;
250         owner.transfer(etherBalance);
251     }
252     
253     function burn(uint256 _value) onlyOwner public {
254         require(_value <= balances[msg.sender]);
255         
256         address burner = msg.sender;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         totalDistributed = totalDistributed.sub(_value);
260         emit Burn(burner, _value);
261     }
262     
263     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
264         AltcoinToken token = AltcoinToken(_tokenContract);
265         uint256 amount = token.balanceOf(address(this));
266         return token.transfer(owner, amount);
267     }
268 }