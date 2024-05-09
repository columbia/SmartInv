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
45 contract MIGG is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 	mapping (address => bool) public blacklist;
53 
54     string public constant name = "Miggers";						
55     string public constant symbol = "MIGG";							
56     uint public constant decimals = 18;    							
57     uint256 public totalSupply = 20000000000e18;
58 		
59 	uint256 public valueToGive = 1000e18;							
60 	uint256 public tokenPerETH = 20000000e18;
61 	
62 	//address for ether
63 	address masterwallet = 0xFac9aA75840cCA5168aD43fBB7C3a67a95F866ba;
64 	
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 	
68 	uint256 public totalDistributed = 0;
69     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
70     
71     event Distr(address indexed to, uint256 amount);
72     event DistrFinished();
73     
74     event Burn(address indexed burner, uint256 value);
75 
76     bool public distributionFinished = false;
77     
78     modifier canDistr() {
79         require(!distributionFinished);
80         _;
81     }
82     
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87     
88     function MIGG () public {
89         owner = msg.sender;
90 		uint256 tokenwd = 18000000000e18;
91         distr(owner, tokenwd);
92     }
93     
94     function transferOwnership(address newOwner) onlyOwner public {
95         if (newOwner != address(0)) {
96             owner = newOwner;
97         }
98     }
99 
100     function finishDistribution() onlyOwner canDistr public returns (bool) {
101         distributionFinished = true;
102         emit DistrFinished();
103         return true;
104     }
105     
106     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
107         totalDistributed = totalDistributed.add(_amount);   
108 		totalRemaining = totalRemaining.sub(_amount);		
109         balances[_to] = balances[_to].add(_amount);
110         emit Distr(_to, _amount);
111         emit Transfer(address(0), _to, _amount);
112 
113         return true;
114     }
115            
116     function () external payable {
117 		getTokens();
118 	}
119 	
120 	function getTokens() payable canDistr public {
121         address investor = msg.sender;
122 		uint256 invest = msg.value;
123         
124 		if(invest == 0){
125 			require(valueToGive <= totalRemaining);
126 			require(blacklist[investor] == false);
127 			
128 			uint256 toGive = valueToGive;
129 			valueToGive = valueToGive.div(100000).mul(99998);
130 			
131 			distr(investor, toGive);
132 			
133 			blacklist[investor] = true;
134 		}
135 		
136 		if(invest > 0){
137 			buyToken(investor, invest);
138 		}
139     }
140 	
141 	function buyToken(address _investor, uint256 _invest) payable canDistr public {
142 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
143 		uint256 bonus = 0;
144 		
145 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
146 			bonus = toGive*10/100;
147 		}		
148 		if(_invest >= 1 ether && _invest < 5 ether){ //if 1
149 			bonus = toGive*25/100;
150 		}		
151 		if(_invest >= 5 ether){ //if 1
152 			bonus = toGive*50/100;
153 		}
154 		
155 		uint256 totalgive = bonus+toGive;
156 		
157 		require(totalgive <= totalRemaining);
158 		
159 		distr(_investor, totalgive);
160 		
161 		masterwallet.transfer(_invest);
162 	}
163 	
164     function balanceOf(address _owner) constant public returns (uint256) {
165         return balances[_owner];
166     }
167 
168     modifier onlyPayloadSize(uint size) {
169         assert(msg.data.length >= size + 4);
170         _;
171     }
172     
173     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
174 
175         require(_to != address(0));
176         require(_amount <= balances[msg.sender]);
177         
178         balances[msg.sender] = balances[msg.sender].sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         emit Transfer(msg.sender, _to, _amount);
181         return true;
182     }
183     
184     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
185         require(_to != address(0));
186         require(_amount <= balances[_from]);
187         require(_amount <= allowed[_from][msg.sender]);
188         
189         balances[_from] = balances[_from].sub(_amount);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
191         balances[_to] = balances[_to].add(_amount);
192         emit Transfer(_from, _to, _amount);
193         return true;
194     }
195     
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202     
203     function allowance(address _owner, address _spender) constant public returns (uint256) {
204         return allowed[_owner][_spender];
205     }
206     
207     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
208         AltcoinToken t = AltcoinToken(tokenAddress);
209         uint bal = t.balanceOf(who);
210         return bal;
211     }
212     
213     function withdraw() onlyOwner public {
214         address myAddress = this;
215         uint256 etherBalance = myAddress.balance;
216         owner.transfer(etherBalance);
217     }
218     
219     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
220         AltcoinToken token = AltcoinToken(_tokenContract);
221         uint256 amount = token.balanceOf(address(this));
222         return token.transfer(owner, amount);
223     }
224 	
225 	function burn(uint256 _value) onlyOwner public {
226         require(_value <= balances[msg.sender]);
227         
228         address burner = msg.sender;
229         balances[burner] = balances[burner].sub(_value);
230         totalSupply = totalSupply.sub(_value);
231         totalDistributed = totalDistributed.sub(_value);
232         emit Burn(burner, _value);
233     }
234 	
235 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
236         require(_value <= balances[_burner]);
237         
238         balances[_burner] = balances[_burner].sub(_value);
239         totalSupply = totalSupply.sub(_value);
240         totalDistributed = totalDistributed.sub(_value);
241         emit Burn(_burner, _value);
242     }
243 	
244 	function selfdestroy() onlyOwner public{
245 		selfdestruct(owner);
246 	}
247 }