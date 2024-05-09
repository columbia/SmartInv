1 {{
2   "language": "Solidity",
3   "sources": {
4     "lib/solmate/src/auth/Owned.sol": {
5       "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Simple single owner authorization mixin.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)\nabstract contract Owned {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event OwnershipTransferred(address indexed user, address indexed newOwner);\n\n    /*//////////////////////////////////////////////////////////////\n                            OWNERSHIP STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    address public owner;\n\n    modifier onlyOwner() virtual {\n        require(msg.sender == owner, \"UNAUTHORIZED\");\n\n        _;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(address _owner) {\n        owner = _owner;\n\n        emit OwnershipTransferred(address(0), _owner);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             OWNERSHIP LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        owner = newOwner;\n\n        emit OwnershipTransferred(msg.sender, newOwner);\n    }\n}\n"
6     },
7     "src/interfaces/INeuralAutomataEngine.sol": {
8       "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.15;\r\n\r\nstruct NCAParams {\r\n    string seed;\r\n    string bg;\r\n    string fg1;\r\n    string fg2;\r\n    string matrix;\r\n    string activation;\r\n    string rand;\r\n    string mods;\r\n}\r\n\r\ninterface INeuralAutomataEngine {\r\n    function baseScript() external view returns(string memory);\r\n\r\n    function parameters(NCAParams memory _params) external pure returns(string memory);\r\n\r\n    function p5() external view returns(string memory);\r\n\r\n    function script(NCAParams memory _params) external view returns(string memory);\r\n\r\n    function page(NCAParams memory _params) external view returns(string memory);\r\n}"
9     },
10     "src/interfaces/IZooOfNeuralAutomata.sol": {
11       "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.15;\r\n\r\nimport {NCAParams} from \"./INeuralAutomataEngine.sol\";\r\n\r\ninterface IZooOfNeuralAutomata {\r\n\r\n    function updateEngine(address _engine) external;\r\n\r\n    function updateContractURI(string memory _contractURI) external;\r\n\r\n    function updateParams(uint256 _id, NCAParams memory _params) external;\r\n\r\n    function updateMinter(uint256 _id, address _minter) external;\r\n\r\n    function updateBurner(uint256 _id, address _burner) external;\r\n\r\n    function updateBaseURI(uint256 _id, string memory _baseURI) external;\r\n\r\n    function freeze(uint256 _id) external;\r\n\r\n    function newToken(\r\n        uint256 _id,\r\n        NCAParams memory _params, \r\n        address _minter, \r\n        address _burner,\r\n        string memory _baseURI\r\n    ) external;\r\n\r\n    function mint(\r\n        address _to,\r\n        uint256 _id,\r\n        uint256 _amount\r\n    ) external;\r\n\r\n    function burn(\r\n        address _from,\r\n        uint256 _id,\r\n        uint256 _amount\r\n    ) external;\r\n    \r\n}"
12     },
13     "src/sales/Conways.sol": {
14       "content": "/* SPDX-License-Identifier: MIT\r\n..........\r\n....[]....\r\n......[]..\r\n..[][][]..\r\n..........\r\n*/\r\n\r\npragma solidity 0.8.15;\r\n\r\nimport {IZooOfNeuralAutomata} from \"../interfaces/IZooOfNeuralAutomata.sol\";\r\nimport {Owned} from \"../../lib/solmate/src/auth/Owned.sol\";\r\n\r\ncontract Conways is Owned {\r\n    address public zona;\r\n    uint256 public startTime;\r\n\r\n    mapping(address => bool) public claimed;\r\n\r\n    constructor(\r\n        address _owner, \r\n        address _zona, \r\n        uint256 _startTime\r\n    ) Owned(_owner) {\r\n        zona = _zona;\r\n        startTime = _startTime;\r\n    }\r\n\r\n    function mint() external {\r\n        require(startTime <= block.timestamp || msg.sender == owner);\r\n        require(!claimed[msg.sender]);\r\n        claimed[msg.sender] = true;\r\n        IZooOfNeuralAutomata(zona).mint(msg.sender, 0, 1);\r\n    }\r\n}"
15     }
16   },
17   "settings": {
18     "remappings": [
19       "ds-test/=lib/solmate/lib/ds-test/src/",
20       "ethfs/=lib/ethfs/",
21       "ethier/=lib/ethfs/packages/contracts/lib/ethier/",
22       "forge-std/=lib/forge-std/src/",
23       "openzeppelin/=lib/ethfs/packages/contracts/lib/openzeppelin-contracts/contracts/",
24       "solady/=lib/ethfs/packages/contracts/lib/solady/src/",
25       "solmate/=lib/solmate/src/"
26     ],
27     "optimizer": {
28       "enabled": true,
29       "runs": 1000000
30     },
31     "metadata": {
32       "bytecodeHash": "none"
33     },
34     "outputSelection": {
35       "*": {
36         "*": [
37           "evm.bytecode",
38           "evm.deployedBytecode",
39           "devdoc",
40           "userdoc",
41           "metadata",
42           "abi"
43         ]
44       }
45     },
46     "evmVersion": "london",
47     "libraries": {
48       "src/utils/Base64.sol": {
49         "Base64": "0x38edb18902ed19d6eb3f532233a0246183273bf9"
50       }
51     }
52   }
53 }}