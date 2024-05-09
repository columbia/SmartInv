1 {{
2   "language": "Solidity",
3   "sources": {
4     "src/esZTH.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.19;\n\nimport \"./interfaces/IMint.sol\";\nimport \"./NonERC20.sol\";\n\n/**\n * @title Zenith ETH\n */\ncontract ESZTH is NonERC20(\"Zenith Escrowed Token\", \"esZTH\", 18) {\n    uint256 private constant _SLEEP_TIMES = 3 days;\n    uint256 private constant _MAX_LOCK_TIMES = 14 days;\n    address private constant _DEAD = 0x000000000000000000000000000000000000dEaD;\n\n    address public immutable MASTERCHEF;\n    address public immutable TREASURY;\n    address public immutable ZTHTOKEN;\n\n    LockInfo[] private _lockPositions;\n\n    struct LockInfo {\n        address holder;\n        uint256 amount;\n        uint256 unlockTime;\n    }\n\n    constructor(address masterChef, address treasury, address zthToken) {\n        if (masterChef == address(0)) revert AddressIsZero();\n        if (treasury == address(0)) revert AddressIsZero();\n        if (zthToken == address(0)) revert AddressIsZero();\n\n        MASTERCHEF = masterChef;\n        TREASURY = treasury;\n        ZTHTOKEN = zthToken;\n    }\n\n    function mint(address to, uint256 amount) external onlyMasterChef {\n        _mint(to, amount);\n    }\n\n    /**\n     * @notice Swap ESZTH to ZTH\n     * @dev Early redemption will result in the loss of the corresponding ZTH share,\n     *  which 50% will be burned and other 50% belonging to the team treasury.\n     */\n    function swap(uint256 amount, uint256 lockTimes) external {\n        _burn(msg.sender, amount);\n\n        uint256 amountOut = getAmountOut(amount, lockTimes);\n\n        uint256 loss;\n        unchecked {\n            loss = amount - amountOut;\n        }\n        // mint ZTH to treasury\n        if (loss > 0) {\n            IMint(ZTHTOKEN).mint(_DEAD, loss / 2);\n            IMint(ZTHTOKEN).mint(TREASURY, loss / 2);\n        }\n\n        uint256 lid = _lockPositions.length;\n        unchecked {\n            _lockPositions.push(LockInfo(msg.sender, amountOut, block.timestamp + lockTimes));\n        }\n        emit Swap(msg.sender, lid, amount, lockTimes, amountOut);\n    }\n\n    function redeem(uint256 lockId) public {\n        LockInfo storage lockInfo = _lockPositions[lockId];\n        if (lockInfo.unlockTime > block.timestamp) revert UnlockTimeNotArrived();\n        uint256 amount = lockInfo.amount;\n\n        if (amount == 0) revert LockedAmountIsZero();\n\n        // update state\n        lockInfo.amount = 0;\n        // mint ZTH to holder\n        IMint(ZTHTOKEN).mint(lockInfo.holder, amount);\n\n        emit Redeem(lockInfo.holder, lockId, amount);\n    }\n\n    function batchRedeem(uint256[] calldata lockIds) external {\n        for (uint256 i = 0; i < lockIds.length; i++) {\n            redeem(lockIds[i]);\n        }\n    }\n\n    function getAmountOut(uint256 amount, uint256 lockTimes) public pure returns (uint256) {\n        if (lockTimes < _SLEEP_TIMES || lockTimes > _MAX_LOCK_TIMES) revert InvalidLockTimes();\n        // 20% of the amount will be locked for 3 days\n        // 100% of the amount will be locked for 14 days\n        // amount= 20%+ 80%*(lockTimes-3days)/(14days-3days)\n        unchecked {\n            return (amount * 2 + amount * 8 * (lockTimes - _SLEEP_TIMES) / (_MAX_LOCK_TIMES - _SLEEP_TIMES)) / 10;\n        }\n    }\n\n    function getLockPosition(uint256 lockId) external view returns (LockInfo memory) {\n        return _lockPositions[lockId];\n    }\n \n    modifier onlyMasterChef() {\n        if (msg.sender != MASTERCHEF) revert OnlyCallByMasterChef();\n\n        _;\n    }\n\n    event Swap(address indexed holder, uint256 lockId, uint256 amount, uint256 lockTimes, uint256 amountOut);\n    event Redeem(address indexed holder, uint256 lockId, uint256 amount);\n\n    error AddressIsZero();\n    error OnlyCallByMasterChef();\n    error InvalidLockTimes();\n    error LockedAmountIsZero();\n    error UnlockTimeNotArrived(); \n}\n"
6     },
7     "src/interfaces/IMint.sol": {
8       "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.19;\n \ninterface IMint {\n    function mint(address to, uint256 amount) external;\n}\n"
9     },
10     "src/NonERC20.sol": {
11       "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n \nabstract contract NonERC20 {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n \n    /*//////////////////////////////////////////////////////////////\n                            METADATA STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    string public name;\n\n    string public symbol;\n\n    uint8 public immutable decimals;\n\n    /*//////////////////////////////////////////////////////////////\n                              ERC20 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 public totalSupply;\n\n    mapping(address => uint256) public balanceOf;\n   \n\n    constructor(\n        string memory _name,\n        string memory _symbol,\n        uint8 _decimals\n    ) {\n        name = _name;\n        symbol = _symbol;\n        decimals = _decimals; \n    }\n   \n    /*//////////////////////////////////////////////////////////////\n                        INTERNAL MINT/BURN LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function _mint(address to, uint256 amount) internal virtual {\n        totalSupply += amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(address(0), to, amount);\n    }\n\n    function _burn(address from, uint256 amount) internal virtual {\n        balanceOf[from] -= amount;\n\n        // Cannot underflow because a user's balance\n        // will never be larger than the total supply.\n        unchecked {\n            totalSupply -= amount;\n        }\n\n        emit Transfer(from, address(0), amount);\n    }\n}\n"
12     }
13   },
14   "settings": {
15     "remappings": [
16       "@openzeppelin/=lib/openzeppelin-contracts/",
17       "@solmate/=lib/solmate/src/",
18       "ds-test/=lib/forge-std/lib/ds-test/src/",
19       "forge-std/=lib/forge-std/src/",
20       "openzeppelin-contracts/=lib/openzeppelin-contracts/",
21       "solmate/=lib/solmate/src/"
22     ],
23     "optimizer": {
24       "enabled": true,
25       "runs": 20000
26     },
27     "metadata": {
28       "bytecodeHash": "ipfs",
29       "appendCBOR": true
30     },
31     "outputSelection": {
32       "*": {
33         "*": [
34           "evm.bytecode",
35           "evm.deployedBytecode",
36           "devdoc",
37           "userdoc",
38           "metadata",
39           "abi"
40         ]
41       }
42     },
43     "evmVersion": "london",
44     "libraries": {}
45   }
46 }}