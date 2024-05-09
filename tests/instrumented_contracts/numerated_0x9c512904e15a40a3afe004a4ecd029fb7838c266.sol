1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 contract CandyContract is owned{
25 
26     token public tokenReward;
27     uint public totalCandyNo; 
28 
29     address public collectorAddress;
30     mapping(address => uint256) public balanceOf;
31 
32     event GoalReached(address recipient, uint totalAmountRaised);
33     event FundTransfer(address backer, uint amount, bool isContribution);
34 
35     /**
36      * Constructor function
37      */
38     constructor(
39         address addressOfTokenUsedAsReward,
40         address collector
41     ) public {
42         totalCandyNo = 1e6;
43         tokenReward = token(addressOfTokenUsedAsReward);
44         collectorAddress = collector;
45     }
46 
47     /**
48      * Fallback function
49      *
50      * The function without name is the default function that is called whenever anyone sends funds to a contract
51      */
52     function () payable public {
53         require(totalCandyNo > 0);
54         uint amount = getCurrentCandyAmount();
55         require(amount > 0); 
56         require(balanceOf[msg.sender] == 0);
57 
58         totalCandyNo -= amount;
59         balanceOf[msg.sender] = amount;
60 
61         tokenReward.transfer(msg.sender, amount * 1e8);
62         emit FundTransfer(msg.sender, amount, true);
63     }
64 
65     function getCurrentCandyAmount() private view returns (uint amount){
66 
67         if (totalCandyNo >= 7.5e5){
68             return 200;
69         }else if (totalCandyNo >= 5e5){
70             return 150;
71         }else if (totalCandyNo >= 2.5e5){
72             return 100;
73         }else if (totalCandyNo >= 50){
74             return 50;
75         }else{
76             return 0;
77         }
78     }
79 
80     function collectBack() onlyOwner public{
81 
82         require(totalCandyNo > 0);
83 
84         require(collectorAddress != 0x0);
85 
86         tokenReward.transfer(collectorAddress, totalCandyNo * 1e8);
87         totalCandyNo = 0;
88 
89     }
90 }