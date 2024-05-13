1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../libraries/Errors.sol";
5 import "../interfaces/IController.sol";
6 import "../interfaces/IGasBank.sol";
7 
8 contract GasBank is IGasBank {
9     IController public immutable controller;
10     IAddressProvider public immutable addressProvider;
11 
12     /**
13      * @notice Keeps track of the user balances
14      */
15     mapping(address => uint256) internal _balances;
16 
17     constructor(IController _controller) {
18         addressProvider = _controller.addressProvider();
19         controller = _controller;
20     }
21 
22     /**
23      * @notice Deposit `msg.value` on behalf of `account`
24      */
25     function depositFor(address account) external payable override {
26         _balances[account] += msg.value;
27         emit Deposit(account, msg.value);
28     }
29 
30     /**
31      * @notice Withdraws `amount` from `account`
32      */
33     function withdrawFrom(address account, uint256 amount) external override {
34         withdrawFrom(account, payable(account), amount);
35     }
36 
37     /**
38      * @notice Withdraws amount not required by any action
39      */
40     function withdrawUnused(address account) external {
41         uint256 currentBalance = _balances[account];
42         require(
43             msg.sender == account || addressProvider.isAction(msg.sender),
44             Error.UNAUTHORIZED_ACCESS
45         );
46         uint256 ethRequired = controller.getTotalEthRequiredForGas(account);
47         if (currentBalance > ethRequired) {
48             _withdrawFrom(account, payable(account), currentBalance - ethRequired, currentBalance);
49         }
50     }
51 
52     /**
53      * @return the balance of `account`
54      */
55     function balanceOf(address account) external view override returns (uint256) {
56         return _balances[account];
57     }
58 
59     /**
60      * @notice Withdraws `amount` on behalf of `account` and send to `to`
61      */
62     function withdrawFrom(
63         address account,
64         address payable to,
65         uint256 amount
66     ) public override {
67         uint256 currentBalance = _balances[account];
68         require(currentBalance >= amount, Error.NOT_ENOUGH_FUNDS);
69         require(
70             msg.sender == account || addressProvider.isAction(msg.sender),
71             Error.UNAUTHORIZED_ACCESS
72         );
73 
74         if (msg.sender == account) {
75             uint256 ethRequired = controller.getTotalEthRequiredForGas(account);
76             require(currentBalance - amount >= ethRequired, Error.NOT_ENOUGH_FUNDS);
77         }
78         _withdrawFrom(account, to, amount, currentBalance);
79     }
80 
81     function _withdrawFrom(
82         address account,
83         address payable to,
84         uint256 amount,
85         uint256 currentBalance
86     ) internal {
87         _balances[account] = currentBalance - amount;
88 
89         // solhint-disable-next-line avoid-low-level-calls
90         (bool success, ) = to.call{value: amount}("");
91         require(success, Error.FAILED_TRANSFER);
92 
93         emit Withdraw(account, to, amount);
94     }
95 }
