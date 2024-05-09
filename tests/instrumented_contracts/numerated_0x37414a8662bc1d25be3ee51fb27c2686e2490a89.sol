1 /**
2  *Submitted for verification at snowtrace.io on 2022-02-11
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity ^0.8.6;
7 
8 contract AnyCallProxy {
9     // Context information for destination chain targets
10     struct Context {
11         address sender;
12         uint256 fromChainID;
13     }
14 
15     // Packed fee information (only 1 storage slot)
16     struct FeeData {
17         uint128 accruedFees;
18         uint128 premium;
19     }
20 
21     // Packed MPC transfer info (only 1 storage slot)
22     struct TransferData {
23         uint96 effectiveTime;
24         address pendingMPC;
25     }
26 
27     // Extra cost of execution (SSTOREs.SLOADs,ADDs,etc..)
28     // TODO: analysis to verify the correct overhead gas usage
29     uint256 constant EXECUTION_OVERHEAD = 100000;
30 
31     address public mpc;
32     TransferData private _transferData;
33 
34     mapping(address => bool) public blacklist;
35     mapping(address => mapping(address => mapping(uint256 => bool))) public whitelist;
36     
37     Context public context;
38 
39     mapping(address => uint256) public executionBudget;
40     FeeData private _feeData;
41 
42     event LogAnyCall(
43         address indexed from,
44         address indexed to,
45         bytes data,
46         address _fallback,
47         uint256 indexed toChainID
48     );
49 
50     event LogAnyExec(
51         address indexed from,
52         address indexed to,
53         bytes data,
54         bool success,
55         bytes result,
56         address _fallback,
57         uint256 indexed fromChainID
58     );
59 
60     event Deposit(address indexed account, uint256 amount);
61     event Withdrawl(address indexed account, uint256 amount);
62     event SetBlacklist(address indexed account, bool flag);
63     event SetWhitelist(
64         address indexed from,
65         address indexed to,
66         uint256 indexed toChainID,
67         bool flag
68     );
69     event TransferMPC(address oldMPC, address newMPC, uint256 effectiveTime);
70     event UpdatePremium(uint256 oldPremium, uint256 newPremium);
71 
72     constructor(address _mpc, uint128 _premium) {
73         mpc = _mpc;
74         _feeData.premium = _premium;
75 
76         emit TransferMPC(address(0), _mpc, block.timestamp);
77         emit UpdatePremium(0, _premium);
78     }
79 
80     /// @dev Access control function
81     modifier onlyMPC() {
82         require(msg.sender == mpc); // dev: only MPC
83         _;
84     }
85 
86     /// @dev Charge an account for execution costs on this chain
87     /// @param _from The account to charge for execution costs
88     modifier charge(address _from) {
89         uint256 gasUsed = gasleft() + EXECUTION_OVERHEAD;
90         _;
91         uint256 totalCost = (gasUsed - gasleft()) * (tx.gasprice + _feeData.premium);
92 
93         executionBudget[_from] -= totalCost;
94         _feeData.accruedFees += uint128(totalCost);
95     }
96 
97     /**
98         @notice Submit a request for a cross chain interaction
99         @param _to The target to interact with on `_toChainID`
100         @param _data The calldata supplied for the interaction with `_to`
101         @param _fallback The address to call back on the originating chain
102             if the cross chain interaction fails
103         @param _toChainID The target chain id to interact with
104     */
105     function anyCall(
106         address _to,
107         bytes calldata _data,
108         address _fallback,
109         uint256 _toChainID
110     ) external {
111         require(!blacklist[msg.sender]); // dev: caller is blacklisted
112         require(whitelist[msg.sender][_to][_toChainID]); // dev: request denied
113 
114         emit LogAnyCall(msg.sender, _to, _data, _fallback, _toChainID);
115     }
116 
117     /**
118         @notice Execute a cross chain interaction
119         @dev Only callable by the MPC
120         @param _from The request originator
121         @param _to The cross chain interaction target
122         @param _data The calldata supplied for interacting with target
123         @param _fallback The address to call on `_fromChainID` if the interaction fails
124         @param _fromChainID The originating chain id
125     */
126     function anyExec(
127         address _from,
128         address _to,
129         bytes calldata _data,
130         address _fallback,
131         uint256 _fromChainID
132     ) external charge(_from) onlyMPC {
133         context = Context({sender: _from, fromChainID: _fromChainID});
134         (bool success, bytes memory result) = _to.call(_data);
135         context = Context({sender: address(0), fromChainID: 0});
136 
137         emit LogAnyExec(_from, _to, _data, success, result, _fallback, _fromChainID);
138 
139         // Call the fallback on the originating chain with the call information (to, data)
140         // _from, _fromChainID, _toChainID can all be identified via contextual info
141         if (!success && _fallback != address(0)) {
142             emit LogAnyCall(
143                 _from,
144                 _fallback,
145                 abi.encodeWithSignature("anyFallback(address,bytes)", _to, _data),
146                 address(0),
147                 _fromChainID
148             );
149         }
150     }
151 
152     /// @notice Deposit native currency crediting `_account` for execution costs on this chain
153     /// @param _account The account to deposit and credit for
154     function deposit(address _account) external payable {
155         executionBudget[_account] += msg.value;
156         emit Deposit(_account, msg.value);
157     }
158 
159     /// @notice Withdraw a previous deposit from your account
160     /// @param _amount The amount to withdraw from your account
161     function withdraw(uint256 _amount) external {
162         executionBudget[msg.sender] -= _amount;
163         emit Withdrawl(msg.sender, _amount);
164         (bool success,) = msg.sender.call{value: _amount}("");
165         require(success);
166     }
167 
168     /// @notice Withdraw all accrued execution fees
169     /// @dev The MPC is credited in the native currency
170     function withdrawAccruedFees() external {
171         uint256 fees = _feeData.accruedFees;
172         _feeData.accruedFees = 0;
173         (bool success,) = mpc.call{value: fees}("");
174         require(success);
175     }
176 
177     /// @notice Set the whitelist premitting an account to issue a cross chain request
178     /// @param _from The account which will submit cross chain interaction requests
179     /// @param _to The target of the cross chain interaction
180     /// @param _toChainID The target chain id
181     function setWhitelist(
182         address _from,
183         address _to,
184         uint256 _toChainID,
185         bool _flag
186     ) external onlyMPC {
187         require(_toChainID != block.chainid, "AnyCall: Forbidden");
188         whitelist[_from][_to][_toChainID] = _flag;
189         emit SetWhitelist(_from, _to, _toChainID, _flag);
190     }
191 
192     /// @notice Set an account's blacklist status
193     /// @dev A simpler way to deactive an account's permission to issue
194     ///     cross chain requests without updating the whitelist
195     /// @param _account The account to update blacklist status of
196     /// @param _flag The blacklist state to put `_account` in
197     function setBlacklist(address _account, bool _flag) external onlyMPC {
198         blacklist[_account] = _flag;
199         emit SetBlacklist(_account, _flag);
200     }
201 
202     /// @notice Set the premimum for cross chain executions
203     /// @param _premium The premium per gas
204     function setPremium(uint128 _premium) external onlyMPC {
205         emit UpdatePremium(_feeData.premium, _premium);
206         _feeData.premium = _premium;
207     }
208 
209     /// @notice Initiate a transfer of MPC status
210     /// @param _newMPC The address of the new MPC
211     function changeMPC(address _newMPC) external onlyMPC {
212         mpc = _newMPC;
213     }
214 
215     /// @notice Get the total accrued fees in native currency
216     /// @dev Fees increase when executing cross chain requests
217     function accruedFees() external view returns(uint128) {
218         return _feeData.accruedFees;
219     }
220 
221     /// @notice Get the gas premium cost
222     /// @dev This is similar to priority fee in eip-1559, except instead of going
223     ///     to the miner it is given to the MPC executing cross chain requests
224     function premium() external view returns(uint128) {
225         return _feeData.premium;
226     }
227 
228     /// @notice Get the effective time at which pendingMPC may become MPC
229     function effectiveTime() external view returns(uint256) {
230         return _transferData.effectiveTime;
231     }
232     
233     /// @notice Get the address of the pending MPC
234     function pendingMPC() external view returns(address) {
235         return _transferData.pendingMPC;
236     }
237 }