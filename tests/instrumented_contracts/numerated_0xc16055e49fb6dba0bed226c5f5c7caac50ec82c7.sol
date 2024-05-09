1 pragma solidity ^0.4.0;
2 
3 contract CrypteloERC20{
4   mapping (address => uint256) public balanceOf;
5   function transfer(address to, uint amount);
6   function burn(uint256 _value) public returns (bool success);
7 }
8 
9 contract CrypteloPreSale{
10   function isWhiteList(address _addr) public returns (uint _group);
11 }
12 
13 contract TadamWhitelistPublicSale{
14     function isWhiteListed(address _addr) returns (uint _group);
15     mapping (address => uint) public PublicSaleWhiteListed;
16 }
17 
18 contract CrypteloPublicSale{
19     using SafeMath for uint256;
20     mapping (address => bool) private owner;
21 
22     
23     uint public contributorCounter = 0;
24     mapping (uint => address) contributor;
25     mapping (address => uint) contributorAmount;
26     
27     /*
28         Public Sale Timings and bonuses
29     */
30     
31     
32     uint ICOstartTime = 0; 
33     uint ICOendTime = now + 30 days;
34     
35     //first 7 days bonus 25%
36     uint firstDiscountStartTime = ICOstartTime;
37     uint firstDiscountEndTime = ICOstartTime + 7 days;
38     
39     //day 7 to day 14 bonus 20%
40     uint secDiscountStartTime = ICOstartTime + 7 days;
41     uint secDiscountEndTime = ICOstartTime + 14 days;
42     
43     //day 14 to day 21 bonus 15%
44     uint thirdDiscountStartTime = ICOstartTime + 14 days;
45     uint thirdDiscountEndTime = ICOstartTime + 21 days;
46     
47     //day 21 to day 28 bonus 10%
48     uint fourthDiscountStartTime = ICOstartTime + 21 days;
49     uint fourthDiscountEndTime = ICOstartTime + 28 days;
50 
51     /*
52         External addresses
53     */
54     address public ERC20Address; 
55     address public preSaleContract;
56     address private forwardFundsWallet;
57     address public whiteListAddress;
58     
59     event eSendTokens(address _addr, uint _amount);
60     event eStateChange(bool state);
61     event eLog(string str, uint no);
62     event eWhiteList(address adr, uint group);
63     
64     function calculateBonus(uint _whiteListLevel) returns (uint _totalBonus){
65         uint timeBonus = currentTimeBonus();
66         uint totalBonus = 0;
67         uint whiteListBonus = 0;
68         if (_whiteListLevel == 1){
69             whiteListBonus = whiteListBonus.add(5);
70         }
71         totalBonus = totalBonus.add(timeBonus).add(whiteListBonus);
72         return totalBonus;
73     }
74     function currentTimeBonus () public returns (uint _bonus){
75         uint bonus = 0;
76         //ICO is running
77         if (now >= firstDiscountStartTime && now <= firstDiscountEndTime){
78             bonus = 25;
79         }else if(now >= secDiscountStartTime && now <= secDiscountEndTime){
80             bonus = 20;
81         }else if(now >= thirdDiscountStartTime && now <= thirdDiscountEndTime){
82             bonus = 15;
83         }else if(now >= fourthDiscountStartTime && now <= fourthDiscountEndTime){
84             bonus = 10;
85         }else{
86             bonus = 5;
87         }
88         return bonus;
89     }
90     
91     function CrypteloPublicSale(address _ERC20Address, address _preSaleContract, address _forwardFundsWallet, address _whiteListAddress ){
92         owner[msg.sender] = true;
93         ERC20Address = _ERC20Address;
94         preSaleContract = _preSaleContract;
95         forwardFundsWallet = _forwardFundsWallet;
96         whiteListAddress = _whiteListAddress;    
97     }
98     /*
99         States are
100             false - Paused - it doesn't accept payments
101             true - Live - accepts payments and disburse tokens if conditions meet
102     */
103     bool public currentState = false;
104 
105     
106     /*
107         Financial Ratios 
108     */
109     uint hardCapTokens = addDecimals(8,187500000);
110     uint raisedWei = 0;
111     uint tokensLeft = hardCapTokens;
112     uint reservedTokens = 0;
113     uint minimumDonationWei = 100000000000000000;
114     uint public tokensPerEther = addDecimals(8, 12500); //1250000000000
115     uint public tokensPerMicroEther = tokensPerEther.div(1000000);
116     
117     function () payable {
118 
119         uint tokensToSend = 0;
120         uint amountEthWei = msg.value;
121         address sender = msg.sender;
122         
123         //check if its live
124         
125         require(currentState);
126         eLog("state OK", 0);
127         require(amountEthWei >= minimumDonationWei);
128         eLog("amount OK", amountEthWei);
129         
130         uint whiteListedLevel = isWhiteListed(sender);
131         require( whiteListedLevel > 0);
132 
133         tokensToSend = calculateTokensToSend(amountEthWei, whiteListedLevel);
134         
135         require(tokensLeft >= tokensToSend);
136         eLog("tokens left vs tokens to send ok", tokensLeft);    
137         eLog("tokensToSend", tokensToSend);
138         
139         //test for minus
140         if (tokensToSend <= tokensLeft){
141             tokensLeft = tokensLeft.sub(tokensToSend);    
142         }
143         
144         addContributor(sender, tokensToSend);
145         reservedTokens = reservedTokens.add(tokensToSend);
146         eLog("send tokens ok", 0);
147         
148         forwardFunds(amountEthWei);
149         eLog("forward funds ok", amountEthWei);
150     }
151     
152     function  calculateTokensToSend(uint _amount_wei, uint _whiteListLevel) public returns (uint _tokensToSend){
153         uint tokensToSend = 0;
154         uint amountMicroEther = _amount_wei.div(1000000000000);
155         uint tokens = amountMicroEther.mul(tokensPerMicroEther);
156         
157         eLog("tokens: ", tokens);
158         uint bonusPerc = calculateBonus(_whiteListLevel); 
159         uint bonusTokens = 0;
160         if (bonusPerc > 0){
161             bonusTokens = tokens.div(100).mul(bonusPerc);    
162         }
163         eLog("bonusTokens", bonusTokens); 
164         
165         tokensToSend = tokens.add(bonusTokens);
166 
167         eLog("tokensToSend", tokensToSend);  
168         return tokensToSend;
169     }
170     
171     function payContributorByNumber(uint _n) onlyOwner{
172         require(now > ICOendTime);
173         
174         address adr = contributor[_n];
175         uint amount = contributorAmount[adr];
176         sendTokens(adr, amount);
177         contributorAmount[adr] = 0;
178     }
179     
180     function payContributorByAdress(address _adr) {
181         require(now > ICOendTime);
182         uint amount = contributorAmount[_adr];
183         sendTokens(_adr, amount);
184         contributorAmount[_adr] = 0;
185     }
186     
187     function addContributor(address _addr, uint _amount) private{
188         contributor[contributorCounter] = _addr;
189         if (contributorAmount[_addr] > 0){
190             contributorAmount[_addr] += _amount;
191         }else{
192             contributorAmount[_addr] = _amount;    
193         }
194         
195         contributorCounter++;
196     }
197     function getContributorByAddress(address _addr) constant returns (uint _amount){
198         return contributorAmount[_addr];
199     }
200     
201     function getContributorByNumber(uint _n) constant returns (address _adr, uint _amount){
202         address contribAdr = contributor[_n];
203         uint amount = contributorAmount[contribAdr];
204         return (contribAdr, amount);
205         
206     }
207     
208     function forwardFunds(uint _amountEthWei) private{
209         raisedWei += _amountEthWei;
210         forwardFundsWallet.transfer(_amountEthWei);  //find balance
211     }
212     
213     function sendTokens(address _to, uint _amountCRL) private{
214         //invoke call on token address
215        CrypteloERC20 _tadamerc20;
216         _tadamerc20 = CrypteloERC20(ERC20Address);
217         _tadamerc20.transfer(_to, _amountCRL);
218         eSendTokens(_to, _amountCRL);
219     }
220     
221     function setCurrentState(bool _state) public onlyOwner {
222         currentState = _state;
223         eStateChange(_state);
224     } 
225     
226     function burnAllTokens() public onlyOwner{
227         CrypteloERC20 _tadamerc20;
228         _tadamerc20 = CrypteloERC20(ERC20Address);
229         uint tokensToBurn = _tadamerc20.balanceOf(this);
230         require (tokensToBurn > reservedTokens);
231         tokensToBurn -= reservedTokens;
232         eLog("tokens burned", tokensToBurn);
233         _tadamerc20.burn(tokensToBurn);
234     }
235     
236     function isWhiteListed(address _address) returns (uint){
237         
238         /*
239             return values :
240             0 = not whitelisted at all,
241             1 = white listed early (pre sale or before 15th of March)
242             2 = white listed after 15th of March
243         */
244         uint256 whiteListedStatus = 0;
245         
246         TadamWhitelistPublicSale whitelistPublic;
247         whitelistPublic = TadamWhitelistPublicSale(whiteListAddress);
248         
249         uint256 PSaleGroup = whitelistPublic.PublicSaleWhiteListed(_address);
250         //if we have it in the PublicSale add it
251         if (PSaleGroup > 0){
252             whiteListedStatus = PSaleGroup;
253         }else{
254             CrypteloPreSale _testPreSale;
255             _testPreSale = CrypteloPreSale(preSaleContract);
256             if (_testPreSale.isWhiteList(_address) > 0){
257                 //exists in the pre-sale white list threfore give em early 1
258                 whiteListedStatus = 1;
259             }else{
260                 //not found on either
261                 whiteListedStatus = 0;
262             }
263         }
264         eWhiteList(_address, whiteListedStatus);
265         return whiteListedStatus;
266     }
267     
268     function addDecimals(uint _noDecimals, uint _toNumber) private returns (uint _finalNo) {
269         uint finalNo = _toNumber * (10 ** _noDecimals);
270         return finalNo;
271     }
272     
273     function withdrawAllTokens() public onlyOwner{
274         CrypteloERC20 _tadamerc20;
275         _tadamerc20 = CrypteloERC20(ERC20Address);
276         uint totalAmount = _tadamerc20.balanceOf(this);
277         require(totalAmount > reservedTokens);
278         uint toWithdraw = totalAmount.sub(reservedTokens);
279         sendTokens(msg.sender, toWithdraw);
280     }
281     
282     function withdrawAllEther() public onlyOwner{
283         msg.sender.send(this.balance);
284     }
285      
286     modifier onlyOwner(){
287         require(owner[msg.sender]);
288         _;
289     }
290     
291 }
292 
293 /**
294  * @title SafeMath
295  * @dev Math operations with safety checks that throw on error
296  */
297 library SafeMath {
298 
299   /**
300   * @dev Multiplies two numbers, throws on overflow.
301   */
302   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
303     if (a == 0) {
304       return 0;
305     }
306     uint256 c = a * b;
307     assert(c / a == b);
308     return c;
309   }
310 
311   /**
312   * @dev Integer division of two numbers, truncating the quotient.
313   */
314   function div(uint256 a, uint256 b) internal pure returns (uint256) {
315     // assert(b > 0); // Solidity automatically throws when dividing by 0
316     uint256 c = a / b;
317     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
318     return c;
319   }
320 
321   /**
322   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
323   */
324   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
325     assert(b <= a);
326     return a - b;
327   }
328 
329   /**
330   * @dev Adds two numbers, throws on overflow.
331   */
332   function add(uint256 a, uint256 b) internal pure returns (uint256) {
333     uint256 c = a + b;
334     assert(c >= a);
335     return c;
336   }
337 }