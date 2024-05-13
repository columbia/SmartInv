1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IGuard.sol";
5 import "../../refs/CoreRef.sol";
6 import "../../pcv/compound/ERC20CompoundPCVDeposit.sol";
7 import "../../pcv/PCVGuardian.sol";
8 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
9 
10 contract FuseWithdrawalGuard is IGuard, CoreRef {
11     using EnumerableSet for EnumerableSet.AddressSet;
12 
13     struct WithdrawInfo {
14         address destination;
15         address underlying;
16         uint96 liquidityToLeave;
17     }
18 
19     /// @notice map the destination and minimum liquidity for each pcv deposit
20     mapping(address => WithdrawInfo) public withdrawInfos;
21 
22     EnumerableSet.AddressSet private fuseDeposits;
23 
24     /// @notice the PCV mover contract exposed to guardian role
25     PCVGuardian public constant pcvGuardian = PCVGuardian(0x02435948F84d7465FB71dE45ABa6098Fc6eC2993);
26 
27     /// @notice the minimum amount of underlying which can be withdrawn from a cToken that registers in the guard.
28     /// i.e. if the min is 100 FEI but the amount in the contract is 1 FEI, the amountToWithdraw will return 0 and the check will fail
29     /// @dev added to prevent dust from bricking the contract
30     uint256 public constant MIN_WITHDRAW = 100e18;
31 
32     constructor(
33         address core,
34         address[] memory deposits,
35         address[] memory destinations,
36         address[] memory underlyings,
37         uint96[] memory liquidityToLeaveList
38     ) CoreRef(core) {
39         uint256 len = deposits.length;
40         require(len == destinations.length && len == liquidityToLeaveList.length && len == underlyings.length);
41         for (uint256 i = 0; i < len; ) {
42             fuseDeposits.add(deposits[i]);
43             withdrawInfos[deposits[i]] = WithdrawInfo({
44                 destination: destinations[i],
45                 underlying: underlyings[i],
46                 liquidityToLeave: liquidityToLeaveList[i]
47             });
48             unchecked {
49                 ++i;
50             }
51         }
52     }
53 
54     /// @notice setter for the Fuse deposit destination and minimum liquidity
55     function setWithdrawInfo(address deposit, WithdrawInfo calldata withdrawInfo)
56         public
57         hasAnyOfThreeRoles(TribeRoles.GUARDIAN, TribeRoles.GOVERNOR, TribeRoles.PCV_SAFE_MOVER_ROLE)
58     {
59         withdrawInfos[deposit] = withdrawInfo;
60     }
61 
62     /// @notice check if contract can be called. If any deposit has a nonzero withdraw amount available, then return true.
63     function check() external view override returns (bool) {
64         for (uint256 i = 0; i < fuseDeposits.length(); ) {
65             if (getAmountToWithdraw(ERC20CompoundPCVDeposit(fuseDeposits.at(i))) > 0) return true;
66             unchecked {
67                 ++i;
68             }
69         }
70         return false;
71     }
72 
73     /// @notice return the amount that can be withdrawn from a deposit after leaving min liquidity
74     function getAmountToWithdraw(ERC20CompoundPCVDeposit deposit) public view returns (uint256) {
75         // can't read underlying directly because some of the PCV deposits use an old abi
76         IERC20 underlying = IERC20(withdrawInfos[address(deposit)].underlying);
77         // Reserves of underlying left in the cToken are considered withdrawable liquidity
78         uint256 liquidity = underlying.balanceOf(address(deposit.cToken()));
79         uint256 liquidityToLeave = withdrawInfos[address(deposit)].liquidityToLeave;
80         if (liquidity <= liquidityToLeave) {
81             return 0;
82         }
83         // take away min liquidity when calculating how much to withdraw.
84         liquidity -= liquidityToLeave;
85 
86         // max withdraw is the pcv deposit balance
87         uint256 withdrawAmount = deposit.balance();
88         if (withdrawAmount > liquidity) {
89             withdrawAmount = liquidity;
90         }
91         return withdrawAmount > MIN_WITHDRAW ? withdrawAmount : 0;
92     }
93 
94     /// @notice return the first element which can be withdrawn from with the appropriate calldata encoding tha max withdraw amount.
95     /// @dev it only returns one element for simplicity. Unlikely multiple will be withdrawable simulteneously after the first pass, and pruning empty entries from a sparse array is an inefficient and inelegant algorithm in solidity.
96     function getProtecActions()
97         external
98         view
99         override
100         returns (
101             address[] memory targets,
102             bytes[] memory datas,
103             uint256[] memory values
104         )
105     {
106         for (uint256 i = 0; i < fuseDeposits.length(); ) {
107             uint256 amount = getAmountToWithdraw(ERC20CompoundPCVDeposit(fuseDeposits.at(i)));
108             if (amount > 0) {
109                 targets = new address[](1);
110                 targets[0] = address(pcvGuardian);
111                 datas = new bytes[](1);
112                 datas[0] = abi.encodeWithSelector(
113                     PCVGuardian.withdrawToSafeAddress.selector,
114                     fuseDeposits.at(i),
115                     withdrawInfos[fuseDeposits.at(i)].destination,
116                     amount,
117                     false,
118                     false
119                 );
120                 values = new uint256[](1);
121                 return (targets, datas, values);
122             }
123             unchecked {
124                 ++i;
125             }
126         }
127     }
128 }
