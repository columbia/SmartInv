1 pragma solidity ^0.4.11;
2 
3 // Token abstract definitioin
4 contract Token {
5     function transfer(address to, uint256 value) returns (bool success);
6     function transferFrom(address from, address to, uint256 value) returns (bool success);
7     function approve(address spender, uint256 value) returns (bool success);
8 
9     function totalSupply() constant returns (uint256 totalSupply) {}
10     function balanceOf(address owner) constant returns (uint256 balance);
11     function allowance(address owner, address spender) constant returns (uint256 remaining);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 contract WaltonTokenLocker {
19 
20     address public beneficiary;
21     uint256 public releaseTime;
22 
23     Token public token = Token('0xb7cB1C96dB6B22b0D3d9536E0108d062BD488F74');
24 
25     function WaltonTokenLocker() public {
26         // team
27         // beneficiary = address('0x732f589BA0b134DC35454716c4C87A06C890445b');
28         // test
29         beneficiary = address('0xa43e4646ee8ebd9AD01BFe87995802D984902e25');
30         releaseTime = 1563379200;     // 2019-07-18 00:00
31     }
32 
33     // when releaseTime reached, and release() has been called
34     // WaltonTokenLocker release all eth and wtc to beneficiary
35     function release() public {
36         if (block.timestamp < releaseTime)
37             throw;
38 
39         uint256 totalTokenBalance = token.balanceOf(this);
40         if (totalTokenBalance > 0)
41             if (!token.transfer(beneficiary, totalTokenBalance))
42                 throw;
43     }
44     // release token by token contract address
45     function releaseToken(address _tokenContractAddress) public {
46         if (block.timestamp < releaseTime)
47             throw;
48 
49         Token _token = Token(_tokenContractAddress);
50         uint256 totalTokenBalance = _token.balanceOf(this);
51         if (totalTokenBalance > 0)
52             if (!_token.transfer(beneficiary, totalTokenBalance))
53                 throw;
54     }
55 
56 
57     // help functions
58     function releaseTimestamp() public constant returns (uint timestamp) {
59         return releaseTime;
60     }
61 
62     function currentTimestamp() public constant returns (uint timestamp) {
63         return block.timestamp;
64     }
65 
66     function secondsRemaining() public constant returns (uint timestamp) {
67         if (block.timestamp < releaseTime)
68             return releaseTime - block.timestamp;
69         else
70             return 0;
71     }
72 
73     function tokenLocked() public constant returns (uint amount) {
74         return token.balanceOf(this);
75     }
76 
77     // functions for debug
78     function setReleaseTime(uint256 _releaseTime) public {
79         releaseTime = _releaseTime;
80     }
81 
82 }