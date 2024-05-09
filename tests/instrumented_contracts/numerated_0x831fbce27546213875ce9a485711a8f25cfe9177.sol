1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "enabled": true,
12       "runs": 200
13     },
14     "remappings": [],
15     "outputSelection": {
16       "*": {
17         "*": [
18           "evm.bytecode",
19           "evm.deployedBytecode",
20           "devdoc",
21           "userdoc",
22           "metadata",
23           "abi"
24         ]
25       }
26     }
27   },
28   "sources": {
29     "contracts/multivault/interfaces/IEverscale.sol": {
30       "content": "// SPDX-License-Identifier: AGPL-3.0\npragma solidity 0.8.0;\n\n\ninterface IEverscale {\n    struct EverscaleAddress {\n        int8 wid;\n        uint256 addr;\n    }\n\n    struct EverscaleEvent {\n        uint64 eventTransactionLt;\n        uint32 eventTimestamp;\n        bytes eventData;\n        int8 configurationWid;\n        uint256 configurationAddress;\n        int8 eventContractWid;\n        uint256 eventContractAddress;\n        address proxy;\n        uint32 round;\n    }\n}\n"
31     },
32     "contracts/multivault/interfaces/multivault/IMultiVaultFacetTokens.sol": {
33       "content": "// SPDX-License-Identifier: AGPL-3.0\npragma solidity 0.8.0;\n\n\nimport \"./../IEverscale.sol\";\n\n\ninterface IMultiVaultFacetTokens {\n    enum TokenType { Native, Alien }\n\n    struct TokenPrefix {\n        uint activation;\n        string name;\n        string symbol;\n    }\n\n    struct TokenMeta {\n        string name;\n        string symbol;\n        uint8 decimals;\n    }\n\n    struct Token {\n        uint activation;\n        bool blacklisted;\n        uint depositFee;\n        uint withdrawFee;\n        bool isNative;\n        address custom;\n    }\n\n    function prefixes(address _token) external view returns (TokenPrefix memory);\n    function tokens(address _token) external view returns (Token memory);\n    function natives(address _token) external view returns (IEverscale.EverscaleAddress memory);\n\n    function setPrefix(\n        address token,\n        string memory name_prefix,\n        string memory symbol_prefix\n    ) external;\n\n    function setTokenBlacklist(\n        address token,\n        bool blacklisted\n    ) external;\n\n    function getNativeToken(\n        IEverscale.EverscaleAddress memory native\n    ) external view returns (address);\n}\n"
34     },
35     "contracts/multivault/interfaces/multivault/IMultiVaultFacetWithdraw.sol": {
36       "content": "// SPDX-License-Identifier: AGPL-3.0\npragma solidity 0.8.0;\n\n\nimport \"./IMultiVaultFacetTokens.sol\";\nimport \"../IEverscale.sol\";\n\n\ninterface IMultiVaultFacetWithdraw {\n    struct Callback {\n        address recipient;\n        bytes payload;\n        bool strict;\n    }\n\n    struct NativeWithdrawalParams {\n        IEverscale.EverscaleAddress native;\n        IMultiVaultFacetTokens.TokenMeta meta;\n        uint256 amount;\n        address recipient;\n        uint256 chainId;\n        Callback callback;\n    }\n\n    struct AlienWithdrawalParams {\n        address token;\n        uint256 amount;\n        address recipient;\n        uint256 chainId;\n        Callback callback;\n    }\n\n    function withdrawalIds(bytes32) external view returns (bool);\n\n    function saveWithdrawNative(\n        bytes memory payload,\n        bytes[] memory signatures\n    ) external;\n\n    function saveWithdrawAlien(\n        bytes memory payload,\n        bytes[] memory signatures\n    ) external;\n\n    function saveWithdrawAlien(\n        bytes memory payload,\n        bytes[] memory signatures,\n        uint bounty\n    ) external;\n}\n"
37     },
38     "contracts/utils/BatchSaver.sol": {
39       "content": "// SPDX-License-Identifier: AGPL-3.0\npragma solidity 0.8.0;\n\n\nimport \"../multivault/interfaces/multivault/IMultiVaultFacetWithdraw.sol\";\n\n\ncontract BatchSaver {\n    address immutable public multivault;\n\n    constructor(\n        address _multivault\n    ) {\n        multivault = _multivault;\n    }\n\n    event WithdrawalAlreadyUsed(bytes32 indexed withdrawalId);\n    event WithdrawalSaved(bytes32 indexed withdrawalId);\n\n    struct Withdraw {\n        bool isNative;\n        bytes payload;\n        bytes[] signatures;\n    }\n\n    function checkWithdrawalAlreadySeen(bytes32 withdrawalId) public view returns (bool) {\n        return IMultiVaultFacetWithdraw(multivault).withdrawalIds(withdrawalId);\n    }\n\n    function saveWithdrawals(\n        Withdraw[] memory withdrawals\n    ) external {\n        for (uint i = 0; i < withdrawals.length; i++) {\n            Withdraw memory withdraw = withdrawals[i];\n\n            bytes32 withdrawalId = keccak256(withdraw.payload);\n\n            if (checkWithdrawalAlreadySeen(withdrawalId)) {\n                emit WithdrawalAlreadyUsed(withdrawalId);\n\n                continue;\n            }\n\n            if (withdraw.isNative) {\n                IMultiVaultFacetWithdraw(multivault).saveWithdrawNative(\n                    withdraw.payload,\n                    withdraw.signatures\n                );\n            } else {\n                IMultiVaultFacetWithdraw(multivault).saveWithdrawAlien(\n                    withdraw.payload,\n                    withdraw.signatures\n                );\n            }\n\n            emit WithdrawalSaved(withdrawalId);\n        }\n    }\n}\n"
40     }
41   }
42 }}