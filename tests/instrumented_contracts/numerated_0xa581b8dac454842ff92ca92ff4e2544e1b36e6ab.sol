1 //* International Exchange
2 
3 //* What is the International Exchange?
4 //* The market’s most usable, compliant, and secure cryptocurrency exchange platform. *
5 
6 ////* Road Map International Exchange *
7 
8 //1. Create Smart Contract <11/11/2018>
9 ////                       2. Airdrop Open <11/11/2018 - 12/12/2018> 
10 ////                   * > How to join airdrop International Exchange < *
11 ////*                     ( Send 0 Eth to Contract) you get 500000 IEX 
12 ////*       > Send more 0 eth get big bonus> Price 10Billion per ETH > End 12/12/2018 <
13 
14 //3. Launch Website and Exchange < Feb 12,2019 >
15 //4. Added CoinMarketCap and CoinGecko
16 //5. List on more Exchange.
17 ////> Target IEX list on Exchange <
18   // > 1. Binance < 2. Poloniex > < 3. Mercatox > < 4. IDEX > < 5. Hotbit > < 6. Huobi >
19  //6. Target Price $1 per token 
20  
21 //* What is IEX ?
22 //* IEX is a new cryptocurrency exchange platform designed to provide a customizable,
23 //tailor-made interface for traders of all experience levels. For newer investors, our exchange brings 
24 //simplicity of a complex ecosystem, allowing users to confidently participate in the booming digital
25 //currency market.For experienced users who value speed, advanced trading capabilities, innovative 
26 //features, and a customized user experience, our exchange provides market leading security and 
27 //exclusive cutting-edge features.By leveraging the power of blockchain technology used by popular 
28 //cryptocurrency exchanges we’ve developed an ecosystem which facilitates the exchange autonomously
29 //while providing enhanced security and liquidity features. 
30 
31 pragma solidity ^0.4.18;
32 
33 library SafeMath {
34     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35         if (a == 0) {
36             return 0;
37         }
38         c = a * b;
39         assert(c / a == b);
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a / b;
44     }
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract AltcoinToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract Exchange is ERC20 {
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;    
82 	mapping (address => bool) public blacklist;
83 
84     string public constant name = "International Exchange";						
85     string public constant symbol = "IEX";							
86     uint public constant decimals = 18;    							
87     uint256 public totalSupply = 441090009888e18;		
88 	
89 	uint256 public tokenPerETH = 10000000000e18;
90 	uint256 public valueToGive = 500000e18;
91     uint256 public totalDistributed = 0;       
92 	uint256 public totalRemaining = totalSupply.sub(totalDistributed);	
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     event Distr(address indexed to, uint256 amount);
98     event DistrFinished();
99     
100     event Burn(address indexed burner, uint256 value);
101 
102     bool public distributionFinished = false;
103     
104     modifier canDistr() {
105         require(!distributionFinished);
106         _;
107     }
108     
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113     
114     function Exchange () public {
115         owner = msg.sender;
116 		uint256 teamtoken = 1000000000e18;	
117         distr(owner, teamtoken);
118     }
119     
120     function transferOwnership(address newOwner) onlyOwner public {
121         if (newOwner != address(0)) {
122             owner = newOwner;
123         }
124     }
125 
126     function finishDistribution() onlyOwner canDistr public returns (bool) {
127         distributionFinished = true;
128         emit DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);   
134 		totalRemaining = totalRemaining.sub(_amount);		
135         balances[_to] = balances[_to].add(_amount);
136         emit Distr(_to, _amount);
137         emit Transfer(address(0), _to, _amount);
138 
139         return true;
140     }
141            
142     function () external payable {
143 		address investor = msg.sender;
144 		uint256 invest = msg.value;
145         
146 		if(invest == 0){
147 			require(valueToGive <= totalRemaining);
148 			require(blacklist[investor] == false);
149 			
150 			uint256 toGive = valueToGive;
151 			distr(investor, toGive);
152 			
153             blacklist[investor] = true;
154         
155 			valueToGive = valueToGive.div(1000000).mul(999999);
156 		}
157 		
158 		if(invest > 0){
159 			buyToken(investor, invest);
160 		}
161 	}
162 	
163 	function buyToken(address _investor, uint256 _invest) canDistr public {
164 		uint256 toGive = tokenPerETH.mul(_invest) / 1 ether;
165 		uint256	bonus = 0;
166 		
167 		if(_invest >= 1 ether/100 && _invest < 1 ether/10){ //if 0,01
168 			bonus = toGive*10/100;
169 		}		
170 		if(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1
171 			bonus = toGive*20/100;
172 		}		
173 		if(_invest >= 1 ether){ //if 1
174 			bonus = toGive*50/100;
175 		}		
176 		toGive = toGive.add(bonus);
177 		
178 		require(toGive <= totalRemaining);
179 		
180 		distr(_investor, toGive);
181 	}
182     
183     function balanceOf(address _owner) constant public returns (uint256) {
184         return balances[_owner];
185     }
186 
187     modifier onlyPayloadSize(uint size) {
188         assert(msg.data.length >= size + 4);
189         _;
190     }
191     
192     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
193 
194         require(_to != address(0));
195         require(_amount <= balances[msg.sender]);
196         
197         balances[msg.sender] = balances[msg.sender].sub(_amount);
198         balances[_to] = balances[_to].add(_amount);
199         emit Transfer(msg.sender, _to, _amount);
200         return true;
201     }
202     
203     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
204 
205         require(_to != address(0));
206         require(_amount <= balances[_from]);
207         require(_amount <= allowed[_from][msg.sender]);
208         
209         balances[_from] = balances[_from].sub(_amount);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
211         balances[_to] = balances[_to].add(_amount);
212         emit Transfer(_from, _to, _amount);
213         return true;
214     }
215     
216     function approve(address _spender, uint256 _value) public returns (bool success) {
217         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
218         allowed[msg.sender][_spender] = _value;
219         emit Approval(msg.sender, _spender, _value);
220         return true;
221     }
222     
223     function allowance(address _owner, address _spender) constant public returns (uint256) {
224         return allowed[_owner][_spender];
225     }
226     
227     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
228         AltcoinToken t = AltcoinToken(tokenAddress);
229         uint bal = t.balanceOf(who);
230         return bal;
231     }
232     
233     function withdraw() onlyOwner public {
234         address myAddress = this;
235         uint256 etherBalance = myAddress.balance;
236         owner.transfer(etherBalance);
237     }
238     
239     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
240         AltcoinToken token = AltcoinToken(_tokenContract);
241         uint256 amount = token.balanceOf(address(this));
242         return token.transfer(owner, amount);
243     }
244 	
245 	function burn(uint256 _value) onlyOwner public {
246         require(_value <= balances[msg.sender]);
247         
248         address burner = msg.sender;
249         balances[burner] = balances[burner].sub(_value);
250         totalSupply = totalSupply.sub(_value);
251         totalDistributed = totalDistributed.sub(_value);
252         emit Burn(burner, _value);
253     }
254 	
255 	function burnFrom(uint256 _value, address _burner) onlyOwner public {
256         require(_value <= balances[_burner]);
257         
258         balances[_burner] = balances[_burner].sub(_value);
259         totalSupply = totalSupply.sub(_value);
260         totalDistributed = totalDistributed.sub(_value);
261         emit Burn(_burner, _value);
262     }
263 }