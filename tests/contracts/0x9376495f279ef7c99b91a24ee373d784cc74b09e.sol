{{
  "language": "Solidity",
  "sources": {
    "/contracts/token.sol": {
      "content": "pragma solidity ^0.4.24;\n \n//Safe Math Interface\n \ncontract SafeMath {\n \n    function safeAdd(uint a, uint b) public pure returns (uint c) {\n        c = a + b;\n        require(c >= a);\n    }\n \n    function safeSub(uint a, uint b) public pure returns (uint c) {\n        require(b <= a);\n        c = a - b;\n    }\n \n    function safeMul(uint a, uint b) public pure returns (uint c) {\n        c = a * b;\n        require(a == 0 || c / a == b);\n    }\n \n    function safeDiv(uint a, uint b) public pure returns (uint c) {\n        require(b > 0);\n        c = a / b;\n    }\n}\n \n \n//ERC Token Standard #20 Interface\n \ncontract ERC20Interface {\n    function totalSupply() public constant returns (uint);\n    function balanceOf(address tokenOwner) public constant returns (uint balance);\n    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n    function transfer(address to, uint tokens) public returns (bool success);\n    function approve(address spender, uint tokens) public returns (bool success);\n    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n \n    event Transfer(address indexed from, address indexed to, uint tokens);\n    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n}\n \n \n//Contract function to receive approval and execute function in one call\n \ncontract ApproveAndCallFallBack {\n    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n}\n \n//Actual token contract\n \ncontract SP4C3 is ERC20Interface, SafeMath {\n    string public symbol;\n    string public  name;\n    uint8 public decimals;\n    uint public _totalSupply;\n \n    mapping(address => uint) balances;\n    mapping(address => mapping(address => uint)) allowed;\n \n    constructor() public {\n        symbol = \"SP4\";\n        name = \"SP4C3 Token\";\n        decimals = 18;\n        _totalSupply = 1000000000 * 10 ** 18;\n        balances[0xA534b5f18675E20F9f0877dA746fd4b3623C365e] = _totalSupply;\n        emit Transfer(address(0), 0xA534b5f18675E20F9f0877dA746fd4b3623C365e, _totalSupply);\n    }\n \n    function totalSupply() public constant returns (uint) {\n        return _totalSupply  - balances[address(0)];\n    }\n \n    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n        return balances[tokenOwner];\n    }\n \n    function transfer(address to, uint tokens) public returns (bool success) {\n        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n        balances[to] = safeAdd(balances[to], tokens);\n        emit Transfer(msg.sender, to, tokens);\n        return true;\n    }\n \n    function approve(address spender, uint tokens) public returns (bool success) {\n        allowed[msg.sender][spender] = tokens;\n        emit Approval(msg.sender, spender, tokens);\n        return true;\n    }\n \n    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n        balances[from] = safeSub(balances[from], tokens);\n        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n        balances[to] = safeAdd(balances[to], tokens);\n        emit Transfer(from, to, tokens);\n        return true;\n    }\n \n    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n        return allowed[tokenOwner][spender];\n    }\n \n    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n        allowed[msg.sender][spender] = tokens;\n        emit Approval(msg.sender, spender, tokens);\n        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n        return true;\n    }\n \n    function () public payable {\n        revert();\n    }\n}"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": false,
      "runs": 200
    },
    "evmVersion": "byzantium",
    "libraries": {},
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  }
}}