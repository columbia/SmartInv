{{
  "language": "Solidity",
  "sources": {
    "contracts/ProtocolFeeRecipient.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.17;\n\n// LooksRare unopinionated libraries\nimport {LowLevelERC20Transfer} from \"@looksrare/contracts-libs/contracts/lowLevelCallers/LowLevelERC20Transfer.sol\";\nimport {IWETH} from \"@looksrare/contracts-libs/contracts/interfaces/generic/IWETH.sol\";\nimport {IERC20} from \"@looksrare/contracts-libs/contracts/interfaces/generic/IERC20.sol\";\n\n/**\n * @title ProtocolFeeRecipient\n * @notice This contract is used to receive protocol fees and transfer them to the fee sharing setter.\n *         Fee sharing setter cannot receive ETH directly, so we need to use this contract as a middleman\n *         to convert ETH into WETH before sending it.\n * @author LooksRare protocol team (👀,💎)\n */\ncontract ProtocolFeeRecipient is LowLevelERC20Transfer {\n    address public immutable FEE_SHARING_SETTER;\n    IWETH public immutable WETH;\n\n    error NothingToTransfer();\n\n    constructor(address _feeSharingSetter, address _weth) {\n        FEE_SHARING_SETTER = _feeSharingSetter;\n        WETH = IWETH(_weth);\n    }\n\n    function transferETH() external {\n        uint256 ethBalance = address(this).balance;\n\n        if (ethBalance != 0) {\n            WETH.deposit{value: ethBalance}();\n        }\n\n        uint256 wethBalance = IERC20(address(WETH)).balanceOf(address(this));\n\n        if (wethBalance == 0) {\n            revert NothingToTransfer();\n        }\n        _executeERC20DirectTransfer(address(WETH), FEE_SHARING_SETTER, wethBalance);\n    }\n\n    /**\n     * @param currency ERC20 currency address\n     */\n    function transferERC20(address currency) external {\n        uint256 balance = IERC20(currency).balanceOf(address(this));\n        if (balance == 0) {\n            revert NothingToTransfer();\n        }\n        _executeERC20DirectTransfer(currency, FEE_SHARING_SETTER, balance);\n    }\n\n    receive() external payable {}\n}\n"
    },
    "node_modules/@looksrare/contracts-libs/contracts/errors/GenericErrors.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\n/**\n * @notice It is emitted if the call recipient is not a contract.\n */\nerror NotAContract();\n"
    },
    "node_modules/@looksrare/contracts-libs/contracts/errors/LowLevelErrors.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\n/**\n * @notice It is emitted if the ETH transfer fails.\n */\nerror ETHTransferFail();\n\n/**\n * @notice It is emitted if the ERC20 approval fails.\n */\nerror ERC20ApprovalFail();\n\n/**\n * @notice It is emitted if the ERC20 transfer fails.\n */\nerror ERC20TransferFail();\n\n/**\n * @notice It is emitted if the ERC20 transferFrom fails.\n */\nerror ERC20TransferFromFail();\n\n/**\n * @notice It is emitted if the ERC721 transferFrom fails.\n */\nerror ERC721TransferFromFail();\n\n/**\n * @notice It is emitted if the ERC1155 safeTransferFrom fails.\n */\nerror ERC1155SafeTransferFromFail();\n\n/**\n * @notice It is emitted if the ERC1155 safeBatchTransferFrom fails.\n */\nerror ERC1155SafeBatchTransferFromFail();\n"
    },
    "node_modules/@looksrare/contracts-libs/contracts/interfaces/generic/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\ninterface IERC20 {\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "node_modules/@looksrare/contracts-libs/contracts/interfaces/generic/IWETH.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.5.0;\n\ninterface IWETH {\n    function deposit() external payable;\n\n    function transfer(address dst, uint256 wad) external returns (bool);\n\n    function withdraw(uint256 wad) external;\n}\n"
    },
    "node_modules/@looksrare/contracts-libs/contracts/lowLevelCallers/LowLevelERC20Transfer.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\n// Interfaces\nimport {IERC20} from \"../interfaces/generic/IERC20.sol\";\n\n// Errors\nimport {ERC20TransferFail, ERC20TransferFromFail} from \"../errors/LowLevelErrors.sol\";\nimport {NotAContract} from \"../errors/GenericErrors.sol\";\n\n/**\n * @title LowLevelERC20Transfer\n * @notice This contract contains low-level calls to transfer ERC20 tokens.\n * @author LooksRare protocol team (👀,💎)\n */\ncontract LowLevelERC20Transfer {\n    /**\n     * @notice Execute ERC20 transferFrom\n     * @param currency Currency address\n     * @param from Sender address\n     * @param to Recipient address\n     * @param amount Amount to transfer\n     */\n    function _executeERC20TransferFrom(address currency, address from, address to, uint256 amount) internal {\n        if (currency.code.length == 0) {\n            revert NotAContract();\n        }\n\n        (bool status, bytes memory data) = currency.call(abi.encodeCall(IERC20.transferFrom, (from, to, amount)));\n\n        if (!status) {\n            revert ERC20TransferFromFail();\n        }\n\n        if (data.length > 0) {\n            if (!abi.decode(data, (bool))) {\n                revert ERC20TransferFromFail();\n            }\n        }\n    }\n\n    /**\n     * @notice Execute ERC20 (direct) transfer\n     * @param currency Currency address\n     * @param to Recipient address\n     * @param amount Amount to transfer\n     */\n    function _executeERC20DirectTransfer(address currency, address to, uint256 amount) internal {\n        if (currency.code.length == 0) {\n            revert NotAContract();\n        }\n\n        (bool status, bytes memory data) = currency.call(abi.encodeCall(IERC20.transfer, (to, amount)));\n\n        if (!status) {\n            revert ERC20TransferFail();\n        }\n\n        if (data.length > 0) {\n            if (!abi.decode(data, (bool))) {\n                revert ERC20TransferFail();\n            }\n        }\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "@chainlink/=node_modules/@chainlink/",
      "@ensdomains/=node_modules/@ensdomains/",
      "@eth-optimism/=node_modules/@eth-optimism/",
      "@looksrare/=node_modules/@looksrare/",
      "@openzeppelin/=node_modules/@openzeppelin/",
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "eth-gas-reporter/=node_modules/eth-gas-reporter/",
      "forge-std/=lib/forge-std/src/",
      "hardhat/=node_modules/hardhat/",
      "murky/=lib/murky/src/",
      "openzeppelin-contracts/=lib/murky/lib/openzeppelin-contracts/",
      "solmate/=node_modules/solmate/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 888888
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}