1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 pragma solidity ^0.4.24;
68 
69 contract Ownable {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76      * account.
77      */
78     constructor () internal {
79         _owner = msg.sender;
80         emit OwnershipTransferred(address(0), _owner);
81     }
82 
83     /**
84      * @return the address of the owner.
85      */
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(isOwner());
95         _;
96     }
97 
98     /**
99      * @return true if `msg.sender` is the owner of the contract.
100      */
101     function isOwner() public view returns (bool) {
102         return msg.sender == _owner;
103     }
104 
105     /**
106      * @dev Allows the current owner to relinquish control of the contract.
107      * @notice Renouncing to ownership will leave the contract without an owner.
108      * It will not be possible to call the functions with the `onlyOwner`
109      * modifier anymore.
110      */
111     function renounceOwnership() public onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116     /**
117      * @dev Allows the current owner to transfer control of the contract to a newOwner.
118      * @param newOwner The address to transfer ownership to.
119      */
120     function transferOwnership(address newOwner) public onlyOwner {
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function _transferOwnership(address newOwner) internal {
129         require(newOwner != address(0));
130         emit OwnershipTransferred(_owner, newOwner);
131         _owner = newOwner;
132     }
133 }
134 
135 pragma solidity ^0.4.24;
136 
137 contract EtherPornStarsVids is Ownable {
138   using SafeMath for uint256;
139   address public ownerAddress;
140   bool public commFree;
141   uint customComm;
142   uint vidComm;
143   uint tipComm;
144     // Boundaries for messages
145   uint8 constant playerMessageMaxLength = 64;
146   mapping(address => userAccount) public user;
147   mapping (address => uint) public spentDivs;
148   mapping (uint => address) public star;
149   mapping (uint => uint) public referrer;
150   event VideoBought(address _buyer, uint _videoId, uint _value, uint _refstarId);
151   event Funded(uint _starId, address _sender, string _message, uint _value, uint _refstarId);
152   event Tipped(uint _starId, address _sender, uint _value);
153   event SubscriptionBought(uint _starId, uint _tier, address _buyer, uint _value);
154   event StoreItemBought(uint _starId, uint _itemId, address _buyer, uint _value, uint _refstarId);
155   event CustomVidBought(uint _starId, address _sender, uint _cid, uint _value);
156   struct userAccount {
157     uint[] vidsOwned;
158     uint[3][] subscriptions;
159     uint epsPrime;
160   }
161   
162   constructor() public {
163       commFree = true;
164       customComm = 15;
165       vidComm = 10;
166       tipComm = 5;
167       ownerAddress = msg.sender;
168   }
169 
170   function tipStar(uint _starId) public payable {
171       require(msg.value >= 10000000000000000);
172       uint _commission = msg.value.div(tipComm);
173       uint _starShare = msg.value-_commission;
174       address starAddress = star[_starId];
175       require(starAddress != address(0));
176       starAddress.transfer(_starShare);
177       ownerAddress.transfer(_commission);
178       emit Tipped(_starId, msg.sender, msg.value);
179   }
180   
181     function fundStar(uint _starId, string _message) public payable {
182       bytes memory _messageBytes = bytes(_message);
183       require(msg.value >= 10000000000000000);
184       require(_messageBytes.length <= playerMessageMaxLength, "Too long");
185       uint _commission = msg.value.div(tipComm);
186       if (referrer[_starId] != 0) {
187           address _referrerAddress = star[referrer[_starId]];
188           uint _referralShare = msg.value.div(5);
189       }
190       uint _starShare = msg.value - _commission - _referralShare;
191       address _starAddress = star[_starId];
192       require(_starAddress != address(0));
193       _starAddress.transfer(_starShare);
194       _referrerAddress.transfer(_referralShare);
195       ownerAddress.transfer(_commission);
196       emit Funded(_starId, msg.sender, _message, msg.value, referrer[_starId]);
197   }
198   
199   function buySub(uint _starId, uint _tier) public payable {
200     require(msg.value >= 10000000000000000);
201     uint _commission = msg.value.div(vidComm);
202     uint _starShare = msg.value-_commission;
203     address _starAddress = star[_starId];
204     require(_starAddress != address(0));
205     _starAddress.transfer(_starShare);
206     ownerAddress.transfer(_commission);
207     user[msg.sender].subscriptions.push([_starId,_tier, msg.value]);
208     emit SubscriptionBought(_starId, _tier, msg.sender, msg.value);
209   }
210   
211   function buyVid(uint _videoId, uint _starId) public payable {
212     require(msg.value >= 10000000000000000);
213     if(!commFree){
214         uint _commission = msg.value.div(vidComm);
215     }
216     if (referrer[_starId] != 0) {
217           address _referrerAddress = star[referrer[_starId]];
218           uint _referralShare = msg.value.div(5);
219       }
220     uint _starShare = msg.value-_commission - _referralShare;
221     address _starAddress = star[_starId];
222     require(_starAddress != address(0));
223     _starAddress.transfer(_starShare);
224     _referrerAddress.transfer(_referralShare);
225     ownerAddress.transfer(_commission);
226     user[msg.sender].vidsOwned.push(_videoId);
227     emit VideoBought(msg.sender, _videoId, msg.value, referrer[_starId]);
228   }
229 
230   function buyStoreItem(uint _itemId, uint _starId) public payable {
231     require(msg.value >= 10000000000000000);
232     if(!commFree){
233         uint _commission = msg.value.div(vidComm);
234     }
235     if (referrer[_starId] != 0) {
236       address _referrerAddress = star[referrer[_starId]];
237       uint _referralShare = msg.value.div(5);
238     }
239     uint _starShare = msg.value-_commission-_referralShare;
240     address _starAddress = star[_starId];
241     require(_starAddress != address(0));
242     _starAddress.transfer(_starShare);
243     _referrerAddress.transfer(_referralShare);
244     ownerAddress.transfer(_commission);
245     emit StoreItemBought(_starId, _itemId, msg.sender,  msg.value, referrer[_starId]);
246   }
247   
248   function buyCustomVid(uint _starId, uint _cid) public payable {
249     require(msg.value >= 10000000000000000);
250     if(!commFree){
251         uint _commission = msg.value.div(customComm);
252     }
253     uint _starShare = msg.value-_commission;
254     address _starAddress = star[_starId];
255     require(_starAddress != address(0));
256     _starAddress.transfer(_starShare);
257     ownerAddress.transfer(_commission);
258     emit CustomVidBought(_starId, msg.sender, _cid, msg.value);
259   }
260   
261   function addStar(uint _starId, address _starAddress) public onlyOwner {
262     star[_starId] = _starAddress;
263   }
264 
265   function addReferrer(uint _starId, uint _referrerId) public onlyOwner {
266     referrer[_starId] = _referrerId;
267   }
268   
269   function commission(bool _commFree, uint _customcomm, uint _vidcomm, uint _tipcomm) public onlyOwner {
270     commFree = _commFree;
271     customComm = _customcomm;
272     vidComm = _vidcomm;
273     tipComm = _tipcomm;
274   }
275 }