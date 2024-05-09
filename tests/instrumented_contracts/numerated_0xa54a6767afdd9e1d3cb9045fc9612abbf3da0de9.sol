1 //Token Name    : Yolk Finance
2 //symbol        : YOLK
3 //decimals      : 8
4 //website       : yolk.finance
5 
6 
7 
8 
9 
10 pragma solidity ^0.4.23;
11 
12 
13 contract ERC20Basic {
14     uint256 public totalSupply;
15     function balanceOf(address who) public constant returns (uint256);
16     function transfer(address to, uint256 value) public returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public constant returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     mapping (address => uint256) public freezeOf;
26 }
27 
28 
29 library SafeMath {
30     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a / b;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54     contract ForeignToken {
55         function balanceOf(address _owner) constant public returns (uint256);
56         function transfer(address _to, uint256 _value) public returns (bool);
57     }
58 
59 
60 
61 
62 contract YolkFinance is ERC20 {
63     using SafeMath for uint256;
64     address owner = msg.sender;
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;    
67     string public constant name = "Yolk Finance"; //* Token Name *//
68     string public constant symbol = "YOLK"; //* Yolk Finance Symbol *//
69     uint public constant decimals = 8; //* Number of Decimals *//
70     uint256 public totalSupply = 2000000000000; //* total supply of Yolk Finance *//
71     uint256 public totalDistributed =  1;  //* Initial Yolk Finance that will give to contract creator *//
72     uint256 public constant MIN = 1 ether / 100;  //* Minimum Contribution for Yolk Finance //
73     uint256 public tokensPerEth = 2000000000; //* Yolk Finance Amount per Ethereum *//
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     event Distr(address indexed to, uint256 amount);
77     event DistrFinished();
78     event Airdrop(address indexed _owner, uint _amount, uint _balance);
79     event TokensPerEthUpdated(uint _tokensPerEth);
80     event Burn(address indexed burner, uint256 value);
81     event Freeze(address indexed from, uint256 value); //event freezing
82     event Unfreeze(address indexed from, uint256 value); //event Unfreezing
83     bool public distributionFinished = false;
84     modifier canDistr() {
85         require(!distributionFinished);
86         _;
87     }
88 
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93     
94     function YolkFinance () public {
95         owner = msg.sender;    
96         distr(owner, totalDistributed);
97     }
98     
99     function transferOwnership(address newOwner) onlyOwner public {
100         if (newOwner != address(0)) {
101             owner = newOwner;
102         }
103     }
104     
105 
106     function finishDistribution() onlyOwner canDistr public returns (bool) {
107         distributionFinished = true;
108         emit DistrFinished();
109         return true;
110     }
111     
112     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
113         totalDistributed = totalDistributed.add(_amount);        
114         balances[_to] = balances[_to].add(_amount);
115         emit Distr(_to, _amount);
116         emit Transfer(address(0), _to, _amount);
117 
118         return true;
119     }
120 
121     function doAirdrop(address _participant, uint _amount) internal {
122 
123         require( _amount > 0 );      
124 
125         require( totalDistributed < totalSupply );
126         
127         balances[_participant] = balances[_participant].add(_amount);
128         totalDistributed = totalDistributed.add(_amount);
129 
130         if (totalDistributed >= totalSupply) {
131             distributionFinished = true;
132         }
133         emit Airdrop(_participant, _amount, balances[_participant]);
134         emit Transfer(address(0), _participant, _amount);
135     }
136 
137     function AirdropSingle(address _participant, uint _amount) public onlyOwner {        
138         doAirdrop(_participant, _amount);
139     }
140 
141     function AirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
142         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
143     }
144 
145     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
146         tokensPerEth = _tokensPerEth;
147         emit TokensPerEthUpdated(_tokensPerEth);
148     }
149            
150     function () external payable {
151         getTokens();
152      }
153     
154     function getTokens() payable canDistr  public {
155         uint256 tokens = 0;
156         require( msg.value >= MIN );
157         require( msg.value > 0 );
158         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
159         address investor = msg.sender;
160         
161         if (tokens > 0) {
162             distr(investor, tokens);
163         }
164 
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168     }
169 
170 
171     modifier onlyPayloadSize(uint size) {
172         assert(msg.data.length >= size + 4);
173         _;
174     }
175 
176     function balanceOf(address _owner) constant public returns (uint256) {
177         return balances[_owner];
178     }
179     
180     
181     function freeze(uint256 _value) returns (bool success) {
182         if (balances[msg.sender] < _value) throw;                               // Check if the sender has enough
183 		if (_value <= 0) throw; 
184         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      // Subtract from the sender
185         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       // Updates totalSupply
186         Freeze(msg.sender, _value);
187         return true;
188     }
189 	
190 	function unfreeze(uint256 _value) returns (bool success) {
191         if (freezeOf[msg.sender] < _value) throw;                               // Check if the sender has enough
192 		if (_value <= 0) throw; 
193         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);      // Subtract from the sender
194 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
195         Unfreeze(msg.sender, _value);
196         return true;
197     }
198     
199     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
200         //check if sender has balance and for oveflow
201         require(_to != address(0));
202         require(_amount <= balances[msg.sender]);
203         balances[msg.sender] = balances[msg.sender].sub(_amount);
204         balances[_to] = balances[_to].add(_amount);
205         emit Transfer(msg.sender, _to, _amount);
206         return true;
207     }
208     
209     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
210         require(_to != address(0));
211         require(_amount <= balances[_from]);
212         require(_amount <= allowed[_from][msg.sender]);
213         balances[_from] = balances[_from].sub(_amount);
214         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(_from, _to, _amount);
217         return true;
218     }
219 
220     //allow the contract owner to withdraw any token that are not belongs to Yolk Finance Community
221      function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
222         ForeignToken token = ForeignToken(_tokenContract);
223         uint256 amount = token.balanceOf(address(this));
224         return token.transfer(owner, amount);
225     } //withdraw foreign tokens
226     
227     function approve(address _spender, uint256 _value) public returns (bool success) {
228         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
229         allowed[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     } 
233     
234     
235     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
236         ForeignToken t = ForeignToken(tokenAddress);
237         uint bal = t.balanceOf(who);
238         return bal;
239     }
240     
241     //withdraw Ethereum from Contract address
242     function withdrawEther() onlyOwner public {
243         address myAddress = this;
244         uint256 etherBalance = myAddress.balance;
245         owner.transfer(etherBalance);
246     }
247     
248     function allowance(address _owner, address _spender) constant public returns (uint256) {
249         return allowed[_owner][_spender];
250     }
251     
252     //Burning specific amount of Yolk Finance
253     function burnYolkFinance(uint256 _value) onlyOwner public {
254         require(_value <= balances[msg.sender]);
255         address burner = msg.sender;
256         balances[burner] = balances[burner].sub(_value);
257         totalSupply = totalSupply.sub(_value);
258         totalDistributed = totalDistributed.sub(_value);
259         emit Burn(burner, _value);
260     } 
261     
262 }