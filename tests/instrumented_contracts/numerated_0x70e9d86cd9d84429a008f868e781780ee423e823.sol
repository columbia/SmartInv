1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() public constant returns (uint256 supply);
6 
7     // Get the account balance of another a ccount with address _owner
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9 
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23 
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 contract AirDrop
32 {
33     address public owner;
34     address public executor;
35     
36     event eTransferExecutor(address newOwner);
37     event eMultiTransfer(address _tokenAddr, address[] dests, uint256[] values);
38     event eMultiTransferETH(address[] dests, uint256[] values);
39     
40     function () public payable {
41     }
42     
43     // Constructor
44     function AirDrop() public {
45         owner = msg.sender;
46         executor = msg.sender;
47     }
48     
49     // Functions with this modifier can only be executed by the owner
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54     
55     function transferExecutor(address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         executor = newOwner;
58         eTransferExecutor(newOwner);
59     }
60     
61     // Functions with this modifier can only be executed by the owner
62     modifier onlyExecutor() {
63         require(msg.sender == executor || msg.sender == owner);
64         _;
65     }
66     
67     function MultiTransfer(address _tokenAddr, address[] dests, uint256[] values) public onlyExecutor
68     {
69         uint256 i = 0;
70         ERC20Interface T = ERC20Interface(_tokenAddr);
71         
72         require(dests.length > 0 && (dests.length == values.length || values.length == 1));
73         
74         if (values.length > 1)
75         {
76             while (i < dests.length) {
77                 T.transfer(dests[i], values[i]);
78                 i += 1;
79             }
80         }
81         else    
82         {
83             while (i < dests.length) {
84                 T.transfer(dests[i], values[0]);
85                 i += 1;
86             }
87         }
88         eMultiTransfer(_tokenAddr, dests, values);
89     }
90     
91     function MultiTransferETH(address[] dests, uint256[] values) public onlyExecutor
92     {
93         uint256 i = 0;
94         require(dests.length > 0 && (dests.length == values.length || values.length == 1));
95         
96         
97         if (values.length > 1)
98         {
99             while (i < dests.length) {
100                 dests[i].transfer(values[i]);
101                 i += 1;
102             }
103         }
104         else    
105         {
106             while (i < dests.length) {
107                 dests[i].transfer(values[0]);
108                 i += 1;
109             }
110         }
111         eMultiTransferETH(dests, values);
112     }
113 }