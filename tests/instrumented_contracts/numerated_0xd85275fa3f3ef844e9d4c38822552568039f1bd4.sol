1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-21
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title Legacy ERC20 interface
32  */
33 interface ILegacyERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address who) external view returns (uint256);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function transfer(address to, uint256 value) external;
41 
42     function approve(address spender, uint256 value) external;
43 
44     function transferFrom(address from, address to, uint256 value) external;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract EtomicSwap {
52     enum PaymentState {
53         Uninitialized,
54         PaymentSent,
55         ReceivedSpent,
56         SenderRefunded
57     }
58 
59     struct Payment {
60         bytes20 paymentHash;
61         uint64 lockTime;
62         PaymentState state;
63     }
64 
65     mapping (bytes32 => Payment) public payments;
66 
67     event PaymentSent(bytes32 id);
68     event ReceiverSpent(bytes32 id, bytes32 secret);
69     event SenderRefunded(bytes32 id);
70 
71     constructor() public { }
72 
73     function ethPayment(
74         bytes32 _id,
75         address _receiver,
76         bytes20 _secretHash,
77         uint64 _lockTime
78     ) external payable {
79         require(_receiver != address(0) && msg.value > 0 && payments[_id].state == PaymentState.Uninitialized);
80 
81         bytes20 paymentHash = ripemd160(abi.encodePacked(
82                 _receiver,
83                 msg.sender,
84                 _secretHash,
85                 address(0),
86                 msg.value
87             ));
88 
89         payments[_id] = Payment(
90             paymentHash,
91             _lockTime,
92             PaymentState.PaymentSent
93         );
94 
95         emit PaymentSent(_id);
96     }
97 
98     function erc20Payment(
99         bytes32 _id,
100         uint256 _amount,
101         address _tokenAddress,
102         bool _isLegacyToken,
103         address _receiver,
104         bytes20 _secretHash,
105         uint64 _lockTime
106     ) external payable {
107         require(_receiver != address(0) && _amount > 0 && payments[_id].state == PaymentState.Uninitialized);
108 
109         bytes20 paymentHash = ripemd160(abi.encodePacked(
110                 _receiver,
111                 msg.sender,
112                 _secretHash,
113                 _tokenAddress,
114                 _amount
115             ));
116 
117         payments[_id] = Payment(
118             paymentHash,
119             _lockTime,
120             PaymentState.PaymentSent
121         );
122 
123         if (_isLegacyToken) {
124             ILegacyERC20 token = ILegacyERC20(_tokenAddress);
125             token.transferFrom(msg.sender, address(this), _amount);
126         } else {
127             IERC20 token = IERC20(_tokenAddress);
128             require(token.transferFrom(msg.sender, address(this), _amount));
129         }
130         emit PaymentSent(_id);
131     }
132 
133     function receiverSpend(
134         bytes32 _id,
135         uint256 _amount,
136         bytes32 _secret,
137         address _tokenAddress,
138         bool _isLegacyToken,
139         address _sender
140     ) external {
141         require(payments[_id].state == PaymentState.PaymentSent);
142 
143         bytes20 paymentHash = ripemd160(abi.encodePacked(
144                 msg.sender,
145                 _sender,
146                 ripemd160(abi.encodePacked(sha256(abi.encodePacked(_secret)))),
147                 _tokenAddress,
148                 _amount
149             ));
150 
151         require(paymentHash == payments[_id].paymentHash && now < payments[_id].lockTime);
152         payments[_id].state = PaymentState.ReceivedSpent;
153         if (_tokenAddress == address(0)) {
154             msg.sender.transfer(_amount);
155         } else {
156             if (_isLegacyToken) {
157                 ILegacyERC20 token = ILegacyERC20(_tokenAddress);
158                 token.transfer(msg.sender, _amount);
159             } else {
160                 IERC20 token = IERC20(_tokenAddress);
161                 require(token.transfer(msg.sender, _amount));
162             }
163         }
164 
165         emit ReceiverSpent(_id, _secret);
166     }
167 
168     function senderRefund(
169         bytes32 _id,
170         uint256 _amount,
171         bytes20 _paymentHash,
172         address _tokenAddress,
173         bool _isLegacyToken,
174         address _receiver
175     ) external {
176         require(payments[_id].state == PaymentState.PaymentSent);
177 
178         bytes20 paymentHash = ripemd160(abi.encodePacked(
179                 _receiver,
180                 msg.sender,
181                 _paymentHash,
182                 _tokenAddress,
183                 _amount
184             ));
185 
186         require(paymentHash == payments[_id].paymentHash && now >= payments[_id].lockTime);
187 
188         payments[_id].state = PaymentState.SenderRefunded;
189 
190         if (_tokenAddress == address(0)) {
191             msg.sender.transfer(_amount);
192         } else {
193             if (_isLegacyToken) {
194                 ILegacyERC20 token = ILegacyERC20(_tokenAddress);
195                 token.transfer(msg.sender, _amount);
196             } else {
197                 IERC20 token = IERC20(_tokenAddress);
198                 require(token.transfer(msg.sender, _amount));
199             }
200         }
201 
202         emit SenderRefunded(_id);
203     }
204 }