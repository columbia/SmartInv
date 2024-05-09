1 pragma solidity ^0.5.9;
2 
3 contract Registry {
4     struct ContractVersion {
5         string name;
6         address contractAddress;
7     }
8 
9     modifier onlyOwner {
10         require(
11             msg.sender == owner,
12             "Only the contract owner is allowed to use this function."
13         );
14         _;
15     }
16 
17     address owner;
18 
19     ContractVersion[] versions;
20 
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25     function addVersion(string calldata versionName, address contractAddress)
26         external
27         onlyOwner
28     {
29         ContractVersion memory newVersion = ContractVersion(
30             versionName,
31             contractAddress
32         );
33         versions.push(newVersion);
34     }
35 
36     function getNumberOfVersions() public view returns (uint size) {
37         return versions.length;
38     }
39 
40     function getVersion(uint i)
41         public
42         view
43         returns (string memory versionName, address contractAddress)
44     {
45         require(i >= 0 && i < versions.length, "Index is out of bounds");
46         ContractVersion memory version = versions[i];
47         return (version.name, version.contractAddress);
48     }
49 
50 }