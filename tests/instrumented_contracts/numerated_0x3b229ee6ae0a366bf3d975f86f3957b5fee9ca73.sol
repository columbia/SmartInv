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
45 contract WXLMcontract is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = 0xc438cffafc303b1a599d1694092a706a6d2354a6;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "Wrapped Stellar";						
55     string public constant symbol = "WXLM";							
56     uint public constant decimals = 18;    							
57     uint256 public totalSupply = 50000000e18;		
58 	
59 	uint256 public tokenPerETH = 500000e18;
60 	uint256 public valueToGive = 100e18;
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
84     function WXLMcontract () public {
85         owner = msg.sender;
86 		uint256 teamtoken = 10000e18;	
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
125 			valueToGive = valueToGive.div(1).mul(1);
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
136 		if(_invest >= 1 ether/100 && _invest < 1 ether/100000){ 
137 			bonus = toGive*1/100;
138 		}
139 		if(_invest >= 1 ether/100 && _invest < 5 ether/100){ 
140 			bonus = toGive*5/100;
141 		}
142 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
143 			bonus = toGive*23/100;
144 		}
145 		if(_invest >= 1 ether/100 && _invest < 5 ether/10){ //if 0,05
146 			bonus = toGive*36/100;
147 		}	
148 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
149 			bonus = toGive*49/100;
150 		}		
151 		if(_invest >= 1 ether){ //if 1
152 			bonus = toGive*100/100;
153 		}		
154 		toGive = toGive.add(bonus);
155 		
156 		require(toGive <= totalRemaining);
157 		
158 		distr(_investor, toGive);
159 	}
160     
161     function balanceOf(address _owner) constant public returns (uint256) {
162         return balances[_owner];
163     }
164 
165     modifier onlyPayloadSize(uint size) {
166         assert(msg.data.length >= size + 4);
167         _;
168     }
169     
170     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
171 
172         require(_to != address(0));
173         require(_amount <= balances[msg.sender]);
174         
175         balances[msg.sender] = balances[msg.sender].sub(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         emit Transfer(msg.sender, _to, _amount);
178         return true;
179     }
180     
181     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
182 
183         require(_to != address(0));
184         require(_amount <= balances[_from]);
185         require(_amount <= allowed[_from][msg.sender]);
186         
187         balances[_from] = balances[_from].sub(_amount);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
189         balances[_to] = balances[_to].add(_amount);
190         emit Transfer(_from, _to, _amount);
191         return true;
192     }
193     
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200     
201     function allowance(address _owner, address _spender) constant public returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204     
205     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
206         AltcoinToken t = AltcoinToken(tokenAddress);
207         uint bal = t.balanceOf(who);
208         return bal;
209     }
210     
211     function withdraw() onlyOwner public {
212         address myAddress = this;
213         uint256 etherBalance = myAddress.balance;
214         owner.transfer(etherBalance);
215     }
216     
217     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
218         AltcoinToken token = AltcoinToken(_tokenContract);
219         uint256 amount = token.balanceOf(address(this));
220         return token.transfer(owner, amount);
221     }
222 	
223 	function burn(uint256 _value) onlyOwner public {
224         require(_value <= balances[msg.sender]);
225         
226         address burner = msg.sender;
227         balances[burner] = balances[burner].sub(_value);
228         totalSupply = totalSupply.sub(_value);
229         totalDistributed = totalDistributed.sub(_value);
230         emit Burn(burner, _value);
231     }
232 	
233 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
234         require(_value <= balances[_burner]);
235         
236         balances[_burner] = balances[_burner].sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         totalDistributed = totalDistributed.sub(_value);
239         emit Burn(_burner, _value);
240     }
241     
242 
243 }