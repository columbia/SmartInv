1 pragma solidity ^0.4.24;
2 
3 contract Alias {
4     mapping(string => address) aliasNameMapping;
5     mapping(string => bool) aliasNameUsedMapping;
6     mapping(address => string) aliasAddressMapping;
7     mapping(address => bool) aliasAddressUsedMapping;
8 
9     constructor() public {
10         setAlias("owner");
11     }
12 
13     function setAlias(string _name) public {
14         require(!aliasNameUsedMapping[_name]);
15         require(!aliasAddressUsedMapping[msg.sender]);
16 
17         aliasNameUsedMapping[_name] = true;
18         aliasAddressUsedMapping[msg.sender] = true;
19         aliasNameMapping[_name] = msg.sender;
20         aliasAddressMapping[msg.sender] = _name;
21     }
22 
23     function getAddress(string _name) public view returns(address) {
24         require(aliasNameUsedMapping[_name]);
25 
26         return aliasNameMapping[_name];
27     }
28 
29     function getAlias(address _address) public view returns(string) {
30         require(aliasAddressUsedMapping[_address]);
31 
32         return aliasAddressMapping[_address];
33     }
34 
35     function resetAlias() public {
36         require(aliasAddressUsedMapping[msg.sender]);
37 
38         string memory name = aliasAddressMapping[msg.sender];
39         aliasNameUsedMapping[name] = false;
40         aliasAddressUsedMapping[msg.sender] = false;
41     }
42 
43     function send(string _name) public payable {
44         require(aliasNameUsedMapping[_name]);
45         require(msg.value > 0);
46 
47         aliasNameMapping[_name].transfer(msg.value);
48     }
49 }