1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/RouterETH.sol": {
5       "content": "// SPDX-License-Identifier: BUSL-1.1\n\npragma solidity 0.7.6;\npragma abicoder v2;\n\nimport \"./interfaces/IStargateRouter.sol\";\nimport \"./interfaces/IStargateEthVault.sol\";\n\ncontract RouterETH {\n    address public immutable stargateEthVault;\n    IStargateRouter public immutable stargateRouter;\n    uint16 public immutable poolId;\n\n    constructor(address _stargateEthVault, address _stargateRouter, uint16 _poolId){\n        require(_stargateEthVault != address(0x0), \"RouterETH: _stargateEthVault cant be 0x0\");\n        require(_stargateRouter != address(0x0), \"RouterETH: _stargateRouter cant be 0x0\");\n        stargateEthVault = _stargateEthVault;\n        stargateRouter = IStargateRouter(_stargateRouter);\n        poolId = _poolId;\n    }\n\n    function addLiquidityETH() external payable {\n        require(msg.value > 0, \"Stargate: msg.value is 0\");\n\n        uint256 amountLD = msg.value;\n\n        // wrap the ETH into WETH\n        IStargateEthVault(stargateEthVault).deposit{value: amountLD}();\n        IStargateEthVault(stargateEthVault).approve(address(stargateRouter), amountLD);\n\n        // addLiquidity using the WETH that was just wrapped,\n        // and mint the LP token to the msg.sender\n        stargateRouter.addLiquidity(\n            poolId,\n            amountLD,\n            msg.sender\n        );\n    }\n\n    // compose stargate to swap ETH on the source to ETH on the destination\n    function swapETH(\n        uint16 _dstChainId,                         // destination Stargate chainId\n        address payable _refundAddress,             // refund additional messageFee to this address\n        bytes calldata _toAddress,                  // the receiver of the destination ETH\n        uint256 _amountLD,                          // the amount, in Local Decimals, to be swapped\n        uint256 _minAmountLD                        // the minimum amount accepted out on destination\n    ) external payable {\n        require(msg.value > _amountLD, \"Stargate: msg.value must be > _amountLD\");\n\n        // wrap the ETH into WETH\n        IStargateEthVault(stargateEthVault).deposit{value: _amountLD}();\n        IStargateEthVault(stargateEthVault).approve(address(stargateRouter), _amountLD);\n\n        // messageFee is the remainder of the msg.value after wrap\n        uint256 messageFee = msg.value - _amountLD;\n\n        // compose a stargate swap() using the WETH that was just wrapped\n        stargateRouter.swap{value: messageFee}(\n            _dstChainId,                        // destination Stargate chainId\n            poolId,                             // WETH Stargate poolId on source\n            poolId,                             // WETH Stargate poolId on destination\n            _refundAddress,                     // message refund address if overpaid\n            _amountLD,                          // the amount in Local Decimals to swap()\n            _minAmountLD,                       // the minimum amount swap()er would allow to get out (ie: slippage)\n            IStargateRouter.lzTxObj(0, 0, \"0x\"),\n            _toAddress,                         // address on destination to send to\n            bytes(\"\")                           // empty payload, since sending to EOA\n        );\n    }\n\n    // this contract needs to accept ETH\n    receive() external payable {}\n\n}"
6     },
7     "contracts/interfaces/IStargateRouter.sol": {
8       "content": "// SPDX-License-Identifier: BUSL-1.1\n\npragma solidity 0.7.6;\npragma abicoder v2;\n\ninterface IStargateRouter {\n    struct lzTxObj {\n        uint256 dstGasForCall;\n        uint256 dstNativeAmount;\n        bytes dstNativeAddr;\n    }\n\n    function addLiquidity(\n        uint256 _poolId,\n        uint256 _amountLD,\n        address _to\n    ) external;\n\n    function swap(\n        uint16 _dstChainId,\n        uint256 _srcPoolId,\n        uint256 _dstPoolId,\n        address payable _refundAddress,\n        uint256 _amountLD,\n        uint256 _minAmountLD,\n        lzTxObj memory _lzTxParams,\n        bytes calldata _to,\n        bytes calldata _payload\n    ) external payable;\n\n    function redeemRemote(\n        uint16 _dstChainId,\n        uint256 _srcPoolId,\n        uint256 _dstPoolId,\n        address payable _refundAddress,\n        uint256 _amountLP,\n        uint256 _minAmountLD,\n        bytes calldata _to,\n        lzTxObj memory _lzTxParams\n    ) external payable;\n\n    function instantRedeemLocal(\n        uint16 _srcPoolId,\n        uint256 _amountLP,\n        address _to\n    ) external returns (uint256);\n\n    function redeemLocal(\n        uint16 _dstChainId,\n        uint256 _srcPoolId,\n        uint256 _dstPoolId,\n        address payable _refundAddress,\n        uint256 _amountLP,\n        bytes calldata _to,\n        lzTxObj memory _lzTxParams\n    ) external payable;\n\n    function sendCredits(\n        uint16 _dstChainId,\n        uint256 _srcPoolId,\n        uint256 _dstPoolId,\n        address payable _refundAddress\n    ) external payable;\n\n    function quoteLayerZeroFee(\n        uint16 _dstChainId,\n        uint8 _functionType,\n        bytes calldata _toAddress,\n        bytes calldata _transferAndCallPayload,\n        lzTxObj memory _lzTxParams\n    ) external view returns (uint256, uint256);\n}\n"
9     },
10     "contracts/interfaces/IStargateEthVault.sol": {
11       "content": "pragma solidity 0.7.6;\n\ninterface IStargateEthVault {\n    function deposit() external payable;\n    function transfer(address to, uint value) external returns (bool);\n    function withdraw(uint) external;\n    function approve(address guy, uint wad) external returns (bool);\n    function transferFrom(address src, address dst, uint wad) external returns (bool);\n}"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": true,
17       "runs": 200
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "devdoc",
25           "userdoc",
26           "metadata",
27           "abi"
28         ]
29       }
30     },
31     "metadata": {
32       "useLiteralContent": true
33     },
34     "libraries": {}
35   }
36 }}