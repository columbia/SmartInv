1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     function transfer(address to, uint256 value) returns (bool success);
5     function transferFrom(address from, address to, uint256 value) returns (bool success);
6     function approve(address spender, uint256 value) returns (bool success);
7 
8     function totalSupply() constant returns (uint256 totalSupply) {}
9     function balanceOf(address owner) constant returns (uint256 balance);
10     function allowance(address owner, address spender) constant returns (uint256 remaining);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 contract WaltonTokenLocker {
18 
19     address public beneficiary;
20     uint256 public releaseTime;
21 
22     Token  public token   = Token('0xb7cB1C96dB6B22b0D3d9536E0108d062BD488F74');
23 
24     function WaltonTokenLocker() public {
25         // team
26         // beneficiary = address('0x732f589BA0b134DC35454716c4C87A06C890445b');
27         // test
28         beneficiary = address('0xa43e4646ee8ebd9AD01BFe87995802D984902e25');
29         releaseTime = 1563379200;     // 2019-07-18 00:00
30     }
31 
32     function release() public {
33         uint256 totalTokenBalance;
34         uint256 totalEthBalance;
35         // when releaseTime reached, and release() has been called
36         // WaltonTokenLocker release all eth and wtc to beneficiary
37         if (block.timestamp < releaseTime)
38             throw;
39 
40         totalTokenBalance = token.balanceOf(this);
41         totalEthBalance = this.balance;
42         if (totalTokenBalance > 0)
43             if (!token.transfer(beneficiary, totalTokenBalance))
44                 throw;
45         if (totalEthBalance > 0)
46             if (!beneficiary.send(totalEthBalance))
47                 throw;
48     }
49 
50     function releaseTimestamp() public constant returns (uint timestamp) {
51         return releaseTime;
52     }
53     function currentTimestamp() public constant returns (uint timestamp) {
54         return block.timestamp;
55     }
56     function secondsRemaining() public constant returns (uint timestamp) {
57         return releaseTime - block.timestamp;
58     }
59 
60     // for debug
61     function setReleaseTime(uint256 _releaseTime) public {
62         releaseTime = _releaseTime;
63     }
64 
65 }