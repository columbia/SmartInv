{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "details": {
        "constantOptimizer": true,
        "cse": true,
        "deduplicate": true,
        "inliner": true,
        "jumpdestRemover": true,
        "orderLiterals": true,
        "peephole": true,
        "yul": true,
        "yulDetails": {
          "optimizerSteps": "dhfoDgvulfnTUtnIf",
          "stackAllocation": true
        }
      },
      "runs": 2000
    },
    "remappings": [],
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
    }
  },
  "sources": {
    "@openzeppelin/contracts/security/Pausable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which allows children to implement an emergency stop\n * mechanism that can be triggered by an authorized account.\n *\n * This module is used through inheritance. It will make available the\n * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n * the functions of your contract. Note that they will not be pausable by\n * simply including this module, only once the modifiers are put in place.\n */\nabstract contract Pausable is Context {\n    /**\n     * @dev Emitted when the pause is triggered by `account`.\n     */\n    event Paused(address account);\n\n    /**\n     * @dev Emitted when the pause is lifted by `account`.\n     */\n    event Unpaused(address account);\n\n    bool private _paused;\n\n    /**\n     * @dev Initializes the contract in unpaused state.\n     */\n    constructor() {\n        _paused = false;\n    }\n\n    /**\n     * @dev Returns true if the contract is paused, and false otherwise.\n     */\n    function paused() public view virtual returns (bool) {\n        return _paused;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is not paused.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    modifier whenNotPaused() {\n        require(!paused(), \"Pausable: paused\");\n        _;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is paused.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    modifier whenPaused() {\n        require(paused(), \"Pausable: not paused\");\n        _;\n    }\n\n    /**\n     * @dev Triggers stopped state.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    function _pause() internal virtual whenNotPaused {\n        _paused = true;\n        emit Paused(_msgSender());\n    }\n\n    /**\n     * @dev Returns to normal state.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    function _unpause() internal virtual whenPaused {\n        _paused = false;\n        emit Unpaused(_msgSender());\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "contracts/MasterStaker.sol": {
      "content": "// SPDX-License-Identifier: MIT LICENSE\n\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/security/Pausable.sol\";\nimport \"./interfaces/IPytheas.sol\";\nimport \"./interfaces/IOrbitalBlockade.sol\";\nimport \"./interfaces/IMasterStaker.sol\";\n\ncontract MasterStaker is IMasterStaker, Pausable {\n    address public auth;\n\n    mapping(address => bool) private admins;\n\n    // reference to Pytheas for stake of colonist\n    IPytheas public pytheas;\n\n    //reference to the oribitalBlockade for stake of pirates\n    IOrbitalBlockade public orbital;\n\n    constructor() {\n        auth = msg.sender;\n    }\n\n    modifier noCheaters() {\n        uint256 size = 0;\n        address acc = msg.sender;\n        assembly {\n            size := extcodesize(acc)\n        }\n\n        require(\n            msg.sender == tx.origin && size == 0,\n            \"you're trying to cheat!\"\n        );\n        _;\n    }\n    modifier onlyOwner() {\n        require(msg.sender == auth);\n        _;\n    }\n\n    /** CRITICAL TO SETUP */\n    modifier requireContractsSet() {\n        require(\n            address(pytheas) != address(0) && address(orbital) != address(0),\n            \"Contracts not set\"\n        );\n        _;\n    }\n\n    function setContracts(address _pytheas, address _orbital)\n        external\n        onlyOwner\n    {\n        pytheas = IPytheas(_pytheas);\n        orbital = IOrbitalBlockade(_orbital);\n    }\n\n    function masterStake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.addColonistToPytheas(msg.sender, colonistIds);\n        orbital.addPiratesToCrew(msg.sender, pirateIds);\n    }\n\n    function masterUnstake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.claimColonistFromPytheas(msg.sender, colonistIds, true);\n        orbital.claimPiratesFromCrew(msg.sender, pirateIds, true);\n    }\n\n    function masterClaim(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.claimColonistFromPytheas(msg.sender, colonistIds, false);\n        orbital.claimPiratesFromCrew(msg.sender, pirateIds, false);\n    }\n\n    /**\n     * enables owner to pause / unpause contract\n     */\n    function setPaused(bool _paused) external requireContractsSet onlyOwner {\n        if (_paused) _pause();\n        else _unpause();\n    }\n\n    function transferOwnership(address newOwner) external onlyOwner {\n        auth = newOwner;\n    }\n}\n"
    },
    "contracts/interfaces/IMasterStaker.sol": {
      "content": "// SPDX-License-Identifier: MIT LICENSE\npragma solidity ^0.8.0;\n\ninterface IMasterStaker {\n\n function masterStake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n\n function masterUnstake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n\n function masterClaim(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n}"
    },
    "contracts/interfaces/IOrbitalBlockade.sol": {
      "content": "// SPDX-License-Identifier: MIT LICENSE\n\npragma solidity ^0.8.0;\n\ninterface IOrbitalBlockade {\n    function addPiratesToCrew(address account, uint16[] calldata tokenIds)\n        external;\n    \n    function claimPiratesFromCrew(address account, uint16[] calldata tokenIds, bool unstake)\n        external;\n\n    function payPirateTax(uint256 amount) external;\n\n    function randomPirateOwner(uint256 seed) external view returns (address);\n}\n"
    },
    "contracts/interfaces/IPytheas.sol": {
      "content": "// SPDX-License-Identifier: MIT LICENSE\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IPytheas {\r\n    function addColonistToPytheas(address account, uint16[] calldata tokenIds)\r\n        external;\r\n\r\n    function claimColonistFromPytheas(address account, uint16[] calldata tokenIds, bool unstake)\r\n        external;\r\n\r\n    function getColonistMined(address account, uint16 tokenId)\r\n        external\r\n        returns (uint256);\r\n\r\n    function handleJoinPirates(address addr, uint16 tokenId) external;\r\n\r\n    function payUp(\r\n        uint16 tokenId,\r\n        uint256 amtMined,\r\n        address addr\r\n    ) external;\r\n}\r\n"
    }
  }
}}