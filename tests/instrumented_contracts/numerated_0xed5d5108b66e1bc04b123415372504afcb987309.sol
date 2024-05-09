1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "london",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "details": {
12         "constantOptimizer": true,
13         "cse": true,
14         "deduplicate": true,
15         "inliner": true,
16         "jumpdestRemover": true,
17         "orderLiterals": true,
18         "peephole": true,
19         "yul": true,
20         "yulDetails": {
21           "optimizerSteps": "dhfoDgvulfnTUtnIf",
22           "stackAllocation": true
23         }
24       },
25       "runs": 2000
26     },
27     "remappings": [],
28     "outputSelection": {
29       "*": {
30         "*": [
31           "evm.bytecode",
32           "evm.deployedBytecode",
33           "devdoc",
34           "userdoc",
35           "metadata",
36           "abi"
37         ]
38       }
39     }
40   },
41   "sources": {
42     "@openzeppelin/contracts/security/Pausable.sol": {
43       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which allows children to implement an emergency stop\n * mechanism that can be triggered by an authorized account.\n *\n * This module is used through inheritance. It will make available the\n * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n * the functions of your contract. Note that they will not be pausable by\n * simply including this module, only once the modifiers are put in place.\n */\nabstract contract Pausable is Context {\n    /**\n     * @dev Emitted when the pause is triggered by `account`.\n     */\n    event Paused(address account);\n\n    /**\n     * @dev Emitted when the pause is lifted by `account`.\n     */\n    event Unpaused(address account);\n\n    bool private _paused;\n\n    /**\n     * @dev Initializes the contract in unpaused state.\n     */\n    constructor() {\n        _paused = false;\n    }\n\n    /**\n     * @dev Returns true if the contract is paused, and false otherwise.\n     */\n    function paused() public view virtual returns (bool) {\n        return _paused;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is not paused.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    modifier whenNotPaused() {\n        require(!paused(), \"Pausable: paused\");\n        _;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is paused.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    modifier whenPaused() {\n        require(paused(), \"Pausable: not paused\");\n        _;\n    }\n\n    /**\n     * @dev Triggers stopped state.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    function _pause() internal virtual whenNotPaused {\n        _paused = true;\n        emit Paused(_msgSender());\n    }\n\n    /**\n     * @dev Returns to normal state.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    function _unpause() internal virtual whenPaused {\n        _paused = false;\n        emit Unpaused(_msgSender());\n    }\n}\n"
44     },
45     "@openzeppelin/contracts/utils/Context.sol": {
46       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
47     },
48     "contracts/MasterStaker.sol": {
49       "content": "// SPDX-License-Identifier: MIT LICENSE\n\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/security/Pausable.sol\";\nimport \"./interfaces/IPytheas.sol\";\nimport \"./interfaces/IOrbitalBlockade.sol\";\nimport \"./interfaces/IMasterStaker.sol\";\n\ncontract MasterStaker is IMasterStaker, Pausable {\n    address public auth;\n\n    mapping(address => bool) private admins;\n\n    // reference to Pytheas for stake of colonist\n    IPytheas public pytheas;\n\n    //reference to the oribitalBlockade for stake of pirates\n    IOrbitalBlockade public orbital;\n\n    constructor() {\n        auth = msg.sender;\n    }\n\n    modifier noCheaters() {\n        uint256 size = 0;\n        address acc = msg.sender;\n        assembly {\n            size := extcodesize(acc)\n        }\n\n        require(\n            msg.sender == tx.origin && size == 0,\n            \"you're trying to cheat!\"\n        );\n        _;\n    }\n    modifier onlyOwner() {\n        require(msg.sender == auth);\n        _;\n    }\n\n    /** CRITICAL TO SETUP */\n    modifier requireContractsSet() {\n        require(\n            address(pytheas) != address(0) && address(orbital) != address(0),\n            \"Contracts not set\"\n        );\n        _;\n    }\n\n    function setContracts(address _pytheas, address _orbital)\n        external\n        onlyOwner\n    {\n        pytheas = IPytheas(_pytheas);\n        orbital = IOrbitalBlockade(_orbital);\n    }\n\n    function masterStake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.addColonistToPytheas(msg.sender, colonistIds);\n        orbital.addPiratesToCrew(msg.sender, pirateIds);\n    }\n\n    function masterUnstake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.claimColonistFromPytheas(msg.sender, colonistIds, true);\n        orbital.claimPiratesFromCrew(msg.sender, pirateIds, true);\n    }\n\n    function masterClaim(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external whenNotPaused noCheaters {\n        uint16[] memory colonistIds = uint16[](colonistTokenIds);\n        uint16[] memory pirateIds = uint16[](pirateTokenIds);\n        pytheas.claimColonistFromPytheas(msg.sender, colonistIds, false);\n        orbital.claimPiratesFromCrew(msg.sender, pirateIds, false);\n    }\n\n    /**\n     * enables owner to pause / unpause contract\n     */\n    function setPaused(bool _paused) external requireContractsSet onlyOwner {\n        if (_paused) _pause();\n        else _unpause();\n    }\n\n    function transferOwnership(address newOwner) external onlyOwner {\n        auth = newOwner;\n    }\n}\n"
50     },
51     "contracts/interfaces/IMasterStaker.sol": {
52       "content": "// SPDX-License-Identifier: MIT LICENSE\npragma solidity ^0.8.0;\n\ninterface IMasterStaker {\n\n function masterStake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n\n function masterUnstake(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n\n function masterClaim(\n        uint16[] calldata colonistTokenIds,\n        uint16[] calldata pirateTokenIds\n    ) external;\n}"
53     },
54     "contracts/interfaces/IOrbitalBlockade.sol": {
55       "content": "// SPDX-License-Identifier: MIT LICENSE\n\npragma solidity ^0.8.0;\n\ninterface IOrbitalBlockade {\n    function addPiratesToCrew(address account, uint16[] calldata tokenIds)\n        external;\n    \n    function claimPiratesFromCrew(address account, uint16[] calldata tokenIds, bool unstake)\n        external;\n\n    function payPirateTax(uint256 amount) external;\n\n    function randomPirateOwner(uint256 seed) external view returns (address);\n}\n"
56     },
57     "contracts/interfaces/IPytheas.sol": {
58       "content": "// SPDX-License-Identifier: MIT LICENSE\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IPytheas {\r\n    function addColonistToPytheas(address account, uint16[] calldata tokenIds)\r\n        external;\r\n\r\n    function claimColonistFromPytheas(address account, uint16[] calldata tokenIds, bool unstake)\r\n        external;\r\n\r\n    function getColonistMined(address account, uint16 tokenId)\r\n        external\r\n        returns (uint256);\r\n\r\n    function handleJoinPirates(address addr, uint16 tokenId) external;\r\n\r\n    function payUp(\r\n        uint16 tokenId,\r\n        uint256 amtMined,\r\n        address addr\r\n    ) external;\r\n}\r\n"
59     }
60   }
61 }}