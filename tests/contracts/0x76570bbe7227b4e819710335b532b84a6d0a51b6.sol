{{
  "language": "Solidity",
  "sources": {
    "StoicFrens.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\n// This smart contract was created to accomodate Buy-One-Get-One (BOGO) airdrops\n// of FRENS with GABE WEIS for Stoics Holders.\n\npragma solidity ^0.8.17;\n\nimport \"IERC721Receiver.sol\";\n\n\ninterface IFrensToken {\n  function transferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external payable;\n  function setApprovalForAll(address operator, bool _approved) external;\n  function totalSupply() external view returns (uint256);\n  function mintSeaDrop(address minter, uint256 quantity) external;\n}\n\ncontract StoicFRENSClaimBOGO {\n\n    IFrensToken public Frens;\n    address constant DEPLOYER = 0x029E4C95c75Eb16Ef63ca4aACE870D0BF444d909;\n    \n    /**\n     * @notice Deploy the token contract with its name, symbol,\n     *         administrator, and allowed SeaDrop addresses.\n     */\n    constructor(address frens) {\n        Frens = IFrensToken(frens);\n    }\n\n    function setApproval() public {\n        // Just in case, set approval for deployer wallet to transfer Frens from this contract\n        Frens.setApprovalForAll(DEPLOYER, true);\n    }\n\n    function mintBogos(uint qty) public {\n      if(msg.sender != DEPLOYER){\n        revert NotStoicsDeployer();\n      }\n      Frens.mintSeaDrop(address(this), qty);\n    }\n\n    function sendBogos(address recipient, uint[] calldata tokenIds) public {\n      if(msg.sender != DEPLOYER){\n        revert NotStoicsDeployer();\n      }\n      uint numTokens = tokenIds.length;\n\n      for (uint i = 0; i < numTokens;) {\n        // mint the Frens\n        Frens.transferFrom(address(this), recipient, tokenIds[i]);\n        unchecked { i++; }\n      }\n    }\n\n    function onERC721Received(\n        address operator,\n        address from,\n        uint256 tokenId,\n        bytes calldata data\n    ) external returns (bytes4) {\n      return IERC721Receiver.onERC721Received.selector;\n    }\n\n    error NotStoicsDeployer();\n\n}"
    },
    "IERC721Receiver.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @title ERC721 token receiver interface\n * @dev Interface for any contract that wants to support safeTransfers\n * from ERC721 asset contracts.\n */\ninterface IERC721Receiver {\n    /**\n     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}\n     * by `operator` from `from`, this function is called.\n     *\n     * It must return its Solidity selector to confirm the token transfer.\n     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.\n     *\n     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.\n     */\n    function onERC721Received(\n        address operator,\n        address from,\n        uint256 tokenId,\n        bytes calldata data\n    ) external returns (bytes4);\n}\n"
    }
  },
  "settings": {
    "evmVersion": "istanbul",
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "libraries": {
      "StoicFrens.sol": {}
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