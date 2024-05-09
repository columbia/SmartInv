1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Ownable {
8 
9     address public owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 }
20 
21 contract ZenswapDistributionTest is Ownable {
22     
23     token public tokenReward;
24     
25     /**
26      * Constructor function
27      *
28      * Set the token smart contract address
29      */
30     constructor() public {
31         
32         tokenReward = token(0xbaD16E6bACaF330D3615539dbf3884836071f279);
33         
34     }
35     
36     /**
37      * Distribute token to multiple address
38      * 
39      */
40     function distributeToken(address[] _addresses, uint256[] _amount) public onlyOwner {
41     
42     uint256 addressCount = _addresses.length;
43     uint256 amountCount = _amount.length;
44     require(addressCount == amountCount);
45     
46     for (uint256 i = 0; i < addressCount; i++) {
47         uint256 _tokensAmount = _amount[i] * 10 ** uint256(18);
48         tokenReward.transfer(_addresses[i], _tokensAmount);
49     }
50   }
51 
52     /**
53      * Withdraw an "amount" of available tokens in the contract
54      * 
55      */
56     function withdrawToken(address _address, uint256 _amount) public onlyOwner {
57         
58         uint256 _tokensAmount = _amount * 10 ** uint256(18); 
59         tokenReward.transfer(_address, _tokensAmount);
60     }
61     
62     /**
63      * Set a token contract address
64      * 
65      */
66     function setTokenReward(address _address) public onlyOwner {
67         
68         tokenReward = token(_address);
69     }
70     
71 }