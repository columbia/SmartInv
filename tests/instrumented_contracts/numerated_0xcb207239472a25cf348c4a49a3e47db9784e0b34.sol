1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/UnimoonMulticall.sol": {
5       "content": "//SPDX-License-Identifier: MIT\npragma solidity 0.8.13;\n\nimport \"./interfaces/IStaking.sol\";\n\ncontract UnimoonMulticall {\n    address public immutable TREASURY;\n    address public immutable STAKING;\n\n    constructor(address _treasury, address _staking) {\n        require(\n            _treasury != address(0) && _staking != address(0),\n            \"UnimoonMulticall: wrong input\"\n        );\n        TREASURY = _treasury;\n        STAKING = _staking;\n    }\n\n    /** @dev Function to get rewards array from current pool\n     * @param user address\n     * @param pid pool id\n     * @return an array of rewards\n     */\n    function getRewards(address user, uint8 pid)\n        external\n        view\n        returns (uint256[] memory)\n    {\n        uint256 stakeLen = (IStaking(STAKING).getUserStakes(user, pid)).length;\n        uint256[] memory array = new uint256[](stakeLen);\n        for (uint256 i; i < stakeLen; i++) {\n            array[i] = IStaking(STAKING).pendingRewardPerDeposit(user, pid, i);\n        }\n        return array;\n    }\n\n    /** @dev Function to create many sells and purchases in one txn\n     * @param data an array of calls' data\n     */\n    function multicall(bytes[] calldata data)\n        external\n        returns (uint256[] memory output)\n    {\n        require(data.length > 0, \"UnimoonMulticall: wrong length\");\n        uint256 counter;\n        output = new uint256[](data.length);\n        for (uint256 i; i < data.length; i++) {\n            (bool success, bytes memory outputData) = TREASURY.call(\n                abi.encodePacked(data[i], msg.sender)\n            );\n            if (success) {\n                output[i] = uint256(bytes32(outputData));\n                counter++;\n            }\n        }\n        require(counter > 0, \"UnimoonMulticall: all calls failed\");\n    }\n}\n"
6     },
7     "contracts/interfaces/IStaking.sol": {
8       "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.13;\n\ninterface IStaking {\n    struct Data {\n        uint256 value;\n        uint64 lockedFrom;\n        uint64 lockedUntil;\n        uint256 weight;\n        uint256 lastAccValue;\n        uint256 pendingYield;\n    }\n\n    function increaseRewardPool(uint256 amount) external;\n\n    function getAllocAndWeight() external view returns (uint256, uint256);\n\n    function pendingRewardPerDeposit(\n        address user,\n        uint8 pid,\n        uint256 stakeId\n    ) external view returns (uint256);\n\n    function getUserStakes(address user, uint256 pid)\n        external\n        view\n        returns (Data[] memory);\n}\n"
9     }
10   },
11   "settings": {
12     "optimizer": {
13       "enabled": true,
14       "runs": 200
15     },
16     "outputSelection": {
17       "*": {
18         "*": [
19           "evm.bytecode",
20           "evm.deployedBytecode",
21           "devdoc",
22           "userdoc",
23           "metadata",
24           "abi"
25         ]
26       }
27     },
28     "libraries": {}
29   }
30 }}