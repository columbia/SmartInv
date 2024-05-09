1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // PublickOffering by Xender Limited.
5 // An ERC20 standard
6 //
7 // author: Xender Team
8 // Contact: service@xender.com
9 // ----------------------------------------------------------------------------------------------
10 
11 contract Authority {
12     
13     // contract administrator
14     address public owner;
15     
16     // publick offering beneficiary
17     address public beneficiary;
18     
19     // publick offering has closed
20     bool public closed = false;
21     
22     // allowed draw ETH
23     bool public allowDraw = true;
24     
25      modifier onlyOwner() { 
26         require(msg.sender == owner);
27         _;
28     }
29     
30     modifier onlyBeneficiary(){
31         require(msg.sender == beneficiary);
32         _;
33     }
34     
35     modifier alloweDrawEth(){
36        if(allowDraw){
37            _;
38        }
39     }
40     
41     function Authority() public {
42         owner = msg.sender;
43         beneficiary = msg.sender;
44     }
45     
46     function open() public onlyOwner {
47         closed = false;
48     }
49     
50     function close() public onlyOwner {
51         closed = true;
52     }
53     
54     function setAllowDrawETH(bool _allow) public onlyOwner{
55         allowDraw = _allow;
56     }
57 }
58 
59 contract PublickOffering is Authority {
60     
61     // invest info
62     struct investorInfo{
63         address investor;
64         uint256 amount;
65         uint    utime;
66         bool    hadback;
67     }
68     
69     // investors bills
70     mapping(uint => investorInfo) public bills;
71     
72     // recive ETH total amount
73     uint256 public totalETHSold;
74     
75     // investor number
76     uint public lastAccountNum;
77     
78     // min ETH
79     uint256 public constant minETH = 0.2 * 10 ** 18;
80     
81     // max ETH
82     uint256 public constant maxETH = 20 * 10 ** 18;
83     
84     event Bill(address indexed sender, uint256 value, uint time);
85     event Draw(address indexed _addr, uint256 value, uint time);
86     event Back(address indexed _addr, uint256 value, uint time);
87     
88     function PublickOffering() public {
89         totalETHSold = 0;
90         lastAccountNum = 0;
91     }
92     
93     function () public payable {
94         if(!closed){
95             require(msg.value >= minETH);
96             require(msg.value <= maxETH);
97             bills[lastAccountNum].investor = msg.sender;
98             bills[lastAccountNum].amount = msg.value;
99             bills[lastAccountNum].utime = now;
100             totalETHSold += msg.value;
101             lastAccountNum++;
102             Bill(msg.sender, msg.value, now);
103         } else {
104             revert();
105         }
106     }
107     
108     function drawETH(uint256 amount) public onlyBeneficiary alloweDrawEth{
109         beneficiary.transfer(amount);
110         Draw(msg.sender, amount, now);
111     }
112     
113     function backETH(uint pos) public onlyBeneficiary{
114         if(!bills[pos].hadback){
115             require(pos < lastAccountNum);
116             bills[pos].investor.transfer(bills[pos].amount);
117             bills[pos].hadback = true;
118             Back(bills[pos].investor, bills[pos].amount, now);
119         }
120     }
121     
122 }