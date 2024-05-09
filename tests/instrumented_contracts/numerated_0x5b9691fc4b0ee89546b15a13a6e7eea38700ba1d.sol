1 pragma solidity ^0.4.24;
2 
3 interface POUInterface {
4 
5     function totalStaked(address) external view returns(uint256);
6     function numApplications(address) external view returns(uint256);
7 
8 }
9 
10 
11 interface SaleInterface {
12     function saleTokensPerUnit() external view returns(uint256);
13     function extraTokensPerUnit() external view returns(uint256);
14     function unitContributions(address) external view returns(uint256);
15     function disbursementHandler() external view returns(address);
16 }
17 
18 
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipRenounced(address indexed previousOwner);
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address _newOwner) public onlyOwner {
68     _transferOwnership(_newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address _newOwner) internal {
76     require(_newOwner != address(0));
77     emit OwnershipTransferred(owner, _newOwner);
78     owner = _newOwner;
79   }
80 }
81 
82 
83 
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
96     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (_a == 0) {
100       return 0;
101     }
102 
103     c = _a * _b;
104     assert(c / _a == _b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
112     // assert(_b > 0); // Solidity automatically throws when dividing by 0
113     // uint256 c = _a / _b;
114     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
115     return _a / _b;
116   }
117 
118   /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
122     assert(_b <= _a);
123     return _a - _b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
130     c = _a + _b;
131     assert(c >= _a);
132     return c;
133   }
134 }
135 
136 
137 
138 
139 
140 
141 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
142 contract TokenControllerI {
143 
144     /// @dev Specifies whether a transfer is allowed or not.
145     /// @return True if the transfer is allowed
146     function transferAllowed(address _from, address _to)
147         external
148         view
149         returns (bool);
150 }
151 
152 
153 
154 
155 contract FoamTokenController is TokenControllerI, Ownable {
156     using SafeMath for uint256;
157 
158     POUInterface public registry;
159     POUInterface public signaling;
160     SaleInterface public sale;
161     SaleInterface public saft;
162 
163     uint256 public platformLaunchDate;
164 
165     uint256 public saleTokensPerUnit;
166     uint256 public extraTokensPerUnit;
167 
168     mapping (address => bool) public isProtocolContract;
169 
170     mapping(address => address) public proposedPair;
171     mapping(address => address) public pair;
172 
173     mapping(address => bool) public isBlacklisted;
174     mapping(address => bool) public pouCompleted;
175 
176     event ProposeWhitelisted(address _whitelistor, address _whitelistee);
177     event ConfirmWhitelisted(address _whitelistor, address _whitelistee);
178     event PoUCompleted(address contributor, address secondAddress, bool isComplete);
179 
180     // this is one of the TF multisigs.
181     // We can then send the tokens onwards to wherever FOAM request for the tokens to be.
182     address acceptedAddress = 0x36A9b165ef64767230A7Aded71B04F0911bB1283;
183 
184     constructor(POUInterface _registry, POUInterface _signaling, SaleInterface _sale, SaleInterface _saft, uint256 _launchDate) public {
185         require(_registry != address(0), "registry contract must have a valid address");
186         require(_signaling != address(0), "signaling contract must have a valid address");
187         require(_sale != address(0), "sale contract must have a valid address");
188         require(_saft != address(0), "saft contract must have a valid address");
189         require(_launchDate != 0 && _launchDate <= now, "platform cannot have launched in the future");
190 
191         registry = _registry;
192         signaling = _signaling;
193         sale = _sale;
194         saft = _saft;
195         platformLaunchDate = _launchDate;
196 
197         isProtocolContract[address(registry)] = true;
198         isProtocolContract[address(signaling)] = true;
199 
200         saleTokensPerUnit = sale.saleTokensPerUnit();
201         extraTokensPerUnit = sale.extraTokensPerUnit();
202     }
203 
204     function setWhitelisted(address _whitelisted) public {
205         require(_whitelisted != 0, "cannot whitelist the zero address");
206 
207         require(pair[msg.sender] == 0, "sender's address must not be paired yet");
208         require(pair[_whitelisted] == 0, "proposed whitelist address must not be paired yet");
209 
210         require(sale.unitContributions(msg.sender) != 0, "sender must have purchased tokens during the sale");
211         require(sale.unitContributions(_whitelisted) == 0, "proposed whitelist address must not have purchased tokens during the sale");
212 
213         proposedPair[msg.sender] = _whitelisted;
214         emit ProposeWhitelisted(msg.sender, _whitelisted);
215     }
216 
217     function confirmWhitelisted(address _whitelistor) public {
218         require(pair[msg.sender] == 0, "sender's address must not be paired yet");
219         require(pair[_whitelistor] == 0, "whitelistor's address must not be paired yet");
220 
221         require(proposedPair[_whitelistor] == msg.sender, "whitelistor's proposed address must be the sender");
222 
223         pair[msg.sender] = _whitelistor;
224         pair[_whitelistor] = msg.sender;
225 
226         emit ConfirmWhitelisted(_whitelistor, msg.sender);
227     }
228 
229     function setAcceptedAddress(address _newAcceptedAddress) public onlyOwner {
230       require(_newAcceptedAddress != address(0), "blacklist bypass address cannot be the zero address");
231       acceptedAddress = _newAcceptedAddress;
232     }
233 
234     function pairAddresses(address[] froms, address[] tos) public onlyOwner {
235       require(froms.length == tos.length, "pair arrays must be same size");
236       for (uint256 i = 0; i < froms.length; i++) {
237         pair[froms[i]] = tos[i];
238         pair[tos[i]] = froms[i];
239       }
240     }
241 
242     function blacklistAddresses(address[] _addresses, bool _isBlacklisted) public onlyOwner {
243         for (uint256 i = 0; i < _addresses.length; i++) {
244             isBlacklisted[_addresses[i]] = _isBlacklisted;
245         }
246     }
247 
248     function setPoUCompleted(address _user, bool _isCompleted) public onlyOwner {
249         pouCompleted[_user] = _isCompleted;
250     }
251 
252     function changeRegistry(POUInterface _newRegistry) public onlyOwner {
253         require(_newRegistry != address(0), "registry contract must have a valid address");
254         isProtocolContract[address(registry)] = false;
255         isProtocolContract[address(_newRegistry)] = true;
256         registry = _newRegistry;
257     }
258 
259     function changeSignaling(POUInterface _newSignaling) public onlyOwner {
260         require(_newSignaling != address(0), "signaling contract must have a valid address");
261         isProtocolContract[address(signaling)] = false;
262         isProtocolContract[address(_newSignaling)] = true;
263         signaling = _newSignaling;
264     }
265 
266     function setPlatformLaunchDate(uint256 _launchDate) public onlyOwner {
267         require(_launchDate != 0 && _launchDate <= now, "platform cannot have launched in the future");
268         platformLaunchDate = _launchDate;
269     }
270 
271     function setProtocolContract(address _contract, bool _isProtocolContract) public onlyOwner {
272         isProtocolContract[_contract] = _isProtocolContract;
273     }
274 
275     function setProtocolContracts(address[] _addresses, bool _isProtocolContract) public onlyOwner {
276       for (uint256 i = 0; i < _addresses.length; i++) {
277         isProtocolContract[_addresses[i]] = _isProtocolContract;
278       }
279     }
280 
281     function setSaleContract(SaleInterface _sale) public onlyOwner {
282       require(_sale != address(0), "sale contract must have a valid address");
283       sale = _sale;
284     }
285 
286     function setSaftContract(SaleInterface _saft) public onlyOwner {
287       require(_saft != address(0), "saft contract must have a valid address");
288       saft = _saft;
289     }
290 
291     function transferAllowed(address _from, address _to)
292         external
293         view
294         returns (bool)
295     {
296         if(isBlacklisted[_from]) {
297             return _to == acceptedAddress;
298         }
299 
300         bool protocolTransfer = isProtocolContract[_from] || isProtocolContract[_to];
301         bool whitelistedTransfer = pair[_from] == _to && pair[_to] == _from;
302 
303         if (protocolTransfer || whitelistedTransfer || platformLaunchDate + 365 days <= now) {
304             return true;
305         } else if (platformLaunchDate + 45 days > now) {
306             return false;
307         }
308         return purchaseCheck(_from);
309     }
310 
311     function purchaseCheck(address _contributor) public returns (bool) {
312         if(pouCompleted[_contributor]){
313             return true;
314         }
315 
316         address secondAddress = pair[_contributor];
317         if(secondAddress != address(0) && pouCompleted[secondAddress]) {
318             return true;
319         }
320 
321         uint256 contributed = sale.unitContributions(_contributor).add(saft.unitContributions(_contributor));
322 
323         if (contributed == 0) {
324             if (secondAddress == 0) {
325                 return true;
326             } else {
327                 contributed = sale.unitContributions(secondAddress).add(saft.unitContributions(secondAddress));
328             }
329         }
330 
331 
332         uint256 tokensStaked = registry.totalStaked(_contributor).add(signaling.totalStaked(_contributor));
333         uint256 PoICreated = registry.numApplications(_contributor).add(signaling.numApplications(_contributor));
334 
335         if (secondAddress != 0) {
336             tokensStaked = tokensStaked.add(registry.totalStaked(secondAddress)).add(signaling.totalStaked(secondAddress));
337             PoICreated = PoICreated.add(registry.numApplications(secondAddress)).add(signaling.numApplications(secondAddress));
338         }
339 
340         uint256 tokensBought = contributed.mul(saleTokensPerUnit.add(extraTokensPerUnit));
341 
342         bool enoughStaked;
343         if (contributed <= 10000) {
344             enoughStaked = tokensStaked >= tokensBought.mul(25).div(100);
345         } else {
346             enoughStaked = tokensStaked >= tokensBought.mul(50).div(100);
347         }
348 
349         bool isComplete = enoughStaked && PoICreated >= 10;
350         if (isComplete == true) {
351           pouCompleted[_contributor] = true;
352           if (secondAddress != address(0)) {
353             pouCompleted[secondAddress] = true;
354           }
355           emit PoUCompleted(_contributor, secondAddress, isComplete);
356         }
357 
358         return isComplete;
359     }
360 }