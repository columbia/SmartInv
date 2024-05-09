1 /*
2  * Ether PornStars Smart Contract.  Copyright © 2016–2019.
3  * <admin@etherpornstars.com>
4  */
5 
6 pragma solidity ^0.5.2;
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14      * @dev Multiplies two unsigned integers, reverts on overflow.
15      */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
32      */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 
42     /**
43      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Adds two unsigned integers, reverts on overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64      * reverts when dividing by zero.
65      */
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69     }
70 }
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 contract EtherPornStars is Ownable {
145   using SafeMath for uint256;
146   address payable public ownerAddress;
147   bool public commFree;
148   uint customComm;
149   uint vidComm;
150   uint tipComm;
151     // Boundaries for messages
152   uint8 constant playerMessageMaxLength = 64;
153   mapping(address => userAccount) public user;
154   mapping (uint => address payable) public star;
155   mapping (uint => uint) public referrer;
156   event VideoBought(uint _buyerId, uint _videoId, uint _value, uint _refstarId);
157   event Funded(uint _buyerId, uint _starId, string _message, uint _value, uint _refstarId);
158   event Tipped(uint _buyerId, uint _starId, uint _value);
159   event PrivateShow(uint _buyerId, uint _starId, uint _value);
160   event SubscriptionBought(uint _buyerId, uint _starId, uint _tier, uint _value);
161   event StoreItemBought(uint _buyerId, uint _starId, uint _itemId, uint _value, uint _refstarId);
162   event CustomVidBought(uint _buyerId, uint _starId,  uint _cid, uint _value);
163   event PremiumBought(uint _buyerId, uint _value);
164   struct userAccount {
165     uint[] vidsOwned;
166     uint[3][] subscriptions;
167     uint epsPremium;
168   }
169   
170   constructor() public {
171       commFree = true;
172       customComm = 10;
173       vidComm = 10;
174       tipComm = 5;
175       ownerAddress = msg.sender;
176   }
177 
178   function tipStar(uint _buyerId, uint _starId) public payable {
179       require(msg.value >= 10000000000000000);
180       uint _commission = msg.value.div(tipComm);
181       uint _starShare = msg.value-_commission;
182       address payable starAddress = star[_starId];
183       require(starAddress != address(0));
184       starAddress.transfer(_starShare);
185       ownerAddress.transfer(_commission);
186       emit Tipped(_buyerId, _starId, msg.value);
187   }
188   
189     function fundStar(uint _buyerId, uint _starId, string memory _message) public payable {
190       bytes memory _messageBytes = bytes(_message);
191       require(msg.value >= 10000000000000000);
192       require(_messageBytes.length <= playerMessageMaxLength, "Too long");
193       uint _commission = msg.value.div(tipComm);
194       address payable _referrerAddress;
195       uint _referralShare;
196       if (referrer[_starId] != 0) {
197           _referrerAddress = star[referrer[_starId]];
198           _referralShare = msg.value.div(5);
199       }
200       uint _starShare = msg.value - _commission - _referralShare;
201       address payable _starAddress = star[_starId];
202       require(_starAddress != address(0));
203       _starAddress.transfer(_starShare);
204       _referrerAddress.transfer(_referralShare);
205       ownerAddress.transfer(_commission);
206       emit Funded(_buyerId, _starId, _message, msg.value, referrer[_starId]);
207   }
208   
209     function buyPrivateShow(uint _buyerId, uint _starId) public payable {
210       require(msg.value >= 10000000000000000);
211       uint _commission = msg.value.div(vidComm);
212       uint _starShare = msg.value-_commission;
213       address payable starAddress = star[_starId];
214       require(starAddress != address(0));
215       starAddress.transfer(_starShare);
216       ownerAddress.transfer(_commission);
217       emit PrivateShow(_buyerId, _starId, msg.value);
218   }
219   
220   function buySub(uint _buyerId, uint _starId, uint _tier) public payable {
221     require(msg.value >= 10000000000000000);
222     require(_tier > 0 && _buyerId > 0);
223     uint _commission = msg.value.div(vidComm);
224     uint _starShare = msg.value-_commission;
225     address payable _starAddress = star[_starId];
226     require(_starAddress != address(0));
227     _starAddress.transfer(_starShare);
228     ownerAddress.transfer(_commission);
229     user[msg.sender].subscriptions.push([_starId,_tier, msg.value]);
230     emit SubscriptionBought(_buyerId, _starId, _tier, msg.value);
231   }
232   
233   function buyVid(uint _buyerId, uint _videoId, uint _starId) public payable {
234     require(msg.value >= 10000000000000000);
235     uint _commission = msg.value.div(vidComm);
236     if(commFree){
237         _commission = 0;
238     }
239     address payable _referrerAddress;
240     uint _referralShare;
241     if (referrer[_starId] != 0) {
242           _referrerAddress = star[referrer[_starId]];
243           _referralShare = msg.value.div(5);
244       }
245     uint _starShare = msg.value- _commission - _referralShare;
246     address payable _starAddress = star[_starId];
247     require(_starAddress != address(0));
248     _starAddress.transfer(_starShare);
249     _referrerAddress.transfer(_referralShare);
250     ownerAddress.transfer(_commission);
251     user[msg.sender].vidsOwned.push(_videoId);
252     emit VideoBought(_buyerId, _videoId, msg.value, referrer[_starId]);
253   }
254 
255   function buyStoreItem(uint _buyerId, uint _itemId, uint _starId) public payable {
256     require(msg.value >= 10000000000000000);
257     require(_itemId > 0 && _buyerId > 0);
258     uint _commission = msg.value.div(vidComm);
259     if(commFree){
260         _commission = 0;
261     }
262     uint _referralShare;
263     address payable _referrerAddress;
264     if (referrer[_starId] != 0) {
265           _referrerAddress = star[referrer[_starId]];
266           _referralShare = msg.value.div(5);
267       }
268     uint _starShare = msg.value- _commission-_referralShare;
269     address payable _starAddress = star[_starId];
270     require(_starAddress != address(0));
271     _starAddress.transfer(_starShare);
272     _referrerAddress.transfer(_referralShare);
273     ownerAddress.transfer(_commission);
274     emit StoreItemBought(_buyerId, _starId, _itemId,  msg.value, referrer[_starId]);
275   }
276   
277   function buyPremium(uint _buyerId) public payable {
278     require(msg.value >= 10000000000000000);
279     ownerAddress.transfer(msg.value);
280     emit PremiumBought(_buyerId, msg.value);
281   }
282   
283     function buyCustomVid(uint _buyerId, uint _starId, uint _cid) public payable {
284     require(msg.value >= 10000000000000000);
285     uint _commission = msg.value.div(customComm);
286     if(commFree){
287         _commission = 0;
288     }
289     uint _starShare = msg.value - _commission;
290     address payable _starAddress = star[_starId];
291     require(_starAddress != address(0));
292     _starAddress.transfer(_starShare);
293     ownerAddress.transfer(_commission);
294     emit CustomVidBought(_buyerId, _starId, _cid, msg.value);
295   }
296   
297   function addStar(uint _starId, address payable _starAddress) public onlyOwner {
298     star[_starId] = _starAddress;
299   }
300 
301   function addReferrer(uint _starId, uint _referrerId) public onlyOwner {
302     referrer[_starId] = _referrerId;
303   }
304   
305   function commission(bool _commFree, uint _customcomm, uint _vidcomm, uint _tipcomm) public onlyOwner {
306     commFree = _commFree;
307     customComm = _customcomm;
308     vidComm = _vidcomm;
309     tipComm = _tipcomm;
310   }
311 }