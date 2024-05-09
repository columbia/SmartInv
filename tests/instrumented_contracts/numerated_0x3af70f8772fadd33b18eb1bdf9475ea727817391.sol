1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ERC20Basic {
37     uint256 public totalSupply;
38 
39     function balanceOf(address who) public view returns (uint256);
40 
41     function transfer(address to, uint256 value) public returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ReferTokenERC20Basic is ERC20Basic {
47     using SafeMath for uint256;
48 
49     mapping(address => uint256) depositBalances;
50     mapping(address => uint256) rewardBalances;
51 
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         require(_to != address(0));
54         require(_value <= rewardBalances[msg.sender]);
55 
56         // SafeMath.sub will throw an error if there is not enough balance.
57         rewardBalances[msg.sender] = rewardBalances[msg.sender].sub(_value);
58         rewardBalances[_to] = rewardBalances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return rewardBalances[_owner];
65     }
66 }
67 
68 contract Ownable {
69     address public owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75      * account.
76      */
77     function Ownable() public {
78         owner = msg.sender;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         require(newOwner != address(0));
95         OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97     }
98 }
99 
100 contract MintableToken is Ownable {
101     event Mint(address indexed to, uint256 amount);
102     event MintFinished();
103 
104     bool public mintingFinished = false;
105 
106 
107     modifier canMint() {
108         require(!mintingFinished);
109         _;
110     }
111 
112     /**
113      * @dev Function to stop minting new tokens.
114      * @return True if the operation was successful.
115      */
116     function finishMinting() onlyOwner canMint public returns (bool) {
117         mintingFinished = true;
118         MintFinished();
119         return true;
120     }
121 }
122 
123 contract PackageContract is ReferTokenERC20Basic, MintableToken {
124     uint constant daysPerMonth = 30;
125     mapping(uint => mapping(string => uint256)) internal packageType;
126 
127     struct Package {
128         uint256 since;
129         uint256 tokenValue;
130         uint256 kindOf;
131     }
132 
133     mapping(address => Package) internal userPackages;
134 
135     function PackageContract() public {
136         packageType[2]['fee'] = 30;
137         packageType[2]['reward'] = 20;
138         packageType[4]['fee'] = 35;
139         packageType[4]['reward'] = 25;
140     }
141 
142     function depositMint(address _to, uint256 _amount, uint _kindOfPackage) canMint internal returns (bool) {
143         return depositMintSince(_to, _amount, _kindOfPackage, now);
144     }
145 
146     function depositMintSince(address _to, uint256 _amount, uint _kindOfPackage, uint since) canMint internal returns (bool) {
147         totalSupply = totalSupply.add(_amount);
148         Package memory pac;
149         pac = Package({since : since, tokenValue : _amount, kindOf : _kindOfPackage});
150         Mint(_to, _amount);
151         Transfer(address(0), _to, _amount);
152         userPackages[_to] = pac;
153         return true;
154     }
155 
156     function depositBalanceOf(address _owner) public view returns (uint256 balance) {
157         return userPackages[_owner].tokenValue;
158     }
159 
160     function getKindOfPackage(address _owner) public view returns (uint256) {
161         return userPackages[_owner].kindOf;
162     }
163 
164 }
165 
166 contract ColdWalletToken is PackageContract {
167     address internal coldWalletAddress;
168     uint internal percentageCW = 30;
169 
170     event CWStorageTransferred(address indexed previousCWAddress, address indexed newCWAddress);
171     event CWPercentageChanged(uint previousPCW, uint newPCW);
172 
173     function setColdWalletAddress(address _newCWAddress) onlyOwner public {
174         require(_newCWAddress != coldWalletAddress && _newCWAddress != address(0));
175         CWStorageTransferred(coldWalletAddress, _newCWAddress);
176         coldWalletAddress = _newCWAddress;
177     }
178 
179     function getColdWalletAddress() onlyOwner public view returns (address) {
180         return coldWalletAddress;
181     }
182 
183     function setPercentageCW(uint _newPCW) onlyOwner public {
184         require(_newPCW != percentageCW && _newPCW < 100);
185         CWPercentageChanged(percentageCW, _newPCW);
186         percentageCW = _newPCW;
187     }
188 
189     function getPercentageCW() onlyOwner public view returns (uint) {
190         return percentageCW;
191     }
192 
193     function saveToCW() onlyOwner public {
194         coldWalletAddress.transfer(this.balance.mul(percentageCW).div(100));
195     }
196 }
197 
198 contract StatusContract is Ownable {
199 
200     mapping(uint => mapping(string => uint[])) internal statusRewardsMap;
201     mapping(address => uint) internal statuses;
202 
203     event StatusChanged(address participant, uint newStatus);
204 
205     function StatusContract() public {
206         statusRewardsMap[1]['deposit'] = [3, 2, 1];
207         statusRewardsMap[1]['refReward'] = [3, 1, 1];
208 
209         statusRewardsMap[2]['deposit'] = [7, 3, 1];
210         statusRewardsMap[2]['refReward'] = [5, 3, 1];
211 
212         statusRewardsMap[3]['deposit'] = [10, 3, 1, 1, 1];
213         statusRewardsMap[3]['refReward'] = [7, 3, 3, 1, 1];
214 
215         statusRewardsMap[4]['deposit'] = [10, 5, 3, 3, 1];
216         statusRewardsMap[4]['refReward'] = [10, 5, 3, 3, 3];
217 
218         statusRewardsMap[5]['deposit'] = [12, 5, 3, 3, 3];
219         statusRewardsMap[5]['refReward'] = [10, 7, 5, 3, 3];
220     }
221 
222     function getStatusOf(address participant) public view returns (uint) {
223         return statuses[participant];
224     }
225 
226     function setStatus(address participant, uint8 status) public onlyOwner returns (bool) {
227         return setStatusInternal(participant, status);
228     }
229 
230     function setStatusInternal(address participant, uint8 status) internal returns (bool) {
231         require(statuses[participant] != status && status > 0 && status <= 5);
232         statuses[participant] = status;
233         StatusChanged(participant, status);
234         return true;
235     }
236 }
237 
238 contract ReferTreeContract is Ownable {
239     mapping(address => address) public referTree;
240 
241     event TreeStructChanged(address sender, address parentSender);
242 
243     function checkTreeStructure(address sender, address parentSender) onlyOwner public {
244         setTreeStructure(sender, parentSender);
245     }
246 
247     function setTreeStructure(address sender, address parentSender) internal {
248         require(referTree[sender] == 0x0);
249         require(sender != parentSender);
250         referTree[sender] = parentSender;
251         TreeStructChanged(sender, parentSender);
252     }
253 }
254 
255 contract ReferToken is ColdWalletToken, StatusContract, ReferTreeContract {
256     string public constant name = "EtherState";
257     string public constant symbol = "ETHS";
258     uint256 public constant decimals = 18;
259     uint256 public totalSupply = 0;
260 
261     uint256 public constant hardCap = 10000000 * 1 ether;
262     mapping(address => uint256) private lastPayoutAddress;
263     uint private rate = 100;
264     uint public constant depth = 5;
265 
266     event RateChanged(uint previousRate, uint newRate);
267     event DataReceived(bytes data);
268     event RefererAddressReceived(address referer);
269 
270     function depositMintAndPay(address _to, uint256 _amount, uint _kindOfPackage) canMint private returns (bool) {
271         require(userPackages[_to].since == 0);
272         _amount = _amount.mul(rate);
273         if (depositMint(_to, _amount, _kindOfPackage)) {
274             payToReferer(_to, _amount, 'deposit');
275             lastPayoutAddress[_to] = now;
276         }
277     }
278 
279     function rewardMint(address _to, uint256 _amount) private returns (bool) {
280         rewardBalances[_to] = rewardBalances[_to].add(_amount);
281         Mint(_to, _amount);
282         Transfer(address(0), _to, _amount);
283         return true;
284     }
285 
286     function payToReferer(address sender, uint256 _amount, string _key) private {
287         address currentReferral = sender;
288         uint currentStatus = 0;
289         uint256 refValue = 0;
290 
291         for (uint level = 0; level < depth; ++level) {
292             currentReferral = referTree[currentReferral];
293             if (currentReferral == 0x0) {
294                 break;
295             }
296             currentStatus = statuses[currentReferral];
297             if (currentStatus < 3 && level >= 3) {
298                 continue;
299             }
300             refValue = _amount.mul(statusRewardsMap[currentStatus][_key][level]).div(100);
301             rewardMint(currentReferral, refValue);
302         }
303     }
304 
305     function AddressDailyReward(address rewarded) public {
306         require(lastPayoutAddress[rewarded] != 0 && (now - lastPayoutAddress[rewarded]).div(1 days) > 0);
307         uint256 n = (now - lastPayoutAddress[rewarded]).div(1 days);
308         uint256 refValue = 0;
309 
310         if (userPackages[rewarded].kindOf != 0) {
311             refValue = userPackages[rewarded].tokenValue.mul(n).mul(packageType[userPackages[rewarded].kindOf]['reward']).div(30).div(100);
312             rewardMint(rewarded, refValue);
313             payToReferer(rewarded, userPackages[rewarded].tokenValue, 'refReward');
314         }
315         if (n > 0) {
316             lastPayoutAddress[rewarded] = now;
317         }
318     }
319 
320     function() external payable {
321         require(totalSupply < hardCap);
322         coldWalletAddress.transfer(msg.value.mul(percentageCW).div(100));
323         bytes memory data = bytes(msg.data);
324         DataReceived(data);
325         address referer = getRefererAddress(data);
326         RefererAddressReceived(referer);
327         setTreeStructure(msg.sender, referer);
328         setStatusInternal(msg.sender, 1);
329         uint8 kind = getReferralPackageKind(data);
330         depositMintAndPay(msg.sender, msg.value, kind);
331     }
332 
333     function getRefererAddress(bytes data) private pure returns (address) {
334         if (data.length == 1 || data.length == 0) {
335             return address(0);
336         }
337         uint256 referer_address;
338         uint256 factor = 1;
339         for (uint i = 20; i > 0; i--) {
340             referer_address += uint8(data[i - 1]) * factor;
341             factor = factor * 256;
342         }
343         return address(referer_address);
344     }
345 
346     function getReferralPackageKind(bytes data) private pure returns (uint8) {
347         if (data.length == 0) {
348             return 4;
349         }
350         if (data.length == 1) {
351             return uint8(data[0]);
352         }
353         return uint8(data[20]);
354     }
355 
356     function withdraw() public {
357         require(userPackages[msg.sender].tokenValue != 0);
358         uint256 withdrawValue = userPackages[msg.sender].tokenValue.div(rate);
359         uint256 dateDiff = now - userPackages[msg.sender].since;
360         if (dateDiff < userPackages[msg.sender].kindOf.mul(30 days)) {
361             uint256 fee = withdrawValue.mul(packageType[userPackages[msg.sender].kindOf]['fee']).div(100);
362             withdrawValue = withdrawValue.sub(fee);
363             coldWalletAddress.transfer(fee);
364             userPackages[msg.sender].tokenValue = 0;
365         }
366         msg.sender.transfer(withdrawValue);
367     }
368 
369     function createRawDeposit(address sender, uint256 _value, uint d, uint since) onlyOwner public {
370         depositMintSince(sender, _value, d, since);
371     }
372 
373     function createDeposit(address sender, uint256 _value, uint d) onlyOwner public {
374         depositMintAndPay(sender, _value, d);
375     }
376 
377     function setRate(uint _newRate) onlyOwner public {
378         require(_newRate != rate && _newRate > 0);
379         RateChanged(rate, _newRate);
380         rate = _newRate;
381     }
382 
383     function getRate() public view returns (uint) {
384         return rate;
385     }
386 }