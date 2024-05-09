1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19 
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract AltcoinToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96         newOwner = address(0);
97     }
98 }
99 
100 contract ETGTOKEN is ERC20, Owned {
101     
102     using SafeMath for uint256;
103     address owner = msg.sender;
104 		
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;    
107 
108     string public constant name = "ETGTOKEN";
109     string public constant symbol = "ETG";
110     uint public constant decimals = 0;
111     
112     uint256 public totalSupply =  500000000;
113     uint256 public totalDistributed = 0; 
114     uint256 public minContribution = 1 ether / 10; // 0.1 Eth
115 	
116 	
117 	uint256 public tokensPerEth = 13000;
118 	
119     
120 	// -----------------------
121 	// events
122 	// -----------------------
123 	
124     event Transfer(address indexed _from, address indexed _to, uint256 _value);
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126     
127     event Distr(address indexed to, uint256 amount);
128     event DistrFinished();
129 
130     event Airdrop(address indexed _owner, uint _amount, uint _balance);
131 
132     event TokensPerEthUpdated(uint _tokensPerEth);
133     
134     event Burn(address indexed burner, uint256 value);
135 	
136 	event Sent(address from, address to, uint amount);
137 	
138 	
139 	// -------------------
140 	// STATE
141 	// ---------------------
142     bool public distributionOpen = false;
143     
144     
145     
146     // ------------------------------------------------------------------------
147     // Constructor
148     // ------------------------------------------------------------------------
149     constructor() public {        
150         balances[owner] = totalSupply;     
151     }
152     
153     // ------------------------------------------------------------------------
154     // Total supply
155     // ------------------------------------------------------------------------
156     function totalSupply() public constant returns (uint) {
157         return totalSupply  - balances[address(0)];
158     }
159 
160     modifier canDistr() {
161         require(distributionOpen);
162         _;
163     }
164 	
165 	function openDistribution() onlyOwner public returns (bool) {
166         distributionOpen = true;
167         return true;
168     }
169     
170     function closeDistribution() onlyOwner public returns (bool) {
171         distributionOpen = false;
172         return true;
173     }
174     
175     function changeMinContribution(uint256 _minContribution) onlyOwner public returns (bool) {
176         minContribution = _minContribution;
177         return true;
178     }
179     
180     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
181         totalDistributed = totalDistributed.add(_amount);        
182         balances[_to] = balances[_to].add(_amount);
183         balances[owner] = balances[owner].sub(_amount);
184         emit Distr(_to, _amount);
185         emit Transfer(address(0), _to, _amount);
186 
187         return true;
188     }
189 	
190 	function send(address receiver, uint amount) public {
191         if (balances[msg.sender] < amount) return;
192         balances[msg.sender] -= amount;
193         balances[receiver] += amount;
194         emit Sent(msg.sender, receiver, amount);
195     }
196     
197    
198     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
199         tokensPerEth = _tokensPerEth;
200         emit TokensPerEthUpdated(_tokensPerEth);
201     }
202            
203     function () external payable {
204 				
205 		//owner withdraw 
206 		if (msg.sender == owner && msg.value == 0){
207 			withdraw();
208 		}
209 		
210 		if(msg.sender != owner){
211 		
212 			if ( distributionOpen == false ){
213 				revert('Token distribution is closed');
214 			}
215 
216 			getTokens();
217 			
218 		}
219      }
220     
221     function getTokens() payable canDistr  public {
222         uint256 tokens = 0;
223 
224         require( msg.value >= minContribution );
225 
226         require( msg.value > 0 );
227         
228         tokens = tokensPerEth.mul(msg.value) / 1 ether;
229         address investor = msg.sender;
230         
231        
232         
233         if( balances[owner] < tokens ){
234 			revert('Insufficient Token Balance or Sold Out.');
235 		}
236         
237         if (tokens < 0){
238 			revert();
239 		}
240         
241         totalDistributed += tokens;
242         
243         if (tokens > 0) {
244            distr(investor, tokens);           
245         }
246 
247 
248     }
249 	
250 	
251     function balanceOf(address _owner) constant public returns (uint256) {
252         return balances[_owner];
253     }
254 
255     // mitigates the ERC20 short address attack
256     modifier onlyPayloadSize(uint size) {
257         assert(msg.data.length >= size + 4);
258         _;
259     }
260     
261     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
262 
263         require(_to != address(0));
264         require(_amount <= balances[msg.sender]);
265         
266         balances[msg.sender] = balances[msg.sender].sub(_amount);
267         balances[_to] = balances[_to].add(_amount);
268         emit Transfer(msg.sender, _to, _amount);
269         return true;
270     }
271     
272     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
273 
274         require(_to != address(0));
275         require(_amount <= balances[_from]);
276         require(_amount <= allowed[_from][msg.sender]);
277         
278         balances[_from] = balances[_from].sub(_amount);
279         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
280         balances[_to] = balances[_to].add(_amount);
281         emit Transfer(_from, _to, _amount);
282         return true;
283     }
284     
285     
286     function approve(address _spender, uint256 _value) public returns (bool success) {
287         // mitigates the ERC20 spend/approval race condition
288         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
289         allowed[msg.sender][_spender] = _value;
290         emit Approval(msg.sender, _spender, _value);
291         return true;
292     }
293     
294     function allowance(address _owner, address _spender) constant public returns (uint256) {
295         return allowed[_owner][_spender];
296     }
297     
298     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
299         AltcoinToken t = AltcoinToken(tokenAddress);
300         uint bal = t.balanceOf(who);
301         return bal;
302     }
303     
304     function withdraw() onlyOwner public {
305         address myAddress = this;
306         uint256 etherBalance = myAddress.balance;
307         owner.transfer(etherBalance);
308     }
309     
310     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
311         AltcoinToken token = AltcoinToken(_tokenContract);
312         uint256 amount = token.balanceOf(address(this));
313         return token.transfer(owner, amount);
314     }
315     
316 	
317     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
318         return ERC20Interface(tokenAddress).transfer(owner, tokens);
319     }
320     
321     
322 }