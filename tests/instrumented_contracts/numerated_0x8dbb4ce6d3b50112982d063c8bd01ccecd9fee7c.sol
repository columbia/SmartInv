1 pragma solidity ^0.5.0;
2 
3 
4 contract IOwnable {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnerChanged(address _oldOwner, address _newOwner);
10 
11     function changeOwner(address _newOwner) public;
12     function acceptOwnership() public;
13 }
14 
15 contract IVerificationList is IOwnable {
16 
17     event Accept(address _address);
18     event Reject(address _address);
19     event SendToCheck(address _address);
20     event RemoveFromList(address _address);
21     
22     function isAccepted(address _address) public view returns (bool);
23     function isRejected(address _address) public view returns (bool);
24     function isOnCheck(address _address) public view returns (bool);
25     function isInList(address _address) public view returns (bool);
26     function isNotInList(address _address) public view returns (bool);
27     function isAcceptedOrNotInList(address _address) public view returns (bool);
28     function getState(address _address) public view returns (uint8);
29     
30     function accept(address _address) public;
31     function reject(address _address) public;
32     function toCheck(address _address) public;
33     function remove(address _address) public;
34 }
35 
36 contract Ownable is IOwnable {
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     constructor() public {
44         owner = msg.sender;
45         emit OwnerChanged(address(0), owner);
46     }
47 
48     function changeOwner(address _newOwner) public onlyOwner {
49         newOwner = _newOwner;
50     }
51 
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnerChanged(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 
60 contract VerificationList is IVerificationList, Ownable {
61 
62     enum States { NOT_IN_LIST, ON_CHECK, ACCEPTED, REJECTED }
63 
64     mapping (address => States) private states;
65 
66     modifier inList(address _address) {
67         require(isInList(_address));
68         _;
69     }
70 
71     function isAccepted(address _address) public view returns (bool) {
72         return states[_address] == States.ACCEPTED;
73     }
74 
75     function isRejected(address _address) public view returns (bool) {
76         return states[_address] == States.REJECTED;
77     }
78 
79     function isOnCheck(address _address) public view returns (bool) {
80         return states[_address] == States.ON_CHECK;
81     }
82 
83     function isInList(address _address) public view returns (bool) {
84         return states[_address] != States.NOT_IN_LIST;
85     }
86     
87     function isNotInList(address _address) public view returns (bool) {
88         return states[_address] == States.NOT_IN_LIST;
89     }
90 
91     function isAcceptedOrNotInList(address _address) public view returns (bool) {
92         return states[_address] == States.NOT_IN_LIST || states[_address] == States.ACCEPTED;
93     }
94     
95     function getState(address _address) public view returns (uint8) {
96         return uint8(states[_address]);
97     }
98 
99     function accept(address _address) public onlyOwner inList(_address) {
100         if (isAccepted(_address)) return;
101         states[_address] = States.ACCEPTED;
102         emit Accept(_address);
103     }
104 
105     function reject(address _address) public onlyOwner inList(_address) {
106         if (isRejected(_address)) return;
107         states[_address] = States.REJECTED;
108         emit Reject(_address);
109     }
110 
111     function toCheck(address _address) public onlyOwner {
112         if (isOnCheck(_address)) return;
113         states[_address] = States.ON_CHECK;
114         emit SendToCheck(_address);
115     }
116 
117     function remove(address _address) public onlyOwner {
118         if (isNotInList(_address)) return;
119         states[_address] = States.NOT_IN_LIST;
120         emit RemoveFromList(_address);
121     }
122 }