1 pragma solidity ^0.4.25;
2 
3 /** TOKEN INFORMATION
4  * Welcome to VOUCHERTOKEN Project
5  * Name Token : VOUCHERTOKEN
6  * Symbol : VCRT
7  * Decimal : 8
8  * Total Supply : 10,000,000,000
9  
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract ForeignToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract VOUCHERTOKEN is ERC20 {
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;    
82 
83     string public constant name = "VOUCHERTOKEN";
84     string public constant symbol = "VCRT";
85     uint public constant decimals = 8;
86     
87     uint256 public totalSupply = 10000000000e8;
88     uint256 public totalDistributed = 0;
89     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
90     uint256 public tokensPerEth = 20000000e8;
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     
95     event Distr(address indexed to, uint256 amount);
96     event DistrFinished();
97 
98     event Airdrop(address indexed _owner, uint _amount, uint _balance);
99 
100     event TokensPerEthUpdated(uint _tokensPerEth);
101     
102     event Burn(address indexed burner, uint256 value);
103 
104     bool public distributionFinished = false;
105     
106     modifier canDistr() {
107         require(!distributionFinished);
108         _;
109     }
110     
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115     
116     
117     function VOUCHERTOKEN () public {
118         owner = msg.sender;    
119         distr(owner, totalDistributed);
120     }
121     
122     function transferOwnership(address newOwner) onlyOwner public {
123         if (newOwner != address(0)) {
124             owner = newOwner;
125         }
126     }
127     
128 
129     function finishDistribution() onlyOwner canDistr public returns (bool) {
130         distributionFinished = true;
131         emit DistrFinished();
132         return true;
133     }
134     
135     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
136         totalDistributed = totalDistributed.add(_amount);        
137         balances[_to] = balances[_to].add(_amount);
138         emit Distr(_to, _amount);
139         emit Transfer(address(0), _to, _amount);
140 
141         return true;
142     }
143 
144     function doAirdrop(address _participant, uint _amount) internal {
145 
146         require( _amount > 0 );      
147 
148         require( totalDistributed < totalSupply );
149         
150         balances[_participant] = balances[_participant].add(_amount);
151         totalDistributed = totalDistributed.add(_amount);
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156 
157         // log
158         emit Airdrop(_participant, _amount, balances[_participant]);
159         emit Transfer(address(0), _participant, _amount);
160     }
161 
162     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
163         doAirdrop(_participant, _amount);
164     }
165 
166     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
167         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
168     }
169 
170     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
171         tokensPerEth = _tokensPerEth;
172         emit TokensPerEthUpdated(_tokensPerEth);
173     }
174            
175     function () external payable {
176         getTokens();
177      }
178     
179     function getTokens() payable canDistr  public {
180         uint256 tokens = 0;
181 
182         // minimum contribution
183         require( msg.value >= MIN_CONTRIBUTION );
184 
185         require( msg.value > 0 );
186 
187         // get baseline number of tokens
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
247         ForeignToken t = ForeignToken(tokenAddress);
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
260         // no need to require value <= totalSupply, since that would imply the
261         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263         address burner = msg.sender;
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         totalDistributed = totalDistributed.sub(_value);
267         emit Burn(burner, _value);
268     }
269     
270     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
271         ForeignToken token = ForeignToken(_tokenContract);
272         uint256 amount = token.balanceOf(address(this));
273         return token.transfer(owner, amount);
274     }
275 }