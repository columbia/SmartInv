1 pragma solidity 0.4.24;
2 
3 
4 /// @title A contract for enforcing a treasure hunt
5 /// @author John Fitzpatrick
6 /// @author Sam Pullman
7 
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 contract TreasureHunt is Ownable {
44     
45     /// Cost of verifying a single location
46     uint public cost;
47 
48     /// Balance of the treausure hunt reward pool
49     uint public pot;
50 
51     /// @notice Balance of administrator's fee
52     uint public ownersBalance;
53 
54     /// Marks the time of victory
55     uint public timeOfWin;
56 
57     /// Address of the winner
58     address public winner;
59 
60     /// True during the grace period (when the winner can collect the pot)
61     bool public grace;
62 
63     /// List of unique location keys
64     uint[] public locations;
65 
66     /// Container for submitted location info
67     struct KeyLog {
68         /// Location key XOR'd with a user password
69         uint encryptKey;
70         /// Block number of submission
71         uint block;
72     }
73 
74     /// Record of each hunter's progress
75     mapping(address => mapping(uint => KeyLog)) public hunters;
76     
77     /// @notice Triggered when a hunter has won and the hunt is over
78     /// @param winner The address of the victor
79     event WonEvent(address winner);
80 
81     /// @notice Number of locations in the hunt
82     /// @dev Useful for testing, since public arrays don't expose length
83     /// @return length of locations array
84     function locationsLength() public view returns (uint) {
85         return locations.length;
86     }
87 
88     /// @notice Admin function for updating all locations
89     /// @param _locations Array of location keys
90     function setAllLocations(uint[] _locations) onlyOwner public {
91         locations = _locations;
92     }
93 
94     /// @notice Admin function to update the location at `index`
95     /// @dev Throws if index is >= locations.length
96     /// @param index The index of the location to update
97     /// @param _location The new location
98     function setLocation(uint index, uint _location) onlyOwner public {
99         require(index < locations.length);
100         locations[index] = _location;
101     }
102 
103     /// @notice Admin function to add a location
104     /// @param _location The new location
105     function addLocation(uint _location) onlyOwner public {
106         locations.push(_location);
107     }
108 
109     /// @notice Admin function to set the price of submitting a location
110     /// @param _cost The new cost
111     function setCost(uint _cost) onlyOwner public {
112         cost = _cost;
113     }
114 
115     /// @notice Submit a location key XOR'd with a password for later verification
116     /// @notice The message value must be greater than `cost`
117     /// @param encryptKey A location key encrypted with a user password
118     /// @param locationNumber The index of the location
119     function submitLocation(uint encryptKey, uint8 locationNumber) public payable {
120 
121         require(encryptKey != 0);
122         require(locationNumber < locations.length);
123 
124         if (!grace) {
125             require(msg.value >= cost);
126             uint contribution = cost - cost / 10; // avoid integer rounding issues
127             ownersBalance += cost - contribution;
128             pot += contribution;
129         }
130         hunters[msg.sender][locationNumber] = KeyLog(encryptKey, block.number);
131     }
132 
133     /// @notice Sets the message sender as the winner if they have completed the hunt
134     /// @dev Location order should be enforced offline, checks here are to ward against cheaters
135     /// @param decryptKeys Array of user passwords corresponding to original submissions 
136     function checkWin(uint[] decryptKeys) public {
137         require(!grace);
138         require(decryptKeys.length == locations.length);
139 
140         uint lastBlock = 0;
141         bool won = true;
142         for (uint i; i < locations.length; i++) {
143             
144             // Make sure locations were visited in order
145             require(hunters[msg.sender][i].block > lastBlock);
146             lastBlock = hunters[msg.sender][i].block;
147 
148             // Skip removed locations
149             if (locations[i] != 0) {
150                 uint storedVal = uint(keccak256(abi.encodePacked(hunters[msg.sender][i].encryptKey ^ decryptKeys[i])));
151                 
152                 won = won && (locations[i] == storedVal);
153             }
154         }
155 
156         require(won);
157 
158         if (won) {
159             timeOfWin = now;
160             winner = msg.sender;
161             grace = true;
162             emit WonEvent(winner);
163         }
164     }
165 
166     /// @notice Donate the message value to the pot
167     function increasePot() public payable {
168         pot += msg.value;
169     }
170 
171     /// @notice Funds sent to the contract are added to the pot
172     function() public payable {
173         increasePot();
174     }
175     
176     /// @notice Reset the hunt if the grace period is over
177     function resetWinner() public {
178         require(grace);
179         require(now > timeOfWin + 30 days);
180         grace = false;
181         winner = 0;
182         ownersBalance = 0;
183         pot = address(this).balance;
184     }
185 
186     /// @notice Withdrawal function for winner and admin
187     function withdraw() public returns (bool) {
188         uint amount;
189         if (msg.sender == owner) {
190             amount = ownersBalance;
191             ownersBalance = 0;
192         } else if (msg.sender == winner) {
193             amount = pot;
194             pot = 0;
195         }
196         msg.sender.transfer(amount);
197     }
198 
199     /// @notice Admin failsafe for destroying the contract
200     function kill() onlyOwner public {
201         selfdestruct(owner);
202     }
203 
204 }