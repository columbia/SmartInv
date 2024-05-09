1 pragma solidity ^0.4.25;
2 /**
3  * @title Happy Melody Token
4  * @dev Happy Melody Token Smart Contract
5  */
6 // Public Sale: 10 November      Public Sale Ends: 30 November
7 // Min. Purchase: 0.01 ETH
8 // Initial Value: 1HMT = 0.00000005
9 // Number of tokens for sale: 9.000.000.000 HMT (60%)
10 // Fouder + CEO  10%
11 // Team 3%
12 // DEV 2%
13 // Marketting + Partnerships 15%
14 // Telegram : https://t.me/HappyMelodyToken_HMT
15 // Fabook : https://www.facebook.com/HappyMelodyToken/
16 library SafeMath {
17 
18     
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28    
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30       
31         return a / b;
32     }
33 
34     
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40    
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
67 contract HappyMelodyToken is ERC20 {
68 // HappyMelodyToken
69 // Token name: Happy Melody Token
70 // Symbol: HMT
71 // Decimals: 18
72 // This creates an array with all balances 
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;    
78 
79     string public constant name = "Happy Melody Token";                      // Set the name for dis
80     string public constant symbol = "HMT";                                   // Set the symbol for display purposes
81     uint public constant decimals = 8;                                      // Amount of decimals for display purposes
82     
83     uint256 public totalSupply = 15000000000e8;                             // Update total supply
84     uint256 public totalDistributed = 0;        
85     uint256 public tokensPerEth = 15000000e8;
86     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
87 //Soft Cap 150ETH
88 //Hard Cap 600ETH
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91     
92     event Distr(address indexed to, uint256 amount);
93     event DistrFinished();
94 //Enough Hard Cap to stop ico
95     event Airdrop(address indexed _owner, uint _amount, uint _balance);
96 
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     
99     event Burn(address indexed burner, uint256 value);
100 //All unsold tokens will be burn
101     bool public distributionFinished = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     
114     function HappyMelodyToken () public {
115         owner = msg.sender;
116         uint256 devTokens = 1500000000e8;
117         distr(owner, devTokens);
118 //Founder wallet is locked in 6 Months ( 0x06D49C0BbE8BBA7B42ab19E344242B3D057F53e3 )
119 //Team wallet is locked in 3 Months
120 //Advisor Wallet lock for 2 months
121     }
122     
123     function transferOwnership(address newOwner) onlyOwner public {
124         if (newOwner != address(0)) {
125             owner = newOwner;
126         }
127     }
128     
129 
130     function finishDistribution() onlyOwner canDistr public returns (bool) {
131         distributionFinished = true;
132         emit DistrFinished();
133         return true;
134     }
135     
136     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
137         totalDistributed = totalDistributed.add(_amount);        
138         balances[_to] = balances[_to].add(_amount);
139         emit Distr(_to, _amount);
140         emit Transfer(address(0), _to, _amount);
141 
142         return true;
143     }
144 
145     function doAirdrop(address _participant, uint _amount) internal {
146 
147         require( _amount > 0 );      
148 
149         require( totalDistributed < totalSupply );
150         
151         balances[_participant] = balances[_participant].add(_amount);
152         totalDistributed = totalDistributed.add(_amount);
153 
154         if (totalDistributed >= totalSupply) {
155             distributionFinished = true;
156         }
157 
158       
159         emit Airdrop(_participant, _amount, balances[_participant]);
160         emit Transfer(address(0), _participant, _amount);
161     }
162 
163     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
164         doAirdrop(_participant, _amount);
165     }
166 
167     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
168         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
169     }
170 
171     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
172         tokensPerEth = _tokensPerEth;
173         emit TokensPerEthUpdated(_tokensPerEth);
174     }
175            
176     function () external payable {
177         getTokens();
178      }
179     
180     function getTokens() payable canDistr  public {
181         uint256 tokens = 0;
182 
183         require( msg.value >= minContribution );
184 
185         require( msg.value > 0 );
186         
187         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
188         address investor = msg.sender;
189         
190         if (tokens > 0) {
191             distr(investor, tokens);
192         }
193 
194         if (totalDistributed >= totalSupply) {
195             distributionFinished = true;
196         }
197     }
198 
199     function balanceOf(address _owner) constant public returns (uint256) {
200         return balances[_owner];
201     }
202 
203     
204     modifier onlyPayloadSize(uint size) {
205         assert(msg.data.length >= size + 4);
206         _;
207     }
208 /* Send coins */
209     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
210 // Add and subtract new balances 
211         require(_to != address(0));
212         require(_amount <= balances[msg.sender]);
213 // Add and subtract new balances 
214         balances[msg.sender] = balances[msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219 /* transferFrom */
220     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
221 
222         require(_to != address(0));
223         require(_amount <= balances[_from]);
224         require(_amount <= allowed[_from][msg.sender]);
225         
226         balances[_from] = balances[_from].sub(_amount);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         emit Transfer(_from, _to, _amount);
230         return true;
231     }
232     
233     function approve(address _spender, uint256 _value) public returns (bool success) {
234 // mitigates the ERC20 spend/approval race condition
235         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
236         allowed[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 /* Withdraw */
241     function withdraw() onlyOwner public {
242         address myAddress = this;
243         uint256 etherBalance = myAddress.balance;
244         owner.transfer(etherBalance);
245     }
246 /* allowance */
247     function allowance(address _owner, address _spender) constant public returns (uint256) {
248         return allowed[_owner][_spender];
249     }
250 /* getTokens */
251     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
252         AltcoinToken t = AltcoinToken(tokenAddress);
253         uint bal = t.balanceOf(who);
254         return bal;
255     }
256 /* Burn */
257     function burn(uint256 _value) onlyOwner public {
258         require(_value <= balances[msg.sender]);
259         //All unsold tokens will be burn
260         address burner = msg.sender;
261         balances[burner] = balances[burner].sub(_value);
262         totalSupply = totalSupply.sub(_value);
263         totalDistributed = totalDistributed.sub(_value);
264         emit Burn(burner, _value);
265     }
266 /* withdrawAltcoinTokens */
267     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
268         AltcoinToken token = AltcoinToken(_tokenContract);
269         uint256 amount = token.balanceOf(address(this));
270         return token.transfer(owner, amount);
271     }
272 }