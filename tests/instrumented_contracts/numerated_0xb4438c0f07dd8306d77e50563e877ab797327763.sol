1 //Website:https://imchain.org
2 
3 pragma solidity ^0.4.18;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract AltcoinToken {
29     function balanceOf(address _owner) constant public returns (uint256);
30     function transfer(address _to, uint256 _value) public returns (bool);
31 }
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public constant returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract imchain is ERC20 {
48     
49     using SafeMath for uint256;
50     address owner = msg.sender;
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;    
54 	mapping (address => bool) public blacklist;
55 
56     string public constant name = "imchain";						
57     string public constant symbol = "IMC";							
58     uint public constant decimals = 18;    							
59     uint256 public totalSupply = 10000000000e18;		
60 	
61 	uint256 public tokenPerETH = 8000000e18;
62 	uint256 public valueToGive = 1000e18;
63     uint256 public totalDistributed = 0;       
64 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68     
69     event Distr(address indexed to, uint256 amount);
70     event DistrFinished();
71     
72     event Burn(address indexed burner, uint256 value);
73 
74     bool public distributionFinished = false;
75     
76     modifier canDistr() {
77         require(!distributionFinished);
78         _;
79     }
80     
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85     
86     function imchain () public {
87         owner = msg.sender;
88 		uint256 teamtoken = 4400000000e18;	
89         distr(owner, teamtoken);
90     }
91     
92     function transferOwnership(address newOwner) onlyOwner public {
93         if (newOwner != address(0)) {
94             owner = newOwner;
95         }
96     }
97 
98     function finishDistribution() onlyOwner canDistr public returns (bool) {
99         distributionFinished = true;
100         emit DistrFinished();
101         return true;
102     }
103     
104     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
105         totalDistributed = totalDistributed.add(_amount);   
106 		totalRemaining = totalRemaining.sub(_amount);		
107         balances[_to] = balances[_to].add(_amount);
108         emit Distr(_to, _amount);
109         emit Transfer(address(0), _to, _amount);
110 
111         return true;
112     }
113            
114     function () external payable {
115 		address investor = msg.sender;
116 		uint256 invest = msg.value;
117         
118 		if(invest == 0){
119 			require(valueToGive <= totalRemaining);
120 			require(blacklist[investor] == false);
121 			
122 			uint256 toGive = valueToGive;
123 			distr(investor, toGive);
124 			
125             blacklist[investor] = true;
126         
127 			valueToGive = valueToGive.div(1000000).mul(999999);
128 		}
129 		
130 		if(invest > 0){
131 			buyToken(investor, invest);
132 		}
133 	}
134 	
135 	function buyToken(address _investor, uint256 _invest) canDistr public {
136 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
137 		uint256	bonus = 0;
138 		
139 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
140 			bonus = toGive*50/100;
141 		}		
142 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
143 			bonus = toGive*80/100;
144 		}		
145 		if(_invest >= 1 ether){ //if 1
146 			bonus = toGive*100/100;
147 		}		
148 		toGive = toGive.add(bonus);
149 		
150 		require(toGive <= totalRemaining);
151 		
152 		distr(_investor, toGive);
153 	}
154     
155     function balanceOf(address _owner) constant public returns (uint256) {
156         return balances[_owner];
157     }
158 
159     modifier onlyPayloadSize(uint size) {
160         assert(msg.data.length >= size + 4);
161         _;
162     }
163     
164     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
165 
166         require(_to != address(0));
167         require(_amount <= balances[msg.sender]);
168         
169         balances[msg.sender] = balances[msg.sender].sub(_amount);
170         balances[_to] = balances[_to].add(_amount);
171         emit Transfer(msg.sender, _to, _amount);
172         return true;
173     }
174     
175     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
176 
177         require(_to != address(0));
178         require(_amount <= balances[_from]);
179         require(_amount <= allowed[_from][msg.sender]);
180         
181         balances[_from] = balances[_from].sub(_amount);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
183         balances[_to] = balances[_to].add(_amount);
184         emit Transfer(_from, _to, _amount);
185         return true;
186     }
187     
188     function approve(address _spender, uint256 _value) public returns (bool success) {
189         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195     function allowance(address _owner, address _spender) constant public returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198     
199     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
200         AltcoinToken t = AltcoinToken(tokenAddress);
201         uint bal = t.balanceOf(who);
202         return bal;
203     }
204     
205     function withdraw() onlyOwner public {
206         address myAddress = this;
207         uint256 etherBalance = myAddress.balance;
208         owner.transfer(etherBalance);
209     }
210     
211     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
212         AltcoinToken token = AltcoinToken(_tokenContract);
213         uint256 amount = token.balanceOf(address(this));
214         return token.transfer(owner, amount);
215     }
216 	
217 	function burn(uint256 _value) onlyOwner public {
218         require(_value <= balances[msg.sender]);
219         
220         address burner = msg.sender;
221         balances[burner] = balances[burner].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         totalDistributed = totalDistributed.sub(_value);
224         emit Burn(burner, _value);
225     }
226 	
227 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
228         require(_value <= balances[_burner]);
229         
230         balances[_burner] = balances[_burner].sub(_value);
231         totalSupply = totalSupply.sub(_value);
232         totalDistributed = totalDistributed.sub(_value);
233         emit Burn(_burner, _value);
234     }
235 }