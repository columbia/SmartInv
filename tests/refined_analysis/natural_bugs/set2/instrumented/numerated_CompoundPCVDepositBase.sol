1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../PCVDeposit.sol";
5 import "../../refs/CoreRef.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 interface CToken {
9     function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
10 
11     function exchangeRateStored() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function isCToken() external view returns (bool);
16 
17     function isCEther() external view returns (bool);
18 }
19 
20 /// @title base class for a Compound PCV Deposit
21 /// @author Fei Protocol
22 abstract contract CompoundPCVDepositBase is PCVDeposit {
23     CToken public cToken;
24 
25     uint256 private constant EXCHANGE_RATE_SCALE = 1e18;
26 
27     /// @notice Compound PCV Deposit constructor
28     /// @param _core Fei Core for reference
29     /// @param _cToken Compound cToken to deposit
30     constructor(address _core, address _cToken) CoreRef(_core) {
31         cToken = CToken(_cToken);
32         require(cToken.isCToken(), "CompoundPCVDeposit: Not a cToken");
33     }
34 
35     /// @notice withdraw tokens from the PCV allocation
36     /// @param amountUnderlying of tokens withdrawn
37     /// @param to the address to send PCV to
38     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController whenNotPaused {
39         require(cToken.redeemUnderlying(amountUnderlying) == 0, "CompoundPCVDeposit: redeem error");
40         _transferUnderlying(to, amountUnderlying);
41         emit Withdrawal(msg.sender, to, amountUnderlying);
42     }
43 
44     /// @notice returns total balance of PCV in the Deposit excluding the FEI
45     /// @dev returns stale values from Compound if the market hasn't been updated
46     function balance() public view override returns (uint256) {
47         uint256 exchangeRate = cToken.exchangeRateStored();
48         return (cToken.balanceOf(address(this)) * exchangeRate) / EXCHANGE_RATE_SCALE;
49     }
50 
51     function _transferUnderlying(address to, uint256 amount) internal virtual;
52 }
