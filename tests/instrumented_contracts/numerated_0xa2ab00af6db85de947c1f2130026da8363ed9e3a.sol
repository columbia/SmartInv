1 pragma solidity ^0.4.3;
2 
3  /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 contract BlockPaperScissors is Ownable {
59 
60   using SafeMath for uint256;
61 
62     ERC20Interface bCoin;
63     ERC20Interface pCoin;
64     ERC20Interface sCoin;
65     ERC20Interface tCoin;
66 
67     address public rpsDev = msg.sender;
68     uint8 public lastMove = 1; // last played move; 1=rock, 2=paper, 3=scissor
69     address public lastPlayer = msg.sender;
70     uint public oneCoin = 1000000000000000000;
71 
72 //FUNCTIONS setting and retrieving global variables that impact gameplay
73 
74     function setBCoinContractAddress(address _address) external onlyOwner {
75       bCoin = ERC20Interface(_address);
76     }
77     function setPCoinContractAddress(address _address) external onlyOwner {
78       pCoin = ERC20Interface(_address);
79     }
80     function setSCoinContractAddress(address _address) external onlyOwner {
81       sCoin = ERC20Interface(_address);
82     }
83     function setTCoinContractAddress(address _address) external onlyOwner {
84       tCoin = ERC20Interface(_address);
85     }
86 
87 //EVENTS
88 
89     event newMove(uint8 move);
90     event newWinner(address winner);
91 
92 // FUNCTIONS interacting with the swine structs in contract
93 
94     function playBps(uint8 _choice) public returns (uint8) {
95       require (_choice == 1 || _choice == 2 || _choice == 3);
96       if (_choice == lastMove) {
97         tCoin.transfer(msg.sender, oneCoin);
98         tCoin.transfer(lastPlayer, oneCoin);// send tie token to each player
99         setGame(_choice, msg.sender);
100         return 3; // it's a tie
101       }
102       if (_choice == 1) { //choice is block
103         if (lastMove == 3) {
104           bCoin.transfer(msg.sender, oneCoin);
105           emit newWinner(msg.sender);
106           setGame(_choice, msg.sender);
107           return 1;// win
108           } else {
109           pCoin.transfer(lastPlayer, oneCoin);
110           emit newWinner(lastPlayer);
111           setGame(_choice, msg.sender);
112           return 2;//lose
113           }
114       }
115       if (_choice == 2) { // choice is paper
116         if (lastMove == 1) {
117           pCoin.transfer(msg.sender, oneCoin);
118           emit newWinner(msg.sender);
119           setGame(_choice, msg.sender);
120           return 1;// win
121           } else {
122           sCoin.transfer(lastPlayer, oneCoin);
123           emit newWinner(lastPlayer);
124           setGame(_choice, msg.sender);
125           return 2;//lose
126           }
127       }
128       if (_choice == 3) { // choice is scissors
129         if (lastMove == 2) {
130           sCoin.transfer(msg.sender, oneCoin);
131           emit newWinner(msg.sender);
132           setGame(_choice, msg.sender);
133           return 1;// win
134           } else {
135           bCoin.transfer(lastPlayer, oneCoin);
136           emit newWinner(lastPlayer);
137           setGame(_choice, msg.sender);
138           return 2;//lose
139           }
140       }
141     }
142 
143     function setGame(uint8 _move, address _player) private {
144       lastMove = _move;
145       lastPlayer = _player;
146       emit newMove(_move);
147     }
148 
149 }
150 
151 library SafeMath {
152 
153   /**
154   * @dev Multiplies two numbers, throws on overflow.
155   */
156   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157     if (a == 0) {
158       return 0;
159     }
160     uint256 c = a * b;
161     assert(c / a == b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return c;
173   }
174 
175   /**
176   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256) {
187     uint256 c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 
192 }