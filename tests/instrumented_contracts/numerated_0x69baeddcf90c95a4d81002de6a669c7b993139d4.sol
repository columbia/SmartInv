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
23 contract ZenswapContributeTest is Ownable {
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
36      */
37     constructor() public {
38         
39         beneficiary = msg.sender;
40         tokenReward = token(0xbaD16E6bACaF330D3615539dbf3884836071f279);
41     }
42 
43     /**
44      * Fallback function
45      *
46      * The function without name is the default function that is called whenever anyone sends funds to a contract
47      */
48     function () payable public {
49         
50         uint256 amount = msg.value;
51         uint256 tokens = amount * amountTokensPerEth;
52         require(availableTokens >= amount);
53         
54         balanceOf[msg.sender] += amount;
55         availableTokens -= tokens;
56         amountEthRaised += amount;
57         tokenReward.transfer(msg.sender, tokens);
58         beneficiary.transfer(amount);
59     }
60 
61     /**
62      * Withdraw an "amount" of available tokens in this contract
63      * 
64      */
65     function withdrawAvailableToken(address _address, uint amount) public onlyOwner {
66         require(availableTokens >= amount);
67         availableTokens -= amount;
68         tokenReward.transfer(_address, amount);
69     }
70     
71     /**
72      * Set the amount of tokens per one ether
73      * 
74      */
75     function setTokensPerEth(uint value) public onlyOwner {
76         
77         amountTokensPerEth = value;
78     }
79     
80    /**
81      * Set a token contract address and available tokens
82      * 
83      */
84     function setTokenReward(address _address, uint amount) public onlyOwner {
85         
86         tokenReward = token(_address);
87         availableTokens = amount;
88     }
89     
90    /**
91      * Set available tokens to synchronized or force halt contribution campaign
92      * 
93      */
94     function setAvailableToken(uint value) public onlyOwner {
95         
96         availableTokens = value;
97     }
98     
99    /**
100      * Returns available token 
101      * 
102      */  
103     function tokensAvailable() public constant returns (uint256) {
104         return availableTokens;
105     }
106     
107     
108 }