1 pragma solidity ^0.4.8;
2 
3 /**
4  * Very basic owned/mortal boilerplate.  Used for basically everything, for
5  * security/access control purposes.
6  */
7 contract Owned {
8   address owner;
9 
10   modifier onlyOwner {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   /**
18    * Basic constructor.  The sender is the owner.
19    */
20   function Owned() {
21     owner = msg.sender;
22   }
23 
24   /**
25    * Transfers ownership of the contract to a new owner.
26    * @param newOwner  Who gets to inherit this thing.
27    */
28   function transferOwnership(address newOwner) onlyOwner {
29     owner = newOwner;
30   }
31 
32   /**
33    * Shuts down the contract and removes it from the blockchain state.
34    * Only available to the owner.
35    */
36   function shutdown() onlyOwner {
37     selfdestruct(owner);
38   }
39 
40   /**
41    * Withdraw all the funds from this contract.
42    * Only available to the owner.
43    */
44   function withdraw() onlyOwner {
45     if (!owner.send(this.balance)) {
46       throw;
47     }
48   }
49 }
50 
51 /**
52  * The base interface is what the parent contract expects to be able to use.
53  * If rules change in the future, and new logic is introduced, it only has to
54  * implement these methods, wtih the role of the curator being used
55  * to execute the additional functionality (if any).
56  */
57 contract LotteryGameLogicInterface {
58   address public currentRound;
59   function finalizeRound() returns(address);
60   function isUpgradeAllowed() constant returns(bool);
61   function transferOwnership(address newOwner);
62 }
63 
64 /**
65  * This contract is pretty generic, as it really only serves to maintain a constant
66  * address on the blockchain (through upgrades to the game logic), and to maintain
67  * a history of previous rounds.  Note that the rounds will have had ownership
68  * transferred to the curator (most likely), so there's mostly just here for
69  * accounting purposes.
70  *
71  * A side effect of this is that finalizing a round has to happen from here.
72  */
73 contract Lotto is Owned {
74 
75   address[] public previousRounds;
76 
77   LotteryGameLogicInterface public gameLogic;
78 
79   modifier onlyWhenUpgradeable {
80     if (!gameLogic.isUpgradeAllowed()) {
81       throw;
82     }
83     _;
84   }
85 
86   modifier onlyGameLogic {
87     if (msg.sender != address(gameLogic)) {
88       throw;
89     }
90     _;
91   }
92 
93   /**
94    * Creates a new lottery contract.
95    * @param initialGameLogic   The starting game logic.
96    */
97   function Lotto(address initialGameLogic) {
98     gameLogic = LotteryGameLogicInterface(initialGameLogic);
99   }
100 
101   /**
102    * Upgrade the game logic.  Only possible to do when the game logic
103    * has deemed it clear to do so.  Hands the old one over to the owner
104    * for cleanup.  Expects the new logic to already be configured.
105    * @param newLogic   New, already-configured game logic.
106    */
107   function setNewGameLogic(address newLogic) onlyOwner onlyWhenUpgradeable {
108     gameLogic.transferOwnership(owner);
109     gameLogic = LotteryGameLogicInterface(newLogic);
110   }
111 
112   /**
113    * Returns the current round.
114    * @return address The current round (when applicable)
115    */
116   function currentRound() constant returns(address) {
117     return gameLogic.currentRound();
118   }
119 
120   /**
121    * Used to finalize (e.g. pay winners) the current round, then log
122    * it in the history.
123    */
124   function finalizeRound() onlyOwner {
125     address roundAddress = gameLogic.finalizeRound();
126     previousRounds.push(roundAddress);
127   }
128 
129   /**
130    * Tells how many previous rounds exist.
131    */
132   function previousRoundsCount() constant returns(uint) {
133     return previousRounds.length;
134   }
135 
136   // You must think I'm a joke
137   // I ain't gonna be part of your system
138   // Man! Pump that garbage in another man's veins
139   function () {
140     throw;
141   }
142 }