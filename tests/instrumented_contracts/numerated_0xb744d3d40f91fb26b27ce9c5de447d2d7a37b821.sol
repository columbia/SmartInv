1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract AltcoinToken {
27     function balanceOf(address _owner) constant public returns (uint256);
28     function transfer(address _to, uint256 _value) public returns (bool);
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract GDCT is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "GD-Chain Token";						
55     string public constant symbol = "GDCT";							
56     uint public constant decimals = 8;    							
57     uint256 public totalSupply = 600000000e8;
58 	
59 	uint256 public tokenPerETH = 100000e8;
60 	
61     uint256 public totalDistributed = 0;       
62 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     
67     event Distr(address indexed to, uint256 amount);
68     event DistrFinished();
69     
70     event Burn(address indexed burner, uint256 value);
71 
72     bool public distributionFinished = false;
73     
74     modifier canDistr() {
75         require(!distributionFinished);
76         _;
77     }
78     
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83     
84     function GDCT () public {
85         owner = msg.sender;
86 		uint256 teamtoken = 400000000e8;	
87         distr(owner, teamtoken);
88     }
89     
90     function transferOwnership(address newOwner) onlyOwner public {
91         if (newOwner != address(0)) {
92             owner = newOwner;
93         }
94     }
95 
96     function finishDistribution() onlyOwner canDistr public returns (bool) {
97         distributionFinished = true;
98         emit DistrFinished();
99         return true;
100     }
101     
102     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
103         totalDistributed = totalDistributed.add(_amount);   
104 		totalRemaining = totalRemaining.sub(_amount);		
105         balances[_to] = balances[_to].add(_amount);
106         emit Distr(_to, _amount);
107         emit Transfer(address(0), _to, _amount);
108 
109         return true;
110     }
111            
112     function () external payable {
113 		address investor = msg.sender;
114 		uint256 invest = msg.value;
115 		
116 		uint256 toGive = tokenPerETH.mul(invest) / 1 ether;
117 		
118 		require(invest >= 1 ether/1000);
119 		
120 		distr(investor, toGive);
121 		
122 		owner.transfer(invest);
123 	}	
124     
125     function balanceOf(address _owner) constant public returns (uint256) {
126         return balances[_owner];
127     }
128 
129     modifier onlyPayloadSize(uint size) {
130         assert(msg.data.length >= size + 4);
131         _;
132     }
133     
134     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
135         require(_to != address(0));
136         require(_amount <= balances[msg.sender]);
137         
138         balances[msg.sender] = balances[msg.sender].sub(_amount);
139         balances[_to] = balances[_to].add(_amount);
140         emit Transfer(msg.sender, _to, _amount);
141         return true;
142     }
143     
144     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
145 
146         require(_to != address(0));
147         require(_amount <= balances[_from]);
148         require(_amount <= allowed[_from][msg.sender]);
149         
150         balances[_from] = balances[_from].sub(_amount);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
152         balances[_to] = balances[_to].add(_amount);
153         emit Transfer(_from, _to, _amount);
154         return true;
155     }
156     
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163     
164     function allowance(address _owner, address _spender) constant public returns (uint256) {
165         return allowed[_owner][_spender];
166     }
167     
168     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
169         AltcoinToken t = AltcoinToken(tokenAddress);
170         uint bal = t.balanceOf(who);
171         return bal;
172     }
173     
174     function withdraw() onlyOwner public {
175         address myAddress = this;
176         uint256 etherBalance = myAddress.balance;
177         owner.transfer(etherBalance);
178     }
179     
180     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
181         AltcoinToken token = AltcoinToken(_tokenContract);
182         uint256 amount = token.balanceOf(address(this));
183         return token.transfer(owner, amount);
184     }
185 	
186 	function burn(uint256 _value) onlyOwner public {
187         require(_value <= balances[msg.sender]);
188         
189         address burner = msg.sender;
190         balances[burner] = balances[burner].sub(_value);
191         totalSupply = totalSupply.sub(_value);
192         totalDistributed = totalDistributed.sub(_value);
193         emit Burn(burner, _value);
194     }
195 	
196 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
197         require(_value <= balances[_burner]);
198         
199         balances[_burner] = balances[_burner].sub(_value);
200         totalSupply = totalSupply.sub(_value);
201         totalDistributed = totalDistributed.sub(_value);
202         emit Burn(_burner, _value);
203     }
204 }