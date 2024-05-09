1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: contracts/library/Withdrawable.sol
114 
115 abstract contract Withdrawable {
116     address internal _withdrawAddress;
117 
118     constructor(address withdrawAddress__) {
119         _withdrawAddress = withdrawAddress__;
120     }
121 
122     modifier onlyWithdrawer() {
123         require(msg.sender == _withdrawAddress);
124         _;
125     }
126 
127     function withdraw() external onlyWithdrawer {
128         _withdraw();
129     }
130 
131     function _withdraw() internal {
132         payable(_withdrawAddress).transfer(address(this).balance);
133     }
134 
135     function setWithdrawAddress(address newWithdrawAddress)
136         external
137         onlyWithdrawer
138     {
139         _withdrawAddress = newWithdrawAddress;
140     }
141 
142     function withdrawAddress() external view returns (address) {
143         return _withdrawAddress;
144     }
145 }
146 // File: contracts/library/IMintableNft.sol
147 
148 interface IMintableNft {
149     function mint(address to) external;
150 }
151 
152 // File: contracts/library/Factory.sol
153 
154 
155 
156 
157 
158 contract Factory is Ownable, Withdrawable {
159     IMintableNft public nft;
160     uint256 public pricePpm;
161     bool whiteListEnabled = true;
162     mapping(address => bool) whiteList;
163 
164     constructor(address nftAddress, uint256 pricePpm_)
165         Withdrawable(msg.sender)
166     {
167         nft = IMintableNft(nftAddress);
168         pricePpm = pricePpm_;
169     }
170 
171     function mint(address to, uint256 count) external payable {
172         if (whiteListEnabled) {
173             require(
174                 whiteList[msg.sender],
175                 "mint enable only for whitelist at moment"
176             );
177         }
178         uint256 needPriice = pricePpm * 1e15 * count;
179         require(msg.value >= needPriice, "not enough ether value");
180         for (uint256 i = 0; i < count; ++i) nft.mint(to);
181     }
182 
183     function setPrice(uint256 newPricePpm) external onlyOwner {
184         pricePpm = newPricePpm;
185     }
186 
187     function setWhiteListEnabled(bool enabled) external onlyOwner {
188         whiteListEnabled = enabled;
189     }
190 
191     function addToWhiteList(address[] memory accounts) external onlyOwner {
192         for (uint256 i = 0; i < accounts.length; ++i) {
193             whiteList[accounts[i]] = true;
194         }
195     }
196 
197     function removeFromWhiteList(address[] memory accounts) external onlyOwner {
198         for (uint256 i = 0; i < accounts.length; ++i) {
199             whiteList[accounts[i]] = false;
200         }
201     }
202 }
203 
204 // File: contracts/FastFoodTrader/FastFoodTradersFactory.sol
205 
206 
207 
208 contract FastFoodTradersFactory is Factory {
209     constructor(address nftAddress) Factory(nftAddress, 100) {}
210 }