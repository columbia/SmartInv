1 pragma solidity ^0.4.15;
2 
3 contract Directory {
4     struct Entry {
5         string name;
6         string company;
7         string description;
8         string category;
9         string contact;
10         address ethAddress;
11         uint256 timestamp;
12         bool deprecated;
13     }
14 
15     mapping(address => Entry) public directory;
16     Entry[] public entries;
17 
18     address public owner;
19 
20     function Directory() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     modifier indexMatches(uint256 index, address ethAddress) {
30         require(entries[index].ethAddress == ethAddress);
31         _;
32     }
33 
34     function transferOwner(address _owner) onlyOwner public returns (bool) {
35         owner = _owner;
36         return true;
37     }
38 
39     function addEntry(string name, string company, string description, string category, string contact, address ethAddress) onlyOwner public returns (bool) {
40         require(directory[ethAddress].timestamp == 0);
41         var entry = Entry(name, company, description, category, contact, ethAddress, block.timestamp, false);
42         directory[ethAddress] = entry;
43         entries.push(entry);
44         return true;
45     }
46 
47     function findCurrentIndex(address ethAddress) public constant returns (uint256) {
48         for (uint i = 0; i < entries.length; i++) {
49             if (entries[i].ethAddress == ethAddress) {
50                 return i;
51             }
52         }
53         revert();
54     }
55 
56     function removeEntry(address ethAddress) public returns (bool) {
57         return removeEntryManual(findCurrentIndex(ethAddress), ethAddress);
58     }
59 
60     function removeEntryManual(uint256 index, address ethAddress) onlyOwner indexMatches(index, ethAddress) public returns (bool) {
61         uint256 lastIndex = entries.length - 1;
62         entries[index] = entries[lastIndex];
63         delete entries[lastIndex];
64         delete directory[ethAddress];
65         return true;
66     }
67 
68     function modifyDescription(address ethAddress, string description) public returns (bool) {
69         return modifyDescriptionManual(findCurrentIndex(ethAddress), ethAddress, description);
70     }
71 
72     function modifyDescriptionManual(uint256 index, address ethAddress, string description) onlyOwner indexMatches(index, ethAddress) public returns (bool) {
73         entries[index].description = description;
74         directory[ethAddress].description = description;
75         return true;
76     }
77 
78     function modifyContact(address ethAddress, string contact) public returns (bool) {
79         return modifyDescriptionManual(findCurrentIndex(ethAddress), ethAddress, contact);
80     }
81 
82     function modifyContactManual(uint256 index, address ethAddress, string contact) onlyOwner indexMatches(index, ethAddress) public returns (bool) {
83         entries[index].contact = contact;
84         directory[ethAddress].contact = contact;
85         return true;
86     }
87 
88     function setDeprecated(address ethAddress, bool deprecated) public returns (bool) {
89         return setDeprecatedManual(findCurrentIndex(ethAddress), ethAddress, deprecated);
90     }
91 
92     function setDeprecatedManual(uint256 index, address ethAddress, bool deprecated) onlyOwner indexMatches(index, ethAddress) public returns (bool) {
93         entries[index].deprecated = deprecated;
94         directory[ethAddress].deprecated = deprecated;
95         return true;
96     }
97 
98     function getName(address _address) public constant returns (string) { return directory[_address].name; }
99     function getCompany(address _address) public constant returns (string) { return directory[_address].company; }
100     function getDescription(address _address) public constant returns (string) { return directory[_address].description; }
101     function getCategory(address _address) public constant returns (string) { return directory[_address].category; }
102     function getTimestamp(address _address) public constant returns (uint256) { return directory[_address].timestamp; }
103     function isDeprecated(address _address) public constant returns (bool) { return directory[_address].deprecated; }
104 
105     function getNameHash(address _address) public constant returns (bytes32) { return keccak256(directory[_address].name); }
106     function getCompanyHash(address _address) public constant returns (bytes32) { return keccak256(directory[_address].company); }
107     function getDescriptionHash(address _address) public constant returns (bytes32) { return keccak256(directory[_address].description);}
108     function getCategoryHash(address _address) public constant returns (bytes32) { return keccak256(directory[_address].category); }
109 }