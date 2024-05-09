1 pragma solidity ^0.4.18;
2 
3 /*
4  * v1.0
5  * Created by MyEtheroll.com, feb 2018
6  * Feel free to copy and share :)
7  * Donations: 0x7e3dc9f40e7ff9db80c3c7a1847cb95f861b3aef
8 */
9 
10 contract Billboard {
11 
12     uint public cost = 100000000000000; // 0.0001 eth
13     uint16 public messageSpanStep = 1 minutes;
14     address owner;
15 
16     bytes32 public head;
17     uint public length = 0;
18     mapping (bytes32 => Message) public messages;
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     event MessageAdded(address indexed sender, uint validFrom, uint validTo, string message);
26     event MessageSpanStepChanged(uint16 newStep);
27     event CostChanged(uint newCost);
28 
29     struct Message {
30     uint validFrom;
31     uint validTo;
32     address sender;
33     string message;
34     bytes32 next;
35     }
36 
37     /*
38     * Init.
39     */
40     function Billboard() public {
41         _saveMessage(now, now, msg.sender, "Welcome to MyEtheroll.com!");
42         owner = msg.sender;
43     }
44 
45     /*
46     * Adds message to the billboard.
47     * If a message already exists that has not expired, the new message will be queued.
48     */
49     function addMessage(string _message) public payable {
50         require(msg.value >= cost || msg.sender == owner); // make sure enough eth is sent
51         uint validFrom = messages[head].validTo > now ? messages[head].validTo : now;
52         _saveMessage(validFrom, validFrom + calculateDuration(msg.value), msg.sender, _message);
53         if(msg.value>0)owner.transfer(msg.value);
54     }
55 
56 
57     /*
58     * Returns the current active message.
59     */
60     function getActiveMessage() public view returns (uint, uint, address, string, bytes32) {
61         bytes32 idx = _getActiveMessageId();
62         return (messages[idx].validFrom, messages[idx].validTo, messages[idx].sender, messages[idx].message, messages[idx].next);
63     }
64 
65     /*
66     * Returns the timestamp of next queue opening.
67     */
68     function getQueueOpening() public view returns (uint) {
69         return messages[head].validTo;
70     }
71 
72     /*
73     * Returns guaranteed duration of message based on amount of wei sent with message.
74     * For each multiple of the current cost, the duration guarantee is extended by the messageSpan.
75     */
76     function calculateDuration(uint _wei) public view returns (uint)  {
77         return (_wei / cost * messageSpanStep);
78     }
79 
80     /*
81     * Owner can change the message span step, in seconds.
82     */
83     function setMessageSpan(uint16 _newMessageSpanStep) public onlyOwner {
84         messageSpanStep = _newMessageSpanStep;
85         MessageSpanStepChanged(_newMessageSpanStep);
86     }
87 
88     /*
89     * Owner can change the cost, in wei.
90     */
91     function setCost(uint _newCost) public onlyOwner {
92         cost = _newCost;
93         CostChanged(_newCost);
94     }
95 
96     /*
97     * Save message to the blockchain and add event.
98     */
99     function _saveMessage (uint _validFrom, uint _validTo, address _sender, string _message) private {
100         bytes32 id = _createId(Message(_validFrom, _validTo, _sender, _message, head));
101         messages[id] = Message(_validFrom, _validTo, _sender, _message, head);
102         length = length+1;
103         head = id;
104         MessageAdded(_sender, _validFrom, _validTo, _message);
105     }
106 
107     /*
108     * Create message id for linked list.
109     */
110     function _createId(Message _message) private view returns (bytes32) {
111         return keccak256(_message.validFrom, _message.validTo, _message.sender, _message.message, length);
112     }
113 
114     /*
115     * Get message id for current active message.
116     */
117     function _getActiveMessageId() private view returns (bytes32) {
118         bytes32 idx = head;
119         while(messages[messages[idx].next].validTo > now){
120             idx = messages[idx].next;
121         }
122         return idx;
123     }
124 
125     /*
126     * Kill contract.
127     */
128     function kill() public onlyOwner {
129         selfdestruct(owner);
130     }
131 
132 }