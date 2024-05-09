1 pragma solidity ^0.4.14;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function add(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a + b;
13         assert(c >= a);
14         return c;
15     }
16 }
17 
18 
19 contract Ownable {
20     address public owner;
21 
22     function Ownable() {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address newOwner) onlyOwner {
32         require(newOwner != address(0));
33         owner = newOwner;
34     }
35 
36 }
37 
38 
39 contract MintableToken {
40     function mint(address _to, uint256 _amount) returns (bool);
41 }
42 
43 
44 contract CryptoSlotsCrowdsale is Ownable {
45     using SafeMath for uint256;
46 
47     MintableToken public token;
48 
49     bool public isCrowdsaleOpen = true;
50 
51     address public wallet;
52 
53     uint256 public rate = 400;
54 
55     uint256 public weiRaised;
56 
57     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount, uint256 tokenAmount);
58 
59     event CrowdsaleFinished();
60 
61     function CryptoSlotsCrowdsale() {
62         wallet = msg.sender;
63     }
64 
65     function deleteContract() onlyOwner
66     {
67         selfdestruct(msg.sender);
68     }
69 
70     function() payable {
71         buyTokens(msg.sender);
72     }
73 
74     function buyTokens(address beneficiary) payable {
75         require(beneficiary != 0x0);
76         require(msg.value != 0);
77         require(isCrowdsaleOpen);
78 
79         uint256 weiAmount = msg.value;
80 
81         uint256 tokenAmount = weiAmount.mul(rate);
82 
83         weiRaised = weiRaised.add(weiAmount);
84 
85         token.mint(beneficiary, tokenAmount);
86         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
87 
88         wallet.transfer(msg.value);
89     }
90 
91     function stopCrowdsale() onlyOwner {
92         require(isCrowdsaleOpen);
93 
94         isCrowdsaleOpen = false;
95         CrowdsaleFinished();
96     }
97 
98     function setWallet(address value) onlyOwner {
99         require(value != 0x0);
100         wallet = value;
101     }
102 
103     function setRate(uint value) onlyOwner {
104         require(value != 0);
105         rate = value;
106     }
107 
108     function setToken(address value) onlyOwner {
109         require(value != 0x0);
110         token = MintableToken(value);
111     }
112 }