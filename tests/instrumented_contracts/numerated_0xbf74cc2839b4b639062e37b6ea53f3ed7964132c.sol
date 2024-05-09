1 pragma solidity ^0.4.11;
2 
3 
4 contract Announcement {
5 
6     struct Message {
7         string ipfsHash;
8         uint256 timestamp;
9     }
10 
11     struct MessageAwaitingAudit {
12         uint256 nAudits;
13         uint256 nAlarms;
14         Message msg;
15         mapping (address => bool) auditedBy;
16         mapping (address => bool) alarmedBy;
17     }
18 
19     address public owner;
20     mapping(address => bool) public auditors;
21     address[] public auditorsList;
22     uint256 public nAuditors;
23     uint256 public nAuditorsRequired = 1;
24     uint256 public nAuditorsAlarm = 1;
25     uint256 public nAlarms = 0;
26     uint256[] public alarms;
27     mapping(uint256 => bool) public alarmRaised;
28 
29     uint256 public nMsg = 0;
30     mapping(uint256 => Message) public msgMap;
31 
32     uint256 public nMsgsWaiting = 0;
33     mapping(uint256 => MessageAwaitingAudit) msgsWaiting;
34     mapping(uint256 => bool) public msgsWaitingDone;
35 
36 
37     modifier isOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     modifier isAuditor() {
43         require(auditors[msg.sender] == true);
44         _;
45     }
46 
47 
48     function Announcement(address[] _auditors, uint256 _nAuditorsRequired, uint256 _nAuditorsAlarm) {
49         require(_nAuditorsRequired >= 1);
50         require(_nAuditorsAlarm >= 1);
51 
52         for (uint256 i = 0; i < _auditors.length; i++) {
53             auditors[_auditors[i]] = true;
54             auditorsList.push(_auditors[i]);
55         }
56         nAuditors = _auditors.length;
57 
58         owner = msg.sender;
59         nAuditorsRequired = _nAuditorsRequired;
60         nAuditorsAlarm = _nAuditorsAlarm;
61     }
62 
63     function addAnn (string ipfsHash) isOwner external {
64         require(bytes(ipfsHash).length > 0);
65         msgQPut(ipfsHash);
66     }
67 
68     function msgQPut (string ipfsHash) private {
69         createNewMsgAwaitingAudit(ipfsHash, block.timestamp);
70     }
71 
72     function addAudit (uint256 msgWaitingN, bool msgGood) isAuditor external {
73         // ensure the msgWaiting is not done, and that this auditor has not submitted an audit previously
74         require(msgsWaitingDone[msgWaitingN] == false);
75         MessageAwaitingAudit msgWaiting = msgsWaiting[msgWaitingN];
76         require(msgWaiting.auditedBy[msg.sender] == false);
77         require(msgWaiting.alarmedBy[msg.sender] == false);
78         require(alarmRaised[msgWaitingN] == false);
79 
80         // check if the auditor is giving a thumbs up or a thumbs down and adjust things appropriately
81         if (msgGood == true) {
82             msgWaiting.nAudits += 1;
83             msgWaiting.auditedBy[msg.sender] = true;
84         } else {
85             msgWaiting.nAlarms += 1;
86             msgWaiting.alarmedBy[msg.sender] = true;
87         }
88 
89         // have we reached the right number of auditors and not triggered an alarm?
90         if (msgWaiting.nAudits >= nAuditorsRequired && msgWaiting.nAlarms < nAuditorsAlarm) {
91             // then remove msg from queue and add to messages
92             addMsgFinal(msgWaiting.msg, msgWaitingN);
93         } else if (msgWaiting.nAlarms >= nAuditorsAlarm) {
94             msgsWaitingDone[msgWaitingN] = true;
95             alarmRaised[msgWaitingN] = true;
96             alarms.push(msgWaitingN);
97             nAlarms += 1;
98         }
99     }
100 
101     function createNewMsgAwaitingAudit(string ipfsHash, uint256 timestamp) private {
102         msgsWaiting[nMsgsWaiting] = MessageAwaitingAudit(0, 0, Message(ipfsHash, timestamp));
103         nMsgsWaiting += 1;
104     }
105 
106     function addMsgFinal(Message msg, uint256 msgWaitingN) private {
107         // ensure we store the message first
108         msgMap[nMsg] = msg;
109         nMsg += 1;
110 
111         // finally note that this has been processed and clean up
112         msgsWaitingDone[msgWaitingN] = true;
113         delete msgsWaiting[msgWaitingN];
114     }
115 
116     function getMsgWaiting(uint256 msgWaitingN) constant external returns (uint256, uint256, string, uint256, bool) {
117         MessageAwaitingAudit maa = msgsWaiting[msgWaitingN];
118         return (
119             maa.nAudits,
120             maa.nAlarms,
121             maa.msg.ipfsHash,
122             maa.msg.timestamp,
123             alarmRaised[msgWaitingN]
124         );
125     }
126 }