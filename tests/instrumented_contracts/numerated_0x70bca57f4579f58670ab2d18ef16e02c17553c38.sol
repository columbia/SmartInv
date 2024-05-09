1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/EIP1559Burn.sol": {
5       "content": "//SPDX-License-Identifier: Apache-2.0\npragma solidity ^0.8.9;\n\ninterface IERC20 {\n    function withdraw(uint256 amount) external payable;\n    function transfer(address to, uint256 value) external returns (bool);\n    function balanceOf(address who) external view returns (uint256);\n}\n\ninterface IERC20Predicate {\n    function startExitWithBurntTokens(bytes calldata data) external;\n}\n\ninterface IWithdrawManager {\n    function processExits(address _token) external;\n}\n\ncontract EIP1559Burn {\n    IERC20 public immutable maticRootToken;\n    IERC20 public immutable maticChildToken = IERC20(0x0000000000000000000000000000000000001010);\n    IWithdrawManager public immutable withdrawManager;\n    uint24 public immutable rootChainId;\n    uint24 public immutable childChainId;\n\n    constructor(\n        IERC20 _maticRootToken,\n        IWithdrawManager _withdrawManager,\n        uint24 _rootChainId,\n        uint24 _childChainId\n        ) {\n        maticRootToken = _maticRootToken;\n        withdrawManager = _withdrawManager;\n        rootChainId = _rootChainId;\n        childChainId = _childChainId;\n    }\n\n    modifier onlyRootChain() {\n        require(block.chainid == rootChainId, \"ONLY_ROOT\");\n        _;\n    }\n\n    modifier onlyChildChain() {\n        require(block.chainid == childChainId, \"ONLY_CHILD\");\n        _;\n    }\n\n    receive() external payable {\n\n    }\n\n    function withdraw() external onlyChildChain payable {\n        maticChildToken.withdraw{value: address(this).balance}(address(this).balance);\n    }\n\n    function initiateExit(IERC20Predicate _erc20Predicate, bytes calldata data) external onlyRootChain {\n        _erc20Predicate.startExitWithBurntTokens(data);\n    }\n\n    function exit() external onlyRootChain {\n        require(gasleft() > 370000, \"MORE_GAS_NEEDED\"); // WithdrawManager needs 300k, 65k for ERC20 transfer + leeway\n        withdrawManager.processExits(address(maticRootToken));\n        uint256 tokenBalance = maticRootToken.balanceOf(address(this));\n        if (tokenBalance > 0) {\n            maticRootToken.transfer(0x000000000000000000000000000000000000dEaD, tokenBalance);\n        }\n    }\n}\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": true,
11       "runs": 9999
12     },
13     "outputSelection": {
14       "*": {
15         "*": [
16           "evm.bytecode",
17           "evm.deployedBytecode",
18           "devdoc",
19           "userdoc",
20           "metadata",
21           "abi"
22         ]
23       }
24     },
25     "libraries": {}
26   }
27 }}