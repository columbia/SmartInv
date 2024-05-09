1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 contract DocumentStore is Ownable {
68   string public name;
69   string public version = "2.2.0";
70 
71   /// A mapping of the document hash to the block number that was issued
72   mapping(bytes32 => uint) documentIssued;
73   /// A mapping of the hash of the claim being revoked to the revocation block number
74   mapping(bytes32 => uint) documentRevoked;
75 
76   event DocumentIssued(bytes32 indexed document);
77   event DocumentRevoked(
78     bytes32 indexed document
79   );
80 
81   constructor(
82     string _name
83   ) public
84   {
85     name = _name;
86   }
87 
88   function issue(
89     bytes32 document
90   ) public onlyOwner onlyNotIssued(document)
91   {
92     documentIssued[document] = block.number;
93     emit DocumentIssued(document);
94   }
95 
96   function getIssuedBlock(
97     bytes32 document
98   ) public onlyIssued(document) view returns (uint)
99   {
100     return documentIssued[document];
101   }
102 
103   function isIssued(
104     bytes32 document
105   ) public view returns (bool)
106   {
107     return (documentIssued[document] != 0);
108   }
109 
110   function isIssuedBefore(
111     bytes32 document,
112     uint blockNumber
113   ) public view returns (bool)
114   {
115     return documentIssued[document] != 0 && documentIssued[document] <= blockNumber;
116   }
117 
118   function revoke(
119     bytes32 document
120   ) public onlyOwner onlyNotRevoked(document) returns (bool)
121   {
122     documentRevoked[document] = block.number;
123     emit DocumentRevoked(document);
124   }
125 
126   function isRevoked(
127     bytes32 document
128   ) public view returns (bool)
129   {
130     return documentRevoked[document] != 0;
131   }
132 
133   function isRevokedBefore(
134     bytes32 document,
135     uint blockNumber
136   ) public view returns (bool)
137   {
138     return documentRevoked[document] <= blockNumber && documentRevoked[document] != 0;
139   }
140 
141   modifier onlyIssued(bytes32 document) {
142     require(isIssued(document), "Error: Only issued document hashes can be revoked");
143     _;
144   }
145 
146   modifier onlyNotIssued(bytes32 document) {
147     require(!isIssued(document), "Error: Only hashes that have not been issued can be issued");
148     _;
149   }
150 
151   modifier onlyNotRevoked(bytes32 claim) {
152     require(!isRevoked(claim), "Error: Hash has been revoked previously");
153     _;
154   }
155 }