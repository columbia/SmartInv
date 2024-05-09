1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 
86 //Abstract contract for Calling ERC20 contract
87 contract AbstractCon {
88     function allowance(address _owner, address _spender)  public pure returns (uint256 remaining);
89     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
90     function decimals() public returns (uint8);
91     //function approve(address _spender, uint256 _value) public returns (bool); //test
92     //function transfer(address _to, uint256 _value) public returns (bool); //test
93     
94 }
95 
96 //...
97 contract EXOTokenSale is Ownable {
98     using SafeMath for uint256;
99 
100     string public constant name = "EXO_TOKEN_SALE";
101 
102     ///////////////////////
103     // DATA STRUCTURES  ///
104     ///////////////////////
105     enum StageName {Pause, PreSale, Sale, Ended, Refund}
106     struct StageProperties {
107         uint256 planEndDate;
108         address tokenKeeper;
109     }
110     
111     StageName public currentStage;
112     mapping(uint8   => StageProperties) public campaignStages;
113     mapping(address => uint256)         public deposited;
114     
115     uint256 public weiRaised=0; //All raised ether
116     uint256 public token_rate=1600; // decimal part of token per wei (0.3$ if 480$==1ETH)
117     uint256 public minimum_token_sell=1000; // !!! token count - without decimals!!!
118     uint256 public softCap=1042*10**18;//    500 000$ if 480$==1ETH
119     uint256 public hardCap=52083*10**18;//25 000 000$ if 480$==1ETH
120     address public wallet ; 
121     address public ERC20address;
122 
123     ///////////////////////
124     /// EVENTS     ///////
125     //////////////////////
126     event Income(address from, uint256 amount, uint64 timestamp);
127     event NewTokenRate(uint256 rate);
128     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weivalue, uint256 tokens);
129     event FundsWithdraw(address indexed who, uint256 amount , uint64 timestamp);
130     event Refunded(address investor, uint256 depositedValue);
131     
132     //20180501 = 1525132800
133     //20180901 = 1535760000
134     //20181231 = 1546214400
135 
136     function EXOTokenSale(address _wallet, address _preSaleTokenKeeper , address _SaleTokenKeeper) public {
137         //costructor
138         require(_wallet != address(0));
139         wallet = _wallet;
140         campaignStages[uint8(StageName.PreSale)] = StageProperties(1525132800, _preSaleTokenKeeper);
141         campaignStages[uint8(StageName.Sale)]    = StageProperties(1535760000, _SaleTokenKeeper);
142         currentStage = StageName.Pause;
143     }
144 
145     //For disable transfers from incompatible wallet (Coinbase) 
146     // or from a non ERC-20 compatible wallet
147     //it may be purposefully comment this fallback function and recieve
148     // Ether  direct through exchangeEtherOnTokens()
149     function() public payable {
150         exchangeEtherOnTokens(msg.sender);
151     }
152 
153         // low level token purchase function
154     function exchangeEtherOnTokens(address beneficiary) public payable  {
155         emit Income(msg.sender, msg.value, uint64(now));
156         require(currentStage == StageName.PreSale || currentStage == StageName.Sale);
157         uint256 weiAmount = msg.value; //local
158         uint256 tokens = getTokenAmount(weiAmount);
159         require(beneficiary != address(0));
160         require(token_rate > 0);//implicit enabling sell
161         AbstractCon ac = AbstractCon(ERC20address);
162         require(tokens >= minimum_token_sell.mul(10 ** uint256(ac.decimals())));
163         require(ac.transferFrom(campaignStages[uint8(currentStage)].tokenKeeper, beneficiary, tokens));
164         checkCurrentStage();
165         weiRaised = weiRaised.add(weiAmount);
166         deposited[beneficiary] = deposited[beneficiary].add(weiAmount);
167         emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
168         if (weiRaised >= softCap) 
169             withdrawETH();
170     }
171 
172     //Stage time and conditions control
173     function checkCurrentStage() internal {
174         if  (campaignStages[uint8(currentStage)].planEndDate <= now) {
175             // Allow refund if softCap is not reached during PreSale stage
176             if  (currentStage == StageName.PreSale 
177                  && (weiRaised + msg.value) < softCap
178                 ) {
179                     currentStage = StageName.Refund;
180                     return;
181             }
182             currentStage = StageName.Pause;
183         }
184         //Finish tokensale campaign when hardCap will reached
185         if (currentStage == StageName.Sale 
186             && (weiRaised + msg.value) >= hardCap
187             ) { 
188                currentStage = StageName.Ended;
189         }
190     }
191 
192     //for all discount logic
193     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
194         return weiAmount.mul(token_rate);
195     }
196 
197     function withdrawETH() internal {
198         emit FundsWithdraw(wallet, this.balance, uint64(now));
199         wallet.transfer(this.balance);// or weiAmount
200     }
201 
202     //Set current stage of campaign manually
203     function setCurrentStage(StageName _name) external onlyOwner  {
204         currentStage = _name;
205     }
206 
207     //Manually stages control
208     function setStageProperties(
209         StageName _name, 
210         uint256 _planEndDate, 
211         address _tokenKeeper 
212         ) external onlyOwner {
213         campaignStages[uint8(_name)] = StageProperties(_planEndDate, _tokenKeeper);
214     } 
215 
216     //set   erc20 address for token process  with check of allowance 
217     function setERC20address(address newERC20contract)  external onlyOwner {
218         require(address(newERC20contract) != 0);
219         AbstractCon ac = AbstractCon(newERC20contract);
220         require(ac.allowance(campaignStages[uint8(currentStage)].tokenKeeper, address(this))>0);
221         ERC20address = newERC20contract;
222     }
223     
224     //refund if not softCapped
225     function refund(address investor) external {
226         require(currentStage == StageName.Refund);
227         require(investor != address(0));
228         assert(msg.data.length >= 32 + 4);  //Short Address Attack
229         uint256 depositedValue = deposited[investor];
230         deposited[investor] = 0;
231         investor.transfer(depositedValue);
232         emit Refunded(investor, depositedValue);
233     }
234 
235     function setTokenRate(uint256 newRate) external onlyOwner {
236         token_rate = newRate;
237         emit NewTokenRate(newRate);
238     }
239 
240     function setSoftCap(uint256 _val) external onlyOwner {
241         softCap = _val;
242     }
243 
244     function setHardCap(uint256 _val) external onlyOwner {
245         hardCap = _val;
246     }
247 
248 
249     function setMinimumTokenSell(uint256 newNumber) external onlyOwner {
250         minimum_token_sell = newNumber;
251     }
252 
253     function setWallet(address _wallet) external onlyOwner {
254         wallet = _wallet;
255     } 
256 
257     function destroy()  external onlyOwner {
258       if  (weiRaised >= softCap)
259           selfdestruct(owner);
260   } 
261 
262 }              
263 //***************************************************************
264   // Designed by by IBERGroup, email:maxsizmobile@iber.group; 
265   //     Telegram: https://t.me/msmobile
266   //               https://t.me/alexamuek
267   // Code released under the MIT License(see git root).
268   //// SafeMath and Ownable part of this contract based on 
269   //// https://github.com/OpenZeppelin/zeppelin-solidity
270   ////**************************************************************