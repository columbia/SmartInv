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
40 
41 
42 interface Token {
43   function transfer(address _to, uint256 _value) public constant returns (bool);
44   function balanceOf(address _owner) public constant returns (uint256 balance);
45 }
46 
47 contract Distribution is Owned {
48     using SafeMath for uint256;
49 
50   Token token;
51 
52   event TransferredToken(address indexed to, uint256 value);
53   event FailedTransfer(address indexed to, uint256 value);
54 
55   modifier whenDropIsActive() {
56     assert(isActive());
57 
58     _;
59   }
60 
61   function Distribution () public {
62       address _tokenAddr = 0xB15EF419bA0Dd1f5748c7c60e17Fe88e6e794950; //here pass address of your token
63       token = Token(_tokenAddr);
64   }
65 
66   function isActive() public constant returns (bool) {
67     return (
68         tokensAvailable() > 0 // Tokens must be available to send
69     );
70   }
71   //below function can be used when you want to send every recipeint with different number of tokens
72   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
73     uint256 i = 0;
74     while (i < dests.length) {
75         uint256 toSend = values[i] * 10**8;
76         sendInternally(dests[i] , toSend, values[i]);
77         i++;
78     }
79   }
80 
81   // this function can be used when you want to send same number of tokens to all the recipients
82   function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
83     uint256 i = 0;
84     uint256 toSend = value * 10**8;
85     while (i < dests.length) {
86         sendInternally(dests[i] , toSend, value);
87         i++;
88     }
89   }  
90 
91   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
92     if(recipient == address(0)) return;
93 
94     if(tokensAvailable() >= tokensToSend) {
95       token.transfer(recipient, tokensToSend);
96       TransferredToken(recipient, valueToPresent);
97     } else {
98       FailedTransfer(recipient, valueToPresent); 
99     }
100   }   
101 
102 
103   function tokensAvailable() public constant returns (uint256) {
104     return token.balanceOf(this);
105   }
106 
107   function destroy() onlyOwner public {
108     uint256 balance = tokensAvailable();
109     require (balance > 0);
110     token.transfer(owner, balance);
111     selfdestruct(owner);
112   }
113 }