1 {{
2   "language": "Solidity",
3   "sources": {
4     "development/_10KStake.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.7;\n\nimport \"./IERC721A.sol\";\n\ncontract _10KStake {\n    address public owner;\n    address public stakeAddress;\n    mapping(uint256 => address) public stakeOwnerOf;\n    mapping(uint256 => uint256) public stakeTime;\n\n    enum StakeLockedDays {\n        NowDays,\n        ThirtyDays,\n        SixtyDays,\n        NinetyDays\n    }\n\n    event StakeEvent(\n        address indexed from,\n        uint256 indexed tokenId,\n        StakeLockedDays indexed stakeLockedDays,\n        uint256 timestamp\n    );\n\n    event UnStakeEvent(\n        address indexed to,\n        uint256 indexed tokenId,\n        uint256 indexed timestamp\n    );\n\n    constructor(address _stakeAddress) {\n        stakeAddress = _stakeAddress;\n        owner = msg.sender;\n    }\n\n    modifier onlyOwner() {\n        require(owner == msg.sender, \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function stake(uint256 _tokenId, StakeLockedDays stakeLockedDays) public {\n        require(\n            IERC721A(stakeAddress).ownerOf(_tokenId) == msg.sender &&\n                stakeOwnerOf[_tokenId] == address(0),\n            \"You must own the NFT.\"\n        );\n        IERC721A(stakeAddress).transferFrom(\n            msg.sender,\n            address(this),\n            _tokenId\n        );\n        stakeOwnerOf[_tokenId] = msg.sender;\n        uint256 currentTimestamp = block.timestamp;\n\n        if (stakeLockedDays == StakeLockedDays.ThirtyDays) {\n            stakeTime[_tokenId] = currentTimestamp + 30 days;\n        } else if (stakeLockedDays == StakeLockedDays.SixtyDays) {\n            stakeTime[_tokenId] = currentTimestamp + 60 days;\n        } else if (stakeLockedDays == StakeLockedDays.NinetyDays) {\n            stakeTime[_tokenId] = currentTimestamp + 90 days;\n        } else {\n            stakeTime[_tokenId] = currentTimestamp;\n        }\n        emit StakeEvent(\n            msg.sender,\n            _tokenId,\n            stakeLockedDays,\n            currentTimestamp\n        );\n    }\n\n    function unStake(uint256 _tokenId) public {\n        require(stakeOwnerOf[_tokenId] == msg.sender, \"Not original owner\");\n        require(block.timestamp > stakeTime[_tokenId], \"Not time to unstake\");\n        IERC721A(stakeAddress).transferFrom(\n            address(this),\n            msg.sender,\n            _tokenId\n        );\n        stakeOwnerOf[_tokenId] = address(0);\n        stakeTime[_tokenId] = uint256(0);\n        emit UnStakeEvent(msg.sender, _tokenId, block.timestamp);\n    }\n\n    function batchStake(\n        uint256[] memory _tokenIds,\n        StakeLockedDays stakeLockedDays\n    ) external {\n        for (uint256 i = 0; i < _tokenIds.length; i++) {\n            stake(_tokenIds[i], stakeLockedDays);\n        }\n    }\n\n    function batchUnStake(uint256[] memory _tokenIds) external {\n        for (uint256 i = 0; i < _tokenIds.length; i++) {\n            unStake(_tokenIds[i]);\n        }\n    }\n\n    function setStakeAddress(address _stakeAddress) external onlyOwner {\n        stakeAddress = _stakeAddress;\n    }\n}\n"
6     },
7     "development/IERC721A.sol": {
8       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\ninterface IERC721A {\n    function transferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external;\n\n    function ownerOf(uint256 tokenId) external view returns (address owner);\n}\n"
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
21           "abi"
22         ]
23       }
24     }
25   }
26 }}