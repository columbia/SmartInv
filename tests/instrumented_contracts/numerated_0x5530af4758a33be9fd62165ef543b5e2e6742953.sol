1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
4 
5 
6 contract Ownable {
7 
8     address private owner;
9     
10     event OwnerSet(address indexed oldOwner, address indexed newOwner);
11     
12     modifier onlyOwner() {
13         require(msg.sender == owner, "Caller is not owner");
14         _;
15     }
16     
17     constructor() {
18         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
19         emit OwnerSet(address(0), owner);
20     }
21 
22     function changeOwner(address newOwner) public onlyOwner {
23         emit OwnerSet(owner, newOwner);
24         owner = newOwner;
25     }
26 
27     function getOwner() external view returns (address) {
28         return owner;
29     }
30 }
31 
32 library SafeMath {
33 
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35 
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46 }
47 
48 interface Token {
49     function tokensSold(address buyer, uint256 amount) external  returns (bool success);
50     function balanceOf(address _owner) external view returns (uint256 balance);
51     function burn(uint256 _value) external returns (bool success);
52 }
53 
54 contract YUICrowdSale is Ownable{
55     
56     using SafeMath for uint256;
57     
58     uint256 public priceFactor;
59     uint256 public totalSold;
60     address public tokenAddress;
61     uint256 public startTime = 1605290400;
62     uint256 public endTime = 1605636000;
63     
64     uint256 public minimumBuyAmount = 10 ** 17;
65     address payable public walletAddress;
66     event TokensSold(address indexed to, uint256 amount);
67     
68     constructor() {
69         priceFactor = uint256(20);
70         walletAddress = 0x5958C4C4385883F940809698826e9780146a96f7;
71         tokenAddress = address(0x0);
72     }
73     
74     receive() external payable {
75         buy();
76     }
77     
78     function changeWallet (address payable _walletAddress) onlyOwner public {
79         walletAddress = _walletAddress;
80     }
81     
82     function setToken(address _tokenAddress) onlyOwner public {
83         tokenAddress = _tokenAddress;
84     }
85     
86     function buy() public payable {
87         require((block.timestamp > startTime ) && (block.timestamp < endTime)  , "YUI Token Crowdsate is not active");
88         uint256 weiValue = msg.value;
89         require(weiValue >= minimumBuyAmount, "Minimum amount is 0.1 eth");
90         uint256 amount = weiValue.mul(priceFactor);
91         Token token = Token(tokenAddress);
92         require(walletAddress.send(weiValue));
93         require(token.tokensSold(msg.sender, amount));
94         totalSold += amount;
95         emit TokensSold(msg.sender, amount);
96     }
97     
98     function burnUnsold() onlyOwner public {
99         require((block.timestamp > endTime), "YUI Token Crowdsate is still active");
100         Token token = Token(tokenAddress);
101         uint256 amount = token.balanceOf(address(this));
102         token.burn(amount);
103     }
104     
105 }