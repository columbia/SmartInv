1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../core/TribeRoles.sol";
5 import "../pcv/PCVDeposit.sol";
6 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
7 
8 /// @title Delegator PCV Deposit
9 /// This contract simply holds an ERC20 token, and delegate its voting power
10 /// to an address. The ERC20 token needs to implement a delegate(address) method.
11 /// @author eswak
12 contract DelegatorPCVDeposit is PCVDeposit {
13     using SafeERC20 for IERC20;
14 
15     event DelegateUpdate(address indexed oldDelegate, address indexed newDelegate);
16 
17     /// @notice the token that is being used for voting
18     ERC20Votes public token;
19 
20     /// @notice the snapshot delegate for the deposit
21     address public delegate;
22 
23     /// @notice Delegator PCV Deposit constructor
24     /// @param _core Fei Core for reference
25     /// @param _token token to custody and delegate with
26     /// @param _initialDelegate the initial delegate
27     constructor(
28         address _core,
29         address _token,
30         address _initialDelegate
31     ) CoreRef(_core) {
32         token = ERC20Votes(_token);
33         if (_initialDelegate != address(0)) _delegate(_initialDelegate);
34     }
35 
36     /// @notice withdraw tokens from the PCV allocation
37     /// @param amount of tokens withdrawn
38     /// @param to the address to send PCV to
39     function withdraw(address to, uint256 amount) external virtual override onlyPCVController {
40         IERC20(token).safeTransfer(to, amount);
41         emit Withdrawal(msg.sender, to, amount);
42     }
43 
44     /// @notice no-op
45     function deposit() external override {}
46 
47     /// @notice returns total balance of PCV in the Deposit
48     function balance() public view virtual override returns (uint256) {
49         return token.balanceOf(address(this));
50     }
51 
52     /// @notice display the related token of the balance reported
53     function balanceReportedIn() public view override returns (address) {
54         return address(token);
55     }
56 
57     /// @notice sets the snapshot delegate
58     /// @dev callable by governor or admin
59     function setDelegate(address newDelegate) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) {
60         _delegate(newDelegate);
61     }
62 
63     function _delegate(address newDelegate) internal {
64         address oldDelegate = delegate;
65         delegate = newDelegate;
66 
67         token.delegate(delegate);
68 
69         emit DelegateUpdate(oldDelegate, newDelegate);
70     }
71 }
