1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7 
8     function allowance(address owner, address spender) public view returns (uint256);
9     function transferFrom(address from, address to, uint256 value) public returns (bool);
10     function approve(address spender, uint256 value) public returns (bool);
11 
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * Owned Contract
18  * 
19  * This is a contract trait to inherit from. Contracts that inherit from Owned 
20  * are able to modify functions to be only callable by the owner of the
21  * contract.
22  * 
23  * By default it is impossible to change the owner of the contract.
24  */
25 contract Owned {
26     /**
27      * Contract owner.
28      * 
29      * This value is set at contract creation time.
30      */
31     address owner;
32 
33     /**
34      * Contract constructor.
35      * 
36      * This sets the owner of the Owned contract at the time of contract
37      * creation.
38      */
39     function Owned() public {
40         owner = msg.sender;
41     }
42 
43     /**
44      * Modify method to only allow the owner to call it.
45      */
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 }
51 
52 /**
53  * Aethia Chi Token Sale
54  * 
55  * This contract represent the 50% off sale for the in-game currency of Aethia.
56  * The normal exchange rate in-game is 0.001 ETH for 1 CHI. During the sale, the
57  * exchange rate will be 0.0005 ETH for 1 CHI.
58  * 
59  * The contract only exchanges whole (integer) values of CHI. If the sender
60  * sends a value of 0.00051 ETH, the sender will get 1 CHI and 0.00001 ETH back.
61  * 
62  * In the case not enough CHI tokens remain to fully exchange the sender's value
63  * from ETH to CHI, the remaining CHI will be paid out, and the remaining ETH
64  * will be returned to the sender.
65  */
66 contract ChiSale is Owned {
67     /**
68      * The CHI token contract.
69      */
70     ERC20 chiTokenContract;
71 
72     /**
73      * The start date of the CHI sale in seconds since the UNIX epoch.
74      * 
75      * This is equivalent to February 17th, 12:00:00 UTC.
76      */
77     uint256 constant START_DATE = 1518868800;
78 
79     /**
80      * The end date of the CHI sale in seconds since the UNIX epoch.
81      * 
82      * This is equivalent to February 19th, 12:00:00 UTC.
83      */
84     uint256 constant END_DATE = 1519041600;
85 
86     /**
87      * The price per CHI token in ETH.
88      */
89     uint256 tokenPrice = 0.0005 ether;
90     
91     /**
92      * The number of Chi tokens for sale.
93      */
94     uint256 tokensForSale = 10000000;
95 
96     /**
97      * Chi token sale event.
98      * 
99      * For audit and logging purposes, all chi token sales are logged by 
100      * acquirer.
101      */
102     event LogChiSale(address indexed _acquirer, uint256 _amount);
103 
104     /**
105      * Contract constructor.
106      * 
107      * This passes the address of the Chi token contract address to the
108      * Chi sale contract. Additionally it sets the owner to the contract 
109      * creator.
110      */
111     function ChiSale(address _chiTokenAddress) Owned() public {
112         chiTokenContract = ERC20(_chiTokenAddress);
113     }
114 
115     /**
116      * Buy Chi tokens.
117      * 
118      * The cost of a Chi token during the sale is 0.0005 ether per token. This
119      * contract accepts any amount equal to or above 0.0005 ether. It tries to
120      * exchange as many Chi tokens for the sent value as possible. The remaining
121      * ether is sent back.
122      *
123      * In the case where not enough Chi tokens are available for the to exchange
124      * for the entirety of the sent value, an attempt will be made to exchange
125      * as much as possible. The remaining ether is then sent back.
126      * 
127      * The sale starts at February 17th, 12:00:00 UTC, and ends at February
128      * 19th, 12:00:00 UTC, lasting a total of 48 hours. Transactions that occur
129      * outside this time period are rejected.
130      */
131     function buy() payable external {
132         require(START_DATE <= now);
133         require(END_DATE >= now);
134         require(tokensForSale > 0);
135         require(msg.value >= tokenPrice);
136 
137         uint256 tokens = msg.value / tokenPrice;
138         uint256 remainder;
139 
140         // If there aren't enough tokens to exchange, try to exchange as many
141         // as possible, and pay out the remainder. Else, if there are enough
142         // tokens, pay the remaining ether that couldn't be exchanged for tokens 
143         // back to the sender.
144         if (tokens > tokensForSale) {
145             tokens = tokensForSale;
146 
147             remainder = msg.value - tokens * tokenPrice;
148         } else {
149             remainder = msg.value % tokenPrice;
150         }
151         
152         tokensForSale -= tokens;
153 
154         LogChiSale(msg.sender, tokens);
155 
156         chiTokenContract.transfer(msg.sender, tokens);
157 
158         if (remainder > 0) {
159             msg.sender.transfer(remainder);
160         }
161     }
162 
163     /**
164      * Fallback payable method.
165      *
166      * This is in the case someone calls the contract without specifying the
167      * correct method to call. This method will ensure the failure of a
168      * transaction that was wrongfully executed.
169      */
170     function () payable external {
171         revert();
172     }
173 
174     /**
175      * Withdraw all funds from contract.
176      * 
177      * Additionally, this moves all remaining Chi tokens back to the original
178      * owner to be used for redistribution.
179      */
180     function withdraw() onlyOwner external {
181         uint256 currentBalance = chiTokenContract.balanceOf(this);
182 
183         chiTokenContract.transfer(owner, currentBalance);
184 
185         owner.transfer(this.balance);
186     }
187     
188     function remainingTokens() external view returns (uint256) {
189         return tokensForSale;
190     }
191 }