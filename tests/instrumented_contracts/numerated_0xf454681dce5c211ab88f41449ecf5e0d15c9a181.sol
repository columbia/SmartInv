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
20     address public smnAddress;
21     uint256 public releaseTimestamp;
22     string public name;
23     address public wtcFundation;
24 
25     Token public token = Token('0x554622209Ee05E8871dbE1Ac94d21d30B61013c2');
26 
27     function WaltonTokenLocker(string _name, address _token, address _beneficiary, uint256 _releaseTime) public {
28         // smn account
29         wtcFundation = msg.sender;
30         name = _name;
31         token = Token(_token);
32         smnAddress = _beneficiary;
33         releaseTimestamp = _releaseTime;
34     }
35 
36     // when releaseTimestamp reached, and release() has been called
37     // WaltonTokenLocker release all wtc to smnAddress
38     function release() public {
39         if (block.timestamp < releaseTimestamp)
40             throw;
41 
42         uint256 totalTokenBalance = token.balanceOf(this);
43         if (totalTokenBalance > 0)
44             if (!token.transfer(smnAddress, totalTokenBalance))
45                 throw;
46     }
47 
48 
49     // help functions
50     function releaseTimestamp() public constant returns (uint timestamp) {
51         return releaseTimestamp;
52     }
53 
54     function currentTimestamp() public constant returns (uint timestamp) {
55         return block.timestamp;
56     }
57 
58     function secondsRemaining() public constant returns (uint timestamp) {
59         if (block.timestamp < releaseTimestamp)
60             return releaseTimestamp - block.timestamp;
61         else
62             return 0;
63     }
64 
65     function tokenLocked() public constant returns (uint amount) {
66         return token.balanceOf(this);
67     }
68 
69     // release for safe, will never be called in normal condition
70     function safeRelease() public {
71         if (msg.sender != wtcFundation)
72             throw;
73 
74         uint256 totalTokenBalance = token.balanceOf(this);
75         if (totalTokenBalance > 0)
76             if (!token.transfer(wtcFundation, totalTokenBalance))
77                 throw;
78     }
79 
80     // functions for debug
81     //function setReleaseTime(uint256 _releaseTime) public {
82     //    releaseTimestamp = _releaseTime;
83     //}
84 }