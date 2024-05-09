1 // SPDX-License-Identifier: UNLICENSED
2 // -------------------
3 // Router Version: 2.0
4 // -------------------
5 pragma solidity 0.8.3;
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
31     mapping(address => mapping(address => uint)) public vaultAllowance;
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
43     // Changes the spend allowance between vaults
44     event TransferAllowance(address indexed oldVault, address indexed newVault, address asset, uint amount, string memo);
45 
46     // Specifically used to batch send the entire vault assets
47     event VaultTransfer(address indexed oldVault, address indexed newVault, Coin[] coins, string memo);
48 
49     modifier nonReentrant() {
50         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
51         _status = _ENTERED;
52         _;
53         _status = _NOT_ENTERED;
54     }
55 
56     constructor(address rune) {
57         RUNE = rune;
58         _status = _NOT_ENTERED;
59     }
60 
61     // Deposit with Expiry (preferred)
62     function depositWithExpiry(address payable vault, address asset, uint amount, string memory memo, uint expiration) external payable {
63         require(block.timestamp < expiration, "THORChain_Router: expired");
64         deposit(vault, asset, amount, memo);
65     }
66 
67     // Deposit an asset with a memo. ETH is forwarded, ERC-20 stays in ROUTER
68     function deposit(address payable vault, address asset, uint amount, string memory memo) public payable nonReentrant{
69         uint safeAmount;
70         if(asset == address(0)){
71             safeAmount = msg.value;
72             (bool success,) = vault.call{value:safeAmount}("");
73             require(success);
74         } else if(asset == RUNE) {
75             safeAmount = amount;
76             iRUNE(RUNE).transferTo(address(this), amount);
77             iERC20(RUNE).burn(amount);
78         } else {
79             safeAmount = safeTransferFrom(asset, amount); // Transfer asset
80             vaultAllowance[vault][asset] += safeAmount; // Credit to chosen vault
81         }
82         emit Deposit(vault, asset, safeAmount, memo);
83     }
84 
85     //############################## ALLOWANCE TRANSFERS ##############################
86 
87     // Use for "moving" assets between vaults (asgard<>ygg), as well "churning" to a new Asgard
88     function transferAllowance(address router, address newVault, address asset, uint amount, string memory memo) external {
89         if (router == address(this)){
90             _adjustAllowances(newVault, asset, amount);
91             emit TransferAllowance(msg.sender, newVault, asset, amount, memo);
92         } else {
93             _routerDeposit(router, newVault, asset, amount, memo);
94         }
95     }
96 
97     //############################## ASSET TRANSFERS ##############################
98 
99     // Any vault calls to transfer any asset to any recipient.
100     function transferOut(address payable to, address asset, uint amount, string memory memo) public payable nonReentrant {
101         uint safeAmount; bool success;
102         if(asset == address(0)){
103             safeAmount = msg.value;
104             (success,) = to.call{value:msg.value}(""); // Send ETH
105         } else {
106             vaultAllowance[msg.sender][asset] -= amount; // Reduce allowance
107             (success,) = asset.call(abi.encodeWithSignature("transfer(address,uint256)" , to, amount));
108             safeAmount = amount;
109         }
110         require(success);
111         emit TransferOut(msg.sender, to, asset, safeAmount, memo);
112     }
113 
114     // Batch Transfer
115     function batchTransferOut(address[] memory recipients, Coin[] memory coins, string[] memory memos) external payable {
116         require((recipients.length == coins.length) && (coins.length == memos.length));
117         for(uint i = 0; i < coins.length; i++){
118             transferOut(payable(recipients[i]), coins[i].asset, coins[i].amount, memos[i]);
119         }
120     }
121 
122     //############################## VAULT MANAGEMENT ##############################
123 
124     // A vault can call to "return" all assets to an asgard, including ETH. 
125     function returnVaultAssets(address router, address payable asgard, Coin[] memory coins, string memory memo) external payable {
126         if (router == address(this)){
127             for(uint i = 0; i < coins.length; i++){
128                 _adjustAllowances(asgard, coins[i].asset, coins[i].amount);
129             }
130             emit VaultTransfer(msg.sender, asgard, coins, memo); // Does not include ETH.           
131         } else {
132             for(uint i = 0; i < coins.length; i++){
133                 _routerDeposit(router, asgard, coins[i].asset, coins[i].amount, memo);
134             }
135         }
136         (bool success,) = asgard.call{value:msg.value}(""); //ETH amount needs to be parsed from tx.
137         require(success);
138     }
139 
140     //############################## HELPERS ##############################
141 
142     // Safe transferFrom in case asset charges transfer fees
143     function safeTransferFrom(address _asset, uint _amount) internal returns(uint amount) {
144         uint _startBal = iERC20(_asset).balanceOf(address(this));
145         (bool success,) = _asset.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), _amount));
146         require(success);
147         return (iERC20(_asset).balanceOf(address(this)) - _startBal);
148     }
149 
150     // Decrements and Increments Allowances between two vaults
151     function _adjustAllowances(address _newVault, address _asset, uint _amount) internal {
152         vaultAllowance[msg.sender][_asset] -= _amount;
153         vaultAllowance[_newVault][_asset] += _amount;
154     }
155 
156     // Adjust allowance and forwards funds to new router, credits allowance to desired vault
157     function _routerDeposit(address _router, address _vault, address _asset, uint _amount, string memory _memo) internal {
158         vaultAllowance[msg.sender][_asset] -= _amount;
159         (bool success,) = _asset.call(abi.encodeWithSignature("approve(address,uint256)", _router, _amount)); // Approve to transfer
160         require(success);
161         iROUTER(_router).depositWithExpiry(_vault, _asset, _amount, _memo, type(uint).max); // Transfer by depositing
162     }
163 }