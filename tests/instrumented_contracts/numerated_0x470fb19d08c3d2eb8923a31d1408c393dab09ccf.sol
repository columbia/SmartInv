1 pragma solidity 0.4.16;
2 
3 contract FiveMedium {
4 	
5 	// owner
6 	address private owner;
7 
8 	// fees
9 	uint256 public feeNewThread;
10 	uint256 public feeReplyThread;
11 
12 	//
13 	// Database
14 	//
15 
16 	// the threads
17 	struct thread {
18 		string text;
19 		string imageUrl;
20 
21 		uint256 indexLastReply;
22 		uint256 indexFirstReply;
23 
24 		uint256 timestamp;
25 	}
26 	mapping (uint256 => thread) public threads;
27 	uint256 public indexThreads = 1;
28 
29 	// the replies
30 	struct reply {
31 		string text;
32 		string imageUrl;
33 
34 		uint256 replyTo;
35 		uint256 nextReply;
36 
37 		uint256 timestamp;
38 	}
39 	mapping (uint256 => reply) public replies;
40 	uint256 public indexReplies = 1;
41 
42 	// last 20 active threads 
43 	uint256[20] public lastThreads;
44 	uint256 public indexLastThreads = 0; // the index of the thread that was added last in lastThreads
45 
46 	// 
47 	// Events
48 	//
49 
50 	event newThreadEvent(uint256 threadId, string text, string imageUrl, uint256 timestamp);
51 
52 	event newReplyEvent(uint256 replyId, uint256 replyTo, string text, string imageUrl, uint256 timestamp);
53 
54 	//
55 	// Meta
56 	//
57 
58 	// constructor
59 	function FiveMedium(uint256 _feeNewThread, uint256 _feeReplyThread) public {
60 		owner = msg.sender;
61 		feeNewThread = _feeNewThread;
62 		feeReplyThread = _feeReplyThread;
63 	}
64 	
65 	// modifying the fees
66 	function SetFees(uint256 _feeNewThread, uint256 _feeReplyThread) public {
67 		require(owner == msg.sender);
68 		feeNewThread = _feeNewThread;
69 		feeReplyThread = _feeReplyThread;
70 	}
71 
72 	// To get the money back
73 	function withdraw(uint256 amount) public {
74 		owner.transfer(amount);
75 	}
76 
77 	//
78 	// Core
79 	//
80 
81 	// To create a Thread
82 	function createThread(string _text, string _imageUrl) payable public {
83 		// collect the fees
84 		require(msg.value >= feeNewThread); 
85 		// calculate a new thread ID and post
86 		threads[indexThreads] = thread(_text, _imageUrl, 0, 0, now);
87 		// add it to our last active threads array
88 		lastThreads[indexLastThreads] = indexThreads;
89 		indexLastThreads = addmod(indexLastThreads, 1, 20); // increment index
90 		// log!
91 		newThreadEvent(indexThreads, _text, _imageUrl, now);
92 		// increment index for next thread
93 		indexThreads += 1;
94 	}
95 
96 	// To reply to a thread
97 	function replyThread(uint256 _replyTo, string _text, string _imageUrl)  payable public {
98 		// collect the fees
99 		require(msg.value >= feeReplyThread);
100 		// make sure you can't reply to an inexistant thread
101 		require(_replyTo < indexThreads && _replyTo > 0);
102 		// post the reply with nextReply = 0 (this is the last message in the chain)
103 		replies[indexReplies] = reply(_text, _imageUrl, _replyTo, 0, now);
104 		// update the thread 
105 		if(threads[_replyTo].indexFirstReply == 0){// we're first
106 			threads[_replyTo].indexFirstReply = indexReplies;
107 			threads[_replyTo].indexLastReply = indexReplies;
108 		}
109 		else { // we're not first so we update the previous reply as well
110 			replies[threads[_replyTo].indexLastReply].nextReply = indexReplies;
111 			threads[_replyTo].indexLastReply = indexReplies;
112 		}
113 		// update the last active threads 
114 		for (uint8 i = 0; i < 20; i++) { 
115 			if(lastThreads[i] == _replyTo) {
116 				break; // already in the list
117 			}
118 			if(i == 19) {
119 				lastThreads[indexLastThreads] = _replyTo;
120 				indexLastThreads = addmod(indexLastThreads, 1, 20);
121 			}
122 		} 
123 		// log!
124 		newReplyEvent(indexReplies, _replyTo, _text, _imageUrl, now);
125 		// increment index for next reply
126 		indexReplies += 1;
127 	}
128 }