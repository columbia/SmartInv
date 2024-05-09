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
45 contract MCC is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "MetaCashCoin";						
55     string public constant symbol = "MCC";							
56     uint public constant decimals = 18;    							
57     uint256 public totalSupply = 100000000000e18;		
58 	
59 	uint256 public tokenPerETH = 10000000e18;
60 	uint256 public valueToGive = 25000e18;
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
84     function MCC () public {
85         owner = msg.sender;
86 		uint256 teamtoken = 1000000000e18;	
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
137 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
138 			bonus = toGive*10/100;
139 		}		
140 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
141 			bonus = toGive*20/100;
142 		}		
143 		if(_invest >= 1 ether){ //if 1
144 			bonus = toGive*50/100;
145 		}		
146 		toGive = toGive.add(bonus);
147 		
148 		require(toGive <= totalRemaining);
149 		
150 		distr(_investor, toGive);
151 	}
152     
153     function balanceOf(address _owner) constant public returns (uint256) {
154         return balances[_owner];
155     }
156 
157     modifier onlyPayloadSize(uint size) {
158         assert(msg.data.length >= size + 4);
159         _;
160     }
161     
162     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
163 
164         require(_to != address(0));
165         require(_amount <= balances[msg.sender]);
166         
167         balances[msg.sender] = balances[msg.sender].sub(_amount);
168         balances[_to] = balances[_to].add(_amount);
169         emit Transfer(msg.sender, _to, _amount);
170         return true;
171     }
172     
173     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
174 
175         require(_to != address(0));
176         require(_amount <= balances[_from]);
177         require(_amount <= allowed[_from][msg.sender]);
178         
179         balances[_from] = balances[_from].sub(_amount);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181         balances[_to] = balances[_to].add(_amount);
182         emit Transfer(_from, _to, _amount);
183         return true;
184     }
185     
186     function approve(address _spender, uint256 _value) public returns (bool success) {
187         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
188         allowed[msg.sender][_spender] = _value;
189         emit Approval(msg.sender, _spender, _value);
190         return true;
191     }
192     
193     function allowance(address _owner, address _spender) constant public returns (uint256) {
194         return allowed[_owner][_spender];
195     }
196     
197     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
198         AltcoinToken t = AltcoinToken(tokenAddress);
199         uint bal = t.balanceOf(who);
200         return bal;
201     }
202     
203     function withdraw() onlyOwner public {
204         address myAddress = this;
205         uint256 etherBalance = myAddress.balance;
206         owner.transfer(etherBalance);
207     }
208     
209     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
210         AltcoinToken token = AltcoinToken(_tokenContract);
211         uint256 amount = token.balanceOf(address(this));
212         return token.transfer(owner, amount);
213     }
214 	
215 	function burn(uint256 _value) onlyOwner public {
216         require(_value <= balances[msg.sender]);
217         
218         address burner = msg.sender;
219         balances[burner] = balances[burner].sub(_value);
220         totalSupply = totalSupply.sub(_value);
221         totalDistributed = totalDistributed.sub(_value);
222         emit Burn(burner, _value);
223     }
224 	
225 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
226         require(_value <= balances[_burner]);
227         
228         balances[_burner] = balances[_burner].sub(_value);
229         totalSupply = totalSupply.sub(_value);
230         totalDistributed = totalDistributed.sub(_value);
231         emit Burn(_burner, _value);
232     }
233 }