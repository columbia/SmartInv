1 // compiled using solidity 0.7.4
2 
3 pragma solidity 0.7.4;
4 
5 contract DIAOracleV2 {
6     mapping (string => uint256) public values;
7     address oracleUpdater;
8     
9     event OracleUpdate(string key, uint128 value, uint128 timestamp);
10     event UpdaterAddressChange(address newUpdater);
11     
12     constructor() {
13         oracleUpdater = msg.sender;
14     }
15     
16     function setValue(string memory key, uint128 value, uint128 timestamp) public {
17         require(msg.sender == oracleUpdater);
18         uint256 cValue = (((uint256)(value)) << 128) + timestamp;
19         values[key] = cValue;
20         emit OracleUpdate(key, value, timestamp);
21     }
22     
23     function getValue(string memory key) external view returns (uint128, uint128) {
24         uint256 cValue = values[key];
25         uint128 timestamp = (uint128)(cValue % 2**128);
26         uint128 value = (uint128)(cValue >> 128);
27         return (value, timestamp);
28     }
29     
30     function updateOracleUpdaterAddress(address newOracleUpdaterAddress) public {
31         require(msg.sender == oracleUpdater);
32         oracleUpdater = newOracleUpdaterAddress;
33         emit UpdaterAddressChange(newOracleUpdaterAddress);
34     }
35 }