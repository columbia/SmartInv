1 /*
2 
3   Copyright 2017 Cofound.it.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity ^0.4.13;
19 
20 contract Owned {
21     address public owner;
22     address public newOwner;
23 
24     function Owned() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         assert(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address _newOwner) public onlyOwner {
34         require(_newOwner != owner);
35         newOwner = _newOwner;
36     }
37 
38     function acceptOwnership() public {
39         require(msg.sender == newOwner);
40         OwnerUpdate(owner, newOwner);
41         owner = newOwner;
42         newOwner = 0x0;
43     }
44 
45     event OwnerUpdate(address _prevOwner, address _newOwner);
46 }
47 
48 contract PriorityPassContract is Owned {
49 
50     struct Account {
51     bool active;
52     uint level;
53     uint limit;
54     bool wasActive;
55     }
56 
57     uint public accountslength;
58     mapping (uint => address) public accountIds;
59     mapping (address => Account) public accounts;
60 
61     //
62     // constructor
63     //
64     function PriorityPassContract() public { }
65 
66     //
67     // @owner creates data for particular account
68     // @param _accountAddress address for which we are setting the data
69     // @param _level integer number that presents loyalty level
70     // @param _limit integer number that presents limit within contribution can be made
71     //
72     function addNewAccount(address _accountAddress, uint _level, uint _limit) onlyOwner public {
73         require(!accounts[_accountAddress].active);
74 
75         accounts[_accountAddress].active = true;
76         accounts[_accountAddress].level = _level;
77         accounts[_accountAddress].limit = _limit;
78 
79         if (!accounts[_accountAddress].wasActive) {
80             accounts[_accountAddress].wasActive = true;
81             accountIds[accountslength] = _accountAddress;
82             accountslength++;
83         }
84     }
85 
86     //
87     // @owner updates data for particular account
88     // @param _accountAddress address for which we are setting the data
89     // @param _level integer number that presents loyalty level
90     // @param _limit integer number that presents limit within contribution can be made
91     //
92     function setAccountData(address _accountAddress, uint _level, uint _limit) onlyOwner public {
93         require(accounts[_accountAddress].active);
94 
95         accounts[_accountAddress].level = _level;
96         accounts[_accountAddress].limit = _limit;
97     }
98 
99     //
100     // @owner updates activity for particular account
101     // @param _accountAddress address for which we are setting the data
102     // @param _level bool value that presents activity level
103     //
104     function setActivity(address _accountAddress, bool _activity) onlyOwner public {
105         accounts[_accountAddress].active = _activity;
106     }
107 
108     //
109     // @owner adds data for list of account
110     // @param _accountAddresses array of accounts
111     // @param _levels array of integer numbers corresponding to addresses order
112     // @param _limits array of integer numbers corresponding to addresses order
113     //
114     function addOrUpdateAccounts(address[] _accountAddresses, uint[] _levels, uint[] _limits) onlyOwner public {
115         require(_accountAddresses.length == _levels.length && _accountAddresses.length == _limits.length);
116 
117         for (uint cnt = 0; cnt < _accountAddresses.length; cnt++) {
118 
119             accounts[_accountAddresses[cnt]].active = true;
120             accounts[_accountAddresses[cnt]].level = _levels[cnt];
121             accounts[_accountAddresses[cnt]].limit = _limits[cnt];
122 
123             if (!accounts[_accountAddresses[cnt]].wasActive) {
124                 accounts[_accountAddresses[cnt]].wasActive = true;
125                 accountIds[accountslength] = _accountAddresses[cnt];
126                 accountslength++;
127             }
128         }
129     }
130 
131     //
132     // @public asks about account loyalty level for the account
133     // @param _accountAddress address to get data for
134     // @returns level for the account
135     //
136     function getAccountLevel(address _accountAddress) public constant returns (uint) {
137         return accounts[_accountAddress].level;
138     }
139 
140     //
141     // @public asks about account limit of contribution for the account
142     // @param _accountAddress address to get data for
143     //
144     function getAccountLimit(address _accountAddress) public constant returns (uint) {
145         return accounts[_accountAddress].limit;
146     }
147 
148     //
149     // @public asks about account being active or not
150     // @param _accountAddress address to get data for
151     //
152     function getAccountActivity(address _accountAddress) public constant returns (bool) {
153         return accounts[_accountAddress].active;
154     }
155 
156     //
157     // @public asks about data of an account
158     // @param _accountAddress address to get data for
159     //
160     function getAccountData(address _accountAddress) public constant returns (uint, uint, bool) {
161         return (accounts[_accountAddress].level, accounts[_accountAddress].limit, accounts[_accountAddress].active);
162     }
163 }