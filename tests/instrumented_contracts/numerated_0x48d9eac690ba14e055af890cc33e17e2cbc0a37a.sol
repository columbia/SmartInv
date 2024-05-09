1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint tokens) public returns (bool success);
7   function approve(address spender, uint tokens) public returns (bool success);
8   function transferFrom(address from, address to, uint tokens) public returns (bool success);
9 
10   event Transfer(address indexed from, address indexed to, uint tokens);
11   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipRenounced(address indexed previousOwner);
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to relinquish control of the contract.
70    * @notice Renouncing to ownership will leave the contract without an owner.
71    * It will not be possible to call the functions with the `onlyOwner`
72    * modifier anymore.
73    */
74   function renounceOwnership() public onlyOwner {
75     emit OwnershipRenounced(owner);
76     owner = address(0);
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address _newOwner) public onlyOwner {
84     _transferOwnership(_newOwner);
85   }
86 
87   /**
88    * @dev Transfers control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function _transferOwnership(address _newOwner) internal {
92     require(_newOwner != address(0));
93     emit OwnershipTransferred(owner, _newOwner);
94     owner = _newOwner;
95   }
96 }
97 
98 
99 contract EthTweetMe is Ownable {
100     using SafeMath for uint256;
101 
102     // Supported token symbols mapped to ERC20 contract addr
103     mapping(string => address) tokens;
104 
105     address webappAddress;
106     address feePayoutAddress;
107     uint256 public feePercentage = 5;
108     uint256 public minAmount = 0.000001 ether;
109     uint256 public webappMinBalance = 0.000001 ether;
110 
111     struct Influencer {
112         address influencerAddress;
113         uint256 charityPercentage;
114         address charityAddress;
115     }
116     // Map influencer's twitterHandle to Influencer struct
117     mapping(string => Influencer) influencers;
118 
119 
120     event InfluencerAdded(string _influencerTwitterHandle);
121     event FeePercentageUpdated(uint256 _feePercentage);
122     event Deposit(address _address, uint256 _amount);
123 
124 
125     modifier onlyWebappOrOwner() {
126         require(msg.sender == webappAddress || msg.sender == owner);
127         _;
128     }
129     modifier onlyFeePayoutOrOwner() {
130         require(msg.sender == feePayoutAddress || msg.sender == owner);
131         _;
132     }
133 
134 
135     constructor() public {
136         webappAddress = msg.sender;
137         feePayoutAddress = msg.sender;
138     }
139 
140     // Fallback function. Allow users to pay the contract directly
141     function() external payable {
142         emit Deposit(msg.sender, msg.value);
143     }
144 
145     // Owner management functions
146     function updateFeePercentage(uint256 _feePercentage) external onlyWebappOrOwner {
147         require(_feePercentage <= 100);
148         feePercentage = _feePercentage;
149         emit FeePercentageUpdated(feePercentage);
150     }
151 
152     function updateMinAmount(uint256 _minAmount) external onlyWebappOrOwner {
153         minAmount = _minAmount;
154     }
155     function updateWebappMinBalance(uint256 _minBalance) external onlyWebappOrOwner {
156         webappMinBalance = _minBalance;
157     }
158 
159     function updateWebappAddress(address _address) external onlyOwner {
160         webappAddress = _address;
161     }
162 
163     function updateFeePayoutAddress(address _address) external onlyOwner {
164         feePayoutAddress = _address;
165     }
166 
167     // Move some of the remaining balance stored in the contract
168     function payoutETH(uint256 _amount) external onlyFeePayoutOrOwner {
169         require(_amount <= address(this).balance);
170         feePayoutAddress.transfer(_amount);
171     }
172     function payoutERC20(string _symbol) external onlyFeePayoutOrOwner {
173         // Must be an ERC20 that we support
174         require(tokens[_symbol] != 0x0);
175         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
176 
177         require(erc20.balanceOf(address(this)) > 0);
178         erc20.transfer(feePayoutAddress, erc20.balanceOf(address(this)));
179     }
180 
181     function updateInfluencer(
182             string _twitterHandle,
183             address _influencerAddress,
184             uint256 _charityPercentage,
185             address _charityAddress) external onlyWebappOrOwner {
186         require(_charityPercentage <= 100);
187         require((_charityPercentage == 0 && _charityAddress == 0x0) || (_charityPercentage > 0 && _charityAddress != 0x0));
188         if (influencers[_twitterHandle].influencerAddress == 0x0) {
189             // This is a new Influencer!
190             emit InfluencerAdded(_twitterHandle);
191         }
192         influencers[_twitterHandle] = Influencer(_influencerAddress, _charityPercentage, _charityAddress);
193     }
194 
195     function sendEthTweet(uint256 _amount, bool _isERC20, string _symbol, bool _payFromMsg, string _influencerTwitterHandle, uint256 _additionalFee) private {
196         require(
197             (!_isERC20 && _payFromMsg && msg.value == _amount) ||
198             (!_isERC20 && !_payFromMsg && _amount <= address(this).balance) ||
199             _isERC20
200         );
201         require(_additionalFee == 0 || _amount > _additionalFee);
202 
203         ERC20Basic erc20;
204         if (_isERC20) {
205             // Now do ERC20-specific checks
206             // Must be an ERC20 that we support
207             require(tokens[_symbol] != 0x0);
208 
209             // The ERC20 funds should have already been transferred
210             erc20 = ERC20Basic(tokens[_symbol]);
211             require(erc20.balanceOf(address(this)) >= _amount);
212         }
213 
214         // influencer must be a known twitterHandle
215         Influencer memory influencer = influencers[_influencerTwitterHandle];
216         require(influencer.influencerAddress != 0x0);
217 
218         uint256[] memory payouts = new uint256[](4);    // 0: influencer, 1: charity, 2: fee, 3: webapp
219         uint256 hundred = 100;
220         if (_additionalFee > 0) {
221             payouts[3] = _additionalFee;
222             _amount = _amount.sub(_additionalFee);
223         }
224         if (influencer.charityPercentage == 0) {
225             payouts[0] = _amount.mul(hundred.sub(feePercentage)).div(hundred);
226             payouts[2] = _amount.sub(payouts[0]);
227         } else {
228             payouts[1] = _amount.mul(influencer.charityPercentage).div(hundred);
229             payouts[0] = _amount.sub(payouts[1]).mul(hundred.sub(feePercentage)).div(hundred);
230             payouts[2] = _amount.sub(payouts[1]).sub(payouts[0]);
231         }
232 
233         require(payouts[0].add(payouts[1]).add(payouts[2]) == _amount);
234 
235         if (payouts[0] > 0) {
236             if (!_isERC20) {
237                 influencer.influencerAddress.transfer(payouts[0]);
238             } else {
239                 erc20.transfer(influencer.influencerAddress, payouts[0]);
240             }
241         }
242         if (payouts[1] > 0) {
243             if (!_isERC20) {
244                 influencer.charityAddress.transfer(payouts[1]);
245             } else {
246                 erc20.transfer(influencer.charityAddress, payouts[1]);
247             }
248         }
249         if (payouts[2] > 0) {
250             if (!_isERC20) {
251                 if (webappAddress.balance < webappMinBalance) {
252                     // Redirect the fee funds into webapp
253                     payouts[3] = payouts[3].add(payouts[2]);
254                 } else {
255                     feePayoutAddress.transfer(payouts[2]);
256                 }
257             } else {
258                 erc20.transfer(feePayoutAddress, payouts[2]);
259             }
260         }
261         if (payouts[3] > 0) {
262             if (!_isERC20) {
263                 webappAddress.transfer(payouts[3]);
264             } else {
265                 erc20.transfer(webappAddress, payouts[3]);
266             }
267         }
268     }
269 
270     // Called by users directly interacting with the contract, paying in ETH
271     //  Users are paying their own gas so no additional fee.
272     function sendEthTweet(string _influencerTwitterHandle) external payable {
273         sendEthTweet(msg.value, false, "ETH", true, _influencerTwitterHandle, 0);
274     }
275 
276     // Called by the webapp on behalf of Other/QR code payers.
277     //  Charge an additional fee since we're paying for gas.
278     function sendPrepaidEthTweet(uint256 _amount, string _influencerTwitterHandle, uint256 _additionalFee) external onlyWebappOrOwner {
279         /* require(_amount <= address(this).balance); */
280         sendEthTweet(_amount, false, "ETH", false, _influencerTwitterHandle, _additionalFee);
281     }
282 
283     /****************************************************************
284     *   ERC-20 support
285     ****************************************************************/
286     function addNewToken(string _symbol, address _address) external onlyWebappOrOwner {
287         tokens[_symbol] = _address;
288     }
289     function removeToken(string _symbol) external onlyWebappOrOwner {
290         require(tokens[_symbol] != 0x0);
291         delete(tokens[_symbol]);
292     }
293     function supportsToken(string _symbol, address _address) external constant returns (bool) {
294         return (tokens[_symbol] == _address);
295     }
296     function contractTokenBalance(string _symbol) external constant returns (uint256) {
297         require(tokens[_symbol] != 0x0);
298         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
299         return erc20.balanceOf(address(this));
300     }
301 
302     // Called as the second step by users directly interacting with the contract.
303     //  Users are paying their own gas so no additional fee.
304     function sendERC20Tweet(uint256 _amount, string _symbol, string _influencerTwitterHandle) external {
305         // Pull in the pre-approved ERC-20 funds
306         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
307         erc20.transferFrom(msg.sender, address(this), _amount);
308 
309         sendEthTweet(_amount, true, _symbol, false, _influencerTwitterHandle, 0);
310     }
311 
312     // Called by the webapp on behalf of Other/QR code payers.
313     //  Charge an additional fee since we're paying for gas.
314     function sendPrepaidERC20Tweet(uint256 _amount, string _symbol, string _influencerTwitterHandle, uint256 _additionalFee) external onlyWebappOrOwner {
315         sendEthTweet(_amount, true, _symbol, false, _influencerTwitterHandle, _additionalFee);
316     }
317 
318     // Public accessors
319     function getInfluencer(string _twitterHandle) external constant returns(address, uint256, address) {
320         Influencer memory influencer = influencers[_twitterHandle];
321         return (influencer.influencerAddress, influencer.charityPercentage, influencer.charityAddress);
322     }
323 
324 }