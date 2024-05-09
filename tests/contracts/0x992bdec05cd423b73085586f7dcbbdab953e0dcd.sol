{{
  "language": "Solidity",
  "sources": {
    "contracts/SuSquaresUnderlay.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\nimport \"./AccessControlTwoOfficers.sol\";\n\ninterface SuSquares {\n    function ownerOf(uint256) external view returns(address);\n}\n\n/// @title  Personalize your Su Squares that are unpersonalized on the main contract\n/// @author William Entriken (https://phor.net)\ncontract SuSquaresUnderlay is AccessControlTwoOfficers {\n    SuSquares public constant suSquares = SuSquares(0xE9e3F9cfc1A64DFca53614a0182CFAD56c10624F);\n    uint256 public constant pricePerSquare = 1e15; // 1 Finney\n\n    struct Personalization {\n        uint256 squareId;\n        bytes rgbData;\n        string title;\n        string href;\n    }\n\n    event PersonalizedUnderlay(\n        uint256 indexed squareId,\n        bytes rgbData,\n        string title,\n        string href\n    );\n\n    /// @notice Update the contents of your Square on the underlay\n    /// @param  squareId Your Square number, the top-left is 1, to its right is 2, ..., top-right is 100 and then 101 is\n    ///                  below 1... the last one at bottom-right is 10000\n    /// @param  rgbData  A 10x10 image for your square, in 8-bit RGB words ordered like the squares are ordered. See\n    ///                  Imagemagick's command: convert -size 10x10 -depth 8 in.rgb out.png\n    /// @param  title    A description of your square (max 64 bytes UTF-8)\n    /// @param  href     A hyperlink for your square (max 96 bytes)\n    function personalizeSquareUnderlay(\n        uint256 squareId,\n        bytes calldata rgbData,\n        string calldata title,\n        string calldata href\n    )\n        external payable\n    {\n        require(msg.value == pricePerSquare);\n        _personalizeSquareUnderlay(squareId, rgbData, title, href);\n    }\n\n    /// @notice Update the contents of Square on the underlay\n    /// @param  personalizations Each one is a the personalization for a single Square\n    function personalizeSquareUnderlayBatch(Personalization[] calldata personalizations) external payable {\n        require(personalizations.length > 0, \"Missing personalizations\");\n        require(msg.value == pricePerSquare * personalizations.length);\n        for(uint256 i=0; i<personalizations.length; i++) {\n            _personalizeSquareUnderlay(\n                personalizations[i].squareId,\n                personalizations[i].rgbData,\n                personalizations[i].title,\n                personalizations[i].href\n            );\n        }\n    }\n\n    function _personalizeSquareUnderlay(\n        uint256 squareId,\n        bytes calldata rgbData,\n        string calldata title,\n        string calldata href\n    ) private {\n        require(suSquares.ownerOf(squareId) == msg.sender, \"Only the Su Square owner may personalize underlay\");\n        require(rgbData.length == 300, \"Pixel data must be 300 bytes: 3 colors (RGB) x 10 columns x 10 rows\");\n        require(bytes(title).length <= 64, \"Title max 64 bytes\");\n        require(bytes(href).length <= 96, \"HREF max 96 bytes\");\n        emit PersonalizedUnderlay(\n            squareId,\n            rgbData,\n            title,\n            href\n        );\n    }\n}"
    },
    "contracts/AccessControlTwoOfficers.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\n\n/// @title  Role-based access control inspired by CryptoKitties\n/// @dev    Keep the CEO wallet stored offline, I warned you.\n/// @author William Entriken (https://phor.net)\nabstract contract AccessControlTwoOfficers {\n    /// @notice The account that can only reassign officer accounts\n    address public executiveOfficer;\n\n    /// @notice The account that can collect funds from this contract\n    address payable public financialOfficer;\n\n    constructor() {\n        executiveOfficer = msg.sender;\n    }\n\n    /// @notice Reassign the executive officer role\n    /// @param  newExecutiveOfficer new officer address\n    function setExecutiveOfficer(address newExecutiveOfficer) external {\n        require(msg.sender == executiveOfficer);\n        require(newExecutiveOfficer != address(0));\n        executiveOfficer = newExecutiveOfficer;\n    }\n\n    /// @notice Reassign the financial officer role\n    /// @param  newFinancialOfficer new officer address\n    function setFinancialOfficer(address payable newFinancialOfficer) external {\n        require(msg.sender == executiveOfficer);\n        require(newFinancialOfficer != address(0));\n        financialOfficer = newFinancialOfficer;\n    }\n\n    /// @notice Collect funds from this contract\n    function withdrawBalance() external {\n        require(msg.sender == financialOfficer);\n        financialOfficer.transfer(address(this).balance);\n    }\n}"
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
    }
  }
}}