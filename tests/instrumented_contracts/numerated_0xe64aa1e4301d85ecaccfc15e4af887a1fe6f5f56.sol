1 pragma solidity ^0.4.11;
2 
3 contract MiningRig {
4     // 警告
5     string public warning = "請各位要有耐心等候交易完成喔";
6     
7     // 合約部署者
8     address public owner = 0x0;
9     
10     // 合約停止合資的區塊，初始 0 
11     uint public closeBlock = 0;
12     
13     // 大家一起合資的總新台幣
14     uint public totalNTD = 0;
15     
16     // 這個合約過去總共被提領過的 reward
17     uint public totalWithdrew = 0;
18     
19     // 使用者各自合資的新台幣
20     mapping(address => uint) public usersNTD;
21     
22     // 使用者提領過的 ether
23     mapping(address => uint) public usersWithdrew;
24     
25     // 只能 owner 才行 的修飾子
26     modifier onlyOwner () {
27         assert(owner == msg.sender);
28         _;
29     }
30     
31     // 在關閉合資前才行 的修飾子
32     modifier beforeCloseBlock () {
33         assert(block.number <= closeBlock);
34         _;
35     }
36     
37     // 在關閉合資後才行 的修飾子
38     modifier afterCloseBlock () {
39         assert(block.number > closeBlock);
40         _;
41     }
42     
43     // 只有有合資過的人才行 的修飾子
44     modifier onlyMember () {
45         assert(usersNTD[msg.sender] != 0);
46         _;
47     }
48     
49     // 建構子
50     function MiningRig () {
51         owner = msg.sender;
52         closeBlock = block.number + 5760; // 一天的 block 數
53     }
54     
55     // 合資，由舉辦人註冊 (因為是合資新台幣，所以必須中心化)
56     function Register (address theUser, uint NTD) onlyOwner beforeCloseBlock {
57         usersNTD[theUser] += NTD;
58         totalNTD += NTD;
59     }
60     
61     // 反合資
62     function Unregister (address theUser, uint NTD) onlyOwner beforeCloseBlock {
63         assert(usersNTD[theUser] >= NTD);
64         
65         usersNTD[theUser] -= NTD;
66         totalNTD -= NTD;
67     }
68     
69     // 提領所分配之以太幣
70     function Withdraw () onlyMember afterCloseBlock {
71         // 這個合約曾經得到過的 ether 等於現有 balance + 曾經被提領過的
72         uint everMined = this.balance + totalWithdrew;
73         
74         // 這個 user 總共終究可以領的
75         uint totalUserCanWithdraw = everMined * usersNTD[msg.sender] / totalNTD;
76         
77         // 這個 user 現在還可以領的
78         uint userCanWithdrawNow = totalUserCanWithdraw - usersWithdrew[msg.sender];
79         
80         // 防止 reentrance 攻擊，先改狀態
81         totalWithdrew += userCanWithdrawNow;
82         usersWithdrew[msg.sender] += userCanWithdrawNow;
83 
84         assert(userCanWithdrawNow > 0);
85         
86         msg.sender.transfer(userCanWithdrawNow);
87     }
88     
89     // 貼現轉讓
90     // 轉讓之前必須把能領的 ether 領完
91     function Cashing (address targetAddress, uint permilleToCashing) onlyMember afterCloseBlock {
92         //permilleToCashing 是千分比
93         assert(permilleToCashing <= 1000);
94         assert(permilleToCashing > 0);
95         
96         // 這個合約曾經得到過的 ether 等於現有 balance + 曾經被提領過的
97         uint everMined = this.balance + totalWithdrew;
98         
99         // 這個要發起轉讓的 user 總共終究可以領的
100         uint totalUserCanWithdraw = everMined * usersNTD[msg.sender] / totalNTD;
101         
102         // 這個要發起轉讓的 user 現在還可以領的
103         uint userCanWithdrawNow = totalUserCanWithdraw - usersWithdrew[msg.sender];
104         
105         // 要接收轉讓的 user 總共終究可以領的
106         uint totalTargetUserCanWithdraw = everMined * usersNTD[targetAddress] / totalNTD;
107         
108         // 要接收轉讓的 user 現在還可以領的
109         uint targetUserCanWithdrawNow = totalTargetUserCanWithdraw - usersWithdrew[targetAddress];
110         
111         // 發起轉讓及接收轉讓之前，雙方皆需要淨空可提領 ether
112         assert(userCanWithdrawNow == 0);
113         assert(targetUserCanWithdrawNow == 0);
114         
115         uint NTDToTransfer = usersNTD[msg.sender] * permilleToCashing / 1000;
116         uint WithdrewToTransfer = usersWithdrew[msg.sender] * permilleToCashing / 1000;
117         
118         usersNTD[msg.sender] -= NTDToTransfer;
119         usersWithdrew[msg.sender] -= WithdrewToTransfer;
120         
121         usersNTD[targetAddress] += NTDToTransfer;
122         usersWithdrew[targetAddress] += WithdrewToTransfer;
123     }
124     
125     function ContractBalance () constant returns (uint) {
126         return this.balance;
127     }
128     
129     function ContractTotalMined() constant returns (uint) {
130         return this.balance + totalWithdrew;
131     }
132     
133     function MyTotalNTD () constant returns (uint) {
134         return usersNTD[msg.sender];
135     }
136     
137     function MyTotalWithdrew () constant returns (uint) {
138         return usersWithdrew[msg.sender];
139     }
140  
141     function () payable {}
142 }