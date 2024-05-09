{{
  "language": "Solidity",
  "sources": {
    "lib/solmate/src/auth/Owned.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Simple single owner authorization mixin.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)\nabstract contract Owned {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event OwnershipTransferred(address indexed user, address indexed newOwner);\n\n    /*//////////////////////////////////////////////////////////////\n                            OWNERSHIP STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    address public owner;\n\n    modifier onlyOwner() virtual {\n        require(msg.sender == owner, \"UNAUTHORIZED\");\n\n        _;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(address _owner) {\n        owner = _owner;\n\n        emit OwnershipTransferred(address(0), _owner);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             OWNERSHIP LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        owner = newOwner;\n\n        emit OwnershipTransferred(msg.sender, newOwner);\n    }\n}\n"
    },
    "src/interfaces/INeuralAutomataEngine.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.15;\r\n\r\nstruct NCAParams {\r\n    string seed;\r\n    string bg;\r\n    string fg1;\r\n    string fg2;\r\n    string matrix;\r\n    string activation;\r\n    string rand;\r\n    string mods;\r\n}\r\n\r\ninterface INeuralAutomataEngine {\r\n    function baseScript() external view returns(string memory);\r\n\r\n    function parameters(NCAParams memory _params) external pure returns(string memory);\r\n\r\n    function p5() external view returns(string memory);\r\n\r\n    function script(NCAParams memory _params) external view returns(string memory);\r\n\r\n    function page(NCAParams memory _params) external view returns(string memory);\r\n}"
    },
    "src/interfaces/IZooOfNeuralAutomata.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.15;\r\n\r\nimport {NCAParams} from \"./INeuralAutomataEngine.sol\";\r\n\r\ninterface IZooOfNeuralAutomata {\r\n\r\n    function updateEngine(address _engine) external;\r\n\r\n    function updateContractURI(string memory _contractURI) external;\r\n\r\n    function updateParams(uint256 _id, NCAParams memory _params) external;\r\n\r\n    function updateMinter(uint256 _id, address _minter) external;\r\n\r\n    function updateBurner(uint256 _id, address _burner) external;\r\n\r\n    function updateBaseURI(uint256 _id, string memory _baseURI) external;\r\n\r\n    function freeze(uint256 _id) external;\r\n\r\n    function newToken(\r\n        uint256 _id,\r\n        NCAParams memory _params, \r\n        address _minter, \r\n        address _burner,\r\n        string memory _baseURI\r\n    ) external;\r\n\r\n    function mint(\r\n        address _to,\r\n        uint256 _id,\r\n        uint256 _amount\r\n    ) external;\r\n\r\n    function burn(\r\n        address _from,\r\n        uint256 _id,\r\n        uint256 _amount\r\n    ) external;\r\n    \r\n}"
    },
    "src/sales/Quaqs.sol": {
      "content": "/* SPDX-License-Identifier: MIT\r\n                                       __  .__     \r\n  ________ _______    ______     _____/  |_|  |__  \r\n / ____/  |  \\__  \\  / ____/   _/ __ \\   __\\  |  \\ \r\n< <_|  |  |  // __ \\< <_|  |   \\  ___/|  | |   Y  \\\r\n \\__   |____/(____  /\\__   | /\\ \\___  >__| |___|  /\r\n    |__|          \\/    |__| \\/     \\/          \\/ \r\n*/\r\n\r\npragma solidity 0.8.15;\r\n\r\nimport {IZooOfNeuralAutomata} from \"../interfaces/IZooOfNeuralAutomata.sol\";\r\nimport {Owned} from \"../../lib/solmate/src/auth/Owned.sol\";\r\n\r\ncontract Quaqs is Owned {\r\n    uint256 constant maxSupply = 1000;\r\n    uint256 constant price = 0.0314 ether;\r\n\r\n    address public zona;\r\n    uint256 public startTime;\r\n\r\n    uint256 public sold;\r\n    bool private claimed;\r\n\r\n    constructor(\r\n        address _owner,\r\n        address _zona, \r\n        uint256 _startTime\r\n    ) Owned(_owner) {\r\n        zona = _zona;\r\n        startTime = _startTime;\r\n    }\r\n\r\n    function mint(uint256 amount) external payable {\r\n        require(startTime <= block.timestamp);\r\n        require(msg.value >= price * amount);\r\n        require(sold + amount <= maxSupply);\r\n\r\n        sold += amount;\r\n\r\n        IZooOfNeuralAutomata(zona).mint(msg.sender, 1, amount);\r\n    }\r\n\r\n    function reserved() external onlyOwner {\r\n        require(!claimed);\r\n        claimed = true;\r\n        IZooOfNeuralAutomata(zona).mint(owner, 1, 24);\r\n    }\r\n\r\n    function withdraw() external onlyOwner {\r\n        payable(owner).transfer(address(this).balance);\r\n    }\r\n}"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/solmate/lib/ds-test/src/",
      "ethfs/=lib/ethfs/",
      "ethier/=lib/ethfs/packages/contracts/lib/ethier/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin/=lib/ethfs/packages/contracts/lib/openzeppelin-contracts/contracts/",
      "solady/=lib/ethfs/packages/contracts/lib/solady/src/",
      "solmate/=lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "metadata": {
      "bytecodeHash": "none"
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
    "evmVersion": "london",
    "libraries": {
      "src/utils/Base64.sol": {
        "Base64": "0x38edb18902ed19d6eb3f532233a0246183273bf9"
      }
    }
  }
}}