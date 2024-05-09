1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     
43   address public owner;
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     require(newOwner != address(0));      
67     owner = newOwner;
68   }
69 
70 }
71 
72 contract Token {
73   function totalSupply() constant public returns (uint256 supply);
74 
75   function balanceOf(address _owner) constant public returns (uint256 balance);
76   function transfer(address _to, uint256 _value) public  returns (bool success) ;
77   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) ;
78   function approve(address _spender, uint256 _value) public  returns (bool success) ;
79   function allowance(address _owner, address _spender) constant public  returns (uint256 remaining) ;
80 
81   event Transfer(address indexed _from, address indexed _to, uint256 _value);
82   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 
84   uint public decimals;
85   string public name;
86 }
87 
88 /**
89  * @title Crowdsale
90  * @dev Crowdsale is a base contract for managing a token crowdsale.
91  * Crowdsales have a start and end timestamps, where Contributors can make
92  * token Contributions and the crowdsale will assign them tokens based
93  * on a token per ETH rate. Funds collected are forwarded to a wallet
94  * as they arrive. The contract requires a MintableToken that will be
95  * minted as contributions arrive, note that the crowdsale contract
96  * must be owner of the token in order to be able to mint it.
97  */
98 contract Crowdsale is Ownable {
99   using SafeMath for uint256;
100   // totalTokens
101   uint256 public totalTokens;
102   // soft cap
103   uint softcap;
104   // hard cap
105   uint hardcap;  
106   Token public token;
107   // balances for softcap
108   mapping(address => uint) public balances;
109   // balances for softcap
110   mapping(address => uint) public balancesToken;  
111   // The token being offered
112 
113   // start and end timestamps where investments are allowed (both inclusive)
114   
115   //pre-sale
116     //start
117   uint256 public startPreSale;
118     //end
119   uint256 public endPreSale;
120 
121   //ico
122     //start
123   uint256 public startIco;
124     //end 
125   uint256 public endIco;    
126 
127   //token distribution
128   uint256 public maxPreSale;
129   uint256 public maxIco;
130 
131   uint256 public totalPreSale;
132   uint256 public totalIco;
133   
134   // how many token units a Contributor gets per wei
135   uint256 public ratePreSale;
136   uint256 public rateIco;   
137 
138   // address where funds are collected
139   address public wallet;
140 
141   // minimum quantity values
142   uint256 public minQuanValues; 
143   uint256 public maxQuanValues; 
144 
145 /**
146 * event for token Procurement logging
147 * @param contributor who Pledged for the tokens
148 * @param beneficiary who got the tokens
149 * @param value weis Contributed for Procurement
150 * @param amount amount of tokens Procured
151 */
152   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
153   function Crowdsale() public {
154     
155     //soft cap
156     softcap = 5000 * 1 ether; 
157     hardcap = 20000 * 1 ether;  	
158     // min quantity values
159     minQuanValues = 100000000000000000; //0.1 eth
160     // max quantity values
161     maxQuanValues = 27 * 1 ether; //    
162     // start and end timestamps where investments are allowed
163     //Pre-sale
164       //start
165     startPreSale = 1523260800;//09 Apr 2018 08:00:00 +0000
166       //end
167     endPreSale = 1525507200;//05 May 2018 08:00:00 +0000
168   
169     //ico
170       //start
171     startIco = 1525507200;//05 May 2018 08:00:00 +0000
172       //end 
173     endIco = startIco + 6 * 7 * 1 days;   
174 
175     // rate;
176     ratePreSale = 382;
177     rateIco = 191; 
178     
179     // restrictions on amounts during the crowdfunding event stages
180     maxPreSale = 30000000 * 1 ether;
181     maxIco =     60000000 * 1 ether;    
182     
183     // address where funds are collected
184     wallet = 0x04cFbFa64917070d7AEECd20225782240E8976dc;
185   }
186 
187   function setratePreSale(uint _ratePreSale) public onlyOwner  {
188     ratePreSale = _ratePreSale;
189   }
190  
191   function setrateIco(uint _rateIco) public onlyOwner  {
192     rateIco = _rateIco;
193   }   
194   
195 
196 
197   // fallback function can be used to Procure tokens
198   function () external payable {
199     procureTokens(msg.sender);
200   }
201   
202   function setToken(address _address) public onlyOwner {
203       token = Token(_address);
204   }
205     
206   // low level token Pledge function
207   function procureTokens(address beneficiary) public payable {
208     uint256 tokens;
209     uint256 weiAmount = msg.value;
210     uint256 backAmount;
211     require(beneficiary != address(0));
212     //minimum amount in ETH
213     require(weiAmount >= minQuanValues);
214     //maximum amount in ETH
215     require(weiAmount.add(balances[msg.sender]) <= maxQuanValues);    
216     //hard cap
217     address _this = this;
218     require(hardcap > _this.balance);
219 
220     //Pre-sale
221     if (now >= startPreSale && now < endPreSale && totalPreSale < maxPreSale){
222       tokens = weiAmount.mul(ratePreSale);
223 	  if (maxPreSale.sub(totalPreSale) <= tokens){
224 	    endPreSale = now;
225 	    startIco = now;
226 	    endIco = startIco + 6 * 7 * 1 days; 
227 	  }
228       if (maxPreSale.sub(totalPreSale) < tokens){
229         tokens = maxPreSale.sub(totalPreSale); 
230         weiAmount = tokens.div(ratePreSale);
231         backAmount = msg.value.sub(weiAmount);
232       }
233       totalPreSale = totalPreSale.add(tokens);
234     }
235        
236     //ico   
237     if (now >= startIco && now < endIco && totalIco < maxIco){
238       tokens = weiAmount.mul(rateIco);
239       if (maxIco.sub(totalIco) < tokens){
240         tokens = maxIco.sub(totalIco); 
241         weiAmount = tokens.div(rateIco);
242         backAmount = msg.value.sub(weiAmount);
243       }
244       totalIco = totalIco.add(tokens);
245     }        
246 
247     require(tokens > 0);
248     balances[msg.sender] = balances[msg.sender].add(msg.value);
249     balancesToken[msg.sender] = balancesToken[msg.sender].add(tokens);
250     
251     if (backAmount > 0){
252       msg.sender.transfer(backAmount);    
253     }
254     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
255   }
256   function getToken() public{
257     address _this = this;
258     require(_this.balance >= softcap && now > endIco); 
259     uint value = balancesToken[msg.sender];
260     balancesToken[msg.sender] = 0;
261     token.transfer(msg.sender, value);
262   }
263   
264   function refund() public{
265     address _this = this;
266     require(_this.balance < softcap && now > endIco);
267     require(balances[msg.sender] > 0);
268     uint value = balances[msg.sender];
269     balances[msg.sender] = 0;
270     msg.sender.transfer(value);
271   }
272   
273   function transferTokenToMultisig(address _address) public onlyOwner {
274     address _this = this;
275     require(_this.balance >= softcap && now > endIco);  
276     token.transfer(_address, token.balanceOf(_this));
277   }   
278   
279   function transferEthToMultisig() public onlyOwner {
280     address _this = this;
281     require(_this.balance >= softcap && now > endIco);  
282     wallet.transfer(_this.balance);
283   }  
284 }