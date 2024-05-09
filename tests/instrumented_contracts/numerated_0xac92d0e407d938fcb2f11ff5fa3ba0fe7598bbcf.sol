1 pragma solidity ^0.4.24;
2 
3 interface ErrorThrower {
4     event Error(string func, string message);
5 }
6 
7 
8 contract Ownable is ErrorThrower {
9     address public owner;
10 
11     event OwnershipRenounced(address indexed previousOwner);
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17 
18     constructor() public {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner(string _funcName) {
23         if(msg.sender != owner){
24             emit Error(_funcName,"Operation can only be performed by contract owner");
25             return;
26         }
27         _;
28     }
29 
30 
31     function renounceOwnership() public onlyOwner("renounceOwnership") {
32         emit OwnershipRenounced(owner);
33         owner = address(0);
34     }
35 
36 
37     function transferOwnership(address _newOwner) public onlyOwner("transferOwnership") {
38         _transferOwnership(_newOwner);
39     }
40 
41     /**
42     *  Transfers control of the contract to a newOwner.
43     * @param _newOwner The address to transfer ownership to.
44     */
45     function _transferOwnership(address _newOwner) internal {
46         if(_newOwner == address(0)){
47             emit Error("transferOwnership","New owner's address needs to be different than 0x0");
48             return;
49         }
50 
51         emit OwnershipTransferred(owner, _newOwner);
52         owner = _newOwner;
53     }
54 }
55 
56 
57 /**
58 @title AddressProxy contract
59 @author App Store Foundation
60  This contract works as part of a set of mechanisms in order to maintain tracking of the latest
61 version's contracts deployed to the network.
62  */
63 
64 contract AddressProxy is Ownable {
65 
66     struct ContractAddress {
67         bytes32 id;
68         string name;
69         address at;
70         uint createdTime;
71         uint updatedTime;
72     }
73 
74     mapping(bytes32 => ContractAddress) private contractsAddress;
75     bytes32[] public availableIds;
76 
77     event AddressCreated(bytes32 id, string name, address at, uint createdTime, uint updatedTime);
78     event AddressUpdated(bytes32 id, string name, address at, uint createdTime, uint updatedTime);
79 
80     function AddressProxy() public {
81     }
82 
83 
84     /**
85     @notice Get all avaliable ids registered on the contract
86      Just shows the list of ids registerd on the contract
87     @return { "IdList" : "List of registered ids" }
88      */
89     function getAvailableIds() public view returns (bytes32[] IdList) {
90         return availableIds;
91     }
92 
93     /**
94     @notice  Adds or updates an address
95      Used when a new address needs to be updated to a currently registered id or to a new id.
96     @param name Name of the contract
97     @param newAddress Address of the contract
98     */
99     function addAddress(string name, address newAddress) public onlyOwner("addAddress") {
100         bytes32 contAddId = stringToBytes32(name);
101 
102         uint nowInMilliseconds = now * 1000;
103 
104         if (contractsAddress[contAddId].id == 0x0) {
105             ContractAddress memory newContractAddress;
106             newContractAddress.id = contAddId;
107             newContractAddress.name = name;
108             newContractAddress.at = newAddress;
109             newContractAddress.createdTime = nowInMilliseconds;
110             newContractAddress.updatedTime = nowInMilliseconds;
111             availableIds.push(contAddId);
112             contractsAddress[contAddId] = newContractAddress;
113 
114             emit AddressCreated(newContractAddress.id, newContractAddress.name, newContractAddress.at, newContractAddress.createdTime, newContractAddress.updatedTime);
115         } else {
116             ContractAddress storage contAdd = contractsAddress[contAddId];
117             contAdd.at = newAddress;
118             contAdd.updatedTime = nowInMilliseconds;
119 
120             emit AddressUpdated(contAdd.id, contAdd.name, contAdd.at, contAdd.createdTime, contAdd.updatedTime);
121         }
122     }
123 
124     /**
125     @notice Get the contract name associated to a certain id
126     @param id Id of the registry
127     @return { 'name' : 'Name of the contract associated to the given id' }
128      */
129     function getContractNameById(bytes32 id) public view returns(string name) {
130         return contractsAddress[id].name;
131     }
132 
133 
134     /**
135     @notice Get the contract address associated to a certain id
136     @param id Id of the registry
137     @return { 'contractAddr' : 'Address of the contract associated to the given id' }
138      */
139     function getContractAddressById(bytes32 id) public view returns(address contractAddr) {
140         return contractsAddress[id].at;
141     }
142 
143     /**
144     @notice Get the specific date on which the contract address was firstly registered
145     to a certain id
146     @param id Id of the registry
147     @return { 'time' : 'Time in miliseconds of the first time the given id was registered' }
148      */
149     function getContractCreatedTimeById(bytes32 id) public view returns(uint time) {
150         return contractsAddress[id].createdTime;
151     }
152 
153     /**
154     @notice Get the specific date on which the contract address was lastly updated to a certain id
155     @param id Id of the registry
156     @return { 'time' : 'Time in miliseconds of the last time the given id was updated' }
157      */
158     function getContractUpdatedTimeById(bytes32 id) public view returns(uint time) {
159         return contractsAddress[id].updatedTime;
160     }
161 
162     /**
163     @notice Converts a string type variable into a byte32 type variable
164      This function is internal and uses inline assembly instructions.
165     @param source string to be converted to a byte32 type
166     @return { 'result' : 'Initial string content converted to a byte32 type' }
167      */
168     function stringToBytes32(string source) internal pure returns (bytes32 result) {
169         bytes memory tempEmptyStringTest = bytes(source);
170         if (tempEmptyStringTest.length == 0) {
171             return 0x0;
172         }
173 
174         assembly {
175             result := mload(add(source, 32))
176         }
177     }
178 }