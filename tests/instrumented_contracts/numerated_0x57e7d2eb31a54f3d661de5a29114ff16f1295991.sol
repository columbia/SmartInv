1 // Copyright New Alchemy Limited, 2017. All rights reserved.
2 
3 pragma solidity >=0.4.10;
4 
5 // Just the bits of ERC20 that we need.
6 contract Token {
7 	function balanceOf(address addr) returns(uint);
8 	function transfer(address to, uint amount) returns(bool);
9 }
10 
11 contract Sale {
12 	address public owner;    // contract owner
13 	address public newOwner; // new contract owner for two-way ownership handshake
14 	string public notice;    // arbitrary public notice text
15 	uint public start;       // start time of sale
16 	uint public end;         // end time of sale
17 	uint public cap;         // Ether hard cap
18 	bool public live;        // sale is live right now
19 
20 	event StartSale();
21 	event EndSale();
22 	event EtherIn(address from, uint amount);
23 
24 	function Sale() {
25 		owner = msg.sender;
26 	}
27 
28 	modifier onlyOwner() {
29 		require(msg.sender == owner);
30 		_;
31 	}
32 
33 	function () payable {
34 		require(block.timestamp >= start);
35 
36 		// If we've reached end-of-sale conditions, accept
37 		// this as the last contribution and emit the EndSale event.
38 		// (Technically this means we allow exactly one contribution
39 		// after the end of the sale.)
40 		// Conversely, if we haven't started the sale yet, emit
41 		// the StartSale event.
42 		if (block.timestamp > end || this.balance > cap) {
43 			require(live);
44 			live = false;
45 			EndSale();
46 		} else if (!live) {
47 			live = true;
48 			StartSale();
49 		}
50 		EtherIn(msg.sender, msg.value);
51 	}
52 
53 	function init(uint _start, uint _end, uint _cap) onlyOwner {
54 		start = _start;
55 		end = _end;
56 		cap = _cap;
57 	}
58 
59 	function softCap(uint _newend) onlyOwner {
60 		require(_newend >= block.timestamp && _newend >= start && _newend <= end);
61 		end = _newend;
62 	}
63 
64 	// 1st half of ownership change
65 	function changeOwner(address next) onlyOwner {
66 		newOwner = next;
67 	}
68 
69 	// 2nd half of ownership change
70 	function acceptOwnership() {
71 		require(msg.sender == newOwner);
72 		owner = msg.sender;
73 		newOwner = 0;
74 	}
75 
76 	// put some text in the contract
77 	function setNotice(string note) onlyOwner {
78 		notice = note;
79 	}
80 
81 	// withdraw all of the Ether
82 	function withdraw() onlyOwner {
83 		msg.sender.transfer(this.balance);
84 	}
85 
86 	// withdraw some of the Ether
87 	function withdrawSome(uint value) onlyOwner {
88 		require(value <= this.balance);
89 		msg.sender.transfer(value);
90 	}
91 
92 	// withdraw tokens to owner
93 	function withdrawToken(address token) onlyOwner {
94 		Token t = Token(token);
95 		if (!t.transfer(msg.sender, t.balanceOf(this))) throw;
96 	}
97 
98 	// refund early/late tokens
99 	function refundToken(address token, address sender, uint amount) onlyOwner {
100 		Token t = Token(token);
101 		if (!t.transfer(sender, amount)) throw;
102 	}
103 }