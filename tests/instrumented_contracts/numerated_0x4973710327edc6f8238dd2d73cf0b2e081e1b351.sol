1 // Sources flattened with hardhat v2.11.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
4 
5 // SPDX-License-Identifier: BUSL-1.1
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File contracts/RabbitDeposit.sol
90 
91 pragma solidity ^0.8.17;
92 
93 // import "hardhat/console.sol";
94 
95 contract RabbitDeposit {
96 
97     address public immutable owner;
98     address public immutable rabbit;
99     IERC20 public paymentToken;
100 
101     // total of trader's deposits to date
102     mapping(address => uint) public deposits;
103 
104     uint nextDepositId = 30001;
105 
106     struct Receipt {
107         uint fromAddress;
108         address toAddress;
109         uint[] payload;
110     }
111 
112     event Deposit(uint indexed id, address indexed trader, uint amount);
113 
114     constructor(address _owner, address _rabbit, address _paymentToken) {
115         owner = _owner;
116         rabbit = _rabbit;
117         paymentToken = IERC20(_paymentToken);
118     }
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner, "ONLY_OWNER");
122         _;
123     }
124 
125     function setPaymentToken(address _paymentToken) external onlyOwner {
126         paymentToken = IERC20(_paymentToken);
127     }
128 
129     function allocateDepositId() private returns (uint depositId) {
130         depositId = nextDepositId;
131         nextDepositId++;
132         return depositId;
133     }
134 
135     function deposit(uint amount) external {
136         bool success = makeTransferFrom(msg.sender, rabbit, amount);
137         require(success, "TRANSFER_FAILED");
138         deposits[msg.sender] += amount;
139         uint depositId = allocateDepositId();
140         emit Deposit(depositId, msg.sender, amount);
141     }
142 
143     // function makeTransfer(address to, uint256 amount) private returns (bool success) {
144     //     return tokenCall(abi.encodeWithSelector(paymentToken.transfer.selector, to, amount));
145     // }
146 
147     function makeTransferFrom(address from, address to, uint256 amount) private returns (bool success) {
148         return tokenCall(abi.encodeWithSelector(paymentToken.transferFrom.selector, from, to, amount));
149     }
150 
151     function tokenCall(bytes memory data) private returns (bool) {
152         (bool success, bytes memory returndata) = address(paymentToken).call(data);
153         if (success && returndata.length > 0) {
154             success = abi.decode(returndata, (bool));
155         }
156         return success;
157     }
158 }