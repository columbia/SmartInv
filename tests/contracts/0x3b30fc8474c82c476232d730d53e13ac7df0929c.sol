{{
  "language": "Solidity",
  "sources": {
    "/contracts/TraitsBurner.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n// solhint-disable-next-line\npragma solidity 0.8.12;\n\nimport \"./interface/IERC1155Factory.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\n/// @title Bulls and Apes Project - Traits Burner Helper\n/// @author BAP Dev Team\n/// @notice Handle the burning of Traits as deposit to be used off-chain\ncontract TraitsBurner is Ownable {\n    /// @notice Master contract instance\n    IERC1155Factory public traitsContract;\n\n    /// @notice Event for Utilities burned on chain as deposit\n    event TraitsBurnedOnChain(\n        address user,\n        uint256[] utilityIds,\n        uint256[] amounts,\n        uint256 timestamp\n    );\n\n    /// @notice Deploys the contract and sets the instances addresses\n    /// @param traitsContractAddress: Address of the Master Contract\n    constructor(\n        address traitsContractAddress\n    ) {\n       traitsContract = IERC1155Factory(traitsContractAddress);\n    }\n\n\n    /// @notice Handle the burning of Traits as deposit to be used off-chain\n    /// @param traitsIds: IDs of the Traits to burn\n    /// @param amounts: Amounts to burn for each Utility\n    /// @dev This contract must be approved by the user to spend the Traits\n    function burnTraits(\n        uint256[] memory traitsIds,\n        uint256[] memory amounts\n    ) external {\n        require(\n            traitsIds.length == amounts.length,\n            \"burnTraits: Arrays length mismatch\"\n        );\n\n        for (uint256 i = 0; i < traitsIds.length; i++) {\n            traitsContract.burn(msg.sender, traitsIds[i], amounts[i]);\n        }\n\n        emit TraitsBurnedOnChain(\n            msg.sender,\n            traitsIds,\n            amounts,\n            block.timestamp\n        );\n    }\n\n    /// @notice Set the Traits Contract address   \n    /// @param traitsContractAddress: Address of the Traits Contract\n    function setTraitsContractAddress(\n        address traitsContractAddress\n    ) external onlyOwner {\n        traitsContract = IERC1155Factory(traitsContractAddress);\n    } \n}\n"
    },
    "/contracts/interface/IERC1155Factory.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\r\n// solhint-disable-next-line\r\npragma solidity 0.8.12;\r\n\r\ninterface IERC1155Factory {\r\n    function burn(\r\n        address account,\r\n        uint256 id,\r\n        uint256 value\r\n    ) external;\r\n}\r\n\r\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": true,
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