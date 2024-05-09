1 pragma solidity 0.4.24;
2 
3 // File: contracts/interfaces/VaultI.sol
4 
5 interface VaultI {
6     function deposit(address contributor) external payable;
7     function saleSuccessful() external;
8     function enableRefunds() external;
9     function refund(address contributor) external;
10     function close() external;
11     function sendFundsToWallet() external;
12 }
13 
14 // File: contracts/Refunder.sol
15 
16 /**
17  * @title Refunder
18  * @dev This contract is used when sale has had its refunds enabled,
19  *      and ETH needs to be refunded to each sale contributor.
20  */
21 contract Refunder {
22 
23     /// @dev Called to refund ETH
24     /// @dev The array of contributors should not have an address that has already
25     ///      been refunded otherwise it will revert. So the contributors array
26     ///      should be checked offchain before being sent to this function
27     /// @param _vault Address of the interface for the sale to use
28     /// @param _contributors Array of contributors for which eth will be refunded
29     function refundContribution(VaultI _vault, address[] _contributors)
30         external
31     {
32         for (uint256 i = 0; i < _contributors.length; i++) {
33             address contributor = _contributors[i];
34             _vault.refund(contributor);
35         }
36     }
37 }