{{
  "language": "Solidity",
  "sources": {
    "contracts/stakingV2/ApeXPool2.sol": {
      "content": "// SPDX-License-Identifier: GPL-2.0-or-later\npragma solidity ^0.8.0;\n\nimport \"./interfaces/IApeXPool2.sol\";\nimport \"../utils/Ownable.sol\";\nimport \"../libraries/TransferHelper.sol\";\n\ncontract ApeXPool2 is IApeXPool2, Ownable {\n    address public immutable override apeX;\n    address public immutable override esApeX;\n\n    mapping(address => mapping(uint256 => uint256)) public override stakingAPEX;\n    mapping(address => mapping(uint256 => uint256)) public override stakingEsAPEX;\n\n    bool public override paused;\n\n    constructor(address _apeX, address _esApeX, address _owner) {\n        apeX = _apeX;\n        esApeX = _esApeX;\n        owner = _owner;\n    }\n\n    function setPaused(bool newState) external override onlyOwner {\n        require(paused != newState, \"same state\");\n        paused = newState;\n        emit PausedStateChanged(newState);\n    }\n\n    function stakeAPEX(uint256 accountId, uint256 amount) external override {\n        require(!paused, \"paused\");\n        TransferHelper.safeTransferFrom(apeX, msg.sender, address(this), amount);\n        stakingAPEX[msg.sender][accountId] += amount;\n        emit Staked(apeX, msg.sender, accountId, amount);\n    }\n\n    function stakeEsAPEX(uint256 accountId, uint256 amount) external override {\n        require(!paused, \"paused\");\n        TransferHelper.safeTransferFrom(esApeX, msg.sender, address(this), amount);\n        stakingEsAPEX[msg.sender][accountId] += amount;\n        emit Staked(esApeX, msg.sender, accountId, amount);\n    }\n\n    function unstakeAPEX(address to, uint256 accountId, uint256 amount) external override {\n        require(amount <= stakingAPEX[msg.sender][accountId], \"not enough balance\");\n        stakingAPEX[msg.sender][accountId] -= amount;\n        TransferHelper.safeTransfer(apeX, to, amount);\n        emit Unstaked(apeX, msg.sender, to, accountId, amount);\n    }\n\n    function unstakeEsAPEX(address to, uint256 accountId, uint256 amount) external override {\n        require(amount <= stakingEsAPEX[msg.sender][accountId], \"not enough balance\");\n        stakingEsAPEX[msg.sender][accountId] -= amount;\n        TransferHelper.safeTransfer(esApeX, to, amount);\n        emit Unstaked(esApeX, msg.sender, to, accountId, amount);\n    }\n}\n"
    },
    "contracts/stakingV2/interfaces/IApeXPool2.sol": {
      "content": "// SPDX-License-Identifier: GPL-2.0-or-later\npragma solidity ^0.8.0;\n\ninterface IApeXPool2 {\n    event PausedStateChanged(bool newState);\n    event Staked(address indexed token, address indexed user, uint256 accountId, uint256 amount);\n    event Unstaked(address indexed token, address indexed user, address indexed to, uint256 accountId, uint256 amount);\n\n    function apeX() external view returns (address);\n\n    function esApeX() external view returns (address);\n\n    function stakingAPEX(address user, uint256 accountId) external view returns (uint256);\n\n    function stakingEsAPEX(address user, uint256 accountId) external view returns (uint256);\n\n    function paused() external view returns (bool);\n\n    function setPaused(bool newState) external;\n\n    function stakeAPEX(uint256 accountId, uint256 amount) external;\n\n    function stakeEsAPEX(uint256 accountId, uint256 amount) external;\n\n    function unstakeAPEX(address to, uint256 accountId, uint256 amount) external;\n\n    function unstakeEsAPEX(address to, uint256 accountId, uint256 amount) external;\n}\n"
    },
    "contracts/utils/Ownable.sol": {
      "content": "// SPDX-License-Identifier: GPL-2.0-or-later\npragma solidity ^0.8.0;\n\nabstract contract Ownable {\n    address public owner;\n    address public pendingOwner;\n\n    event NewOwner(address indexed oldOwner, address indexed newOwner);\n    event NewPendingOwner(address indexed oldPendingOwner, address indexed newPendingOwner);\n\n    modifier onlyOwner() {\n        require(msg.sender == owner, \"Ownable: REQUIRE_OWNER\");\n        _;\n    }\n\n    function setPendingOwner(address newPendingOwner) external onlyOwner {\n        require(pendingOwner != newPendingOwner, \"Ownable: ALREADY_SET\");\n        emit NewPendingOwner(pendingOwner, newPendingOwner);\n        pendingOwner = newPendingOwner;\n    }\n\n    function acceptOwner() external {\n        require(msg.sender == pendingOwner, \"Ownable: REQUIRE_PENDING_OWNER\");\n        address oldOwner = owner;\n        address oldPendingOwner = pendingOwner;\n        owner = pendingOwner;\n        pendingOwner = address(0);\n        emit NewOwner(oldOwner, owner);\n        emit NewPendingOwner(oldPendingOwner, pendingOwner);\n    }\n}\n"
    },
    "contracts/libraries/TransferHelper.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\nlibrary TransferHelper {\n    function safeApprove(\n        address token,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('approve(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            \"TransferHelper::safeApprove: approve failed\"\n        );\n    }\n\n    function safeTransfer(\n        address token,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            \"TransferHelper::safeTransfer: transfer failed\"\n        );\n    }\n\n    function safeTransferFrom(\n        address token,\n        address from,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            \"TransferHelper::transferFrom: transferFrom failed\"\n        );\n    }\n\n    function safeTransferETH(address to, uint256 value) internal {\n        (bool success, ) = to.call{value: value}(new bytes(0));\n        require(success, \"TransferHelper::safeTransferETH: ETH transfer failed\");\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}