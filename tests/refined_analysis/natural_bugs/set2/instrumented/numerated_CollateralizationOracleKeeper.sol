1 pragma solidity ^0.8.0;
2 
3 import "../fei/minter/FeiTimedMinter.sol";
4 import "../oracle/collateralization/ICollateralizationOracleWrapper.sol";
5 
6 /// @title CollateralizationOracleKeeper
7 /// @notice a FEI timed minter which only rewards when updating the collateralization oracle
8 contract CollateralizationOracleKeeper is FeiTimedMinter {
9     ICollateralizationOracleWrapper public collateralizationOracleWrapper;
10 
11     /**
12         @notice constructor for CollateralizationOracleKeeper
13         @param _core the Core address to reference
14         @param _incentive the incentive amount for calling mint paid in FEI
15         @param _collateralizationOracleWrapper the collateralizationOracleWrapper to incentivize updates only
16         sets the target to this address and mint amount to 0, relying exclusively on the incentive payment to caller
17     */
18     constructor(
19         address _core,
20         uint256 _incentive,
21         ICollateralizationOracleWrapper _collateralizationOracleWrapper
22     ) FeiTimedMinter(_core, address(this), _incentive, MIN_MINT_FREQUENCY, 0) {
23         collateralizationOracleWrapper = _collateralizationOracleWrapper;
24     }
25 
26     function _afterMint() internal override {
27         collateralizationOracleWrapper.updateIfOutdated();
28     }
29 }
