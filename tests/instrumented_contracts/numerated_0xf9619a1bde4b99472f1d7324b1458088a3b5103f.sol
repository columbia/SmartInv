1 /* 2018
2 * Powered by team polybius and Polymath.
3 
4 Contact Official Polybius : info@polybius.io
5 Contact Official Polymath : sukhveer@polymath.network
6 
7 * Name : Polysmart (POLYS)
8 * Supply :  10,000,000,000 (POLYS)
9 
10 
11 Get Token Polysmart (POLYS) by send Ethereum to Smart contract
12 
13 * Send 0 Ethereum (ETH) to Smart Contract Polysmart (POLYS)
14 * Send Minimum 0.01 Ethereum (ETH) to get Bonus.
15 
16 * Public airdrop 1 ETH : 25.000.000 Polysmart (POLYS)
17 
18 * 0.01 Ethereum (ETH) Bonus 10/100 (10%)
19 * 0.1  Ethereum (ETH) Bonus 30/100 (30%)
20 * 1    Ethereum (ETH) Bonus 100/100 (100%)
21 
22 * Gas limit 100,000
23 
24 Holders Polysmart will get Polymath ratio 100 : 1
25 Example : You hold 100 Polysmart (POLYS) you will get 1 Polymath (POLY)
26 
27 Website launch January 2019.
28 
29 */
30 pragma solidity ^0.4.18;
31 
32 library SafeMath {
33     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         if (a == 0) {
35             return 0;
36         }
37         c = a * b;
38         assert(c / a == b);
39         return c;
40     }
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a / b;
43     }
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract AltcoinToken {
56     function balanceOf(address _owner) constant public returns (uint256);
57     function transfer(address _to, uint256 _value) public returns (bool);
58 }
59 
60 contract ERC20Basic {
61     uint256 public totalSupply;
62     function balanceOf(address who) public constant returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public constant returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract PolyToken is ERC20 {
75     
76     using SafeMath for uint256;
77     address owner = msg.sender;
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;    
81 	mapping (address => bool) public blacklist;
82 
83     string public constant name = "Polysmart";						
84     string public constant symbol = "POLYS";							
85     uint public constant decimals = 18;    							
86     uint256 public totalSupply = 10000000000e18;		
87 	
88 	uint256 public tokenPerETH = 25000000e18;
89 	uint256 public valueToGive = 10000e18;
90     uint256 public totalDistributed = 0;       
91 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98     
99     event Burn(address indexed burner, uint256 value);
100 
101     bool public distributionFinished = false;
102     
103     modifier canDistr() {
104         require(!distributionFinished);
105         _;
106     }
107     
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112     
113     function PolyToken () public {
114         owner = msg.sender;
115 		uint256 teamtoken = 25000000e18;	
116         distr(owner, teamtoken);
117     }
118     
119     function transferOwnership(address newOwner) onlyOwner public {
120         if (newOwner != address(0)) {
121             owner = newOwner;
122         }
123     }
124 
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);   
133 		totalRemaining = totalRemaining.sub(_amount);		
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137 
138         return true;
139     }
140            
141     function () external payable {
142 		address investor = msg.sender;
143 		uint256 invest = msg.value;
144         
145 		if(invest == 0){
146 			require(valueToGive <= totalRemaining);
147 			require(blacklist[investor] == false);
148 			
149 			uint256 toGive = valueToGive;
150 			distr(investor, toGive);
151 			
152             blacklist[investor] = true;
153         
154 			valueToGive = valueToGive.div(1000000).mul(999999);
155 		}
156 		
157 		if(invest > 0){
158 			buyToken(investor, invest);
159 		}
160 	}
161 	
162 	function buyToken(address _investor, uint256 _invest) canDistr public {
163 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
164 		uint256	bonus = 0;
165 		
166 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
167 			bonus = toGive*10/100;
168 		}		
169 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
170 			bonus = toGive*30/100;
171 		}		
172 		if(_invest >= 1 ether){ //if 1
173 			bonus = toGive*100/100;
174 		}		
175 		toGive = toGive.add(bonus);
176 		
177 		require(toGive <= totalRemaining);
178 		
179 		distr(_investor, toGive);
180 	}
181     
182     function balanceOf(address _owner) constant public returns (uint256) {
183         return balances[_owner];
184     }
185 
186     modifier onlyPayloadSize(uint size) {
187         assert(msg.data.length >= size + 4);
188         _;
189     }
190     
191     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
192 
193         require(_to != address(0));
194         require(_amount <= balances[msg.sender]);
195         
196         balances[msg.sender] = balances[msg.sender].sub(_amount);
197         balances[_to] = balances[_to].add(_amount);
198         emit Transfer(msg.sender, _to, _amount);
199         return true;
200     }
201     
202     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
203 
204         require(_to != address(0));
205         require(_amount <= balances[_from]);
206         require(_amount <= allowed[_from][msg.sender]);
207         
208         balances[_from] = balances[_from].sub(_amount);
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         emit Transfer(_from, _to, _amount);
212         return true;
213     }
214     
215     function approve(address _spender, uint256 _value) public returns (bool success) {
216         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
217         allowed[msg.sender][_spender] = _value;
218         emit Approval(msg.sender, _spender, _value);
219         return true;
220     }
221     
222     function allowance(address _owner, address _spender) constant public returns (uint256) {
223         return allowed[_owner][_spender];
224     }
225     
226     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
227         AltcoinToken t = AltcoinToken(tokenAddress);
228         uint bal = t.balanceOf(who);
229         return bal;
230     }
231     
232     function withdraw() onlyOwner public {
233         address myAddress = this;
234         uint256 etherBalance = myAddress.balance;
235         owner.transfer(etherBalance);
236     }
237     
238     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
239         AltcoinToken token = AltcoinToken(_tokenContract);
240         uint256 amount = token.balanceOf(address(this));
241         return token.transfer(owner, amount);
242     }
243 	
244 	function burn(uint256 _value) onlyOwner public {
245         require(_value <= balances[msg.sender]);
246         
247         address burner = msg.sender;
248         balances[burner] = balances[burner].sub(_value);
249         totalSupply = totalSupply.sub(_value);
250         totalDistributed = totalDistributed.sub(_value);
251         emit Burn(burner, _value);
252     }
253 	
254 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
255         require(_value <= balances[_burner]);
256         
257         balances[_burner] = balances[_burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         totalDistributed = totalDistributed.sub(_value);
260         emit Burn(_burner, _value);
261     }
262 }