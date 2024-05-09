1 pragma solidity ^0.4.25;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     function balanceOf(address who) constant public returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 
16 contract ERC20 is ERC20Basic {
17     function allowance(address owner, address spender) constant public returns (uint256);
18     function transferFrom(address from, address to, uint256 value) public  returns (bool);
19     function approve(address spender, uint256 value) public returns (bool);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (_a == 0) {
39       return 0;
40     }
41 
42     c = _a * _b;
43     assert(c / _a == _b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // assert(_b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54     return _a / _b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 
76 
77 contract Ownable {
78     
79     address public owner;
80 
81     /**
82      * The address whcih deploys this contrcat is automatically assgined ownership.
83      * */
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     /**
89      * Functions with this modifier can only be executed by the owner of the contract. 
90      * */
91     modifier onlyOwner {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     event OwnershipTransferred(address indexed from, address indexed to);
97 
98     /**
99     * Transfers ownership to new Ethereum address. This function can only be called by the 
100     * owner.
101     * @param _newOwner the address to be granted ownership.
102     **/
103     function transferOwnership(address _newOwner) public onlyOwner {
104         require(_newOwner != 0x0);
105         emit OwnershipTransferred(owner, _newOwner);
106         owner = _newOwner;
107     }
108 }
109 
110 
111 
112 contract Memberships is Ownable {
113     
114     using SafeMath for uint256;
115     
116     
117     uint256 private numOfMembers;
118     uint256 private maxGramsPerMonth;
119     uint256 private monthNo;
120     ERC20 public ELYC;
121     
122     
123     constructor() public {
124         maxGramsPerMonth = 60;
125         ELYC = ERC20(0xFD96F865707ec6e6C0d6AfCe1f6945162d510351); 
126     }
127     
128     
129     /**
130      * MAPPINGS
131      * */
132     mapping (address => uint256) private memberIdByAddr;
133     mapping (uint256 => address) private memberAddrById;
134     mapping (address => bool) private addrIsMember;
135     mapping (address => mapping (uint256 => uint256)) private memberPurchases;
136     mapping (address => bool) private blacklist;
137     
138     
139     /**
140      * EVENTS
141      * */
142     event MaxGramsPerMonthChanged(uint256 from, uint256 to);
143     event MemberBlacklisted(address indexed addr, uint256 indexed id, uint256 block);
144     event MemberRemovedFromBlacklist(address indexed addr, uint256 indexed id, uint256 block);
145     event NewMemberAdded(address indexed addr, uint256 indexed id, uint256 block);
146     event CannabisPurchaseMade(address indexed by, uint256 milligrams, uint256 price, address indexed vendor, uint256 block);
147     event PurchaseMade(address indexed by, uint256 _price, address indexed _vendor, uint256 block);
148     event MonthNumberIncremented(uint256 block);
149     
150     
151     /**
152      * MODIFIERS
153      * */
154      modifier onlyMembers {
155          require(
156              addressHasMembership(msg.sender)
157              && !memberIsBlacklisted(msg.sender)
158              );
159          _;
160      }
161 
162     
163     
164     /**
165      * GETTERS
166      * */
167      
168     /**
169      * @return The current number of months the contract has been running for
170      * */
171      function getMonthNo() public view returns(uint256) {
172          return monthNo;
173      }
174      
175     /**
176      * @return The total amount of members 
177      * */
178     function getNumOfMembers() public view returns(uint256) {
179         return numOfMembers;
180     }
181     
182     
183     /**
184      * @return The maximum grams of cannabis each member can buy per month
185      * */
186     function getMaxGramsPerMonth() public view returns(uint256) {
187         return maxGramsPerMonth;
188     }
189     
190     
191     /**
192      * @param _addr The address which is being queried for membership
193      * @return true if the address is a member, false otherwise
194      * */
195     function addressHasMembership(address _addr) public view returns(bool) {
196         return addrIsMember[_addr];
197     }
198     
199     
200     /**
201      * @param _addr The address associated with a member ID (if any).
202      * @return The member ID if it exists, 0 otherwise
203      * */
204     function getMemberIdByAddr(address _addr) public view returns(uint256) {
205         return memberIdByAddr[_addr];
206     }
207     
208     
209     /**
210      * @param _id The ID associated with a member address (if any).
211      * @return The member address if it exists, 0x00...00 otherwise.
212      * */
213     function getMemberAddrById(uint256 _id) public view returns(address) {
214         return memberAddrById[_id];
215     }
216     
217     
218     /**
219      * @param _addr The address which is being checked if it is on the blacklist
220      * @return true if the address is on the blacklist, false otherwise
221      * */
222     function memberIsBlacklisted(address _addr) public view returns(bool) {
223         return blacklist[_addr];
224     }
225     
226     
227     /**
228      * @param _addr The address for which is being checked how many milligrams the address owner
229      * (i.e. the registered member) can buy.
230      * @return The total amount of milligrams the address owner can buy.
231      * */
232     function getMilligramsMemberCanBuy(address _addr) public view returns(uint256) {
233         uint256 milligrams = memberPurchases[_addr][monthNo];
234         if(milligrams >= maxGramsPerMonth.mul(1000)) {
235             return 0;
236         } else {
237             return (maxGramsPerMonth.mul(1000)).sub(milligrams);
238         }
239     }
240     
241     
242 
243     /**
244      * @param _id The member ID for which is being checked how many milligrams the ID owner
245      * (i.e. the registered member) can buy.
246      * @return The total amount of milligrams the ID owner can buy.
247      * */
248     function getMilligramsMemberCanBuy(uint256 _id) public view returns(uint256) {
249         uint256 milligrams = memberPurchases[getMemberAddrById(_id)][monthNo];
250         if(milligrams >= maxGramsPerMonth.mul(1000)) {
251             return 0;
252         } else {
253             return (maxGramsPerMonth.mul(1000)).sub(milligrams);
254         }
255     }
256 
257 
258     
259     /**
260      * ONLY MEMBER FUNCTIONS
261      * */
262      
263      /**
264       * Allows members to buy cannabis.
265       * @param _price The total amount of ELYC tokens that should be paid.
266       * @param _milligrams The total amount of milligrams which is being purchased 
267       * @param _vendor The vendors address 
268       * @return true if the function executes successfully, false otherwise
269       * */
270     function buyCannabis(uint256 _price, uint256 _milligrams, address _vendor) public onlyMembers returns(bool) {
271         require(_milligrams > 0 && _price > 0 && _vendor != address(0));
272         require(_milligrams <= getMilligramsMemberCanBuy(msg.sender));
273         ELYC.transferFrom(msg.sender, _vendor, _price);
274         memberPurchases[msg.sender][monthNo] = memberPurchases[msg.sender][monthNo].add(_milligrams);
275         emit CannabisPurchaseMade(msg.sender, _milligrams, _price, _vendor, block.number);
276         return true;
277     }
278     
279     
280     
281     /**
282      * ONLY OWNER FUNCTIONS
283      * */
284      
285     /**
286      * Allows the owner of this contract to add new members.
287      * @param _addr The address of the new member. 
288      * @return true if the function executes successfully, false otherwise.
289      * */
290     function addMember(address _addr) public onlyOwner returns(bool) {
291         require(!addrIsMember[_addr]);
292         addrIsMember[_addr] = true;
293         numOfMembers += 1;
294         memberIdByAddr[_addr] = numOfMembers;
295         memberAddrById[numOfMembers] = _addr;
296         emit NewMemberAdded(_addr, numOfMembers, block.number);
297         //assignment of owner variable made to overcome bug found in EVM which 
298         //caused the owner address to overflow to 0x00...01
299         owner = msg.sender;
300         return true;
301     }
302     
303     
304     /**
305      * Allows the owner to change the maximum amount of grams which members can buy 
306      * each month. 
307      * @param _newMax The new maximum amount of grams 
308      * @return true if the function executes successfully, false otherwise.
309      * */
310     function setMaxGramsPerMonth(uint256 _newMax) public onlyOwner returns(bool) {
311         require(_newMax != maxGramsPerMonth && _newMax > 0);
312         emit MaxGramsPerMonthChanged(maxGramsPerMonth, _newMax);
313         maxGramsPerMonth = _newMax;
314         return true;
315     }
316     
317     
318     /**
319      * Allows the owner to add members to the blacklist using the member's address
320      * @param _addr The address of the member who is to be blacklisted
321      * @return true if the function executes successfully, false otherwise.
322      * */
323     function addMemberToBlacklist(address _addr) public onlyOwner returns(bool) {
324         emit MemberBlacklisted(_addr, getMemberIdByAddr(_addr), block.number);
325         blacklist[_addr] = true;
326         return true;
327     }
328     
329     
330     /**
331      * Allows the owner to add members to the blacklist using the member's ID
332      * @param _id The ID of the member who is to be blacklisted.
333      * @return true if the function executes successfully, false otherwise.
334      * */
335     function addMemberToBlacklist(uint256 _id) public onlyOwner returns(bool) {
336         emit MemberBlacklisted(getMemberAddrById(_id), _id, block.number);
337         blacklist[getMemberAddrById(_id)] = true;
338         return true;
339     }
340     
341     
342     /**
343      * Allows the owner to remove members from the blacklist using the member's address. 
344      * @param _addr The address of the member who is to be removed from the blacklist. 
345      * @return true if the function executes successfully, false otherwise.
346      * */
347     function removeMemberFromBlacklist(address _addr) public onlyOwner returns(bool) {
348         emit MemberRemovedFromBlacklist(_addr, getMemberIdByAddr(_addr), block.number);
349         blacklist[_addr] = false;
350         return true;
351     }
352     
353     
354     /**
355      * Allows the owner to remove members from the blacklist using the member's ID.
356      * @param _id The ID of the member who is to be removed from the blacklist.
357      * @return true if the function executes successfully, false otherwise.
358      * */
359     function removeMemberFromBlacklist(uint256 _id) public onlyOwner returns(bool) {
360         emit MemberRemovedFromBlacklist(getMemberAddrById(_id), _id, block.number);
361         blacklist[getMemberAddrById(_id)] = false;
362         return true;
363     }
364     
365     
366     /**
367      * Allows the owner to withdraw any ERC20 token which may have been sent to this 
368      * contract address by mistake. 
369      * @param _addressOfToken The contract address of the ERC20 token
370      * @param _recipient The receiver of the token. 
371      * */
372     function withdrawAnyERC20(address _addressOfToken, address _recipient) public onlyOwner {
373         ERC20 token = ERC20(_addressOfToken);
374         token.transfer(_recipient, token.balanceOf(address(this)));
375     }
376     
377     
378     /**
379      * Allows the owner to update the monnth on the contract
380      * */
381     function incrementMonthNo() public onlyOwner {
382         emit MonthNumberIncremented(now);
383         monthNo = monthNo.add(1);
384     }
385 }