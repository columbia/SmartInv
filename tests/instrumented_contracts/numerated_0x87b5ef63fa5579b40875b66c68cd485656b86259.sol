1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-02
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity 0.7.5;
7 
8 interface IERC20Token {
9     function balanceOf(address owner) external returns (uint256);
10     function transfer(address to, uint256 amount) external returns (bool);
11     function decimals() external returns (uint256);
12 }
13 
14 
15 contract Owned {
16     address payable public owner;
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19 
20     constructor() {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function transferOwnership(address payable _newOwner) public onlyOwner {
30         require(_newOwner != address(0), "ERC20: sending to the zero address");
31         owner = _newOwner;
32         emit OwnershipTransferred(msg.sender, _newOwner);
33     }
34 }
35 
36 
37 contract TokenSale is Owned{
38     IERC20Token public tokenContract;  // the token being sold
39     uint256 public price = 500;              // 1eth = 500 tokens
40     uint256 public decimals = 18;
41     
42     uint256 public tokensSold;
43     uint256 public ethRaised;
44     uint256 public MaxETHAmount;
45 
46     event Sold(address buyer, uint256 amount);
47 
48     constructor(IERC20Token _tokenContract, uint256 _maxEthAmount) {
49         owner = msg.sender;
50         tokenContract = _tokenContract;
51         MaxETHAmount = _maxEthAmount;
52     }
53     
54     fallback() external payable {
55         buyTokensWithETH(msg.sender);
56     }
57 
58     // Guards against integer overflows
59     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         } else {
63             uint256 c = a * b;
64             assert(c / a == b);
65             return c;
66         }
67     }
68     
69     function multiply(uint x, uint y) internal pure returns (uint z) {
70         require(y == 0 || (z = x * y) / y == x);
71     }
72     
73     function setPrice(uint256 price_) external onlyOwner{
74         price = price_;
75     }
76 
77 
78     function buyTokensWithETH(address _receiver) public payable {
79         require(ethRaised < MaxETHAmount, "Presale finished");
80         uint _amount = msg.value; 
81         require(_receiver != address(0), "Can't send to 0x00 address"); 
82         require(_amount > 0, "Can't buy with 0 eth"); 
83         
84         uint tokensToBuy = multiply(_amount, price);
85         require(owner.send(_amount), "Unable to transfer eth to owner");
86         require(tokenContract.transfer(_receiver, tokensToBuy), "Unable to transfer token to user"); 
87         tokensSold += tokensToBuy; 
88         ethRaised += _amount;
89         
90         emit Sold(msg.sender, tokensToBuy);
91     }
92 
93     
94 
95     function endSale() public {
96         require(msg.sender == owner);
97 
98         // Send unsold tokens to the owner.
99         require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))));
100 
101         msg.sender.transfer(address(this).balance);
102     }
103 }