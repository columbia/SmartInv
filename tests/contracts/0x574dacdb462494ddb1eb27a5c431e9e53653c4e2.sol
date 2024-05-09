{{
  "language": "Solidity",
  "sources": {
    "contracts/bulk/ETHBulkRegistrarV1.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.8.4;\nimport \"./IETHBulkRegistrar.sol\";\nimport \"./IETHRegistrarController.sol\";\nimport \"../bnbregistrar/IPriceOracle.sol\";\n\ncontract ETHBulkRegistrarV1 is IETHBulkRegistrar {\n    IETHRegistrarController public immutable registrarController;\n\n    constructor(IETHRegistrarController _registrarController) {\n        registrarController = _registrarController;\n    }\n\n    function bulkRentPrice(string[] calldata names, uint256 duration) external view override returns (uint256 total) {\n        for (uint256 i = 0; i < names.length; i++) {\n            uint price = registrarController.rentPrice(names[i], duration);\n            total += price;\n        }\n        return total;\n    }\n\n    function bulkMakeCommitment(string[] calldata name, address owner, bytes32 secret) external view override returns (bytes32[] memory commitments) {\n        commitments = new bytes32[](name.length);\n        for (uint256 i = 0; i < name.length; i++) {\n            commitments[i] = registrarController.makeCommitmentWithConfig(name[i], owner, secret, address(0), address(0));\n        }\n        return commitments;\n    }\n\n    function commitment(bytes32 commit) external view override returns (uint256) {\n        return registrarController.commitments(commit);\n    }\n\n    function bulkCommit(bytes32[] calldata commitments) external override {\n        for (uint256 i = 0; i < commitments.length; i++) {\n            registrarController.commit(commitments[i]);\n        }\n    }\n\n    function bulkRegister(string[] calldata names, address owner, uint duration, bytes32 secret) external override payable {\n        uint256 cost = 0;\n        for (uint256 i = 0; i < names.length; i++) {\n            uint price = registrarController.rentPrice(names[i], duration);\n            registrarController.register{value: (price)}(names[i], owner, duration, secret);\n            cost = cost + price;\n        }\n\n        // Send any excess funds back\n        payable(msg.sender).transfer(msg.value - cost);\n    }\n}\n"
    },
    "contracts/bulk/IETHBulkRegistrar.sol": {
      "content": "pragma solidity >=0.8.4;\n\ninterface IETHBulkRegistrar {\n    function bulkRentPrice(string[] calldata names, uint256 duration) external view returns (uint256 total);\n    \n    function bulkRegister(string[] calldata names, address owner, uint duration, bytes32 secret) external payable;\n\n    function bulkCommit(bytes32[] calldata commitments) external;\n\n    function bulkMakeCommitment(string[] calldata name, address owner, bytes32 secret) external view returns (bytes32[] memory commitments);\n\n    function commitment(bytes32 commit) external view returns(uint256);\n\n}"
    },
    "contracts/bnbregistrar/IPriceOracle.sol": {
      "content": "pragma solidity >=0.8.4;\n\ninterface IPriceOracle {\n    struct Price {\n        uint256 base;\n        uint256 premium;\n    }\n\n    /**\n     * @dev Returns the price to register or renew a name.\n     * @param name The name being registered or renewed.\n     * @param expires When the name presently expires (0 if this is a new registration).\n     * @param duration How long the name is being registered or extended for, in seconds.\n     * @return base premium tuple of base price + premium price\n     */\n    function price(\n        string calldata name,\n        uint256 expires,\n        uint256 duration\n    ) external view returns (Price calldata);\n\n    function price(\n        uint name_len,\n        uint256 expires,\n        uint256 duration\n    ) external view returns (Price calldata);\n\n}\n"
    },
    "contracts/bulk/IETHRegistrarController.sol": {
      "content": "pragma solidity >=0.8.4;\n\nimport \"../bnbregistrar/IPriceOracle.sol\";\ninterface IETHRegistrarController {\n    \n    function rentPrice(string memory, uint)\n        external\n        view\n        returns (uint);\n\n    function available(string memory) external returns (bool);\n\n    function makeCommitmentWithConfig(\n        string memory,\n        address,\n        bytes32,\n        address,\n        address\n    ) external pure returns (bytes32);\n\n    function commit(bytes32) external;\n\n    function register(\n        string calldata,\n        address,\n        uint256,\n        bytes32\n    ) external payable;\n\n    function renew(string calldata, uint256) external payable;\n\n    function commitments(bytes32) external view returns (uint256);\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 10000
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