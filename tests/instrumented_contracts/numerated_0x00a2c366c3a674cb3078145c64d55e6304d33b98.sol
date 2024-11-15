1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/OnchainGate.sol": {
5       "content": "// contracts/OnchainGate.sol\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nimport \"./IOffchainZombie.sol\";\r\nimport \"./IOnchainZombie.sol\";\r\n\r\ncontract OnchainGate {\r\n\r\n    // Bool\r\n    bool public _gateOpened;\r\n\r\n    // Mappings\r\n\r\n    mapping(uint => address) offchainIdToOwner;\r\n\r\n    // Addresses\r\n\r\n    address public offChainAddress;\r\n    address public onChainAddress;\r\n    address _owner;\r\n\r\n    // Constructor\r\n\r\n    constructor() {\r\n        _owner = msg.sender;\r\n    }\r\n\r\n    // Claim functions\r\n\r\n    /** \r\n     * @dev Claim onchain zombiemouse for the offchain\r\n     * @param _offchain_uid Offhchain mouse ID used to claim\r\n     */\r\n    function claimOnchainMouse(\r\n        uint _offchain_uid\r\n    ) \r\n        external \r\n        gateOpened \r\n    {\r\n        require(IOffchainZombie(offChainAddress).ownerOf(_offchain_uid)==msg.sender, \"You are not the mice owner\");\r\n        offchainIdToOwner[_offchain_uid]=msg.sender;\r\n        IOffchainZombie(offChainAddress).transferFrom(msg.sender, address(this), _offchain_uid);\r\n        IOnchainZombie(onChainAddress).claimMouse(msg.sender);\r\n    }\r\n\r\n    /** \r\n     * @dev Claim several onchain zombiemice for the offchain\r\n     * @param _offchain_uids_ Offhchain mice IDs used to claim\r\n     */\r\n    function claimOnchainMice(\r\n        uint[] memory _offchain_uids_\r\n    ) \r\n        external \r\n        gateOpened \r\n    {\r\n        for (uint8 i =0;i<_offchain_uids_.length;i++)\r\n        {\r\n            require(IOffchainZombie(offChainAddress).ownerOf(_offchain_uids_[i])==msg.sender, \"You are not the offchain mice owner\");\r\n\r\n            offchainIdToOwner[_offchain_uids_[i]]=msg.sender;\r\n            IOffchainZombie(offChainAddress).transferFrom(msg.sender, address(this), _offchain_uids_[i]);\r\n        }\r\n        IOnchainZombie(onChainAddress).claimMice(msg.sender, _offchain_uids_.length);\r\n    }\r\n\r\n    // Public functions\r\n\r\n    /** \r\n     * @dev Get address of who claimed the mouse by ID\r\n     * @param _offchain_uid_ Offhchain mice IDs used to claim\r\n     */\r\n    function getClaimedOwner(\r\n        uint _offchain_uid_\r\n    ) \r\n        external \r\n        view \r\n        returns(address) \r\n    {\r\n        return offchainIdToOwner[_offchain_uid_];\r\n    }\r\n\r\n    // Owner only functions\r\n    // Contracts linking\r\n\r\n    /** \r\n     * @dev Set offchain zombiemice contract address and create an interface instance\r\n     * @param _offChainAddress contract address\r\n     */\r\n    function setOffchainAddress(\r\n        address _offChainAddress\r\n    ) \r\n        external \r\n        onlyOwner \r\n    {\r\n        offChainAddress = _offChainAddress;\r\n    }\r\n\r\n    /** \r\n     * @dev Set onchain zombiemice contract address and create an interface instance\r\n     * @param _onChainAddress contract address\r\n     */\r\n    function setOnchainAddress(\r\n        address _onChainAddress\r\n    ) \r\n        external \r\n        onlyOwner \r\n    {\r\n        onChainAddress = _onChainAddress;\r\n    }\r\n\r\n    /** \r\n     * @dev Opens and closes the Gate for claim\r\n     * @param state new Gate state\r\n     */\r\n    function setGateState(\r\n        bool state\r\n    ) \r\n        public \r\n        onlyOwner \r\n    {\r\n        _gateOpened=state;\r\n    }\r\n    \r\n    modifier gateOpened() {\r\n        require(_gateOpened);\r\n        _;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == msg.sender);\r\n        _;\r\n    }\r\n}"
6     },
7     "contracts/IOffchainZombie.sol": {
8       "content": "// contracts/OnchainGate.sol\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IOffchainZombie {\r\n    function ownerOf(uint256 tokenId) external view returns (address owner);\r\n    function transferFrom(address from, address to, uint256 tokenId) external;\r\n}"
9     },
10     "contracts/IOnchainZombie.sol": {
11       "content": "// contracts/IOnchainZombie.sol\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IOnchainZombie {\r\n    function claimMouse(address _claimer) external;\r\n    function claimMice(address _claimer, uint _num) external;\r\n}"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": false,
17       "runs": 200
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "abi"
25         ]
26       }
27     },
28     "libraries": {}
29   }
30 }}