1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 
115 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
116 contract TokenControllerI {
117 
118     /// @dev Specifies whether a transfer is allowed or not.
119     /// @return True if the transfer is allowed
120     function transferAllowed(address _from, address _to)
121         external
122         view 
123         returns (bool);
124 }
125 
126 interface SaleInterface {
127     function saleTokensPerUnit() external view returns(uint256);
128     function extraTokensPerUnit() external view returns(uint256);
129     function unitContributions(address) external view returns(uint256);
130     function disbursementHandler() external view returns(address);
131 
132 }
133 
134 
135 interface RegistryInterface {
136 
137     function totalStaked(address) external view returns(uint256);
138     function numApplications(address) external view returns(uint256);
139 
140 }
141 
142 
143 contract FoamTokenController is TokenControllerI, Ownable {
144     using SafeMath for uint256;
145 
146     RegistryInterface public registry;
147     SaleInterface public sale;
148 
149     uint256 public platformLaunchDate;
150 
151     uint256 public saleTokensPerUnit;
152     uint256 public extraTokensPerUnit;
153 
154     mapping (address => bool) public isProtocolContract;
155 
156     mapping(address => address) public proposedPair;
157     mapping(address => address) public pair;
158 
159     mapping(address => bool) public isBlacklisted;
160 
161     event ProposeWhitelisted(address _whitelistor, address _whitelistee);
162     event ConfirmWhitelisted(address _whitelistor, address _whitelistee);
163 
164     // this is one of the TF multisigs.
165     // We can then send the tokens onwards to wherever FOAM request for the tokens to be.
166     address acceptedAddress = 0x36A9b165ef64767230A7Aded71B04F0911bB1283;
167 
168     constructor(RegistryInterface _registry, SaleInterface _sale, uint256 _launchDate) public {
169         require(_registry != address(0));
170         require(_sale != address(0));
171         require(_launchDate != 0 && _launchDate <= now);
172 
173         registry = _registry;
174         sale = _sale;
175         platformLaunchDate = _launchDate;
176 
177         isProtocolContract[address(registry)] = true;
178 
179         saleTokensPerUnit = sale.saleTokensPerUnit();
180         extraTokensPerUnit = sale.extraTokensPerUnit();
181     }
182 
183     function setWhitelisted(address _whitelisted) public {
184         require(_whitelisted != 0);
185 
186         require(pair[msg.sender] == 0);
187         require(pair[_whitelisted] == 0);
188 
189         require(sale.unitContributions(msg.sender) != 0);
190         require(sale.unitContributions(_whitelisted) == 0);
191 
192         proposedPair[msg.sender] = _whitelisted;
193         emit ProposeWhitelisted(msg.sender, _whitelisted);
194     }
195 
196     function confirmWhitelisted(address _whitelistor) public {
197         require(pair[msg.sender] == 0);
198         require(pair[_whitelistor] == 0);
199 
200         require(proposedPair[_whitelistor] == msg.sender);
201 
202         pair[msg.sender] = _whitelistor;
203         pair[_whitelistor] = msg.sender;
204 
205         emit ConfirmWhitelisted(_whitelistor, msg.sender);
206     }
207 
208     function blacklistAddresses(address[] _addresses, bool _isBlacklisted) public onlyOwner {
209         for (uint256 i = 0; i < _addresses.length; i++) {
210             isBlacklisted[_addresses[i]] = _isBlacklisted;
211         }
212     }
213 
214     function changeRegistry(RegistryInterface _newRegistry) public onlyOwner {
215         require(_newRegistry != address(0));
216         isProtocolContract[address(registry)] = false;
217         isProtocolContract[address(_newRegistry)] = true;
218         registry = _newRegistry;
219     }
220 
221     function setPlatformLaunchDate(uint256 _launchDate) public onlyOwner {
222         require(_launchDate != 0 && _launchDate <= now);
223         platformLaunchDate = _launchDate;
224     }
225 
226     function setProtocolContract(address _contract, bool _isProtocolContract) public onlyOwner {
227         isProtocolContract[_contract] = _isProtocolContract;
228     }
229 
230     function transferAllowed(address _from, address _to)
231         external
232         view
233         returns (bool)
234     {
235         if(isBlacklisted[_from]) {
236             if (_to == acceptedAddress) {
237                 return true;
238             } else {
239                 return false;
240             }
241         }
242 
243         bool protocolTransfer = isProtocolContract[_from] || isProtocolContract[_to];
244         bool whitelistedTransfer = pair[_from] == _to && pair[_to] == _from;
245 
246         if (protocolTransfer || whitelistedTransfer || platformLaunchDate + 1 years <= now) {
247             return true;
248         } else if (platformLaunchDate + 45 days > now) {
249             return false;
250         }
251         return purchaseCheck(_from);
252     }
253 
254     function purchaseCheck(address _contributor) internal view returns(bool) {
255         address secondAddress = pair[_contributor];
256 
257         uint256 contributed = sale.unitContributions(_contributor);
258 
259         if (contributed == 0) {
260             if (secondAddress == 0) {
261                 return true;
262             } else {
263                 contributed = sale.unitContributions(secondAddress);
264             }
265         }
266 
267         uint256 tokensStaked = registry.totalStaked(_contributor);
268         uint256 PoICreated = registry.numApplications(_contributor);
269 
270         if (secondAddress != 0) {
271             tokensStaked = tokensStaked.add(registry.totalStaked(secondAddress));
272             PoICreated = PoICreated.add(registry.numApplications(secondAddress));
273         }
274 
275         uint256 tokensBought = contributed.mul(saleTokensPerUnit.add(extraTokensPerUnit));
276 
277         bool enoughStaked;
278         if (contributed <= 10000) {
279             enoughStaked = tokensStaked >= tokensBought.mul(25).div(100);
280         } else {
281             enoughStaked = tokensStaked >= tokensBought.mul(50).div(100);
282         }
283 
284         return enoughStaked && PoICreated >= 10;
285     }
286 }