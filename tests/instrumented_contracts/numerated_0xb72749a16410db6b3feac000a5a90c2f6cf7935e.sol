1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/Context.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: contracts/Ownable.sol
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(
101             newOwner != address(0),
102             "Ownable: new owner is the zero address"
103         );
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 // File: contracts/FriendtechShares.sol
119 
120 pragma solidity >=0.8.2 <0.9.0;
121 
122 // TODO: Events, final pricing model,
123 
124 contract iso3166SharesV1 is Ownable {
125     address public protocolFeeDestination;
126     uint256 public protocolFeePercent = 50000000000000000;
127     uint256 public subjectFeePercent = 50000000000000000;
128 
129     event Trade(
130         address trader,
131         uint256 subject,
132         bool isBuy,
133         uint256 shareAmount,
134         uint256 ethAmount,
135         uint256 protocolEthAmount,
136         uint256 subjectEthAmount,
137         uint256 supply
138     );
139 
140     // SharesSubject => (Holder => Balance)
141     mapping(uint256 => mapping(address => uint256)) public sharesBalance;
142 
143     // SharesSubject => Supply
144     mapping(uint256 => uint256) public sharesSupply;
145     mapping(address => address) public invite;
146 
147     function setFeeDestination(address _feeDestination) public onlyOwner {
148         protocolFeeDestination = _feeDestination;
149     }
150 
151     function setProtocolFeePercent(uint256 _feePercent) public onlyOwner {
152         protocolFeePercent = _feePercent;
153     }
154 
155     function setSubjectFeePercent(uint256 _feePercent) public onlyOwner {
156         subjectFeePercent = _feePercent;
157     }
158 
159     function register(address _inviter) public {
160         require(invite[msg.sender] == address(0), "Error: Repeat binding");
161         require(_inviter != msg.sender, "Error: Binding self");
162         require(
163             _inviter != address(0),
164             "Error: Binding inviter is zero address"
165         );
166 
167         require(
168             invite[_inviter] != msg.sender,
169             "Error: Do not allow mutual binding"
170         );
171         invite[msg.sender] = _inviter;
172     }
173 
174     function getPrice(
175         uint256 supply,
176         uint256 amount
177     ) public pure returns (uint256) {
178         uint256 sum1 = supply == 0
179             ? 0
180             : ((supply - 1) * (supply) * (2 * (supply - 1) + 1)) / 6;
181         uint256 sum2 = supply == 0 && amount == 1
182             ? 0
183             : ((supply - 1 + amount) *
184                 (supply + amount) *
185                 (2 * (supply - 1 + amount) + 1)) / 6;
186         uint256 summation = sum2 - sum1;
187         return (summation * 1 ether) / 16000;
188     }
189 
190     function getBuyPrice(
191         uint256 sharesSubject,
192         uint256 amount
193     ) public view returns (uint256) {
194         return getPrice(sharesSupply[sharesSubject], amount);
195     }
196 
197     function getSellPrice(
198         uint256 sharesSubject,
199         uint256 amount
200     ) public view returns (uint256) {
201         return getPrice(sharesSupply[sharesSubject] - amount, amount);
202     }
203 
204     function getBuyPriceAfterFee(
205         uint256 sharesSubject,
206         uint256 amount
207     ) public view returns (uint256) {
208         uint256 price = getBuyPrice(sharesSubject, amount);
209         uint256 protocolFee = (price * protocolFeePercent) / 1 ether;
210         uint256 subjectFee = (price * subjectFeePercent) / 1 ether;
211         return price + protocolFee + subjectFee;
212     }
213 
214     function getSellPriceAfterFee(
215         uint256 sharesSubject,
216         uint256 amount
217     ) public view returns (uint256) {
218         uint256 price = getSellPrice(sharesSubject, amount);
219         uint256 protocolFee = (price * protocolFeePercent) / 1 ether;
220         uint256 subjectFee = (price * subjectFeePercent) / 1 ether;
221         return price - protocolFee - subjectFee;
222     }
223 
224     function buyShares(uint256 sharesSubject, uint256 amount) public payable {
225         uint256 supply = sharesSupply[sharesSubject];
226         uint256 price = getPrice(supply, amount);
227         uint256 protocolFee = (price * protocolFeePercent) / 1 ether;
228         uint256 subjectFee = (price * subjectFeePercent) / 1 ether;
229         require(
230             msg.value >= price + protocolFee + subjectFee,
231             "Insufficient payment"
232         );
233 
234         sharesBalance[sharesSubject][msg.sender] =
235             sharesBalance[sharesSubject][msg.sender] +
236             amount;
237         sharesSupply[sharesSubject] = supply + amount;
238         emit Trade(
239             msg.sender,
240             sharesSubject,
241             true,
242             amount,
243             price,
244             protocolFee,
245             subjectFee,
246             supply + amount
247         );
248         (bool success1, ) = protocolFeeDestination.call{value: protocolFee}("");
249         if (invite[msg.sender] != address(0)) {
250             (bool success2, ) = invite[msg.sender].call{value: subjectFee}("");
251             require(success1 && success2, "Unable to send funds");
252         } else {
253             (bool success2, ) = protocolFeeDestination.call{value: subjectFee}(
254                 ""
255             );
256             require(success1 && success2, "Unable to send funds");
257         }
258     }
259 
260     function sellShares(uint256 sharesSubject, uint256 amount) public payable {
261         uint256 supply = sharesSupply[sharesSubject];
262         require(supply > amount, "Cannot sell the last share");
263         uint256 price = getPrice(supply - amount, amount);
264         uint256 protocolFee = (price * protocolFeePercent) / 1 ether;
265         uint256 subjectFee = (price * subjectFeePercent) / 1 ether;
266         require(
267             sharesBalance[sharesSubject][msg.sender] >= amount,
268             "Insufficient shares"
269         );
270         sharesBalance[sharesSubject][msg.sender] =
271             sharesBalance[sharesSubject][msg.sender] -
272             amount;
273 
274         sharesSupply[sharesSubject] = supply - amount;
275         emit Trade(
276             msg.sender,
277             sharesSubject,
278             false,
279             amount,
280             price,
281             protocolFee,
282             subjectFee,
283             supply - amount
284         );
285         (bool success1, ) = msg.sender.call{
286             value: price - protocolFee - subjectFee
287         }("");
288         (bool success2, ) = protocolFeeDestination.call{value: protocolFee}("");
289         if (invite[msg.sender] != address(0)) {
290             (bool success3, ) = invite[msg.sender].call{value: subjectFee}("");
291             require(success1 && success2 && success3, "Unable to send funds");
292         } else {
293             (bool success3, ) = protocolFeeDestination.call{value: subjectFee}(
294                 ""
295             );
296             require(success1 && success2 && success3, "Unable to send funds");
297         }
298     }
299 }