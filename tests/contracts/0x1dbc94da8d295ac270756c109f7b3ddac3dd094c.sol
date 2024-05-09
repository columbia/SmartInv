{{
  "language": "Solidity",
  "sources": {
    "contracts/redemption.sol": {
      "content": "// SPDX-License-Identifier: MIT\n//          .@@@                                                                  \n//               ,@@@@@@@&,                  #@@%                                  \n//                    @@@@@@@@@@@@@@.          @@@@@@@@@                           \n//                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      \n//                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   \n//                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                 \n//                                    @@@@@@@    &@@@@@@@@@@@@@@@@@                \n//                                        @@@/        &@@@@@@@@@@@@@,              \n//                                            @            @@@@@@@@@@@             \n//                                                             /@@@@@@@#           \n//                                                                  @@@@@          \n//                                                                      *@&   \n//         RTFKT Studios (https://twitter.com/RTFKT)\n//         Redemption Contract (made by @CardilloSamuel)\n\npragma solidity ^0.8.7;\n\nabstract contract redeemableCollection {\n    function redeem(address owner, address initialCollection, uint256 tokenId) public virtual returns(uint256);\n    function hasBeenRedeem(address initialCollection, uint256 tokenId) public view virtual returns(address);\n}\n\ncontract RTFKTRedemption {\n    mapping (address => bool) authorizedOwners;\n    mapping (address => bool) authorizedContract;\n    mapping (address => uint256) public redeemPrice;\n\n    constructor() {\n        authorizedOwners[msg.sender] = true;\n    }\n\n    /** \n        MODIFIER \n    **/\n\n    modifier isAuthorizedOwner() {\n        require(authorizedOwners[msg.sender], \"You are not authorized to perform this action\");\n        _;\n    }\n\n    /**\n        MAIN FUNCTION\n    **/\n\n    function redeemToken(address newCollection, address initialCollection, uint256 tokenId) public payable { \n        require(authorizedContract[newCollection], \"This contract is not authorized\");\n        require(msg.value == redeemPrice[newCollection], \"Not enough money sent\");\n        redeemableCollection externalContract = redeemableCollection(newCollection);\n        require(externalContract.hasBeenRedeem(initialCollection, tokenId) == 0x0000000000000000000000000000000000000000, \"This token has been redeemed already\");\n\n        externalContract.redeem(msg.sender, initialCollection, tokenId);\n    }\n\n    function hasBeenRedeemed(address newCollection, address initialCollection, uint256 tokenId) public view returns(address) {\n        redeemableCollection externalContract = redeemableCollection(newCollection);\n        return externalContract.hasBeenRedeem(initialCollection, tokenId);\n    }\n\n    /** \n        CONTRACT MANAGEMENT FUNCTIONS \n    **/ \n\n    function changeRedeemPrice(address collectionAddress, uint256 newPrice) public isAuthorizedOwner {\n        redeemPrice[collectionAddress] = newPrice;\n    }\n\n    function toggleAuthorizedContract(address redeemableContract) public isAuthorizedOwner {\n        authorizedContract[redeemableContract] = !authorizedContract[redeemableContract];\n    }\n\n    function toggleAuthorizedOwner(address newAddress) public isAuthorizedOwner {\n        require(msg.sender != newAddress, \"You can't revoke your own access\");\n\n        authorizedOwners[msg.sender] = !authorizedOwners[msg.sender];\n    }\n\n    function withdrawFunds(address withdrawalAddress) public isAuthorizedOwner {\n        payable(withdrawalAddress).transfer(address(this).balance);\n    }\n\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
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
    }
  }
}}