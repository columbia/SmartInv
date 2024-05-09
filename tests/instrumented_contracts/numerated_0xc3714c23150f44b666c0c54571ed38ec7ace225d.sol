1 pragma solidity ^0.4.24;
2 
3 /*** @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */
5 library SafeMath {
6   
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15   
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a / b;
18   }
19   
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface ERC20 {
33   function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
34   function burn(uint256 _value) external returns (bool);
35   function allowance(address _owner, address _spender) external returns (uint256);
36   function transferFrom(address from, address to, uint256 value) external returns (bool);
37   function balanceOf(address who) external  returns (uint256);
38 }
39 
40 /**
41  * @title Ownable
42  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol */
43 contract Ownable {
44   address public owner;
45   
46   constructor() public {
47     owner = msg.sender;
48   }
49   
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 }
55 
56 contract Buyback is Ownable{
57     
58   using SafeMath for uint;    
59   
60   // ERC20 standard interface
61   ERC20 public token;
62   
63   address public tokenPreSale;
64   address public tokenMainSale;
65 
66   address public backEndOperator = msg.sender;
67   
68   // Price 
69   uint256 public buyPrice; // 1 USD
70   
71   uint256 public dollarPrice;
72     
73   // Amount of ether on the contract
74   uint256 public totalFundsAvailable;
75   
76   uint256 public startBuyBackOne = 1639526400; // Wednesday, 15 December 2021 г., 0:00:00 Start Buyback for InvestTypeOne
77   
78   uint256 public startBuyBackTwo = 1734220800; // Sunday, 15 December 2024 г., 0:00:00 Start Buyback for InvestTypeTwo
79   
80   uint256 public percentBuyBackTypeTwo = 67;
81  
82   // This creates an array of invest type one addresses
83   mapping (address => bool) public investTypeOne;
84   
85   // This creates an array of invest type two addresses
86   mapping (address => bool) public investTypeTwo;
87   
88   // This creates an array of balance payble token in ICO period
89   mapping (address => uint256) public balancesICOToken;
90   
91   
92   modifier backEnd() {
93     require(msg.sender == backEndOperator || msg.sender == owner);
94     _;
95   }
96   
97   modifier onlyICO() {
98     require(msg.sender == tokenPreSale || msg.sender == tokenMainSale);
99 	_;
100   }
101 	
102   constructor(ERC20 _token,  address _tokenPreSale, address _tokenMainSale, uint256 usdETH) public {
103     token = _token;
104     tokenPreSale = _tokenPreSale;
105     tokenMainSale = _tokenMainSale;
106     dollarPrice = usdETH;
107     buyPrice = (1e18/dollarPrice); // 1 usd
108   }
109   
110   
111   
112   /*******************************************************************************
113    * Setter's section */
114   
115   function setBuyPrice(uint256 _dollar) public onlyOwner {
116     dollarPrice = _dollar;
117     buyPrice = (1e18/dollarPrice); // 1 usd
118   }
119   
120   function setBackEndAddress(address newBackEndOperator) public onlyOwner {
121     backEndOperator = newBackEndOperator;
122   }
123   function setPercentTypeTwo(uint256 newPercent) public onlyOwner {
124     percentBuyBackTypeTwo = newPercent;
125   }
126   
127   function setstartBuyBackOne(uint256 newstartBuyBackOne) public onlyOwner {
128     startBuyBackOne = newstartBuyBackOne;
129   }
130   
131   function setstartBuyBackTwo(uint256 newstartBuyBackTwo) public onlyOwner {
132     startBuyBackTwo = newstartBuyBackTwo;
133   }
134  
135   //once the set typeInvest
136   function setInvestTypeOne(address _investor) public backEnd{
137       require(_investor != address(0x0));
138       require(!isInvestTypeOne(_investor));
139       require(!isInvestTypeTwo(_investor));
140       investTypeOne[_investor] = true;
141   }
142   
143   //once the set typeInvest
144   function setInvestTypeTwo(address _investor) public backEnd{
145       require(_investor != address(0x0));
146       require(!isInvestTypeOne(_investor));
147       require(!isInvestTypeTwo(_investor));
148       investTypeTwo[_investor] = true;
149   }
150   
151    function setPreSaleAddres(address _tokenPreSale) public onlyOwner{
152       tokenPreSale = _tokenPreSale;
153    }
154       
155   /*******************************************************************************
156    * For Require's section */
157    
158    function isInvestTypeOne(address _investor) internal view returns(bool) {
159     return investTypeOne[_investor];
160   }
161  
162   function isInvestTypeTwo(address _investor) internal view returns(bool) {
163     return investTypeTwo[_investor];
164   }
165      
166    function isBuyBackOne() public constant returns(bool) {
167     return now >= startBuyBackOne;
168   }
169   
170    function isBuyBackTwo() public constant returns(bool) {
171     return now >= startBuyBackTwo;
172   }
173   
174   /*******************************************************************************/
175   
176    function buyTokenICO(address _investor, uint256 _value) onlyICO public returns (bool) {
177       balancesICOToken[_investor] = balancesICOToken[_investor].add(_value);
178       return true;
179     }
180      
181     
182   /*
183    *  Fallback function.
184    *  Stores sent ether.
185    */
186   function () public payable {
187     totalFundsAvailable = totalFundsAvailable.add(msg.value);
188   }
189 
190 
191   /*
192    *  Exchange tokens for ether. Invest type one
193    */
194   function buybackTypeOne() public {
195         uint256 allowanceToken = token.allowance(msg.sender,this);
196         require(allowanceToken != uint256(0));
197         require(isInvestTypeOne(msg.sender));
198         require(isBuyBackOne());
199         require(balancesICOToken[msg.sender] >= allowanceToken);
200         
201         uint256 forTransfer = allowanceToken.mul(buyPrice).div(1e18).mul(3); //calculation Eth 100% in 3 year 
202         require(totalFundsAvailable >= forTransfer);
203         msg.sender.transfer(forTransfer);
204         totalFundsAvailable = totalFundsAvailable.sub(forTransfer);
205         
206         balancesICOToken[msg.sender] = balancesICOToken[msg.sender].sub(allowanceToken);
207         token.transferFrom(msg.sender, this, allowanceToken);
208    }
209    
210    /*
211    *  Exchange tokens for ether. Invest type two
212    */
213   function buybackTypeTwo() public {
214         uint256 allowanceToken = token.allowance(msg.sender,this);
215         require(allowanceToken != uint256(0));
216         require(isInvestTypeTwo(msg.sender));
217         require(isBuyBackTwo());
218         require(balancesICOToken[msg.sender] >= allowanceToken);
219         
220         uint256 accumulated = percentBuyBackTypeTwo.mul(allowanceToken).div(100).mul(5).add(allowanceToken); // ~ 67%  of tokens purchased in 5 year
221         uint256 forTransfer = accumulated.mul(buyPrice).div(1e18); //calculation Eth 
222         require(totalFundsAvailable >= forTransfer);
223         msg.sender.transfer(forTransfer);
224         totalFundsAvailable = totalFundsAvailable.sub(forTransfer);
225         
226         balancesICOToken[msg.sender] = balancesICOToken[msg.sender].sub(allowanceToken);
227         token.transferFrom(msg.sender, this, allowanceToken);
228    }
229    
230 }