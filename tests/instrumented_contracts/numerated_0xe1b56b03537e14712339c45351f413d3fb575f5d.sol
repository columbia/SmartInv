1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 
8 contract Ownable {
9 
10     address public owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20     
21 }
22 
23 contract ZenswapContribution is Ownable {
24     
25     address public beneficiary;
26     uint256 public amountTokensPerEth = 200000000;
27     uint256 public amountEthRaised = 0;
28     uint256 public availableTokens;
29     token public tokenReward;
30     mapping(address => uint256) public balanceOf;
31     
32     
33     /**
34      * Constructor function
35      *
36      * Set beneficiary and set the token smart contract address
37      */
38     constructor() public {
39         
40         beneficiary = msg.sender;
41         tokenReward = token(0x0D1C63E12fDE9e5cADA3E272576183AbA9cfedA2);
42     }
43 
44     /**
45      * Fallback function
46      *
47      * The function without name is the default function that is called whenever anyone sends funds to a contract
48      */
49     function () payable public {
50         
51         uint256 amount = msg.value;
52         uint256 tokens = amount * amountTokensPerEth;
53         require(availableTokens >= amount);
54         
55         balanceOf[msg.sender] += amount;
56         availableTokens -= tokens;
57         amountEthRaised += amount;
58         tokenReward.transfer(msg.sender, tokens);
59         beneficiary.transfer(amount);
60     }
61 
62     /**
63      * Withdraw an "amount" of available tokens in the contract
64      * 
65      */
66     function withdrawAvailableToken(address _address, uint amount) public onlyOwner {
67         require(availableTokens >= amount);
68         availableTokens -= amount;
69         tokenReward.transfer(_address, amount);
70     }
71     
72     /**
73      * Set the amount of tokens per one ether
74      * 
75      */
76     function setTokensPerEth(uint value) public onlyOwner {
77         
78         amountTokensPerEth = value;
79     }
80     
81    /**
82      * Set a token contract address and available tokens and the available tokens
83      * 
84      */
85     function setTokenReward(address _address, uint amount) public onlyOwner {
86         
87         tokenReward = token(_address);
88         availableTokens = amount;
89     }
90     
91    /**
92      * Set available tokens to synchronized values or force to stop contribution campaign
93      * 
94      */
95     function setAvailableToken(uint value) public onlyOwner {
96         
97         availableTokens = value;
98     }
99     
100     
101     
102 }