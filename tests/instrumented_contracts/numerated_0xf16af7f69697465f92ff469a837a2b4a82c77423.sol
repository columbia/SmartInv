1 /*
2   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3   Licensed under the Apache License, Version 2.0 (the "License");
4   you may not use this file except in compliance with the License.
5   You may obtain a copy of the License at
6   http://www.apache.org/licenses/LICENSE-2.0
7   Unless required by applicable law or agreed to in writing, software
8   distributed under the License is distributed on an "AS IS" BASIS,
9   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10   See the License for the specific language governing permissions and
11   limitations under the License.
12 */
13 pragma solidity 0.4.19;
14 /// @title Ethereum Address Register Contract
15 /// @dev This contract maintains a name service for addresses and miner.
16 /// @author Kongliang Zhong - <kongliang@loopring.org>,
17 /// @author Daniel Wang - <daniel@loopring.org>,
18 contract NameRegistry {
19     uint public nextId = 0;
20     mapping (uint    => Participant) public participantMap;
21     mapping (address => NameInfo)    public nameInfoMap;
22     mapping (bytes12 => address)     public ownerMap;
23     mapping (address => string)      public nameMap;
24     struct NameInfo {
25         bytes12  name;
26         uint[]   participantIds;
27     }
28     struct Participant {
29         address feeRecipient;
30         address signer;
31         bytes12 name;
32         address owner;
33     }
34     event NameRegistered (
35         string            name,
36         address   indexed owner
37     );
38     event NameUnregistered (
39         string             name,
40         address    indexed owner
41     );
42     event OwnershipTransfered (
43         bytes12            name,
44         address            oldOwner,
45         address            newOwner
46     );
47     event ParticipantRegistered (
48         bytes12           name,
49         address   indexed owner,
50         uint      indexed participantId,
51         address           singer,
52         address           feeRecipient
53     );
54     event ParticipantUnregistered (
55         uint    participantId,
56         address owner
57     );
58     function registerName(string name)
59         external
60     {
61         require(isNameValid(name));
62         bytes12 nameBytes = stringToBytes12(name);
63         require(ownerMap[nameBytes] == 0x0);
64         require(stringToBytes12(nameMap[msg.sender]) == bytes12(0x0));
65         nameInfoMap[msg.sender] = NameInfo(nameBytes, new uint[](0));
66         ownerMap[nameBytes] = msg.sender;
67         nameMap[msg.sender] = name;
68         NameRegistered(name, msg.sender);
69     }
70     function unregisterName(string name)
71         external
72     {
73         NameInfo storage nameInfo = nameInfoMap[msg.sender];
74         uint[] storage participantIds = nameInfo.participantIds;
75         bytes12 nameBytes = stringToBytes12(name);
76         require(nameInfo.name == nameBytes);
77         for (uint i = participantIds.length - 1; i >= 0; i--) {
78             delete participantMap[participantIds[i]];
79         }
80         delete nameInfoMap[msg.sender];
81         delete nameMap[msg.sender];
82         delete ownerMap[nameBytes];
83         NameUnregistered(name, msg.sender);
84     }
85     function transferOwnership(address newOwner)
86         external
87     {
88         require(newOwner != 0x0);
89         require(nameInfoMap[newOwner].name.length == 0);
90         NameInfo storage nameInfo = nameInfoMap[msg.sender];
91         string storage name = nameMap[msg.sender];
92         uint[] memory participantIds = nameInfo.participantIds;
93         for (uint i = 0; i < participantIds.length; i ++) {
94             Participant storage p = participantMap[participantIds[i]];
95             p.owner = newOwner;
96         }
97         delete nameInfoMap[msg.sender];
98         delete nameMap[msg.sender];
99         nameInfoMap[newOwner] = nameInfo;
100         nameMap[newOwner] = name;
101         OwnershipTransfered(nameInfo.name, msg.sender, newOwner);
102     }
103     /* function addParticipant(address feeRecipient) */
104     /*     external */
105     /*     returns (uint) */
106     /* { */
107     /*     return addParticipant(feeRecipient, feeRecipient); */
108     /* } */
109     function addParticipant(
110         address feeRecipient,
111         address singer
112         )
113         external
114         returns (uint)
115     {
116         require(feeRecipient != 0x0 && singer != 0x0);
117         NameInfo storage nameInfo = nameInfoMap[msg.sender];
118         bytes12 name = nameInfo.name;
119         require(name.length > 0);
120         Participant memory participant = Participant(
121             feeRecipient,
122             singer,
123             name,
124             msg.sender
125         );
126         uint participantId = ++nextId;
127         participantMap[participantId] = participant;
128         nameInfo.participantIds.push(participantId);
129         ParticipantRegistered(
130             name,
131             msg.sender,
132             participantId,
133             singer,
134             feeRecipient
135         );
136         return participantId;
137     }
138     function removeParticipant(uint participantId)
139         external
140     {
141         require(msg.sender == participantMap[participantId].owner);
142         NameInfo storage nameInfo = nameInfoMap[msg.sender];
143         uint[] storage participantIds = nameInfo.participantIds;
144         delete participantMap[participantId];
145         uint len = participantIds.length;
146         for (uint i = 0; i < len; i ++) {
147             if (participantId == participantIds[i]) {
148                 participantIds[i] = participantIds[len - 1];
149                 participantIds.length -= 1;
150             }
151         }
152         ParticipantUnregistered(participantId, msg.sender);
153     }
154     function getParticipantById(uint id)
155         external
156         view
157         returns (address feeRecipient, address signer)
158     {
159         Participant storage addressSet = participantMap[id];
160         feeRecipient = addressSet.feeRecipient;
161         signer = addressSet.signer;
162     }
163     function getFeeRecipientById(uint id)
164         external
165         view
166         returns (address feeRecipient)
167     {
168         Participant storage addressSet = participantMap[id];
169         feeRecipient = addressSet.feeRecipient;
170     }
171     function getParticipantIds(string name, uint start, uint count)
172         external
173         view
174         returns (uint[] idList)
175     {
176         bytes12 nameBytes = stringToBytes12(name);
177         address owner = ownerMap[nameBytes];
178         require(owner != 0x0);
179         NameInfo storage nameInfo = nameInfoMap[owner];
180         uint[] storage pIds = nameInfo.participantIds;
181         uint len = pIds.length;
182         if (start >= len) {
183             return;
184         }
185         uint end = start + count;
186         if (end > len) {
187             end = len;
188         }
189         if (start == end) {
190             return;
191         }
192         idList = new uint[](end - start);
193         for (uint i = start; i < end; i ++) {
194             idList[i - start] = pIds[i];
195         }
196     }
197     function getOwner(string name)
198         external
199         view
200         returns (address)
201     {
202         bytes12 nameBytes = stringToBytes12(name);
203         return ownerMap[nameBytes];
204     }
205     function isNameValid(string name)
206         internal
207         pure
208         returns (bool)
209     {
210         bytes memory temp = bytes(name);
211         return temp.length >= 6 && temp.length <= 12;
212     }
213     function stringToBytes12(string str)
214         internal
215         pure
216         returns (bytes12 result)
217     {
218         assembly {
219             result := mload(add(str, 32))
220         }
221     }
222 }