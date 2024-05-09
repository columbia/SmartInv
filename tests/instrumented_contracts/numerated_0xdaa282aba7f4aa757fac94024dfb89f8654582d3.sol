1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     constructor() public {
10         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25         newOwner = address(0);
26     }
27 }
28 
29 interface HourglassInterface  {
30     function() payable external;
31     function buy(address _playerAddress) payable external returns(uint256);
32     function sell(uint256 _amountOfTokens) external;
33     function reinvest() external;
34     function withdraw() external;
35     function exit() external;
36     function dividendsOf(address _playerAddress) external view returns(uint256);
37     function balanceOf(address _playerAddress) external view returns(uint256);
38     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
39     function stakingRequirement() external view returns(uint256);
40 }
41 contract DivGarden is Owned {
42 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
43 
44 function buyp3d(uint256 amt) internal{
45 P3Dcontract_.buy.value(amt)(this);
46 }
47 function claimdivs() internal{
48 P3Dcontract_.withdraw();
49 }
50 // amount of divs available
51 uint256 private ethtosend;
52 mapping(address => uint256) public ticketsavailable;  
53 uint256 public ticket1price =  1 finney;
54 uint256 public tickets10price =  5 finney;
55 uint256 public tickets100price =  25 finney;
56 uint256 public tickets1kprice =  125 finney;
57 uint256 public tickets10kprice =  625 finney;
58 uint256 public tickets100kprice =  3125 finney;
59 address public contrp3d = 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe;
60 uint256 private div ;
61 event onTicketPurchase(
62         address customerAddress,
63         uint256 amount
64     );
65 event onHarvest(
66         address customerAddress,
67         uint256 amount
68     );
69 function harvestabledivs()
70         view
71         public
72         returns(uint256)
73     {
74         return ( P3Dcontract_.dividendsOf(address(this)))  ;
75     }
76 function amountofp3d() external view returns(uint256){
77     return ( P3Dcontract_.balanceOf(address(this)))  ;
78 }
79 
80 function buy1ticket () public payable{
81     require(msg.value >= ticket1price);
82     ticketsavailable[msg.sender] += 1;
83     emit onTicketPurchase(msg.sender,1);
84 }
85 function buy10tickets () public payable{
86     require(msg.value >= tickets10price);
87     ticketsavailable[msg.sender] += 10;
88     emit onTicketPurchase(msg.sender,10);
89 }
90 function buy100tickets () public payable{
91     require(msg.value >= tickets100price);
92     ticketsavailable[msg.sender] += 100;
93     emit onTicketPurchase(msg.sender,100);
94 }
95 function buy1ktickets () public payable{
96     require(msg.value >= tickets1kprice);
97     ticketsavailable[msg.sender] += 1000;
98     emit onTicketPurchase(msg.sender,1000);
99 }
100 function buy10ktickets () public payable{
101     require(msg.value >= tickets10kprice);
102     ticketsavailable[msg.sender] += 10000;
103     emit onTicketPurchase(msg.sender,10000);
104 }
105 function buy100ktickets () public payable{
106     require(msg.value >= tickets100kprice);
107     ticketsavailable[msg.sender] += 100000;
108     emit onTicketPurchase(msg.sender,100000);
109 }
110 
111 function onlyHarvest(uint256 amt) public payable{
112     div = harvestabledivs();
113     require(amt > 0);
114     require(msg.value > 0);
115     require(msg.value * 2 >= amt);
116     require(div > amt);
117     require(ticketsavailable[msg.sender] >= 2);
118     ethtosend = amt;
119     claimdivs();
120     ticketsavailable[msg.sender] -= 2;
121     msg.sender.transfer(ethtosend);
122     emit onHarvest(msg.sender,ethtosend);
123 }
124 function ExpandandHarvest(uint256 amt) public payable{
125     div = harvestabledivs();
126     require(amt > 0);
127     require(msg.value > 0);
128     require(msg.value * 2 >= amt);
129     require(div > amt);
130     require(ticketsavailable[msg.sender] >= 1);
131     //1% to owner
132     ethtosend = this.balance /100;
133     owner.transfer(ethtosend);
134     //99% buy p3d
135     buyp3d(this.balance);
136     ethtosend = amt;
137     claimdivs();
138     ticketsavailable[msg.sender] -= 1;
139     msg.sender.transfer(ethtosend);
140     emit onHarvest(msg.sender,ethtosend);
141 }
142 function Expand() public {
143     require(ticketsavailable[msg.sender] >= 1);
144     //1% to owner
145     ethtosend = this.balance /100;
146     owner.transfer(ethtosend);
147     //99% buy p3d
148     buyp3d(this.balance);
149     ticketsavailable[msg.sender] -= 1;
150 }
151 
152 function () external payable{}
153 }