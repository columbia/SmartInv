1 pragma solidity ^0.4.0;
2 
3 
4 contract Registrar {
5     address public owner;
6 
7     function Registrar() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyowner { if (msg.sender != owner) throw; _; }
12 
13     function transferOwner(address newOwner) public onlyowner {
14         owner = newOwner;
15     }
16 
17     Registrar public parent;
18 
19     function setParent(address parentAddress) public onlyowner {
20         parent = Registrar(parentAddress);
21     }
22 
23     mapping (bytes32 => bytes32) records;
24     mapping (bytes32 => string) stringRecords;
25     mapping (bytes32 => bool) recordExists;
26 
27 
28     function set(string key, bytes32 value) public onlyowner {
29         // Compute the fixed length key
30         bytes32 _key = sha3(key);
31 
32         // Set the value
33         records[_key] = value;
34         recordExists[_key] = true;
35     }
36 
37     function get(string key) constant returns (bytes32) {
38         // Compute the fixed length key
39         bytes32 _key = sha3(key);
40 
41         if (!recordExists[_key]) {
42             if (address(parent) == 0x0) {
43                 // Do return unset keys
44                 throw;
45             } else {
46                 // Delegate to the parent.
47                 return parent.get(key);
48             }
49         }
50 
51         return records[_key];
52     }
53 
54     function exists(string key) constant returns (bool) {
55         // Compute the fixed length key
56         bytes32 _key = sha3(key);
57 
58         return recordExists[_key];
59     }
60 
61     function setAddress(string key, address value) public onlyowner {
62         set(key, bytes32(value));
63     }
64 
65     function getAddress(string key) constant returns (address) {
66         return address(get(key));
67     }
68 
69     function setUInt(string key, uint value) public onlyowner {
70         set(key, bytes32(value));
71     }
72 
73     function getUInt(string key) constant returns (uint) {
74         return uint(get(key));
75     }
76 
77     function setInt(string key, int value) public onlyowner {
78         set(key, bytes32(value));
79     }
80 
81     function getInt(string key) constant returns (int) {
82         return int(get(key));
83     }
84 
85     function setBool(string key, bool value) public onlyowner {
86         if (value) {
87             set(key, bytes32(0x1));
88         } else {
89             set(key, bytes32(0x0));
90         }
91     }
92 
93     function getBool(string key) constant returns (bool) {
94         return get(key) != bytes32(0x0);
95     }
96 
97     function setString(string key, string value) public onlyowner {
98         bytes32 valueHash = sha3(value);
99         set(key, valueHash);
100         stringRecords[valueHash] = value;
101     }
102 
103     function getString(string key) public returns (string) {
104         bytes32 valueHash = get(key);
105         return stringRecords[valueHash];
106     }
107 }