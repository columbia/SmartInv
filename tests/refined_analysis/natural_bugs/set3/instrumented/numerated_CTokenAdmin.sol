1 pragma solidity ^0.5.16;
2 
3 import "./CErc20.sol";
4 import "./CToken.sol";
5 import "./EIP20NonStandardInterface.sol";
6 
7 contract CTokenAdmin {
8     address public constant ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
9 
10     /// @notice Admin address
11     address payable public admin;
12 
13     /// @notice Reserve manager address
14     address payable public reserveManager;
15 
16     /// @notice Emits when a new admin is assigned
17     event SetAdmin(address indexed oldAdmin, address indexed newAdmin);
18 
19     /// @notice Emits when a new reserve manager is assigned
20     event SetReserveManager(address indexed oldReserveManager, address indexed newAdmin);
21 
22     /**
23      * @dev Throws if called by any account other than the admin.
24      */
25     modifier onlyAdmin() {
26         require(msg.sender == admin, "only the admin may call this function");
27         _;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the reserve manager.
32      */
33     modifier onlyReserveManager() {
34         require(msg.sender == reserveManager, "only the reserve manager may call this function");
35         _;
36     }
37 
38     constructor(address payable _admin) public {
39         _setAdmin(_admin);
40     }
41 
42     /**
43      * @notice Get cToken admin
44      * @param cToken The cToken address
45      */
46     function getCTokenAdmin(address cToken) public view returns (address) {
47         return CToken(cToken).admin();
48     }
49 
50     /**
51      * @notice Set cToken pending admin
52      * @param cToken The cToken address
53      * @param newPendingAdmin The new pending admin
54      */
55     function _setPendingAdmin(address cToken, address payable newPendingAdmin) external onlyAdmin returns (uint256) {
56         return CTokenInterface(cToken)._setPendingAdmin(newPendingAdmin);
57     }
58 
59     /**
60      * @notice Accept cToken admin
61      * @param cToken The cToken address
62      */
63     function _acceptAdmin(address cToken) external onlyAdmin returns (uint256) {
64         return CTokenInterface(cToken)._acceptAdmin();
65     }
66 
67     /**
68      * @notice Set cToken comptroller
69      * @param cToken The cToken address
70      * @param newComptroller The new comptroller address
71      */
72     function _setComptroller(address cToken, ComptrollerInterface newComptroller) external onlyAdmin returns (uint256) {
73         return CTokenInterface(cToken)._setComptroller(newComptroller);
74     }
75 
76     /**
77      * @notice Set cToken reserve factor
78      * @param cToken The cToken address
79      * @param newReserveFactorMantissa The new reserve factor
80      */
81     function _setReserveFactor(address cToken, uint256 newReserveFactorMantissa) external onlyAdmin returns (uint256) {
82         return CTokenInterface(cToken)._setReserveFactor(newReserveFactorMantissa);
83     }
84 
85     /**
86      * @notice Reduce cToken reserve
87      * @param cToken The cToken address
88      * @param reduceAmount The amount of reduction
89      */
90     function _reduceReserves(address cToken, uint256 reduceAmount) external onlyAdmin returns (uint256) {
91         return CTokenInterface(cToken)._reduceReserves(reduceAmount);
92     }
93 
94     /**
95      * @notice Set cToken IRM
96      * @param cToken The cToken address
97      * @param newInterestRateModel The new IRM address
98      */
99     function _setInterestRateModel(address cToken, InterestRateModel newInterestRateModel)
100         external
101         onlyAdmin
102         returns (uint256)
103     {
104         return CTokenInterface(cToken)._setInterestRateModel(newInterestRateModel);
105     }
106 
107     /**
108      * @notice Set cToken collateral cap
109      * @dev It will revert if the cToken is not CCollateralCap.
110      * @param cToken The cToken address
111      * @param newCollateralCap The new collateral cap
112      */
113     function _setCollateralCap(address cToken, uint256 newCollateralCap) external onlyAdmin {
114         CCollateralCapErc20Interface(cToken)._setCollateralCap(newCollateralCap);
115     }
116 
117     /**
118      * @notice Set cToken new implementation
119      * @param cToken The cToken address
120      * @param implementation The new implementation
121      * @param becomeImplementationData The payload data
122      */
123     function _setImplementation(
124         address cToken,
125         address implementation,
126         bool allowResign,
127         bytes calldata becomeImplementationData
128     ) external onlyAdmin {
129         CDelegatorInterface(cToken)._setImplementation(implementation, allowResign, becomeImplementationData);
130     }
131 
132     /**
133      * @notice Extract reserves by the reserve manager
134      * @param cToken The cToken address
135      * @param reduceAmount The amount of reduction
136      */
137     function extractReserves(address cToken, uint256 reduceAmount) external onlyReserveManager {
138         require(CTokenInterface(cToken)._reduceReserves(reduceAmount) == 0, "failed to reduce reserves");
139 
140         address underlying;
141         if (compareStrings(CToken(cToken).symbol(), "crETH")) {
142             underlying = ethAddress;
143         } else {
144             underlying = CErc20(cToken).underlying();
145         }
146         _transferToken(underlying, reserveManager, reduceAmount);
147     }
148 
149     /**
150      * @notice Seize the stock assets
151      * @param token The token address
152      */
153     function seize(address token) external onlyAdmin {
154         uint256 amount;
155         if (token == ethAddress) {
156             amount = address(this).balance;
157         } else {
158             amount = EIP20NonStandardInterface(token).balanceOf(address(this));
159         }
160         if (amount > 0) {
161             _transferToken(token, admin, amount);
162         }
163     }
164 
165     /**
166      * @notice Set the admin
167      * @param newAdmin The new admin
168      */
169     function setAdmin(address payable newAdmin) external onlyAdmin {
170         _setAdmin(newAdmin);
171     }
172 
173     /**
174      * @notice Set the reserve manager
175      * @param newReserveManager The new reserve manager
176      */
177     function setReserveManager(address payable newReserveManager) external onlyAdmin {
178         address oldReserveManager = reserveManager;
179         reserveManager = newReserveManager;
180 
181         emit SetReserveManager(oldReserveManager, newReserveManager);
182     }
183 
184     /* Internal functions */
185 
186     function _setAdmin(address payable newAdmin) private {
187         require(newAdmin != address(0), "new admin cannot be zero address");
188         address oldAdmin = admin;
189         admin = newAdmin;
190         emit SetAdmin(oldAdmin, newAdmin);
191     }
192 
193     function _transferToken(
194         address token,
195         address payable to,
196         uint256 amount
197     ) private {
198         require(to != address(0), "receiver cannot be zero address");
199         if (token == ethAddress) {
200             to.transfer(amount);
201         } else {
202             EIP20NonStandardInterface(token).transfer(to, amount);
203 
204             bool success;
205             assembly {
206                 switch returndatasize()
207                 case 0 {
208                     // This is a non-standard ERC-20
209                     success := not(0) // set success to true
210                 }
211                 case 32 {
212                     // This is a complaint ERC-20
213                     returndatacopy(0, 0, 32)
214                     success := mload(0) // Set `success = returndata` of external call
215                 }
216                 default {
217                     if lt(returndatasize(), 32) {
218                         revert(0, 0) // This is a non-compliant ERC-20, revert.
219                     }
220                     returndatacopy(0, 0, 32) // Vyper compiler before 0.2.8 will not truncate RETURNDATASIZE.
221                     success := mload(0) // See here: https://github.com/vyperlang/vyper/security/advisories/GHSA-375m-5fvv-xq23
222                 }
223             }
224             require(success, "TOKEN_TRANSFER_OUT_FAILED");
225         }
226     }
227 
228     function compareStrings(string memory a, string memory b) private pure returns (bool) {
229         return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
230     }
231 
232     function() external payable {}
233 }
