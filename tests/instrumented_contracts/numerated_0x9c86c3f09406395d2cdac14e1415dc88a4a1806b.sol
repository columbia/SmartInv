1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
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
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: contracts/HowlStore.sol
101 
102 
103 pragma solidity ^0.8.2;
104 
105 
106 interface IHowl {
107     function equipProperties(
108         address _caller,
109         uint256 _tokenId,
110         uint16[8] calldata _w
111     ) external;
112 }
113 
114 interface ISoul {
115     function mint(address _address, uint256 _amount) external;
116 
117     function collectAndBurn(address _address, uint256 _amount) external;
118 }
119 
120 contract HowlStore is Ownable {
121     constructor(address _howlContractAddress, address _soulContractAddress)
122         Ownable()
123     {
124         howlContractAddress = _howlContractAddress;
125         soulContractAddress = _soulContractAddress;
126     }
127 
128     address public howlContractAddress;
129     address public soulContractAddress;
130 
131     function setHowlContractAddress(address _address) external onlyOwner {
132         howlContractAddress = _address;
133     }
134 
135     function setSoulContractAddress(address _address) external onlyOwner {
136         soulContractAddress = _address;
137     }
138 
139     event StorePurchase(
140         uint256 indexed _tokenId,
141         address indexed _address,
142         uint16[8] _properties,
143         uint16 _remainingQty
144     );
145 
146     struct StoreItem {
147         uint16[8] properties;
148         uint16 qty;
149         uint128 soulPrice;
150     }
151 
152     mapping(uint256 => StoreItem) public store;
153 
154     function addStoreItem(
155         uint256 _slot,
156         uint16[8] calldata properties,
157         uint16 _qty,
158         uint128 _soulPrice
159     ) external onlyOwner {
160         store[_slot] = StoreItem(properties, _qty, _soulPrice);
161     }
162 
163     function deleteStoreItems(uint256[] calldata _slotsToDelete)
164         external
165         onlyOwner
166     {
167         for (uint256 i = 0; i < _slotsToDelete.length; i++) {
168             delete store[_slotsToDelete[i]];
169         }
170     }
171 
172     function buyStoreItem(uint256 _tokenId, uint256 _slot) external {
173         StoreItem storage item = store[_slot];
174 
175         require(item.qty > 0, "HOWL Store: item is sold out or doesn't exist");
176         item.qty -= 1;
177 
178         ISoul(soulContractAddress).collectAndBurn(msg.sender, item.soulPrice);
179         IHowl(howlContractAddress).equipProperties(
180             msg.sender, // howl will verify that this address owns the token
181             _tokenId,
182             item.properties
183         );
184 
185         emit StorePurchase(_tokenId, msg.sender, item.properties, item.qty);
186     }
187 }