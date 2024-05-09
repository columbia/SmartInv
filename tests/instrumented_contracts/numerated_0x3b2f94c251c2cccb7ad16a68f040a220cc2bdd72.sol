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
45 contract ALU is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "ALUCHAIN";						
55     string public constant symbol = "ALU";							
56     uint public constant decimals = 8;    							
57     uint256 public totalSupply = 10000000000e8;	
58 	
59     uint256 public totalDistributed = 0;       
60 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64     
65     event Distr(address indexed to, uint256 amount);
66     event DistrFinished();
67     
68     event Burn(address indexed burner, uint256 value);
69 
70     bool public distributionFinished = false;
71     
72     modifier canDistr() {
73         require(!distributionFinished);
74         _;
75     }
76     
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     function ALU () public {
83         owner = msg.sender;
84 		uint256 teamtoken = totalSupply;	
85         distr(owner, teamtoken);
86     }
87     
88     function transferOwnership(address newOwner) onlyOwner public {
89         if (newOwner != address(0)) {
90             owner = newOwner;
91         }
92     }
93 
94     function finishDistribution() onlyOwner canDistr public returns (bool) {
95         distributionFinished = true;
96         emit DistrFinished();
97         return true;
98     }
99     
100     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
101         totalDistributed = totalDistributed.add(_amount);   
102 		totalRemaining = totalRemaining.sub(_amount);		
103         balances[_to] = balances[_to].add(_amount);
104         emit Distr(_to, _amount);
105         emit Transfer(address(0), _to, _amount);
106 
107         return true;
108     }
109            
110     function () external payable {
111 		revert();
112 	}
113     
114     function balanceOf(address _owner) constant public returns (uint256) {
115         return balances[_owner];
116     }
117 
118     modifier onlyPayloadSize(uint size) {
119         assert(msg.data.length >= size + 4);
120         _;
121     }
122     
123     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
124         require(_to != address(0));
125         require(_amount <= balances[msg.sender]);
126         
127         balances[msg.sender] = balances[msg.sender].sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         emit Transfer(msg.sender, _to, _amount);
130         return true;
131     }
132     
133     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
134 
135         require(_to != address(0));
136         require(_amount <= balances[_from]);
137         require(_amount <= allowed[_from][msg.sender]);
138         
139         balances[_from] = balances[_from].sub(_amount);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
141         balances[_to] = balances[_to].add(_amount);
142         emit Transfer(_from, _to, _amount);
143         return true;
144     }
145     
146     function approve(address _spender, uint256 _value) public returns (bool success) {
147         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152     
153     function allowance(address _owner, address _spender) constant public returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156     
157     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
158         AltcoinToken t = AltcoinToken(tokenAddress);
159         uint bal = t.balanceOf(who);
160         return bal;
161     }
162     
163     function withdraw() onlyOwner public {
164         address myAddress = this;
165         uint256 etherBalance = myAddress.balance;
166         owner.transfer(etherBalance);
167     }
168     
169     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
170         AltcoinToken token = AltcoinToken(_tokenContract);
171         uint256 amount = token.balanceOf(address(this));
172         return token.transfer(owner, amount);
173     }
174 	
175 	function burn(uint256 _value) onlyOwner public {
176         require(_value <= balances[msg.sender]);
177         
178         address burner = msg.sender;
179         balances[burner] = balances[burner].sub(_value);
180         totalSupply = totalSupply.sub(_value);
181         totalDistributed = totalDistributed.sub(_value);
182         emit Burn(burner, _value);
183     }
184 	
185 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
186         require(_value <= balances[_burner]);
187         
188         balances[_burner] = balances[_burner].sub(_value);
189         totalSupply = totalSupply.sub(_value);
190         totalDistributed = totalDistributed.sub(_value);
191         emit Burn(_burner, _value);
192     }
193 }