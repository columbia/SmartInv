1 /*
2  * Kryptium Tracker Smart Contract v.1.0.0
3  * Copyright © 2018 Kryptium Team <info@kryptium.io>
4  * Author: Giannis Zarifis <jzarifis@kryptium.io>
5  * 
6  * A registry of betting houses based on the Ethereum blockchain. It keeps track
7  * of users' upvotes/downvotes for specific houses and can be fully autonomous 
8  * or managed.
9  *
10  * This program is free to use according the Terms of Use available at
11  * <https://kryptium.io/terms-of-use/>. You cannot resell it or copy any
12  * part of it or modify it without permission from the Kryptium Team.
13  *
14  * This program is distributed in the hope that it will be useful, but WITHOUT 
15  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
16  * FOR A PARTICULAR PURPOSE. See the Terms and Conditions for more details.
17  */
18 
19 pragma solidity ^0.5.0;
20 
21 /**
22  * SafeMath
23  * Math operations with safety checks that throw on error
24  */
25 contract SafeMath {
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b != 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
51         return div(mul(number, numerator), denominator);
52     }
53 }
54 
55 contract Owned {
56 
57     address payable public owner;
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address payable newOwner) onlyOwner public {
69         require(newOwner != address(0x0));
70         owner = newOwner;
71     }
72 }
73 
74 
75 /*
76  * House smart contract interface
77  */
78 interface HouseContract {
79      function owner() external view returns (address); 
80      function isHouse() external view returns (bool);
81      function isPlayer(address playerAddress) external view returns(bool);
82 }
83 
84 /*
85  * Kryptium Tracker Smart Contract.  
86  */
87 contract Tracker is SafeMath, Owned {
88 
89 
90 
91 
92     enum Action { added, updated}
93 
94     struct House {            
95         uint upVotes;             
96         uint downVotes;
97         bool isActive;
98         address oldAddress;
99         address owner;
100     }
101 
102     struct TrackerData { 
103         string  name;
104         string  creatorName;
105         bool  managed;
106         uint trackerVersion;
107     }    
108 
109 
110     TrackerData public trackerData;
111 
112     // This creates an array with all balances
113     mapping (address => House) public houses;
114 
115     // Player has upvoted a House
116     mapping (address => mapping (address => bool)) public playerUpvoted;
117 
118     // Player has downvoted a House
119     mapping (address => mapping (address => bool)) public playerDownvoted;
120 
121     // Notifies clients that a house was inserted/altered
122     event TrackerChanged(address indexed  newHouseAddress, Action action);
123 
124     // Notifies clients that a new tracker was launched
125     event TrackerCreated();
126 
127     // Notifies clients that the Tracker's name was changed
128     event TrackerNamesUpdated();    
129 
130 
131     /**
132      * Constructor function
133      * Initializes Tracker data
134      */
135     constructor(string memory trackerName, string memory trackerCreatorName, bool trackerIsManaged, uint version) public {
136         trackerData.name = trackerName;
137         trackerData.creatorName = trackerCreatorName;
138         trackerData.managed = trackerIsManaged;
139         trackerData.trackerVersion = version;
140         emit TrackerCreated();
141     }
142 
143      /**
144      * Update Tracker Data function
145      *
146      * Updates trackersstats
147      */
148     function updateTrackerNames(string memory newName, string memory newCreatorName) onlyOwner public {
149         trackerData.name = newName;
150         trackerData.creatorName = newCreatorName;
151         emit TrackerNamesUpdated();
152     }    
153 
154      /**
155      * Add House function
156      *
157      * Adds a new house
158      */
159     function addHouse(address houseAddress) public {
160         require(!trackerData.managed || msg.sender==owner,"Tracker is managed");
161         require(!houses[houseAddress].isActive,"There is a new version of House already registered");    
162         HouseContract houseContract = HouseContract(houseAddress);
163         require(houseContract.isHouse(),"Invalid House");
164         houses[houseAddress].isActive = true;
165         houses[houseAddress].owner = houseContract.owner();
166         emit TrackerChanged(houseAddress,Action.added);
167     }
168 
169     /**
170      * Update House function
171      *
172      * Updates a house 
173      */
174     function updateHouse(address newHouseAddress,address oldHouseAddress) public {
175         require(!trackerData.managed || msg.sender==owner,"Tracker is managed");
176         require(houses[oldHouseAddress].owner==msg.sender || houses[oldHouseAddress].owner==oldHouseAddress,"Caller isn't the owner of old House");
177         require(!houses[newHouseAddress].isActive,"There is a new version of House already registered");  
178         HouseContract houseContract = HouseContract(newHouseAddress);
179         require(houseContract.isHouse(),"Invalid House");
180         houses[oldHouseAddress].isActive = false;
181         houses[newHouseAddress].isActive = true;
182         houses[newHouseAddress].owner = houseContract.owner();
183         houses[newHouseAddress].upVotes = houses[oldHouseAddress].upVotes;
184         houses[newHouseAddress].downVotes = houses[oldHouseAddress].downVotes;
185         houses[newHouseAddress].oldAddress = oldHouseAddress;
186         emit TrackerChanged(newHouseAddress,Action.added);
187         emit TrackerChanged(oldHouseAddress,Action.updated);
188     }
189 
190      /**
191      * Remove House function
192      *
193      * Removes a house
194      */
195     function removeHouse(address houseAddress) public {
196         require(!trackerData.managed || msg.sender==owner,"Tracker is managed");
197         require(houses[houseAddress].owner==msg.sender,"Caller isn't the owner of House");  
198         houses[houseAddress].isActive = false;
199         emit TrackerChanged(houseAddress,Action.updated);
200     }
201 
202      /**
203      * UpVote House function
204      *
205      * UpVotes a house
206      */
207     function upVoteHouse(address houseAddress) public {
208         require(HouseContract(houseAddress).isPlayer(msg.sender),"Caller hasn't placed any bet");
209         require(!playerUpvoted[msg.sender][houseAddress],"Has already Upvoted");
210         playerUpvoted[msg.sender][houseAddress] = true;
211         houses[houseAddress].upVotes += 1;
212         emit TrackerChanged(houseAddress,Action.updated);
213     }
214 
215      /**
216      * DownVote House function
217      *
218      * DownVotes a house
219      */
220     function downVoteHouse(address houseAddress) public {
221         require(HouseContract(houseAddress).isPlayer(msg.sender),"Caller hasn't placed any bet");
222         require(!playerDownvoted[msg.sender][houseAddress],"Has already Downvoted");
223         playerDownvoted[msg.sender][houseAddress] = true;
224         houses[houseAddress].downVotes += 1;
225         emit TrackerChanged(houseAddress,Action.updated);
226     }    
227 
228     /**
229      * Kill function
230      *
231      * Contract Suicide
232      */
233     function kill() onlyOwner public {
234         selfdestruct(owner); 
235     }
236 
237 }