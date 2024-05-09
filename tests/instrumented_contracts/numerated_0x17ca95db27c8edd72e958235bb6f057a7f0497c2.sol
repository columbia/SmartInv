1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 
5 /**
6  * @title 资产汇总
7  */
8 contract FundSummary {
9 
10     address private _owner;     // 资金汇总目标地址
11     address public fundAddress; // 资产汇总地址
12     mapping(address => bool) private _sendTransferAddress;  // 可以发起批量转账的地址
13 
14 
15     // 管理员地址，USDT合约地址，CNHC合约地址，支付gasfee发起交易地址
16     constructor(address _fundAddress,address sendTransferAddress) public{
17         fundAddress = _fundAddress;
18         _owner = msg.sender;
19         _sendTransferAddress[sendTransferAddress] = true;
20     }
21 
22     function batchTransfer(address contractAddress,address user1) public onlyTransferAddress{
23         ERC20 erc20 = ERC20(contractAddress);
24         batchTransfer(erc20,user1);
25     }
26     function batchTransfer(address contractAddress,address user1,address user2) public onlyTransferAddress{
27         ERC20 erc20 = ERC20(contractAddress);
28         batchTransfer(erc20,user1);
29         batchTransfer(erc20,user2);
30     }
31     function batchTransfer(address contractAddress,address user1,address user2,address user3) public onlyTransferAddress{
32         ERC20 erc20 = ERC20(contractAddress);
33         batchTransfer(erc20,user1);
34         batchTransfer(erc20,user2);
35         batchTransfer(erc20,user3);
36     }
37     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4) public onlyTransferAddress{
38         ERC20 erc20 = ERC20(contractAddress);
39         batchTransfer(erc20,user1);
40         batchTransfer(erc20,user2);
41         batchTransfer(erc20,user3);
42         batchTransfer(erc20,user4);
43     }
44     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5) public onlyTransferAddress{
45         ERC20 erc20 = ERC20(contractAddress);
46         batchTransfer(erc20,user1);
47         batchTransfer(erc20,user2);
48         batchTransfer(erc20,user3);
49         batchTransfer(erc20,user4);
50         batchTransfer(erc20,user5);
51     }
52     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6) public onlyTransferAddress{
53         ERC20 erc20 = ERC20(contractAddress);
54         batchTransfer(erc20,user1);
55         batchTransfer(erc20,user2);
56         batchTransfer(erc20,user3);
57         batchTransfer(erc20,user4);
58         batchTransfer(erc20,user5);
59         batchTransfer(erc20,user6);
60     }
61     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7) public onlyTransferAddress{
62         ERC20 erc20 = ERC20(contractAddress);
63         batchTransfer(erc20,user1);
64         batchTransfer(erc20,user2);
65         batchTransfer(erc20,user3);
66         batchTransfer(erc20,user4);
67         batchTransfer(erc20,user5);
68         batchTransfer(erc20,user6);
69         batchTransfer(erc20,user7);
70     }
71     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7,address user8) public onlyTransferAddress{
72         ERC20 erc20 = ERC20(contractAddress);
73         batchTransfer(erc20,user1);
74         batchTransfer(erc20,user2);
75         batchTransfer(erc20,user3);
76         batchTransfer(erc20,user4);
77         batchTransfer(erc20,user5);
78         batchTransfer(erc20,user6);
79         batchTransfer(erc20,user7);
80         batchTransfer(erc20,user8);
81     }
82     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7,address user8,address user9) public onlyTransferAddress{
83         ERC20 erc20 = ERC20(contractAddress);
84         batchTransfer(erc20,user1);
85         batchTransfer(erc20,user2);
86         batchTransfer(erc20,user3);
87         batchTransfer(erc20,user4);
88         batchTransfer(erc20,user5);
89         batchTransfer(erc20,user6);
90         batchTransfer(erc20,user7);
91         batchTransfer(erc20,user8);
92         batchTransfer(erc20,user9);
93     }
94     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7,address user8,address user9,address user10) public onlyTransferAddress{
95         ERC20 erc20 = ERC20(contractAddress);
96         batchTransfer(erc20,user1);
97         batchTransfer(erc20,user2);
98         batchTransfer(erc20,user3);
99         batchTransfer(erc20,user4);
100         batchTransfer(erc20,user5);
101         batchTransfer(erc20,user6);
102         batchTransfer(erc20,user7);
103         batchTransfer(erc20,user8);
104         batchTransfer(erc20,user9);
105         batchTransfer(erc20,user10);
106     }
107     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7,address user8,address user9,address user10,address user11) public onlyTransferAddress{
108         ERC20 erc20 = ERC20(contractAddress);
109         batchTransfer(erc20,user1);
110         batchTransfer(erc20,user2);
111         batchTransfer(erc20,user3);
112         batchTransfer(erc20,user4);
113         batchTransfer(erc20,user5);
114         batchTransfer(erc20,user6);
115         batchTransfer(erc20,user7);
116         batchTransfer(erc20,user8);
117         batchTransfer(erc20,user9);
118         batchTransfer(erc20,user10);
119         batchTransfer(erc20,user11);
120     }
121     function batchTransfer(address contractAddress,address user1,address user2,address user3,address user4,address user5,address user6,address user7,address user8,address user9,address user10,address user11,address user12) public onlyTransferAddress{
122         ERC20 erc20 = ERC20(contractAddress);
123         batchTransfer(erc20,user1);
124         batchTransfer(erc20,user2);
125         batchTransfer(erc20,user3);
126         batchTransfer(erc20,user4);
127         batchTransfer(erc20,user5);
128         batchTransfer(erc20,user6);
129         batchTransfer(erc20,user7);
130         batchTransfer(erc20,user8);
131         batchTransfer(erc20,user9);
132         batchTransfer(erc20,user10);
133         batchTransfer(erc20,user11);
134         batchTransfer(erc20,user12);
135     }
136     //转账指定资产
137     function batchTransfer(ERC20 erc20Contract,address user) private{
138         uint256 erc20Balance = erc20Contract.balanceOf(user);
139         if(erc20Balance > 0){
140             erc20Contract.transferFrom(user,fundAddress,erc20Balance);
141         }
142     }
143     // 验证可以调用合约发起批量转账的地址
144     function verificationSendTransferAddress(address addr) public view returns (bool){
145         return _sendTransferAddress[addr];
146     }
147     // 取出合约里面的ERC20资产(预防不小心将ERC20打进来了)
148     function turnOut(address contractAddress) public onlyOwner{
149         ERC20 erc20 = ERC20(contractAddress);
150         erc20.transfer(fundAddress,erc20.balanceOf(address(this)));
151     }
152     // 增加可以调用批量转账的地址
153     function addSendTransferAddress(address addr) public onlyTransferAddress{
154         _sendTransferAddress[addr] = true;
155         emit AddSendTransferAddress(msg.sender,addr);
156     }
157     // 删除可以调用批量转账的地址
158     function subSendTransferAddress(address addr) public onlyTransferAddress{
159         _sendTransferAddress[addr] = false;
160         emit SubSendTransferAddress(msg.sender,addr);
161     }
162     // 查看管理员地址
163     function checkOwner() public view returns (address){
164         return _owner;
165     }
166     // 更新资产汇总地址
167     function updateFundAddress(address addr) public onlyOwner{
168         fundAddress = addr;
169     }
170     // 更新管理员地址
171     function updateOwner(address addr) public onlyOwner{
172         _owner = addr;
173         emit UpdateOwner(_owner);
174     }
175     //  仅限管理员操作
176     modifier onlyOwner(){
177         require(msg.sender == _owner, "No authority");
178         _;
179     }
180     // 仅限转账交易地址操作
181     modifier onlyTransferAddress(){
182         require(_sendTransferAddress[msg.sender], "No authority");
183         _;
184     }
185     event UpdateOwner(address indexed owner);
186     event AddSendTransferAddress(address indexed sendAddress,address indexed addr);
187     event SubSendTransferAddress(address indexed sendAddress,address indexed addr);
188 
189 }
190 
191 interface ERC20 {
192     function balanceOf(address account) external view returns (uint256);
193     function transfer(address recipient, uint256 amount) external;
194     function transferFrom(address sender, address recipient, uint256 amount) external;
195 }