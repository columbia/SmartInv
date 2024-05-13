1 // SPDX-License-Identifier: MIT
2 // Taken from https://github.com/ensdomains/governance/blob/master/contracts/TokenLock.sol
3 pragma solidity 0.8.10;
4 
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 /**
9  * @dev Time-locks tokens according to an unlock schedule.
10  */
11 
12 contract TokenLock is Ownable {
13     ERC20 public immutable token;
14 
15     struct VestingParams {
16         uint256 unlockBegin;
17         uint256 unlockCliff;
18         uint256 unlockEnd;
19         uint256 lockedAmounts;
20         uint256 claimedAmounts;
21     }
22 
23     address public tokenSale;
24     mapping(address => VestingParams) public vesting;
25 
26     event Setup(
27         address indexed recipient,
28         uint256 _unlockBegin,
29         uint256 _unlockCliff,
30         uint256 _unlockEnd
31     );
32     event Locked(address indexed sender, address indexed recipient, uint256 amount);
33     event Claimed(address indexed owner, address indexed recipient, uint256 amount);
34 
35     /**
36      * @dev Constructor.
37      * @param _token The token this contract will lock
38      */
39     constructor(ERC20 _token) {
40         token = _token;
41     }
42 
43     /**
44      * @dev set sale contract
45      * @param _tokenSale address of token sale contract
46      */
47     function setTokenSale(address _tokenSale) external onlyOwner {
48         require(_tokenSale != address(0), "TokenLock: Null address");
49         tokenSale = _tokenSale;
50     }
51 
52     /**
53      * @dev setup vesting for recipient.
54      * @param recipient The account for which vesting will be setup.
55      * @param _unlockBegin The time at which unlocking of tokens will begin.
56      * @param _unlockCliff The first time at which tokens are claimable.
57      * @param _unlockEnd The time at which the last token will unlock.
58      */
59     function setupVesting(
60         address recipient,
61         uint256 _unlockBegin,
62         uint256 _unlockCliff,
63         uint256 _unlockEnd
64     ) external {
65         require(
66             msg.sender == owner() || msg.sender == address(token) || msg.sender == tokenSale,
67             "TokenLock: Only owner/ claims/ sale contract can call"
68         );
69         require(
70             _unlockCliff >= _unlockBegin,
71             "TokenLock: Unlock cliff must not be before unlock begin"
72         );
73         require(
74             _unlockEnd >= _unlockCliff,
75             "TokenLock: Unlock end must not be before unlock cliff"
76         );
77         vesting[recipient].unlockBegin = _unlockBegin;
78         vesting[recipient].unlockCliff = _unlockCliff;
79         vesting[recipient].unlockEnd = _unlockEnd;
80     }
81 
82     /**
83      * @dev Returns the maximum number of tokens currently claimable by `owner`.
84      * @param owner The account to check the claimable balance of.
85      * @return The number of tokens currently claimable.
86      */
87     function claimableBalance(address owner) public view virtual returns (uint256) {
88         if (block.timestamp < vesting[owner].unlockCliff) {
89             return 0;
90         }
91 
92         uint256 locked = vesting[owner].lockedAmounts;
93         uint256 claimed = vesting[owner].claimedAmounts;
94         if (block.timestamp >= vesting[owner].unlockEnd) {
95             return locked - claimed;
96         }
97         return
98             (locked * (block.timestamp - vesting[owner].unlockBegin)) /
99             (vesting[owner].unlockEnd - vesting[owner].unlockBegin) -
100             claimed;
101     }
102 
103     /**
104      * @dev Transfers tokens from the caller to the token lock contract and locks them for benefit of `recipient`.
105      *      Requires that the caller has authorised this contract with the token contract.
106      * @param recipient The account the tokens will be claimable by.
107      * @param amount The number of tokens to transfer and lock.
108      */
109     function lock(address recipient, uint256 amount) external {
110         require(
111             block.timestamp < vesting[recipient].unlockEnd,
112             "TokenLock: Unlock period already complete"
113         );
114         vesting[recipient].lockedAmounts += amount;
115         require(
116             token.transferFrom(msg.sender, address(this), amount),
117             "TokenLock: Transfer failed"
118         );
119         emit Locked(msg.sender, recipient, amount);
120     }
121 
122     /**
123      * @dev Claims the caller's tokens that have been unlocked, sending them to `recipient`.
124      * @param recipient The account to transfer unlocked tokens to.
125      * @param amount The amount to transfer. If greater than the claimable amount, the maximum is transferred.
126      */
127     function claim(address recipient, uint256 amount) external {
128         uint256 claimable = claimableBalance(msg.sender);
129         if (amount > claimable) {
130             amount = claimable;
131         }
132         if (amount != 0) {
133             vesting[msg.sender].claimedAmounts += amount;
134             require(token.transfer(recipient, amount), "TokenLock: Transfer failed");
135             emit Claimed(msg.sender, recipient, amount);
136         }
137     }
138 }
