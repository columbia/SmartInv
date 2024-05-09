1 pragma solidity ^0.4.11;
2 
3 /// @title SaintArnould (Tokyo) Token (SAT) -
4 contract SaintArnouldToken {
5     string public constant name = "Saint Arnould Token";
6     string public constant symbol = "SAT";
7     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
8 
9     uint256 public constant tokenCreationRate = 5000;  //creation rate 1 ETH = 5000 SAT
10     uint256 public constant firstTokenCap = 10 ether * tokenCreationRate; 
11     uint256 public constant secondTokenCap = 920 ether * tokenCreationRate; //27,900,000 YEN
12 
13     uint256 public fundingStartBlock;
14     uint256 public fundingEndBlock;
15     uint256 public locked_allocation;
16     uint256 public unlockingBlock;
17 
18     // Receives ETH for founders.
19     address public founders;
20 
21     // The flag indicates if the SAT contract is in Funding state.
22     bool public funding_ended = false;
23 
24     // The current total token supply.
25     uint256 totalTokens;
26 
27     mapping (address => uint256) balances;
28 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31     function SaintArnouldToken(address _founders,
32                                uint256 _fundingStartBlock,
33                                uint256 _fundingEndBlock) {
34 
35         if (_founders == 0) throw;
36         if (_fundingStartBlock <= block.number) throw;
37         if (_fundingEndBlock   <= _fundingStartBlock) throw;
38 
39         founders = _founders;
40         fundingStartBlock = _fundingStartBlock;
41         fundingEndBlock = _fundingEndBlock;
42     }
43 
44     /// @notice Transfer `_value` SAT tokens from sender's account
45     /// `msg.sender` to provided account address `_to`.
46     /// @param _to The address of the tokens recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint256 _value) public returns (bool) {
50         // Abort if not in Operational state.
51         if (!funding_ended) throw;
52         if (msg.sender == founders) throw;
53         var senderBalance = balances[msg.sender];
54         if (senderBalance >= _value && _value > 0) {
55             senderBalance -= _value;
56             balances[msg.sender] = senderBalance;
57             balances[_to] += _value;
58             Transfer(msg.sender, _to, _value);
59             return true;
60         }
61         return false;
62     }
63 
64     function totalSupply() external constant returns (uint256) {
65         return totalTokens;
66     }
67 
68     function balanceOf(address _owner) external constant returns (uint256) {
69         return balances[_owner];
70     }
71 
72     // Crowdfunding:
73 
74     /// @notice Create tokens when funding is active.
75     /// @dev Required state: Funding Active
76     /// @dev State transition: -> Funding Success (only if cap reached)
77     function buy(address _sender) internal {
78         // Abort if not in Funding Active state.
79         if (funding_ended) throw;
80         // The checking for blocktimes.
81         if (block.number < fundingStartBlock) throw;
82         if (block.number > fundingEndBlock) throw;
83 
84         // Do not allow creating 0 or more than the cap tokens.
85         if (msg.value == 0) throw;
86 
87         var numTokens = msg.value * tokenCreationRate;
88         totalTokens += numTokens;
89 
90         // Assign new tokens to the sender
91         balances[_sender] += numTokens;
92 
93         // sending funds to founders
94         founders.transfer(msg.value);
95 
96         // Log token creation event
97         Transfer(0, _sender, numTokens);
98     }
99 
100     /// @notice Finalize crowdfunding
101     function finalize() external {
102         if (block.number <= fundingEndBlock) throw;
103 
104         //locked allocation for founders 
105         locked_allocation = totalTokens * 10 / 100;
106         balances[founders] = locked_allocation;
107         totalTokens += locked_allocation;
108         
109         unlockingBlock = block.number + 864000;   //about 6 months locked time.
110         funding_ended = true;
111     }
112 
113     function transferFounders(address _to, uint256 _value) public returns (bool) {
114         if (!funding_ended) throw;
115         if (block.number <= unlockingBlock) throw;
116         if (msg.sender != founders) throw;
117         var senderBalance = balances[msg.sender];
118         if (senderBalance >= _value && _value > 0) {
119             senderBalance -= _value;
120             balances[msg.sender] = senderBalance;
121             balances[_to] += _value;
122             Transfer(msg.sender, _to, _value);
123             return true;
124         }
125         return false;
126     }
127 
128     /// @notice If anybody sends Ether directly to this contract, consider he is
129     function() public payable {
130         buy(msg.sender);
131     }
132 }