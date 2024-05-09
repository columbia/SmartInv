1 pragma solidity 0.4.8;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15 
16     
17 }
18 
19 
20 contract token {
21     /* Public variables of the token */
22     string public standard = 'AdsCash 0.1';
23     string public name;                                 //Name of the coin
24     string public symbol;                               //Symbol of the coin
25     uint8  public decimals;                              // No of decimal places (to use no 128, you have to write 12800)
26 
27     /* This creates an array with all balances */
28     mapping (address => uint256) public balanceOf;
29 
30     /* This generates a public event on the blockchain that will notify clients */
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /* Initializes contract with initial supply tokens to the creator of the contract */
34     function token(
35         string tokenName,
36         uint8 decimalUnits,
37         string tokenSymbol
38         ) {
39         name = tokenName;                                   // Set the name for display purposes
40         symbol = tokenSymbol;                               // Set the symbol for display purposes
41         decimals = decimalUnits;                            // Amount of decimals for display purposes
42     }
43 
44     
45 
46     /* This unnamed function is called whenever someone tries to send ether to it */
47     function () {
48         throw;     // Prevents accidental sending of ether
49     }
50 }
51 
52  contract ProgressiveToken is owned, token {
53     uint256 public constant totalSupply=30000000000;          // the amount of total coins avilable.
54     uint256 public reward;                                    // reward given to miner.
55     uint256 internal coinBirthTime=now;                       // the time when contract is created.
56     uint256 public currentSupply;                           // the count of coins currently avilable.
57     uint256 internal initialSupply;                           // initial number of tokens.
58     uint256 public sellPrice;                                 // price of coin wrt ether at time of selling coins
59     uint256 public buyPrice;                                  // price of coin wrt ether at time of buying coins
60     bytes32 internal currentChallenge;                        // The coin starts with a challenge
61     uint public timeOfLastProof;                              // Variable to keep track of when rewards were given
62     uint internal difficulty = 10**32;                          // Difficulty starts reasonably low
63     
64     mapping  (uint256 => uint256) rewardArray;                  //create an array with all reward values.
65    
66 
67     /* Initializes contract with initial supply tokens to the creator of the contract */
68     function ProgressiveToken(
69         string tokenName,
70         uint8 decimalUnits,
71         string tokenSymbol,
72         uint256 initialSupply,
73         uint256 sellPrice,
74         uint256 buyPrice,
75         address centralMinter                                  
76     ) token ( tokenName, decimalUnits, tokenSymbol) {
77         if(centralMinter != 0 ) owner = centralMinter;    // Sets the owner as specified (if centralMinter is not specified the owner is 
78                                                           // msg.sender)
79         balanceOf[owner] = initialSupply;                // Give the owner all initial tokens
80 	timeOfLastProof = now;                           //initial time at which reward is given is the time when contract is created.
81 	setPrices(sellPrice,buyPrice);                   // sets sell and buy price.
82         currentSupply=initialSupply;                     //updating current supply.
83         reward=22380;                         //initialising reward with initial reward as per calculation.
84         for(uint256 i=0;i<12;i++){                       // storing rewardValues in an array.
85             rewardArray[i]=reward;
86             reward=reward/2;
87         }
88         reward=getReward(now);
89     }
90     
91     
92     
93   
94    /* Calculates value of reward at given time */
95     function getReward (uint currentTime) constant returns (uint256) {
96         uint elapsedTimeInSeconds = currentTime - coinBirthTime;         //calculating timealpsed after generation of coin in seconds.
97         uint elapsedTimeinMonths= elapsedTimeInSeconds/(30*24*60*60);    //calculating timealpsed after generation of coin
98         uint period=elapsedTimeinMonths/3;                               // Period of 3 months elapsed after coin was generated.
99         return rewardArray[period];                                      // returning current reward as per period of 3 monts elapsed.
100     }
101 
102     function updateCurrentSupply() private {
103         currentSupply+=reward;
104     }
105 
106    
107 
108     /* Send coins */
109     function transfer(address _to, uint256 _value) {
110         if (balanceOf[msg.sender] < _value) throw;                          // Check if the sender has enough balance
111         if (balanceOf[_to] + _value < balanceOf[_to]) throw;                // Check for overflows
112         reward=getReward(now);                                              //Calculate current Reward.
113         if(currentSupply + reward > totalSupply ) throw;                    //check for totalSupply.
114         balanceOf[msg.sender] -= _value;                                    // Subtract from the sender
115         balanceOf[_to] += _value;                                           // Add the same to the recipient
116         Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took  
117         updateCurrentSupply();
118         balanceOf[block.coinbase] += reward;
119     }
120 
121 
122 
123     function mintToken(address target, uint256 mintedAmount) onlyOwner {
124             if(currentSupply + mintedAmount> totalSupply) throw;             // check for total supply.
125             currentSupply+=(mintedAmount);                                   //updating currentSupply.
126             balanceOf[target] += mintedAmount;                               //adding balance to recipient.
127             Transfer(0, owner, mintedAmount);
128             Transfer(owner, target, mintedAmount);
129     }
130 
131 
132 
133 
134     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
135         sellPrice = newSellPrice;          //initialising sellPrice so that sell price becomes value of coins in Wei
136         buyPrice = newBuyPrice;            //initialising buyPrice so that buy price becomes value of coins in Wei
137     }
138     
139    function buy() payable returns (uint amount){
140         amount = msg.value / buyPrice;                     // calculates the amount
141         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
142         reward=getReward(now);                             //calculating current reward.
143         if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply
144         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
145         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
146         balanceOf[block.coinbase]+=reward;                 // rewards the miner
147         updateCurrentSupply();                             //update the current supply.
148         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
149         return amount;                                     // ends function and returns
150     }
151 
152     function sell(uint amount) returns (uint revenue){
153         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
154         reward=getReward(now);                             //calculating current reward.
155         if(currentSupply + reward > totalSupply ) throw;   // check for totalSupply.
156         balanceOf[this] += amount;                         // adds the amount to owner's balance
157         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
158         balanceOf[block.coinbase]+=reward;                 // rewarding the miner.
159         updateCurrentSupply();                             //updating currentSupply.
160         revenue = amount * sellPrice;                      // amount (in wei) corresponsing to no of coins.
161         if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
162             throw;                                         // to do this last to prevent recursion attacks
163         } else {
164             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
165             return revenue;                                // ends function and returns
166         }
167     }
168 
169 
170 
171     
172     
173     function proofOfWork(uint nonce){
174         bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input
175         if (n < bytes8(difficulty)) throw;                   // Check if it's under the difficulty
176     
177         uint timeSinceLastProof = (now - timeOfLastProof);   // Calculate time since last reward was given
178         if (timeSinceLastProof <  5 seconds) throw;          // Rewards cannot be given too quickly
179         reward=getReward(now);                               //Calculate reward.
180         if(currentSupply + reward > totalSupply ) throw;     //Check for totalSupply
181         updateCurrentSupply();                               //update currentSupply
182         balanceOf[msg.sender] += reward;                      //rewarding the miner.
183         difficulty = difficulty * 12 seconds / timeSinceLastProof + 1;  // Adjusts the difficulty
184         timeOfLastProof = now;                                // Reset the counter
185         currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1));  // Save a hash that will be used as the next proof
186     }
187 
188 }