1 pragma solidity ^0.4.24;
2 
3 contract Metadata {
4     mapping (address => mapping (address => mapping (string => string))) metadata;
5 
6     function put(address _namespace, string _key, string _value) public {
7         metadata[_namespace][msg.sender][_key] = _value;
8     }
9 
10     function get(address _namespace, address _ownerAddress, string _key) public constant returns (string) {
11         return metadata[_namespace][_ownerAddress][_key];
12     }
13 }