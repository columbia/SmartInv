1 //* NSBox Token 
2 //* Send 0 ETH to Claim NSBox Token
3 //* Get Bonus if you send minimum 0.01 ETH
4 
5 //* Stable Token *
6 
7 
8 
9 pragma solidity ^0.4.18;
10 
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a / b;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract AltcoinToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47     function allowance(address owner, address spender) public constant returns (uint256);
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49     function approve(address spender, uint256 value) public returns (bool);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 contract NSBox is ERC20 {
54     
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;    
60 	mapping (address => bool) public blacklist;
61 
62     string public constant name = "NSBox Token";						
63     string public constant symbol = "NSB";							
64     uint public constant decimals = 18;    							
65     uint256 public totalSupply = 5981510001e18;		
66 	
67 	uint256 public tokenPerETH = 50000000e18;
68 	uint256 public valueToGive = 25000e18;
69     uint256 public totalDistributed = 0;       
70 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     
75     event Distr(address indexed to, uint256 amount);
76     event DistrFinished();
77     
78     event Burn(address indexed burner, uint256 value);
79 
80     bool public distributionFinished = false;
81     
82     modifier canDistr() {
83         require(!distributionFinished);
84         _;
85     }
86     
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91     
92     function NSBox () public {
93         owner = msg.sender;
94 		uint256 teamtoken = 598151000e18;	
95         distr(owner, teamtoken);
96     }
97     
98     function transferOwnership(address newOwner) onlyOwner public {
99         if (newOwner != address(0)) {
100             owner = newOwner;
101         }
102     }
103 
104     function finishDistribution() onlyOwner canDistr public returns (bool) {
105         distributionFinished = true;
106         emit DistrFinished();
107         return true;
108     }
109     
110     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
111         totalDistributed = totalDistributed.add(_amount);   
112 		totalRemaining = totalRemaining.sub(_amount);		
113         balances[_to] = balances[_to].add(_amount);
114         emit Distr(_to, _amount);
115         emit Transfer(address(0), _to, _amount);
116 
117         return true;
118     }
119            
120     function () external payable {
121 		address investor = msg.sender;
122 		uint256 invest = msg.value;
123         
124 		if(invest == 0){
125 			require(valueToGive <= totalRemaining);
126 			require(blacklist[investor] == false);
127 			
128 			uint256 toGive = valueToGive;
129 			distr(investor, toGive);
130 			
131             blacklist[investor] = true;
132         
133 			valueToGive = valueToGive.div(1000000).mul(999999);
134 		}
135 		
136 		if(invest > 0){
137 			buyToken(investor, invest);
138 		}
139 	}
140 	
141 	function buyToken(address _investor, uint256 _invest) canDistr public {
142 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
143 		uint256	bonus = 0;
144 		
145 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
146 			bonus = toGive*20/100;
147 		}		
148 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
149 			bonus = toGive*40/100;
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
241 }