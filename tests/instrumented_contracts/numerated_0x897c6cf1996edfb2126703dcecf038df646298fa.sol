1 pragma solidity ^0.4.15;
2 
3 contract etherDelta {
4     function deposit() payable;
5     function withdraw(uint amount);
6     function depositToken(address token, uint amount);
7     function withdrawToken(address token, uint amount);
8     function balanceOf(address token, address user) constant returns (uint);
9     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce);
10     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount);
11     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private;
12     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);
13     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);
14     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s);
15 }
16 
17 contract Token {
18     function totalSupply() constant returns (uint256 supply);
19     function approve(address _spender, uint256 _value) returns (bool success);
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
21     function balanceOf(address _owner) constant returns (uint256 balance);
22     function transfer(address _to, uint256 _value) returns (bool success);
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
24 }
25 
26 
27 contract TradersWallet {
28     
29     address public owner;
30     string public version;
31     etherDelta private ethDelta;
32     address public ethDeltaDepositAddress;
33     
34     // init the TradersWallet()
35     function TradersWallet() {
36         owner = msg.sender;
37         version = "ALPHA 0.1";
38         ethDeltaDepositAddress = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819;
39         ethDelta = etherDelta(ethDeltaDepositAddress);
40     }
41     
42     // default function
43     function() payable {
44         
45     }
46     
47     // standard erc20 token balance in wallet from specific token address
48     function tokenBalance(address tokenAddress) constant returns (uint) {
49         Token token = Token(tokenAddress);
50         return token.balanceOf(this);
51     }
52     
53     // standard erc20 transferFrom function
54     function transferFromToken(address tokenAddress, address sendTo, address sendFrom, uint256 amount) external {
55         require(msg.sender==owner);
56         Token token = Token(tokenAddress);
57         token.transferFrom(sendTo, sendFrom, amount);
58     }
59     
60     // change owner this this trader wallet
61     function changeOwner(address newOwner) external {
62         require(msg.sender==owner);
63         owner = newOwner;
64     }
65     
66     // send ether to another wallet
67     function sendEther(address toAddress, uint amount) external {
68         require(msg.sender==owner);
69         toAddress.transfer(amount);
70     }
71     
72     // standard erc20 transfer/send function
73     function sendToken(address tokenAddress, address sendTo, uint256 amount) external {
74         require(msg.sender==owner);
75         Token token = Token(tokenAddress);
76         token.transfer(sendTo, amount);
77     }
78     
79     // let the owner execute with data
80     function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r) {
81         require(msg.sender==owner);
82         require(_to.call.value(_value)(_data));
83         return 0;
84     }
85     
86     // get ether delta token balance from token address
87     function EtherDeltaTokenBalance(address tokenAddress) constant returns (uint) {
88         return ethDelta.balanceOf(tokenAddress, this);
89     }
90     
91     // withdraw a token from etherdelta
92     function EtherDeltaWithdrawToken(address tokenAddress, uint amount) payable external {
93         require(msg.sender==owner);
94         ethDelta.withdrawToken(tokenAddress, amount);
95     }
96     
97     // change etherdelta exchange address
98     function changeEtherDeltaDeposit(address newEthDelta) external {
99         require(msg.sender==owner);
100         ethDeltaDepositAddress = newEthDelta;
101         ethDelta = etherDelta(newEthDelta);
102     }
103     
104     // deposit tokens to etherdelta
105     function EtherDeltaDepositToken(address tokenAddress, uint amount) payable external {
106         require(msg.sender==owner);
107         ethDelta.depositToken(tokenAddress, amount);
108     }
109     
110     // approve etherdelta to take take a specific amount
111     function EtherDeltaApproveToken(address tokenAddress, uint amount) payable external {
112         require(msg.sender==owner);
113         Token token = Token(tokenAddress);
114         token.approve(ethDeltaDepositAddress, amount);
115     }
116     
117     // deposit ether to etherdelta
118     function EtherDeltaDeposit(uint amount) payable external {
119         require(msg.sender==owner);
120         ethDelta.deposit.value(amount)();
121     }
122     
123     // withdraw ether from etherdelta
124     function EtherDeltaWithdraw(uint amount) external {
125         require(msg.sender==owner);
126         ethDelta.withdraw(amount);
127     }
128     
129     // destroy this wallet and send all ether to sender
130     // THIS DOES NOT INCLUDE ERC20 TOKENS
131     function kill() {
132         require(msg.sender==owner);
133         suicide(msg.sender);
134     }
135     
136 }