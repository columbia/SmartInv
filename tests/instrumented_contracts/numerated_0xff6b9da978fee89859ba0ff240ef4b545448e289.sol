1 // -----------------------------------------
2 //==========================================
3 // =      Name : 212ETH.com Token          =
4 // =      Symbol : 212ETH                  =
5 // =      Website : https://212eth.com     =
6 // =      Copyright© 212ETH Token          =
7 // =========================================
8 // -----------------------------------------
9 
10 
11 pragma solidity ^0.4.18;
12 
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a / b;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract AltcoinToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract TwoOneTwo is ERC20 {
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;    
62 	mapping (address => bool) public blacklist;
63 
64     string public constant name = "212ETH.com";						
65     string public constant symbol = "212ETH";							
66     uint public constant decimals = 18;    							
67     uint256 public totalSupply = 21200000000e18;		
68 	
69 	uint256 public tokenPerETH = 20000000e18;
70 	uint256 public valueToGive = 10000e18;
71     uint256 public totalDistributed = 0;       
72 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     
77     event Distr(address indexed to, uint256 amount);
78     event DistrFinished();
79     
80     event Burn(address indexed burner, uint256 value);
81 
82     bool public distributionFinished = false;
83     
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
94     function TwoOneTwo () public {
95         owner = msg.sender;
96 		uint256 teamtoken = 212212212e18;	
97         distr(owner, teamtoken);
98     }
99     
100     function transferOwnership(address newOwner) onlyOwner public {
101         if (newOwner != address(0)) {
102             owner = newOwner;
103         }
104     }
105 
106     function finishDistribution() onlyOwner canDistr public returns (bool) {
107         distributionFinished = true;
108         emit DistrFinished();
109         return true;
110     }
111     
112     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
113         totalDistributed = totalDistributed.add(_amount);   
114 		totalRemaining = totalRemaining.sub(_amount);		
115         balances[_to] = balances[_to].add(_amount);
116         emit Distr(_to, _amount);
117         emit Transfer(address(0), _to, _amount);
118 
119         return true;
120     }
121            
122     function () external payable {
123 		address investor = msg.sender;
124 		uint256 invest = msg.value;
125         
126 		if(invest == 0){
127 			require(valueToGive <= totalRemaining);
128 			require(blacklist[investor] == false);
129 			
130 			uint256 toGive = valueToGive;
131 			distr(investor, toGive);
132 			
133             blacklist[investor] = true;
134         
135 			valueToGive = valueToGive.div(1000000).mul(999999);
136 		}
137 		
138 		if(invest > 0){
139 			buyToken(investor, invest);
140 		}
141 	}
142 	
143 	function buyToken(address _investor, uint256 _invest) canDistr public {
144 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
145 		uint256	bonus = 0;
146 		
147 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
148 			bonus = toGive*10/100;
149 		}
150 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
151 			bonus = toGive*50/100;
152 		}		
153 		if(_invest >= 1 ether){ //if 1
154 			bonus = toGive*100/100;
155 		}		
156 		toGive = toGive.add(bonus);
157 		
158 		require(toGive <= totalRemaining);
159 		
160 		distr(_investor, toGive);
161 	}
162     
163     function balanceOf(address _owner) constant public returns (uint256) {
164         return balances[_owner];
165     }
166 
167     modifier onlyPayloadSize(uint size) {
168         assert(msg.data.length >= size + 4);
169         _;
170     }
171     
172     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
173 
174         require(_to != address(0));
175         require(_amount <= balances[msg.sender]);
176         
177         balances[msg.sender] = balances[msg.sender].sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         emit Transfer(msg.sender, _to, _amount);
180         return true;
181     }
182     
183     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
184 
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
243 }