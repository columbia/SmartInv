1 pragma solidity ^0.4.18;
2 
3 interface OysterPearl {
4     function balanceOf(address _owner) public constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public;
6 }
7 
8 contract PearlBonus {
9     address public pearlContract = 0x1844b21593262668B7248d0f57a220CaaBA46ab9;
10     OysterPearl pearl = OysterPearl(pearlContract);
11     
12     address public director;
13     address public partner;
14     uint8 public share;
15     uint256 public funds;
16     bool public saleClosed;
17     
18     function PearlBonus() public {
19         director = msg.sender;
20         partner = 0x5F5E3bc34347e1f10C7a0E932871D8DbFBEF9f87;
21         share = 10;
22         funds = 0;
23         saleClosed = false;
24     }
25     
26     modifier onlyDirector {
27         // Only the director is permitted
28         require(msg.sender == director);
29         _;
30     }
31     
32     modifier onlyPartner {
33         // Only the partner is permitted
34         require(msg.sender == partner);
35         _;
36     }
37     
38     /**
39      * Director can close the crowdsale
40      */
41     function closeSale() public onlyDirector returns (bool success) {
42         // The sale must be currently open
43         require(!saleClosed);
44         
45         // Lock the crowdsale
46         saleClosed = true;
47         return true;
48     }
49 
50     /**
51      * Director can open the crowdsale
52      */
53     function openSale() public onlyDirector returns (bool success) {
54         // The sale must be currently closed
55         require(saleClosed);
56         
57         // Unlock the crowdsale
58         saleClosed = false;
59         return true;
60     }
61     
62     function rescue(address _send, uint256 _amount) public onlyDirector {
63         pearl.transfer(_send, _amount);
64     }
65     
66     /**
67      * Transfers the director to a new address
68      */
69     function transferDirector(address newDirector) public onlyDirector {
70         director = newDirector;
71     }
72     
73     /**
74      * Transfers the partner to a new address
75      */
76     function transferPartner(address newPartner) public onlyPartner {
77         director = newPartner;
78     }
79     
80     /**
81      * Withdraw funds from the contract (failsafe)
82      */
83     function withdrawFunds() public onlyDirector {
84         director.transfer(this.balance);
85     }
86 
87      /**
88      * Crowdsale function
89      */
90     function () public payable {
91         // Check if crowdsale is still active
92         require(!saleClosed);
93         
94         // Minimum amount is 1 finney
95         require(msg.value >= 1 finney);
96         
97         // Price is 1 ETH = 50,000 PRL
98         uint256 amount = msg.value * 50000;
99         
100         require(amount <= pearl.balanceOf(this));
101         
102         pearl.transfer(msg.sender, amount);
103         
104         // Track ETH amount raised
105         funds += msg.value;
106         
107         // Auto withdraw
108         uint256 partnerShare = (this.balance / 100) * share;
109         director.transfer(this.balance - partnerShare);
110         partner.transfer(partnerShare);
111     }
112 }