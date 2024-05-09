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
41 contract DivMultisigHackable is Owned {
42 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
43 
44 function buyp3d(uint256 amt) internal{
45 P3Dcontract_.buy.value(amt)(this);
46 }
47 function claimdivs() internal{
48 P3Dcontract_.withdraw();
49 }
50 // amount of divs available
51 
52 struct HackableSignature {
53     address owner;
54     uint256 hackingcost;
55     uint256 encryption;
56 }
57 uint256 private ethtosend;
58 uint256 private nexId;
59 uint256 public totalsigs;
60 mapping(uint256 => HackableSignature) public Multisigs;  
61 mapping(address => uint256) public lasthack;
62 
63 address public contrp3d = 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe;
64 uint256 private div;
65 uint256 private count;
66 constructor(uint256 amtsigs) public{
67     for(nexId = 0; nexId < amtsigs;nexId++){
68     Multisigs[nexId].owner = msg.sender;
69     Multisigs[nexId].hackingcost = 1;
70     Multisigs[nexId].encryption = 1;
71 }
72 totalsigs = amtsigs;
73 }
74 event onHarvest(
75         address customerAddress,
76         uint256 amount
77     );
78 function harvestabledivs()
79         view
80         public
81         returns(uint256)
82     {
83         return ( P3Dcontract_.dividendsOf(address(this)))  ;
84     }
85 function amountofp3d() external view returns(uint256){
86     return ( P3Dcontract_.balanceOf(address(this)))  ;
87 }
88 function Hacksig(uint256 nmbr) public payable{
89     require(lasthack[msg.sender] < block.number);
90     require(nmbr < totalsigs);
91     require(Multisigs[nmbr].owner != msg.sender);
92     require(msg.value >= Multisigs[nmbr].hackingcost + Multisigs[nmbr].encryption);
93     Multisigs[nmbr].owner = msg.sender;
94     Multisigs[nmbr].hackingcost ++;
95     Multisigs[nmbr].encryption = 0;
96     lasthack[msg.sender] = block.number;
97 }
98 function Encrypt(uint256 nmbr) public payable{
99     require(Multisigs[nmbr].owner == msg.sender);//prevent encryption of hacked sig
100     Multisigs[nmbr].encryption += msg.value;
101     }
102 
103 function HackDivs() public payable{
104     div = harvestabledivs();
105     require(msg.value >= 1 finney);
106     require(div > 0);
107     count = 0;
108     for(nexId = 0; nexId < totalsigs;nexId++){
109     if(Multisigs[nexId].owner == msg.sender){
110         count++;
111     }
112 }
113 require(count > totalsigs/2);
114     claimdivs();
115     //1% to owner
116     ethtosend = div /100;
117     owner.transfer(ethtosend);
118     ethtosend = ethtosend * 99;
119     msg.sender.transfer(ethtosend);
120     emit onHarvest(msg.sender,ethtosend);
121 }
122 
123 function Expand() public {
124     //1% to owner
125     ethtosend = this.balance /100;
126     owner.transfer(ethtosend);
127     //99% buy p3d
128     buyp3d(this.balance);
129 }
130 
131 function () external payable{}
132 }