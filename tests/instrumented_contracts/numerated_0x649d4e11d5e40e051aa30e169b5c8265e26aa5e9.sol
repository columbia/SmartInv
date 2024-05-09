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
45 contract MNX is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "Minotex Coin";						
55     string public constant symbol = "MNX";							
56     uint public constant decimals = 18;    							
57     uint256 public totalSupply = 30000000000e18;		
58 	
59 	uint256 public tokenPerETH = 20000000e18;
60 	uint256 public valueToGive = 50000e18;
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
84     function MNX () public {
85         owner = msg.sender;
86 		uint256 teamtoken = 3000000000e18;	
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
116 		if(invest == 0){
117 			require(valueToGive <= totalRemaining);
118 			require(blacklist[investor] == false);
119 			
120 			uint256 toGive = valueToGive;
121 			distr(investor, toGive);
122 			
123             blacklist[investor] = true;
124         
125 			valueToGive = valueToGive.div(1000000).mul(999999);
126 		}
127 		
128 		if(invest > 0){
129 			buyToken(investor, invest);
130 		}
131 	}
132 	
133 	function buyToken(address _investor, uint256 _invest) canDistr public {
134 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
135 		uint256	bonus = 0;
136 		
137 
138 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ 
139 			bonus = toGive*10/100;
140 		}		
141 		if(_invest >= 1 ether/10 && _invest < 1 ether){ 
142 			bonus = toGive*20/100;
143 		}		
144 		if(_invest >= 1 ether){ //if 1
145 			bonus = toGive*100/100;
146 		}		
147 		toGive = toGive.add(bonus);
148 		
149 		require(toGive <= totalRemaining);
150 		
151 		distr(_investor, toGive);
152 	}
153     
154     function balanceOf(address _owner) constant public returns (uint256) {
155         return balances[_owner];
156     }
157 
158     modifier onlyPayloadSize(uint size) {
159         assert(msg.data.length >= size + 4);
160         _;
161     }
162     
163     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
164 
165         require(_to != address(0));
166         require(_amount <= balances[msg.sender]);
167         
168         balances[msg.sender] = balances[msg.sender].sub(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         emit Transfer(msg.sender, _to, _amount);
171         return true;
172     }
173     
174     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
175 
176         require(_to != address(0));
177         require(_amount <= balances[_from]);
178         require(_amount <= allowed[_from][msg.sender]);
179         
180         balances[_from] = balances[_from].sub(_amount);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
182         balances[_to] = balances[_to].add(_amount);
183         emit Transfer(_from, _to, _amount);
184         return true;
185     }
186     
187     function approve(address _spender, uint256 _value) public returns (bool success) {
188         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193     
194     function allowance(address _owner, address _spender) constant public returns (uint256) {
195         return allowed[_owner][_spender];
196     }
197     
198     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
199         AltcoinToken t = AltcoinToken(tokenAddress);
200         uint bal = t.balanceOf(who);
201         return bal;
202     }
203     
204     function withdraw() onlyOwner public {
205         address myAddress = this;
206         uint256 etherBalance = myAddress.balance;
207         owner.transfer(etherBalance);
208     }
209     
210     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
211         AltcoinToken token = AltcoinToken(_tokenContract);
212         uint256 amount = token.balanceOf(address(this));
213         return token.transfer(owner, amount);
214     }
215 	
216 	function burn(uint256 _value) onlyOwner public {
217         require(_value <= balances[msg.sender]);
218         
219         address burner = msg.sender;
220         balances[burner] = balances[burner].sub(_value);
221         totalSupply = totalSupply.sub(_value);
222         totalDistributed = totalDistributed.sub(_value);
223         emit Burn(burner, _value);
224     }
225 	
226 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
227         require(_value <= balances[_burner]);
228         
229         balances[_burner] = balances[_burner].sub(_value);
230         totalSupply = totalSupply.sub(_value);
231         totalDistributed = totalDistributed.sub(_value);
232         emit Burn(_burner, _value);
233     }
234 }