1 //Token Name    : AZLTEST
2 //symbol        : ALT
3 //decimals      : 8
4 //website       : 
5 
6 
7 contract ERC20Basic {
8     uint256 public totalSupply;
9     function balanceOf(address who) public constant returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15     function allowance(address owner, address spender) public constant returns (uint256);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17     function approve(address spender, uint256 value) public returns (bool);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19     mapping (address => uint256) public freezeOf;
20 }
21 
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a / b;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48     contract ForeignToken {
49         function balanceOf(address _owner) constant public returns (uint256);
50 
51         function transfer(address _to, uint256 _value) public returns (bool);
52     }
53 
54 
55 
56 
57 contract AZLTEST is ERC20 {
58     
59     using SafeMath for uint256;
60     
61     address owner = msg.sender;
62     
63     mapping (address => uint256) balances;
64     
65     mapping (address => mapping (address => uint256)) allowed;    
66     
67     string public constant name = "AZLTEST"; //* Token Name *//
68     
69     string public constant symbol = "ALT"; //* AZLTEST Symbol *//
70     
71     uint public constant decimals = 8; //* Number of Decimals *//
72     
73     uint256 public totalSupply = 1000000000000000000; //* total supply of AZLTEST *//
74     
75     uint256 public totalDistributed =  500000000000000000;  //* Initial AZLTEST that will give to contract creator *//
76    
77     uint256 public constant MIN = 1 ether / 100;  //* Minimum Contribution for AZLTEST //
78     
79     uint256 public tokensPerEth = 2000000000000000; //* AZLTEST Amount per Ethereum *//
80     
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85     event Distr(address indexed to, uint256 amount);
86     
87     event DistrFinished();
88     
89     event Airdrop(address indexed _owner, uint _amount, uint _balance);
90     
91     event TokensPerEthUpdated(uint _tokensPerEth);
92     
93     event Burn(address indexed burner, uint256 value);
94     
95     event Freeze(address indexed from, uint256 value); //event freezing
96     
97     event Unfreeze(address indexed from, uint256 value); //event Unfreezing
98     
99     bool public distributionFinished = false;
100     
101     modifier canDistr() {
102         require(!distributionFinished);
103         _;
104     }
105 
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     
111     function AZLTEST () public {
112         owner = msg.sender;    
113         distr(owner, totalDistributed);
114     }
115     
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121     
122     function finishDistribution() onlyOwner canDistr public returns (bool) {
123         distributionFinished = true;
124         emit DistrFinished();
125         return true;
126     }
127     
128     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
129         totalDistributed = totalDistributed.add(_amount);        
130         balances[_to] = balances[_to].add(_amount);
131         emit Distr(_to, _amount);
132         emit Transfer(address(0), _to, _amount);
133 
134         return true;
135     }
136 
137     function doAirdrop(address _participant, uint _amount) internal {
138 
139         require( _amount > 0 );      
140 
141         require( totalDistributed < totalSupply );
142         
143         balances[_participant] = balances[_participant].add(_amount);
144         totalDistributed = totalDistributed.add(_amount);
145 
146         if (totalDistributed >= totalSupply) {
147             distributionFinished = true;
148         }
149         emit Airdrop(_participant, _amount, balances[_participant]);
150         emit Transfer(address(0), _participant, _amount);
151     }
152 
153     function AirdropSingle(address _participant, uint _amount) public onlyOwner {        
154         doAirdrop(_participant, _amount);
155     }
156 
157     function AirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
158         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
159     }
160 
161     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
162         tokensPerEth = _tokensPerEth;
163         emit TokensPerEthUpdated(_tokensPerEth);
164     }
165            
166     function () external payable {
167         getTokens();
168      }
169     
170     function getTokens() payable canDistr  public {
171         uint256 tokens = 0;
172         require( msg.value >= MIN );
173         require( msg.value > 0 );
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
186 
187     modifier onlyPayloadSize(uint size) {
188         assert(msg.data.length >= size + 4);
189         _;
190     }
191 
192     function balanceOf(address _owner) constant public returns (uint256) {
193         return balances[_owner];
194     }
195     
196     
197     function freeze(uint256 _value) returns (bool success) {
198         if (balances[msg.sender] < _value) throw;                               // Check if the sender has enough
199 		if (_value <= 0) throw; 
200         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      // Subtract from the sender
201         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       // Updates totalSupply
202         emit Freeze(msg.sender, _value);
203         return true;
204     }
205 	
206 	function unfreeze(uint256 _value) returns (bool success) {
207         if (freezeOf[msg.sender] < _value) throw;                               // Check if the sender has enough
208 		if (_value <= 0) throw; 
209         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);      // Subtract from the sender
210 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
211         emit Unfreeze(msg.sender, _value);
212         return true;
213     }
214     
215     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
216         //check if sender has balance and for oveflow
217         require(_to != address(0));
218         require(_amount <= balances[msg.sender]);
219         balances[msg.sender] = balances[msg.sender].sub(_amount);
220         balances[_to] = balances[_to].add(_amount);
221         emit Transfer(msg.sender, _to, _amount);
222         return true;
223     }
224     
225     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
226         require(_to != address(0));
227         require(_amount <= balances[_from]);
228         require(_amount <= allowed[_from][msg.sender]);
229         balances[_from] = balances[_from].sub(_amount);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         emit Transfer(_from, _to, _amount);
233         return true;
234     }
235 
236     //allow the contract owner to withdraw any token that are not belongs to AZLTEST Community
237      function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
238         ForeignToken token = ForeignToken(_tokenContract);
239         uint256 amount = token.balanceOf(address(this));
240         return token.transfer(owner, amount);
241     } //withdraw foreign tokens
242     
243     function approve(address _spender, uint256 _value) public returns (bool success) {
244         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     } 
249     
250     
251     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
252         ForeignToken t = ForeignToken(tokenAddress);
253         uint bal = t.balanceOf(who);
254         return bal;
255     }
256     
257     //withdraw Ethereum from Contract address
258     function withdrawEther() onlyOwner public {
259         address myAddress = this;
260         uint256 etherBalance = myAddress.balance;
261         owner.transfer(etherBalance);
262     }
263     
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267     
268     //Burning specific amount of AZLTEST
269     function burnAZLTEST(uint256 _value) onlyOwner public {
270         require(_value <= balances[msg.sender]);
271         address burner = msg.sender;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         totalDistributed = totalDistributed.sub(_value);
275         emit Burn(burner, _value);
276     } 
277     
278     
279 }