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
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     function balanceOf(address who) public view returns (uint256);
43 
44     function transfer(address to, uint256 value) public returns (bool);
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47 
48     function approve(address _spender, uint256 _value) public returns (bool success);
49 
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
51 }
52 
53 contract ReferTokenERC20Basic is ERC20Basic {
54     using SafeMath for uint256;
55 
56     mapping(address => uint256) rewardBalances;
57     mapping(address => mapping(address => uint256)) allow;
58 
59     function _transfer(address _from, address _to, uint256 _value) private returns (bool) {
60         require(_to != address(0));
61         require(_value <= rewardBalances[_from]);
62 
63         // SafeMath.sub will throw an error if there is not enough balance.
64         rewardBalances[_from] = rewardBalances[_from].sub(_value);
65         rewardBalances[_to] = rewardBalances[_to].add(_value);
66         Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         return _transfer(msg.sender, _to, _value);
72     }
73 
74     function balanceOf(address _owner) public view returns (uint256 balance) {
75         return rewardBalances[_owner];
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_from != msg.sender);
80         require(allow[_from][msg.sender] > _value || allow[_from][msg.sender] == _value);
81 
82         success = _transfer(_from, _to, _value);
83 
84         if (success) {
85             allow[_from][msg.sender] = allow[_from][msg.sender].sub(_value);
86         }
87 
88         return success;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allow[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94 
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
99         return allow[_owner][_spender];
100     }
101 
102 }
103 
104 contract Ownable {
105     address public owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     /**
110      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111      * account.
112      */
113     function Ownable() public {
114         owner = msg.sender;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         require(newOwner != address(0));
131         OwnershipTransferred(owner, newOwner);
132         owner = newOwner;
133     }
134 }
135 
136 contract MintableToken is Ownable {
137     event Mint(address indexed to, uint256 amount);
138     event MintFinished();
139 
140     bool public mintingFinished = false;
141 
142 
143     modifier canMint() {
144         require(!mintingFinished);
145         _;
146     }
147 
148     /**
149      * @dev Function to stop minting new tokens.
150      * @return True if the operation was successful.
151      */
152     function finishMinting() onlyOwner canMint public returns (bool) {
153         mintingFinished = true;
154         MintFinished();
155         return true;
156     }
157 }
158 
159 contract PackageContract is ReferTokenERC20Basic, MintableToken {
160     uint constant daysPerMonth = 30;
161     mapping(uint => mapping(string => uint256)) internal packageType;
162 
163     struct Package {
164         uint256 since;
165         uint256 tokenValue;
166         uint256 kindOf;
167     }
168 
169     mapping(address => Package) internal userPackages;
170 
171     function PackageContract() public {
172         packageType[2]['fee'] = 30;
173         packageType[2]['reward'] = 20;
174         packageType[4]['fee'] = 35;
175         packageType[4]['reward'] = 25;
176     }
177 
178     function depositMint(address _to, uint256 _amount, uint _kindOfPackage) canMint internal returns (bool) {
179         return depositMintSince(_to, _amount, _kindOfPackage, now);
180     }
181 
182     function depositMintSince(address _to, uint256 _amount, uint _kindOfPackage, uint since) canMint internal returns (bool) {
183         totalSupply = totalSupply.add(_amount);
184         Package memory pac;
185         pac = Package({since : since, tokenValue : _amount, kindOf : _kindOfPackage});
186         Mint(_to, _amount);
187         Transfer(address(0), _to, _amount);
188         userPackages[_to] = pac;
189         return true;
190     }
191 
192     function depositBalanceOf(address _owner) public view returns (uint256 balance) {
193         return userPackages[_owner].tokenValue;
194     }
195 
196     function getKindOfPackage(address _owner) public view returns (uint256) {
197         return userPackages[_owner].kindOf;
198     }
199 
200 }
201 
202 contract ColdWalletToken is PackageContract {
203     address internal coldWalletAddress;
204     uint internal percentageCW = 30;
205 
206     event CWStorageTransferred(address indexed previousCWAddress, address indexed newCWAddress);
207     event CWPercentageChanged(uint previousPCW, uint newPCW);
208 
209     function setColdWalletAddress(address _newCWAddress) onlyOwner public {
210         require(_newCWAddress != coldWalletAddress && _newCWAddress != address(0));
211         CWStorageTransferred(coldWalletAddress, _newCWAddress);
212         coldWalletAddress = _newCWAddress;
213     }
214 
215     function getColdWalletAddress() onlyOwner public view returns (address) {
216         return coldWalletAddress;
217     }
218 
219     function setPercentageCW(uint _newPCW) onlyOwner public {
220         require(_newPCW != percentageCW && _newPCW < 100);
221         CWPercentageChanged(percentageCW, _newPCW);
222         percentageCW = _newPCW;
223     }
224 
225     function getPercentageCW() onlyOwner public view returns (uint) {
226         return percentageCW;
227     }
228 
229     function saveToCW() onlyOwner public {
230         coldWalletAddress.transfer(this.balance.mul(percentageCW).div(100));
231     }
232 }
233 
234 contract StatusContract is Ownable {
235 
236     mapping(uint => mapping(string => uint[])) internal statusRewardsMap;
237     mapping(address => uint) internal statuses;
238 
239     event StatusChanged(address participant, uint newStatus);
240 
241     function StatusContract() public {
242         statusRewardsMap[1]['deposit'] = [3, 2, 1];
243         statusRewardsMap[1]['refReward'] = [3, 1, 1];
244 
245         statusRewardsMap[2]['deposit'] = [7, 3, 1];
246         statusRewardsMap[2]['refReward'] = [5, 3, 1];
247 
248         statusRewardsMap[3]['deposit'] = [10, 3, 1, 1, 1];
249         statusRewardsMap[3]['refReward'] = [7, 3, 3, 1, 1];
250 
251         statusRewardsMap[4]['deposit'] = [10, 5, 3, 3, 1];
252         statusRewardsMap[4]['refReward'] = [10, 5, 3, 3, 3];
253 
254         statusRewardsMap[5]['deposit'] = [12, 5, 3, 3, 3];
255         statusRewardsMap[5]['refReward'] = [10, 7, 5, 3, 3];
256     }
257 
258     function getStatusOf(address participant) public view returns (uint) {
259         return statuses[participant];
260     }
261 
262     function setStatus(address participant, uint8 status) public onlyOwner returns (bool) {
263         return setStatusInternal(participant, status);
264     }
265 
266     function setStatusInternal(address participant, uint8 status) internal returns (bool) {
267         require(statuses[participant] != status && status > 0 && status <= 5);
268         statuses[participant] = status;
269         StatusChanged(participant, status);
270         return true;
271     }
272 }
273 
274 contract ReferTreeContract is Ownable {
275     mapping(address => address) public referTree;
276 
277     event TreeStructChanged(address sender, address parentSender);
278 
279     function checkTreeStructure(address sender, address parentSender) onlyOwner public {
280         setTreeStructure(sender, parentSender);
281     }
282 
283     function setTreeStructure(address sender, address parentSender) internal {
284         require(referTree[sender] == 0x0);
285         require(sender != parentSender);
286         referTree[sender] = parentSender;
287         TreeStructChanged(sender, parentSender);
288     }
289 }
290 
291 contract ReferToken is ColdWalletToken, StatusContract, ReferTreeContract {
292     string public constant name = "EtherState";
293     string public constant symbol = "ETHS";
294     uint256 public constant decimals = 18;
295     uint256 public totalSupply = 0;
296 
297     uint256 public constant hardCap = 10000000 * 1 ether;
298     mapping(address => uint256) private lastPayoutAddress;
299     uint private rate = 100;
300     uint public constant depth = 5;
301 
302     event RateChanged(uint previousRate, uint newRate);
303     event DataReceived(bytes data);
304     event RefererAddressReceived(address referer);
305 
306     function depositMintAndPay(address _to, uint256 _amount, uint _kindOfPackage) canMint private returns (bool) {
307         require(userPackages[_to].since == 0);
308         _amount = _amount.mul(rate);
309         if (depositMint(_to, _amount, _kindOfPackage)) {
310             payToReferer(_to, _amount, 'deposit');
311             lastPayoutAddress[_to] = now;
312         }
313     }
314 
315     function rewardMint(address _to, uint256 _amount) private returns (bool) {
316         rewardBalances[_to] = rewardBalances[_to].add(_amount);
317         Mint(_to, _amount);
318         Transfer(address(0), _to, _amount);
319         return true;
320     }
321 
322     function payToReferer(address sender, uint256 _amount, string _key) private {
323         address currentReferral = sender;
324         uint currentStatus = 0;
325         uint256 refValue = 0;
326 
327         for (uint level = 0; level < depth; ++level) {
328             currentReferral = referTree[currentReferral];
329             if (currentReferral == 0x0) {
330                 break;
331             }
332             currentStatus = statuses[currentReferral];
333             if (currentStatus < 3 && level >= 3) {
334                 continue;
335             }
336             refValue = _amount.mul(statusRewardsMap[currentStatus][_key][level]).div(100);
337             rewardMint(currentReferral, refValue);
338         }
339     }
340 
341     function AddressDailyReward(address rewarded) public {
342         require(lastPayoutAddress[rewarded] != 0 && (now - lastPayoutAddress[rewarded]).div(1 days) > 0);
343         uint256 n = (now - lastPayoutAddress[rewarded]).div(1 days);
344         uint256 refValue = 0;
345 
346         if (userPackages[rewarded].kindOf != 0) {
347             refValue = userPackages[rewarded].tokenValue.mul(n).mul(packageType[userPackages[rewarded].kindOf]['reward']).div(30).div(100);
348             rewardMint(rewarded, refValue);
349             payToReferer(rewarded, userPackages[rewarded].tokenValue, 'refReward');
350         }
351         if (n > 0) {
352             lastPayoutAddress[rewarded] = now;
353         }
354     }
355 
356     function() external payable {
357         require(totalSupply < hardCap);
358         coldWalletAddress.transfer(msg.value.mul(percentageCW).div(100));
359         bytes memory data = bytes(msg.data);
360         DataReceived(data);
361         address referer = getRefererAddress(data);
362         RefererAddressReceived(referer);
363         setTreeStructure(msg.sender, referer);
364         setStatusInternal(msg.sender, 1);
365         uint8 kind = getReferralPackageKind(data);
366         depositMintAndPay(msg.sender, msg.value, kind);
367     }
368 
369     function getRefererAddress(bytes data) private pure returns (address) {
370         if (data.length == 1 || data.length == 0) {
371             return address(0);
372         }
373         uint256 referer_address;
374         uint256 factor = 1;
375         for (uint i = 20; i > 0; i--) {
376             referer_address += uint8(data[i - 1]) * factor;
377             factor = factor * 256;
378         }
379         return address(referer_address);
380     }
381 
382     function getReferralPackageKind(bytes data) private pure returns (uint8) {
383         if (data.length == 0) {
384             return 4;
385         }
386         if (data.length == 1) {
387             return uint8(data[0]);
388         }
389         return uint8(data[20]);
390     }
391 
392     function withdraw() public {
393         require(userPackages[msg.sender].tokenValue != 0);
394         uint256 withdrawValue = userPackages[msg.sender].tokenValue.div(rate);
395         uint256 dateDiff = now - userPackages[msg.sender].since;
396         if (dateDiff < userPackages[msg.sender].kindOf.mul(30 days)) {
397             uint256 fee = withdrawValue.mul(packageType[userPackages[msg.sender].kindOf]['fee']).div(100);
398             withdrawValue = withdrawValue.sub(fee);
399             coldWalletAddress.transfer(fee);
400             userPackages[msg.sender].tokenValue = 0;
401         }
402         msg.sender.transfer(withdrawValue);
403     }
404 
405     function createRawDeposit(address sender, uint256 _value, uint d, uint since) onlyOwner public {
406         depositMintSince(sender, _value, d, since);
407     }
408 
409     function createDeposit(address sender, uint256 _value, uint d) onlyOwner public {
410         depositMintAndPay(sender, _value, d);
411     }
412 
413     function setRate(uint _newRate) onlyOwner public {
414         require(_newRate != rate && _newRate > 0);
415         RateChanged(rate, _newRate);
416         rate = _newRate;
417     }
418 
419     function getRate() public view returns (uint) {
420         return rate;
421     }
422 }