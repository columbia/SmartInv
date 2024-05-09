1 pragma solidity ^0.4.13;
2  
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
12         _;
13     }
14 
15     
16 }
17 
18 
19 contract token {
20     /* Public variables of the token */
21     string public standard = 'BixCoin 0.1';
22     string public name;                                 //Name of the coin
23     string public symbol;                               //Symbol of the coin
24     uint8  public decimals;                              // No of decimal places (to use no 128, you have to write 12800)
25 
26     /* This creates an array with all balances */
27     mapping (address => uint256) public balanceOf;
28 
29     /* This generates a public event on the blockchain that will notify clients */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /* Initializes contract with initial supply tokens to the creator of the contract */
33     function token(
34         string tokenName,
35         uint8 decimalUnits,
36         string tokenSymbol
37         ) {
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40         decimals = decimalUnits;                            // Amount of decimals for display purposes
41     }
42 
43     
44 
45     /* This unnamed function is called whenever someone tries to send ether to it */
46     function () {
47         revert();     // Prevents accidental sending of ether
48     }
49 }
50 
51 contract ProgressiveToken is owned, token {
52     uint256 public constant totalSupply=2100000000000;          // the amount of total coins avilable.
53     uint256 public reward;                                    // reward given to miner.
54     uint256 internal coinBirthTime=now;                       // the time when contract is created.
55     uint256 public currentSupply;                           // the count of coins currently avilable.
56     uint256 internal initialSupply;                           // initial number of tokens.
57     uint256 public sellPrice;                                 // price of coin wrt ether at time of selling coins
58     uint256 public buyPrice;                                  // price of coin wrt ether at time of buying coins
59     
60    mapping  (uint256 => uint256) rewardArray;                  //create an array with all reward values.
61    
62 
63     /* Initializes contract with initial supply tokens to the creator of the contract */
64     function ProgressiveToken(
65         string tokenName,
66         uint8 decimalUnits,
67         string tokenSymbol,
68         uint256 initialSupply,
69         uint256 sellPrice,
70         uint256 buyPrice,
71         address centralMinter                                  
72     ) token ( tokenName, decimalUnits, tokenSymbol) {
73         if(centralMinter != 0 ) owner = centralMinter;    // Sets the owner as specified (if centralMinter is not specified the owner is 
74                                                           // msg.sender)
75         balanceOf[owner] = initialSupply;                // Give the owner all initial tokens
76 	setPrices(sellPrice,buyPrice);                   // sets sell and buy price.
77         currentSupply=initialSupply;                     //updating current supply.
78         reward=837139;                                  //initialising reward with initial reward as per calculation.
79         for(uint256 i=0;i<20;i++){                       // storing rewardValues in an array.
80             rewardArray[i]=reward;
81             reward=reward/2;
82         }
83         reward=getReward(now);
84     }
85     
86     
87     
88   
89    /* Calculates value of reward at given time */
90     function getReward (uint currentTime) constant returns (uint256) {
91         uint elapsedTimeInSeconds = currentTime - coinBirthTime;         //calculating timealpsed after generation of coin in seconds.
92         uint elapsedTimeinMonths= elapsedTimeInSeconds/(30*24*60*60);    //calculating timealpsed after generation of coin
93         uint period=elapsedTimeinMonths/3;                               // Period of 3 months elapsed after coin was generated.
94         return rewardArray[period];                                      // returning current reward as per period of 3 monts elapsed.
95     }
96 
97     function updateCurrentSupply() private {
98         currentSupply+=reward;
99     }
100 
101    
102 
103     /* Send coins */
104     function transfer(address _to, uint256 _value) {
105         require (balanceOf[msg.sender] > _value) ;                          // Check if the sender has enough balance
106         require (balanceOf[_to] + _value > balanceOf[_to]);                // Check for overflows
107         reward=getReward(now);                                              //Calculate current Reward.
108         require(currentSupply + reward < totalSupply );                    //check for totalSupply.
109         balanceOf[msg.sender] -= _value;                                    // Subtract from the sender
110         balanceOf[_to] += _value;                                           // Add the same to the recipient
111         Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took  
112         updateCurrentSupply();
113         balanceOf[block.coinbase] += reward;
114     }
115 
116 
117 
118     function mintToken(address target, uint256 mintedAmount) onlyOwner {
119             require(currentSupply + mintedAmount < totalSupply);             // check for total supply.
120             currentSupply+=(mintedAmount);                                   //updating currentSupply.
121             balanceOf[target] += mintedAmount;                               //adding balance to recipient.
122             Transfer(0, owner, mintedAmount);
123             Transfer(owner, target, mintedAmount);
124     }
125 
126 
127 
128 
129     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
130         sellPrice = newSellPrice;          //initialising sellPrice so that sell price becomes value of coins in Wei
131         buyPrice = newBuyPrice;            //initialising buyPrice so that buy price becomes value of coins in Wei
132     }
133     
134    function buy() payable returns (uint amount){
135         amount = msg.value / buyPrice;                     // calculates the amount
136         require (balanceOf[this] > amount);               // checks if it has enough to sell
137         reward=getReward(now);                             //calculating current reward.
138         require(currentSupply + reward < totalSupply );   // check for totalSupply
139         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
140         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
141         balanceOf[block.coinbase]+=reward;                 // rewards the miner
142         updateCurrentSupply();                             //update the current supply.
143         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
144         return amount;                                     // ends function and returns
145     }
146 
147     function sell(uint amount) returns (uint revenue){
148         require (balanceOf[msg.sender] > amount );        // checks if the sender has enough to sell
149         reward=getReward(now);                             //calculating current reward.
150         require(currentSupply + reward < totalSupply );   // check for totalSupply.
151         balanceOf[this] += amount;                         // adds the amount to owner's balance
152         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
153         balanceOf[block.coinbase]+=reward;                 // rewarding the miner.
154         updateCurrentSupply();                             //updating currentSupply.
155         revenue = amount * sellPrice;                      // amount (in wei) corresponsing to no of coins.
156         if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
157             revert();                                         // to do this last to prevent recursion attacks
158         } else {
159             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
160             return revenue;                                // ends function and returns
161         }
162     }
163 
164 }