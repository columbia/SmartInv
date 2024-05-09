1 // SPDX-License-Identifier: MIT
2 // -------------------
3 // Router Version: 4.0
4 // -------------------
5 pragma solidity 0.8.13;
6 
7 // ERC20 Interface
8 interface iERC20 {
9     function balanceOf(address) external view returns (uint256);
10 }
11 // ROUTER Interface
12 interface iROUTER {
13     function depositWithExpiry(address, address, uint, string calldata, uint) external;
14 }
15 
16 // MAYAChain_Router is managed by MAYAChain Vaults
17 contract MAYAChain_Router {
18     struct Coin {
19         address asset;
20         uint amount;
21     }
22 
23     // Vault allowance for each asset
24     mapping(address => mapping(address => uint)) private _vaultAllowance;
25 
26     uint256 private constant _NOT_ENTERED = 1;
27     uint256 private constant _ENTERED = 2;
28     uint256 private _status;
29 
30     // Emitted for all deposits, the memo distinguishes for swap, add, remove, donate etc
31     event Deposit(address indexed to, address indexed asset, uint amount, string memo);
32 
33     // Emitted for all outgoing transfers, the vault dictates who sent it, memo used to track.
34     event TransferOut(address indexed vault, address indexed to, address asset, uint amount, string memo);
35 
36     // Emitted for all outgoing transferAndCalls, the vault dictates who sent it, memo used to track.
37     event TransferOutAndCall(address indexed vault, address target, uint amount, address finalAsset, address to, uint256 amountOutMin, string memo);
38 
39     // Changes the spend allowance between vaults
40     event TransferAllowance(address indexed oldVault, address indexed newVault, address asset, uint amount, string memo);
41 
42     // Specifically used to batch send the entire vault assets
43     event VaultTransfer(address indexed oldVault, address indexed newVault, Coin[] coins, string memo);
44 
45     modifier nonReentrant() {
46         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
47         _status = _ENTERED;
48         _;
49         _status = _NOT_ENTERED;
50     }
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     // Deposit with Expiry (preferred)
57     function depositWithExpiry(address payable vault, address asset, uint amount, string memory memo, uint expiration) external payable {
58         require(block.timestamp < expiration, "MAYAChain_Router: expired");
59         deposit(vault, asset, amount, memo);
60     }
61 
62     // Deposit an asset with a memo. ETH is forwarded, ERC-20 stays in ROUTER
63     function deposit(address payable vault, address asset, uint amount, string memory memo) public payable nonReentrant{
64         uint safeAmount;
65         if(asset == address(0)){
66             safeAmount = msg.value;
67             bool success = vault.send(safeAmount);
68             require(success);
69         } else {
70             require(msg.value == 0, "unexpected eth");  // protect user from accidentally locking up eth
71             safeAmount = safeTransferFrom(asset, amount); // Transfer asset
72             _vaultAllowance[vault][asset] += safeAmount; // Credit to chosen vault
73         }
74         emit Deposit(vault, asset, safeAmount, memo);
75     }
76 
77     //############################## ALLOWANCE TRANSFERS ##############################
78 
79     // Use for "moving" assets between vaults (asgard<>ygg), as well "churning" to a new Asgard
80     function transferAllowance(address router, address newVault, address asset, uint amount, string memory memo) external nonReentrant {
81         if (router == address(this)){
82             _adjustAllowances(newVault, asset, amount);
83             emit TransferAllowance(msg.sender, newVault, asset, amount, memo);
84         } else {
85             _routerDeposit(router, newVault, asset, amount, memo);
86         }
87     }
88 
89     //############################## ASSET TRANSFERS ##############################
90 
91     // Any vault calls to transfer any asset to any recipient.
92     // Note: Contract recipients of ETH are only given 2300 Gas to complete execution.
93     function transferOut(address payable to, address asset, uint amount, string memory memo) public payable nonReentrant {
94         uint safeAmount;
95         if(asset == address(0)){
96             safeAmount = msg.value;
97             bool success = to.send(safeAmount); // Send ETH.
98             if (!success) {
99                 payable(address(msg.sender)).transfer(safeAmount); // For failure, bounce back to Yggdrasil & continue.
100             }
101         } else {
102             _vaultAllowance[msg.sender][asset] -= amount; // Reduce allowance
103             (bool success, bytes memory data) = asset.call(abi.encodeWithSignature("transfer(address,uint256)" , to, amount));
104             require(success && (data.length == 0 || abi.decode(data, (bool))));
105             safeAmount = amount;
106         }
107         emit TransferOut(msg.sender, to, asset, safeAmount, memo);
108     }
109 
110     // Any vault calls to transferAndCall on a target contract that conforms with "swapOut(address,address,uint256)"
111     // Example Memo: "~1b3:ETH.0xFinalToken:0xTo:"
112     // Target is fuzzy-matched to the last three digits of whitelisted aggregators
113     // FinalToken, To, amountOutMin come from originating memo
114     // Memo passed in here is the "OUT:HASH" type
115     function transferOutAndCall(address payable target, address finalToken, address to, uint256 amountOutMin, string memory memo) public payable nonReentrant {
116         uint256 _safeAmount = msg.value;
117         (bool erc20Success, ) = target.call{value:_safeAmount}(abi.encodeWithSignature("swapOut(address,address,uint256)", finalToken, to, amountOutMin));
118         if (!erc20Success) {
119             bool ethSuccess = payable(to).send(_safeAmount); // If can't swap, just send the recipient the ETH
120             if (!ethSuccess) {
121                 payable(address(msg.sender)).transfer(_safeAmount); // For failure, bounce back to Yggdrasil & continue.
122             }
123         }
124         emit TransferOutAndCall(msg.sender, target, _safeAmount, finalToken, to, amountOutMin, memo);
125     }
126 
127 
128     //############################## VAULT MANAGEMENT ##############################
129 
130     // A vault can call to "return" all assets to an asgard, including ETH.
131     function returnVaultAssets(address router, address payable asgard, Coin[] memory coins, string memory memo) external payable nonReentrant {
132         if (router == address(this)){
133             for(uint i = 0; i < coins.length; i++){
134                 _adjustAllowances(asgard, coins[i].asset, coins[i].amount);
135             }
136             emit VaultTransfer(msg.sender, asgard, coins, memo); // Does not include ETH.
137         } else {
138             for(uint i = 0; i < coins.length; i++){
139                 _routerDeposit(router, asgard, coins[i].asset, coins[i].amount, memo);
140             }
141         }
142         bool success = asgard.send(msg.value);
143         require(success);
144     }
145 
146     //############################## HELPERS ##############################
147 
148     function vaultAllowance(address vault, address token) public view returns(uint amount){
149         return _vaultAllowance[vault][token];
150     }
151 
152     // Safe transferFrom in case asset charges transfer fees
153     function safeTransferFrom(address _asset, uint _amount) internal returns(uint amount) {
154         uint _startBal = iERC20(_asset).balanceOf(address(this));
155         (bool success, bytes memory data) = _asset.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), _amount));
156         require(success && (data.length == 0 || abi.decode(data, (bool))));
157         return (iERC20(_asset).balanceOf(address(this)) - _startBal);
158     }
159 
160     // Decrements and Increments Allowances between two vaults
161     function _adjustAllowances(address _newVault, address _asset, uint _amount) internal {
162         _vaultAllowance[msg.sender][_asset] -= _amount;
163         _vaultAllowance[_newVault][_asset] += _amount;
164     }
165 
166     // Adjust allowance and forwards funds to new router, credits allowance to desired vault
167     function _routerDeposit(address _router, address _vault, address _asset, uint _amount, string memory _memo) internal {
168         _vaultAllowance[msg.sender][_asset] -= _amount;
169         (bool success,) = _asset.call(abi.encodeWithSignature("approve(address,uint256)", _router, _amount)); // Approve to transfer
170         require(success);
171         iROUTER(_router).depositWithExpiry(_vault, _asset, _amount, _memo, type(uint).max); // Transfer by depositing
172     }
173 }