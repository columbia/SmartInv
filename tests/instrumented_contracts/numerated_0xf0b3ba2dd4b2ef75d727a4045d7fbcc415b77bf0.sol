1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9     assert(b <= a);
10     return a - b;
11   }
12 
13   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     c = a + b;
15     assert(c >= a);
16     return c;
17   }
18   
19 }
20 
21 // ERC Token Standard #20 Interface
22 // https://github.com/ethereum/EIPs/issues/20
23 
24 interface ERC20Interface {
25 
26 	//Get the totalSupply of the token.
27 	function totalSupply() external constant returns (uint256);
28 	
29 	// Get the account balance of another account with address _owner
30 	function balanceOf(address _owner) external constant returns (uint256 balance);
31 
32 	// Send _value amount of tokens to address _to
33 	function transfer(address _to, uint256 _value) external returns (bool success);
34 
35 	// Send _value amount of tokens from address _from to address _to
36 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
37 
38 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
39 	// If this function is called again it overwrites the current allowance with _value.
40 	// this function is required for some DEX functionality
41 	function approve(address _spender, uint256 _value) external returns (bool success);
42 
43 	// Returns the amount which _spender is still allowed to withdraw from _owner
44 	function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
45 
46 	// Triggered when tokens are transferred.
47 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
48 
49 	// Triggered whenever approve(address _spender, uint256 _value) is called.
50 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 contract STTInterface is ERC20Interface {
54     function BuyTokens () external payable returns (uint256 AtokenBought);
55           event Mint(address indexed _to, uint256 amount);
56 
57     function SellTokens (uint256 SellAmount) external payable returns (uint256 EtherPaid);
58     function split() external returns (bool success);
59     event Split(uint256 factor);
60    
61     function getReserve() external constant returns (uint256);
62     function burn(uint256 _value) external returns (bool success);
63      event Burn(address indexed _burner, uint256 value);
64     
65 }
66 
67 contract AToken is STTInterface {
68    
69    using SafeMath for uint256;
70    
71    //ERC20 stuff
72    
73    	// ************************************************************************
74 	//
75 	// Constructor and initializer
76 	//
77 	// ************************************************************************	
78 
79    
80    uint256 public _totalSupply = 10000000000000000000000;
81    string public name = "A-Token";
82    string public symbol = "A";
83    uint8 public constant decimals = 18;
84    
85    mapping(address => uint256) public balances;
86    mapping(address => mapping (address => uint256)) public allowed;
87    
88    //Arry and map for the split.
89     address[] private tokenHolders;
90 	mapping(address => bool) private tokenHoldersMap;
91    
92    
93    //Constructor
94 	
95 	constructor() public {
96 	    balances[msg.sender] = _totalSupply;
97 	    tokenHolders.push(msg.sender);
98 	    tokenHoldersMap[msg.sender] = true;
99 
100 	}
101    
102     //*************************************************************************
103 	//
104 	// Methods for all states
105 	//
106 	// ************************************************************************	
107 
108 	// ERC20 stuff
109 
110 	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
111 	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);  
112    
113    function balanceOf(address _addr) external constant returns(uint256 balance) {
114 
115 		return balances[_addr];
116 	}
117 	
118 	function transfer(address _to, uint256 _amount) external returns(bool success) {
119 
120 		require(_amount > 0);
121 		require(_amount <= balances[msg.sender]);
122 		require (_to != address(0));
123 		
124 		balances[msg.sender] = balances[msg.sender].sub(_amount);
125 		balances[_to] = balances[_to].add(_amount);
126 		
127 		if(tokenHoldersMap[_to] != true) {
128 			tokenHolders.push(_to);
129 			tokenHoldersMap[_to] = true;
130 		}
131 
132 		emit Transfer(msg.sender, _to, _amount);
133 
134 		return true;
135 	}
136 	
137 	function transferFrom(address _from, address _to, uint256 _amount) external returns(bool success) {
138 
139 		require(_from != address(0));
140 		require(_to != address (0));
141 		require(_amount > 0);
142 		require(_amount <= balances[_from]);
143 		require(_amount <= allowed[_from][msg.sender]);
144 
145 		balances[_from] = balances[_from].sub(_amount);
146 		balances[_to] = balances[_to].add(_amount);
147 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
148 		
149 		if(tokenHoldersMap[_to] != true) {
150 			tokenHolders.push(_to);
151 			tokenHoldersMap[_to] = true;
152 		}
153 		
154 		emit Transfer(_from, _to, _amount);
155 
156 		return true;
157  	}
158  	
159  	function approve(address _spender, uint256 _amount) external returns(bool success) {
160 
161 		require(_spender != address(0));
162 		require(_amount > 0);
163 		require(_amount <= balances[msg.sender]);
164         allowed[msg.sender][_spender] = _amount;
165 	
166 		emit Approval(msg.sender, _spender, _amount);
167 
168 		return true;
169  	}
170  	
171  	function allowance(address _owner, address _spender) external constant returns(uint256 remaining) {
172 
173 		require(_owner != address(0));
174 		require(_spender != address(0));
175 
176 		return allowed[_owner][_spender];
177  	}
178 		
179 	function totalSupply() external constant returns (uint) {
180         return _totalSupply  - balances[address(0)];
181     }
182 	
183 	
184 // Self tradable functions
185      event Mint(address indexed _to, uint256 amount);
186      event Split(uint256 factor);
187      event Burn(address indexed _burner, uint256 value);
188 
189 
190     function BuyTokens () external payable returns ( uint256 AtokenBought) {
191      
192        
193         address thisAddress = this;
194 
195 
196         //checking minimum buy - twice the price
197         uint256 Aprice = (thisAddress.balance - msg.value) * 4*2* 1000000000000000000/_totalSupply;
198         require (msg.value>=Aprice);
199         
200         //calculating the formula
201         
202         AtokenBought = (thisAddress.balance -206000)* 1000000000000000000/ (thisAddress.balance-msg.value);
203         uint256 x = (1000000000000000000 + AtokenBought)/2;
204        x = (x + (AtokenBought * 1000000000000000000/x))/2;
205        x = (x + (AtokenBought * 1000000000000000000/x))/2;
206        x = (x + (AtokenBought * 1000000000000000000/x))/2; 
207        x = (x + (AtokenBought * 1000000000000000000/x))/2;
208        x = (x + (AtokenBought * 1000000000000000000/x))/2;
209        
210        AtokenBought=x; 
211        x = (1000000000000000000 + AtokenBought)/2;
212        x = (x + (AtokenBought * 1000000000000000000/x))/2;
213        x = (x + (AtokenBought * 1000000000000000000/x))/2;
214        x = (x + (AtokenBought * 1000000000000000000/x))/2;
215        x = (x + (AtokenBought * 1000000000000000000/x))/2;
216        x = (x + (AtokenBought * 1000000000000000000/x))/2;
217           
218        AtokenBought=x;
219        
220         AtokenBought -=1000000000000000000;
221        
222         AtokenBought = AtokenBought * _totalSupply/1000000000000000000;
223        
224         //checking the outcome
225         uint256 check1=(msg.value-206000)*_totalSupply/(thisAddress.balance-msg.value)/4;
226         require(check1>=AtokenBought);
227         
228         //doing the buy
229         _totalSupply +=AtokenBought;
230         balances[msg.sender] += AtokenBought;
231         if(tokenHoldersMap[msg.sender] != true) {
232         tokenHolders.push(msg.sender);
233 	    tokenHoldersMap[msg.sender] = true;
234 	   	}
235 	    emit Mint(msg.sender, AtokenBought);
236         emit Transfer(address(0), msg.sender, AtokenBought);
237 
238         return AtokenBought;
239         
240         }
241 
242 
243 
244     function SellTokens (uint256 SellAmount) external payable returns (uint256 EtherPaid) {
245         
246         //re-entry defense
247         bool locked;
248         require(!locked);
249         locked = true;
250 
251        //first check amount is equal or higher than 1 token
252         require(SellAmount>=1000000000000000000);
253        
254         //calculating the formula
255         require(msg.value>=206000);
256         
257         //Never going down from 300 tokens.
258         require((_totalSupply-SellAmount)>=300000000000000000000);
259         require(balances[(msg.sender)]>=SellAmount);
260         address thisAddress = this;
261         EtherPaid = (_totalSupply -SellAmount)*1000000000000000000/_totalSupply;
262         EtherPaid=1000000000000000000-(((EtherPaid**2/1000000000000000000)*(EtherPaid**2/1000000000000000000))/1000000000000000000);
263         EtherPaid=(EtherPaid*(thisAddress.balance-msg.value))*9/10000000000000000000;
264         //checking the calculation
265         uint256 check1=SellAmount*(thisAddress.balance-msg.value)*36/_totalSupply/10;
266         require(check1>EtherPaid);
267         require(EtherPaid<(thisAddress.balance-msg.value));
268         
269         //paying the ether
270         balances[msg.sender] -= SellAmount;
271         _totalSupply-=SellAmount;
272         
273         
274          emit Burn(msg.sender, SellAmount);
275          emit Transfer(msg.sender, address(0), SellAmount);
276        
277        msg.sender.transfer(EtherPaid);
278        
279          locked=false;
280 
281         return EtherPaid;
282             }
283 
284     //split function to lower the price.
285     
286     function split() external returns (bool success){
287         address thisContracrt = this;
288 
289         //calculating the factor
290         
291         uint256 factor = thisContracrt.balance * 4 * 10/_totalSupply;
292     require (factor > 10);
293         factor *= 10;    
294     
295     for(uint index = 0; index < tokenHolders.length; index++) {
296 				balances[tokenHolders[(index)]] *=factor ;
297 								
298 				}
299 		_totalSupply *=factor;
300 		emit Split(factor);
301 		return true;
302 			}		
303 
304 //get reserve information
305 function getReserve() external constant returns (uint256){
306     address thissmart=this;
307     return thissmart.balance;
308 }
309 
310 
311 
312 // Burn function
313 
314   function burn(uint256 _value) external returns (bool success){
315     
316     require(_value > 0);
317     require(_value <= balances[msg.sender]);
318     require(_totalSupply-_value>=300000000000000000000);
319     balances[msg.sender] = balances[msg.sender].sub(_value);
320     _totalSupply = _totalSupply.sub(_value);
321     emit Burn(msg.sender, _value);
322     emit Transfer(msg.sender, address(0), _value);
323     return true;
324   }
325 
326 //FallBack function
327 
328 function () public payable {}
329 }