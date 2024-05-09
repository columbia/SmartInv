1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner public{
17     require(newOwner != address(0));
18     owner = newOwner;
19   }
20 }
21 
22 
23 interface Token {
24   function transfer(address _to, uint256 _value) external returns  (bool);
25   function balanceOf(address _owner) external constant returns (uint256 balance);
26 }
27 
28 contract ELACoinSender is Ownable {
29 
30   Token token;
31 
32   event TransferredToken(address indexed to, uint256 value);
33   event FailedTransfer(address indexed to, uint256 value);
34 
35   modifier whenDropIsActive() {
36     assert(isActive());
37 
38     _;
39   }
40 
41   function Multisend () public {
42       address _tokenAddr = 0xFaF378DD7C26EBcFAe80f4675faDB3F9d9DFC152; //here pass address of your token
43       token = Token(_tokenAddr);
44   }
45 
46   function isActive() constant public returns (bool) {
47     return (
48         tokensAvailable() > 0 // Tokens must be available to send
49     );
50   }
51 //below function can be used when you want to send every recipeint with different number of tokens
52 // change the uint256 tosend = value  * “10**18”; to adjust the decimal points
53   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
54     uint256 i = 0;
55     while (i < dests.length) {
56         uint256 toSend = values[i]; //here set if you want to send in whole number leave as is or delete the 10**18 to send in 18 decimals
57         sendInternally(dests[i] , toSend, values[i]);
58         i++;
59     }
60   }
61 
62 // this function can be used when you want to send same number of tokens to all the recipients
63 // change the uint256 tosend = value  * “10**18”; to adjust the decimal points
64   function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
65     uint256 i = 0;
66     uint256 toSend = value;  //here set if you want to send in whole number leave as is or delete the 10**18 to send in 18 decimals
67     while (i < dests.length) {
68         sendInternally(dests[i] , toSend, value);
69         i++;
70     }
71   }  
72 
73   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
74     if(recipient == address(0)) return;
75 
76     if(tokensAvailable() >= tokensToSend) {
77       token.transfer(recipient, tokensToSend);
78       emit TransferredToken(recipient, valueToPresent);
79     } else {
80       emit FailedTransfer(recipient, valueToPresent); 
81     }
82   }   
83 
84 
85   function tokensAvailable() constant public returns (uint256) {
86     return token.balanceOf(this);
87   }
88 
89   function destroy() onlyOwner external {
90     uint256 balance = tokensAvailable();
91     require (balance > 0);
92     token.transfer(owner, balance);
93     selfdestruct(owner);
94   }}