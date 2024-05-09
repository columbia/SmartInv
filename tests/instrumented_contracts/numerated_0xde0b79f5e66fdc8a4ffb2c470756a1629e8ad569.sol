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
22 
23 	function safeMul(uint a, uint b) internal returns(uint) {
24 		uint c = a * b;
25 		assert(a == 0 || c / a == b);
26 		return c;
27 	}
28 }
29 
30 contract owned {
31   address public owner;
32   modifier onlyOwner {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   function owned() {
38     owner = msg.sender;
39   }
40 
41   function changeOwner(address newOwner) onlyOwner {
42     owner = newOwner;
43   }
44 }
45 
46 contract mortal is owned {
47   function close() onlyOwner {
48 		require(address(this).balance == 0);
49     selfdestruct(owner);
50   }
51 }
52 
53 contract Reservation2 is mortal, SafeMath {
54 	ICO public ico;
55 	address[] public investors;
56 	mapping(address => uint) public balanceOf;
57 	mapping(address => bool) invested;
58 	uint public weiCap;
59 
60 
61 	/** constructs an investment contract for an ICO contract **/
62 	function Reservation2(address _icoAddr, uint _etherCap) {
63 		ico = ICO(_icoAddr);
64 		weiCap = safeMul(_etherCap, 1 ether);
65 	}
66 
67 	/** make an investment **/
68 	function() payable {
69 		require(msg.value > 0);
70 
71 		require(weiCap == 0 || this.balance <= weiCap);
72 
73 		if (!invested[msg.sender]) {
74 			investors.push(msg.sender);
75 			invested[msg.sender] = true;
76 		}
77 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value);
78 	}
79 
80 	/** buys tokens in behalf of the investors by calling the ico contract
81 	 *   starting with the investor at index from and ending with investor at index to.
82 	 *   This function will be called as soon as the ICO starts and as often as necessary, until all investments were made. **/
83 	function buyTokens(uint _from, uint _to) onlyOwner {
84 		require(address(ico)!=0x0);//would fail anyway below, but to be sure
85 		uint amount;
86 		if (_to > investors.length)
87 			_to = investors.length;
88 		for (uint i = _from; i < _to; i++) {
89 			if (balanceOf[investors[i]] > 0) {
90 				amount = balanceOf[investors[i]];
91 				delete balanceOf[investors[i]];
92 				ico.invest.value(amount)(investors[i]);
93 			}
94 		}
95 	}
96 
97 	/** In case an investor wants to retrieve his or her funds he or she can call this function.
98 	 *   (only possible before tokens are bought) **/
99 	function withdraw() {
100 		uint amount = balanceOf[msg.sender];
101 		require(amount > 0);
102 		
103 		balanceOf[msg.sender] = 0;
104 		msg.sender.transfer(amount);
105 	}
106 
107 	/** returns the number of investors **/
108 	function getNumInvestors() constant returns(uint) {
109 		return investors.length;
110 	}
111 	
112 	function setICO(address _icoAddr) onlyOwner {
113 		ico = ICO(_icoAddr);
114 	}
115 
116 }