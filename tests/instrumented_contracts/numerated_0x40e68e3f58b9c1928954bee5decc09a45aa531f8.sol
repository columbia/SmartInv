1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 contract Administration {
5 
6     using SafeMath for uint256;
7 
8     address public owner;
9     address public admin;
10 
11     event AdminSet(address _admin);
12     event OwnershipTransferred(address _previousOwner, address _newOwner);
13 
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyAdmin() {
21         require(msg.sender == owner || msg.sender == admin);
22         _;
23     }
24 
25     modifier nonZeroAddress(address _addr) {
26         require(_addr != address(0), "must be non zero address");
27         _;
28     }
29 
30     constructor() public {
31         owner = msg.sender;
32         admin = msg.sender;
33     }
34 
35     function setAdmin(
36         address _newAdmin
37     )
38         public
39         onlyOwner
40         nonZeroAddress(_newAdmin)
41         returns (bool)
42     {
43         require(_newAdmin != admin);
44         admin = _newAdmin;
45         emit AdminSet(_newAdmin);
46         return true;
47     }
48 
49     function transferOwnership(
50         address _newOwner
51     )
52         public
53         onlyOwner
54         nonZeroAddress(_newOwner)
55         returns (bool)
56     {
57         owner = _newOwner;
58         emit OwnershipTransferred(msg.sender, _newOwner);
59         return true;
60     }
61 
62 }
63 
64 library SafeMath {
65 
66   // We use `pure` bbecause it promises that the value for the function depends ONLY
67   // on the function arguments
68     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
69         uint256 c = a * b;
70         require(a == 0 || c / a == b);
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a / b;
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         return a - b;
82     }
83 
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87         return c;
88     }
89 }
90 
91 interface RTCoinInterface {
92     
93 
94     /** Functions - ERC20 */
95     function transfer(address _recipient, uint256 _amount) external returns (bool);
96 
97     function transferFrom(address _owner, address _recipient, uint256 _amount) external returns (bool);
98 
99     function approve(address _spender, uint256 _amount) external returns (bool approved);
100 
101     /** Getters - ERC20 */
102     function totalSupply() external view returns (uint256);
103 
104     function balanceOf(address _holder) external view returns (uint256);
105 
106     function allowance(address _owner, address _spender) external view returns (uint256);
107 
108     /** Getters - Custom */
109     function mint(address _recipient, uint256 _amount) external returns (bool);
110 
111     function stakeContractAddress() external view returns (address);
112 
113     function mergedMinerValidatorAddress() external view returns (address);
114     
115     /** Functions - Custom */
116     function freezeTransfers() external returns (bool);
117 
118     function thawTransfers() external returns (bool);
119 }
120 
121 /*
122     ERC20 Standard Token interface
123 */
124 interface ERC20Interface {
125     function owner() external view returns (address);
126     function decimals() external view returns (uint8);
127     function transfer(address _to, uint256 _value) external returns (bool);
128     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
129     function approve(address _spender, uint256 _amount) external returns (bool);
130     function totalSupply() external view returns (uint256);
131     function balanceOf(address _owner) external view returns (uint256);
132     function allowance(address _owner, address _spender) external view returns (uint256);
133 }
134 
135 /// @title RTCETH allows the sale of RTC for ETH with an updatable ETH price
136 /// @author Postables, RTrade Technologies Ltd
137 /// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
138 contract RTCETH is Administration {
139     using SafeMath for uint256;
140 
141     // we mark as constant private to save gas
142     address constant private TOKENADDRESS = 0xecc043b92834c1ebDE65F2181B59597a6588D616;
143     RTCoinInterface constant public RTI = RTCoinInterface(TOKENADDRESS);
144     string constant public VERSION = "production";
145 
146     address public hotWallet;
147     uint256 public ethUSD;
148     uint256 public weiPerRtc;
149     bool   public locked;
150 
151     event EthUsdPriceUpdated(uint256 _ethUSD);
152     event EthPerRtcUpdated(uint256 _ethPerRtc);
153     event RtcPurchased(uint256 _rtcPurchased);
154     event ForeignTokenTransfer(address indexed _sender, address indexed _recipient, uint256 _amount);
155 
156     modifier notLocked() {
157         require(!locked, "sale must not be locked");
158         _;
159     }
160 
161     modifier isLocked() {
162         require(locked, "sale must be locked");
163         _;
164     }
165 
166     function lockSales()
167         public
168         onlyAdmin
169         notLocked
170         returns (bool)
171     {
172         locked = true;
173         return true;
174     }
175 
176     function unlockSales()
177         public
178         onlyAdmin
179         isLocked
180         returns (bool)
181     {
182         locked = false;
183         return true;
184     }
185 
186     constructor() public {
187         // prevent deployment if the token address isnt set
188         require(TOKENADDRESS != address(0), "token address cant be unset");
189         locked = true;
190     }
191 
192     function () external payable {
193         require(msg.data.length == 0, "data length must be 0");
194         require(buyRtc(), "buying rtc failed");
195     }
196 
197     function updateEthPrice(
198         uint256 _ethUSD)
199         public
200         onlyAdmin
201         returns (bool)
202     {
203         ethUSD = _ethUSD;
204         uint256 oneEth = 1 ether;
205         // here we calculate how many ETH 1 USD is worth
206         uint256 oneUsdOfEth = oneEth.div(ethUSD);
207         // for the duration of this contract, RTC will be at a fixed price of 0.125USD, which divides into 1 8 times
208         weiPerRtc = oneUsdOfEth.div(8);
209         emit EthUsdPriceUpdated(ethUSD);
210         emit EthPerRtcUpdated(weiPerRtc);
211         return true;
212     }
213 
214     function setHotWallet(
215         address _hotWalletAddress)
216         public
217         onlyOwner
218         isLocked
219         returns (bool)
220     {
221         hotWallet = _hotWalletAddress;
222         return true;
223     }
224 
225     function withdrawRemainingRtc()
226         public
227         onlyOwner
228         isLocked
229         returns (bool)
230     {
231         require(RTI.transfer(msg.sender, RTI.balanceOf(address(this))), "transfer failed");
232         return true;
233     }
234 
235     function buyRtc()
236         public
237         payable
238         notLocked
239         returns (bool)
240     {
241         require(hotWallet != address(0), "hot wallet cant be unset");
242         require(msg.value > 0, "msg value must be greater than zero");
243         uint256 rtcPurchased = (msg.value.mul(1 ether)).div(weiPerRtc);
244         hotWallet.transfer(msg.value);
245         require(RTI.transfer(msg.sender, rtcPurchased), "transfer failed");
246         emit RtcPurchased(rtcPurchased);
247         return true;
248     }
249 
250     /** @notice Allow us to transfer tokens that someone might've accidentally sent to this contract
251         @param _tokenAddress this is the address of the token contract
252         @param _recipient This is the address of the person receiving the tokens
253         @param _amount This is the amount of tokens to send
254      */
255     function transferForeignToken(
256         address _tokenAddress,
257         address _recipient,
258         uint256 _amount)
259         public
260         onlyAdmin
261         returns (bool)
262     {
263         require(_recipient != address(0), "recipient address can't be empty");
264         // don't allow us to transfer RTC tokens stored in this contract
265         require(_tokenAddress != TOKENADDRESS, "token can't be RTC");
266         ERC20Interface eI = ERC20Interface(_tokenAddress);
267         require(eI.transfer(_recipient, _amount), "token transfer failed");
268         emit ForeignTokenTransfer(msg.sender, _recipient, _amount);
269         return true;
270     }
271 }