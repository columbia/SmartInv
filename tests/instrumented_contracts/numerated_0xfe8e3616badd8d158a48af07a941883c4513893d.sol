1 pragma solidity ^0.4.25;
2 /**
3  * @title KamenToken
4  */
5 // Min Purchase: 0.01 ETH
6 // Token name: KamenToken
7 // Symbol: KNT
8 // Decimals: 18
9 //Website:https://kamentoken.co
10 // Telegram : https://t.me/KamenToken_KT
11 // Telegram Channel :https://t.me/KamenToken_Channel
12 library SafeMath {
13 
14     
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24    
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26       
27         return a / b;
28     }
29 
30     
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36    
37     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38         c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract AltcoinToken {
45     function balanceOf(address _owner) constant public returns (uint256);
46     function transfer(address _to, uint256 _value) public returns (bool);
47 }
48 
49 contract ERC20Basic {
50     uint256 public totalSupply;
51     function balanceOf(address who) public constant returns (uint256);
52     function transfer(address to, uint256 value) public returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public constant returns (uint256);
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59     function approve(address spender, uint256 value) public returns (bool);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract KamenToken is ERC20 {
64     using SafeMath for uint256;
65     address owner = msg.sender;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;    
69 
70     string public constant name = "Kamen Token";                                                  // Set the name for dis
71     string public constant symbol = "KNT";                                                        // Set the symbol for display purposes
72     uint public constant decimals = 18;                                                         // Amount of decimals for display purposes
73     
74     uint256 public totalSupply = 10000000000000000000000000000;                                  // Update total supply
75     uint256 public totalDistributed = 0;        
76     uint256 public tokensPerEth = 5000000000000000000000000;
77     uint256 public constant minContribution = 1 ether / 100; // 0.01 etherBalance               //Soft Cap 555ETH and Hard Cap 1400ETH
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84     //Enough Hard Cap to stop ico
85     event Airdrop(address indexed _owner, uint _amount, uint _balance);
86 
87     event TokensPerEthUpdated(uint _tokensPerEth);
88     
89     event Burn(address indexed burner, uint256 value);
90 
91     bool public distributionFinished = false;
92     
93     modifier canDistr() {
94         require(!distributionFinished);
95         _;
96     }
97     
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102     
103     
104     function KamenToken () public {
105         owner = msg.sender;
106         uint256 devTokens = 1000000000000000000000000000;
107         distr(owner, devTokens);
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115     
116 
117     function finishDistribution() onlyOwner canDistr public returns (bool) {
118         distributionFinished = true;
119         emit DistrFinished();
120         return true;
121     }
122     
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
145       
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
166     /*getTokens*/
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
190     
191     modifier onlyPayloadSize(uint size) {
192         assert(msg.data.length >= size + 4);
193         _;
194     }
195     /* Send coins */
196     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
197          // Add and subtract new balances 
198         require(_to != address(0));
199         require(_amount <= balances[msg.sender]);
200         // Add and subtract new balances 
201         balances[msg.sender] = balances[msg.sender].sub(_amount);
202         balances[_to] = balances[_to].add(_amount);
203         emit Transfer(msg.sender, _to, _amount);
204         return true;
205     }
206     /*transferFrom*/
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
231     /*getTokenBalance*/
232     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
233         AltcoinToken t = AltcoinToken(tokenAddress);
234         uint bal = t.balanceOf(who);
235         return bal;
236     }
237     /* Withdraw */
238     function withdraw() onlyOwner public {
239         address myAddress = this;
240         uint256 etherBalance = myAddress.balance;
241         owner.transfer(etherBalance);
242     }
243     /* Burn */
244     function burn(uint256 _value) onlyOwner public {
245         require(_value <= balances[msg.sender]);
246         //All unsold tokens will be burn
247         address burner = msg.sender;
248         balances[burner] = balances[burner].sub(_value);
249         totalSupply = totalSupply.sub(_value);
250         totalDistributed = totalDistributed.sub(_value);
251         emit Burn(burner, _value);
252     }
253     /*withdrawAltcoinTokens*/
254     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
255         AltcoinToken token = AltcoinToken(_tokenContract);
256         uint256 amount = token.balanceOf(address(this));
257         return token.transfer(owner, amount);
258     }
259 }