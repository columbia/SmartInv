1 //Simple Msg XChange Registrar (does not provide validateion!)
2 contract Message {
3 	address public registrar;	
4 	address public from;
5 	address public to;
6 	string public hash_msg;
7 	string public hash_ack;
8 	uint256 public timestamp_msg;
9 	uint256 public timestamp_ack;
10 	
11 	
12 	function Message(address _registrar,address _from,address _to,string _hash_msg) {
13 		registrar=_registrar;
14 		from=_from;
15 		to=_to;
16 		hash_msg=_hash_msg;
17 		timestamp_msg=now;
18 	}
19 	
20 	function ack(string _hash) {
21 		if(msg.sender!=to) throw;
22 		if(timestamp_ack>0) throw;
23 		hash_ack=_hash;
24 		timestamp_ack=now;		
25 	}
26 	
27 	function() {
28 		if(msg.value>0) {
29 			if(msg.sender==from) {			
30 				to.send(msg.value);
31 			} else {
32 				from.send(msg.value);
33 			}
34 		}
35 	}
36 	
37 }
38 contract Registrar
39 {
40 	address public registrar;		
41 	
42 	uint256 public fee_registration;
43 	uint256 public fee_msg;
44 	uint256 public cnt_registrations;
45 	
46 	struct Registration {
47 		address adr;
48 		string hash;
49 		string gnid;
50 	}	
51 	
52 	mapping(address=>Registration) public regadr;	
53 	mapping(address=>Message[]) public msgs;
54 	mapping(address=>Message[]) public sent;
55 	mapping(address=>bool) public preregister;	
56 	
57 	Registration[] public regs;
58 	
59 	function Registrar() {
60 		registrar=msg.sender;
61 	}
62 	
63 	function register(string hash) {
64 		updateRegistration(hash,'');		
65 	}
66 	
67 	function unregister() {
68 		delete regadr[msg.sender];
69 	}
70 	
71 	function updateRegistration(string hash,string gnid) {		
72 		if((msg.value>=fee_registration)||(preregister[msg.sender])) {			
73 			regadr[msg.sender]=Registration(msg.sender,hash,gnid);
74 			regs.push(regadr[msg.sender]);
75 			if(fee_registration>0) registrar.send(this.balance);
76 			preregister[msg.sender]=false;
77 			cnt_registrations++;
78 		} else throw;
79 	}
80 	
81 	function preRegister(address preReg) {
82 		if(msg.sender!=registrar) throw;
83 		preReg.send(msg.value);		
84 		preregister[preReg]=true;
85 	}
86 	
87 	function getMsgs() returns (Message[]) {
88 		return msgs[msg.sender];	
89 	}
90 	
91 	function setRegistrationPrice(uint256 price) {
92 		if(msg.sender!=registrar) throw;
93 		fee_registration=price;
94 	}
95 	
96 	function setMsgPrice(uint256 price) {
97 		if(msg.sender!=registrar) throw;
98 		fee_msg=price;
99 	}
100 	
101 	function sendMsg(address to,string hash) {
102 		if(msg.value>=fee_msg) {	
103 			    Message m = new  Message(this,msg.sender,to,hash);
104 				msgs[to].push(m);	
105 			    sent[msg.sender].push(m);
106 			if(fee_msg>0) registrar.send(this.balance);
107 		} else throw;		
108 	}
109 	
110 	function ackMsg(uint256 msgid,string hash) {
111 		Message message =Message(msgs[msg.sender][msgid]);
112 		message.ack(hash);
113 	}
114 	
115 	function() {
116 		if(msg.value>0) {
117 			registrar.send(msg.value);
118 		}
119 	}
120 }