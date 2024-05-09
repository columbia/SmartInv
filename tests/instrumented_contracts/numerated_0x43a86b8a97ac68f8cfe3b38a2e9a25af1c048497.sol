1 contract owned {
2     function owned() {
3         owner = msg.sender;
4     }
5 
6     address public owner;
7 
8     modifier onlyowner { if (msg.sender != owner) throw; _ }
9 
10     event OwnershipTransfer(address indexed from, address indexed to);
11 
12     function transferOwnership(address to) public onlyowner {
13         owner = to;
14         OwnershipTransfer(msg.sender, to);
15     }
16 }
17 // Token standard API
18 // https://github.com/ethereum/EIPs/issues/20
19 contract ERC20 {
20     function totalSupply() constant returns (uint supply);
21     function balanceOf(address who) constant returns (uint value);
22     function allowance(address owner, address spender) constant returns (uint _allowance);
23     function transfer(address to, uint value) returns (bool ok);
24     function transferFrom(address from, address to, uint value) returns (bool ok);
25     function approve(address spender, uint value) returns (bool ok);
26     event Transfer(address indexed from, address indexed to, uint value);
27     event Approval(address indexed owner, address indexed spender, uint value);
28 }
29 
30 
31 contract Order is owned {
32     ERC20 public token;
33     uint public weiPerToken;
34     uint public decimalPlaces;
35 
36     function Order(address _token, uint _weiPerToken, uint _decimalPlaces) {
37         token = ERC20(_token);
38         weiPerToken = _weiPerToken;
39         decimalPlaces = _decimalPlaces;
40     }
41 
42     function sendRobust(address to, uint value) internal {
43         if (!to.send(value)) {
44             if (!to.call.value(value)()) throw;
45         }
46     }
47 
48     function min(uint a, uint b) internal returns (uint) {
49         if (a <= b) {
50             return a;
51         } else {
52             return b;
53         }
54     }
55 
56     function getTransferableBalance(address who) internal returns (uint amount) {
57         uint allowance = token.allowance(msg.sender, address(this));
58         uint balance = token.balanceOf(msg.sender);
59 
60         amount = min(min(allowance, balance), numTokensAbleToPurchase());
61 
62         return amount;
63     }
64 
65     function numTokensAbleToPurchase() constant returns (uint) {
66         return (this.balance / weiPerToken) * decimalPlaces;
67     }
68 
69     event OrderFilled(address _from, uint numTokens);
70 
71     // Fills or partially fills the order.
72     function _fillOrder(address _from, uint numTokens) internal returns (bool) {
73         if (numTokens == 0) throw;
74         if (this.balance < numTokens * weiPerToken / decimalPlaces) throw;
75 
76         if (!token.transferFrom(_from, owner, numTokens)) return false;
77         sendRobust(_from, numTokens * weiPerToken / decimalPlaces);
78         OrderFilled(_from, numTokens);
79         return true;
80     }
81 
82     function fillOrder(address _from, uint numTokens) public returns (bool) {
83         return _fillOrder(_from, numTokens);
84     }
85 
86     // Simpler call signature that uses `msg.sender`
87     function fillMyOrder(uint numTokens) public returns (bool) {
88         return _fillOrder(msg.sender, numTokens);
89     }
90 
91     // Simpler call signature that defaults to the account allowance.
92     function fillTheirOrder(address who) public returns (bool) {
93         return _fillOrder(who, getTransferableBalance(who));
94     }
95 
96     // Simpler call signature that uses `msg.sender` and the current approval
97     // value.
98     function fillOrderAuto() public returns (bool) {
99         return _fillOrder(msg.sender, getTransferableBalance(msg.sender));
100     }
101 
102     // Even simpler call signature that tries to transfer as many as possible.
103     function () {
104         // allow receipt of funds
105         if (msg.value > 0) {
106             return;
107         } else {
108             fillOrderAuto();
109         }
110     }
111 
112     // Cancel the order, returning all funds to the owner.
113     function cancel() onlyowner {
114         selfdestruct(owner);
115     }
116 }