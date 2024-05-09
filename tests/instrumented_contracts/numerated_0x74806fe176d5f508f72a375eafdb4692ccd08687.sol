1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract AltcoinToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BitcoinNext is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;    
71 
72     string public constant name = "BitcoinNext Project";
73     string public constant symbol = "BiN";
74     uint public constant decimals = 8;
75     
76     uint256 public totalSupply = 25000000000000000;
77     uint256 public totalDistributed = 0;        
78     uint256 public tokensPerEth = 2500000000000;
79     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     
84     event Distr(address indexed to, uint256 amount);
85     event DistrFinished();
86 
87     event Airdrop(address indexed _owner, uint _amount, uint _balance);
88 
89     event TokensPerEthUpdated(uint _tokensPerEth);
90     
91     event Burn(address indexed burner, uint256 value);
92 
93     bool public distributionFinished = false;
94     
95     modifier canDistr() {
96         require(!distributionFinished);
97         _;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104     
105    
106     
107     function transferOwnership(address newOwner) onlyOwner public {
108         if (newOwner != address(0)) {
109             owner = newOwner;
110         }
111     }
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
175 			owner.transfer(msg.value);
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
188  
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
236     
237 
238     
239     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
240         AltcoinToken token = AltcoinToken(_tokenContract);
241         uint256 amount = token.balanceOf(address(this));
242         return token.transfer(owner, amount);
243     }
244 }