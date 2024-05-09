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
67 contract HitexExchangeToken is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Hitex Exchange Token";
76     string public constant symbol = "HITEX";
77     uint public constant decimals = 8;
78     
79     uint256 public totalSupply = 10000000000e8;
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth = 30000000e8;
82     uint256 public constant minContribution = 1 ether / 100; // 0.01 Eth
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
108     
109     
110     
111     
112     
113 
114     function finishDistribution() onlyOwner canDistr public returns (bool) {
115         distributionFinished = true;
116         emit DistrFinished();
117         return true;
118     }
119     
120     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
121         totalDistributed = totalDistributed.add(_amount);        
122         balances[_to] = balances[_to].add(_amount);
123         emit Distr(_to, _amount);
124         emit Transfer(address(0), _to, _amount);
125 
126         return true;
127     }
128 
129     function doAirdrop(address _participant, uint _amount) internal {
130 
131         require( _amount > 0 );      
132 
133         require( totalDistributed < totalSupply );
134         
135         balances[_participant] = balances[_participant].add(_amount);
136         totalDistributed = totalDistributed.add(_amount);
137 
138         if (totalDistributed >= totalSupply) {
139             distributionFinished = true;
140         }
141 
142         // log
143         emit Airdrop(_participant, _amount, balances[_participant]);
144         emit Transfer(address(0), _participant, _amount);
145     }
146 
147     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
148         doAirdrop(_participant, _amount);
149     }
150 
151     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
152         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
153     }
154 
155     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
156         tokensPerEth = _tokensPerEth;
157         emit TokensPerEthUpdated(_tokensPerEth);
158     }
159            
160     function () external payable {
161         getTokens();
162      }
163     
164     function getTokens() payable canDistr  public {
165         uint256 tokens = 0;
166 
167         require( msg.value >= minContribution );
168 
169         require( msg.value > 0 );
170         
171         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
172         address investor = msg.sender;
173         
174         if (tokens > 0) {
175             distr(investor, tokens);
176         }
177 
178         if (totalDistributed >= totalSupply) {
179             distributionFinished = true;
180         }
181     }
182 
183     function balanceOf(address _owner) constant public returns (uint256) {
184         return balances[_owner];
185     }
186 
187     // mitigates the ERC20 short address attack
188     modifier onlyPayloadSize(uint size) {
189         assert(msg.data.length >= size + 4);
190         _;
191     }
192     
193     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
194 
195         require(_to != address(0));
196         require(_amount <= balances[msg.sender]);
197         
198         balances[msg.sender] = balances[msg.sender].sub(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         emit Transfer(msg.sender, _to, _amount);
201         return true;
202     }
203     
204     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
205 
206         require(_to != address(0));
207         require(_amount <= balances[_from]);
208         require(_amount <= allowed[_from][msg.sender]);
209         
210         balances[_from] = balances[_from].sub(_amount);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
212         balances[_to] = balances[_to].add(_amount);
213         emit Transfer(_from, _to, _amount);
214         return true;
215     }
216     
217     function approve(address _spender, uint256 _value) public returns (bool success) {
218         // mitigates the ERC20 spend/approval race condition
219         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224     
225     function allowance(address _owner, address _spender) constant public returns (uint256) {
226         return allowed[_owner][_spender];
227     }
228     
229     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
230         AltcoinToken t = AltcoinToken(tokenAddress);
231         uint bal = t.balanceOf(who);
232         return bal;
233     }
234     
235     function withdraw() onlyOwner public {
236         address myAddress = this;
237         uint256 etherBalance = myAddress.balance;
238         owner.transfer(etherBalance);
239     }
240     
241     function burn(uint256 _value) onlyOwner public {
242         require(_value <= balances[msg.sender]);
243         
244         address burner = msg.sender;
245         balances[burner] = balances[burner].sub(_value);
246         totalSupply = totalSupply.sub(_value);
247         totalDistributed = totalDistributed.sub(_value);
248         emit Burn(burner, _value);
249     }
250     
251     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
252         AltcoinToken token = AltcoinToken(_tokenContract);
253         uint256 amount = token.balanceOf(address(this));
254         return token.transfer(owner, amount);
255     }
256 }