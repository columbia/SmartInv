1 // SPDX-License-Identifier: CC0-1.0
2 pragma solidity 0.8.19;
3 
4 // This interface is designed to be compatible with the Vyper version.
5 /// @notice This is the Ethereum 2.0 deposit contract interface.
6 /// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs
7 interface IDepositContract {
8     /// @notice Submit a Phase 0 DepositData object.
9     /// @param pubkey A BLS12-381 public key.
10     /// @param withdrawal_credentials Commitment to a public key for withdrawals.
11     /// @param signature A BLS12-381 signature.
12     /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.
13     /// Used as a protection against malformed input.
14     function deposit(
15         bytes calldata pubkey,
16         bytes calldata withdrawal_credentials,
17         bytes calldata signature,
18         bytes32 deposit_data_root
19     ) external payable;
20 
21     /// @notice Query the current deposit count.
22     /// @return The deposit count encoded as a little endian 64-bit number.
23     function get_deposit_count() external view returns (bytes memory);
24 }
