1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _setOwner(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _setOwner(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _setOwner(newOwner);
90     }
91 
92     function _setOwner(address newOwner) private {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 // File: contracts/interface/MinterMintable.sol
100 
101 pragma solidity ^0.8.7;
102 
103 interface MinterMintable {
104     function isMinter(address check) external view returns (bool);
105     function mint(address owner) external returns (uint256);
106     function batchMint(address owner, uint256 amount) external returns (uint256[] memory);
107 }
108 
109 // File: contracts/OfficialSale.sol
110 
111 pragma solidity ^0.8.7;
112 
113 
114 
115 contract OfficialSale is Ownable {
116 
117     MinterMintable _minterMintable_;
118 
119     constructor(address ghettoSharkhoodAddress) {
120         _minterMintable_ = MinterMintable(ghettoSharkhoodAddress);
121     }
122 
123     function price() public view returns (uint256) {
124         if (block.timestamp <= whitelistUnlockAt()) return 0.085 ether;
125         
126         return 0.09 ether;
127     }
128 
129     function whitelistUnlockAt() public virtual pure returns (uint256) {
130         return 1639360800;
131     }
132 
133     // Whitelist
134 
135     struct buyerData {
136         uint256 cap; // the max number of NFT buyer can buy
137         uint256 bought; // the number of NFT buyer have bought
138     }
139 
140     mapping(address => buyerData) _buyers_;
141 
142     /**
143      * This purpose of this function is to check whether buyer can buy,
144      */
145     modifier onlyAllowedBuyer(uint256 amount) {
146 
147         /**
148          * only if block.timestamp less than whitelistUnlockAt will check buyer cap
149          */
150         if (block.timestamp <= whitelistUnlockAt()) {
151             require(
152                 _buyers_[msg.sender].bought < _buyers_[msg.sender].cap
153                 && _buyers_[msg.sender].bought + amount > _buyers_[msg.sender].bought
154                 && _buyers_[msg.sender].bought + amount <= _buyers_[msg.sender].cap, 
155                 "Presale: this address hasn't been added to whitelist."
156             );
157         }
158         
159         _;
160     }
161 
162     /**
163      * Set buyer cap, only owner can do this operation, and this function can be call before closing.
164      */
165     function setBuyerCap(address buyer, uint256 cap) public onlyOwner onlyOpened {
166         _buyers_[buyer].cap = cap;
167     }
168 
169     /**
170      * This function can help owner to add larger than one addresses cap.
171      */
172     function setBuyerCapBatch(address[] memory buyers, uint256[] memory amount) public onlyOwner onlyOpened {
173         require(buyers.length == amount.length, "Presale: buyers length and amount length not match");
174         require(buyers.length <= 100, "Presale: the max size of batch is 100.");
175 
176         for(uint256 i = 0; i < buyers.length; i ++) {
177             _buyers_[buyers[i]].cap = amount[i];
178         }
179     }
180 
181     function buyerCap(address buyer) public view returns (uint256) {
182         return _buyers_[buyer].cap;
183     }
184 
185     function buyerBought(address buyer) public view returns (uint256) {
186         return _buyers_[buyer].bought;
187     }
188 
189     // withdraw related functions
190 
191     function withdraw() public onlyOwner {
192         address payable receiver = payable(owner());
193         receiver.transfer(address(this).balance);
194     }
195 
196     // open and start control
197     bool _opened_ = true;
198     bool _started_ = false;
199 
200     modifier onlyOpened() {
201         require(_opened_, "Presale: presale has been closed.");
202         _;
203     }
204     
205     modifier onlyStart() {
206         require(_started_, "Presale: presale is not now.");
207         _;
208     }
209 
210     function start() public onlyOwner onlyOpened {
211         _started_ = true;
212     }
213 
214     function end() public onlyOwner onlyOpened {
215         _started_ = false;
216     }
217 
218     function close() public onlyOwner onlyOpened {
219         _started_ = false;
220         _opened_ = false;
221     }
222 
223     function started() public view returns (bool) {
224         return _started_;
225     }
226 
227     function opened() public view returns (bool) {
228         return _opened_;
229     }
230 
231     // Presale
232 
233     uint256 _sold_ = 0;
234 
235     /**
236      * Only pay larger than or equal to total price will
237      */
238     modifier onlyPayEnoughEth(uint256 amount) {
239         require(msg.value >= amount * price(), "Presale: please pay enough ETH to buy.");
240         _;
241     }
242 
243     /**
244      * Buy one NFT in one transaction
245      */
246     function buy() public payable 
247         onlyOpened
248         onlyStart
249         onlyAllowedBuyer(1) 
250         onlyPayEnoughEth(1)
251         returns (uint256) {
252         _sold_ += 1;
253         // if whitelist still active, add number of bought
254         _buyers_[msg.sender].bought += 1;
255         return _minterMintable_.mint(msg.sender);
256     }
257 
258     /**
259      * Buy numbers of NFT in one transaction.
260      * It will also increase the number of NFT buyer has bought.
261      */
262     function buyBatch(uint256 amount) public payable 
263         onlyOpened
264         onlyStart
265         onlyAllowedBuyer(amount) 
266         onlyPayEnoughEth(amount)
267         returns (uint256[] memory) {
268         require(amount <= 20, "Presale: batch size should less than 20.");
269         require(amount >= 1, "Presale: batch size should larger than 0.");
270         _sold_ += amount;
271         // if whitelist still active, add number of bought
272         _buyers_[msg.sender].bought += amount;
273         return _minterMintable_.batchMint(msg.sender, amount);
274     }
275 
276     /**
277      * Get the number of NFT has been sold during presale
278      */
279     function sold() public view returns (uint256) {
280         return _sold_;
281     }
282 
283 }