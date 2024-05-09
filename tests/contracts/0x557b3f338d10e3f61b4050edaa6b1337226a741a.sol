{{
  "language": "Solidity",
  "sources": {
    "contracts/MonasteryStakingHelper.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity 0.7.5;\n\nimport \"./interfaces/IERC20.sol\";\n\ninterface IStaking {\n    function stake( uint _amount, address _recipient ) external returns ( bool );\n    function claim( address _recipient ) external;\n}\n\ncontract MonasteryStakingHelper {\n\n    address public immutable staking;\n    address public immutable MONK;\n\n    constructor ( address _staking, address _MONK ) {\n        require( _staking != address(0) );\n        staking = _staking;\n        require( _MONK != address(0) );\n        MONK = _MONK;\n    }\n\n    function stake( uint _amount ) external {\n        IERC20( MONK ).transferFrom( msg.sender, address(this), _amount );\n        IERC20( MONK ).approve( staking, _amount );\n        IStaking( staking ).stake( _amount, msg.sender );\n        IStaking( staking ).claim( msg.sender );\n    }\n}\n"
    },
    "contracts/interfaces/IERC20.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity >=0.5.0;\n\ninterface IERC20 {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external view returns (string memory);\n    function symbol() external view returns (string memory);\n    function decimals() external view returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n}\n\ninterface IERC20Mintable {\n  function mint( uint256 amount_ ) external;\n\n  function mint( address account_, uint256 ammount_ ) external;\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 800
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}