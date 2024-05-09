{{
  "language": "Solidity",
  "sources": {
    "contracts/producers/crowdfunds/crowdfund-with-podium-editions/CrowdfundWithPodiumEditionsProxy.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\npragma solidity 0.8.6;\n\nimport {CrowdfundWithPodiumEditionsStorage} from \"./CrowdfundWithPodiumEditionsStorage.sol\";\n\ninterface ICrowdfundWithPodiumEditionsFactory {\n    function mediaAddress() external returns (address);\n\n    function logic() external returns (address);\n\n    function editions() external returns (address);\n\n    // ERC20 data.\n    function parameters()\n        external\n        returns (\n            address payable fundingRecipient,\n            uint256 fundingCap,\n            uint256 operatorPercent,\n            string memory name,\n            string memory symbol,\n            uint256 feePercentage,\n            uint256 podiumDuration\n        );\n}\n\n/**\n * @title CrowdfundWithPodiumEditionsProxy\n * @author MirrorXYZ\n */\ncontract CrowdfundWithPodiumEditionsProxy is\n    CrowdfundWithPodiumEditionsStorage\n{\n    constructor(address treasuryConfig_, address payable operator_) {\n        logic = ICrowdfundWithPodiumEditionsFactory(msg.sender).logic();\n        editions = ICrowdfundWithPodiumEditionsFactory(msg.sender).editions();\n        // Crowdfund-specific data.\n        (\n            fundingRecipient,\n            fundingCap,\n            operatorPercent,\n            name,\n            symbol,\n            feePercentage,\n            podiumDuration\n        ) = ICrowdfundWithPodiumEditionsFactory(msg.sender).parameters();\n\n        operator = operator_;\n        treasuryConfig = treasuryConfig_;\n        // Initialize mutable storage.\n        status = Status.FUNDING;\n    }\n\n    fallback() external payable {\n        address _impl = logic;\n        assembly {\n            let ptr := mload(0x40)\n            calldatacopy(ptr, 0, calldatasize())\n            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)\n            let size := returndatasize()\n            returndatacopy(ptr, 0, size)\n\n            switch result\n            case 0 {\n                revert(ptr, size)\n            }\n            default {\n                return(ptr, size)\n            }\n        }\n    }\n\n    receive() external payable {}\n}\n"
    },
    "contracts/producers/crowdfunds/crowdfund-with-podium-editions/CrowdfundWithPodiumEditionsStorage.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\npragma solidity 0.8.6;\n\n/**\n * @title CrowdfundWithPodiumEditionsStorage\n * @author MirrorXYZ\n */\ncontract CrowdfundWithPodiumEditionsStorage {\n    // The two states that this contract can exist in. \"FUNDING\" allows\n    // contributors to add funds.\n    enum Status {\n        FUNDING,\n        TRADING\n    }\n\n    // ============ Constants ============\n\n    // The factor by which ETH contributions will multiply into crowdfund tokens.\n    uint16 internal constant TOKEN_SCALE = 1000;\n    uint256 internal constant REENTRANCY_NOT_ENTERED = 1;\n    uint256 internal constant REENTRANCY_ENTERED = 2;\n    uint16 public constant PODIUM_TIME_BUFFER = 900;\n    uint8 public constant decimals = 18;\n\n    // ============ Immutable Storage ============\n\n    // The operator has a special role to change contract status.\n    address payable public operator;\n    address payable public fundingRecipient;\n    address public treasuryConfig;\n    // We add a hard cap to prevent raising more funds than deemed reasonable.\n    uint256 public fundingCap;\n    uint256 public feePercentage;\n    // The operator takes some equity in the tokens, represented by this percent.\n    uint256 public operatorPercent;\n    string public symbol;\n    string public name;\n\n    // ============ Mutable Storage ============\n\n    // Represents the current state of the campaign.\n    Status public status;\n    uint256 internal reentrancy_status;\n\n\n    // Podium storage\n    uint256 public podiumStartTime;\n    uint256 public podiumDuration;\n\n    // ============ Mutable ERC20 Attributes ============\n\n    uint256 public totalSupply;\n    mapping(address => uint256) public balanceOf;\n    mapping(address => mapping(address => uint256)) public allowance;\n    mapping(address => uint256) public nonces;\n\n    // ============ Delegation logic ============\n    address public logic;\n\n    // ============ Tiered Campaigns ============\n    // Address of the editions contract to purchase from.\n    address public editions;\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 2000
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}