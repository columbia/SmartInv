1 pragma solidity 0.4.18;
2 
3 // This contract provides the functions necessary to record ("push") & retrieve
4 // public funding data to the Ethereum blockchain for the National Research
5 // Council of Canada
6 
7 contract DisclosureManager {
8 
9 	address public owner;
10 
11 	struct Disclosure {
12 		bytes32 organization;
13 		bytes32 recipient;
14 		bytes32 location;
15 		bytes16 amount;
16 		bytes1 fundingType;
17 		bytes16 date;
18 		bytes32 purpose;
19 		bytes32 comment;
20 		uint amended;    // if zero not amended, otherwise points to the rowNumber of the new record
21 	}
22 
23 	Disclosure[] public disclosureList;
24 
25 	event disclosureAdded(
26     uint rowNumber,
27     bytes32 organization,
28     bytes32 recipient,
29     bytes32 location,
30     bytes16 amount,
31     bytes1 fundingType,
32     bytes16 date,
33     bytes32 purpose,
34     bytes32 comment);
35 
36 	function DisclosureManager() public {
37 		owner = msg.sender;
38 	}
39 
40 	// Make sure the caller of the contract is the owner
41 	// modifier isOwner() { if (msg.sender != owner) throw; _ ;}   // old way
42 	modifier isOwner() { if (msg.sender != owner) revert(); _ ;}
43 
44 	// getListCount() returns the number of records in disclosureList (not including the empty 0th record)
45 	function getListCount() public constant returns(uint listCount) {
46   	if (disclosureList.length > 0) {
47 			return disclosureList.length - 1;    // Returns the last rowNumber, reflecting number of records in list
48 		} else {
49 			return 0;    // The case of an uninitialized list
50 		}
51 	}
52 	// Future idea: Another function to return total number of unamended Entries? (ie actual record count)
53 
54 	// Create/push a new entry to our array, returns the new Entry's rowNumber
55 	function newEntry(bytes32 organization,
56 					  bytes32 recipient,
57 					  bytes32 location,
58 					  bytes16 amount,
59 					  bytes1 fundingType,
60 					  bytes16 date,
61 					  bytes32 purpose,
62 					  bytes32 comment) public isOwner() returns(uint rowNumber) {    // should this be public? yes, only needed isOwner()
63 
64 		// Initialize disclosureList here as needed by putting an empty record at row 0
65 		// The first entry starts at 1 and getListCount will be in accordance with the record count
66 		if (disclosureList.length == 0) {
67 			// Push an empty Entry
68 			Disclosure memory nullEntry;
69 			disclosureList.push(nullEntry);
70 		}
71 
72 		Disclosure memory disclosure;
73 
74 		disclosure.organization = organization;
75 		disclosure.recipient = recipient;
76 		disclosure.location = location;
77 		disclosure.amount = amount;
78 		disclosure.fundingType = fundingType;
79 		disclosure.date = date;
80 		disclosure.purpose = purpose;
81 		disclosure.comment = comment;
82 		disclosure.amended = 0;
83 
84 		// Push entry to the array
85 		uint index = disclosureList.push(disclosure);   // adds to end of array (of structs) and returns the new array length
86 		index = index - 1;
87 
88 		// Record the event
89 		disclosureAdded(index, organization, recipient, location, amount, fundingType, date, purpose, comment);
90 
91 		return index;   // returning rowNumber of the record
92 	}
93 
94 	// Amends/changes marks existing entry as amended and takes passed data to
95 	// create a new Entry to which the amended pointer (rowNumber) will point.
96 	function amendEntry(uint rowNumber,
97 						bytes32 organization,
98 						bytes32 recipient,
99 						bytes32 location,
100 						bytes16 amount,
101 						bytes1 fundingType,
102 						bytes16 date,
103 						bytes32 purpose,
104 						bytes32 comment) public isOwner() returns(uint newRowNumber) {    // returns the new rowNumber of amended record
105 
106 		// Make sure passed rowNumber is in bounds
107 		if (rowNumber >= disclosureList.length) { revert(); }
108 		if (rowNumber < 1) { revert(); }
109 		if (disclosureList[rowNumber].amended > 0) { revert(); }    // This record is already amended
110 
111 		// First create new entry
112 		Disclosure memory disclosure;
113 
114 		disclosure.organization = organization;
115 		disclosure.recipient = recipient;
116 		disclosure.location = location;
117 		disclosure.amount = amount;
118 		disclosure.fundingType = fundingType;
119 		disclosure.date = date;
120 		disclosure.purpose = purpose;
121 		disclosure.comment = comment;
122 		disclosure.amended = 0;
123 
124 		// Push entry to the array
125 		uint index = disclosureList.push(disclosure);   // adds to end of array (of structs) and returns the new array length
126 		index = index - 1;
127 
128 		// Now that we have the newRowNumber (index), set the amended field on the old record
129 		disclosureList[rowNumber].amended = index;
130 
131 		// Record the event
132 		disclosureAdded(index, organization, recipient, location, amount, fundingType, date, purpose, comment);   // a different event for amending?
133 
134 		return index;   // returning rowNumber of the new record
135 	}
136 
137 	// Returns row regardless of whether or not it has been amended
138 	function pullRow(uint rowNumber) public constant returns(bytes32, bytes32, bytes32, bytes16, bytes1, bytes16, bytes32, bytes32, uint) {
139 		// First make sure rowNumber passed is within bounds
140 		if (rowNumber >= disclosureList.length) { revert(); }
141 		if (rowNumber < 1) { revert(); }
142 		// Should not use any gas:
143 		Disclosure memory entry = disclosureList[rowNumber];
144 		return (entry.organization, entry.recipient, entry.location, entry.amount, entry.fundingType, entry.date, entry.purpose, entry.comment, entry.amended);
145 	}
146 
147 	// Returns latest entry of record intended to pull
148 	function pullEntry(uint rowNumber) public constant returns(bytes32, bytes32, bytes32, bytes16, bytes1, bytes16, bytes32, bytes32) {
149 		// First make sure rowNumber passed is within bounds
150 		if (rowNumber >= disclosureList.length) { revert(); }
151 		if (rowNumber < 1) { revert(); }
152 		// If this entry has been amended, return amended entry instead (recursively)
153 		// just make sure there are never any cyclical lists (shouldn't be possible using these functions)
154 		if (disclosureList[rowNumber].amended > 0) return pullEntry(disclosureList[rowNumber].amended);
155 		// Should not require any gas to run:
156 		Disclosure memory entry = disclosureList[rowNumber];
157 		return (entry.organization, entry.recipient, entry.location, entry.amount, entry.fundingType, entry.date, entry.purpose, entry.comment);
158 		// No event for pullEntry() since it shouldn't cost gas to call it
159 	}
160 
161 }