1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.3;
3 
4 // ERC20 Interface
5 interface iERC20 {
6     function balanceOf(address) external view returns (uint256);
7     function approve(address, uint) external returns (bool);
8     function burn(uint) external;
9 }
10 // RUNE Interface
11 interface iRUNE {
12     function transferTo(address, uint) external returns (bool);
13 }
14 // ROUTER Interface
15 interface iROUTER {
16     function deposit(address, address, uint, string calldata) external;
17 }
18 
19 // THORChain_Router is managed by THORChain Vaults
20 contract THORChain_Router {
21     address public RUNE = 0x3155BA85D5F96b2d030a4966AF206230e46849cb; //mainnet
22 
23     struct Coin {
24         address asset;
25         uint amount;
26     }
27 
28     // Vault allowance for each asset
29     mapping(address => mapping(address => uint)) public vaultAllowance;
30 
31     // Emitted for all deposits, the memo distinguishes for swap, add, remove, donate etc
32     event Deposit(address indexed to, address indexed asset, uint amount, string memo);
33 
34     // Emitted for all outgoing transfers, the vault dictates who sent it, memo used to track.
35     event TransferOut(address indexed vault, address indexed to, address asset, uint amount, string memo);
36 
37     // Changes the spend allowance between vaults
38     event TransferAllowance(address indexed oldVault, address indexed newVault, address asset, uint amount, string memo);
39 
40     // Specifically used to batch send the entire vault assets
41     event VaultTransfer(address indexed oldVault, address indexed newVault, Coin[] coins, string memo);
42 
43     constructor() {}
44 
45     // Deposit an asset with a memo. ETH is forwarded, ERC-20 stays in ROUTER
46     function deposit(address payable vault, address asset, uint amount, string memory memo) external payable {
47         uint safeAmount;
48         if(asset == address(0)){
49             safeAmount = msg.value;
50             (bool success, bytes memory data) = vault.call{value:safeAmount}("");
51             require(success && (data.length == 0 || abi.decode(data, (bool))));
52         } else if(asset == RUNE) {
53             safeAmount = amount;
54             iRUNE(RUNE).transferTo(address(this), amount);
55             iERC20(RUNE).burn(amount);
56         } else {
57             safeAmount = safeTransferFrom(asset, amount); // Transfer asset
58             vaultAllowance[vault][asset] += safeAmount; // Credit to chosen vault
59         }
60         emit Deposit(vault, asset, safeAmount, memo);
61     }
62 
63     //############################## ALLOWANCE TRANSFERS ##############################
64 
65     // Use for "moving" assets between vaults (asgard<>ygg), as well "churning" to a new Asgard
66     function transferAllowance(address router ,address newVault, address asset, uint amount, string memory memo) external {
67         if (router == address(this)){
68             _adjustAllowances(newVault, asset, amount);
69             emit TransferAllowance(msg.sender, newVault, asset, amount, memo);
70         } else {
71             _routerDeposit(router, newVault, asset, amount, memo);
72         }
73     }
74 
75     //############################## ASSET TRANSFERS ##############################
76 
77     // Any vault calls to transfer any asset to any recipient.
78     function transferOut(address payable to, address asset, uint amount, string memory memo) public payable {
79         uint safeAmount; bool success; bytes memory data;
80         if(asset == address(0)){
81             safeAmount = msg.value;
82             (success, data) = to.call{value:msg.value}(""); // Send ETH
83         } else {
84             vaultAllowance[msg.sender][asset] -= amount; // Reduce allowance
85             (success, data) = asset.call(abi.encodeWithSelector(0xa9059cbb, to, amount));
86             safeAmount = amount;
87         }
88         require(success && (data.length == 0 || abi.decode(data, (bool))));
89         emit TransferOut(msg.sender, to, asset, safeAmount, memo);
90     }
91 
92     // Batch Transfer
93     function batchTransferOut(address[] memory recipients, Coin[] memory coins, string[] memory memos) external payable {
94         for(uint i = 0; i < coins.length; i++){
95             transferOut(payable(recipients[i]), coins[i].asset, coins[i].amount, memos[i]);
96         }
97     }
98 
99     //############################## VAULT MANAGEMENT ##############################
100 
101     // A vault can call to "return" all assets to an asgard, including ETH. 
102     function returnVaultAssets(address router, address payable asgard, Coin[] memory coins, string memory memo) external payable {
103         if (router == address(this)){
104             for(uint i = 0; i < coins.length; i++){
105                 _adjustAllowances(asgard, coins[i].asset, coins[i].amount);
106             }
107             emit VaultTransfer(msg.sender, asgard, coins, memo); // Does not include ETH.           
108         } else {
109             for(uint i = 0; i < coins.length; i++){
110                 _routerDeposit(router, asgard, coins[i].asset, coins[i].amount, memo);
111             }
112         }
113         (bool success, bytes memory data) = asgard.call{value:msg.value}(""); //ETH amount needs to be parsed from tx.
114         require(success && (data.length == 0 || abi.decode(data, (bool))));
115     }
116 
117     //############################## HELPERS ##############################
118 
119     // Safe transferFrom in case asset charges transfer fees
120     function safeTransferFrom(address _asset, uint _amount) internal returns(uint amount) {
121         uint _startBal = iERC20(_asset).balanceOf(address(this));
122         (bool success, bytes memory data) = _asset.call(abi.encodeWithSelector(0x23b872dd, msg.sender, address(this), _amount));
123         require(success && (data.length == 0 || abi.decode(data, (bool))));
124         return (iERC20(_asset).balanceOf(address(this)) - _startBal);
125     }
126 
127     // Decrements and Increments Allowances between two vaults
128     function _adjustAllowances(address _newVault, address _asset, uint _amount) internal {
129         vaultAllowance[msg.sender][_asset] -= _amount;
130         vaultAllowance[_newVault][_asset] += _amount;
131     }
132 
133     // Adjust allowance and forwards funds to new router, credits allowance to desired vault
134     function _routerDeposit(address _router, address _vault, address _asset, uint _amount, string memory _memo) internal {
135         vaultAllowance[msg.sender][_asset] -= _amount;
136         require(iERC20(_asset).approve(_router, _amount)); // Approve to transfer
137         iROUTER(_router).deposit(_vault, _asset, _amount, _memo); // Transfer
138     }
139 }