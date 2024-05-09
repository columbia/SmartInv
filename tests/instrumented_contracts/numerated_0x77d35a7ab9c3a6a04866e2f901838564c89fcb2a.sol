1 //* FiberStar Token
2 
3 //* Send ETH to claim FiberStar *\\
4 //* Open Price fisrt exchange : 0.0000268 ETH
5 
6 
7 pragma solidity ^0.4.25;
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract AltcoinToken {
33     function balanceOf(address _owner) constant public returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35 }
36 
37 contract ERC20Basic {
38     uint256 public totalSupply;
39     function balanceOf(address who) public constant returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 contract ERC20 is ERC20Basic {
45     function allowance(address owner, address spender) public constant returns (uint256);
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47     function approve(address spender, uint256 value) public returns (bool);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract FiberStar is ERC20 {
52     
53     using SafeMath for uint256;
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;    
58 	mapping (address => bool) public blacklist;
59 
60     string public constant name = "FiberStar Token";						
61     string public constant symbol = "FST";							
62     uint public constant decimals = 18;    							
63     uint256 public totalSupply = 12811111099e18;		
64 	
65 	uint256 public tokenPerETH = 128111110;
66 	uint256 public valueToGive = 35000e18;
67     uint256 public totalDistributed = 0;       
68 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     
76     event Burn(address indexed burner, uint256 value);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     function FiberStar () public {
91         owner = msg.sender;
92 		uint256 teamtoken = 1281111e18;	
93         distr(owner, teamtoken);
94     }
95     
96     function transferOwnership(address newOwner) onlyOwner public {
97         if (newOwner != address(0)) {
98             owner = newOwner;
99         }
100     }
101 
102     function finishDistribution() onlyOwner canDistr public returns (bool) {
103         distributionFinished = true;
104         emit DistrFinished();
105         return true;
106     }
107     
108     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
109         totalDistributed = totalDistributed.add(_amount);   
110 		totalRemaining = totalRemaining.sub(_amount);		
111         balances[_to] = balances[_to].add(_amount);
112         emit Distr(_to, _amount);
113         emit Transfer(address(0), _to, _amount);
114 
115         return true;
116     }
117            
118     function () external payable {
119 		address investor = msg.sender;
120 		uint256 invest = msg.value;
121         
122 		if(invest == 0){
123 			require(valueToGive <= totalRemaining);
124 			require(blacklist[investor] == false);
125 			
126 			uint256 toGive = valueToGive;
127 			distr(investor, toGive);
128 			
129             blacklist[investor] = true;
130         
131 			valueToGive = valueToGive.div(1000000).mul(999999);
132 		}
133 		
134 		if(invest > 0){
135 			buyToken(investor, invest);
136 		}
137 	}
138 	
139 	function buyToken(address _investor, uint256 _invest) canDistr public {
140 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
141 		uint256	bonus = 0;
142 		
143 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
144 			bonus = toGive*10/100;
145 		}		
146 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
147 			bonus = toGive*20/100;
148 		}		
149 		if(_invest >= 1 ether){ //if 1
150 			bonus = toGive*50/100;
151 		}		
152 		toGive = toGive.add(bonus);
153 		
154 		require(toGive <= totalRemaining);
155 		
156 		distr(_investor, toGive);
157 	}
158     
159     function balanceOf(address _owner) constant public returns (uint256) {
160         return balances[_owner];
161     }
162 
163     modifier onlyPayloadSize(uint size) {
164         assert(msg.data.length >= size + 4);
165         _;
166     }
167     
168     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
169 
170         require(_to != address(0));
171         require(_amount <= balances[msg.sender]);
172         
173         balances[msg.sender] = balances[msg.sender].sub(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         emit Transfer(msg.sender, _to, _amount);
176         return true;
177     }
178     
179     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
180 
181         require(_to != address(0));
182         require(_amount <= balances[_from]);
183         require(_amount <= allowed[_from][msg.sender]);
184         
185         balances[_from] = balances[_from].sub(_amount);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
187         balances[_to] = balances[_to].add(_amount);
188         emit Transfer(_from, _to, _amount);
189         return true;
190     }
191     
192     function approve(address _spender, uint256 _value) public returns (bool success) {
193         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
194         allowed[msg.sender][_spender] = _value;
195         emit Approval(msg.sender, _spender, _value);
196         return true;
197     }
198     
199     function allowance(address _owner, address _spender) constant public returns (uint256) {
200         return allowed[_owner][_spender];
201     }
202     
203     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
204         AltcoinToken t = AltcoinToken(tokenAddress);
205         uint bal = t.balanceOf(who);
206         return bal;
207     }
208     
209     function withdraw() onlyOwner public {
210         address myAddress = this;
211         uint256 etherBalance = myAddress.balance;
212         owner.transfer(etherBalance);
213     }
214     
215     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
216         AltcoinToken token = AltcoinToken(_tokenContract);
217         uint256 amount = token.balanceOf(address(this));
218         return token.transfer(owner, amount);
219     }
220 	
221 	function burn(uint256 _value) onlyOwner public {
222         require(_value <= balances[msg.sender]);
223         
224         address burner = msg.sender;
225         balances[burner] = balances[burner].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227         totalDistributed = totalDistributed.sub(_value);
228         emit Burn(burner, _value);
229     }
230 	
231 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
232         require(_value <= balances[_burner]);
233         
234         balances[_burner] = balances[_burner].sub(_value);
235         totalSupply = totalSupply.sub(_value);
236         totalDistributed = totalDistributed.sub(_value);
237         emit Burn(_burner, _value);
238     }
239 }