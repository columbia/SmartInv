1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title SafeERC20
36  * @dev Wrappers around ERC20 operations that throw on failure.
37  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
38  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
39  */
40 library SafeERC20 {
41   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
42     require(token.transfer(to, value));
43   }
44 
45   function safeTransferFrom(
46     ERC20 token,
47     address from,
48     address to,
49     uint256 value
50   )
51     internal
52   {
53     require(token.transferFrom(from, to, value));
54   }
55 
56   function safeApprove(ERC20 token, address spender, uint256 value) internal {
57     require(token.approve(spender, value));
58   }
59 }
60 
61 contract ARPHoldingWallet {
62     using SafeERC20 for ERC20;
63 
64     // Middle term holding
65     uint256 constant MID_TERM   = 1 finney; // = 0.001 ether
66     // Long term holding
67     uint256 constant LONG_TERM  = 2 finney; // = 0.002 ether
68 
69     uint256 constant GAS_LIMIT  = 200000;
70 
71     address owner;
72 
73     // ERC20 basic token contract being held
74     ERC20 arpToken;
75     address midTermHolding;
76     address longTermHolding;
77 
78     /// Initialize the contract
79     constructor(address _owner, ERC20 _arpToken, address _midTermHolding, address _longTermHolding) public {
80         owner = _owner;
81         arpToken = _arpToken;
82         midTermHolding = _midTermHolding;
83         longTermHolding = _longTermHolding;
84     }
85 
86     /*
87      * PUBLIC FUNCTIONS
88      */
89 
90     function() payable public {
91         require(msg.sender == owner);
92 
93         if (msg.value == MID_TERM) {
94             depositOrWithdraw(midTermHolding);
95         } else if (msg.value == LONG_TERM) {
96             depositOrWithdraw(longTermHolding);
97         } else if (msg.value == 0) {
98             drain();
99         } else {
100             revert();
101         }
102     }
103 
104     function depositOrWithdraw(address _holding) private {
105         uint256 amount = arpToken.balanceOf(address(this));
106         if (amount > 0) {
107             arpToken.safeApprove(_holding, amount);
108         }
109         require(_holding.call.gas(GAS_LIMIT)());
110         amount = arpToken.balanceOf(address(this));
111         if (amount > 0) {
112             arpToken.safeTransfer(msg.sender, amount);
113         }
114         msg.sender.transfer(msg.value);
115     }
116 
117     /// Drains ARP.
118     function drain() private {
119         uint256 amount = arpToken.balanceOf(address(this));
120         require(amount > 0);
121 
122         arpToken.safeTransfer(owner, amount);
123     }
124 }
125 
126 contract ARPHoldingWalletCreator {
127     /* 
128      * EVENTS
129      */
130     event Created(address indexed _owner, address _wallet);
131 
132     mapping (address => address) public wallets;
133     ERC20 public arpToken;
134     address public midTermHolding;
135     address public longTermHolding;
136 
137     constructor(ERC20 _arpToken, address _midTermHolding, address _longTermHolding) public {
138         arpToken = _arpToken;
139         midTermHolding = _midTermHolding;
140         longTermHolding = _longTermHolding;
141     }
142 
143     function() public {
144         require(wallets[msg.sender] == address(0x0));
145 
146         address wallet = new ARPHoldingWallet(msg.sender, arpToken, midTermHolding, longTermHolding);
147         wallets[msg.sender] = wallet;
148 
149         emit Created(msg.sender, wallet);
150     }
151 }