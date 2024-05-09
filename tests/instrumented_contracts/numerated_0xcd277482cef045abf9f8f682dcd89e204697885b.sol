1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract SafeMath {
22     function mul(uint a, uint b) internal pure returns (uint) {
23         uint c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 
28     function div(uint a, uint b) internal pure returns (uint) {
29         assert(b > 0);
30         uint c = a / b;
31         assert(a == b * c + a % b);
32         return c;
33     }
34 
35     function sub(uint a, uint b) internal pure returns (uint) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint a, uint b) internal pure returns (uint) {
41         uint c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 interface Qobi {
48     function transfer(address _to, uint256 _value) external returns (bool success);
49     function balanceOf(address _owner) external view returns (uint256 balance);
50 }
51 
52 // for test, not use on production
53 contract Airdrop is SafeMath, Owned {
54     Qobi public token;
55     event CandySent(address user, uint256 amount);
56 
57     constructor(address _addressOfToken) public {
58         token = Qobi(_addressOfToken);
59     }
60 
61     function sendCandy(address[] dests, uint256[] values) onlyOwner public returns(bool success) {
62         require(dests.length > 0);
63         require(dests.length == values.length);
64 
65         // calculate total amount
66         uint256 totalAmount = 0;
67         for (uint i = 0; i < values.length; i++) {
68             totalAmount = add(totalAmount, values[i]);
69         }
70 
71         require(totalAmount > 0, "total amount must > 0");
72         require(totalAmount < token.balanceOf(address(this)), "total amount must < this address token balance ");
73 
74         for (uint j = 0; j < dests.length; j++) {
75             token.transfer(dests[j], values[j]); // mul decimal
76             emit CandySent(dests[j], values[j]);
77         }
78 
79         return true;
80     }
81 }