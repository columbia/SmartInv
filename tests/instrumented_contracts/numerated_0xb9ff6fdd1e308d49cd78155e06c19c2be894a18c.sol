1 pragma solidity ^0.4.0;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 interface token {
27     function transfer(address to, uint tokens) external;
28     function balanceOf(address tokenOwner) external returns(uint balance);
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40     event tokensBought(address _addr, uint _amount);
41     event tokensCalledBack(uint _amount);
42     event privateSaleEnded(uint _time);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         owner = _newOwner;
55         emit OwnershipTransferred(owner, _newOwner);
56     }
57 
58 }
59 
60 
61 contract Crowdsale is Owned{
62     using SafeMath for uint;
63     uint public endDate;
64     address public developer;
65     address public marketing;
66     address public kelly;
67     address public company;
68     uint public phaseOneEnd;
69     uint public phaseTwoEnd;
70     uint public phaseThreeEnd;
71     token public CCC;
72     
73     event tokensBought(address _addr, uint _amount);
74     constructor() public{
75     phaseOneEnd = now + 3 days;
76     phaseTwoEnd = now + 6 days;
77     phaseThreeEnd = now + 29 days;
78     CCC = token(0x4446B2551d7aCdD1f606Ef3Eed9a9af913AE3e51);
79     developer = 0x215c6e1FaFa372E16CfD3cA7D223fc7856018793;
80     company = 0x49BAf97cc2DF6491407AE91a752e6198BC109339;
81     kelly = 0x36e8A1C0360B733d6a4ce57a721Ccf702d4008dE;
82     marketing = 0x4DbADf088EEBc22e9A679f4036877B1F7Ce71e4f;
83     }
84     
85     function() payable public{
86         require(msg.value >= 0.3 ether);
87         require(now < phaseThreeEnd);
88         uint tokens;
89         if (now <= phaseOneEnd) {
90             tokens = msg.value * 6280;
91         } else if (now > phaseOneEnd && now <= phaseTwoEnd) {
92             tokens = msg.value * 6280;
93         }else if( now > phaseTwoEnd && now <= phaseThreeEnd){
94             tokens = msg.value * 6280;
95         }
96         CCC.transfer(msg.sender, tokens);
97         emit tokensBought(msg.sender, tokens);
98     }
99     
100     function safeWithdrawal() public onlyOwner {
101         require(now >= phaseThreeEnd);
102         uint amount = address(this).balance;
103         uint devamount = amount/uint(100);
104         uint devamtFinal = devamount*5;
105         uint marketamtFinal = devamount*5;
106         uint kellyamtFinal = devamount*5;
107         uint companyamtFinal = devamount*85;
108         developer.transfer(devamtFinal);
109         marketing.transfer(marketamtFinal);
110         company.transfer(companyamtFinal);
111         kelly.transfer(kellyamtFinal);
112 
113         
114     }
115     
116 
117     function withdrawTokens() public onlyOwner{
118         require(now >= phaseThreeEnd);
119         uint Ownerbalance = CCC.balanceOf(this);
120     	CCC.transfer(owner, Ownerbalance);
121     	emit tokensCalledBack(Ownerbalance);
122 
123     }
124     
125 }