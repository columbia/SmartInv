1 pragma solidity ^0.5;
2 
3 contract ERC20 {
4     mapping(address => mapping(address => uint)) public allowed;
5     function transferFrom(address from, address to, uint amount) public returns (bool);
6     function transfer(address to, uint amount) public returns (bool);
7     function approve(address spender, uint amount) public returns (bool);
8     function balanceOf(address a) public view returns (uint);
9 }
10 
11 contract ProtocolTypes {
12     struct OptionSeries {
13         uint expiration;
14         Flavor flavor;
15         uint strike;
16     }
17     
18     enum Flavor {
19         Call,
20         Put
21     }
22 }
23 
24 contract Protocol is ProtocolTypes {
25     ERC20 public usdERC20;
26     mapping(address => OptionSeries) public seriesInfo;
27     mapping(address => mapping(address => uint)) public writers;
28 
29     function open(address _series, uint amount) public payable;
30     function redeem(address _series) public;
31     function settle(address _series) public;
32     function close(address _series, uint amount) public;
33 }
34 
35 contract Trading is ProtocolTypes {
36     
37     address payable public owner;
38     address public signer = 0x47e3ea40D4F39A8C3a819B90F03FcE162e2fdbe4;
39     
40     Protocol public protocol;
41     ERC20 public usd;
42     
43     enum Action {
44         Buy,
45         Sell
46     }
47     
48     constructor(address _protocol) public {
49         owner = msg.sender;
50         require(_protocol != address(0));
51         protocol = Protocol(_protocol);
52         usd = ERC20(address(protocol.usdERC20()));
53         usd.approve(address(protocol), uint256(0) - 1);
54     }
55     
56     function() external payable {}
57     
58     function trade(Action action, uint expiration, uint getting, uint giving, address token, uint8 v, bytes32 r, bytes32 s) public payable {
59         require(msg.sender == tx.origin);
60         require(expiration > now);
61         require(ecrecover(keccak256(abi.encodePacked(uint8(action), expiration, getting, giving, token)), v, r, s) == signer);
62         
63         Flavor flavor;
64         uint strike;
65 
66         (expiration, flavor, strike) = protocol.seriesInfo(token);
67         if (action == Action.Buy) {
68             require(msg.value == giving);
69             uint owned = ERC20(token).balanceOf(address(this));
70             uint needed = owned < getting ? getting - owned : 0;
71             
72             if (needed > 0) {
73                 // open value in protocol and send to buyer
74                 if (flavor == Flavor.Call) {
75                     protocol.open.value(needed)(token, needed);
76                 } else {
77                     protocol.open(token, needed);
78                 }
79             }
80             
81             ERC20(token).transfer(msg.sender, getting);
82             // require(token.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, getting));
83         } else {
84             require(msg.value == 0);
85             // require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), msg.sender, address(this), giving));
86             ERC20(token).transferFrom(msg.sender, address(this), giving);
87             // close value in protocol and send to seller
88             uint written = protocol.writers(token, address(this));
89             uint closeable = written < giving ? written : giving;
90             
91             if (closeable > 0) {
92                 protocol.close(token, closeable); 
93             }
94 
95             msg.sender.transfer(getting);
96         }
97     }
98     
99     function settleWritten(address token) public {
100         protocol.redeem(token);
101     }
102     
103     function settle(address token) public {
104         protocol.settle(token);
105     }
106     
107     // these functions allow the contract owner to remove liquidity from the contract
108     // they have no impact on users funds since this contract never holds users funds
109     function withdraw(uint amount) public {
110         require(msg.sender == owner);
111         owner.transfer(amount);
112     }
113     
114     function withdrawUSD(uint amount) public {
115         require(msg.sender == owner);
116         usd.transfer(owner, amount);
117     }
118     
119     function withdrawMaxETH() public {
120         withdraw(address(this).balance);
121     }
122     
123     function withdrawToken(address token, uint amount) public {
124         require(msg.sender == owner);
125         ERC20(token).transfer(owner, amount);
126     }
127     
128     function setSigner(address next) public {
129         require(msg.sender == owner);
130         signer = next;
131     }
132 }