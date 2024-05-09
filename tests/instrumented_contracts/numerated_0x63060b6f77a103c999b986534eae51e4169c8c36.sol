1 // Copyright New Alchemy Limited, 2017. All rights reserved.
2 pragma solidity >=0.4.10;
3 
4 // Just the bits of ERC20 that we need.
5 contract Token {
6     function balanceOf(address addr) returns(uint);
7     function transfer(address to, uint amount) returns(bool);
8 }
9 
10 // Receiver is the contract that takes contributions
11 contract Receiver {
12     event StartSale();
13     event EndSale();
14     event EtherIn(address from, uint amount);
15 
16     address public owner;    // contract owner
17     address public newOwner; // new contract owner for two-way ownership handshake
18     string public notice;    // arbitrary public notice text
19 
20     Sale public sale;
21 
22     function Receiver() {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     modifier onlySale() {
32         require(msg.sender == address(sale));
33         _;
34     }
35 
36     function live() constant returns(bool) {
37         return sale.live();
38     }
39 
40     // callback from sale contract when the sale begins
41     function start() onlySale {
42         StartSale();
43     }
44 
45     // callback from sale contract when sale ends
46     function end() onlySale {
47         EndSale();
48     }
49 
50     function () payable {
51         // forward everything to the sale contract
52         EtherIn(msg.sender, msg.value);
53         require(sale.call.value(msg.value)());
54     }
55 
56     // 1st half of ownership change
57     function changeOwner(address next) onlyOwner {
58         newOwner = next;
59     }
60 
61     // 2nd half of ownership change
62     function acceptOwnership() {
63         require(msg.sender == newOwner);
64         owner = msg.sender;
65         newOwner = 0;
66     }
67 
68     // put some text in the contract
69     function setNotice(string note) onlyOwner {
70         notice = note;
71     }
72 
73     // set the target sale address
74     function setSale(address s) onlyOwner {
75         sale = Sale(s);
76     }
77 
78     // Ether gets sent to the main sale contract,
79     // but tokens get sent here, so we still need
80     // withdrawal methods.
81 
82     // withdraw tokens to owner
83     function withdrawToken(address token) onlyOwner {
84         Token t = Token(token);
85         require(t.transfer(msg.sender, t.balanceOf(this)));
86     }
87 
88     // refund early/late tokens
89     function refundToken(address token, address sender, uint amount) onlyOwner {
90         Token t = Token(token);
91         require(t.transfer(sender, amount));
92     }
93 }
94 
95 contract Sale {
96     // once the balance of this contract exceeds the
97     // soft-cap, the sale should stay open for no more
98     // than this amount of time
99     uint public constant SOFTCAP_TIME = 4 hours;
100 
101     address public owner;    // contract owner
102     address public newOwner; // new contract owner for two-way ownership handshake
103     string public notice;    // arbitrary public notice text
104     uint public start;       // start time of sale
105     uint public end;         // end time of sale
106     uint public cap;         // Ether hard cap
107     uint public softcap;     // Ether soft cap
108     bool public live;        // sale is live right now
109 
110     Receiver public r0;
111     Receiver public r1;
112     Receiver public r2;
113 
114     function Sale() {
115         owner = msg.sender;
116     }
117 
118     modifier onlyOwner() {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     // tell the receivers that the sale has begun
124     function emitBegin() internal {
125         r0.start();
126         r1.start();
127         r2.start();
128     }
129 
130     // tell the receivers that the sale is over
131     function emitEnd() internal {
132         r0.end();
133         r1.end();
134         r2.end();
135     }
136 
137     function () payable {
138         // only accept contributions from receiver contracts
139         require(msg.sender == address(r0) || msg.sender == address(r1) || msg.sender == address(r2));
140         require(block.timestamp >= start);
141 
142         // if we've gone past the softcap, make sure the sale
143         // stays open for no longer than SOFTCAP_TIME past the current block
144         if (this.balance > softcap && block.timestamp < end && (end - block.timestamp) > SOFTCAP_TIME)
145             end = block.timestamp + SOFTCAP_TIME;
146 
147         // If we've reached end-of-sale conditions, accept
148         // this as the last contribution and emit the EndSale event.
149         // (Technically this means we allow exactly one contribution
150         // after the end of the sale.)
151         // Conversely, if we haven't started the sale yet, emit
152         // the StartSale event.
153         if (block.timestamp > end || this.balance > cap) {
154             require(live);
155             live = false;
156             emitEnd();
157         } else if (!live) {
158             live = true;
159             emitBegin();
160         }
161     }
162 
163     function init(uint _start, uint _end, uint _cap, uint _softcap) onlyOwner {
164         start = _start;
165         end = _end;
166         cap = _cap;
167         softcap = _softcap;
168     }
169 
170     function setReceivers(address a, address b, address c) onlyOwner {
171         r0 = Receiver(a);
172         r1 = Receiver(b);
173         r2 = Receiver(c);
174     }
175 
176     // 1st half of ownership change
177     function changeOwner(address next) onlyOwner {
178         newOwner = next;
179     }
180 
181     // 2nd half of ownership change
182     function acceptOwnership() {
183         require(msg.sender == newOwner);
184         owner = msg.sender;
185         newOwner = 0;
186     }
187 
188     // put some text in the contract
189     function setNotice(string note) onlyOwner {
190         notice = note;
191     }
192 
193     // withdraw all of the Ether
194     function withdraw() onlyOwner {
195         msg.sender.transfer(this.balance);
196     }
197 
198     // withdraw some of the Ether
199     function withdrawSome(uint value) onlyOwner {
200         require(value <= this.balance);
201         msg.sender.transfer(value);
202     }
203 
204     // withdraw tokens to owner
205     function withdrawToken(address token) onlyOwner {
206         Token t = Token(token);
207         require(t.transfer(msg.sender, t.balanceOf(this)));
208     }
209 
210     // refund early/late tokens
211     function refundToken(address token, address sender, uint amount) onlyOwner {
212         Token t = Token(token);
213         require(t.transfer(sender, amount));
214     }
215 }