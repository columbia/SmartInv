1 /**
2  * This reservation contract accepts investments, which will be sent to the ICO contract as soon as it starts buy calling buyTokens().
3  * Investors may withdraw their funds anytime if they change their mind as long as the tokens have not yet been purchased.
4  * Author: Julia Altenried
5  * Internal audit: Alex Bazhanau, Andrej Ruckij
6  * Audit: Blockchain & Smart Contract Security Group
7  **/
8 
9 pragma solidity ^0.4.15;
10 
11 contract ICO {
12 	function invest(address receiver) payable {}
13 }
14 
15 contract SafeMath {
16 
17 	function safeAdd(uint a, uint b) internal returns(uint) {
18 		uint c = a + b;
19 		assert(c >= a && c >= b);
20 		return c;
21 	}
22 }
23 
24 contract owned {
25   address public owner;
26   modifier onlyOwner {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   function owned() {
32     owner = msg.sender;
33   }
34 
35   function changeOwner(address newOwner) onlyOwner {
36     owner = newOwner;
37   }
38 }
39 
40 contract mortal is owned {
41   function close() onlyOwner {
42 		require(address(this).balance == 0);
43     selfdestruct(owner);
44   }
45 }
46 
47 contract Reservation is mortal, SafeMath {
48 	ICO public ico;
49 	address[] public investors;
50 	mapping(address => uint) public balanceOf;
51 	mapping(address => bool) invested;
52 
53 
54 	/** constructs an investment contract for an ICO contract **/
55 	function Reservation(address _icoAddr) {
56 		ico = ICO(_icoAddr);
57 	}
58 
59 	/** make an investment **/
60 	function() payable {
61 		if (msg.value > 0) {
62 			if (!invested[msg.sender]) {
63 				investors.push(msg.sender);
64 				invested[msg.sender] = true;
65 			}
66 			balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value);
67 		}
68 	}
69 
70 
71 
72 	/** buys tokens in behalf of the investors by calling the ico contract
73 	 *   starting with the investor at index from and ending with investor at index to.
74 	 *   This function will be called as soon as the ICO starts and as often as necessary, until all investments were made. **/
75 	function buyTokens(uint _from, uint _to) onlyOwner {
76 		require(address(ico)!=0x0);//would fail anyway below, but to be sure
77 		uint amount;
78 		if (_to > investors.length)
79 			_to = investors.length;
80 		for (uint i = _from; i < _to; i++) {
81 			if (balanceOf[investors[i]] > 0) {
82 				amount = balanceOf[investors[i]];
83 				delete balanceOf[investors[i]];
84 				ico.invest.value(amount)(investors[i]);
85 			}
86 		}
87 	}
88 
89 	/** In case an investor wants to retrieve his or her funds he or she can call this function.
90 	 *   (only possible before tokens are bought) **/
91 	function withdraw() {
92 		uint amount = balanceOf[msg.sender];
93 		require(amount > 0);
94 		
95 		balanceOf[msg.sender] = 0;
96 		msg.sender.transfer(amount);
97 	}
98 
99 	/** returns the number of investors **/
100 	function getNumInvestors() constant returns(uint) {
101 		return investors.length;
102 	}
103 	
104 	function setICO(address _icoAddr) onlyOwner {
105 		ico = ICO(_icoAddr);
106 	}
107 
108 }