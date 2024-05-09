1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract BlockchainId is Ownable {
63 
64     event NewCompany(bytes32 companyId, bytes32 merkleRoot);
65     event ChangeCompany(bytes32 companyId, bytes32 merkleRoot);
66     event DeleteCompany(bytes32 companyId);
67 
68     mapping (bytes32 => bytes32) companyMap;
69 
70     function _createCompany(bytes32 companyId, bytes32 merkleRoot) public onlyOwner() {
71         companyMap[companyId] = merkleRoot;
72         emit NewCompany(companyId, merkleRoot);
73     }
74 
75     function _createCompanies(bytes32[] companyIds, bytes32[] merkleRoots) public onlyOwner() {
76         require(companyIds.length == merkleRoots.length);
77         for (uint i = 0; i < companyIds.length; i++) {
78             _createCompany(companyIds[i], merkleRoots[i]);
79         }
80     }
81 
82     function getCompany(bytes32 companyId) public view returns (bytes32) {
83         return companyMap[companyId];
84     }
85 
86     function _updateCompany(bytes32 companyId, bytes32 merkleRoot) public onlyOwner() {
87         companyMap[companyId] = merkleRoot;
88         emit ChangeCompany(companyId, merkleRoot);
89     }
90 
91     function _updateCompanies(bytes32[] companyIds, bytes32[] merkleRoots) public onlyOwner() {
92         require(companyIds.length == merkleRoots.length);
93         for (uint i = 0; i < companyIds.length; i++) {
94             _updateCompany(companyIds[i], merkleRoots[i]);
95         }
96     }
97 
98     function _deleteCompany(bytes32 companyId) public onlyOwner() {
99         delete companyMap[companyId];
100         emit DeleteCompany(companyId);
101     }
102 }