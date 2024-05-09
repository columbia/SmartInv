1 pragma solidity ^ 0.5.8;
2  
3  /**
4  *  ╔═╗╔═╗╔═══╗╔══╗─╔═══╗╔════╗     ──────╔══╗╔═╗─╔╗
5  *  ╚╗╚╝╔╝║╔═╗║║╔╗║─║╔══╝║╔╗╔╗║     ──────╚╣─╝║║╚╗║║
6  *  ─╚╗╔╝─╚╝╔╝║║╚╝╚╗║╚══╗╚╝║║╚╝     ╔╗╔╗╔╗─║║─║╔╗╚╝║
7  *  ─╔╝╚╗─╔═╝╔╝║╔═╗║║╔══╝──║║──     ║╚╝╚╝║─║║─║║╚╗║║
8  *  ╔╝╔╗╚╗║║╚═╗║╚═╝║║╚══╗──║║──     ╚╗╔╗╔╝╔╣─╗║║─║║║
9  *  ╚═╝╚═╝╚═══╝╚═══╝╚═══╝──╚╝──     ─╚╝╚╝─╚══╝╚╝─╚═╝
10  *
11  * 
12  * The contract of acceptance and withdrawal of funds in the first, fair and open gaming platform https://x2bet.win
13  * Buying coins x2bet you agree that you have turned 18 years old and you realize the risk associated with gambling and slot machines
14  * For the withdrawal of winnings from the system, a commission of 3% is charged.
15  * The creator of the project is not responsible for the player’s financial losses when playing fair slot machines, all actions you do at your own risk.
16  * The project team has the right to suspend withdrawal of funds, in case of detection of suspicious actions, until clarification of circumstances.
17  */
18 
19 contract X2Bet_win {
20     
21     using SafeMath
22     for uint;
23     
24     address public owner;
25     mapping(address => uint) public deposit;
26     mapping(address => uint) public withdrawal;
27     bool public status = true;
28     uint public min_payment = 0.05 ether;
29     uint public systemPercent = 0;
30     
31     constructor()public {
32         owner = msg.sender;
33     }
34     
35     event ByCoin(
36         address indexed from,
37         uint indexed block,
38         uint value,
39         uint user_id,
40         uint time
41     );
42     
43     event ReturnRoyalty(
44         address indexed from,
45         uint indexed block,
46         uint value, 
47         uint withdrawal_id,
48         uint time
49     );
50     
51     modifier isNotContract(){
52         uint size;
53         address addr = msg.sender;
54         assembly { size := extcodesize(addr) }
55         require(size == 0 && tx.origin == msg.sender);
56         _;
57     }
58     
59     modifier contractIsOn(){
60         require(status);
61         _;
62     }
63     
64     modifier minPayment(){
65         require(msg.value >= min_payment);
66         _;
67     }
68     
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73     
74     //Coin purchase method x2Bet.win
75     function byCoin(uint _user_id)contractIsOn isNotContract minPayment public payable{
76         deposit[msg.sender]+= msg.value;
77         emit ByCoin(msg.sender, block.number, msg.value, _user_id, now);
78         
79     }
80     
81     //Automatic withdrawal of winnings x2Bet.win
82     function pay_royaltie(address payable[] memory dests, uint256[] memory values, uint256[] memory ident) onlyOwner contractIsOn public returns(uint){
83         uint256 i = 0;
84         while (i < dests.length) {
85             uint transfer_value = values[i].sub(values[i].mul(3).div(100));
86             dests[i].transfer(transfer_value);
87             withdrawal[dests[i]]+=values[i];
88             emit ReturnRoyalty(dests[i], block.number, values[i], ident[i], now);
89             systemPercent += values[i].mul(3).div(100);
90             i += 1;
91         }
92         
93         return(i);
94     }
95     
96     function startProphylaxy()onlyOwner public {
97         status = false;
98     }
99     
100     function stopProphylaxy()onlyOwner public {
101         status = true;
102     }
103     
104     function() external payable {
105         
106     }
107     
108 }
109 
110 library SafeMath {
111 
112     /**
113      * @dev Multiplies two numbers, reverts on overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
116         if (a == 0) {
117             return 0;
118         }
119         uint256 c = a * b;
120         require(c / a == b);
121         return c;
122     }
123 
124     function div(uint256 a, uint256 b) internal pure returns(uint256) {
125         require(b > 0); // Solidity only automatically asserts when dividing by 0
126         uint256 c = a / b;
127         return c;
128     }
129 
130     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
131         require(b <= a);
132         uint256 c = a - b;
133         return c;
134     }
135 
136     function add(uint256 a, uint256 b) internal pure returns(uint256) {
137         uint256 c = a + b;
138         require(c >= a);
139         return c;
140     }
141 }