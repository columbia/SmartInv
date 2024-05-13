1 pragma solidity ^0.5.16;
2 
3 import "../CErc20.sol";
4 
5 /**
6  * @title Compound's CErc20Immutable Contract
7  * @notice CTokens which wrap an EIP-20 underlying and are immutable
8  * @author Compound
9  */
10 contract CErc20Immutable is CErc20 {
11     /**
12      * @notice Construct a new money market
13      * @param underlying_ The address of the underlying asset
14      * @param comptroller_ The address of the Comptroller
15      * @param interestRateModel_ The address of the interest rate model
16      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
17      * @param name_ ERC-20 name of this token
18      * @param symbol_ ERC-20 symbol of this token
19      * @param decimals_ ERC-20 decimal precision of this token
20      * @param admin_ Address of the administrator of this token
21      */
22     constructor(
23         address underlying_,
24         ComptrollerInterface comptroller_,
25         InterestRateModel interestRateModel_,
26         uint256 initialExchangeRateMantissa_,
27         string memory name_,
28         string memory symbol_,
29         uint8 decimals_,
30         address payable admin_
31     ) public {
32         // Creator of the contract is admin during initialization
33         admin = msg.sender;
34 
35         // Initialize the market
36         initialize(
37             underlying_,
38             comptroller_,
39             interestRateModel_,
40             initialExchangeRateMantissa_,
41             name_,
42             symbol_,
43             decimals_
44         );
45 
46         // Set the proper admin now that initialization is done
47         admin = admin_;
48     }
49 }
