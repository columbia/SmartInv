1 pragma solidity ^0.8.4;
2 
3 import "../IPCVDepositBalances.sol";
4 import "../../Constants.sol";
5 import "../../refs/CoreRef.sol";
6 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
7 
8 /**
9   @notice a contract to report static PCV data to cover PCV not held with a reliable oracle or on-chain reading 
10   @author Fei Protocol
11 
12   Returns PCV in USD terms
13 */
14 contract NamedStaticPCVDepositWrapper is IPCVDepositBalances, CoreRef {
15     using SafeCast for *;
16 
17     // -------------- Events ---------------
18     /// @notice event to update fei and usd balance
19     event BalanceUpdate(uint256 oldBalance, uint256 newBalance, uint256 oldFEIBalance, uint256 newFEIBalance);
20 
21     /// @notice event to remove a deposit
22     event DepositRemoved(uint256 index);
23 
24     /// @notice event to add a new deposit
25     event DepositAdded(uint256 index, string indexed depositName);
26 
27     /// @notice event emitted when a deposit is edited
28     event DepositChanged(uint256 index, string indexed depositName);
29 
30     /// @notice struct to store info on each PCV Deposit
31     struct DepositInfo {
32         string depositName;
33         uint256 usdAmount; /// USD equivalent in this deposit, not including FEI value
34         uint256 feiAmount; /// amount of FEI in this deposit
35         uint256 underlyingTokenAmount; /// amount of underlying token in this deposit
36         address underlyingToken; /// address of the underlying token this deposit is reporting
37     }
38 
39     /// @notice a list of all pcv deposits
40     DepositInfo[] public pcvDeposits;
41 
42     /// @notice the PCV balance
43     uint256 public override balance;
44 
45     /// @notice the reported FEI balance to track protocol controlled FEI in these deposits
46     uint256 public feiReportBalance;
47 
48     constructor(address _core, DepositInfo[] memory newPCVDeposits) CoreRef(_core) {
49         // Uses oracle admin to share admin with CR oracle where this contract is used
50         _setContractAdminRole(keccak256("ORACLE_ADMIN_ROLE"));
51 
52         // add all pcv deposits
53         for (uint256 i = 0; i < newPCVDeposits.length; i++) {
54             _addDeposit(newPCVDeposits[i]);
55         }
56     }
57 
58     // ----------- Helper methods to change state -----------
59 
60     /// @notice helper method to add a PCV deposit
61     function _addDeposit(DepositInfo memory newPCVDeposit) internal {
62         require(
63             newPCVDeposit.feiAmount > 0 || newPCVDeposit.usdAmount > 0,
64             "NamedStaticPCVDepositWrapper: must supply either fei or usd amount"
65         );
66 
67         uint256 oldBalance = balance;
68         uint256 oldFEIBalance = feiReportBalance;
69 
70         balance += newPCVDeposit.usdAmount;
71         feiReportBalance += newPCVDeposit.feiAmount;
72         pcvDeposits.push(newPCVDeposit);
73 
74         emit DepositAdded(pcvDeposits.length - 1, newPCVDeposit.depositName);
75         emit BalanceUpdate(oldBalance, balance, oldFEIBalance, feiReportBalance);
76     }
77 
78     /// @notice helper method to edit a PCV deposit
79     function _editDeposit(
80         uint256 index,
81         string calldata depositName,
82         uint256 usdAmount,
83         uint256 feiAmount,
84         uint256 underlyingTokenAmount,
85         address underlyingToken
86     ) internal {
87         require(index < pcvDeposits.length, "NamedStaticPCVDepositWrapper: cannot edit index out of bounds");
88 
89         DepositInfo storage updatePCVDeposit = pcvDeposits[index];
90 
91         uint256 oldBalance = balance;
92         uint256 oldFEIBalance = feiReportBalance;
93         uint256 newBalance = oldBalance - updatePCVDeposit.usdAmount + usdAmount;
94         uint256 newFeiReportBalance = oldFEIBalance - updatePCVDeposit.feiAmount + feiAmount;
95 
96         balance = newBalance;
97         feiReportBalance = newFeiReportBalance;
98 
99         updatePCVDeposit.usdAmount = usdAmount;
100         updatePCVDeposit.feiAmount = feiAmount;
101         updatePCVDeposit.depositName = depositName;
102         updatePCVDeposit.underlyingTokenAmount = underlyingTokenAmount;
103         updatePCVDeposit.underlyingToken = underlyingToken;
104 
105         emit DepositChanged(index, depositName);
106         emit BalanceUpdate(oldBalance, newBalance, oldFEIBalance, newFeiReportBalance);
107     }
108 
109     /// @notice helper method to delete a PCV deposit
110     function _removeDeposit(uint256 index) internal {
111         require(index < pcvDeposits.length, "NamedStaticPCVDepositWrapper: cannot remove index out of bounds");
112 
113         DepositInfo storage pcvDepositToRemove = pcvDeposits[index];
114 
115         uint256 depositBalance = pcvDepositToRemove.usdAmount;
116         uint256 feiDepositBalance = pcvDepositToRemove.feiAmount;
117         uint256 oldBalance = balance;
118         uint256 oldFeiReportBalance = feiReportBalance;
119         uint256 lastIndex = pcvDeposits.length - 1;
120 
121         if (lastIndex != index) {
122             DepositInfo storage lastvalue = pcvDeposits[lastIndex];
123 
124             pcvDeposits[index] = lastvalue;
125         }
126 
127         pcvDeposits.pop();
128         balance -= depositBalance;
129         feiReportBalance -= feiDepositBalance;
130 
131         emit BalanceUpdate(oldBalance, balance, oldFeiReportBalance, feiReportBalance);
132         emit DepositRemoved(index);
133     }
134 
135     // ----------- Governor only state changing api -----------
136 
137     /// @notice function to add a deposit
138     function addDeposit(DepositInfo calldata newPCVDeposit) external onlyGovernorOrAdmin {
139         _addDeposit(newPCVDeposit);
140     }
141 
142     /// @notice function to bulk add deposits
143     function bulkAddDeposits(DepositInfo[] calldata newPCVDeposits) external onlyGovernorOrAdmin {
144         for (uint256 i = 0; i < newPCVDeposits.length; i++) {
145             _addDeposit(newPCVDeposits[i]);
146         }
147     }
148 
149     /// @notice function to remove a PCV Deposit
150     function removeDeposit(uint256 index) external isGovernorOrGuardianOrAdmin {
151         _removeDeposit(index);
152     }
153 
154     /// @notice function to edit an existing deposit
155     function editDeposit(
156         uint256 index,
157         uint256 usdAmount,
158         uint256 feiAmount,
159         uint256 underlyingTokenAmount,
160         string calldata depositName,
161         address underlying
162     ) external onlyGovernorOrAdmin {
163         _editDeposit(index, depositName, usdAmount, feiAmount, underlyingTokenAmount, underlying);
164     }
165 
166     // ----------- Getters -----------
167 
168     /// @notice returns the current number of PCV deposits
169     function numDeposits() public view returns (uint256) {
170         return pcvDeposits.length;
171     }
172 
173     /// @notice returns the resistant balance and FEI in the deposit
174     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
175         return (balance, feiReportBalance);
176     }
177 
178     /// @notice display the related token of the balance reported
179     function balanceReportedIn() public pure override returns (address) {
180         return Constants.USD;
181     }
182 
183     /// @notice function to return all of the different tokens deposited into this contract
184     function getAllUnderlying() public view returns (address[] memory) {
185         uint256 totalDeposits = numDeposits();
186 
187         address[] memory allUnderlyingTokens = new address[](totalDeposits);
188         for (uint256 i = 0; i < totalDeposits; i++) {
189             allUnderlyingTokens[i] = pcvDeposits[i].underlyingToken;
190         }
191 
192         return allUnderlyingTokens;
193     }
194 }
