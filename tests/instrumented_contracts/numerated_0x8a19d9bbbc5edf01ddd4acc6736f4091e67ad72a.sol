1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5     function safeMul(uint a, uint b) internal pure returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint a, uint b) internal pure returns (uint) {
12         require(b > 0);
13         uint c = a / b;
14         require(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint a, uint b) internal pure returns (uint) {
19         require(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint a, uint b) internal pure returns (uint) {
24         uint c = a + b;
25         require(c >= a && c >= b);
26         return c;
27     }
28 }
29 
30 contract AlsToken {
31     function balanceOf(address _owner) public constant returns (uint256);
32     function transfer(address receiver, uint amount) public;
33 }
34 
35 contract Owned {
36 
37     address internal owner;
38 
39     function Owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require (msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) external onlyOwner {
49         owner = newOwner;
50     }
51 
52     function getOwner() public constant returns (address currentOwner) {
53         return owner;
54     }
55 }
56 
57 contract AlsIco is Owned, SafeMath {
58 
59     // Crowdsale start time in seconds since epoch.
60     // Equivalent to Wednesday, December 20th 2017, 3 pm London time.
61     uint256 public constant crowdsaleStartTime = 1513782000;
62 
63     // Crowdsale end time in seconds since epoch.
64     // Equivalent to Tuesday, February 20th 2018, 3 pm London time.
65     uint256 public constant crowdsaleEndTime = 1519138800;
66 
67     // One thousand ALS with 18 decimals [10 to the power of 21 (3 + 18) tokens].
68     uint256 private constant oneThousandAls = uint256(10) ** 21;
69 
70     uint public amountRaised;
71     uint public tokensSold;
72     AlsToken public alsToken;
73 
74     event FundTransfer(address backer, uint amount, bool isContribution);
75 
76     function AlsIco() public {
77         alsToken = AlsToken(0xbCeC57361649E5dA917efa9F992FBCA0a2529350);
78     }
79 
80     modifier onlyAfterStart() {
81         require(now >= crowdsaleStartTime);
82         _;
83     }
84 
85     modifier onlyBeforeEnd() {
86         require(now <= crowdsaleEndTime);
87         _;
88     }
89 
90     // Returns how many ALS are given in exchange for 1 ETH.
91     function getPrice() public constant onlyAfterStart onlyBeforeEnd returns (uint256) {
92         if (tokensSold < 1600 * oneThousandAls) {
93             // Firs 2% (equivalent to first 1.600.000 ALS) get 70% bonus (equivalent to 17000 ALS per 1 ETH).
94             return 17000;
95         } else if (tokensSold < 8000 * oneThousandAls) {
96             // Firs 10% (equivalent to first 8.000.000 ALS) get 30% bonus (equivalent to 13000 ALS per 1 ETH).
97             return 13000;
98         } else if (tokensSold < 16000 * oneThousandAls) {
99             // Firs 20% (equivalent to first 16.000.000 ALS) get 10% bonus (equivalent to 11000 ALS per 1 ETH).
100             return 11000;
101         } else if (tokensSold < 40000 * oneThousandAls) {
102             // Firs 50% (equivalent to first 40.000.000 ALS) get 5% bonus (equivalent to 10500 ALS per 1 ETH).
103             return 10500;
104         } else {
105             // The rest of the tokens (after 50%) will be sold without a bonus.
106             return 10000;
107         }
108     }
109 
110     function () payable public onlyAfterStart onlyBeforeEnd {
111         uint256 availableTokens = alsToken.balanceOf(this);
112         require (availableTokens > 0);
113 
114         uint256 etherAmount = msg.value;
115         require(etherAmount > 0);
116 
117         uint256 price = getPrice();
118         uint256 tokenAmount = safeMul(etherAmount, price);
119 
120         if (tokenAmount <= availableTokens) {
121             amountRaised = safeAdd(amountRaised, etherAmount);
122             tokensSold = safeAdd(tokensSold, tokenAmount);
123 
124             alsToken.transfer(msg.sender, tokenAmount);
125             FundTransfer(msg.sender, etherAmount, true);
126         } else {
127             uint256 etherToSpend = safeDiv(availableTokens, price);
128             amountRaised = safeAdd(amountRaised, etherToSpend);
129             tokensSold = safeAdd(tokensSold, availableTokens);
130 
131             alsToken.transfer(msg.sender, availableTokens);
132             FundTransfer(msg.sender, etherToSpend, true);
133 
134             // Return the rest of the funds back to the caller.
135             uint256 amountToRefund = safeSub(etherAmount, etherToSpend);
136             msg.sender.transfer(amountToRefund);
137         }
138     }
139 
140     function withdrawEther(uint _amount) external onlyOwner {
141         require(this.balance >= _amount);
142         owner.transfer(_amount);
143         FundTransfer(owner, _amount, false);
144     }
145 }