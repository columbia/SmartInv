1 pragma solidity ^0.4.18;
2 
3 contract Etheriumx{
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6 
7     string public name = "Etheriumx";
8     string public symbol = "ETHX";
9     uint256 public max_supply = 4200000000000000;
10     uint256 public unspent_supply = 0;
11     uint256 public spendable_supply = 0;
12     uint256 public circulating_supply = 0;
13     uint256 public decimals = 18;
14     uint256 public reward = 500000000000;
15     uint256 public timeOfLastHalving = now;
16     uint public timeOfLastIncrease = now;
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Mint(address indexed from, uint256 value);
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function howCoin() public {
23       timeOfLastHalving = now;
24     }
25 
26     function updateSupply() internal returns (uint256) {
27 
28       if (now - timeOfLastHalving >= 2100000 minutes) {
29         reward /= 2;
30         timeOfLastHalving = now;
31       }
32 
33       if (now - timeOfLastIncrease >= 150 seconds) {
34         uint256 increaseAmount = ((now - timeOfLastIncrease) / 150 seconds) * reward;
35         spendable_supply += increaseAmount;
36         unspent_supply += increaseAmount;
37         timeOfLastIncrease = now;
38       }
39 
40       circulating_supply = spendable_supply - unspent_supply;
41 
42       return circulating_supply;
43     }
44 
45     /* Send coins */
46     function transfer(address _to, uint256 _value) public {
47         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
48         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
49         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
50         balanceOf[_to] += _value;                           // Add the same to the recipient
51 
52         updateSupply();
53 
54         /* Notify anyone listening that the transfer took place */
55         Transfer(msg.sender, _to, _value);
56 
57     }
58     /* Mint new coins by sending ether */
59     function mint() public payable {
60         require(balanceOf[msg.sender] + _value >= balanceOf[msg.sender]); // Check for overflows
61         uint256 _value = msg.value / 100000000;
62 
63         updateSupply();
64 
65         require(unspent_supply - _value <= unspent_supply);
66         unspent_supply -= _value; // Remove from unspent supply
67         balanceOf[msg.sender] += _value; // Add the same to the recipient
68 
69         updateSupply();
70 
71         /* Notify anyone listening that the minting took place */
72         Mint(msg.sender, _value);
73 
74     }
75 
76     function withdraw(uint256 amountToWithdraw) public returns (bool) {
77 
78         // Balance given in HOW
79 
80         require(balanceOf[msg.sender] >= amountToWithdraw);
81         require(balanceOf[msg.sender] - amountToWithdraw <= balanceOf[msg.sender]);
82 
83         // Balance checked in HOW, then converted into Wei
84         balanceOf[msg.sender] -= amountToWithdraw;
85 
86         // Added back to supply in HOW
87         unspent_supply += amountToWithdraw;
88         // Converted into Wei
89         amountToWithdraw *= 100000000;
90 
91         // Transfered in Wei
92         msg.sender.transfer(amountToWithdraw);
93 
94         updateSupply();
95 
96         return true;
97     }
98 }