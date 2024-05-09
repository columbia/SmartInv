1 {{
2   "language": "Solidity",
3   "sources": {
4     "/Users/ahmedali/Desktop/work/mainnet-deployment/ocean-contracts/contracts/interfaces/IERC20Template.sol": {
5       "content": "pragma solidity >=0.5.0;\n\ninterface IERC20Template {\n    function initialize(\n        string calldata name,\n        string calldata symbol,\n        address minter,\n        uint256 cap,\n        string calldata blob,\n        address collector\n    ) external returns (bool);\n\n    function mint(address account, uint256 value) external;\n    function minter() external view returns(address);    \n    function name() external view returns (string memory);\n    function symbol() external view returns (string memory);\n    function decimals() external view returns (uint8);\n    function cap() external view returns (uint256);\n    function isMinter(address account) external view returns (bool);\n    function isInitialized() external view returns (bool);\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n    function transferFrom(\n        address from,\n        address to,\n        uint256 value\n    ) external returns (bool);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address to, uint256 value) external returns (bool);\n    function proposeMinter(address newMinter) external;\n    function approveMinter() external;\n}\n"
6     },
7     "/Users/ahmedali/Desktop/work/mainnet-deployment/ocean-contracts/contracts/metadata/Metadata.sol": {
8       "content": "pragma solidity 0.5.7;\n// Copyright BigchainDB GmbH and Ocean Protocol contributors\n// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)\n// Code is Apache-2.0 and docs are CC-BY-4.0\n\nimport '../interfaces/IERC20Template.sol';\n\n\n/**\n* @title Metadata\n*  \n* @dev Metadata stands for Decentralized Document. It allows publishers\n*      to publish their dataset metadata in decentralized way.\n*      It follows the Ocean DID Document standard: \n*      https://github.com/oceanprotocol/OEPs/blob/master/7/v0.2/README.md\n*/\ncontract Metadata {\n\n    event MetadataCreated(\n        address indexed dataToken,\n        address indexed createdBy,\n        bytes flags,\n        bytes data\n    );\n    event MetadataUpdated(\n        address indexed dataToken,\n        address indexed updatedBy,\n        bytes flags,\n        bytes data\n    );\n\n    modifier onlyDataTokenMinter(address dataToken)\n    {\n        IERC20Template token = IERC20Template(dataToken);\n        require(\n            token.minter() == msg.sender,\n            'Metadata: Invalid DataToken Minter'\n        );\n        _;\n    }\n\n    /**\n     * @dev create\n     *      creates/publishes new metadata/DDO document on-chain. \n     * @param dataToken refers to data token address\n     * @param flags special flags associated with metadata\n     * @param data referes to the actual metadata\n     */\n    function create(\n        address dataToken,\n        bytes calldata flags,\n        bytes calldata data\n    ) \n        external\n        onlyDataTokenMinter(dataToken)\n    {\n        emit MetadataCreated(\n            dataToken,\n            msg.sender,\n            flags,\n            data\n        );\n    }\n\n    /**\n     * @dev update\n     *      allows only datatoken minter(s) to update the DDO/metadata content\n     * @param dataToken refers to data token address\n     * @param flags special flags associated with metadata\n     * @param data referes to the actual metadata\n     */\n    function update(\n        address dataToken,\n        bytes calldata flags,\n        bytes calldata data\n    ) \n        external\n        onlyDataTokenMinter(dataToken)\n    {\n        emit MetadataUpdated(\n            dataToken,\n            msg.sender,\n            flags,\n            data\n        );\n    }\n}"
9     }
10   },
11   "settings": {
12     "remappings": [],
13     "optimizer": {
14       "enabled": true,
15       "runs": 200
16     },
17     "evmVersion": "byzantium",
18     "libraries": {
19       "": {}
20     },
21     "outputSelection": {
22       "*": {
23         "*": [
24           "evm.bytecode",
25           "evm.deployedBytecode",
26           "abi"
27         ]
28       }
29     }
30   }
31 }}