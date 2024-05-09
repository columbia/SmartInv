1 pragma solidity ^0.4.18;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract BlockdeblockContract is Ownable {
46 
47 	struct Product {
48 		uint index;
49 		uint date;
50 		uint uniqueId;
51 		uint design;
52 		uint8 gender;
53 		uint8 productType;
54 		uint8 size;
55 		uint8 color;
56 		string brandGuardPhrase;
57 	}
58 
59 	mapping(uint8 => string) public sizes;
60 	mapping(uint8 => string) public colors;
61 	mapping(uint8 => string) public genders;
62 	mapping(uint8 => string) public productTypes;
63 	mapping(uint => string) public designs;
64 	mapping(uint => Product) public products;
65 
66 	uint public lastIndex;
67 
68 	mapping(uint => uint) public uniqueIds;
69 
70 	event Registration(uint index, uint date, 
71 		uint indexed uniqueId, uint design, uint8 gender, uint8 productType,
72 		uint8 size, uint8 color, string brandGuardPhrase);
73 
74 	function setDesign(uint index, string description) public onlyOwner {
75 		designs[index] = description;
76 	}
77 
78 	function setSize(uint8 index, string size) public onlyOwner {
79 		sizes[index] = size;
80 	}
81 
82 	function setColor(uint8 index, string color) public onlyOwner {
83 		colors[index] = color;
84 	}
85 
86 	function setGender(uint8 index, string gender) public onlyOwner {
87 		genders[index] = gender;
88 	}
89 
90 	function setProductType(uint8 index, string productType) public onlyOwner {
91 		productTypes[index] = productType;
92 	}
93 
94 	function register(uint uniqueId, uint design, uint8 gender, uint8 productType,
95 		uint8 size, uint8 color, string brandGuardPhrase) external onlyOwner {
96 		lastIndex += 1;
97 		require(!uniqueIdExists(uniqueId));
98 		uniqueIds[uniqueId] = lastIndex;
99 		products[lastIndex] = 
100 			Product(lastIndex, now, uniqueId, design, gender, productType, size,
101 				color, brandGuardPhrase);
102 		Registration(lastIndex, now, uniqueId, design, gender, productType, size,
103 			color, brandGuardPhrase);
104 	}
105 
106 	function edit(uint uniqueId, uint design, uint8 gender, uint8 productType,
107 		uint8 size, uint8 color, string brandGuardPhrase) external onlyOwner {
108 		uint index = uniqueIds[uniqueId];
109 		Product storage product = products[index];
110 		if(design != 0) {
111 			product.design = design;
112 		}
113 		if(gender != 0) {
114 			product.gender = gender;
115 		}
116 		if(size != 0) {
117 			product.size = size;
118 		}
119 		if(color != 0) {
120 			product.color = color;
121 		}
122 		if(productType != 0) {
123 			product.productType = productType;
124 		}
125 		if(bytes(brandGuardPhrase).length > 0) {
126 			product.brandGuardPhrase = brandGuardPhrase;
127 		}
128 	}
129 
130 	function uniqueIdExists(uint uniqueId) internal view returns (bool exists) {
131 		uint index = uniqueIds[uniqueId];
132 		return index > 0;
133 	}
134 
135 }