1 pragma solidity ^0.4.4;
2 
3 
4 contract TestNetworkToken {
5 
6     // Token metadata
7     string public constant name = "Test Network Token";
8     string public constant symbol = "TNT";
9     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
10 
11     uint256 public constant tokenCreationRate = 1000;
12 
13     // The current total token supply
14     uint256 totalTokens;
15     
16     mapping (address => uint256) balances;
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Refund(address indexed _from, uint256 _value);
20 
21     // ERC20 interface implementation
22 
23     // Empty implementation, so that no tokens can be moved
24     function transfer(address _to, uint256 _value) returns (bool) {
25         return false;
26     }
27 
28     function totalSupply() external constant returns (uint256) {
29         return totalTokens;
30     }
31 
32     function balanceOf(address _owner) external constant returns (uint256) {
33         return balances[_owner];
34     }
35 
36     // External interface similar to the crowdfunding one
37 
38     function create() payable external {
39         // Do not allow creating 0 tokens.
40         if (msg.value == 0) throw;
41 
42         var numTokens = msg.value * tokenCreationRate;
43 
44         totalTokens += numTokens;
45 
46         // Assign new tokens to the sender
47         balances[msg.sender] += numTokens;
48 
49         // Log token creation event
50         Transfer(0x0, msg.sender, numTokens);
51     }
52 
53     function refund() external {
54         var tokenValue = balances[msg.sender];
55         if (tokenValue == 0) throw;
56         balances[msg.sender] = 0;
57         totalTokens -= tokenValue;
58 
59         var ethValue = tokenValue / tokenCreationRate;
60         Refund(msg.sender, ethValue);
61         Transfer(msg.sender, 0x0, tokenValue);
62 
63         if (!msg.sender.send(ethValue)) throw;
64     }
65 
66     // This is a test contract, so kill can be used once it is not needed
67     
68     function kill() {
69         if(totalTokens > 0) throw;
70 
71         selfdestruct(msg.sender);
72     }
73 }