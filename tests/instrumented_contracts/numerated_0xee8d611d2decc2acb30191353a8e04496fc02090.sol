1 pragma solidity ^0.4.18;
2 
3 /** TOKEN INFORMATION
4  * Welcome to CRYPTOVENO Project
5  * Name Token : CRYPTOVENO
6  * Symbol : VENO2
7  * Decimal : 8
8  * Total Supply : 10,000,000,000
9  * Website : https://cryptoveno.com
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract ForeignToken {
58     function balanceOf(address _owner) constant public returns (uint256);
59     function transfer(address _to, uint256 _value) public returns (bool);
60 }
61 
62 contract ERC20Basic {
63     uint256 public totalSupply;
64     function balanceOf(address who) public constant returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public constant returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract CRYPTOVENO is ERC20 {
77     
78     using SafeMath for uint256;
79     address owner = msg.sender;
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;    
83 
84     string public constant name = "CRYPTOVENO";
85     string public constant symbol = "VENO2";
86     uint public constant decimals = 8;
87     
88     uint256 public totalSupply = 10000000000e8;
89     uint256 public totalDistributed = 0;    
90     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
91     uint256 public tokensPerEth = 10000000e8;
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98 
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104 
105     bool public distributionFinished = false;
106     
107     modifier canDistr() {
108         require(!distributionFinished);
109         _;
110     }
111     
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     
118     function CRYPTOVENO () public {
119         owner = msg.sender;    
120         distr(owner, totalDistributed);
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
158         // log
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
183         // minimum contribution
184         require( msg.value >= MIN_CONTRIBUTION );
185 
186         require( msg.value > 0 );
187 
188         // get baseline number of tokens
189         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
190         address investor = msg.sender;
191         
192         if (tokens > 0) {
193             distr(investor, tokens);
194         }
195 
196         if (totalDistributed >= totalSupply) {
197             distributionFinished = true;
198         }
199     }
200 
201     function balanceOf(address _owner) constant public returns (uint256) {
202         return balances[_owner];
203     }
204 
205     // mitigates the ERC20 short address attack
206     modifier onlyPayloadSize(uint size) {
207         assert(msg.data.length >= size + 4);
208         _;
209     }
210     
211     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
212 
213         require(_to != address(0));
214         require(_amount <= balances[msg.sender]);
215         
216         balances[msg.sender] = balances[msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221     
222     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
223 
224         require(_to != address(0));
225         require(_amount <= balances[_from]);
226         require(_amount <= allowed[_from][msg.sender]);
227         
228         balances[_from] = balances[_from].sub(_amount);
229         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
230         balances[_to] = balances[_to].add(_amount);
231         emit Transfer(_from, _to, _amount);
232         return true;
233     }
234     
235     function approve(address _spender, uint256 _value) public returns (bool success) {
236         // mitigates the ERC20 spend/approval race condition
237         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
238         allowed[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242     
243     function allowance(address _owner, address _spender) constant public returns (uint256) {
244         return allowed[_owner][_spender];
245     }
246     
247     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
248         ForeignToken t = ForeignToken(tokenAddress);
249         uint bal = t.balanceOf(who);
250         return bal;
251     }
252     
253     function withdraw() onlyOwner public {
254         address myAddress = this;
255         uint256 etherBalance = myAddress.balance;
256         owner.transfer(etherBalance);
257     }
258     
259     function burn(uint256 _value) onlyOwner public {
260         require(_value <= balances[msg.sender]);
261         // no need to require value <= totalSupply, since that would imply the
262         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         totalDistributed = totalDistributed.sub(_value);
268         emit Burn(burner, _value);
269     }
270     
271     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
272         ForeignToken token = ForeignToken(_tokenContract);
273         uint256 amount = token.balanceOf(address(this));
274         return token.transfer(owner, amount);
275     }
276 }