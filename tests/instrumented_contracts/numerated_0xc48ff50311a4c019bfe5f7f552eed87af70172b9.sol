1 pragma solidity >=0.4.10;
2 
3 contract Token {
4 	function balanceOf(address addr) returns(uint);
5 	function transfer(address to, uint amount) returns(bool);
6 }
7 
8 contract Sale {
9 	address public owner;    // contract owner
10 	address public newOwner; // new contract owner for two-way ownership handshake
11 	string public notice;    // arbitrary public notice text
12 	uint public start;       // start time of sale
13 	uint public end;         // end time of sale
14 	uint public cap;         // Ether hard cap
15 	bool public live;        // sale is live right now
16 
17 	event StartSale();
18 	event EndSale();
19 	event EtherIn(address from, uint amount);
20 
21 	function Sale() {
22 		owner = msg.sender;
23 	}
24 
25 	modifier onlyOwner() {
26 		require(msg.sender == owner);
27 		_;
28 	}
29 
30 	function () payable {
31 		require(block.timestamp >= start);
32 		if (block.timestamp > end || this.balance > cap) {
33 			require(live);
34 			live = false;
35 			EndSale();
36 		} else if (!live) {
37 			live = true;
38 			StartSale();
39 		}
40 		EtherIn(msg.sender, msg.value);
41 	}
42 
43 	function init(uint _start, uint _end, uint _cap) onlyOwner {
44 		start = _start;
45 		end = _end;
46 		cap = _cap;
47 	}
48 
49 	// 1st half of ownership change
50 	function changeOwner(address next) onlyOwner {
51 		newOwner = next;
52 	}
53 
54 	// 2nd half of ownership change
55 	function acceptOwnership() {
56 		require(msg.sender == newOwner);
57 		owner = msg.sender;
58 		newOwner = 0;
59 	}
60 
61 	// put some text in the contract
62 	function setNotice(string note) onlyOwner {
63 		notice = note;
64 	}
65 
66 	// withdraw all of the Ether
67 	function withdraw() onlyOwner {
68 		msg.sender.transfer(this.balance);
69 	}
70 
71 	// withdraw some of the Ether
72 	function withdrawSome(uint value) onlyOwner {
73 		require(value <= this.balance);
74 		msg.sender.transfer(value);
75 	}
76 
77 	// withdraw tokens to owner
78 	function withdrawToken(address token) onlyOwner {
79 		Token t = Token(token);
80 		if (!t.transfer(msg.sender, t.balanceOf(this))) throw;
81 	}
82 
83 	// refund early/late tokens
84 	function refundToken(address token, address sender, uint amount) onlyOwner {
85 		Token t = Token(token);
86 		if (!t.transfer(sender, amount)) throw;
87 	}
88 }