1 pragma solidity >=0.4.23 <0.6.0;
2 
3 interface UmiTokenInterface {
4     function putIntoBlacklist(address _addr) external;
5 
6     function removeFromBlacklist(address _addr) external;
7 
8     function inBlacklist(address _addr) external view returns (bool);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function mint(address account, uint256 amount) external returns (bool);
13 
14     function balanceOf(address account) external view returns (uint256);
15 }
16 
17 interface UniSageInterface {
18     function isUserExists(address user) external view returns (bool);
19 }
20 
21 contract UMIChrismas {
22     address owner;
23 
24     //mainnet
25     address public umiTokenAddr = 0xf61DdA9A827cff208b6242FCF72AD1bB2006A995;
26     //goerli
27     // address public umiTokenAddr = 0x3B4005397f57804BEbFAf5B0aFA3B2DD13CD7F0F; 
28     UmiTokenInterface public umiToken = UmiTokenInterface(umiTokenAddr);
29 
30     //mainnet
31     address public unisageAddr = 0xd4845cBc79acE2cc6E48C8671a5860FfAB920bC2;
32     //goerli
33     // address public unisageAddr = 0xf61DdA9A827cff208b6242FCF72AD1bB2006A995;
34     
35     UniSageInterface public unisage = UniSageInterface(unisageAddr);
36 
37     //switch
38     bool public open = true;
39 
40     //total airdrop
41     uint256 public totalAirdropAmount = 100000000000000000000000;
42     //single address can receive amount
43     uint256 public singleAirdropAmount = 100000000000000000000;
44     //referrer address can receive amount
45     uint256 public singleAirdropAmountForReferrer = 0;
46 
47     //statics
48     uint256 public hasAirdropAmount = 0;
49 
50     //
51     mapping(address => bool) public successList;
52 
53     //event list
54     event chrismasAirdropEvent(address indexed userAddr, uint256 airdropAmount);
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     ////////////////////////////////////////////////////////////////////////////////
61     //user operation
62 
63     function isUserJoined(address user) public view returns (bool) {
64         return successList[user];
65     }
66 
67     function getChrismasAirdrop() external {
68         //condition 1, switch is open
69         require(open, "umi chrismas has been closed");
70 
71         //condition 2, not in umi blacklist
72         bool isInblacklist = umiToken.inBlacklist(msg.sender);
73         require(!isInblacklist, "address is in blacklist");
74 
75         //condition 3 , not registered
76         bool isRegisterd = unisage.isUserExists(msg.sender);
77         require(!isRegisterd, "address is exsits");
78 
79         //condition 4, not joined before
80         bool isJoined = isUserJoined(msg.sender);
81         require(!isJoined, "address has been join already");
82 
83         //condition 5, the remain airdrop amount is enough
84         require(
85             hasAirdropAmount + singleAirdropAmount <= totalAirdropAmount,
86             "the remain airdrop amount is not enough"
87         );
88 
89         //transfer
90         umiToken.transfer(msg.sender,singleAirdropAmount);
91         umiToken.putIntoBlacklist(msg.sender);
92 
93         hasAirdropAmount = hasAirdropAmount + singleAirdropAmount;
94 
95         //record
96         successList[msg.sender] = true;
97 
98         emit chrismasAirdropEvent(msg.sender, singleAirdropAmount);
99     }
100 
101     ////////////////////////////////////////////////////////////////////////////////
102     // owner operation
103     function refreshOpen(bool _open) external {
104         require(msg.sender == owner, "only owner can do this operation");
105         open = _open;
106     }
107 
108     function changeTotalAirdropAmount(uint256 amount) external {
109         require(msg.sender == owner, "only owner can do this operation");
110         totalAirdropAmount = amount;
111     }
112 
113     function changeSingleAirdropAmount(uint256 amount) external {
114         require(msg.sender == owner, "only owner can do this operation");
115         singleAirdropAmount = amount;
116     }
117 
118     function changeSingleAirdropAmountForReferrer(uint256 amount) external {
119         require(msg.sender == owner, "only owner can do this operation");
120         singleAirdropAmountForReferrer = amount;
121     }
122 
123     function changeUmiTokenAddr(address _addr) external {
124         require(msg.sender == owner, "only owner can do this operation");
125         umiTokenAddr = _addr;
126         umiToken = UmiTokenInterface(umiTokenAddr);
127     }
128 
129     function changeUnisageAddr(address _addr) external {
130         require(msg.sender == owner, "only owner can do this operation");
131         unisageAddr = _addr;
132         unisage = UniSageInterface(unisageAddr);
133     }
134 }