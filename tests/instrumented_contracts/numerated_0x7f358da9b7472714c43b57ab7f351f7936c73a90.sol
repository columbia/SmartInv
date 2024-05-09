1 {{
2   "language": "Solidity",
3   "sources": {
4     "@openzeppelin/contracts/access/Ownable.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
6     },
7     "@openzeppelin/contracts/utils/Context.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
9     },
10     "contracts/locking/StakeValentine.sol": {
11       "content": "// SPDX-License-Identifier: UNLICENSED\n\n// Crafted with ❤️ by [ @esawwh (1619058420), @dankazenoff, @rnaidenov (889528910) ] @ HOMA;\n\npragma solidity ^0.8.17;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface Valentine {\n  function ownerOf(uint256 tokenId) external view returns (address);\n  function transferFrom(address sender, address recipient, uint256 tokenId) external;    \n  function balanceOf(address owner) external view returns (uint256);\n}\n\ncontract StakeValentine is Ownable {\n  Valentine private ValentineERC721;\n\n  bool private canHoldersStake = false;\n  uint256 private minimumStakeDurationInSeconds = 1800;\n\n  struct StakeMetadata {\n    uint256 tokenId;\n    uint256 startTimestamp;\n    uint256 minimumStakeDurationEndTimestamp;\n    address stakedBy;\n    bool active;\n  }\n  \n  mapping(uint256 => StakeMetadata) public stakedTokens;\n  mapping(address => bool) private canStakeAtAnyTime;\n\n  event Staked(address indexed from, StakeMetadata stakedInfo);\n  event Claimed(address indexed from, StakeMetadata stakedInfo);\n\n  constructor(address _valentineAddress) {\n    require(_valentineAddress != address(0), \"Valentine to stake needs to have non-zero address.\");                \n    ValentineERC721 = Valentine(_valentineAddress);\n  }\n\n  function stakeToken(uint256[] calldata _tokenIds) external {\n    require(canHoldersStake || canStakeAtAnyTime[msg.sender]);\n\n    for (uint256 i = 0; i < _tokenIds.length; i++) {\n      require(ValentineERC721.ownerOf(_tokenIds[i]) == msg.sender);\n\n      StakeMetadata memory stakeInfo = StakeMetadata({                \n        startTimestamp: block.timestamp,\n        minimumStakeDurationEndTimestamp: block.timestamp + minimumStakeDurationInSeconds,\n        stakedBy: msg.sender,\n        tokenId: _tokenIds[i],\n        active: true\n      });\n\n      stakedTokens[_tokenIds[i]] = stakeInfo;\n\n      ValentineERC721.transferFrom(msg.sender, address(this), _tokenIds[i]);\n\n      emit Staked(msg.sender, stakeInfo);\n    }\n  }    \n\n  function withdrawToken(uint256[] calldata _tokenIds) external {\n    for (uint256 i = 0; i < _tokenIds.length; i++) {\n      StakeMetadata memory stakeInfo = stakedTokens[_tokenIds[i]];\n\n      require(stakeInfo.active == true, \"This token is not staked\");\n      require((stakeInfo.stakedBy == msg.sender && stakeInfo.minimumStakeDurationEndTimestamp < block.timestamp) \n      || msg.sender == owner());\n\n      StakeMetadata memory defaultStakeInfo;\n      stakedTokens[_tokenIds[i]] = defaultStakeInfo;\n\n      ValentineERC721.transferFrom(address(this), stakeInfo.stakedBy, _tokenIds[i]);\n\n      emit Claimed(stakeInfo.stakedBy, stakeInfo);\n    }\n  }\n\n  function setCanStakeAtAnyTime(address[] calldata _addresses, bool[] calldata _can) external onlyOwner {\n    for (uint256 i = 0; i < _addresses.length; i++) {\n      canStakeAtAnyTime[_addresses[i]] = _can[i];\n    }\n  }\n\n  function getCanStakeAtAnyTime(address[] calldata _addresses) external view returns (bool[] memory) {\n    bool[] memory returnedArray = new bool[](_addresses.length);\n\n    for (uint256 i = 0; i < _addresses.length; i++) {\n      returnedArray[i] = canStakeAtAnyTime[_addresses[i]];\n    }\n\n    return returnedArray;\n  }\n\n  function setCanHoldersStake(bool _can) external onlyOwner {\n    canHoldersStake = _can;\n  }\n\n  function getCanHoldersStake() external view returns (bool) {\n    return canHoldersStake;\n  }\n\n  function setMinimumStakeDuration(uint256 _durationInSeconds) external onlyOwner {\n    minimumStakeDurationInSeconds = _durationInSeconds;\n  }\n\n  function getMinimumStakeDuration() external view returns (uint256) {\n    return minimumStakeDurationInSeconds;\n  }\n\n  function getStakedTokens(uint256[] calldata _tokenIds) external view returns (StakeMetadata[] memory) {\n    StakeMetadata[] memory returnedArray = new StakeMetadata[](_tokenIds.length);\n\n    for (uint256 i = 0; i < _tokenIds.length; i++) {\n      returnedArray[i] = stakedTokens[_tokenIds[i]];\n    }\n\n    return returnedArray;\n  }\n}"
12     }
13   },
14   "settings": {
15     "viaIR": true,
16     "optimizer": {
17       "enabled": true,
18       "runs": 9999999,
19       "details": {
20         "peephole": true,
21         "inliner": true,
22         "jumpdestRemover": true,
23         "orderLiterals": true,
24         "deduplicate": false,
25         "cse": true,
26         "constantOptimizer": true,
27         "yul": true,
28         "yulDetails": {
29           "stackAllocation": true
30         }
31       }
32     },
33     "outputSelection": {
34       "*": {
35         "*": [
36           "evm.bytecode",
37           "evm.deployedBytecode",
38           "devdoc",
39           "userdoc",
40           "metadata",
41           "abi"
42         ]
43       }
44     },
45     "libraries": {}
46   }
47 }}