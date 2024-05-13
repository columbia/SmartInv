1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IGuard.sol";
5 import "../../refs/CoreRef.sol";
6 import "../../pcv/compound/ERC20CompoundPCVDeposit.sol";
7 import "../../pcv/PCVGuardian.sol";
8 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
9 
10 contract MaxFeiWithdrawalGuard is IGuard, CoreRef {
11     using EnumerableSet for EnumerableSet.AddressSet;
12 
13     struct WithdrawInfo {
14         address destination;
15         address liquiditySource;
16     }
17 
18     /// @notice map the destination and liquidity source for each pcv deposit
19     mapping(address => WithdrawInfo) public withdrawInfos;
20 
21     EnumerableSet.AddressSet private depositSet;
22 
23     /// @notice the PCV mover contract exposed to guardian role
24     PCVGuardian public constant pcvGuardian = PCVGuardian(0x02435948F84d7465FB71dE45ABa6098Fc6eC2993);
25 
26     /// @notice the minimum amount of underlying which can be withdrawn from a deposit that registers in the guard.
27     /// i.e. if the min is 100 FEI but the amount in the contract is 1 FEI, the amountToWithdraw will return 0 and the check will fail
28     /// @dev added to prevent dust from bricking the contract
29     uint256 public constant MIN_WITHDRAW = 100e18;
30 
31     constructor(
32         address core,
33         address[] memory deposits,
34         address[] memory destinations,
35         address[] memory liquiditySources
36     ) CoreRef(core) {
37         uint256 len = deposits.length;
38         require(len == destinations.length);
39         for (uint256 i = 0; i < len; ) {
40             depositSet.add(deposits[i]);
41             withdrawInfos[deposits[i]] = WithdrawInfo({
42                 destination: destinations[i],
43                 liquiditySource: liquiditySources[i]
44             });
45             unchecked {
46                 ++i;
47             }
48         }
49     }
50 
51     /// @notice setter for the deposit destination and liquidity source
52     function setWithdrawInfo(address deposit, WithdrawInfo calldata withdrawInfo)
53         public
54         hasAnyOfThreeRoles(TribeRoles.GUARDIAN, TribeRoles.GOVERNOR, TribeRoles.PCV_SAFE_MOVER_ROLE)
55     {
56         withdrawInfos[deposit] = withdrawInfo;
57     }
58 
59     /// @notice check if contract can be called. If any deposit has a nonzero withdraw amount available, then return true.
60     function check() external view override returns (bool) {
61         for (uint256 i = 0; i < depositSet.length(); ) {
62             if (getAmountToWithdraw(IPCVDeposit(depositSet.at(i))) > 0) return true;
63             unchecked {
64                 ++i;
65             }
66         }
67         return false;
68     }
69 
70     /// @notice return the amount that can be withdrawn from a deposit after leaving min liquidity
71     function getAmountToWithdraw(IPCVDeposit deposit) public view returns (uint256) {
72         // Reserves of underlying left in the liquidity source are considered withdrawable liquidity
73         uint256 liquidity = fei().balanceOf(withdrawInfos[address(deposit)].liquiditySource);
74         if (liquidity == 0) {
75             return 0;
76         }
77 
78         // max withdraw is the pcv deposit balance
79         uint256 withdrawAmount = deposit.balance();
80         if (withdrawAmount > liquidity) {
81             withdrawAmount = liquidity;
82         }
83         return withdrawAmount > MIN_WITHDRAW ? withdrawAmount : 0;
84     }
85 
86     /// @notice return the first element which can be withdrawn from with the appropriate calldata encoding tha max withdraw amount.
87     /// @dev it only returns one element for simplicity. Unlikely multiple will be withdrawable simulteneously after the first pass, and pruning empty entries from a sparse array is an inefficient and inelegant algorithm in solidity.
88     function getProtecActions()
89         external
90         view
91         override
92         returns (
93             address[] memory targets,
94             bytes[] memory datas,
95             uint256[] memory values
96         )
97     {
98         for (uint256 i = 0; i < depositSet.length(); ) {
99             uint256 amount = getAmountToWithdraw(IPCVDeposit(depositSet.at(i)));
100             if (amount > 0) {
101                 targets = new address[](1);
102                 targets[0] = address(pcvGuardian);
103                 datas = new bytes[](1);
104                 datas[0] = abi.encodeWithSelector(
105                     PCVGuardian.withdrawToSafeAddress.selector,
106                     depositSet.at(i),
107                     withdrawInfos[depositSet.at(i)].destination,
108                     amount,
109                     false,
110                     false
111                 );
112                 values = new uint256[](1);
113                 return (targets, datas, values);
114             }
115             unchecked {
116                 ++i;
117             }
118         }
119     }
120 }
