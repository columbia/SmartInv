1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/FlyzStakingHelper.sol": {
5       "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity 0.7.5;\n\nimport './interfaces/IERC20.sol';\nimport './interfaces/IFlyzStaking.sol';\n\ncontract FlyzStakingHelper {\n    address public immutable staking;\n    address public immutable FLYZ;\n\n    constructor(address _staking, address _FLYZ) {\n        require(_staking != address(0));\n        staking = _staking;\n        require(_FLYZ != address(0));\n        FLYZ = _FLYZ;\n    }\n\n    function stake(uint256 _amount, address _recipient) external {\n        IERC20(FLYZ).transferFrom(msg.sender, address(this), _amount);\n        IERC20(FLYZ).approve(staking, _amount);\n        IFlyzStaking(staking).stake(_amount, _recipient);\n        IFlyzStaking(staking).claim(_recipient);\n    }\n}\n"
6     },
7     "contracts/interfaces/IERC20.sol": {
8       "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity >=0.5.0;\n\ninterface IERC20 {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address owner) external view returns (uint256);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n\n    function approve(address spender, uint256 value) external returns (bool);\n\n    function transfer(address to, uint256 value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 value\n    ) external returns (bool);\n}\n\ninterface IERC20Mintable {\n    function mint(uint256 amount_) external;\n\n    function mint(address account_, uint256 ammount_) external;\n}\n"
9     },
10     "contracts/interfaces/IFlyzStaking.sol": {
11       "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity 0.7.5;\n\ninterface IFlyzStaking {\n    function stake(uint256 _amount, address _recipient) external returns (bool);\n\n    function claim(address _recipient) external;\n}\n"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": true,
17       "runs": 200
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "devdoc",
25           "userdoc",
26           "metadata",
27           "abi"
28         ]
29       }
30     },
31     "libraries": {}
32   }
33 }}