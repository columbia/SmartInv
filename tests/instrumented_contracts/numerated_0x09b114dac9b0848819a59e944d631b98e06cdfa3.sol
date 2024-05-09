1 pragma solidity 0.7.4;
2 
3 contract DIADafiOracle {
4     mapping (string => uint256) public values;
5     address oracleUpdater;
6     
7     event OracleUpdate(string key, uint128 value, uint128 timestamp);
8     event UpdaterAddressChange(address newUpdater);
9     
10     constructor() {
11         oracleUpdater = msg.sender;
12     }
13     
14     function setValue(string memory key, uint128 value, uint128 timestamp) public {
15         require(msg.sender == oracleUpdater);
16         uint256 cValue = (((uint256)(value)) << 128) + timestamp;
17         values[key] = cValue;
18         emit OracleUpdate(key, value, timestamp);
19     }
20     
21     function getValue(string memory key) public view returns (uint128, uint128) {
22         uint256 cValue = values[key];
23         uint128 timestamp = (uint128)(cValue % 2**128);
24         uint128 value = (uint128)(cValue >> 128);
25         return (value, timestamp);
26     }
27     
28     function updateOracleUpdaterAddress(address newOracleUpdaterAddress) public {
29         require(msg.sender == oracleUpdater);
30         oracleUpdater = newOracleUpdaterAddress;
31         emit UpdaterAddressChange(newOracleUpdaterAddress);
32     }
33 }