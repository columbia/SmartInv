1 // Copyright New Alchemy Limited, 2017. All rights reserved.
2 
3 pragma solidity >=0.4.10;
4 
5 contract Token {
6 	function balanceOf(address addr) returns(uint);
7 	function transfer(address to, uint amount) returns(bool);
8 }
9 
10 contract Sale {
11 	address public owner;    // contract owner
12 	address public newOwner; // new contract owner for two-way ownership handshake
13 	string public notice;    // arbitrary public notice text
14 	uint public start;       // start time of sale
15 	uint public end;         // end time of sale
16 	uint public cap;         // Ether hard cap
17 	bool public live;        // sale is live right now
18 
19 	event StartSale();
20 	event EndSale();
21 	event EtherIn(address from, uint amount);
22 
23 	function Sale() {
24 		owner = msg.sender;
25 	}
26 
27 	modifier onlyOwner() {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 
32 	function () payable {
33 		require(block.timestamp >= start);
34 		if (block.timestamp > end || this.balance > cap) {
35 			require(live);
36 			live = false;
37 			EndSale();
38 		} else if (!live) {
39 			live = true;
40 			StartSale();
41 		}
42 		EtherIn(msg.sender, msg.value);
43 	}
44 
45 	function init(uint _start, uint _end, uint _cap) onlyOwner {
46 		start = _start;
47 		end = _end;
48 		cap = _cap;
49 	}
50 
51 	function softCap(uint _newend) onlyOwner {
52 		require(_newend >= block.timestamp && _newend >= start && _newend <= end);
53 		end = _newend;
54 	}
55 
56 	function changeOwner(address next) onlyOwner {
57 		newOwner = next;
58 	}
59 
60 	function acceptOwnership() {
61 		require(msg.sender == newOwner);
62 		owner = msg.sender;
63 		newOwner = 0;
64 	}
65 
66 	function setNotice(string note) onlyOwner {
67 		notice = note;
68 	}
69 
70 	function withdraw() onlyOwner {
71 		msg.sender.transfer(this.balance);
72 	}
73 
74 	function withdrawSome(uint value) onlyOwner {
75 		require(value <= this.balance);
76 		msg.sender.transfer(value);
77 	}
78 
79 	function withdrawToken(address token) onlyOwner {
80 		Token t = Token(token);
81 		require(t.transfer(msg.sender, t.balanceOf(this)));
82 	}
83 
84 	function refundToken(address token, address sender, uint amount) onlyOwner {
85 		Token t = Token(token);
86 		require(t.transfer(sender, amount));
87 	}
88 }