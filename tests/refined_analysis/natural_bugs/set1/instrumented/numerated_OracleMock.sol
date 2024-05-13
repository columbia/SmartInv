1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
4 import "../interfaces/IOracle.sol";
5 
6 // WARNING: This oracle is only for testing, please use PeggedOracle for a fixed value oracle
7 contract OracleMock is IOracle {
8     using BoringMath for uint256;
9 
10     uint256 public rate;
11     bool public success;
12 
13     constructor() public {
14         success = true;
15     }
16 
17     function set(uint256 rate_) public {
18         // The rate can be updated.
19         rate = rate_;
20     }
21 
22     function setSuccess(bool val) public {
23         success = val;
24     }
25 
26     function getDataParameter() public pure returns (bytes memory) {
27         return abi.encode("0x0");
28     }
29 
30     // Get the latest exchange rate
31     function get(bytes calldata) public override returns (bool, uint256) {
32         return (success, rate);
33     }
34 
35     // Check the last exchange rate without any state changes
36     function peek(bytes calldata) public view override returns (bool, uint256) {
37         return (success, rate);
38     }
39 
40     function peekSpot(bytes calldata) public view override returns (uint256) {
41         return rate;
42     }
43 
44     function name(bytes calldata) public view override returns (string memory) {
45         return "Test";
46     }
47 
48     function symbol(bytes calldata) public view override returns (string memory) {
49         return "TEST";
50     }
51 }
