1 // SPDX-License-Identifier: MIT
2 import "../interfaces/IOracle.sol";
3 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
4 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
5 
6 /// @title ProxyOracle
7 /// @author 0xMerlin
8 /// @notice Oracle used for getting the price of xSUSHI based on Chainlink
9 contract ProxyOracle is IOracle, BoringOwnable {
10 
11     IOracle public oracleImplementation;
12 
13     event LogOracleImplementationChange(IOracle indexed oldOracle, IOracle indexed newOracle);
14 
15     constructor() public {
16     }
17 
18     function changeOracleImplementation(IOracle newOracle) external onlyOwner {
19         IOracle oldOracle = oracleImplementation;
20         oracleImplementation = newOracle;
21         emit LogOracleImplementationChange(oldOracle, newOracle);
22     }
23 
24     // Get the latest exchange rate
25     /// @inheritdoc IOracle
26     function get(bytes calldata data) public override returns (bool, uint256) {
27         return oracleImplementation.get(data);
28     }
29 
30     // Check the last exchange rate without any state changes
31     /// @inheritdoc IOracle
32     function peek(bytes calldata data) public view override returns (bool, uint256) {
33         return oracleImplementation.peek(data);
34     }
35 
36     // Check the current spot exchange rate without any state changes
37     /// @inheritdoc IOracle
38     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
39         return oracleImplementation.peekSpot(data);
40     }
41 
42     /// @inheritdoc IOracle
43     function name(bytes calldata) public view override returns (string memory) {
44         return "Proxy Oracle";
45     }
46 
47     /// @inheritdoc IOracle
48     function symbol(bytes calldata) public view override returns (string memory) {
49         return "Proxy";
50     }
51 }
