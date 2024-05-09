1 pragma solidity ^0.4.13;
2 contract token { 
3    function mintToken(address target, uint256 mintedAmount);
4 }
5 
6 contract owned { 
7     address public owner;
8     
9     function owned() {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21 }
22 
23 contract Crowdsale is owned {
24     address public beneficiary;
25     
26     uint256 public preICOLimit;
27     uint256 public totalLimit;
28     
29     uint256 public pricePreICO;
30     uint256 public priceICO;
31 
32     bool preICOClosed = false;
33     bool ICOClosed = false;
34 
35     bool preICOWithdrawn = false;
36     bool ICOWithdrawn = false;
37 
38     bool public preICOActive = false;
39     bool public ICOActive = false;
40 
41     uint256 public preICORaised; 
42     uint256 public ICORaised; 
43     uint256 public totalRaised; 
44 
45     token public tokenReward;
46 
47     event FundTransfer(address backer, uint256 amount, bool isContribution);
48 
49     mapping(address => uint256) public balanceOf;
50 
51     function Crowdsale() {
52         preICOLimit = 5000000 * 1 ether;
53         totalLimit = 45000000 * 1 ether; //50m hard cap minus 2.5m for mining and minus 2.5m for bounty
54         pricePreICO = 375;
55         priceICO = 250;
56     }
57 
58     function init(address beneficiaryAddress, token tokenAddress)  onlyOwner {
59         beneficiary = beneficiaryAddress;
60         tokenReward = token(tokenAddress);
61     }
62 
63     function () payable {
64         require (preICOActive || ICOActive);
65         uint256 amount = msg.value;
66 
67         require (amount >= 0.05 * 1 ether); //0.05 - minimum contribution limit
68 
69         //mintToken method will work only for owner of the token.
70         //So we need to execute transferOwnership from the token contract and pass ICO contract address as a parameter.
71         //By doing so we will lock minting function to ICO contract only (so no minting will be available after ICO).
72         if(preICOActive)
73         {
74     	    tokenReward.mintToken(msg.sender, amount * pricePreICO);
75             preICORaised += amount;
76         }
77         if(ICOActive)
78         {
79     	    tokenReward.mintToken(msg.sender, amount * priceICO);
80             ICORaised += amount;
81         }
82 
83         balanceOf[msg.sender] += amount;
84         totalRaised += amount;
85         FundTransfer(msg.sender, amount, true);
86 
87         if(preICORaised >= preICOLimit)
88         {
89             preICOActive = false;
90             preICOClosed = true;
91         }
92         
93         if(totalRaised >= totalLimit)
94         {
95             preICOActive = false;
96             ICOActive = false;
97             preICOClosed = true;
98             ICOClosed = true;
99         }
100     }
101     
102     function startPreICO() onlyOwner {
103         require(!preICOClosed);
104         require(!preICOActive);
105         require(!ICOClosed);
106         require(!ICOActive);
107         
108         preICOActive = true;
109     }
110     function stopPreICO() onlyOwner {
111         require(preICOActive);
112         
113         preICOActive = false;
114         preICOClosed = true;
115     }
116     function startICO() onlyOwner {
117         require(preICOClosed);
118         require(!ICOClosed);
119         require(!ICOActive);
120         
121         ICOActive = true;
122     }
123     function stopICO() onlyOwner {
124         require(ICOActive);
125         
126         ICOActive = false;
127         ICOClosed = true;
128     }
129 
130 
131     //withdrawal raised funds to beneficiary
132     function withdrawFunds() onlyOwner {
133 	require ((!preICOWithdrawn && preICOClosed) || (!ICOWithdrawn && ICOClosed));
134 
135             //withdraw results of preICO
136             if(!preICOWithdrawn && preICOClosed)
137             {
138                 if (beneficiary.send(preICORaised)) {
139                     preICOWithdrawn = true;
140                     FundTransfer(beneficiary, preICORaised, false);
141                 }
142             }
143             //withdraw results of ICO
144             if(!ICOWithdrawn && ICOClosed)
145             {
146                 if (beneficiary.send(ICORaised)) {
147                     ICOWithdrawn = true;
148                     FundTransfer(beneficiary, ICORaised, false);
149                 }
150             }
151     }
152 }