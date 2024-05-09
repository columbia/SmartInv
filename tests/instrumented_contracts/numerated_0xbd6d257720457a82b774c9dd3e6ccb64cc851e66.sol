1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface of the ERC20 standard as defined in the EIP.
90  */
91 interface IERC20 {
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `to`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address to, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `from` to `to` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address from, address to, uint256 amount) external returns (bool);
160 }
161 
162 // File: BonusContract.sol
163 
164 
165 pragma solidity ^0.8.0;
166 
167 
168 
169 contract BonusContract is ReentrancyGuard {
170     
171     IERC20 public pirbToken;
172     
173     struct UserRecord {
174         uint256 totalPurchasedAmount;
175         uint256 totalBonus;
176         uint256 lastPurchaseTime;
177         bool isRewardExcluded;
178     }
179     
180     mapping(address => UserRecord) public userRecords;
181     
182     modifier onlyPirbToken() {
183         require(msg.sender == address(pirbToken), "Only PIRB token contract can call this function");
184         _;
185     }
186     
187     constructor(address _pirbToken) {
188         pirbToken = IERC20(_pirbToken);
189     }
190 
191     function updateBonusAmount(address _user, uint256 _amount) external onlyPirbToken {
192         UserRecord storage userRecord = userRecords[_user];
193         
194         if (userRecord.lastPurchaseTime == 0 || block.timestamp >= userRecord.lastPurchaseTime + 7 days) {
195             userRecord.totalPurchasedAmount += _amount;
196             if(userRecord.lastPurchaseTime == 0 ){
197                 userRecord.lastPurchaseTime = block.timestamp;  
198                 userRecord.totalBonus = calculateBonus(_amount);
199             }
200         } else {
201             uint256 remainingDays = 7 - ((block.timestamp - userRecord.lastPurchaseTime) / 1 days);
202             userRecord.totalPurchasedAmount += _amount;
203             userRecord.totalBonus += ((_amount * 25 / 100) * remainingDays / 7);
204         }
205     }
206     
207     function calculateBonus(uint256 _amount) private pure returns (uint256) {
208         return (_amount * 25) / 100;
209     }
210     
211     function claimBonus() external nonReentrant {
212         UserRecord storage userRecord = userRecords[msg.sender];
213         
214         require(userRecord.lastPurchaseTime > 0, "No purchase has been made");
215         require(block.timestamp >= userRecord.lastPurchaseTime + 7 days, "Bonus is not yet claimable");
216         require(!userRecord.isRewardExcluded, "This address is excluded from receiving the bonus");
217         
218         // Transfer the bonus to the user
219         require(pirbToken.transfer(msg.sender, userRecord.totalBonus), "Transfer failed");
220         
221         // Reset the last purchase time and total amount so that the user can start a new bonus period
222         userRecord.lastPurchaseTime = block.timestamp;
223         userRecord.totalBonus = calculateBonus(userRecord.totalPurchasedAmount);
224     }
225     
226     function setIsRewardExcluded(address _user) external onlyPirbToken {
227         userRecords[_user].isRewardExcluded = true;
228     }
229 }