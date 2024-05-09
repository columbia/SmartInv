1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     /**
8     * Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     /**
19     * Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27     /**
28     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34     /**
35     * Adds two numbers, throws on overflow.
36     */
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
63 contract NMK is ERC20 {
64     
65     using SafeMath for uint256;
66     address owner = msg.sender;
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;    
70 
71     string public constant name = "Namek";
72     string public constant symbol = "NMK";
73     uint public constant decimals = 8;
74     
75     uint256 public totalSupply = 400000000e8;
76     uint256 public totalDistributed = 0;        
77     uint256 public tokensPerEth = 1e8; // 1 token = 1 eth until the token sale starts
78     uint256 public constant minContribution = 1 ether / 2000; // 0.0005 Ether
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82     
83     event Distr(address indexed to, uint256 amount);
84     event DistrFinished();
85 
86     event Airdrop(address indexed _owner, uint _amount, uint _balance);
87 
88     event TokensPerEthUpdated(uint _tokensPerEth);
89     
90     event Burn(address indexed burner, uint256 value);
91 
92     bool public distributionFinished = false;
93     
94     modifier canDistr() {
95         require(!distributionFinished);
96         _;
97     }
98     
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     function NMK () public {
105         owner = msg.sender;
106         uint256 devTokens = 50000000e8;
107         distr(owner, devTokens);
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115 
116     function finishDistribution() onlyOwner canDistr public returns (bool) {
117         distributionFinished = true;
118         emit DistrFinished();
119         return true;
120     }
121     
122     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
123         totalDistributed = totalDistributed.add(_amount);        
124         balances[_to] = balances[_to].add(_amount);
125         emit Distr(_to, _amount);
126         emit Transfer(address(0), _to, _amount);
127 
128         return true;
129     }
130 
131     function doAirdrop(address _participant, uint _amount) internal {
132 
133         require( _amount > 0 );      
134 
135         require( totalDistributed < totalSupply );
136         
137         balances[_participant] = balances[_participant].add(_amount);
138         totalDistributed = totalDistributed.add(_amount);
139 
140         if (totalDistributed >= totalSupply) {
141             distributionFinished = true;
142         }
143         // log
144         emit Airdrop(_participant, _amount, balances[_participant]);
145         emit Transfer(address(0), _participant, _amount);
146     }
147 
148     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
149         doAirdrop(_participant, _amount);
150     }
151 
152     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
153         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
154     }
155 
156     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
157         tokensPerEth = _tokensPerEth;
158         emit TokensPerEthUpdated(_tokensPerEth);
159     }
160            
161     function () external payable {
162         getTokens();
163      }
164     
165     function getTokens() payable canDistr  public {
166         uint256 tokens = 0;
167 
168         require( msg.value >= minContribution );
169 
170         require( msg.value > 0 );
171         
172         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
173         address investor = msg.sender;
174         
175         if (tokens > 0) {
176             distr(investor, tokens);
177         }
178 
179         if (totalDistributed >= totalSupply) {
180             distributionFinished = true;
181         }
182     }
183 
184     function balanceOf(address _owner) constant public returns (uint256) {
185         return balances[_owner];
186     }
187 
188     // mitigates the ERC20 short address attack
189     modifier onlyPayloadSize(uint size) {
190         assert(msg.data.length >= size + 4);
191         _;
192     }
193     
194     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
195 
196         require(_to != address(0));
197         require(_amount <= balances[msg.sender]);
198         
199         balances[msg.sender] = balances[msg.sender].sub(_amount);
200         balances[_to] = balances[_to].add(_amount);
201         emit Transfer(msg.sender, _to, _amount);
202         return true;
203     }
204     
205     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
206 
207         require(_to != address(0));
208         require(_amount <= balances[_from]);
209         require(_amount <= allowed[_from][msg.sender]);
210         
211         balances[_from] = balances[_from].sub(_amount);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Transfer(_from, _to, _amount);
215         return true;
216     }
217     
218     function approve(address _spender, uint256 _value) public returns (bool success) {
219         // mitigates the ERC20 spend/approval race condition
220         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
221         allowed[msg.sender][_spender] = _value;
222         emit Approval(msg.sender, _spender, _value);
223         return true;
224     }
225     
226     function allowance(address _owner, address _spender) constant public returns (uint256) {
227         return allowed[_owner][_spender];
228     }
229     
230     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
231         AltcoinToken t = AltcoinToken(tokenAddress);
232         uint bal = t.balanceOf(who);
233         return bal;
234     }
235     
236     function withdraw() onlyOwner public {
237         address myAddress = this;
238         uint256 etherBalance = myAddress.balance;
239         owner.transfer(etherBalance);
240     }
241     
242     function burn(uint256 _value) onlyOwner public {
243         require(_value <= balances[msg.sender]);
244         
245         address burner = msg.sender;
246         balances[burner] = balances[burner].sub(_value);
247         totalSupply = totalSupply.sub(_value);
248         totalDistributed = totalDistributed.sub(_value);
249         emit Burn(burner, _value);
250     }
251     
252     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
253         AltcoinToken token = AltcoinToken(_tokenContract);
254         uint256 amount = token.balanceOf(address(this));
255         return token.transfer(owner, amount);
256     }
257 }