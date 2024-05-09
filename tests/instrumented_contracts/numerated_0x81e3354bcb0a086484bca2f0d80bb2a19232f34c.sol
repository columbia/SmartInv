1 pragma solidity ^0.4.0;
2 
3 contract RegistryContract {
4     
5     struct record {
6        uint timestamp;
7        string info;
8     }
9     
10     mapping (uint => record) public records;
11    
12     address owner;
13    
14    
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19    
20    
21    
22     function RegistryContract() {
23        owner = msg.sender;
24     }
25     
26     function transferOwnership(address newOwner) public onlyOwner {
27         owner = newOwner;
28     }
29     
30     function put(uint _uuid, string _info) public onlyOwner {
31         require(records[_uuid].timestamp == 0);
32         records[_uuid].timestamp = now;
33         records[_uuid].info = _info;
34     }
35     
36     function getInfo(uint _uuid) public returns(string) {
37         return records[_uuid].info;
38     }
39     
40     function getTimestamp(uint _uuid) public returns(uint) {
41         return records[_uuid].timestamp;
42     }
43     
44 }