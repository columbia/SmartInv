1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * Jackpot holding contract for Zlots.
6 *  
7 * This accepts token payouts from Zlots for every player loss,
8 * and on a win, pays out *half* of the jackpot to the winner.
9 *
10 * Jackpot payout should only be called from Zlots.
11 *
12 */
13 
14 contract ZethrInterface {
15   function balanceOf(address who) public view returns (uint);
16   function transfer(address _to, uint _value) public returns (bool);
17 	function withdraw(address _recipient) public;
18 }
19 
20 // Should receive Zethr tokens
21 contract ERC223Receiving {
22   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
23 }
24 
25 // The actual contract
26 contract ZlotsJackpotHoldingContract is ERC223Receiving {
27 
28   // ------------------------- Modifiers
29 
30   // Require msg.sender to be owner
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   } 
35 
36   // Require msg.sender to be zlots
37   modifier onlyZlots() {
38     require(msg.sender == zlots);
39     _;
40   }
41 
42 	// -------------------------- Events
43 
44   // Events
45   event JackpotPayout(
46     uint amountPaid,
47     address winner,
48     uint payoutNumber
49   );
50 
51 	// -------------------------- Variables
52 
53   // Configurables
54   address owner;
55   address zlots;
56   ZethrInterface Zethr = ZethrInterface(0xD48B633045af65fF636F3c6edd744748351E020D);
57 
58   // Trackers
59   uint payoutNumber = 0; // How many times we've paid out the jackpot
60   uint totalPaidOut = 0; // The total amount we've paid out 
61 
62   // ------------------------- Functions
63 
64 	// Constructor
65   constructor (address zlotsAddress) public {
66     owner = msg.sender;
67     zlots = zlotsAddress;
68   }
69 
70   // When we transfer, divs are withdraw.
71   // This means we need an empty public payable.
72   function () public payable { }
73 
74   // Callable only by Zlots
75   // Pay a winner half of the jackpot
76   function payOutWinner(address winner) onlyZlots {
77 		// Calculate payout & pay out
78  		uint payoutAmount = Zethr.balanceOf(address(this)) / 2;
79 		Zethr.transfer(winner, payoutAmount);	
80 
81 		// Incremement the vars
82 		payoutNumber += 1;
83 		totalPaidOut += payoutAmount / 2;
84 
85 		emit JackpotPayout(payoutAmount / 2, winner, payoutNumber);
86   }
87 
88 	// Admin function to pull all tokens if we need to - like upgrading this contract
89 	function pullTokens(address _to) public onlyOwner {
90     uint balance = Zethr.balanceOf(address(this));
91     Zethr.transfer(_to, balance);
92 	}
93 
94   // Admin function to change zlots address if we need to
95   function setZlotsAddress(address zlotsAddress) public onlyOwner {
96     zlots = zlotsAddress;
97   }
98 
99   // Token fallback to accept jackpot payments from Zlots
100   // These tokens can come from anywhere, really - why restrict?
101   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes/*_data*/) public returns (bool) {
102     // Do nothing, we can track the jackpot by this balance
103   }
104 
105 	// View function - returns the jackpot amount
106   function getJackpot() public view returns (uint) {
107     return Zethr.balanceOf(address(this)) / 2;
108   }
109 }