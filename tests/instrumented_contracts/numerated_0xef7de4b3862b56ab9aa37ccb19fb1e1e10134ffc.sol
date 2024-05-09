1 pragma solidity ^0.4.17;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
5 /// and the implementation of "user permissions".
6 contract Ownable {
7     address public owner;
8     address public newOwnerCandidate;
9 
10     event OwnershipRequested(address indexed _by, address indexed _to);
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     /// account.
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /// @dev Reverts if called by any account other than the owner.
20     modifier onlyOwner() {
21         if (msg.sender != owner) {
22             revert();
23         }
24 
25         _;
26     }
27 
28     modifier onlyOwnerCandidate() {
29         if (msg.sender != newOwnerCandidate) {
30             revert();
31         }
32 
33         _;
34     }
35 
36     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
37     /// @param _newOwnerCandidate address The address to transfer ownership to.
38     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
39         require(_newOwnerCandidate != address(0));
40 
41         newOwnerCandidate = _newOwnerCandidate;
42 
43         OwnershipRequested(msg.sender, newOwnerCandidate);
44     }
45 
46     /// @dev Accept ownership transfer. This method needs to be called by the previously proposed owner.
47     function acceptOwnership() external onlyOwnerCandidate {
48         address previousOwner = owner;
49 
50         owner = newOwnerCandidate;
51         newOwnerCandidate = address(0);
52 
53         OwnershipTransferred(previousOwner, owner);
54     }
55 }
56 
57 /// @title EtherWin
58 /// @dev the contract than handles the EtherWin app
59 contract EtherDick is Ownable {
60 
61     event NewBiggestDick(string name, string notes, uint256 size);
62 
63     struct BiggestDick {
64         string name;
65         string notes;
66         uint256 size;
67         uint256 timestamp;
68         address who;
69     }
70 
71     BiggestDick[] private biggestDicks;
72 
73     function EtherDick() public {
74         biggestDicks.push(BiggestDick({
75             name:       'Brian',
76             notes:      'First dick',
77             size:      9,
78             timestamp:  block.timestamp,
79             who:        address(0)
80             }));
81     }
82 
83     /// Makes you have the bigger dick
84     function iHaveABiggerDick(string name, string notes) external payable {
85 
86         uint nameLen = bytes(name).length;
87         uint notesLen = bytes(notes).length;
88 
89         require(msg.sender != address(0));
90         require(nameLen > 2);
91         require(nameLen <= 64);
92         require(notesLen <= 140);
93         require(msg.value > biggestDicks[biggestDicks.length - 1].size);
94 
95         BiggestDick memory bd = BiggestDick({
96             name:       name,
97             notes:      notes,
98             size:       msg.value,
99             timestamp:  block.timestamp,
100             who:        msg.sender
101         });
102 
103         biggestDicks.push(bd);
104 
105         NewBiggestDick(name, notes, msg.value);
106     }
107 
108     // returns how many dicks there have been
109     function howManyDicks() external view
110             returns (uint) {
111 
112         return biggestDicks.length;
113     }
114 
115     // returns who has the biggest dick
116     function whoHasTheBiggestDick() external view
117             returns (string name, string notes, uint256 size, uint256 timestamp, address who) {
118 
119         BiggestDick storage bd = biggestDicks[biggestDicks.length - 1];
120         return (bd.name, bd.notes, bd.size, bd.timestamp, bd.who);
121     }
122 
123     // returns the biggest dick at the given index
124     function whoHadTheBiggestDick(uint position) external view
125             returns (string name, string notes, uint256 size, uint256 timestamp, address who) {
126 
127         BiggestDick storage bd = biggestDicks[position];
128         return (bd.name, bd.notes, bd.size, bd.timestamp, bd.who);
129     }
130 
131     // fail safe for balance transfer
132     function transferBalance(address to, uint256 amount) external onlyOwner {
133         to.transfer(amount);
134     }
135 
136 }