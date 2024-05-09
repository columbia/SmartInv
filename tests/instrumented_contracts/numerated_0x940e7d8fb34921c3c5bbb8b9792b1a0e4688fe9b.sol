1 pragma solidity ^0.4.4;
2 
3 
4 contract MockTestNetworkToken {
5 
6     // Token metadata
7     string public constant name = "Test Network Token";
8     string public constant symbol = "TNT";
9     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
10 
11     // The current total token supply
12     uint256 totalTokens;
13 
14     // Balances are stored here
15     mapping (address => uint256) balances;
16 
17     // Always false, corresponds to ongoing crowdfunding
18     bool transferable;
19 
20 
21     // ERC20 interface - Transfer event used to track token transfers
22     
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 
25     // ERC20 interface - minimal functional subset
26 
27     function transfer(address _to, uint256 _value) returns (bool) {
28         if (transferable && balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         }
34         return false;
35     }
36 
37     function totalSupply() external constant returns (uint256) {
38         return totalTokens;
39     }
40 
41     function balanceOf(address _owner) external constant returns (uint256) {
42         return balances[_owner];
43     }
44 
45 }
46 
47 contract TestNetworkToken is MockTestNetworkToken {
48 
49     // Only this address is allowed to kill this contract
50     address owner;
51 
52     uint256 public constant tokenCreationRate = 1000;
53 
54     event Refund(address indexed _from, uint256 _value);
55 
56     function TestNetworkToken() {
57         owner = msg.sender;
58     }
59 
60     // Public, external API exposed to all users interested in taking part in the crowdfunding
61 
62     function create() payable external {
63         // Do not allow creating 0 tokens.
64         if (msg.value == 0) throw;
65 
66         var numTokens = msg.value * tokenCreationRate;
67 
68         totalTokens += numTokens;
69 
70         // Assign new tokens to the sender
71         balances[msg.sender] += numTokens;
72 
73         // Log token creation event
74         Transfer(0x0, msg.sender, numTokens);
75     }
76 
77     function refund() external {
78         var tokenValue = balances[msg.sender];
79         if (tokenValue == 0) throw;
80         balances[msg.sender] = 0;
81         totalTokens -= tokenValue;
82 
83         var ethValue = tokenValue / tokenCreationRate;
84         Refund(msg.sender, ethValue);
85         Transfer(msg.sender, 0x0, tokenValue);
86 
87         if (!msg.sender.send(ethValue)) throw;
88     }
89 
90     // This is a test contract, so kill can be used once it is not needed
91     
92     function kill() {
93         if (msg.sender != owner) throw;
94         if (totalTokens > 0) throw;
95 
96         selfdestruct(msg.sender);
97     }
98 }