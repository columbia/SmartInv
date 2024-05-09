1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/Nanohub.sol": {
5       "content": "//SPDX-License-Identifier: MIT\npragma solidity ^0.8;\n\nimport \"./Ownable.sol\";\n\ninterface INFT {\n  function mintFRAME(address to, uint tokenId) external;\n  function exist(uint tokenId) external view returns (bool);\n  function ownerOf(uint tokenId) external view returns (address);\n  function transferFrom(address from, address to, uint id) external;\n  function balanceOf(address owner) external view returns (uint256);\n  function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);\n}\n\n/// @author jolan.eth\ncontract NANOHUB is Ownable {\n  INFT _0N1;\n  INFT _FRAME;\n  INFT _COMICS;\n\n  constructor(address ONI, address FRAME, address COMICS) {\n    _0N1 = INFT(ONI);\n    _FRAME = INFT(FRAME);\n    _COMICS = INFT(COMICS);\n  }\n\n  function mintFRAME(uint tokenId)\n  public {\n    require(!_FRAME.exist(tokenId), \"error FRAME.exist\");\n    require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n    _FRAME.mintFRAME(msg.sender, tokenId);\n  }\n\n  function batchMintFRAME()\n  public {\n    uint i = 0;\n    uint balance = _0N1.balanceOf(msg.sender);\n    while (i < balance) {\n      uint tokenId = _0N1.tokenOfOwnerByIndex(msg.sender, i);\n      if (!_FRAME.exist(tokenId)) {\n        require(!_FRAME.exist(tokenId), \"error FRAME.exist\");\n        require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n        _FRAME.mintFRAME(msg.sender, tokenId);\n      }\n      i++;\n    }\n  }\n\n  function recallFRAME(uint tokenId)\n  public {\n    require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n    require(msg.sender != _FRAME.ownerOf(tokenId), \"error FRAME.owner\");\n    require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n\n    address frameOwner = _FRAME.ownerOf(tokenId);\n    _FRAME.transferFrom(frameOwner, msg.sender, tokenId);\n  }\n\n  function batchRecallFRAME()\n  public {\n    uint i = 0;\n    uint balance = _0N1.balanceOf(msg.sender);\n    while (i < balance) {\n      uint tokenId = _0N1.tokenOfOwnerByIndex(msg.sender, i);\n      require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n      require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n      if (msg.sender != _FRAME.ownerOf(tokenId)) {\n        address frameOwner = _FRAME.ownerOf(tokenId);\n        _FRAME.transferFrom(frameOwner, msg.sender, tokenId);\n      }\n      i++;\n    }\n  }\n\n  function transferFRAME(address to, uint tokenId)\n  public {\n    require(msg.sender == _FRAME.ownerOf(tokenId), \"error FRAME.owner\");\n    require(_FRAME.exist(tokenId), \"error FRAME.exist\");\n\n    _FRAME.transferFrom(msg.sender, to, tokenId);\n  }\n\n  function recallCOMICS(uint tokenId)\n  public {\n    require(_COMICS.exist(tokenId), \"error COMICS.exist\");\n    require(msg.sender != _COMICS.ownerOf(tokenId), \"error COMICS.owner\");\n    require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n\n    address comicsOwner = _COMICS.ownerOf(tokenId);\n    _COMICS.transferFrom(comicsOwner, msg.sender, tokenId);\n  }\n\n  function batchRecallCOMICS()\n  public {\n    uint i = 0;\n    uint balance = _0N1.balanceOf(msg.sender);\n    while (i < balance) {\n      uint tokenId = _0N1.tokenOfOwnerByIndex(msg.sender, i);\n      require(msg.sender == _0N1.ownerOf(tokenId), \"error 0N1.owner\");\n      require(_COMICS.exist(tokenId), \"error COMICS.exist\");\n      if (msg.sender != _COMICS.ownerOf(tokenId)) {\n        address comicsOwner = _COMICS.ownerOf(tokenId);\n        _COMICS.transferFrom(comicsOwner, msg.sender, tokenId);\n      }\n      i++;\n    }\n  }\n\n  function transferCOMICS(address to, uint tokenId)\n  public {\n    require(msg.sender == _COMICS.ownerOf(tokenId), \"error COMICS.owner\");\n    require(_COMICS.exist(tokenId), \"error COMICS.exist\");\n\n    _COMICS.transferFrom(msg.sender, to, tokenId);\n  }\n}\n"
6     },
7     "contracts/Ownable.sol": {
8       "content": "//SPDX-License-Identifier: MIT\r\npragma solidity ^0.8;\r\n\r\nabstract contract Ownable {\r\n    address private _owner;\r\n    \r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n    \r\n    modifier onlyOwner() {\r\n        require(owner() == msg.sender, \"error owner()\");\r\n        _;\r\n    }\r\n\r\n    constructor() { _transferOwnership(msg.sender); }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"error newOwner\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}"
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