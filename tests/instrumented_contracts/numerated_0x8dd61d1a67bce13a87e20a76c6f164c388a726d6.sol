1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/math/Math.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Standard math utilities missing in the Solidity language.
117  */
118 library Math {
119     /**
120      * @dev Returns the largest of two numbers.
121      */
122     function max(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a >= b ? a : b;
124     }
125 
126     /**
127      * @dev Returns the smallest of two numbers.
128      */
129     function min(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a < b ? a : b;
131     }
132 
133     /**
134      * @dev Returns the average of two numbers. The result is rounded towards
135      * zero.
136      */
137     function average(uint256 a, uint256 b) internal pure returns (uint256) {
138         // (a + b) / 2 can overflow, so we distribute
139         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
140     }
141 }
142 
143 // File: contracts/Donation.sol
144 
145 pragma solidity ^0.5.11;
146 
147 
148 
149 
150 
151 interface ERC721Collection {
152     function issueToken(address _beneficiary, string calldata _wearableId) external;
153     function getWearableKey(string calldata _wearableId) external view returns (bytes32);
154     function issued(bytes32 _wearableKey) external view returns (uint256);
155     function maxIssuance(bytes32 _wearableKey) external view returns (uint256);
156     function issueTokens(address[] calldata _beneficiaries, bytes32[] calldata _wearableIds) external;
157     function balanceOf(address _owner) external view returns (uint256);
158 }
159 
160 contract ClaimWearable {
161     using SafeMath for uint256;
162     
163     uint256 public maxSenderBalance;
164     address public owner;
165 
166     event ClaimedNFT(
167         address indexed _caller,
168         address indexed _erc721Collection,
169         string _wearable
170     );
171     
172     constructor(uint256 _maxSenderBalance) public {
173         maxSenderBalance = _maxSenderBalance;
174         owner = msg.sender;
175     }
176     
177     function changeMaxSenderBalance(uint256 _maxSenderBalance) external {
178         require(msg.sender == owner, "Unauthorized sender");
179         maxSenderBalance = _maxSenderBalance;
180     }
181 
182      /**
183      * @dev Claim an NFTs.
184      * @notice Claim a `_wearableId` NFT.
185      * @param _erc721Collection - collection address
186      * @param _wearableId - wearable id
187      */
188     function claimNFT(ERC721Collection _erc721Collection, string calldata _wearableId) external payable {
189         require(_erc721Collection.balanceOf(msg.sender) < maxSenderBalance, "The sender has already reached maxSenderBalance");
190         require(
191             canMint(_erc721Collection, _wearableId, 1),
192             "The amount of wearables to issue is higher than its available supply"
193         );
194 
195         _erc721Collection.issueToken(msg.sender, _wearableId);
196 
197         emit ClaimedNFT(msg.sender, address(_erc721Collection), _wearableId);
198     }
199 
200     /**
201     * @dev Returns whether the wearable can be minted.
202     * @param _erc721Collection - collection address
203     * @param _wearableId - wearable id
204     * @return whether a wearable can be minted
205     */
206     function canMint(ERC721Collection _erc721Collection, string memory _wearableId, uint256 _amount) public view returns (bool) {
207         uint256 balance = balanceOf(_erc721Collection, _wearableId);
208 
209         return balance >= _amount;
210     }
211 
212     /**
213      * @dev Returns a wearable's available supply .
214      * Throws if the option ID does not exist. May return 0.
215      * @param _erc721Collection - collection address
216      * @param _wearableId - wearable id
217      * @return wearable's available supply
218      */
219     function balanceOf(ERC721Collection _erc721Collection, string memory _wearableId) public view returns (uint256) {
220         bytes32 wearableKey = _erc721Collection.getWearableKey(_wearableId);
221 
222         uint256 issued = _erc721Collection.issued(wearableKey);
223         uint256 maxIssuance = _erc721Collection.maxIssuance(wearableKey);
224 
225         return maxIssuance.sub(issued);
226     }
227 }