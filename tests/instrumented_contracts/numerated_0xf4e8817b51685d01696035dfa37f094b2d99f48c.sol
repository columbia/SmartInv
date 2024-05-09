1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 // ----------------------------------------------------------------------------
11 // Safe maths
12 // ----------------------------------------------------------------------------
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipRenounced(address indexed previousOwner);
42   event OwnershipTransferred(
43     address indexed previousOwner,
44     address indexed newOwner
45   );
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to relinquish control of the contract.
66    * @notice Renouncing to ownership will leave the contract without an owner.
67    * It will not be possible to call the functions with the `onlyOwner`
68    * modifier anymore.
69    */
70   function renounceOwnership() public onlyOwner {
71     emit OwnershipRenounced(owner);
72     owner = address(0);
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address _newOwner) public onlyOwner {
80     _transferOwnership(_newOwner);
81   }
82 
83   /**
84    * @dev Transfers control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function _transferOwnership(address _newOwner) internal {
88     require(_newOwner != address(0));
89     emit OwnershipTransferred(owner, _newOwner);
90     owner = _newOwner;
91   }
92 }
93 
94 
95 contract EthTweetMe is Ownable {
96     using SafeMath for uint256;
97 
98     // Supported token symbols mapped to ERC20 contract addr
99     mapping(string => address) tokens;
100 
101     address webappAddress;
102     address feePayoutAddress;
103     uint256 public feePercentage = 5;
104     uint256 public minAmount = 0.000001 ether;
105     uint256 public webappMinBalance = 0.000001 ether;
106 
107     struct Influencer {
108         address influencerAddress;
109         uint256 charityPercentage;
110         address charityAddress;
111     }
112     // Map influencer's twitterHandle to Influencer struct
113     mapping(string => Influencer) influencers;
114 
115     struct EthTweet {
116         string followerTwitterHandle;
117         string influencerTwitterHandle;
118         string tweet;
119         uint256 amount;
120         string symbol;
121     }
122     EthTweet[] public ethTweets;
123 
124 
125     event InfluencerAdded(string _influencerTwitterHandle);
126     event EthTweetSent(string _followerTwitterHandle, string _influencerTwitterHandle, uint256 _amount, string _symbol, uint256 _index);
127     event FeePercentageUpdated(uint256 _feePercentage);
128     event Deposit(address _address, uint256 _amount);
129     event TokenAdded(string _symbol, address _address);
130     event TokenRemoved(string _symbol);
131     event Payment(address _address, uint256 _amount, string _symbol);
132 
133 
134     modifier onlyWebappOrOwner() {
135         require(msg.sender == webappAddress || msg.sender == owner);
136         _;
137     }
138 
139 
140     constructor() public {
141         webappAddress = msg.sender;
142         feePayoutAddress = msg.sender;
143     }
144 
145     // Fallback function. Allow users to pay the contract directly
146     function() external payable {
147         emit Deposit(msg.sender, msg.value);
148     }
149 
150     function updateFeePercentage(uint256 _feePercentage) external onlyWebappOrOwner {
151         require(_feePercentage <= 100);
152         feePercentage = _feePercentage;
153         emit FeePercentageUpdated(feePercentage);
154     }
155 
156     function updateMinAmount(uint256 _minAmount) external onlyWebappOrOwner {
157         minAmount = _minAmount;
158     }
159     function updateWebappMinBalance(uint256 _minBalance) external onlyWebappOrOwner {
160         webappMinBalance = _minBalance;
161     }
162 
163     function updateWebappAddress(address _address) external onlyOwner {
164         webappAddress = _address;
165     }
166 
167     function updateFeePayoutAddress(address _address) external onlyOwner {
168         feePayoutAddress = _address;
169     }
170 
171     function updateInfluencer(
172             string _twitterHandle,
173             address _influencerAddress,
174             uint256 _charityPercentage,
175             address _charityAddress) external onlyWebappOrOwner {
176         require(_charityPercentage <= 100);
177         require((_charityPercentage == 0 && _charityAddress == 0x0) || (_charityPercentage > 0 && _charityAddress != 0x0));
178         if (influencers[_twitterHandle].influencerAddress == 0x0) {
179             // This is a new Influencer!
180             emit InfluencerAdded(_twitterHandle);
181         }
182         influencers[_twitterHandle] = Influencer(_influencerAddress, _charityPercentage, _charityAddress);
183     }
184 
185     function sendEthTweet(uint256 _amount, bool _isERC20, string _symbol, bool _payFromMsg, string _followerTwitterHandle, string _influencerTwitterHandle, string _tweet) private {
186         require(
187             (!_isERC20 && _payFromMsg && msg.value == _amount) ||
188             (!_isERC20 && !_payFromMsg && _amount <= address(this).balance) ||
189             _isERC20
190         );
191 
192         ERC20Basic erc20;
193         if (_isERC20) {
194             // Now do ERC20-specific checks
195             // Must be an ERC20 that we support
196             require(tokens[_symbol] != 0x0);
197 
198             // The ERC20 funds should have already been transferred
199             erc20 = ERC20Basic(tokens[_symbol]);
200             require(erc20.balanceOf(address(this)) >= _amount);
201         }
202 
203         // influencer must be a known twitterHandle
204         Influencer memory influencer = influencers[_influencerTwitterHandle];
205         require(influencer.influencerAddress != 0x0);
206 
207         uint256[] memory payouts = new uint256[](4);    // 0: influencer, 1: charity, 2: fee
208         payouts[3] = 100;
209         if (influencer.charityPercentage == 0) {
210             payouts[0] = _amount.mul(payouts[3].sub(feePercentage)).div(payouts[3]);
211             payouts[2] = _amount.sub(payouts[0]);
212         } else {
213             payouts[1] = _amount.mul(influencer.charityPercentage).div(payouts[3]);
214             payouts[0] = _amount.sub(payouts[1]).mul(payouts[3].sub(feePercentage)).div(payouts[3]);
215             payouts[2] = _amount.sub(payouts[1]).sub(payouts[0]);
216         }
217 
218         require(payouts[0].add(payouts[1]).add(payouts[2]) == _amount);
219 
220         // Checks - EFFECTS - Interaction
221         ethTweets.push(EthTweet(_followerTwitterHandle, _influencerTwitterHandle, _tweet, _amount, _symbol));
222         emit EthTweetSent(
223             _followerTwitterHandle,
224             _influencerTwitterHandle,
225             _amount,
226             _symbol,
227             ethTweets.length - 1
228         );
229 
230         if (payouts[0] > 0) {
231             if (!_isERC20) {
232                 influencer.influencerAddress.transfer(payouts[0]);
233             } else {
234                 erc20.transfer(influencer.influencerAddress, payouts[0]);
235             }
236             emit Payment(influencer.influencerAddress, payouts[0], _symbol);
237         }
238         if (payouts[1] > 0) {
239             if (!_isERC20) {
240                 influencer.charityAddress.transfer(payouts[1]);
241             } else {
242                 erc20.transfer(influencer.charityAddress, payouts[1]);
243             }
244             emit Payment(influencer.charityAddress, payouts[1], _symbol);
245         }
246         if (payouts[2] > 0) {
247             if (!_isERC20) {
248                 if (webappAddress.balance < webappMinBalance) {
249                     // Redirect some funds into webapp
250                     webappAddress.transfer(payouts[2].div(5));
251                     payouts[2] = payouts[2].sub(payouts[2].div(5));
252                     emit Payment(webappAddress, payouts[2].div(5), _symbol);
253                 }
254                 feePayoutAddress.transfer(payouts[2]);
255             } else {
256                 erc20.transfer(feePayoutAddress, payouts[2]);
257             }
258             emit Payment(feePayoutAddress, payouts[2], _symbol);
259         }
260     }
261 
262     // Called by users directly interacting with the contract, paying in ETH
263     function sendEthTweet(string _followerTwitterHandle, string _influencerTwitterHandle, string _tweet) external payable {
264         sendEthTweet(msg.value, false, "ETH", true, _followerTwitterHandle, _influencerTwitterHandle, _tweet);
265     }
266 
267     // Called by the webapp on behalf of Other/QR code payers
268     function sendPrepaidEthTweet(uint256 _amount, string _followerTwitterHandle, string _influencerTwitterHandle, string _tweet) external onlyWebappOrOwner {
269         /* require(_amount <= address(this).balance); */
270         sendEthTweet(_amount, false, "ETH", false, _followerTwitterHandle, _influencerTwitterHandle, _tweet);
271     }
272 
273     /****************************************************************
274     *   ERC-20 support
275     ****************************************************************/
276     function addNewToken(string _symbol, address _address) external onlyWebappOrOwner {
277         tokens[_symbol] = _address;
278         emit TokenAdded(_symbol, _address);
279     }
280     function removeToken(string _symbol) external onlyWebappOrOwner {
281         require(tokens[_symbol] != 0x0);
282         delete(tokens[_symbol]);
283         emit TokenRemoved(_symbol);
284     }
285     function supportsToken(string _symbol, address _address) external constant returns (bool) {
286         return (tokens[_symbol] == _address);
287     }
288     function contractTokenBalance(string _symbol) external constant returns (uint256) {
289         require(tokens[_symbol] != 0x0);
290         ERC20Basic erc20 = ERC20Basic(tokens[_symbol]);
291         return erc20.balanceOf(address(this));
292     }
293     function sendERC20Tweet(uint256 _amount, string _symbol, string _followerTwitterHandle, string _influencerTwitterHandle, string _tweet) external onlyWebappOrOwner {
294         sendEthTweet(_amount, true, _symbol, false, _followerTwitterHandle, _influencerTwitterHandle, _tweet);
295     }
296 
297 
298     // Public accessors
299     function getNumEthTweets() external constant returns(uint256) {
300         return ethTweets.length;
301     }
302     function getInfluencer(string _twitterHandle) external constant returns(address, uint256, address) {
303         Influencer memory influencer = influencers[_twitterHandle];
304         return (influencer.influencerAddress, influencer.charityPercentage, influencer.charityAddress);
305     }
306 
307 }