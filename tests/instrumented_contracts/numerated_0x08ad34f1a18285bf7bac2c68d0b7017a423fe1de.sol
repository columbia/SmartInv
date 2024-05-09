1 pragma solidity ^0.4.18;
2 
3 interface OysterPearl {
4     function balanceOf(address _owner) public constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public;
6 }
7 //AIRDROP SALE
8 contract PearlBonus {
9     address public pearlContract = 0x1844b21593262668B7248d0f57a220CaaBA46ab9;
10     OysterPearl pearl = OysterPearl(pearlContract);
11     
12     address public director;
13     uint256 public funds;
14     bool public saleClosed;
15     
16     function PearlBonus() public {
17         director = msg.sender;
18         funds = 0;
19         saleClosed = false;
20     }
21     
22     modifier onlyDirector {
23         // Only the director is permitted
24         require(msg.sender == director);
25         _;
26     }
27     
28     /**
29      * Director can close the crowdsale
30      */
31     function closeSale() public onlyDirector returns (bool success) {
32         // The sale must be currently open
33         require(!saleClosed);
34         
35         // Lock the crowdsale
36         saleClosed = true;
37         return true;
38     }
39 
40     /**
41      * Director can open the crowdsale
42      */
43     function openSale() public onlyDirector returns (bool success) {
44         // The sale must be currently closed
45         require(saleClosed);
46         
47         // Unlock the crowdsale
48         saleClosed = false;
49         return true;
50     }
51     
52     function transfer(address _send, uint256 _amount) public onlyDirector {
53         pearl.transfer(_send, _amount);
54     }
55     
56     /**
57      * Transfers the director to a new address
58      */
59     function transferDirector(address newDirector) public onlyDirector {
60         director = newDirector;
61     }
62     
63     /**
64      * Withdraw funds from the contract (failsafe)
65      */
66     function withdrawFunds() public onlyDirector {
67         director.transfer(this.balance);
68     }
69 
70      /**
71      * Crowdsale function
72      */
73     function () public payable {
74         // Check if crowdsale is still active
75         require(!saleClosed);
76         
77         // Minimum amount is 1 finney
78         require(msg.value >= 1 finney);
79         
80         // Airdrop price is 1 ETH = 50000 PRL
81         uint256 amount = msg.value * 50000;
82         
83         require(amount <= pearl.balanceOf(this));
84         
85         pearl.transfer(msg.sender, amount);
86         
87         // Track ETH amount raised
88         funds += msg.value;
89         
90         // Auto withdraw
91         director.transfer(this.balance);
92     }
93 }