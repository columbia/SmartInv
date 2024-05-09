1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17     require(newOwner != address(0));
18     owner = newOwner;
19   }
20 }
21 
22 interface Token {
23   function transfer(address _to, uint256 _value) returns (bool);
24   function balanceOf(address _owner) constant returns (uint256 balance);
25 }
26 
27 contract AirDrop is Ownable {
28 
29   Token token;
30 
31   event TransferredToken(address indexed to , uint256 value);
32   event FailedTransfer(address indexed to, uint256 value);
33 
34   modifier whenDropIsActive() {
35     assert(isActive());
36 
37     _;
38   }
39 
40   function AirDrop () {
41       address _tokenAddr = 0x382117315856a533549eA621542Ccce13E54aE82; //here pass address of your token
42       token = Token(_tokenAddr);
43   }
44 
45   function isActive() constant returns (bool) {
46     return (
47         tokensAvailable() > 0 // Tokens must be available to send
48     );
49   }
50   //below function can be used when you want to send every recipeint with different number of tokens
51   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
52     uint256 i = 0;
53     while (i < dests.length) {
54         uint256 toSend = values[i] * 10**18;
55         sendInternally(dests[i] , toSend, values[i]);
56         i++;
57     }
58   }
59 
60   // this function can be used when you want to send same number of tokens to all the recipients
61   function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
62     uint256 i = 0;
63     uint256 toSend = value * 10**18;
64     while (i < dests.length) {
65         sendInternally(dests[i] , toSend, value);
66         i++;
67     }
68   }  
69 
70   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
71     if(recipient == address(0)) return;
72     if(tokensAvailable() >= tokensToSend) {
73       token.transfer(recipient, tokensToSend);
74       TransferredToken(recipient, valueToPresent);
75     } else {
76       FailedTransfer(recipient, valueToPresent); 
77     }
78   }   
79 
80 
81   function tokensAvailable() constant returns (uint256) {
82     return token.balanceOf(this);
83   }
84 
85   function destroy() onlyOwner {
86     uint256 balance = tokensAvailable();
87     require (balance > 0);
88     token.transfer(owner, balance);
89     selfdestruct(owner);
90   }
91 }