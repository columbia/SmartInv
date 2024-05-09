1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5 
6     address public owner;
7     address public acceptableAddress;
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     function Ownable() public {
11         owner = msg.sender;
12         acceptableAddress = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyAcceptable() {
21         require(msg.sender == acceptableAddress);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) public onlyOwner {
26         require(newOwner != address(0));
27         OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29     }
30 
31     function transferAcceptable(address newAcceptable) public onlyOwner {
32         require(newAcceptable != address(0));
33         OwnershipTransferred(acceptableAddress, newAcceptable);
34         acceptableAddress = newAcceptable;
35     }
36 
37 }
38 
39 
40 contract EternalStorage is Ownable {
41 
42     function () public payable {
43         require(msg.sender == acceptableAddress || msg.sender == owner);
44     }
45 
46     mapping(bytes32 => uint) public uintStorage;
47 
48     function getUInt(bytes32 record) public view returns (uint) {
49         return uintStorage[record];
50     }
51 
52     function setUInt(bytes32 record, uint value) public onlyAcceptable {
53         uintStorage[record] = value;
54     }
55 
56     mapping(bytes32 => string) public stringStorage;
57 
58     function getString(bytes32 record) public view returns (string) {
59         return stringStorage[record];
60     }
61 
62     function setString(bytes32 record, string value) public onlyAcceptable {
63         stringStorage[record] = value;
64     }
65 
66     mapping(bytes32 => address) public addressStorage;
67 
68     function getAdd(bytes32 record) public view returns (address) {
69         return addressStorage[record];
70     }
71 
72     function setAdd(bytes32 record, address value) public onlyAcceptable {
73         addressStorage[record] = value;
74     }
75 
76     mapping(bytes32 => bytes) public bytesStorage;
77 
78     function getBytes(bytes32 record) public view returns (bytes) {
79         return bytesStorage[record];
80     }
81 
82     function setBytes(bytes32 record, bytes value) public onlyAcceptable {
83         bytesStorage[record] = value;
84     }
85 
86     mapping(bytes32 => bytes32) public bytes32Storage;
87 
88     function getBytes32(bytes32 record) public view returns (bytes32) {
89         return bytes32Storage[record];
90     }
91 
92     function setBytes32(bytes32 record, bytes32 value) public onlyAcceptable {
93         bytes32Storage[record] = value;
94     }
95 
96     mapping(bytes32 => bool) public booleanStorage;
97 
98     function getBool(bytes32 record) public view returns (bool) {
99         return booleanStorage[record];
100     }
101 
102     function setBool(bytes32 record, bool value) public  onlyAcceptable {
103         booleanStorage[record] = value;
104     }
105 
106     mapping(bytes32 => int) public intStorage;
107 
108     function getInt(bytes32 record) public view returns (int) {
109         return intStorage[record];
110     }
111 
112     function setInt(bytes32 record, int value) public onlyAcceptable {
113         intStorage[record] = value;
114     }
115 
116     function getBalance() public constant returns (uint) {
117         return this.balance;
118     }
119 
120     function withdraw(address beneficiary) public onlyAcceptable {
121         uint balance = getUInt(keccak256(beneficiary, "balance"));
122         setUInt(keccak256(beneficiary, "balance"), 0);
123         beneficiary.transfer(balance);
124     }
125 }