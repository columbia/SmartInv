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
20         partner = 0x36B786f3EC7DE8aC4878980f4B021DE62DDDFF41;
21         share = 4;
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
32     /**
33      * Director can close the crowdsale
34      */
35     function closeSale() public onlyDirector returns (bool success) {
36         // The sale must be currently open
37         require(!saleClosed);
38         
39         // Lock the crowdsale
40         saleClosed = true;
41         return true;
42     }
43 
44     /**
45      * Director can open the crowdsale
46      */
47     function openSale() public onlyDirector returns (bool success) {
48         // The sale must be currently closed
49         require(saleClosed);
50         
51         // Unlock the crowdsale
52         saleClosed = false;
53         return true;
54     }
55     
56     function transfer(address _send, uint256 _amount) public onlyDirector {
57         pearl.transfer(_send, _amount);
58     }
59     
60     /**
61      * Transfers the director to a new address
62      */
63     function transferDirector(address newDirector) public onlyDirector {
64         director = newDirector;
65     }
66     
67     /**
68      * Withdraw funds from the contract (failsafe)
69      */
70     function withdrawFunds() public onlyDirector {
71         director.transfer(this.balance);
72     }
73 
74      /**
75      * Crowdsale function
76      */
77     function () public payable {
78         // Check if crowdsale is still active
79         require(!saleClosed);
80         
81         // Minimum amount is 1 finney
82         require(msg.value >= 1 finney);
83         
84         // Price is 1 ETH = 6000 PRL
85         uint256 amount = msg.value * 6000;
86         
87         require(amount <= pearl.balanceOf(this));
88         
89         pearl.transfer(msg.sender, amount);
90         
91         // Track ETH amount raised
92         funds += msg.value;
93         
94         // Auto withdraw
95         uint256 partnerShare = (this.balance / 100) * share;
96         director.transfer(this.balance - partnerShare);
97         partner.transfer(partnerShare);
98     }
99 }