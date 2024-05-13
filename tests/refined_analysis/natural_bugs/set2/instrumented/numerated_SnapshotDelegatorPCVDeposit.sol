1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../core/TribeRoles.sol";
5 import "../pcv/PCVDeposit.sol";
6 
7 interface DelegateRegistry {
8     function setDelegate(bytes32 id, address delegate) external;
9 
10     function clearDelegate(bytes32 id) external;
11 
12     function delegation(address delegator, bytes32 id) external view returns (address delegatee);
13 }
14 
15 /// @title Snapshot Delegator PCV Deposit
16 /// @author Fei Protocol
17 contract SnapshotDelegatorPCVDeposit is PCVDeposit {
18     event DelegateUpdate(address indexed oldDelegate, address indexed newDelegate);
19 
20     /// @notice the Gnosis delegate registry used by snapshot
21     DelegateRegistry public constant DELEGATE_REGISTRY = DelegateRegistry(0x469788fE6E9E9681C6ebF3bF78e7Fd26Fc015446);
22 
23     /// @notice the token that is being used for snapshot
24     IERC20 public immutable token;
25 
26     /// @notice the keccak encoded spaceId of the snapshot space
27     bytes32 public spaceId;
28 
29     /// @notice the snapshot delegate for the deposit
30     address public delegate;
31 
32     /// @notice Snapshot Delegator PCV Deposit constructor
33     /// @param _core Fei Core for reference
34     /// @param _token snapshot token
35     /// @param _spaceId the id (or ENS name) of the snapshot space
36     constructor(
37         address _core,
38         IERC20 _token,
39         bytes32 _spaceId,
40         address _initialDelegate
41     ) CoreRef(_core) {
42         token = _token;
43         spaceId = _spaceId;
44         _delegate(_initialDelegate);
45     }
46 
47     /// @notice withdraw tokens from the PCV allocation
48     /// @param amountUnderlying of tokens withdrawn
49     /// @param to the address to send PCV to
50     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController {
51         _withdrawERC20(address(token), to, amountUnderlying);
52     }
53 
54     /// @notice no-op
55     function deposit() external override {}
56 
57     /// @notice returns total balance of PCV in the Deposit
58     function balance() public view virtual override returns (uint256) {
59         return token.balanceOf(address(this));
60     }
61 
62     /// @notice display the related token of the balance reported
63     function balanceReportedIn() public view override returns (address) {
64         return address(token);
65     }
66 
67     /// @notice sets the snapshot space ID
68     function setSpaceId(bytes32 _spaceId) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) {
69         DELEGATE_REGISTRY.clearDelegate(spaceId);
70         spaceId = _spaceId;
71         _delegate(delegate);
72     }
73 
74     /// @notice sets the snapshot delegate
75     function setDelegate(address newDelegate) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) {
76         _delegate(newDelegate);
77     }
78 
79     /// @notice clears the delegate from snapshot
80     function clearDelegate() external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) {
81         address oldDelegate = delegate;
82         DELEGATE_REGISTRY.clearDelegate(spaceId);
83 
84         emit DelegateUpdate(oldDelegate, address(0));
85     }
86 
87     function _delegate(address newDelegate) internal {
88         address oldDelegate = delegate;
89         DELEGATE_REGISTRY.setDelegate(spaceId, newDelegate);
90         delegate = newDelegate;
91 
92         emit DelegateUpdate(oldDelegate, newDelegate);
93     }
94 }
