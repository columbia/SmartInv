1 pragma solidity ^0.4.13;
2 contract SafeMath {
3 
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5         uint256 z = x + y;
6         assert((z >= x) && (z >= y));
7         return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11         assert(x >= y);
12         uint256 z = x - y;
13         return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x * y;
18         assert((x == 0)||(z/x == y));
19         return z;
20     }
21 }
22 
23 contract PrivateCityToken {
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25 }
26 
27 
28 contract PrivateCityCrowdsale is SafeMath{
29 
30     uint256 public totalSupply;
31     // Deposit address of account controlled by the creators
32     address public ethFundDeposit = 0x4574C2A0a1C39114Fe794dD1A3D1A5F90C92AD90;
33     address public tokenExchangeAddress = 0xD9fc693CA2C5CF060D10E182a078a0A4CFF1F4d6;
34     address public tokenAccountAddress = 0xdca42D3220681C3beaF3dD0631D06536c39beB67;
35     //Access to token contract for tokens exchange
36     PrivateCityToken public tokenExchange;
37 
38     // Fundraising parameters
39     enum ContractState { Fundraising }
40     ContractState public state;
41 
42     uint256 public constant decimals = 18;
43     //start date: 11/24/2017 @ 00:00 (GMT-8)
44     uint public startDate = 1511510400;
45     //start date: 1/01/2018 @ 00:00 (GMT-8)
46     uint public endDate = 1514793600;
47     
48     uint256 public constant TOKEN_MIN = 1 * 10**decimals; // 1 PCT
49 
50     // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
51     uint256 public totalReceivedEth = 0;
52 	
53 
54     // Constructor
55     function PrivateCityCrowdsale()
56     {
57         // Contract state
58         state = ContractState.Fundraising;
59         tokenExchange = PrivateCityToken(tokenExchangeAddress);
60         totalSupply = 0;
61     }
62 
63     
64     function ()
65     payable
66     external
67     {
68         require(now >= startDate);
69         require(now <= endDate);
70         require(msg.value > 0);
71         
72 
73         // First we check the ETH cap, as it's easier to calculate, return
74         // the contribution if the cap has been reached already
75         uint256 checkedReceivedEth = safeAdd(totalReceivedEth, msg.value);
76 
77         // If all is fine with the ETH cap, we continue to check the
78         // minimum amount of tokens
79         uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
80         require(tokens >= TOKEN_MIN);
81 
82         totalReceivedEth = checkedReceivedEth;
83         totalSupply = safeAdd(totalSupply, tokens);
84         ethFundDeposit.transfer(msg.value);
85         if(!tokenExchange.transferFrom(tokenAccountAddress, msg.sender, tokens)) revert();
86             
87 
88     }
89 
90 
91     /// @dev Returns the current token price
92     function getCurrentTokenPrice()
93     private
94     constant
95     returns (uint256 currentPrice)
96     {
97         return 6000;//bonuses are not implied!
98     }
99 
100 }