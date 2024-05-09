1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     function balanceOf(address who) public constant returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender) public constant returns (uint256);
13     function transferFrom(address from, address to, uint256 value) public returns (bool);
14     function approve(address spender, uint256 value) public returns (bool);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16     mapping (address => uint256) public freezeOf;
17 }
18 
19 
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a / b;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45     contract ForeignToken {
46         function balanceOf(address _owner) constant public returns (uint256);
47         function transfer(address _to, uint256 _value) public returns (bool);
48     }
49 
50 
51 
52 
53 contract Dexter is ERC20 {
54     using SafeMath for uint256;
55     address owner = msg.sender;
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;    
58     string public constant name = "Dexter"; //* Token Name *//
59     string public constant symbol = "DXTR"; //* Dexter Symbol *//
60     uint public constant decimals = 8; //* Number of Decimals *//
61     uint256 public totalSupply = 3200000000000000000; //* total supply of Dexter *//
62     uint256 public totalDistributed =  2000000000000;  //* Initial Dexter that will give to contract creator *//
63     uint256 public constant MIN = 1 ether / 100;  //* Minimum Contribution for Dexter //
64     uint256 public tokensPerEth = 1200000000000000; //* Dexter Amount per Ethereum *//
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     event Distr(address indexed to, uint256 amount);
68     event DistrFinished();
69     event Airdrop(address indexed _owner, uint _amount, uint _balance);
70     event TokensPerEthUpdated(uint _tokensPerEth);
71     event Burn(address indexed burner, uint256 value);
72     event Freeze(address indexed from, uint256 value); //event freezing
73     event Unfreeze(address indexed from, uint256 value); //event Unfreezing
74     bool public distributionFinished = false;
75     modifier canDistr() {
76         require(!distributionFinished);
77         _;
78     }
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     function Dexter () public {
86         owner = msg.sender;    
87         distr(owner, totalDistributed);
88     }
89     
90     function transferOwnership(address newOwner) onlyOwner public {
91         if (newOwner != address(0)) {
92             owner = newOwner;
93         }
94     }
95     
96 
97     function finishDistribution() onlyOwner canDistr public returns (bool) {
98         distributionFinished = true;
99         emit DistrFinished();
100         return true;
101     }
102     
103     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
104         totalDistributed = totalDistributed.add(_amount);        
105         balances[_to] = balances[_to].add(_amount);
106         emit Distr(_to, _amount);
107         emit Transfer(address(0), _to, _amount);
108 
109         return true;
110     }
111 
112     function doAirdrop(address _participant, uint _amount) internal {
113 
114         require( _amount > 0 );      
115 
116         require( totalDistributed < totalSupply );
117         
118         balances[_participant] = balances[_participant].add(_amount);
119         totalDistributed = totalDistributed.add(_amount);
120 
121         if (totalDistributed >= totalSupply) {
122             distributionFinished = true;
123         }
124         emit Airdrop(_participant, _amount, balances[_participant]);
125         emit Transfer(address(0), _participant, _amount);
126     }
127 
128     function AirdropSingle(address _participant, uint _amount) public onlyOwner {        
129         doAirdrop(_participant, _amount);
130     }
131 
132     function AirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
133         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
134     }
135 
136     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
137         tokensPerEth = _tokensPerEth;
138         emit TokensPerEthUpdated(_tokensPerEth);
139     }
140            
141     function () external payable {
142         getTokens();
143      }
144     
145     function getTokens() payable canDistr  public {
146         uint256 tokens = 0;
147         require( msg.value >= MIN );
148         require( msg.value > 0 );
149         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
150         address investor = msg.sender;
151         
152         if (tokens > 0) {
153             distr(investor, tokens);
154         }
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159     }
160 
161 
162     modifier onlyPayloadSize(uint size) {
163         assert(msg.data.length >= size + 4);
164         _;
165     }
166 
167     function balanceOf(address _owner) constant public returns (uint256) {
168         return balances[_owner];
169     }
170     
171     
172     function freeze(uint256 _value) returns (bool success) {
173         if (balances[msg.sender] < _value) throw;                               // Check if the sender has enough
174 		if (_value <= 0) throw; 
175         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      // Subtract from the sender
176         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       // Updates totalSupply
177         Freeze(msg.sender, _value);
178         return true;
179     }
180 	
181 	function unfreeze(uint256 _value) returns (bool success) {
182         if (freezeOf[msg.sender] < _value) throw;                               // Check if the sender has enough
183 		if (_value <= 0) throw; 
184         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);      // Subtract from the sender
185 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
186         Unfreeze(msg.sender, _value);
187         return true;
188     }
189     
190     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
191         //check if sender has balance and for oveflow
192         require(_to != address(0));
193         require(_amount <= balances[msg.sender]);
194         balances[msg.sender] = balances[msg.sender].sub(_amount);
195         balances[_to] = balances[_to].add(_amount);
196         emit Transfer(msg.sender, _to, _amount);
197         return true;
198     }
199     
200     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
201         require(_to != address(0));
202         require(_amount <= balances[_from]);
203         require(_amount <= allowed[_from][msg.sender]);
204         balances[_from] = balances[_from].sub(_amount);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         emit Transfer(_from, _to, _amount);
208         return true;
209     }
210 
211     //allow the contract owner to withdraw any token that are not belongs to Dexter Community
212      function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
213         ForeignToken token = ForeignToken(_tokenContract);
214         uint256 amount = token.balanceOf(address(this));
215         return token.transfer(owner, amount);
216     } //withdraw foreign tokens
217     
218     function approve(address _spender, uint256 _value) public returns (bool success) {
219         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     } 
224     
225     
226     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
227         ForeignToken t = ForeignToken(tokenAddress);
228         uint bal = t.balanceOf(who);
229         return bal;
230     }
231     
232     //withdraw Ethereum from Contract address
233     function withdrawEther() onlyOwner public {
234         address myAddress = this;
235         uint256 etherBalance = myAddress.balance;
236         owner.transfer(etherBalance);
237     }
238     
239     function allowance(address _owner, address _spender) constant public returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242     
243     //Burning specific amount of Dexter
244     function burnDexter(uint256 _value) onlyOwner public {
245         require(_value <= balances[msg.sender]);
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         totalDistributed = totalDistributed.sub(_value);
250         emit Burn(burner, _value);
251     } 
252     
253 }