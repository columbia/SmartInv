1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "../Libraries/LibAsset.sol";
5 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
6 
7 /// @title Fee Collector
8 /// @author LI.FI (https://li.fi)
9 /// @notice Provides functionality for collecting integrator fees
10 /// @custom:version 1.0.0
11 contract FeeCollector is TransferrableOwnership {
12     /// State ///
13 
14     // Integrator -> TokenAddress -> Balance
15     mapping(address => mapping(address => uint256)) private _balances;
16     // TokenAddress -> Balance
17     mapping(address => uint256) private _lifiBalances;
18 
19     /// Errors ///
20     error TransferFailure();
21     error NotEnoughNativeForFees();
22 
23     /// Events ///
24     event FeesCollected(
25         address indexed _token,
26         address indexed _integrator,
27         uint256 _integratorFee,
28         uint256 _lifiFee
29     );
30     event FeesWithdrawn(
31         address indexed _token,
32         address indexed _to,
33         uint256 _amount
34     );
35     event LiFiFeesWithdrawn(
36         address indexed _token,
37         address indexed _to,
38         uint256 _amount
39     );
40 
41     /// Constructor ///
42 
43     // solhint-disable-next-line no-empty-blocks
44     constructor(address _owner) TransferrableOwnership(_owner) {}
45 
46     /// External Methods ///
47 
48     /// @notice Collects fees for the integrator
49     /// @param tokenAddress address of the token to collect fees for
50     /// @param integratorFee amount of fees to collect going to the integrator
51     /// @param lifiFee amount of fees to collect going to lifi
52     /// @param integratorAddress address of the integrator
53     function collectTokenFees(
54         address tokenAddress,
55         uint256 integratorFee,
56         uint256 lifiFee,
57         address integratorAddress
58     ) external {
59         LibAsset.depositAsset(tokenAddress, integratorFee + lifiFee);
60         _balances[integratorAddress][tokenAddress] += integratorFee;
61         _lifiBalances[tokenAddress] += lifiFee;
62         emit FeesCollected(
63             tokenAddress,
64             integratorAddress,
65             integratorFee,
66             lifiFee
67         );
68     }
69 
70     /// @notice Collects fees for the integrator in native token
71     /// @param integratorFee amount of fees to collect going to the integrator
72     /// @param lifiFee amount of fees to collect going to lifi
73     /// @param integratorAddress address of the integrator
74     function collectNativeFees(
75         uint256 integratorFee,
76         uint256 lifiFee,
77         address integratorAddress
78     ) external payable {
79         if (msg.value < integratorFee + lifiFee)
80             revert NotEnoughNativeForFees();
81         _balances[integratorAddress][LibAsset.NULL_ADDRESS] += integratorFee;
82         _lifiBalances[LibAsset.NULL_ADDRESS] += lifiFee;
83         uint256 remaining = msg.value - (integratorFee + lifiFee);
84         // Prevent extra native token from being locked in the contract
85         if (remaining > 0) {
86             // solhint-disable-next-line avoid-low-level-calls
87             (bool success, ) = payable(msg.sender).call{ value: remaining }(
88                 ""
89             );
90             if (!success) {
91                 revert TransferFailure();
92             }
93         }
94         emit FeesCollected(
95             LibAsset.NULL_ADDRESS,
96             integratorAddress,
97             integratorFee,
98             lifiFee
99         );
100     }
101 
102     /// @notice Withdraw fees and sends to the integrator
103     /// @param tokenAddress address of the token to withdraw fees for
104     function withdrawIntegratorFees(address tokenAddress) external {
105         uint256 balance = _balances[msg.sender][tokenAddress];
106         if (balance == 0) {
107             return;
108         }
109         _balances[msg.sender][tokenAddress] = 0;
110         LibAsset.transferAsset(tokenAddress, payable(msg.sender), balance);
111         emit FeesWithdrawn(tokenAddress, msg.sender, balance);
112     }
113 
114     /// @notice Batch withdraw fees and sends to the integrator
115     /// @param tokenAddresses addresses of the tokens to withdraw fees for
116     function batchWithdrawIntegratorFees(
117         address[] memory tokenAddresses
118     ) external {
119         uint256 length = tokenAddresses.length;
120         uint256 balance;
121         for (uint256 i = 0; i < length; ) {
122             balance = _balances[msg.sender][tokenAddresses[i]];
123             if (balance != 0) {
124                 _balances[msg.sender][tokenAddresses[i]] = 0;
125                 LibAsset.transferAsset(
126                     tokenAddresses[i],
127                     payable(msg.sender),
128                     balance
129                 );
130                 emit FeesWithdrawn(tokenAddresses[i], msg.sender, balance);
131             }
132             unchecked {
133                 ++i;
134             }
135         }
136     }
137 
138     /// @notice Withdraws fees and sends to lifi
139     /// @param tokenAddress address of the token to withdraw fees for
140     function withdrawLifiFees(address tokenAddress) external onlyOwner {
141         uint256 balance = _lifiBalances[tokenAddress];
142         if (balance == 0) {
143             return;
144         }
145         _lifiBalances[tokenAddress] = 0;
146         LibAsset.transferAsset(tokenAddress, payable(msg.sender), balance);
147         emit LiFiFeesWithdrawn(tokenAddress, msg.sender, balance);
148     }
149 
150     /// @notice Batch withdraws fees and sends to lifi
151     /// @param tokenAddresses addresses of the tokens to withdraw fees for
152     function batchWithdrawLifiFees(
153         address[] memory tokenAddresses
154     ) external onlyOwner {
155         uint256 length = tokenAddresses.length;
156         uint256 balance;
157         for (uint256 i = 0; i < length; ) {
158             balance = _lifiBalances[tokenAddresses[i]];
159             _lifiBalances[tokenAddresses[i]] = 0;
160             LibAsset.transferAsset(
161                 tokenAddresses[i],
162                 payable(msg.sender),
163                 balance
164             );
165             emit LiFiFeesWithdrawn(tokenAddresses[i], msg.sender, balance);
166             unchecked {
167                 ++i;
168             }
169         }
170     }
171 
172     /// @notice Returns the balance of the integrator
173     /// @param integratorAddress address of the integrator
174     /// @param tokenAddress address of the token to get the balance of
175     function getTokenBalance(
176         address integratorAddress,
177         address tokenAddress
178     ) external view returns (uint256) {
179         return _balances[integratorAddress][tokenAddress];
180     }
181 
182     /// @notice Returns the balance of lifi
183     /// @param tokenAddress address of the token to get the balance of
184     function getLifiTokenBalance(
185         address tokenAddress
186     ) external view returns (uint256) {
187         return _lifiBalances[tokenAddress];
188     }
189 }
