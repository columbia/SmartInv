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
31   event TransferredToken(address indexed to, uint256 value);
32   event FailedTransfer(address indexed to, uint256 value);
33 
34   modifier whenDropIsActive() {
35     assert(isActive());
36 
37     _;
38   }
39 
40   function AirDrop () {
41       address _tokenAddr = 0xb62d18DeA74045E822352CE4B3EE77319DC5ff2F; 
42       token = Token(_tokenAddr);
43   }
44 
45   function isActive() constant returns (bool) {
46     return (
47         tokensAvailable() > 0 
48     );
49   }
50   //below function can be used when you want to send every recipeint with different number of tokens
51   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
52     uint256 i = 0;
53     while (i < dests.length) {
54         uint256 toSend = values[i] * 10**18;
55         sendInternally(dests[i], toSend, values[i]);
56         i++;
57     }
58   } 
59 
60   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
61     if (recipient == address(0)) return;
62 
63     if (tokensAvailable() >= tokensToSend) {
64       token.transfer(recipient, tokensToSend);
65       TransferredToken(recipient, valueToPresent);
66     } else {
67       FailedTransfer(recipient, valueToPresent); 
68     }
69   }   
70 
71   function tokensAvailable() constant returns (uint256) {
72     return token.balanceOf(this);
73   }
74 
75   function destroy() onlyOwner {
76     uint256 balance = tokensAvailable();
77     require (balance > 0);
78     token.transfer(owner, balance);
79     selfdestruct(owner);
80   }
81 }