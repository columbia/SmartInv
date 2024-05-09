1 {{
2   "language": "Solidity",
3   "sources": {
4     "src/BoredAndDangerousBatchHelper.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.15;\n\ncontract BoredAndDangerousBatchHelper {\n    /// @notice The book contract to batch mint on\n    address public immutable JENKINS_BOOK;\n\n    /// @notice Raised when a function within the batch call fails\n    error BatchError(bytes innerError);\n    /// @notice Raised when `sender` does not pass the proper ether amount to `recipient`\n    error FailedToSendEther(address sender, address recipient);\n    /// @notice Raised when two calldata arrays do not have the same length\n    error MismatchedArrays();\n\n    constructor (address _JENKINS_BOOK) {\n        JENKINS_BOOK = _JENKINS_BOOK;\n    }\n\n    /// @notice Allows batched external calls.\n    /// @param calls An array of inputs for each call.\n    /// @param msgValues The eth to send along for each call.\n    /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.\n    function batch(bytes[] calldata calls, uint[] calldata msgValues, bool revertOnFail) external payable {\n        // Check array length\n        if (calls.length != msgValues.length) {\n            revert MismatchedArrays();\n        }\n\n        // Check that proper ETH value is sent\n        uint msgValueTotal = 0;\n        for (uint256 i = 0; i < calls.length; ++i) {\n            msgValueTotal += msgValues[i];\n        }\n        if (msgValueTotal != msg.value) {\n            revert FailedToSendEther(msg.sender, address(this));\n        }\n\n        // Perform external calls\n        for (uint256 i = 0; i < calls.length; i++) {\n            (bool success, bytes memory result) = JENKINS_BOOK.call{value: msgValues[i]}(calls[i]);\n            if (!success && revertOnFail) {\n                _getRevertMsg(result);\n            }\n        }\n    }\n\n    /// @dev Helper function to extract a useful revert message from a failed call.\n    /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.\n    function _getRevertMsg(bytes memory _returnData) internal pure {\n        // If the _res length is less than 68, then\n        // the transaction failed with custom error or silently (without a revert message)\n        if (_returnData.length < 68) revert BatchError(_returnData);\n\n        assembly {\n            // Slice the sighash.\n            _returnData := add(_returnData, 0x04)\n        }\n        revert(abi.decode(_returnData, (string))); // All that remains is the revert string\n    }\n    \n}"
6     }
7   },
8   "settings": {
9     "remappings": [
10       "@rari-capital/solmate/=lib/solmate/",
11       "contracts/=contracts/",
12       "ds-test/=lib/ds-test/src/",
13       "forge-std/=lib/forge-std/src/",
14       "murky/=lib/murky/src/",
15       "openzeppelin-contracts/=lib/openzeppelin-contracts/",
16       "solmate/=lib/solmate/src/",
17       "src/=src/",
18       "script/=script/"
19     ],
20     "optimizer": {
21       "enabled": true,
22       "runs": 200
23     },
24     "metadata": {
25       "bytecodeHash": "ipfs"
26     },
27     "outputSelection": {
28       "*": {
29         "*": [
30           "evm.bytecode",
31           "evm.deployedBytecode",
32           "devdoc",
33           "userdoc",
34           "metadata",
35           "abi"
36         ]
37       }
38     },
39     "evmVersion": "london",
40     "libraries": {}
41   }
42 }}