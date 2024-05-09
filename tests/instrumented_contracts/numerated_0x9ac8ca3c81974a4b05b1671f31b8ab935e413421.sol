1 pragma solidity ^0.4.18;
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
67 contract ZorffToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Zorff Token";
76     string public constant symbol = "ZRF";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 30158000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth = 1500000e8;
82     uint256 public tokenBonus = 200000e8;
83     uint256 public constant minContribution = 1 ether / 100; // min purchase (0.01 Ether)
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
110     function ZorffToken () public {
111         owner = msg.sender;
112         uint256 devTokens = 3158000000e8;
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
164     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
165         tokensPerEth = _tokensPerEth;
166         emit TokensPerEthUpdated(_tokensPerEth);
167     }
168            
169     function () external payable {
170         getTokens();
171      }
172     
173     function getTokens() payable canDistr  public {
174         uint256 tokens = 0;
175 
176         require( msg.value >= minContribution );
177 
178         require( msg.value > 0 );
179         
180         tokens = tokensPerEth.mul(msg.value) / 1 ether;  
181         
182         if(msg.value >= 1 ether){
183             tokens = tokens.mul(170).div(100); //purchase ZRF with 1 ETH and above get 70% bonus
184         }
185         
186         tokens = tokens.add(tokenBonus); //add bonus
187         
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
203     // mitigates the ERC20 short address attack
204     modifier onlyPayloadSize(uint size) {
205         assert(msg.data.length >= size + 4);
206         _;
207     }
208     
209     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
210 
211         require(_to != address(0));
212         require(_amount <= balances[msg.sender]);
213         
214         balances[msg.sender] = balances[msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219     
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
234         // mitigates the ERC20 spend/approval race condition
235         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
236         allowed[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240     
241     function allowance(address _owner, address _spender) constant public returns (uint256) {
242         return allowed[_owner][_spender];
243     }
244     
245     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
246         AltcoinToken t = AltcoinToken(tokenAddress);
247         uint bal = t.balanceOf(who);
248         return bal;
249     }
250     
251     function withdraw() onlyOwner public {
252         address myAddress = this;
253         uint256 etherBalance = myAddress.balance;
254         owner.transfer(etherBalance);
255     }
256     
257     function burn(uint256 _value) onlyOwner public {
258         require(_value <= balances[msg.sender]);
259         
260         address burner = msg.sender;
261         balances[burner] = balances[burner].sub(_value);
262         totalSupply = totalSupply.sub(_value);
263         totalDistributed = totalDistributed.sub(_value);
264         emit Burn(burner, _value);
265     }
266     
267     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
268         AltcoinToken token = AltcoinToken(_tokenContract);
269         uint256 amount = token.balanceOf(address(this));
270         return token.transfer(owner, amount);
271     }
272 }