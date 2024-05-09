1 pragma solidity ^0.4.19;
2 
3 
4 contract AddressProxy {
5 
6     struct ContractAddress {
7         bytes32 id;
8         string name;
9         address at;
10         uint createdTime;
11         uint updatedTime;
12     }
13 
14     address public owner;
15     mapping(bytes32 => ContractAddress) private contractsAddress;
16     bytes32[] public availableIds;
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event AddressCreated(bytes32 id, string name, address at, uint createdTime, uint updatedTime);
24     event AddressUpdated(bytes32 id, string name, address at, uint createdTime, uint updatedTime);
25 
26     function AddressProxy() public {
27         owner = msg.sender;
28     }
29 
30     function getAvailableIds() public view returns (bytes32[]) {
31         return availableIds;
32     }
33 
34     //  Adds or updates an address
35     //  @params {string} name - the name of the contract Address
36     //  @params {address} newAddress
37     function addAddress(string name, address newAddress) public onlyOwner {
38         bytes32 contAddId = stringToBytes32(name);
39 
40         uint nowInMilliseconds = now * 1000;
41 
42         if (contractsAddress[contAddId].id == 0x0) {
43             ContractAddress memory newContractAddress;
44             newContractAddress.id = contAddId;
45             newContractAddress.name = name;
46             newContractAddress.at = newAddress;
47             newContractAddress.createdTime = nowInMilliseconds;
48             newContractAddress.updatedTime = nowInMilliseconds;
49             availableIds.push(contAddId);
50             contractsAddress[contAddId] = newContractAddress;
51 
52             emit AddressCreated(newContractAddress.id, newContractAddress.name, newContractAddress.at, newContractAddress.createdTime, newContractAddress.updatedTime);
53         } else {
54             ContractAddress storage contAdd = contractsAddress[contAddId];
55             contAdd.at = newAddress;
56             contAdd.updatedTime = nowInMilliseconds;
57 
58             emit AddressUpdated(contAdd.id, contAdd.name, contAdd.at, contAdd.createdTime, contAdd.updatedTime);
59         }
60     }
61 
62     function getContractNameById(bytes32 id) public view returns(string) {
63         return contractsAddress[id].name;
64     }
65 
66     function getContractAddressById(bytes32 id) public view returns(address) {
67         return contractsAddress[id].at;
68     }
69 
70     function getContractCreatedTimeById(bytes32 id) public view returns(uint) {
71         return contractsAddress[id].createdTime;
72     }
73 
74     function getContractUpdatedTimeById(bytes32 id) public view returns(uint) {
75         return contractsAddress[id].updatedTime;
76     }
77 
78     //  @params {string} source
79     //  @return {bytes32}
80     function stringToBytes32(string source) internal pure returns (bytes32 result) {
81         bytes memory tempEmptyStringTest = bytes(source);
82         if (tempEmptyStringTest.length == 0) {
83             return 0x0;
84         }
85 
86         assembly {
87             result := mload(add(source, 32))
88         }
89     }
90 }