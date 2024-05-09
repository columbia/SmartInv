{{
  "language": "Solidity",
  "sources": {
    "src/L.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.12;\n\nimport './libraries/PoolAddress.sol';\n\ncontract L {\n\n    bytes32 public constant DOMAIN_TYPEHASH = keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\");\n\n    bytes32 public constant PERMIT_TYPEHASH = keccak256(\"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\");\n\n    bytes32 public immutable DOMAIN_SEPARATOR;\n\n    bool public transferable;\n\n    address public owner;\n\n    string public name = \"L\";\n\n    string public symbol = \"L\";\n\n    uint8 public constant decimals = 18;\n\n    uint256 public totalSupply;\n\n    mapping (address => uint256) public balanceOf;\n\n    mapping (address => mapping(address => uint256)) public allowance;\n\n    mapping (address => uint256) public nonces;\n\n    mapping (address => uint256) public antiSnipping;\n\n    mapping (address => bool) public whitelist;\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event OwnershipTransferred(address indexed user, address indexed newOwner);\n\n    event AntiSnippingSet(address indexed pool, uint256 value);\n\n    modifier onlyOwner() {\n        require(msg.sender == owner, \"UNAUTHORIZED\");\n\n        _;\n    }\n\n    constructor() {\n        owner = msg.sender;\n        emit OwnershipTransferred(address(0), msg.sender);\n\n        _mint(msg.sender, 1000000000000 * 10 ** 18);\n\n        uint256 chainId;\n        assembly {\n            chainId := chainid()\n        }\n        DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), keccak256(bytes('1')), chainId, address(this)));\n    }\n\n    function _mint(address to, uint256 amount) internal {\n        totalSupply += amount;\n\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(address(0), to, amount);\n    }\n\n    function burn(uint256 amount) external {\n        balanceOf[msg.sender] -= amount;\n\n        unchecked {\n            totalSupply -= amount;\n        }\n\n        emit Transfer(msg.sender, address(0), amount);\n    }\n\n    function approve(address spender, uint256 amount) external returns (bool) {\n        allowance[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n\n        return true;\n    }\n\n    function transfer(address to, uint256 amount) external returns (bool) {\n        _beforeTokenTransfer(msg.sender, to, amount);\n\n        balanceOf[msg.sender] -= amount;\n\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(msg.sender, to, amount);\n\n        return true;\n    }\n\n    function transferFrom(address from, address to, uint256 amount) external returns (bool) {\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 allowed = allowance[from][msg.sender];\n\n        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;\n\n        balanceOf[from] -= amount;\n\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        return true;\n    }\n\n    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n        require(deadline >= block.timestamp, 'EXPIRED');\n\n        unchecked {\n            bytes32 digest = keccak256(\n                abi.encodePacked(\n                    '\\x19\\x01',\n                    DOMAIN_SEPARATOR,\n                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))\n                )\n            );\n\n            address recoveredAddress = ecrecover(digest, v, r, s);\n\n            require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNATURE');\n\n            allowance[recoveredAddress][spender] = value;\n        }\n\n        emit Approval(owner, spender, value);\n    }\n\n    function _beforeTokenTransfer(address from, address to, uint256 amount) view internal {\n        if (!transferable) {\n            require(whitelist[from] || whitelist[to], \"INVALID_WHITELIST\");\n        }\n        \n        if (antiSnipping[from] > 0) {\n            require(balanceOf[to] + amount <= antiSnipping[from], \"BALANCE_LIMIT\");\n        }\n    }\n\n    function transferOwnership(address newOwner) external onlyOwner {\n        owner = newOwner;\n\n        emit OwnershipTransferred(msg.sender, newOwner);\n    }\n\n    function setWhitelist(address account) external onlyOwner {\n        whitelist[account] = !whitelist[account];\n    }\n\n    function setTransferable() external onlyOwner {\n        transferable = !transferable;\n    }\n\n    function setAntiSnipping(address factory, address tokenA, address tokenB, uint24 fee, uint256 value) external onlyOwner returns (address pool) {\n        PoolAddress.PoolKey memory poolKey = PoolAddress.getPoolKey(tokenA, tokenB, fee);\n\n        pool = PoolAddress.computeAddress(factory, poolKey);\n\n        antiSnipping[pool] = value;\n\n        emit AntiSnippingSet(pool, value);\n    }\n}\n"
    },
    "src/libraries/PoolAddress.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.12;\n\n\nlibrary PoolAddress {\n    bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;\n\n    struct PoolKey {\n        address token0;\n        address token1;\n        uint24 fee;\n    }\n\n    function getPoolKey(\n        address tokenA,\n        address tokenB,\n        uint24 fee\n    ) internal pure returns (PoolKey memory) {\n        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);\n        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});\n    }\n\n    function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {\n        require(key.token0 < key.token1);\n        pool = address(\n            uint160(\n                uint256(\n                    keccak256(\n                        abi.encodePacked(\n                            hex'ff',\n                            factory,\n                            keccak256(abi.encode(key.token0, key.token1, key.fee)),\n                            POOL_INIT_CODE_HASH\n                        )\n                    )\n                )\n            )\n            \n        );\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "libraries": {}
  }
}}