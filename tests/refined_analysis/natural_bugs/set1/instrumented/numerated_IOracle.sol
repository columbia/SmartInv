1 // SPDX-License-Identifier: MIT
2 pragma solidity >= 0.6.12;
3 
4 interface IOracle {
5     /// @notice Get the latest exchange rate.
6     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
7     /// For example:
8     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
9     /// @return success if no valid (recent) rate is available, return false else true.
10     /// @return rate The rate of the requested asset / pair / pool.
11     function get(bytes calldata data) external returns (bool success, uint256 rate);
12 
13     /// @notice Check the last exchange rate without any state changes.
14     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
15     /// For example:
16     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
17     /// @return success if no valid (recent) rate is available, return false else true.
18     /// @return rate The rate of the requested asset / pair / pool.
19     function peek(bytes calldata data) external view returns (bool success, uint256 rate);
20 
21     /// @notice Check the current spot exchange rate without any state changes. For oracles like TWAP this will be different from peek().
22     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
23     /// For example:
24     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
25     /// @return rate The rate of the requested asset / pair / pool.
26     function peekSpot(bytes calldata data) external view returns (uint256 rate);
27 
28     /// @notice Returns a human readable (short) name about this oracle.
29     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
30     /// For example:
31     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
32     /// @return (string) A human readable symbol name about this oracle.
33     function symbol(bytes calldata data) external view returns (string memory);
34 
35     /// @notice Returns a human readable name about this oracle.
36     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
37     /// For example:
38     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
39     /// @return (string) A human readable name about this oracle.
40     function name(bytes calldata data) external view returns (string memory);
41 }
