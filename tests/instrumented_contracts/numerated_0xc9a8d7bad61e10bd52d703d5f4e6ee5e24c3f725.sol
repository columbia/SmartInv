1 {{
2   "language": "Solidity",
3   "sources": {
4     "FairXYZCloner.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.7;\n\ninterface IFairXYZDeployer {\n    function initialize(uint256 maxTokens_, uint256 nftPrice_, string memory name_, string memory symbol_,\n                        bool burnable_, uint256 maxMintsPerWallet_, address interfaceAddress_,\n                        string[] memory URIs_, uint96 royaltyPercentage_) external;\n}\n\ninterface IFairXYZWallets {\n    function viewSigner() view external returns(address);\n    function viewWithdraw() view external returns(address);\n}\n\ncontract FairXYZCloner {\n\n    address public implementation;\n\n    address public interfaceAddress;\n\n    mapping(address => address[]) public allClones;\n\n    event NewClone(address _newClone, address _owner);\n\n    constructor(address _implementation, address _interface) {\n        require(_implementation != address(0), \"Cannot set to 0 address!\");\n        require(_interface != address(0), \"Cannot set to 0 address!\");\n        implementation = _implementation;\n        interfaceAddress = _interface;\n    }\n\n    /**\n     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.\n     *\n     * This function uses the create opcode, which should never revert.\n     */\n    function clone(address _implementation) internal returns (address instance) {\n        assembly {\n            let ptr := mload(0x40)\n            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n            mstore(add(ptr, 0x14), shl(0x60, _implementation))\n            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n            instance := create(0, ptr, 0x37)\n        }\n        require(instance != address(0), \"ERC1167: create failed\");\n    }\n\n    function _clone(uint256 maxTokens, uint256 nftPrice, string memory name, string memory symbol, bool burnable, \n                    uint256 maxMintsPerWallet, string[] memory URIs_, uint96 royaltyPercentage) external {\n\n        address identicalChild = clone(implementation);\n        allClones[msg.sender].push(identicalChild);\n        IFairXYZDeployer(identicalChild).initialize(maxTokens, nftPrice, name, symbol, burnable, maxMintsPerWallet, \n                                                    interfaceAddress, URIs_, royaltyPercentage);\n        emit NewClone(identicalChild, msg.sender);\n    }\n\n    function returnClones(address _owner) external view returns (address[] memory){\n        return allClones[_owner];\n    }\n\n}"
6     }
7   },
8   "settings": {
9     "evmVersion": "istanbul",
10     "optimizer": {
11       "enabled": true,
12       "runs": 200
13     },
14     "libraries": {
15       "FairXYZCloner.sol": {}
16     },
17     "outputSelection": {
18       "*": {
19         "*": [
20           "evm.bytecode",
21           "evm.deployedBytecode",
22           "devdoc",
23           "userdoc",
24           "metadata",
25           "abi"
26         ]
27       }
28     }
29   }
30 }}