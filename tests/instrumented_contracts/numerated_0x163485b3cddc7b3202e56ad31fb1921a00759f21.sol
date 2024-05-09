1 /*
2 MIT License
3 
4 Copyright (c) 2018 Nguyen Vu Nhat Minh
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in all
14 copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 SOFTWARE.
23 */
24 
25 pragma solidity ^0.4.20;
26 
27 contract EtherChat {
28     event messageSentEvent(address indexed from, address indexed to, bytes message, bytes32 encryption);
29     event addContactEvent(address indexed from, address indexed to);
30     event acceptContactEvent(address indexed from, address indexed to);
31     event profileUpdateEvent(address indexed from, bytes32 name, bytes32 avatarUrl);
32     event blockContactEvent(address indexed from, address indexed to);
33     event unblockContactEvent(address indexed from, address indexed to);
34     
35     enum RelationshipType {NoRelation, Requested, Connected, Blocked}
36     
37     struct Member {
38         bytes32 publicKeyLeft;
39         bytes32 publicKeyRight;
40         bytes32 name;
41         bytes32 avatarUrl;
42         uint messageStartBlock;
43         bool isMember;
44     }
45     
46     mapping (address => mapping (address => RelationshipType)) relationships;
47     mapping (address => Member) public members;
48     
49     function addContact(address addr) public onlyMember {
50         require(relationships[msg.sender][addr] == RelationshipType.NoRelation);
51         require(relationships[addr][msg.sender] == RelationshipType.NoRelation);
52         
53         relationships[msg.sender][addr] = RelationshipType.Requested;
54         emit addContactEvent(msg.sender, addr);
55     }
56 
57     function acceptContactRequest(address addr) public onlyMember {
58         require(relationships[addr][msg.sender] == RelationshipType.Requested);
59         
60         relationships[msg.sender][addr] = RelationshipType.Connected;
61         relationships[addr][msg.sender] = RelationshipType.Connected;
62 
63         emit acceptContactEvent(msg.sender, addr);
64     }
65     
66     function join(bytes32 publicKeyLeft, bytes32 publicKeyRight) public {
67         require(members[msg.sender].isMember == false);
68         
69         Member memory newMember = Member(publicKeyLeft, publicKeyRight, "", "", 0, true);
70         members[msg.sender] = newMember;
71     }
72     
73     function sendMessage(address to, bytes message, bytes32 encryption) public onlyMember {
74         require(relationships[to][msg.sender] == RelationshipType.Connected);
75 
76         if (members[to].messageStartBlock == 0) {
77             members[to].messageStartBlock = block.number;
78         }
79         
80         emit messageSentEvent(msg.sender, to, message, encryption);
81     }
82     
83     function blockMessagesFrom(address from) public onlyMember {
84         require(relationships[msg.sender][from] == RelationshipType.Connected);
85 
86         relationships[msg.sender][from] = RelationshipType.Blocked;
87         emit blockContactEvent(msg.sender, from);
88     }
89     
90     function unblockMessagesFrom(address from) public onlyMember {
91         require(relationships[msg.sender][from] == RelationshipType.Blocked);
92 
93         relationships[msg.sender][from] = RelationshipType.Connected;
94         emit unblockContactEvent(msg.sender, from);
95     }
96     
97     function updateProfile(bytes32 name, bytes32 avatarUrl) public onlyMember {
98         members[msg.sender].name = name;
99         members[msg.sender].avatarUrl = avatarUrl;
100         emit profileUpdateEvent(msg.sender, name, avatarUrl);
101     }
102     
103     modifier onlyMember() {
104         require(members[msg.sender].isMember == true);
105         _;
106     }
107     
108     function getRelationWith(address a) public view onlyMember returns (RelationshipType) {
109         return relationships[msg.sender][a];
110     }
111 }