1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  */
6  
7 library SafeMath {
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
48 contract Thetoken {
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
67 contract RealivePlatformTokens is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;    
74 
75     string public constant name = "Realive platform"; // Token Names
76     string public constant symbol = "RLIVE"; // Ticker or Symbol
77     uint public constant decimals = 18; // Decimals Points
78     
79     uint256 public totalSupply = 500000000000000000000000000; // Based with WEI
80     uint256 public totalDistributed = 0;        
81     uint256 public tokensPerEth = 220000000000000000000000;
82     uint256 public constant minContribution = 1 ether / 100;
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
109     function transferOwnership(address newOwner) onlyOwner public {
110         if (newOwner != address(0)) {
111             owner = newOwner;
112         }
113     }
114     
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
143 
144         // log
145         emit Airdrop(_participant, _amount, balances[_participant]);
146         emit Transfer(address(0), _participant, _amount);
147     }
148 
149     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
150         doAirdrop(_participant, _amount);
151     }
152 
153     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
154         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
155     }
156 
157     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
158         tokensPerEth = _tokensPerEth;
159         emit TokensPerEthUpdated(_tokensPerEth);
160     }
161            
162     function () external payable {
163         getTokens();
164      }
165     
166     function getTokens() payable canDistr  public {
167         uint256 tokens = 0;
168 
169         require( msg.value >= minContribution );
170 
171         require( msg.value > 0 );
172         
173         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
174         address investor = msg.sender;
175         
176         if (tokens > 0) {
177             distr(investor, tokens);
178         }
179 
180         if (totalDistributed >= totalSupply) {
181             distributionFinished = true;
182         }
183     }
184 
185     function balanceOf(address _owner) constant public returns (uint256) {
186         return balances[_owner];
187     }
188 
189     // mitigates the ERC20 short address attack
190     modifier onlyPayloadSize(uint size) {
191         assert(msg.data.length >= size + 4);
192         _;
193     }
194     
195     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
196 
197         require(_to != address(0));
198         require(_amount <= balances[msg.sender]);
199         
200         balances[msg.sender] = balances[msg.sender].sub(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         emit Transfer(msg.sender, _to, _amount);
203         return true;
204     }
205     
206     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
207 
208         require(_to != address(0));
209         require(_amount <= balances[_from]);
210         require(_amount <= allowed[_from][msg.sender]);
211         
212         balances[_from] = balances[_from].sub(_amount);
213         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(_from, _to, _amount);
216         return true;
217     }
218     
219     function approve(address _spender, uint256 _value) public returns (bool success) {
220         // mitigates the ERC20 spend/approval race condition
221         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224         return true;
225     }
226     
227     function allowance(address _owner, address _spender) constant public returns (uint256) {
228         return allowed[_owner][_spender];
229     }
230     
231     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
232         Thetoken t = Thetoken(tokenAddress);
233         uint bal = t.balanceOf(who);
234         return bal;
235     }
236     
237     function withdraw() onlyOwner public {
238         address myAddress = this;
239         uint256 etherBalance = myAddress.balance;
240         owner.transfer(etherBalance);
241     }
242     
243     function burn(uint256 _value) onlyOwner public {
244         require(_value <= balances[msg.sender]);
245         
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         totalDistributed = totalDistributed.sub(_value);
250         emit Burn(burner, _value);
251     }
252     
253     function withdrawThetokens(address _tokenContract) onlyOwner public returns (bool) {
254         Thetoken token = Thetoken(_tokenContract);
255         uint256 amount = token.balanceOf(address(this));
256         return token.transfer(owner, amount);
257     }
258 }