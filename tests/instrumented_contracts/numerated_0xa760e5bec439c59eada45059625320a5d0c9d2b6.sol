1 pragma solidity ^0.4.24;
2 
3 // Almacert v.1.0.8
4 // Universita' degli Studi di Cagliari
5 // http://www.unica.it
6 // @authors:
7 // Flosslab s.r.l. <info@flosslab.com>
8 
9 contract Almacert {
10 
11     uint constant ID_LENGTH = 11;
12     uint constant FCODE_LENGTH = 16;
13     uint constant SESSION_LENGTH = 10;
14 
15     modifier restricted() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier restrictedToManager() {
21         require(msg.sender == manager);
22         _;
23     }
24 
25     struct Student {
26         string fCode;
27         string session;
28         bytes32 hash;
29     }
30 
31     address private manager;
32     address public owner;
33 
34     mapping(string => Student) private student;
35 
36     constructor() public{
37         owner = msg.sender;
38         manager = msg.sender;
39     }
40 
41     function getHashDigest(string _id) view public returns (string, string, bytes32){
42         return (student[_id].fCode, student[_id].session, student[_id].hash);
43     }
44 
45     function addStudent(string _id, string _fCode, string _session, bytes32 _hash) restricted public {
46         require(student[_id].hash == 0x0);
47         student[_id].hash = _hash;
48         student[_id].fCode = _fCode;
49         student[_id].session = _session;
50     }
51 
52     function addStudents(string _ids, string _fCodes, string _sessions, bytes32 [] _hashes, uint _len) restricted public {
53         string  memory id;
54         string  memory fCode;
55         string  memory session;
56         for (uint i = 0; i < _len; i++) {
57             id = sub_id(_ids, i);
58             fCode = sub_fCode(_fCodes, i);
59             session = sub_session(_sessions, i);
60             addStudent(id, fCode, session, _hashes[i]);
61         }
62     }
63 
64     function subset(string _source, uint _pos, uint _LENGTH) pure private returns (string) {
65         bytes memory strBytes = bytes(_source);
66         bytes memory result = new bytes(_LENGTH);
67         for (uint i = (_pos * _LENGTH); i < (_pos * _LENGTH + _LENGTH); i++) {
68             result[i - (_pos * _LENGTH)] = strBytes[i];
69         }
70         return string(result);
71     }
72 
73     function sub_id(string str, uint pos) pure private returns (string) {
74         return subset(str, pos, ID_LENGTH);
75     }
76 
77     function sub_fCode(string str, uint pos) pure private returns (string) {
78         return subset(str, pos, FCODE_LENGTH);
79     }
80 
81     function sub_session(string str, uint pos) pure private returns (string) {
82         return subset(str, pos, SESSION_LENGTH);
83     }
84 
85     function removeStudent(string _id) restricted public {
86         require(student[_id].hash != 0x00);
87         student[_id].hash = 0x00;
88         student[_id].fCode = '';
89         student[_id].session = '';
90     }
91 
92     function changeOwner(address _new_owner) restricted public{
93         owner = _new_owner;
94     }
95 
96     function restoreOwner() restrictedToManager public {
97         owner = manager;
98     }
99 
100 }