1 pragma solidity ^0.4.16;
2 
3 /// @author Jordi Baylina
4 /// Auditors: Griff Green & psdev
5 /// @notice Based on http://hudsonjameson.com/ethereummarriage/
6 /// License: GNU-3
7 
8 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
9 ///  later changed
10 contract Owned {
11 
12     /// @dev `owner` is the only address that can call a function with this
13     /// modifier
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     address public owner;
20 
21     /// @notice The Constructor assigns the message sender to be `owner`
22     function Owned() {
23         owner = msg.sender;
24     }
25 
26     address public newOwner;
27 
28     /// @notice `owner` can step down and assign some other address to this role
29     /// @param _newOwner The address of the new owner
30     ///  an unowned neutral vault, however that cannot be undone
31     function changeOwner(address _newOwner) onlyOwner {
32         newOwner = _newOwner;
33     }
34     /// @notice `newOwner` has to accept the ownership before it is transferred
35     ///  Any account or any contract with the ability to call `acceptOwnership`
36     ///  can be used to accept ownership of this contract, including a contract
37     ///  with no other functions
38     function acceptOwnership() {
39         if (msg.sender == newOwner) {
40             owner = newOwner;
41         }
42     }
43 
44     // This is a general safty function that allows the owner to do a lot
45     //  of things in the unlikely event that something goes wrong
46     // _dst is the contract being called making this like a 1/1 multisig
47     function execute(address _dst, uint _value, bytes _data) onlyOwner {
48         _dst.call.value(_value)(_data);
49     }
50 }
51 
52 
53 contract Marriage is Owned
54 {
55     // Marriage data variables
56     string public partner1;
57     string public partner2;
58     uint public marriageDate;
59     string public marriageStatus;
60     string public vows;
61 
62     Event[] public majorEvents;
63     Message[] public messages;
64 
65     struct Event {
66         uint date;
67         string name;
68         string description;
69         string url;
70     }
71 
72     struct Message {
73         uint date;
74         string nameFrom;
75         string text;
76         string url;
77         uint value;
78     }
79 
80     modifier areMarried {
81         require(sha3(marriageStatus) == sha3("Married"));
82         _;
83     }
84 
85     //Set Owner
86     function Marriage(address _owner) {
87         owner = _owner;
88     }
89 
90     function numberOfMajorEvents() constant public returns (uint) {
91         return majorEvents.length;
92     }
93 
94     function numberOfMessages() constant public returns (uint) {
95         return messages.length;
96     }
97 
98     // Create initial marriage contract
99     function createMarriage(
100         string _partner1,
101         string _partner2,
102         string _vows,
103         string url) onlyOwner
104     {
105         require(majorEvents.length == 0);
106         partner1 = _partner1;
107         partner2 = _partner2;
108         marriageDate = now;
109         vows = _vows;
110         marriageStatus = "Married";
111         majorEvents.push(Event(now, "Marriage", vows, url));
112         MajorEvent("Marrigage", vows, url);
113     }
114 
115     // Set the marriage status if it changes
116     function setStatus(string status, string url) onlyOwner
117     {
118         marriageStatus = status;
119         setMajorEvent("Changed Status", status, url);
120     }
121 
122     // Set the IPFS hash of the image of the couple
123     function setMajorEvent(string name, string description, string url) onlyOwner areMarried
124     {
125         majorEvents.push(Event(now, name, description, url));
126         MajorEvent(name, description, url);
127     }
128 
129     function sendMessage(string nameFrom, string text, string url) payable areMarried {
130         if (msg.value > 0) {
131             owner.transfer(this.balance);
132         }
133         messages.push(Message(now, nameFrom, text, url, msg.value));
134         MessageSent(nameFrom, text, url, msg.value);
135     }
136 
137 
138     // Declare event structure
139     event MajorEvent(string name, string description, string url);
140     event MessageSent(string name, string description, string url, uint value);
141 }