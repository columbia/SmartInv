1 // DeadMansSwitch contract, by Gavin Wood.
2 // Copyright Parity Technologies Ltd (UK), 2016.
3 // This code may be distributed under the terms of the Apache Licence, version 2
4 // or the MIT Licence, at your choice.
5 
6 pragma solidity ^0.4;
7 
8 /// This is intended to be used as a basic wallet. It provides the Received event
9 /// in order to track incoming transactions. It also has one piece of additional
10 /// functionality: to nominate a backup owner which can, after a timeout period,
11 /// claim ownership over the account.
12 contract DeadMansSwitch {
13 	event ReclaimBegun();
14 	event Reclaimed();
15 	event Sent(address indexed to, uint value, bytes data);
16 	event Received(address indexed from, uint value, bytes data);
17 	event Reset();
18 	event OwnerChanged(address indexed _old, address indexed _new);
19 	event BackupChanged(address indexed _old, address indexed _new);
20 	event ReclaimPeriodChanged(uint _old, uint _new);
21 
22 	function DeadMansSwitch(address _owner, address _backup, uint _reclaimPeriod) {
23 		owner = _owner;
24 		backup = _backup;
25 		reclaimPeriod = _reclaimPeriod;
26 	}
27 
28 	function() payable { Received(msg.sender, msg.value, msg.data); }
29 
30 	// Backup functions
31 
32 	function beginReclaim() only_backup when_no_timeout {
33 		timeout = now + reclaimPeriod;
34 		ReclaimBegun();
35 	}
36 
37 	function finalizeReclaim() only_backup when_timed_out {
38 		owner = backup;
39 		timeout = 0;
40 		Reclaimed();
41 	}
42 
43 	function reset() only_owner_or_backup {
44 		timeout = 0;
45 		Reset();
46 	}
47 
48 	// Owner functions
49 
50 	function send(address _to, uint _value, bytes _data) only_owner {
51 		if (!_to.call.value(_value)(_data)) throw;
52 		Sent(_to, _value, _data);
53 	}
54 
55 	function setOwner(address _owner) only_owner {
56 		OwnerChanged(owner, _owner);
57 		owner = _owner;
58 	}
59 
60 	function setBackup(address _backup) only_owner {
61 		BackupChanged(backup, _backup);
62 		backup = _backup;
63 	}
64 
65 	function setReclaimPeriod(uint _period) only_owner {
66 		ReclaimPeriodChanged(reclaimPeriod, _period);
67 		reclaimPeriod = _period;
68 	}
69 
70 	// Inspectors
71 
72 	function reclaimStarted() constant returns (bool) {
73 		return timeout != 0;
74 	}
75 
76 	function canFinalize() constant returns (bool) {
77 		return timeout != 0 && now > timeout;
78 	}
79 
80 	function timeLeft() constant only_when_timeout returns (uint) {
81 		return now > timeout ? 0 : timeout - now;
82 	}
83 
84 	modifier only_owner { if (msg.sender != owner) throw; _; }
85 	modifier only_backup { if (msg.sender != backup) throw; _; }
86 	modifier only_owner_or_backup { if (msg.sender != backup && msg.sender != owner) throw; _; }
87 	modifier only_when_timeout { if (timeout == 0) throw; _; }
88 	modifier when_no_timeout { if (timeout == 0) _; }
89 	modifier when_timed_out { if (timeout != 0 && now > timeout) _; }
90 
91 	address public owner;
92 	address public backup;
93 	uint public reclaimPeriod;
94 	uint public timeout;
95 }