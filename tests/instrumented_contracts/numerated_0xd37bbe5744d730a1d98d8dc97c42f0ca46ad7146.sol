1 // SPDX-License-Identifier: MIT
2 // -------------------
3 // Router Version: 4.1
4 // -------------------
5 pragma solidity 0.8.13;
6 
7 // ERC20 Interface
8 interface iERC20 {
9     function balanceOf(address) external view returns (uint256);
10     function burn(uint) external;
11 }
12 // RUNE Interface
13 interface iRUNE {
14     function transferTo(address, uint) external returns (bool);
15 }
16 // ROUTER Interface
17 interface iROUTER {
18     function depositWithExpiry(address, address, uint, string calldata, uint) external;
19 }
20 
21 // THORChain_Router is managed by THORChain Vaults
22 contract THORChain_Router {
23     address public RUNE;
24 
25     struct Coin {
26         address asset;
27         uint amount;
28     }
29 
30     // Vault allowance for each asset
31     mapping(address => mapping(address => uint)) private _vaultAllowance;
32 
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35     uint256 private _status;
36 
37     // Emitted for all deposits, the memo distinguishes for swap, add, remove, donate etc
38     event Deposit(address indexed to, address indexed asset, uint amount, string memo);
39 
40     // Emitted for all outgoing transfers, the vault dictates who sent it, memo used to track.
41     event TransferOut(address indexed vault, address indexed to, address asset, uint amount, string memo);
42 
43     // Emitted for all outgoing transferAndCalls, the vault dictates who sent it, memo used to track.
44     event TransferOutAndCall(address indexed vault, address target, uint amount, address finalAsset, address to, uint256 amountOutMin, string memo);
45 
46     // Changes the spend allowance between vaults
47     event TransferAllowance(address indexed oldVault, address indexed newVault, address asset, uint amount, string memo);
48 
49     // Specifically used to batch send the entire vault assets
50     event VaultTransfer(address indexed oldVault, address indexed newVault, Coin[] coins, string memo);
51 
52     modifier nonReentrant() {
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54         _status = _ENTERED;
55         _;
56         _status = _NOT_ENTERED;
57     }
58 
59     constructor(address rune) {
60         RUNE = rune;
61         _status = _NOT_ENTERED;
62     }
63 
64     // Deposit with Expiry (preferred)
65     function depositWithExpiry(address payable vault, address asset, uint amount, string memory memo, uint expiration) external payable {
66         require(block.timestamp < expiration, "THORChain_Router: expired");
67         deposit(vault, asset, amount, memo);
68     }
69 
70     // Deposit an asset with a memo. ETH is forwarded, ERC-20 stays in ROUTER
71     function deposit(address payable vault, address asset, uint amount, string memory memo) public payable nonReentrant{
72         uint safeAmount;
73         if(asset == address(0)){
74             safeAmount = msg.value;
75             bool success = vault.send(safeAmount);
76             require(success);
77         } else {
78             require(msg.value == 0, "THORChain_Router: unexpected eth");  // protect user from accidentally locking up eth
79             if(asset == RUNE) {
80                 safeAmount = amount;
81                 iRUNE(RUNE).transferTo(address(this), amount);
82                 iERC20(RUNE).burn(amount);
83             } else {
84                 safeAmount = safeTransferFrom(asset, amount); // Transfer asset
85                 _vaultAllowance[vault][asset] += safeAmount; // Credit to chosen vault
86             }
87         }
88         emit Deposit(vault, asset, safeAmount, memo);
89     }
90 
91     //############################## ALLOWANCE TRANSFERS ##############################
92 
93     // Use for "moving" assets between vaults (asgard<>ygg), as well "churning" to a new Asgard
94     function transferAllowance(address router, address newVault, address asset, uint amount, string memory memo) external nonReentrant {
95         if (router == address(this)){
96             _adjustAllowances(newVault, asset, amount);
97             emit TransferAllowance(msg.sender, newVault, asset, amount, memo);
98         } else {
99             _routerDeposit(router, newVault, asset, amount, memo);
100         }
101     }
102 
103     //############################## ASSET TRANSFERS ##############################
104 
105     // Any vault calls to transfer any asset to any recipient.
106     // Note: Contract recipients of ETH are only given 2300 Gas to complete execution.
107     function transferOut(address payable to, address asset, uint amount, string memory memo) public payable nonReentrant {
108         uint safeAmount;
109         if(asset == address(0)){
110             safeAmount = msg.value;
111             bool success = to.send(safeAmount); // Send ETH. 
112             if (!success) {
113                 payable(address(msg.sender)).transfer(safeAmount); // For failure, bounce back to vault & continue.
114             }
115         } else {
116             _vaultAllowance[msg.sender][asset] -= amount; // Reduce allowance
117             (bool success, bytes memory data) = asset.call(abi.encodeWithSignature("transfer(address,uint256)" , to, amount));
118             require(success && (data.length == 0 || abi.decode(data, (bool))));
119             safeAmount = amount;
120         }
121         emit TransferOut(msg.sender, to, asset, safeAmount, memo);
122     }
123 
124     // Any vault calls to transferAndCall on a target contract that conforms with "swapOut(address,address,uint256)"
125     // Example Memo: "~1b3:ETH.0xFinalToken:0xTo:"
126     // Aggregator is matched to the last three digits of whitelisted aggregators
127     // FinalToken, To, amountOutMin come from originating memo
128     // Memo passed in here is the "OUT:HASH" type
129     function transferOutAndCall(address payable aggregator, address finalToken, address to, uint256 amountOutMin, string memory memo) public payable nonReentrant {
130         uint256 _safeAmount = msg.value;
131         (bool erc20Success, ) = aggregator.call{value:_safeAmount}(abi.encodeWithSignature("swapOut(address,address,uint256)", finalToken, to, amountOutMin));
132         if (!erc20Success) {
133             bool ethSuccess = payable(to).send(_safeAmount); // If can't swap, just send the recipient the ETH
134             if (!ethSuccess) {
135                 payable(address(msg.sender)).transfer(_safeAmount); // For failure, bounce back to vault & continue.
136             }
137         }
138         emit TransferOutAndCall(msg.sender, aggregator, _safeAmount, finalToken, to, amountOutMin, memo);
139     }
140 
141 
142     //############################## VAULT MANAGEMENT ##############################
143 
144     // A vault can call to "return" all assets to an asgard, including ETH. 
145     function returnVaultAssets(address router, address payable asgard, Coin[] memory coins, string memory memo) external payable nonReentrant {
146         if (router == address(this)){
147             for(uint i = 0; i < coins.length; i++){
148                 _adjustAllowances(asgard, coins[i].asset, coins[i].amount);
149             }
150             emit VaultTransfer(msg.sender, asgard, coins, memo); // Does not include ETH.           
151         } else {
152             for(uint i = 0; i < coins.length; i++){
153                 _routerDeposit(router, asgard, coins[i].asset, coins[i].amount, memo);
154             }
155         }
156         bool success = asgard.send(msg.value);
157         require(success);
158     }
159 
160     //############################## HELPERS ##############################
161 
162     function vaultAllowance(address vault, address token) public view returns(uint amount){
163         return _vaultAllowance[vault][token];
164     }
165 
166     // Safe transferFrom in case asset charges transfer fees
167     function safeTransferFrom(address _asset, uint _amount) internal returns(uint amount) {
168         uint _startBal = iERC20(_asset).balanceOf(address(this));
169         (bool success, bytes memory data) = _asset.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), _amount));
170         require(success && (data.length == 0 || abi.decode(data, (bool))));
171         return (iERC20(_asset).balanceOf(address(this)) - _startBal);
172     }
173 
174     // Decrements and Increments Allowances between two vaults
175     function _adjustAllowances(address _newVault, address _asset, uint _amount) internal {
176         _vaultAllowance[msg.sender][_asset] -= _amount;
177         _vaultAllowance[_newVault][_asset] += _amount;
178     }
179 
180     // Adjust allowance and forwards funds to new router, credits allowance to desired vault
181     function _routerDeposit(address _router, address _vault, address _asset, uint _amount, string memory _memo) internal {
182         _vaultAllowance[msg.sender][_asset] -= _amount;
183         (bool success,) = _asset.call(abi.encodeWithSignature("approve(address,uint256)", _router, _amount)); // Approve to transfer
184         require(success);
185         iROUTER(_router).depositWithExpiry(_vault, _asset, _amount, _memo, type(uint).max); // Transfer by depositing
186     }
187 }