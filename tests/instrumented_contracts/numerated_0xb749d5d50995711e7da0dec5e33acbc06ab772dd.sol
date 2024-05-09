1 pragma solidity ^0.4.24;
2 // This is based on https://github.com/OpenZeppelin/openzeppelin-solidity.
3 // We announced each .sol file and omitted the verbose comments.
4 // Gas limit : 3,000,000
5 
6 library SafeMath {                             //SafeMath.sol
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) { return 0; }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract QurozToken { // pulbic functions of Token
31   function transfer(address _to, uint256 _value) public returns (bool) {}
32 }
33 
34 contract QforaSale {
35   using SafeMath for uint256;                         //RefundableCrowdsale.sol
36   uint256 public goal;                                //RefundableCrowdsale.sol, goal of wei
37   uint256 public rate;                                //Crowdsale.sol, Token = wei * rate
38   uint256 public openingTime;                         //TimedCrowdsale.sol
39   uint256 public closingTime;                         //TimedCrowdsale.sol
40   uint256 public weiRaised;                           //Crowdsale.sol
41   uint256 public tokenSold;          //new
42   uint256 public threshold;          //new
43   uint256 public hardCap;            //new
44   uint256 public bonusRate;          // new, 20 means 20% 
45   address public wallet;                              //RefundVault.sol
46   address public owner;                               //Ownable.sol
47   bool public isFinalized;                     //FinalizableCrowdsale.sol
48   mapping(address => uint256) public balances;       //PostDeliveryCrowdsale.sol, info for withdraw
49   mapping(address => uint256) public deposited;      //RefundVault.sol,           info for refund
50   mapping(address => bool) public whitelist;          //WhitelistedCrowdsale.sol
51   enum State { Active, Refunding, Closed }            //RefundVault.sol
52   State public state;                                 //RefundVault.sol
53   QurozToken public token;
54 
55   event Closed();                                     //RefundVault.sol
56   event RefundsEnabled();                             //RefundVault.sol
57   event Refunded(address indexed beneficiary, uint256 weiAmount);   //RefundVault.sol
58   event Finalized();                                      //FinalizableCrowdsale.sol
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);  //Ownable.sol
60   event TokenPurchase(address indexed purchaser,address indexed beneficiary,uint256 value,uint256 amount); //Crowdsale
61 
62   constructor(address _wallet, QurozToken _token) public {
63     require(_wallet != address(0) && _token != address(0));
64     owner = msg.sender;
65     wallet = _wallet;
66     token = _token;
67     goal = 5000e18;
68     rate = 10000;
69     threshold = 100e18;
70     hardCap = 50000e18;
71     bonusRate = 20;
72     openingTime = now.add(0 minutes);
73     closingTime = openingTime.add(22 days + 5 hours + 30 minutes);
74     require(block.timestamp <= openingTime && openingTime <= closingTime);
75   }
76 
77   modifier onlyOwner() {require(msg.sender == owner); _;}            //Ownable.sol
78   modifier isWhitelisted(address _beneficiary) {require(whitelist[_beneficiary]); _;}  //WhitelistedCrowdsale.sol
79 
80   function addToWhitelist(address _beneficiary) public onlyOwner {      //WhitelistedCrowdsale.sol (external to public)
81     whitelist[_beneficiary] = true;
82   }
83 
84   function addManyToWhitelist(address[] _beneficiaries) public onlyOwner { //WhitelistedCrowdsale.sol (external to public)
85     for (uint256 i = 0; i < _beneficiaries.length; i++) {
86       whitelist[_beneficiaries[i]] = true;
87     }
88   }
89 
90   function removeFromWhitelist(address _beneficiary) public onlyOwner { //WhitelistedCrowdsale.sol (external to public)
91     whitelist[_beneficiary] = false;
92   }
93 
94   function () external payable {                                            //Crowdsale.sol
95     require(openingTime <= block.timestamp && block.timestamp <= closingTime);      // new
96     require(whitelist[msg.sender]);        // new
97     require(msg.value >= threshold );      // new
98     require(weiRaised.add(msg.value) <= hardCap );      // new
99     buyTokens(msg.sender);
100   }
101 
102   function buyTokens(address _beneficiary) public payable {                           //Crowdsale.sol
103     uint256 weiAmount = msg.value;
104     _preValidatePurchase(_beneficiary, weiAmount);
105     uint256 tokens = _getTokenAmount(weiAmount);
106     uint256 totalTokens = tokens.mul(100 + bonusRate).div(100);
107     weiRaised = weiRaised.add(weiAmount);
108     tokenSold = tokenSold.add(totalTokens);          // new
109     _processPurchase(_beneficiary, totalTokens);     // changed parameter to totalTokens
110     deposit(_beneficiary, msg.value);           // new
111     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
112 //    _updatePurchasingState(_beneficiary, weiAmount);
113 //    _forwardFunds();                                // masking for refund
114 //    _postValidatePurchase(_beneficiary, weiAmount);
115   }
116 
117   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {    
118       //Crowdsale.sol, WhitelistedCrowdsale.sol
119     require(_beneficiary != address(0));
120     require(_weiAmount != 0);
121   }
122 
123   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {        //Crowdsale.sol
124     return _weiAmount.mul(rate);
125   }
126 
127   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {      //PostDeliveryCrowdsale.sol
128 //    _deliverTokens(_beneficiary, _tokenAmount);  //Crowdsale.sol
129     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);  // new
130 
131   }
132 
133   function hasClosed() public view returns (bool) {               //TimedCrowdsale.sol
134     return block.timestamp > closingTime;
135   }
136 
137   function deposit(address investor, uint256 value) internal {  //RefundVault.sol (liternal, no payable, add value)
138     require(state == State.Active);
139     deposited[investor] = deposited[investor].add(value);
140   }
141 
142   function goalReached() public view returns (bool) {    //RefundableCrowdsale.sol
143     return weiRaised >= goal;
144   }
145 
146   function finalize() onlyOwner public {          //FinalizableCrowdsale.sol
147     require(!isFinalized);
148     require(hasClosed());   // finalizing after timeout
149     finalization();
150     emit Finalized();
151     isFinalized = true;
152   }
153 
154   function finalization() internal {                     //RefundableCrowdsale.sol (change state)
155     if (goalReached()) { close(); } 
156     else               { enableRefunds(); }
157     //super.finalization();
158   }
159 
160   function close() onlyOwner public {   //RefundVault.sol (Active -> Closed if goal reached)
161     require(state == State.Active);
162     state = State.Closed;
163     emit Closed();
164     wallet.transfer(address(this).balance);
165   }
166 
167   function enableRefunds() onlyOwner public { //RefundVault.sol (Active -> Refunding if goal not reached)
168     require(state == State.Active);
169     state = State.Refunding;
170     emit RefundsEnabled();
171   }
172 
173   function claimRefund() public {                         //RefundableCrowdsale.sol
174     require(isFinalized);
175     require(!goalReached());
176     refund(msg.sender);
177   }
178 
179   function refund(address investor) public {       //RefundVault.sol
180     require(state == State.Refunding);
181     require(deposited[investor] > 0);                                                                   // new     
182     uint256 depositedValue = deposited[investor];
183     balances[investor] = 0;                                                                             // new
184     deposited[investor] = 0;
185     investor.transfer(depositedValue);
186     emit Refunded(investor, depositedValue);
187   }
188 
189   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {       //Crowdsale.sol
190     token.transfer(_beneficiary, _tokenAmount);
191   }
192 
193   function withdrawTokens() public {                              //PostDeliveryCrowdsale.sol
194     require(hasClosed());
195     uint256 amount = balances[msg.sender];
196     require(amount > 0);
197     balances[msg.sender] = 0;
198     _deliverTokens(msg.sender, amount);
199     deposited[msg.sender] = 0;                        //new
200   }
201 
202   function transferOwnership(address _newOwner) public onlyOwner { //Ownable.sol
203     _transferOwnership(_newOwner);
204   }
205 
206   function _transferOwnership(address _newOwner) internal {       //Ownable.sol
207     require(_newOwner != address(0));
208     emit OwnershipTransferred(owner, _newOwner);
209     owner = _newOwner;
210   }
211     
212   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
213     selfdestruct(_recipient);
214   }
215 
216 /* new functions */
217   function transferToken(address to, uint256 value) onlyOwner public { 
218     token.transfer(to, value);
219   }
220   
221   function setBonusRate(uint256 _bonusRate) public onlyOwner{
222     _setBonusRate(_bonusRate);
223   }
224 
225   function _setBonusRate(uint256 _bonusRate) internal {
226     bonusRate = _bonusRate;
227   }
228   
229   function getBalanceOf(address investor) public view returns(uint256) {
230     return balances[investor];
231   }
232 
233   function getDepositedOf(address investor) public view returns(uint256) {
234     return deposited[investor];
235   }
236 
237   function getWeiRaised() public view returns(uint256) {
238     return weiRaised;
239   }
240 
241   function getTokenSold() public view returns(uint256) {
242     return tokenSold;
243   }
244 
245   function addSmallInvestor(address _beneficiary, uint256 weiAmount, uint256 totalTokens) public onlyOwner {
246     require(whitelist[_beneficiary]);
247     require(weiAmount >= 1 ether );
248     require(weiRaised.add(weiAmount) <= hardCap );
249     weiRaised = weiRaised.add(weiAmount);
250     tokenSold = tokenSold.add(totalTokens);
251     _processPurchase(_beneficiary, totalTokens);
252     //deposit(_beneficiary, weiAmount);       // ether was input to wallet address, so no deposit
253   }
254 
255 }