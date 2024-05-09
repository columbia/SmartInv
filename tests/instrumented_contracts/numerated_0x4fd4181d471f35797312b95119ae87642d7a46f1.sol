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
129 
130 
131     constructor() public {
132         webappAddress = msg.sender;
133         feePayoutAddress = msg.sender;
134     }
135 
136     // Fallback function. Allow users to pay the contract directly
137     function() external payable {
138         emit Deposit(msg.sender, msg.value);
139     }
140 
141     function updateFeePercentage(uint256 _feePercentage) external onlyWebappOrOwner {
142         require(_feePercentage <= 100);
143         feePercentage = _feePercentage;
144         emit FeePercentageUpdated(feePercentage);
145     }
146 
147     function updateMinAmount(uint256 _minAmount) external onlyWebappOrOwner {
148         minAmount = _minAmount;
149     }
150     function updateWebappMinBalance(uint256 _minBalance) external onlyWebappOrOwner {
151         webappMinBalance = _minBalance;
152     }
153 
154     function updateWebappAddress(address _address) external onlyOwner {
155         webappAddress = _address;
156     }
157 
158     function updateFeePayoutAddress(address _address) external onlyOwner {
159         feePayoutAddress = _address;
160     }
161 
162     function updateInfluencer(
163             string _twitterHandle,
164             address _influencerAddress,
165             uint256 _charityPercentage,
166             address _charityAddress) external onlyWebappOrOwner {
167         require(_charityPercentage <= 100);
168         require((_charityPercentage == 0 && _charityAddress == 0x0) || (_charityPercentage > 0 && _charityAddress != 0x0));
169         if (influencers[_twitterHandle].influencerAddress == 0x0) {
170             // This is a new Influencer!
171             emit InfluencerAdded(_twitterHandle);
172         }
173         influencers[_twitterHandle] = Influencer(_influencerAddress, _charityPercentage, _charityAddress);
174     }
175 
176     function sendEthTweet(uint256 _amount, bool _isERC20, string _symbol, bool _payFromMsg, string _influencerTwitterHandle, uint256 _additionalFee) private {
177         require(
178             (!_isERC20 && _payFromMsg && msg.value == _amount) ||
179             (!_isERC20 && !_payFromMsg && _amount <= address(this).balance) ||
180             _isERC20
181         );
182         require(_additionalFee == 0 || _amount > _additionalFee);
183 
184         ERC20Basic erc20;
185         if (_isERC20) {
186             // Now do ERC20-specific checks
187             // Must be an ERC20 that we support
188             require(tokens[_symbol] != 0x0);
189 
190             // The ERC20 funds should have already been transferred
191             erc20 = ERC20Basic(tokens[_symbol]);
192             require(erc20.balanceOf(address(this)) >= _amount);
193         }
194 
195         // influencer must be a known twitterHandle
196         Influencer memory influencer = influencers[_influencerTwitterHandle];
197         require(influencer.influencerAddress != 0x0);
198 
199         uint256[] memory payouts = new uint256[](4);    // 0: influencer, 1: charity, 2: fee, 3: webapp
200         uint256 hundred = 100;
201         if (_additionalFee > 0) {
202             payouts[3] = _additionalFee;
203             _amount = _amount.sub(_additionalFee);
204         }
205         if (influencer.charityPercentage == 0) {
206             payouts[0] = _amount.mul(hundred.sub(feePercentage)).div(hundred);
207             payouts[2] = _amount.sub(payouts[0]);
208         } else {
209             payouts[1] = _amount.mul(influencer.charityPercentage).div(hundred);
210             payouts[0] = _amount.sub(payouts[1]).mul(hundred.sub(feePercentage)).div(hundred);
211             payouts[2] = _amount.sub(payouts[1]).sub(payouts[0]);
212         }
213 
214         require(payouts[0].add(payouts[1]).add(payouts[2]) == _amount);
215 
216         if (payouts[0] > 0) {
217             if (!_isERC20) {
218                 influencer.influencerAddress.transfer(payouts[0]);
219             } else {
220                 erc20.transfer(influencer.influencerAddress, payouts[0]);
221             }
222         }
223         if (payouts[1] > 0) {
224             if (!_isERC20) {
225                 influencer.charityAddress.transfer(payouts[1]);
226             } else {
227                 erc20.transfer(influencer.charityAddress, payouts[1]);
228             }
229         }
230         if (payouts[2] > 0) {
231             if (!_isERC20) {
232                 if (webappAddress.balance < webappMinBalance) {
233                     // Redirect the fee funds into webapp
234                     payouts[3] = payouts[3].add(payouts[2]);
235                 } else {
236                     feePayoutAddress.transfer(payouts[2]);
237                 }
238             } else {
239                 erc20.transfer(feePayoutAddress, payouts[2]);
240             }
241         }
242         if (payouts[3] > 0) {
243             if (!_isERC20) {
244                 webappAddress.transfer(payouts[3]);
245             } else {
246                 erc20.transfer(webappAddress, payouts[3]);
247             }
248         }
249     }
250 
251     // Called by users directly interacting with the contract, paying in ETH
252     //  Users are paying their own gas so no additional fee.
253     function sendEthTweet(string _influencerTwitterHandle) external payable {
254         sendEthTweet(msg.value, false, "ETH", true, _influencerTwitterHandle, 0);
255     }
256 
257     // Called by the webapp on behalf of Other/QR code payers.
258     //  Charge an additional fee since we're paying for gas.
259     function sendPrepaidEthTweet(uint256 _amount, string _influencerTwitterHandle, uint256 _additionalFee) external onlyWebappOrOwner {
260         /* require(_amount <= address(this).balance); */
261         sendEthTweet(_amount, false, "ETH", false, _influencerTwitterHandle, _additionalFee);
262     }
263 
264     /****************************************************************
265     *   ERC-20 support
266     ****************************************************************/
267     function addNewToken(string _symbol, address _address) external onlyWebappOrOwner {
268         tokens[_symbol] = _address;
269     }
270     function removeToken(string _symbol) external onlyWebappOrOwner {
271         require(tokens[_symbol] != 0x0);
272         delete(tokens[_symbol]);
273     }
274     function supportsToken(string _symbol, address _address) external constant returns (bool) {
275         return (tokens[_symbol] == _address);
276     }
277     function contractTokenBalance(string _symbol) external constant returns (uint256) {
278         require(tokens[_symbol] != 0x0);
279         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
280         return erc20.balanceOf(address(this));
281     }
282 
283     // Called as the second step by users directly interacting with the contract.
284     //  Users are paying their own gas so no additional fee.
285     function sendERC20Tweet(uint256 _amount, string _symbol, string _influencerTwitterHandle) external {
286         // Pull in the pre-approved ERC-20 funds
287         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
288         require(erc20.transferFrom(msg.sender, address(this), _amount));
289 
290         sendEthTweet(_amount, true, _symbol, false, _influencerTwitterHandle, 0);
291     }
292 
293     // Called by the webapp on behalf of Other/QR code payers.
294     //  Charge an additional fee since we're paying for gas.
295     function sendPrepaidERC20Tweet(uint256 _amount, string _symbol, string _influencerTwitterHandle, uint256 _additionalFee) external onlyWebappOrOwner {
296         sendEthTweet(_amount, true, _symbol, false, _influencerTwitterHandle, _additionalFee);
297     }
298 
299 
300     // Public accessors
301     function getInfluencer(string _twitterHandle) external constant returns(address, uint256, address) {
302         Influencer memory influencer = influencers[_twitterHandle];
303         return (influencer.influencerAddress, influencer.charityPercentage, influencer.charityAddress);
304     }
305 
306 }