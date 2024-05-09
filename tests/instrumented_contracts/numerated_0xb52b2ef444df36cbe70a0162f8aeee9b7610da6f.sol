1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     // ------------------------------------------------------------------------
5     // Add a number to another number, checking for overflows
6     // ------------------------------------------------------------------------
7     function add(uint a, uint b) internal pure returns (uint) {
8         uint c = a + b;
9         assert(c >= a && c >= b);
10         return c;
11     }
12 
13     // ------------------------------------------------------------------------
14     // Subtract a number from another number, checking for underflows
15     // ------------------------------------------------------------------------
16     function sub(uint a, uint b) internal pure returns (uint) {
17         assert(b <= a);
18         return a - b;
19     }
20 	
21 }
22 
23 contract Owned {
24 
25     address public owner;
26 
27     function Owned() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function setOwner(address _newOwner) public onlyOwner {
37         owner = _newOwner;
38     }
39 }
40 contract Ownable {
41 
42   address public owner;
43 
44   function Ownable() internal {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     owner = newOwner;
56   }
57 }
58 
59 interface Token {
60   function transfer(address _to, uint256 _value) public constant returns (bool);
61   function balanceOf(address _owner) public constant returns (uint256 balance);
62 }
63 
64 contract Distribution is Ownable {
65 
66   Token token;
67 
68   event TransferredToken(address indexed to, uint256 value);
69   event FailedTransfer(address indexed to, uint256 value);
70 
71   modifier whenDropIsActive() {
72     assert(isActive());
73 
74     _;
75   }
76 
77   function Distribution () public {
78       address _tokenAddr = 0xB15EF419bA0Dd1f5748c7c60e17Fe88e6e794950; //here pass address of your token
79       token = Token(_tokenAddr);
80   }
81 
82   function isActive() public constant returns (bool) {
83     return (
84         tokensAvailable() > 0 // Tokens must be available to send
85     );
86   }
87   //below function can be used when you want to send every recipeint with different number of tokens
88   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
89     uint256 i = 0;
90     while (i < dests.length) {
91         uint256 toSend = values[i] * 10**18;
92         sendInternally(dests[i] , toSend, values[i]);
93         i++;
94     }
95   }
96 
97   // this function can be used when you want to send same number of tokens to all the recipients
98   function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
99     uint256 i = 0;
100     uint256 toSend = value * 10**18;
101     while (i < dests.length) {
102         sendInternally(dests[i] , toSend, value);
103         i++;
104     }
105   }  
106 
107   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
108     if(recipient == address(0)) return;
109 
110     if(tokensAvailable() >= tokensToSend) {
111       token.transfer(recipient, tokensToSend);
112       TransferredToken(recipient, valueToPresent);
113     } else {
114       FailedTransfer(recipient, valueToPresent); 
115     }
116   }   
117 
118 
119   function tokensAvailable() public constant returns (uint256) {
120     return token.balanceOf(this);
121   }
122 
123   function destroy() onlyOwner public {
124     uint256 balance = tokensAvailable();
125     require (balance > 0);
126     token.transfer(owner, balance);
127     selfdestruct(owner);
128   }
129 }