1 pragma solidity ^0.4.16;
2 
3 /**
4  * PornTokenV2 PT Upgrader on Ethereum Network: Ropsten Testnet
5  * Converts PT to PTWO on a 4:1 reverse split basis
6  *
7  * The PT user transferring to PTWO must call
8  * The approve(_address_of_this_contract, uint256 _value) function
9  * from original token contract: 0x66497A283E0a007bA3974e837784C6AE323447de
10  *
11  * NOTE: _value must be expressed in the number of PT you want to convert + 18 zeros
12  * to represent it's 18 decimal places.
13  * So if you want to send 1 PT, do approve(_address_of_this_contract, 1000000000000000000)
14  *
15  * ...with the address of this Contract as the first argument
16  * and the amount of PT to convert to PTWO as the 2nd argument
17  *
18  * Then they must call the ptToPtwo() method in this contract
19  * and they will receive a 4:1 reverse split amount of PTWO
20  * meaning 4 times less PTWO than PT
21  */
22 
23 interface token {
24     function transfer(address receiver, uint amount);
25     function allowance(address _owner, address _spender) constant returns (uint remaining);
26     function transferFrom(address _from, address _to, uint _value) returns (bool success);
27 }
28 
29 contract PornTokenV2Upgrader {
30     address public exchanger;
31     token public tokenExchange;
32     token public tokenPtx;
33 
34     event Transfer(address indexed _from, address indexed _to, uint _value);
35 
36     /**
37      * Constructor function
38      *
39      * Setup the owner
40      */
41     function PornTokenV2Upgrader(
42         address sendTo,
43         address addressOfPt,
44         address addressOfPtwo
45     ) {
46         exchanger = sendTo;
47         // address of PT Contract
48         tokenPtx = token(addressOfPt);
49         // address of PTWO Contract
50         tokenExchange = token(addressOfPtwo);
51     }
52 
53     /**
54      * Transfer tokens from other address
55      * Effectively a 4:1 trade from PT to PTWO
56      */
57     function ptToPtwo() public returns (bool success) {
58         
59         uint tokenAmount = tokenPtx.allowance(msg.sender, this);
60         require(tokenAmount > 0); 
61         uint tokenAmountReverseSplitAdjusted = tokenAmount / 4;
62         require(tokenAmountReverseSplitAdjusted > 0); 
63         require(tokenPtx.transferFrom(msg.sender, this, tokenAmount));
64         tokenExchange.transfer(msg.sender, tokenAmountReverseSplitAdjusted);
65         return true;
66     }
67 
68     /**
69      * Fallback function
70      *
71      * Fail if Ether is sent to prevent people from sending ETH by accident
72      */
73     function () payable {
74         require(exchanger == msg.sender);
75     }
76     
77     /* PTWO WITHDRAW FUNCTIONS */
78     
79     /**
80      * Withdraw untraded tokens 10K at a time
81      *
82      * Deposit untraded tokens to PornToken Account 100k Safe
83      */
84     function returnUnsoldSafeSmall() public {
85         if (exchanger == msg.sender) {
86             uint tokenAmount = 10000;
87             tokenExchange.transfer(exchanger, tokenAmount * 1 ether);
88         }
89     }
90     
91     /**
92      * Withdraw untraded tokens 100K at a time
93      *
94      * Deposit untraded tokens to PornToken Account 100k Safe
95      */
96     function returnUnsoldSafeMedium() public {
97         if (exchanger == msg.sender) {
98             uint tokenAmount = 100000;
99             tokenExchange.transfer(exchanger, tokenAmount * 1 ether);
100         }
101     }
102     
103     /**
104      * Withdraw untraded tokens 1M at a time
105      *
106      * Deposit untraded tokens to PornToken Account 100k Safe
107      */
108     function returnUnsoldSafeLarge() public {
109         if (exchanger == msg.sender) {
110             uint tokenAmount = 1000000;
111             tokenExchange.transfer(exchanger, tokenAmount * 1 ether);
112         }
113     }
114     
115     /**
116      * Withdraw untraded tokens 10M at a time
117      *
118      * Deposit untraded tokens to PornToken Account 100k Safe
119      */
120     function returnUnsoldSafeXLarge() public {
121         if (exchanger == msg.sender) {
122             uint tokenAmount = 10000000;
123             tokenExchange.transfer(exchanger, tokenAmount * 1 ether);
124         }
125     }
126     
127     /* PT WITHDRAW FUNCTIONS */
128     
129     /**
130      * Withdraw traded tokens 10K at a time
131      *
132      * Deposit traded tokens to PornToken Account 100k Safe
133      */
134     function returnPtSafeSmall() public {
135         if (exchanger == msg.sender) {
136             uint tokenAmount = 10000;
137             tokenPtx.transfer(exchanger, tokenAmount * 1 ether);
138         }
139     }
140     
141     /**
142      * Withdraw traded tokens 100K at a time
143      *
144      * Deposit traded tokens to PornToken Account 100k Safe
145      */
146     function returnPtSafeMedium() public {
147         if (exchanger == msg.sender) {
148             uint tokenAmount = 100000;
149             tokenPtx.transfer(exchanger, tokenAmount * 1 ether);
150         }
151     }
152     
153     /**
154      * Withdraw traded tokens 1M at a time
155      *
156      * Deposit traded tokens to PornToken Account 100k Safe
157      */
158     function returnPtSafeLarge() public {
159         if (exchanger == msg.sender) {
160             uint tokenAmount = 1000000;
161             tokenPtx.transfer(exchanger, tokenAmount * 1 ether);
162         }
163     }
164     
165     /**
166      * Withdraw traded tokens 10M at a time
167      *
168      * Deposit traded tokens to PornToken Account 100k Safe
169      */
170     function returnPtSafeXLarge() public {
171         if (exchanger == msg.sender) {
172             uint tokenAmount = 10000000;
173             tokenPtx.transfer(exchanger, tokenAmount * 1 ether);
174         }
175     }
176 }