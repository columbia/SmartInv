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
36 		if (block.timestamp > end || this.balance > cap) {
37 			require(live);
38 			live = false;
39 			EndSale();
40 		} else if (!live) {
41 			live = true;
42 			StartSale();
43 		}
44 		EtherIn(msg.sender, msg.value);
45 	}
46 
47 	function init(uint _start, uint _end, uint _cap) onlyOwner {
48 		start = _start;
49 		end = _end;
50 		cap = _cap;
51 	}
52 
53 	function softCap(uint _newend) onlyOwner {
54 		require(_newend >= block.timestamp && _newend >= start && _newend <= end);
55 		end = _newend;
56 	}
57 
58 	// 1st half of ownership change
59 	function changeOwner(address next) onlyOwner {
60 		newOwner = next;
61 	}
62 
63 	// 2nd half of ownership change
64 	function acceptOwnership() {
65 		require(msg.sender == newOwner);
66 		owner = msg.sender;
67 		newOwner = 0;
68 	}
69 
70 	// put some text in the contract
71 	function setNotice(string note) onlyOwner {
72 		notice = note;
73 	}
74 
75 	// withdraw all of the Ether
76 	function withdraw() onlyOwner {
77 		msg.sender.transfer(this.balance);
78 	}
79 
80 	// withdraw some of the Ether
81 	function withdrawSome(uint value) onlyOwner {
82 		require(value <= this.balance);
83 		msg.sender.transfer(value);
84 	}
85 
86 	// withdraw tokens to owner
87 	function withdrawToken(address token) onlyOwner {
88 		Token t = Token(token);
89 		require(t.transfer(msg.sender, t.balanceOf(this)));
90 	}
91 
92 	// refund early/late tokens
93 	function refundToken(address token, address sender, uint amount) onlyOwner {
94 		Token t = Token(token);
95 		require(t.transfer(sender, amount));
96 	}
97 }