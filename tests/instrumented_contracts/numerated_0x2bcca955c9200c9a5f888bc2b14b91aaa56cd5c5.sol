1 /*
2 
3 Etherandom v1.0 [API]
4 
5 Copyright (c) 2016, Etherandom [etherandom.com]
6 All rights reserved.
7 
8 Redistribution and use in source and binary forms, with or without
9 modification, are permitted provided that the following conditions are met:
10     * Redistributions of source code must retain the above copyright
11       notice, this list of conditions and the following disclaimer.
12     * Redistributions in binary form must reproduce the above copyright
13       notice, this list of conditions and the following disclaimer in the
14       documentation and/or other materials provided with the distribution.
15     * Neither the name of the <organization> nor the
16       names of its contributors may be used to endorse or promote products
17       derived from this software without specific prior written permission.
18 
19 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
20 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
21 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
22 DISCLAIMED. IN NO EVENT SHALL ETHERANDOM BE LIABLE FOR ANY
23 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
24 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
25 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
26 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
27 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
28 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
29 
30 */
31 
32 contract EtherandomI {
33   address public addr;
34   function seed() returns (bytes32 _id);
35   function seedWithGasLimit(uint _gasLimit) returns (bytes32 _id);
36   function exec(bytes32 _serverSeedHash, bytes32 _clientSeed, uint _cardinality) returns (bytes32 _id);
37   function execWithGasLimit(bytes32 _serverSeedHash, bytes32 _clientSeed, uint _cardinality, uint _gasLimit) returns (bytes32 _id);
38   function getSeedCost(uint _gasLimit) constant returns (uint _cost);
39   function getExecCost(uint _gasLimit) constant returns (uint _cost);
40   function getMinimumGasLimit() constant returns (uint _minimumGasLimit);
41 }
42 
43 contract EtherandomProxyI {
44   function getContractAddress() constant returns (address _addr); 
45   function getCallbackAddress() constant returns (address _addr); 
46 }
47 
48 contract EtherandomizedI {
49   function onEtherandomSeed(bytes32 _id, bytes32 serverSeedHash);
50   function onEtherandomExec(bytes32 _id, bytes32 serverSeed, uint randomNumber);
51 }
52 
53 contract etherandomized {
54   EtherandomProxyI EAR;
55   EtherandomI etherandom;
56 
57   modifier etherandomAPI {
58     address addr = EAR.getContractAddress();
59     if (addr == 0) {
60       etherandomSetNetwork();
61       addr = EAR.getContractAddress();
62     }
63     etherandom = EtherandomI(addr);
64     _
65   }
66 
67   function etherandomSetNetwork() internal returns (bool) {
68     if (getCodeSize(0x5be0372559e0275c0c415ab48eb0e211bc2f52a8)>0){
69       EAR = EtherandomProxyI(0x5be0372559e0275c0c415ab48eb0e211bc2f52a8);
70       return true;
71     }
72     if (getCodeSize(0xf6d9979499491c1c0c9ef518860f4476c1cd551a)>0){
73       EAR = EtherandomProxyI(0xf6d9979499491c1c0c9ef518860f4476c1cd551a);
74       return true;
75     }
76     return false;
77   }
78 
79   function getCodeSize(address _addr) constant internal returns (uint _size) {
80     assembly { _size := extcodesize(_addr) }
81   }
82 
83   function etherandomSeed() etherandomAPI internal returns (bytes32 _id) {
84     uint cost = etherandom.getSeedCost(etherandom.getMinimumGasLimit());
85     return etherandom.seed.value(cost)();
86   }
87 
88   function etherandomSeedWithGasLimit(uint gasLimit) etherandomAPI internal returns (bytes32 _id) {
89     uint cost = etherandom.getSeedCost(gasLimit);
90     return etherandom.seedWithGasLimit.value(cost)(gasLimit);
91   }
92 
93   function etherandomExec(bytes32 serverSeedHash, bytes32 clientSeed, uint cardinality) etherandomAPI internal returns (bytes32 _id) {
94     uint cost = etherandom.getExecCost(etherandom.getMinimumGasLimit());
95     return etherandom.exec.value(cost)(serverSeedHash, clientSeed, cardinality);
96   }
97 
98   function etherandomExecWithGasLimit(bytes32 serverSeedHash, bytes32 clientSeed, uint cardinality, uint gasLimit) etherandomAPI internal returns (bytes32 _id) {
99     uint cost = etherandom.getExecCost(gasLimit);
100     return etherandom.execWithGasLimit.value(cost)(serverSeedHash, clientSeed, cardinality, gasLimit);
101   }
102   
103   function etherandomCallbackAddress() internal returns (address _addr) {
104     return EAR.getCallbackAddress();
105   }
106 
107   function etherandomVerify(bytes32 serverSeedHash, bytes32 serverSeed, bytes32 clientSeed, uint cardinality, uint randomNumber) internal returns (bool _verified) {
108     if (sha3(serverSeed) != serverSeedHash) return false;
109     uint num = addmod(uint(serverSeed), uint(clientSeed), cardinality);
110     return num == randomNumber;
111   }
112 
113   function() {
114     throw;
115   }
116 }
117 
118 
119 contract Dice is etherandomized {
120   struct Roll {
121     address bettor;
122     bytes32 clientSeed;
123   }
124 
125   address owner;
126   uint pendingAmount;
127   mapping (bytes32 => Roll) pendingSeed;
128   mapping (bytes32 => Roll) pendingExec;
129   mapping (bytes32 => bytes32) serverSeedHashes;
130 
131   function Dice() {
132     owner = msg.sender;
133   }
134 
135   function getAvailable() returns (uint _available) {
136     return this.balance - pendingAmount;
137   }
138 
139   function roll() {
140     rollWithSeed("");
141   }
142 
143   function rollWithSeed(bytes32 clientSeed) {
144     if ( (msg.value != 1) || (getAvailable() < 2)) throw;
145     bytes32 _id = etherandomSeed();
146     pendingSeed[_id] = Roll({bettor: msg.sender, clientSeed: clientSeed});
147     pendingAmount = pendingAmount + 2;
148   }
149 
150   function onEtherandomSeed(bytes32 _id, bytes32 serverSeedHash) {
151     if (msg.sender != etherandomCallbackAddress()) throw;
152     Roll roll = pendingSeed[_id];
153     bytes32 _execID = etherandomExec(serverSeedHash, roll.clientSeed, 100);
154     pendingExec[_execID] = roll;
155     serverSeedHashes[_execID] = serverSeedHash;
156     delete pendingSeed[_id];
157   }
158 
159   function onEtherandomExec(bytes32 _id, bytes32 serverSeed, uint randomNumber) {
160     if (msg.sender != etherandomCallbackAddress()) throw;
161     Roll roll = pendingExec[_id];
162     bytes32 serverSeedHash = serverSeedHashes[_id];
163 
164     pendingAmount = pendingAmount - 2;
165 
166     if (etherandomVerify(serverSeedHash, serverSeed, roll.clientSeed, 100, randomNumber)) {
167       if (randomNumber < 50) roll.bettor.send(2);
168     } else {
169       roll.bettor.send(1);
170     }
171     
172     delete serverSeedHashes[_id];
173     delete pendingExec[_id];
174   }
175 }