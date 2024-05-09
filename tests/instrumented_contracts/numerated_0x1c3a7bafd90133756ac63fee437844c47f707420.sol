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
19 
20     function transferOwnership(address newOwner) public onlyOwner {
21         owner = newOwner;
22     }
23 }
24 
25 contract ZenswapDistribution is Ownable {
26     
27     token public tokenReward;
28     
29     /**
30      * Constructor function
31      *
32      * Set the token smart contract address
33      */
34     constructor() public {
35         
36         tokenReward = token(0x4fa000dF40C06FC8c7D9179661535846B7Cd4f87);
37         
38     }
39     
40     /**
41      * Distribute token to multiple address
42      * 
43      */
44     function distributeToken(address[] _addresses, uint256[] _amount) public onlyOwner {
45     
46     uint256 addressCount = _addresses.length;
47     uint256 amountCount = _amount.length;
48     require(addressCount == amountCount);
49     
50     for (uint256 i = 0; i < addressCount; i++) {
51         uint256 _tokensAmount = _amount[i] * 10 ** uint256(18);
52         tokenReward.transfer(_addresses[i], _tokensAmount);
53     }
54   }
55 
56     /**
57      * Withdraw an "amount" of available tokens in the contract
58      * 
59      */
60     function withdrawToken(address _address, uint256 _amount) public onlyOwner {
61         
62         uint256 _tokensAmount = _amount * 10 ** uint256(18); 
63         tokenReward.transfer(_address, _tokensAmount);
64     }
65     
66     /**
67      * Set a token contract address
68      * 
69      */
70     function setTokenReward(address _address) public onlyOwner {
71         
72         tokenReward = token(_address);
73     }
74     
75 }