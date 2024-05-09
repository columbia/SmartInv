{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
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
  },
  "sources": {
    "contracts/apeusd/ApeUSD.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.6;\n\ninterface IApeFinance {\n    function mint(address minter, uint256 mintAmount)\n        external\n        returns (uint256);\n    function redeem(\n        address payable redeemer,\n        uint256 redeemTokens,\n        uint256 redeemAmount\n    ) external returns (uint256);\n    function exchangeRateStored() external view returns (uint);\n    function balanceOf(address) external view returns (uint);\n}\n\ncontract ApeUSD {\n    string public constant name = \"ApeUSD\";\n    string public constant symbol = \"ApeUSD\";\n    uint8 public constant decimals = 18;\n\n    IApeFinance public apefi;\n    address public gov;\n    address public nextgov;\n    uint public commitgov;\n    uint public constant delay = 1 days;\n\n    uint public liquidity;\n\n    constructor() {\n        gov = msg.sender;\n    }\n\n    modifier g() {\n        require(msg.sender == gov);\n        _;\n    }\n\n    function setApefi(address _apefi) external g {\n        require(address(apefi) == address(0), 'apefi address already set');\n        apefi = IApeFinance(_apefi);\n    }\n\n    function setGov(address _gov) external g {\n        nextgov = _gov;\n        commitgov = block.timestamp + delay;\n    }\n\n    function acceptGov() external {\n        require(msg.sender == nextgov && commitgov < block.timestamp);\n        gov = nextgov;\n    }\n\n    function balanceApeFi() public view returns (uint) {\n        return apefi.balanceOf(address(this));\n    }\n\n    function balanceUnderlying() public view returns (uint) {\n        uint256 _b = balanceApeFi();\n        if (_b > 0) {\n            return _b * apefi.exchangeRateStored() / 1e18;\n        }\n        return 0;\n    }\n\n    function _redeem(uint amount) internal {\n        require(apefi.redeem(payable(address(this)), 0, amount) == 0, \"apefi: withdraw failed\");\n    }\n\n    function profit() external {\n        uint _profit = balanceUnderlying() - liquidity;\n        _redeem(_profit);\n        _transferTokens(address(this), gov, _profit);\n    }\n\n    function withdraw(uint amount) external g {\n        liquidity -= amount;\n        _redeem(amount);\n        _burn(amount);\n    }\n\n    function deposit() external {\n        uint _amount = balances[address(this)];\n        allowances[address(this)][address(apefi)] = _amount;\n        liquidity += _amount;\n        require(apefi.mint(address(this), _amount) == 0, \"apefi: supply failed\");\n    }\n\n    /// @notice Total number of tokens in circulation\n    uint public totalSupply = 0;\n\n    mapping(address => mapping (address => uint)) internal allowances;\n    mapping(address => uint) internal balances;\n\n    event Transfer(address indexed from, address indexed to, uint amount);\n    event Approval(address indexed owner, address indexed spender, uint amount);\n\n    function mint(uint amount) external g {\n        // mint the amount\n        totalSupply += amount;\n        // transfer the amount to the recipient\n        balances[address(this)] += amount;\n        emit Transfer(address(0), address(this), amount);\n    }\n\n    function burn(uint amount) external g {\n        _burn(amount);\n    }\n\n    function _burn(uint amount) internal {\n        // burn the amount\n        totalSupply -= amount;\n        // transfer the amount from the recipient\n        balances[address(this)] -= amount;\n        emit Transfer(address(this), address(0), amount);\n    }\n\n    function allowance(address account, address spender) external view returns (uint) {\n        return allowances[account][spender];\n    }\n\n    function approve(address spender, uint amount) external returns (bool) {\n        allowances[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function balanceOf(address account) external view returns (uint) {\n        return balances[account];\n    }\n\n    function transfer(address dst, uint amount) external returns (bool) {\n        _transferTokens(msg.sender, dst, amount);\n        return true;\n    }\n\n    function transferFrom(address src, address dst, uint amount) external returns (bool) {\n        address spender = msg.sender;\n        uint spenderAllowance = allowances[src][spender];\n\n        if (spender != src && spenderAllowance != type(uint).max) {\n            uint newAllowance = spenderAllowance - amount;\n            allowances[src][spender] = newAllowance;\n\n            emit Approval(src, spender, newAllowance);\n        }\n\n        _transferTokens(src, dst, amount);\n        return true;\n    }\n\n    function _transferTokens(address src, address dst, uint amount) internal {\n        balances[src] -= amount;\n        balances[dst] += amount;\n\n        emit Transfer(src, dst, amount);\n    }\n}\n"
    }
  }
}}