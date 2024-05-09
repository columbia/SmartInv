{{
  "language": "Solidity",
  "sources": {
    "/contracts/WatcherAdmin.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity >=0.4.22 <0.9.0;\r\n\r\n// Who brought you here?\r\ncontract WatcherAdmin {\r\n\tmapping(address => bool) public isAdmin;\r\n\tbool private killswitchActive;\r\n\r\n\taddress public JDWUHRBCBW;\r\n\r\n\taddress public owner;\r\n\taddress public authorizer;\r\n\r\n\tAdminMinter public minter;\r\n\r\n\t// ZFF3NHc5V2dYY1E=\r\n\tconstructor(\r\n\t\taddress _owner,\r\n\t\taddress _authorizer,\r\n\t\taddress _minter\r\n\t) {\r\n\t\towner = _owner;\r\n\t\tauthorizer = _authorizer;\r\n\t\tminter = AdminMinter(_minter);\r\n\t}\r\n\r\n\t// 104 116 116 112 115 58 47 47 105 109 103 117 114 46 99 111 109 47 97 47 74 115 102 65 67 120 54\r\n\tmodifier isAuthorized() {\r\n\t\trequire(killswitchActive == false, \"Killswitch has been activated\");\r\n\t\trequire(\r\n\t\t\tisAdmin[msg.sender] == true ||\r\n\t\t\t\tmsg.sender == owner ||\r\n\t\t\t\tmsg.sender == authorizer,\r\n\t\t\t\"User is not an admin\"\r\n\t\t);\r\n\t\t_;\r\n\t}\r\n\r\n\tmodifier ownerOnly() {\r\n\t\trequire(killswitchActive == false, \"Killswitch has been activated\");\r\n\t\trequire(msg.sender == owner, \"User is not the owner\");\r\n\t\t_;\r\n\t}\r\n\r\n\t// 01101000 01110100 01110100 01110000\r\n\t// 01110011 00111010 00101111 00101111\r\n\t// 01101001 00101110 01101001 01101101\r\n\t// 01100111 01110101 01110010 00101110\r\n\t// 01100011 01101111 01101101 00101111\r\n\t// 01000011 01001011 01010101 01110001\r\n\t// 01000001 01101010 01010100 00101110\r\n\t// 01110000 01101110 01100111\r\n\tmodifier authorizerOnly() {\r\n\t\trequire(killswitchActive == false, \"Killswitch has been activated\");\r\n\t\trequire(\r\n\t\t\tmsg.sender == authorizer || msg.sender == owner,\r\n\t\t\t\"User is not an authorizer\"\r\n\t\t);\r\n\t\t_;\r\n\t}\r\n\r\n\t//  -----------------\r\n\t// | ADMIN FUNCTIONS |\r\n\t//  -----------------\r\n\r\n\tfunction transferOwnership(address _newOwner) external ownerOnly {\r\n\t\towner = _newOwner;\r\n\t}\r\n\r\n\tfunction transferAuthorizer(address _newAuthorizer)\r\n\t\texternal\r\n\t\tauthorizerOnly\r\n\t{\r\n\t\tauthorizer = _newAuthorizer;\r\n\t}\r\n\r\n\tfunction activateKillswitch() external authorizerOnly {\r\n\t\tkillswitchActive = true;\r\n\t}\r\n\r\n\t// 104 116 116 112 115 58 47 47 105 46 105 109 103 117 114 46 99 111 109 47 117 67 75 77 114 98 78 46 112 110 103\r\n\tfunction toggleAdmin(address _wallet) external authorizerOnly {\r\n\t\tisAdmin[_wallet] = !isAdmin[_wallet];\r\n\t}\r\n\r\n\tfunction vnvieksh(address _fjvnsle) external authorizerOnly {\r\n\t\tJDWUHRBCBW = _fjvnsle;\r\n\t}\r\n\r\n\t//  --------------------\r\n\t// | CONTRACT FUNCTIONS |\r\n\t//  --------------------\r\n\r\n\tfunction mint(\r\n\t\taddress _to,\r\n\t\tuint256 _id,\r\n\t\tuint256 _amount\r\n\t) external isAuthorized {\r\n\t\tminter.mint(_to, _id, _amount);\r\n\t}\r\n\r\n\tfunction mintBatch(\r\n\t\taddress _to,\r\n\t\tuint256[] memory _ids,\r\n\t\tuint256[] memory _amounts\r\n\t) external isAuthorized {\r\n\t\tminter.mintBatch(_to, _ids, _amounts);\r\n\t}\r\n\r\n\t// 0x68747470733a2f2f692e696d6775722e636f6d2f33356a37544a652e706e67\r\n\tfunction burnForMint(\r\n\t\taddress _from,\r\n\t\tuint256[] memory _burnIds,\r\n\t\tuint256[] memory _burnAmounts,\r\n\t\tuint256[] memory _mintIds,\r\n\t\tuint256[] memory _mintAmounts\r\n\t) external isAuthorized {\r\n\t\tminter.burnForMint(\r\n\t\t\t_from,\r\n\t\t\t_burnIds,\r\n\t\t\t_burnAmounts,\r\n\t\t\t_mintIds,\r\n\t\t\t_mintAmounts\r\n\t\t);\r\n\t}\r\n\r\n\tfunction setURI(uint256 _id, string memory _uri) external isAuthorized {\r\n\t\tminter.setURI(_id, _uri);\r\n\t}\r\n\r\n\t// 01110111 01101000 01100001 01110100 00100000\r\n\t// 01100001 01110010 01100101 00100000 01111001\r\n\t// 01101111 01110101 00100000 01100100 01101111\r\n\t// 01101001 01101110 01100111 00100000 01101000\r\n\t// 01100101 01110010 01100101 00111111\r\n}\r\n\r\nabstract contract AdminMinter {\r\n\tfunction mint(\r\n\t\taddress _to,\r\n\t\tuint256 _id,\r\n\t\tuint256 _amount\r\n\t) external virtual;\r\n\r\n\tfunction mintBatch(\r\n\t\taddress _to,\r\n\t\tuint256[] memory _ids,\r\n\t\tuint256[] memory _amounts\r\n\t) external virtual;\r\n\r\n\tfunction burnForMint(\r\n\t\taddress _from,\r\n\t\tuint256[] memory _burnIds,\r\n\t\tuint256[] memory _burnAmounts,\r\n\t\tuint256[] memory _mintIds,\r\n\t\tuint256[] memory _mintAmounts\r\n\t) external virtual;\r\n\r\n\tfunction setURI(uint256 _id, string memory _uri) external virtual;\r\n}\r\n\r\n// 0x40707231736d5f646576\r\n"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": false,
      "runs": 200
    },
    "evmVersion": "london",
    "libraries": {},
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
    }
  }
}}