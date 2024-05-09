1 pragma solidity ^0.4.25;
2 
3 
4 contract ErcInterface {
5     function transferFrom(address _from, address _to, uint256 _value) public;
6     function transfer(address _to, uint256 _value) public;
7     function balanceOf(address _who) public returns(uint256);
8 }
9 
10 contract Ownable {
11     
12     address public owner;
13 
14     /**
15      * The address whcih deploys this contrcat is automatically assgined ownership.
16      * */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * Functions with this modifier can only be executed by the owner of the contract. 
23      * */
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     event OwnershipTransferred(address indexed from, address indexed to);
30 
31     /**
32     * Transfers ownership to new Ethereum address. This function can only be called by the 
33     * owner.
34     * @param _newOwner the address to be granted ownership.
35     **/
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != 0x0);
38         emit OwnershipTransferred(owner, _newOwner);
39         owner = _newOwner;
40     }
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, reverts on overflow.
51   */
52   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (_a == 0) {
57       return 0;
58     }
59 
60     uint256 c = _a * _b;
61     require(c / _a == _b);
62 
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
68   */
69   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
70     require(_b > 0); // Solidity only automatically asserts when dividing by 0
71     uint256 c = _a / _b;
72     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
73 
74     return c;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     require(_b <= _a);
82     uint256 c = _a - _b;
83 
84     return c;
85   }
86 
87   /**
88   * @dev Adds two numbers, reverts on overflow.
89   */
90   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     uint256 c = _a + _b;
92     require(c >= _a);
93 
94     return c;
95   }
96 
97   /**
98   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
99   * reverts when dividing by zero.
100   */
101   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102     require(b != 0);
103     return a % b;
104   }
105 }
106 
107 
108 
109 
110 contract FOXTWidget is Ownable {
111     
112     using SafeMath for uint256;
113     
114     ErcInterface public constant FOXT = ErcInterface(0xFbe878CED08132bd8396988671b450793C44bC12); 
115     
116     bool public contractFrozen;
117     
118     uint256 private rate;
119     uint256 private purchaseTimeLimit;
120     uint256 private txFee;
121 
122     mapping (address => uint256) private purchaseDeadlines;
123     mapping (address => uint256) private maxPurchase;
124     mapping (address => bool) private isBotAddress;
125     
126     
127     address[] private botsOwedTxFees;
128     uint256 private indexOfOwedTxFees;
129     
130     event TokensPurchased(address indexed by, address indexed recipient, uint256 total, uint256 value);
131     event RateUpdated(uint256 latestRate);
132     
133     constructor() public {
134         purchaseTimeLimit = 10 minutes;
135         txFee = 300e14; //same as 0.03 ETH.
136         contractFrozen = false;
137         indexOfOwedTxFees = 0;
138     }
139     
140     
141     /**
142      * Allows the owner to freeze / unfreeze the contract 
143      * */
144     function toggleFreeze() public onlyOwner {
145         contractFrozen = !contractFrozen;
146     }
147     
148     
149     /**
150      * Allows the owner of the contract to add a bot address
151      * */
152     function addBotAddress(address _botAddress) public onlyOwner {
153         require(!isBotAddress[_botAddress]);
154         isBotAddress[_botAddress] = true;
155     }
156     
157     
158     /**
159      * Allows the owner of the contract to remove a bot address 
160      */
161     function removeBotAddress(address _botAddress) public onlyOwner  {
162         require(isBotAddress[_botAddress]);
163         isBotAddress[_botAddress] = false;
164     }
165     
166     
167     /**
168      * Allows the owner to change the time limit which buyers will have once they
169      * have been permitted to buy tokens with the contract update. 
170      * 
171      * @param _newPurchaseTimeLimit The new time limit which buyers will have to 
172      * make a purchase. 
173      * 
174      * @return true if the function exeutes successfully, false otherwise
175      * */
176     function changeTimeLimitMinutes(uint256 _newPurchaseTimeLimit) public onlyOwner returns(bool) {
177         require(_newPurchaseTimeLimit > 0 && _newPurchaseTimeLimit != purchaseTimeLimit);
178         purchaseTimeLimit = _newPurchaseTimeLimit;
179         return true;
180     }
181     
182     
183     /**
184      * Allows the owner to change the fixed transaction fee which will be charged 
185      * to the buyers. 
186      * 
187      * @param _newTxFee The new transaction fee which will be charged to the buyers. 
188      * 
189      * @return true if the function exeutes successfully, false otherwise
190      * */
191     function changeTxFee(uint256 _newTxFee) public onlyOwner returns(bool) {
192         require(_newTxFee != txFee);
193         txFee = _newTxFee;
194         return true;
195     }
196     
197     
198     /**
199      * Functions with this modifier can only be invoked by either one of the bot  
200      * addresses or the owner of the contract. 
201      * */
202     modifier restricted {
203         require(isBotAddress[msg.sender] || msg.sender == owner);
204         _;
205     }
206     
207     
208     /**
209      * Allows the bot or the owner of the contract to update the contract (will 
210      * usuall by invoked right before a buyer will make a purchase). 
211      * 
212      * @param _rate The rate at which the FOXT tokens are shwon on Coin Market Cap.
213      * @param _purchaser The address of the buyer.
214      * @param _ethInvestment The total amoun of ETH the buyer has specified he 
215      * or she will send to the contract. 
216      * 
217      * @return true if the function exeutes successfully, false otherwise
218      * */
219     function updateContract(uint256 _rate, address _purchaser, uint256 _ethInvestment) public restricted returns(bool){
220         require(!contractFrozen);
221         require(_purchaser != address(0x0));
222         require(_ethInvestment > 0);
223         require(_rate != 0);
224         if(_rate != rate) {
225             rate = _rate;
226         }
227         maxPurchase[_purchaser] = _ethInvestment;
228         purchaseDeadlines[_purchaser] = now.add(purchaseTimeLimit);
229         botsOwedTxFees.push(msg.sender);
230         emit RateUpdated(rate);
231         return true;
232     }
233     
234     
235     /**
236      * @return The purchaseTimeLimit
237      * */
238     function getTimePurchase() public view returns(uint256) {
239         return purchaseTimeLimit;
240     }
241     
242         /**
243      * @return The current rate shown on Coin Market Cap. 
244      * */
245     function getRate() public view returns(uint256) {
246         return rate;
247     }
248     
249     
250     
251     /**
252      * Checks if a purchaser is permitted to make a purchase by checking 
253      * the following conditions. 1st condition is that the bot updated the contract 
254      * with the purcahser's address no longer than the purchase deadline ago. 2nd 
255      * condition is that the purchaser is allowed to make an investment which is 
256      * greater than 0. 
257      * 
258      * @return true if the purchaser is permitted to make a purchase, false 
259      * otherwise.
260      * */
261     function addrCanPurchase(address _purchaser) public view returns(bool) {
262         return now < purchaseDeadlines[_purchaser] && maxPurchase[_purchaser] > 0;
263     }
264     
265 
266     /**
267      * Allows users to buy FOXT tokens. For the function to execute successfully
268      * the following conditions must be met: 1st the purchaser must purcahse the 
269      * tokens before the time limit is up (time limit is set when the bot updates
270      * the contract). 2nd the purchaser must send at least enough ETH to cover the 
271      * txFee to cover the cost of the update, however, if the purchaser sends more 
272      * ETH than specified in the update, the purchaser will still get FOXT tokens 
273      * but also the remaining ETH will be refunded. 
274      * 
275      * @param _purchaser The address of the buyer
276      * 
277      * @return true if the function exeutes successfully, false otherwise
278      * */
279     function buyTokens(address _purchaser) public payable returns(bool){
280         require(!contractFrozen);
281         require(addrCanPurchase(_purchaser));
282         require(msg.value > txFee);
283         uint256 msgVal = msg.value;
284         if(msgVal > maxPurchase[_purchaser]) {
285             msg.sender.transfer(msg.value.sub(maxPurchase[_purchaser]));
286             msgVal = maxPurchase[_purchaser];
287         }
288         maxPurchase[_purchaser] = 0;
289         msgVal = msgVal.sub(txFee);
290         botsOwedTxFees[indexOfOwedTxFees].transfer(txFee);
291         indexOfOwedTxFees = indexOfOwedTxFees.add(1);
292         uint256 toSend = msgVal.mul(rate);
293         FOXT.transfer(_purchaser, toSend);
294         emit TokensPurchased(msg.sender, _purchaser, toSend, msg.value);
295     }
296     
297     
298     /**
299      * Fallback function invokes the buyTokens function. 
300      * */
301     function() public payable {
302         buyTokens(msg.sender);
303     }
304     
305     
306     /**
307      * Allows the owner of the contract to withdraw all ETH.
308      * */
309     function withdrawETH() public onlyOwner {
310         owner.transfer(address(this).balance);
311     }
312     
313     
314     /**
315      * Allows the owner of the contract to withdraw FOXT tokens.
316      * 
317      * @param _recipient The address of the receiver.
318      * @param _totalTokens The number of FOXT tokens to send. 
319      * */
320     function withdrawFoxt(address _recipient, uint256 _totalTokens) public onlyOwner {
321         FOXT.transfer(_recipient, _totalTokens);
322     }
323     
324     
325     /**
326      * Allows the owner of the contract to withdraw any ERC20 token.
327      * 
328      * @param _tokenAddr The contract address of the ERC20 token.
329      * @param _recipient The address of the receiver.
330      * @param _totalTokens The number of tokens to send
331      * */
332     function withdrawAnyERC20(address _tokenAddr, address _recipient, uint256 _totalTokens) public onlyOwner {
333         ErcInterface token = ErcInterface(_tokenAddr);
334         token.transfer(_recipient, _totalTokens);
335     }
336     
337 }