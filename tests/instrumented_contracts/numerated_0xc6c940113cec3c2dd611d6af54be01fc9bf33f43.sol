1 pragma solidity 0.4.21;
2 
3 interface DreamToken {
4     function transfer(address receiver, uint amount) external;
5     function transferFrom(address from, address to, uint tokens) external returns (bool success);
6     function totalSupply() external constant returns (uint);
7 }
8 
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14 
15     function safeSub(uint a, uint b) public pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19 
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24 
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract Owned {
32     address public owner;
33     address public newOwner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     function Owned() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address _newOwner) public onlyOwner {
47         newOwner = _newOwner;
48     }
49 
50     function acceptOwnership() public {
51         require(msg.sender == newOwner);
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54         newOwner = address(0);
55     }
56 }
57 
58 contract Crowdsale is Owned, SafeMath {
59     address public escrowAddress;
60     uint public totalEthInWei;
61     
62     uint start = 1529274449;
63     uint period = 1;
64     uint amountPerEther = 1500;
65     uint minAmount = 1e16; // 0.01 ETH
66     DreamToken token;
67 
68     function Crowdsale() public {
69         escrowAddress = owner;
70         token = DreamToken(0xBcd4012cECBbFc7a73EC4a14EBb39406D361a0f5);
71     }
72 
73     function setEscrowAddress(address newAddress)
74     public onlyOwner returns (bool success) {
75         escrowAddress = newAddress;
76 
77         return true;
78     }
79     
80     function setAmountPerEther(uint newAmount)
81     public onlyOwner returns (bool success) {
82         amountPerEther = newAmount;
83 
84         return true;
85     }
86     
87     function getSaleIsOn()
88     public constant returns (bool success) {
89         
90         return now > start && now < start + period * 13 days;
91     }
92     
93     function() external payable {
94         require(getSaleIsOn());
95         require(msg.value >= minAmount);
96         totalEthInWei = totalEthInWei + msg.value;
97         
98         if (owner != msg.sender) {
99             uint amount = safeDiv(msg.value, 1e10);
100             amount = safeMul(amount, amountPerEther);
101             token.transferFrom(owner, msg.sender, amount);
102             
103             //Transfer ether to fundsWallet
104             escrowAddress.transfer(msg.value);
105             //emit Transfer(msg.sender, _to, _value);
106         }
107     }
108 }