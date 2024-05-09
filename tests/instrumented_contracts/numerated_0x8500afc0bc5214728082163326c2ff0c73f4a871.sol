1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract EtomicSwap {
26     enum PaymentState {
27         Uninitialized,
28         PaymentSent,
29         ReceivedSpent,
30         SenderRefunded
31     }
32 
33     struct Payment {
34         bytes20 paymentHash;
35         uint64 lockTime;
36         PaymentState state;
37     }
38 
39     mapping (bytes32 => Payment) public payments;
40 
41     event PaymentSent(bytes32 id);
42     event ReceiverSpent(bytes32 id, bytes32 secret);
43     event SenderRefunded(bytes32 id);
44 
45     constructor() public { }
46 
47     function ethPayment(
48         bytes32 _id,
49         address _receiver,
50         bytes20 _secretHash,
51         uint64 _lockTime
52     ) external payable {
53         require(_receiver != address(0) && msg.value > 0 && payments[_id].state == PaymentState.Uninitialized);
54 
55         bytes20 paymentHash = ripemd160(abi.encodePacked(
56                 _receiver,
57                 msg.sender,
58                 _secretHash,
59                 address(0),
60                 msg.value
61             ));
62 
63         payments[_id] = Payment(
64             paymentHash,
65             _lockTime,
66             PaymentState.PaymentSent
67         );
68 
69         emit PaymentSent(_id);
70     }
71 
72     function erc20Payment(
73         bytes32 _id,
74         uint256 _amount,
75         address _tokenAddress,
76         address _receiver,
77         bytes20 _secretHash,
78         uint64 _lockTime
79     ) external payable {
80         require(_receiver != address(0) && _amount > 0 && payments[_id].state == PaymentState.Uninitialized);
81 
82         bytes20 paymentHash = ripemd160(abi.encodePacked(
83                 _receiver,
84                 msg.sender,
85                 _secretHash,
86                 _tokenAddress,
87                 _amount
88             ));
89 
90         payments[_id] = Payment(
91             paymentHash,
92             _lockTime,
93             PaymentState.PaymentSent
94         );
95 
96         IERC20 token = IERC20(_tokenAddress);
97         require(token.transferFrom(msg.sender, address(this), _amount));
98         emit PaymentSent(_id);
99     }
100 
101     function receiverSpend(
102         bytes32 _id,
103         uint256 _amount,
104         bytes32 _secret,
105         address _tokenAddress,
106         address _sender
107     ) external {
108         require(payments[_id].state == PaymentState.PaymentSent);
109 
110         bytes20 paymentHash = ripemd160(abi.encodePacked(
111                 msg.sender,
112                 _sender,
113                 ripemd160(abi.encodePacked(sha256(abi.encodePacked(_secret)))),
114                 _tokenAddress,
115                 _amount
116             ));
117 
118         require(paymentHash == payments[_id].paymentHash && now < payments[_id].lockTime);
119         payments[_id].state = PaymentState.ReceivedSpent;
120         if (_tokenAddress == address(0)) {
121             msg.sender.transfer(_amount);
122         } else {
123             IERC20 token = IERC20(_tokenAddress);
124             require(token.transfer(msg.sender, _amount));
125         }
126 
127         emit ReceiverSpent(_id, _secret);
128     }
129 
130     function senderRefund(
131         bytes32 _id,
132         uint256 _amount,
133         bytes20 _paymentHash,
134         address _tokenAddress,
135         address _receiver
136     ) external {
137         require(payments[_id].state == PaymentState.PaymentSent);
138 
139         bytes20 paymentHash = ripemd160(abi.encodePacked(
140                 _receiver,
141                 msg.sender,
142                 _paymentHash,
143                 _tokenAddress,
144                 _amount
145             ));
146 
147         require(paymentHash == payments[_id].paymentHash && now >= payments[_id].lockTime);
148 
149         payments[_id].state = PaymentState.SenderRefunded;
150 
151         if (_tokenAddress == address(0)) {
152             msg.sender.transfer(_amount);
153         } else {
154             IERC20 token = IERC20(_tokenAddress);
155             require(token.transfer(msg.sender, _amount));
156         }
157 
158         emit SenderRefunded(_id);
159     }
160 }