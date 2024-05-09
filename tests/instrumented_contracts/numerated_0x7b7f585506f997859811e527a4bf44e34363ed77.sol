1 pragma solidity ^0.4.11;
2 
3 //
4 // Ann.sol - A smart contract for managing announcements cryptographically.
5 // Licensed under MIT
6 // See https://github.com/secure-vote/ann.sol/ for the readme and license
7 // 
8 // This contract allows publishers to push out announcements cryptographically.
9 // Before the contract recognizes them, they must be "thumbs up"ed by one or
10 // more third parties. Those third parties can also raise the alarm if they
11 // believe the announcement was made illegitimately.
12 //
13 // See https://ann-sol.com for a frontend and more info.
14 // See https://github.com/secure-vote/ann.sol/ for the contract source code.
15 //
16 
17 contract Announcement {
18 
19     struct Message {
20         string ipfsHash;
21         uint256 timestamp;
22     }
23 
24     struct MessageAwaitingAudit {
25         uint256 nAudits;
26         uint256 nAlarms;
27         Message msg;
28         mapping (address => bool) auditedBy;
29         mapping (address => bool) alarmedBy;
30     }
31 
32     address public owner;
33     mapping(address => bool) public auditors;
34     address[] public auditorsList;
35     uint256 public nAuditors;
36     uint256 public nAuditorsRequired = 1;
37     uint256 public nAuditorsAlarm = 1;
38     uint256 public nAlarms = 0;
39     uint256[] public alarms;
40     mapping(uint256 => bool) public alarmRaised;
41 
42     uint256 public nMsg = 0;
43     mapping(uint256 => Message) public msgMap;
44 
45     uint256 public nMsgsWaiting = 0;
46     mapping(uint256 => MessageAwaitingAudit) msgsWaiting;
47     mapping(uint256 => bool) public msgsWaitingDone;
48 
49 
50     modifier isOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     modifier isAuditor() {
56         require(auditors[msg.sender] == true);
57         _;
58     }
59 
60 
61     function Announcement(address[] _auditors, uint256 _nAuditorsRequired, uint256 _nAuditorsAlarm) {
62         require(_nAuditorsRequired >= 1);
63         require(_nAuditorsAlarm >= 1);
64 
65         for (uint256 i = 0; i < _auditors.length; i++) {
66             auditors[_auditors[i]] = true;
67             auditorsList.push(_auditors[i]);
68         }
69         nAuditors = _auditors.length;
70 
71         owner = msg.sender;
72         nAuditorsRequired = _nAuditorsRequired;
73         nAuditorsAlarm = _nAuditorsAlarm;
74     }
75 
76     function addAnn (string ipfsHash) isOwner external {
77         require(bytes(ipfsHash).length > 0);
78         msgQPut(ipfsHash);
79     }
80 
81     function msgQPut (string ipfsHash) private {
82         createNewMsgAwaitingAudit(ipfsHash, block.timestamp);
83     }
84 
85     function addAudit (uint256 msgWaitingN, bool msgGood) isAuditor external {
86         // ensure the msgWaiting is not done, and that this auditor has not submitted an audit previously
87         require(msgsWaitingDone[msgWaitingN] == false);
88         MessageAwaitingAudit msgWaiting = msgsWaiting[msgWaitingN];
89         require(msgWaiting.auditedBy[msg.sender] == false);
90         require(msgWaiting.alarmedBy[msg.sender] == false);
91         require(alarmRaised[msgWaitingN] == false);
92 
93         // check if the auditor is giving a thumbs up or a thumbs down and adjust things appropriately
94         if (msgGood == true) {
95             msgWaiting.nAudits += 1;
96             msgWaiting.auditedBy[msg.sender] = true;
97         } else {
98             msgWaiting.nAlarms += 1;
99             msgWaiting.alarmedBy[msg.sender] = true;
100         }
101 
102         // have we reached the right number of auditors and not triggered an alarm?
103         if (msgWaiting.nAudits >= nAuditorsRequired && msgWaiting.nAlarms < nAuditorsAlarm) {
104             // then remove msg from queue and add to messages
105             addMsgFinal(msgWaiting.msg, msgWaitingN);
106         } else if (msgWaiting.nAlarms >= nAuditorsAlarm) {
107             msgsWaitingDone[msgWaitingN] = true;
108             alarmRaised[msgWaitingN] = true;
109             alarms.push(msgWaitingN);
110             nAlarms += 1;
111         }
112     }
113 
114     function createNewMsgAwaitingAudit(string ipfsHash, uint256 timestamp) private {
115         msgsWaiting[nMsgsWaiting] = MessageAwaitingAudit(0, 0, Message(ipfsHash, timestamp));
116         nMsgsWaiting += 1;
117     }
118 
119     function addMsgFinal(Message msg, uint256 msgWaitingN) private {
120         // ensure we store the message first
121         msgMap[nMsg] = msg;
122         nMsg += 1;
123 
124         // finally note that this has been processed and clean up
125         msgsWaitingDone[msgWaitingN] = true;
126         delete msgsWaiting[msgWaitingN];
127     }
128 
129     function getMsgWaiting(uint256 msgWaitingN) constant external returns (uint256, uint256, string, uint256, bool) {
130         MessageAwaitingAudit maa = msgsWaiting[msgWaitingN];
131         return (
132             maa.nAudits,
133             maa.nAlarms,
134             maa.msg.ipfsHash,
135             maa.msg.timestamp,
136             alarmRaised[msgWaitingN]
137         );
138     }
139 }