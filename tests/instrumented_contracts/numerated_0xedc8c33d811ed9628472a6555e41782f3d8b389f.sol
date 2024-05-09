1 /*
2 1. All rights to the smart contract, the PGCT tokens and the receipts are owned by the Golden Currency Group. 
3 
4 2. The PGCT token is a transitional token of the crowdfunding campaign. 
5 Token is not a security and does not provide any profit payment for its owners or any rights similar to shareholders rights. 
6 The PGCT Token is to be exchanged for the future Golden Currency token, 
7 which will be released as part of the main round of the ICO campaign. 
8 Future Golden Currency token is planned to become a security token, providing additional incentives for project contributors (like dividends and buyback), 
9 yet it will be realized only in case all legal procedures are fulfilled, 
10 Golden Currency Group does not ensure it becoming a security token and disclaims all liability relating thereto. 
11 
12 3. The PGCT-future Golden Currency token exchange procedure will include the mandatory KYC process, 
13 the exchange will be refused for those who do not pass the KYC procedure. 
14 The exchange will be refused for residents of countries who are legally prohibited from participating in such crowdfunding campaigns.
15 */
16 
17 pragma solidity ^0.4.21;
18 
19 contract ERC20Basic {
20   function totalSupply() public view returns (uint256);
21   function balanceOf(address who) public view returns (uint256);
22   function transfer(address to, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25  
26 library SafeMath {
27 
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a / b;
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52  
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58   mapping(address => bool   ) isInvestor;
59   address[] public arrInvestors;
60   
61   uint256 totalSupply_;
62 
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   function addInvestor(address _newInvestor) internal {
68     if (!isInvestor[_newInvestor]){
69        isInvestor[_newInvestor] = true;
70        arrInvestors.push(_newInvestor);
71     }  
72       
73   }
74     function getInvestorsCount() public view returns(uint256) {
75         return arrInvestors.length;
76         
77     }
78 
79 /*
80 minimun one token to transfer
81 or only all rest
82 */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     if (balances[msg.sender] >= 1 ether){
85         require(_value >= 1 ether);     // minimun one token to transfer
86     } else {
87         require(_value == balances[msg.sender]); //only all rest
88     }
89     
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     addInvestor(_to);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100 
101     function transferToken(address _to, uint256 _value) public returns (bool) {
102         return transfer(_to, _value.mul(1 ether));
103     }
104 
105 
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112  
113 
114 contract BurnableToken is BasicToken {
115 
116   event Burn(address indexed burner, uint256 value);
117 
118   function burn(uint256 _value) public {
119     _burn(msg.sender, _value);
120   }
121 
122   function _burn(address _who, uint256 _value) internal {
123     require(_value <= balances[_who]);
124     balances[_who] = balances[_who].sub(_value);
125     totalSupply_ = totalSupply_.sub(_value);
126     emit Burn(_who, _value);
127     emit Transfer(_who, address(0), _value);
128   }
129 }
130 
131 
132 contract GoldenCurrencyToken is BurnableToken {
133   string public constant name = "Pre-ICO Golden Currency Token";
134   string public constant symbol = "PGCT";
135   uint32 public constant decimals = 18;
136   uint256 public INITIAL_SUPPLY = 7600000 * 1 ether;
137 
138   function GoldenCurrencyToken() public {
139     totalSupply_ = INITIAL_SUPPLY;
140     balances[msg.sender] = INITIAL_SUPPLY;      
141   }
142 }
143   
144 
145  contract Ownable {
146   address public owner;
147   address candidate;
148   address public manager1;
149   address public manager2;
150 
151   function Ownable() public {
152     owner = msg.sender;
153     manager1 = msg.sender;
154     manager2 = msg.sender;
155   }
156 
157   modifier onlyOwner() {
158     require(msg.sender == owner || msg.sender == manager1 || msg.sender == manager2);
159     _;
160   }
161 
162 
163   function transferOwnership(address newOwner) public onlyOwner {
164     require(newOwner != address(0));
165     candidate = newOwner;
166   }
167 
168   function confirmOwnership() public {
169     require(candidate == msg.sender);
170     owner = candidate;
171     delete candidate;
172   }
173 
174   function transferManagment1(address newManager) public onlyOwner {
175     require(newManager != address(0));
176     manager1 = newManager;
177   }
178 
179   function transferManagment2(address newManager) public onlyOwner {
180     require(newManager != address(0));
181     manager2 = newManager;
182   }
183 }
184 
185 
186 contract Crowdsale is Ownable {
187   using SafeMath for uint;    
188   address myAddress = this;    
189 
190     address public profitOwner = 0x0; //address of the recipient of the contract funds
191     uint public  tokenRate = 500;
192     uint start = 1523450379;        //      StartTime 16.04.2018 - 1523836800
193     uint finish = 1531785599;       //      FinishTime  16.07.2018 23:59 - 1531785599
194     uint256 period1 = 1523836800;   //      16 April 00:00 - 1523836800
195     uint256 period2 = 1525132800;   //      1 May 00:00     - 1525132800
196     uint256 period3 = 1527811200;   //      1 June 00:00    - 1527811200
197   
198   event TokenRates(uint256 indexed value);
199 
200   GoldenCurrencyToken public token = new GoldenCurrencyToken();
201   
202     modifier saleIsOn() {
203         require(now > start && now < finish);
204         _;
205     }
206 
207     function setProfitOwner (address _newProfitOwner) public onlyOwner {
208         require(_newProfitOwner != address(0));
209         profitOwner = _newProfitOwner;
210     }
211 
212     function saleTokens(address _newInvestor, uint256 _value) public saleIsOn onlyOwner payable {
213         // the function of selling tokens to new investors
214         // the sum is entered in whole tokens (1 = 1 token)
215         require (_newInvestor!= address(0));
216         require (_value >= 1);
217         _value = _value.mul(1 ether);
218         token.transfer(_newInvestor, _value);
219     }  
220     
221 
222     function createTokens() saleIsOn internal {
223 
224     require(profitOwner != address(0));
225     uint tokens = tokenRate.mul(msg.value);
226     require (tokens.div(1 ether) >= 100);  //minimum 100 tokens purchase
227 
228     profitOwner.transfer(msg.value);
229     
230     uint bonusTokens = 0;
231         /*
232         25% bonus from 16 to 30 April 2018
233         20% bonus from May 1 to May 31, 2018
234         15% bonus from June 1 to July 16, 2018
235         */
236 
237 
238 
239     if(now < period2) {
240       bonusTokens = tokens.div(4);
241     } else if(now >= period2 && now < period3) {
242       bonusTokens = tokens.div(5);
243     } else if(now >= period3 && now < finish) {
244       bonusTokens = tokens.div(100).mul(15);
245     }
246 
247     uint tokensWithBonus = tokens.add(bonusTokens);
248     token.transfer(msg.sender, tokensWithBonus);
249   }
250  
251  
252    function setTokenRate(uint newRate) public onlyOwner {
253       tokenRate = newRate;
254       emit TokenRates(newRate);
255   }
256    
257   function changePeriods(uint256 _start, uint256 _period1, uint256 _period2, uint256 _period3, uint256 _finish) public onlyOwner {
258     start = _start;
259     finish = _finish;
260     period1 = _period1;
261     period2 = _period2;
262     period3 = _period3;
263   }
264   
265  
266   function() external payable {
267     createTokens();
268   }    
269  
270 }