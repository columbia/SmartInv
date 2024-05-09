1 pragma solidity ^0.5.1;
2 
3 contract Demotivoken {
4     string public constant name = "Demotivoken";
5     string public constant symbol = "DMT";
6     uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
7 
8     bool internal tokensDistributed = true;
9     address internal ruler = address(0x0);
10     
11     constructor() public {
12         ruler = msg.sender;
13     }
14     
15     function disableToken() public {
16         require(msg.sender == ruler);
17         tokensDistributed = false;
18     }
19 
20     function enableToken() public {
21         require(msg.sender == ruler);
22         tokensDistributed = true;
23     }
24 
25     function totalSupply() public view returns (uint) {
26         if (tokensDistributed) {
27             return 70 * 1e6 * 1e18;
28         } else {
29             return 0;
30         }
31     }
32     
33     function balanceOf(address tokenOwner) public view returns (uint balance) {
34         if (tokensDistributed) {
35             return 20;
36         } else {
37             return 0;
38         }
39     }
40     
41     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
42         return 0;
43     }
44     
45     function transfer(address to, uint tokens) public returns (bool success) {
46         emit Transfer(msg.sender, to, tokens);
47         return true;
48     }
49     
50     function approve(address spender, uint tokens) public returns (bool success) {
51         emit Approval(msg.sender, spender, tokens);
52         return true;
53     }
54     
55     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
56         emit Transfer(from, to, tokens);
57         return true;
58     }
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }