1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../modules/Exec.sol";
5 import "../modules/Markets.sol";
6 import "../modules/DToken.sol";
7 import "../Interfaces.sol";
8 import "../Utils.sol";
9 
10 contract FlashLoan is IERC3156FlashLender, IDeferredLiquidityCheck {
11     bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
12     
13     address immutable eulerAddress;
14     Exec immutable exec;
15     Markets immutable markets;
16 
17     bool internal _isDeferredLiquidityCheck;
18     
19     constructor(address euler_, address exec_, address markets_) {
20         eulerAddress = euler_;
21         exec = Exec(exec_);
22         markets = Markets(markets_);
23     }
24 
25     function maxFlashLoan(address token) override external view returns (uint) {
26         address eTokenAddress = markets.underlyingToEToken(token);
27 
28         return eTokenAddress == address(0) ? 0 : IERC20(token).balanceOf(eulerAddress);
29     }
30 
31     function flashFee(address token, uint) override external view returns (uint) {
32         require(markets.underlyingToEToken(token) != address(0), "e/flash-loan/unsupported-token");
33 
34         return 0;
35     }
36 
37     function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 amount, bytes calldata data) override external returns (bool) {
38         require(markets.underlyingToEToken(token) != address(0), "e/flash-loan/unsupported-token");
39 
40         if(!_isDeferredLiquidityCheck) {
41             exec.deferLiquidityCheck(address(this), abi.encode(receiver, token, amount, data, msg.sender));
42             _isDeferredLiquidityCheck = false;
43         } else {
44             _loan(receiver, token, amount, data, msg.sender);
45         }
46         
47         return true;
48     }
49 
50     function onDeferredLiquidityCheck(bytes memory encodedData) override external {
51         require(msg.sender == eulerAddress, "e/flash-loan/on-deferred-caller");
52         (IERC3156FlashBorrower receiver, address token, uint amount, bytes memory data, address msgSender) =
53             abi.decode(encodedData, (IERC3156FlashBorrower, address, uint, bytes, address));
54 
55         _isDeferredLiquidityCheck = true;
56         _loan(receiver, token, amount, data, msgSender);
57 
58         _exitAllMarkets();
59     }
60 
61     function _loan(IERC3156FlashBorrower receiver, address token, uint256 amount, bytes memory data, address msgSender) internal {
62         DToken dToken = DToken(markets.underlyingToDToken(token));
63 
64         dToken.borrow(0, amount);
65         Utils.safeTransfer(token, address(receiver), amount);
66 
67         require(
68             receiver.onFlashLoan(msgSender, token, amount, 0, data) == CALLBACK_SUCCESS,
69             "e/flash-loan/callback"
70         );
71 
72         Utils.safeTransferFrom(token, address(receiver), address(this), amount);
73         require(IERC20(token).balanceOf(address(this)) >= amount, 'e/flash-loan/pull-amount');
74 
75         uint allowance = IERC20(token).allowance(address(this), eulerAddress);
76         if(allowance < amount) {
77             (bool success,) = token.call(abi.encodeWithSelector(IERC20(token).approve.selector, eulerAddress, type(uint).max));
78             require(success, "e/flash-loan/approve");
79         }
80 
81         dToken.repay(0, amount);
82     }
83 
84     function _exitAllMarkets() internal {
85         address[] memory enteredMarkets = markets.getEnteredMarkets(address(this));
86 
87         for (uint i = 0; i < enteredMarkets.length; ++i) {
88             markets.exitMarket(0, enteredMarkets[i]);
89         }
90     }
91 }
