1 pragma solidity ^0.4.24;
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
45 contract TMYC is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "TradeMyCoin";						
55     string public constant symbol = "TYMC";							
56     uint public constant decimals = 18;    							
57     uint256 public totalSupply = 15000000000e18;		
58 	
59 	uint256 public tokenPerETH = 50000000e18;
60 	uint256 public valueToGive = 10000e18;
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
84     function TMYC () public {
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
125 			valueToGive = valueToGive.div(1000000).mul(9999999);
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
140 		if(_invest >= 1 ether/100 && _invest < 1 ether){ //if 0,05
141 			bonus = toGive*20/100;
142 		}		
143 		if(_invest >= 1 ether/100 && _invest < 1 ether){ //if 0,1
144 			bonus = toGive*30/100;
145 		}		
146 		if(_invest >= 1 ether){ //if 1
147 			bonus = toGive*50/100;
148 		}		
149 		toGive = toGive.add(bonus);
150 		
151 		require(toGive <= totalRemaining);
152 		
153 		distr(_investor, toGive);
154 	}
155     
156     function balanceOf(address _owner) constant public returns (uint256) {
157         return balances[_owner];
158     }
159 
160     modifier onlyPayloadSize(uint size) {
161         assert(msg.data.length >= size + 4);
162         _;
163     }
164     
165     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
166 
167         require(_to != address(0));
168         require(_amount <= balances[msg.sender]);
169         
170         balances[msg.sender] = balances[msg.sender].sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         emit Transfer(msg.sender, _to, _amount);
173         return true;
174     }
175     
176     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
177 
178         require(_to != address(0));
179         require(_amount <= balances[_from]);
180         require(_amount <= allowed[_from][msg.sender]);
181         
182         balances[_from] = balances[_from].sub(_amount);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
184         balances[_to] = balances[_to].add(_amount);
185         emit Transfer(_from, _to, _amount);
186         return true;
187     }
188     
189     function approve(address _spender, uint256 _value) public returns (bool success) {
190         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
191         allowed[msg.sender][_spender] = _value;
192         emit Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     function allowance(address _owner, address _spender) constant public returns (uint256) {
197         return allowed[_owner][_spender];
198     }
199     
200     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
201         AltcoinToken t = AltcoinToken(tokenAddress);
202         uint bal = t.balanceOf(who);
203         return bal;
204     }
205     
206     function withdraw() onlyOwner public {
207         address myAddress = this;
208         uint256 etherBalance = myAddress.balance;
209         owner.transfer(etherBalance);
210     }
211     
212     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
213         AltcoinToken token = AltcoinToken(_tokenContract);
214         uint256 amount = token.balanceOf(address(this));
215         return token.transfer(owner, amount);
216     }
217 	
218 	function burn(uint256 _value) onlyOwner public {
219         require(_value <= balances[msg.sender]);
220         
221         address burner = msg.sender;
222         balances[burner] = balances[burner].sub(_value);
223         totalSupply = totalSupply.sub(_value);
224         totalDistributed = totalDistributed.sub(_value);
225         emit Burn(burner, _value);
226     }
227 	
228 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
229         require(_value <= balances[_burner]);
230         
231         balances[_burner] = balances[_burner].sub(_value);
232         totalSupply = totalSupply.sub(_value);
233         totalDistributed = totalDistributed.sub(_value);
234         emit Burn(_burner, _value);
235     }
236 }