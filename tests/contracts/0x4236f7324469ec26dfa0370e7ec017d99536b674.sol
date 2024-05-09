{{
  "language": "Solidity",
  "sources": {
    "contracts/Nanohub.sol": {
      "content": "//SPDX-License-Identifier: MIT\n\npragma solidity ^0.8;\n\nimport \"./Ownable.sol\";\n\ninterface i0N1 {\n    function ownerOf(uint256 tokenId) external view returns (address);\n    function balanceOf(address owner) external view returns (uint256);\n    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);\n}\n\ninterface iFRAME {\n    function mintFRAME(address to, uint tokenId) external;\n    function exist(uint tokenId) external view returns (bool);\n    function ownerOf(uint tokenId) external view returns (address);\n    function transferFrom(address from, address to, uint id) external;\n}\n\n/// @author jolan.eth\ncontract NANOHUB is Ownable {\n    i0N1 _0N1;\n    iFRAME _FRAME;\n\n    bool public MINT = false;\n\n    constructor(address ONI, address FRAME) {\n        _0N1 = i0N1(ONI);\n        _FRAME = iFRAME(FRAME);\n    }\n\n    function setMint()\n    public onlyOwner {\n        MINT = !MINT;\n    }\n\n    function mintFRAME(uint tokenId)\n    public {\n        require(MINT, \"error MINT\");\n        require(!_FRAME.exist(tokenId), \"error FRAME.exist\");\n        require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n        _FRAME.mintFRAME(msg.sender, tokenId);\n    }\n\n    function batchMintFRAME()\n    public {\n        require(MINT, \"error MINT\");\n        uint i = 0;\n        uint balance = _0N1.balanceOf(msg.sender);\n        while (i < balance) {\n            uint tokenId = _0N1.tokenOfOwnerByIndex(msg.sender, i);\n            if (!_FRAME.exist(tokenId)) {\n                require(!_FRAME.exist(tokenId), \"error FRAME.exist\");\n                require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n                _FRAME.mintFRAME(msg.sender, tokenId);\n            }\n            i++;\n        }\n    }\n\n    function recallFRAME(uint tokenId)\n    public {\n        require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n        require(msg.sender != _FRAME.ownerOf(tokenId), \"error FRAME.owner\");\n        require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n\n        address frameOwner = _FRAME.ownerOf(tokenId);\n        _FRAME.transferFrom(frameOwner, msg.sender, tokenId);\n    }\n\n    function batchRecallFRAME()\n    public {\n        uint i = 0;\n        uint balance = _0N1.balanceOf(msg.sender);\n        while (i < balance) {\n            uint tokenId = _0N1.tokenOfOwnerByIndex(msg.sender, i);\n            require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n            require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n            if (msg.sender != _FRAME.ownerOf(tokenId)) {\n                address frameOwner = _FRAME.ownerOf(tokenId);\n                _FRAME.transferFrom(frameOwner, msg.sender, tokenId);\n            }\n            i++;\n        }\n    }\n\n    function transferFRAME(address to, uint tokenId)\n    public {\n        require(msg.sender == _FRAME.ownerOf(tokenId), \"error FRAME.owner\");\n        require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n\n        _FRAME.transferFrom(msg.sender, to, tokenId);\n    }\n}\n"
    },
    "contracts/Ownable.sol": {
      "content": "//SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8;\r\n\r\nabstract contract Ownable {\r\n    address private _owner;\r\n    \r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n    \r\n    modifier onlyOwner() {\r\n        require(owner() == msg.sender, \"error owner()\");\r\n        _;\r\n    }\r\n\r\n    constructor() { _transferOwnership(msg.sender); }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"error newOwner\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
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
    "libraries": {}
  }
}}