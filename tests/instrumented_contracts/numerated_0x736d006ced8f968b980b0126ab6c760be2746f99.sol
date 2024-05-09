1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /*
33  * @dev Provides information about the current execution context, including the
34  * sender of the transaction and its data. While these are generally available
35  * via msg.sender and msg.data, they should not be accessed in such a direct
36  * manner, since when dealing with GSN meta-transactions the account sending and
37  * paying for execution may not be the actual sender (as far as an application
38  * is concerned).
39  *
40  * This contract is only required for intermediate, library-like contracts.
41  */
42 contract Context {
43     // Empty internal constructor, to prevent people from mistakenly deploying
44     // an instance of this contract, which should be used via inheritance.
45     constructor () internal { }
46     // solhint-disable-previous-line no-empty-blocks
47 
48     function _msgSender() internal view returns (address payable) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view returns (bytes memory) {
53         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
54         return msg.data;
55     }
56 }
57 
58 /**
59  * @dev Contract module which provides a basic access control mechanism, where
60  * there is an account (an owner) that can be granted exclusive access to
61  * specific functions.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor () internal {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(isOwner(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Returns true if the caller is the current owner.
98      */
99     function isOwner() public view returns (bool) {
100         return _msgSender() == _owner;
101     }
102 
103     /**
104      * @dev Leaves the contract without owner. It will not be possible to call
105      * `onlyOwner` functions anymore. Can only be called by the current owner.
106      *
107      * NOTE: Renouncing ownership will leave the contract without an owner,
108      * thereby removing any functionality that is only available to the owner.
109      */
110     function renounceOwnership() public onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public onlyOwner {
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      */
126     function _transferOwnership(address newOwner) internal {
127         require(newOwner != address(0), "ownable: new owner is the zero address");
128         emit OwnershipTransferred(_owner, newOwner);
129         _owner = newOwner;
130     }
131 }
132 
133 interface SmolStudio {
134     function mint(address _to, uint256 _id, uint256 _quantity, bytes calldata _data) external;
135     function totalSupply(uint256 _id) external view returns (uint256);
136     function maxSupply(uint256 _id) external view returns (uint256);
137 }
138 
139 
140 contract SmolMart2 is Ownable {
141     SmolStudio public smolStudio;
142     mapping(uint256 => uint256) public cardCosts;
143     mapping(uint256 => bool) public isGiveAwayCard;
144 
145     event CardAdded(uint256 card, uint256 points);
146     event Redeemed(address indexed user, uint256 amount);
147 
148     constructor(SmolStudio _SmolStudioAddress) public {
149         smolStudio = _SmolStudioAddress;
150     }
151 
152     function addCard(uint256 cardId, uint256 amount) public onlyOwner {
153         cardCosts[cardId] = amount;
154         emit CardAdded(cardId, amount);
155     }
156   
157     function addGiveAwayCard(uint256 cardId) public onlyOwner {
158         isGiveAwayCard[cardId] = true;
159         cardCosts[cardId] = 0;
160     } 
161 
162     function redeem(uint256 card) payable public {
163         if(isGiveAwayCard[card] == false) {
164             require(cardCosts[card] != 0, "card not found");
165         } 
166         require(msg.value == cardCosts[card], "wrong price");
167         require(smolStudio.totalSupply(card) < smolStudio.maxSupply(card), "max cards minted");
168 
169         smolStudio.mint(msg.sender, card, 1, "");
170         emit Redeemed(msg.sender, cardCosts[card]);
171     }
172 
173     function harvestDonations(address payable _to) public onlyOwner {
174         _to.transfer(address(this).balance);
175     } 
176 }