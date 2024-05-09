1 pragma solidity ^0.4.19;
2 
3 /**
4  * EIP-20 token whose price (in ether terms) is always raising.
5  * Hurry to invest early!
6  */
7 contract RaisingToken {
8     /**
9      * Total number of tokens in circulation.
10      */
11     uint256 public totalSupply;
12 
13     /**
14      * Maps address of token holder to the number of tokens currently belonging
15      * to this token holder.
16      */
17     mapping (address => uint256) public balanceOf;
18 
19     /**
20      * Maps address of token holder and address of spender to the number of
21      * tokens this spender is allowed to transfer from this token holder.
22      */
23     mapping (address => mapping (address => uint256)) allowance;
24 
25     /**
26      * Deploy RaisingToken smart contract, issue one token and sell it to
27      * message sender for ether provided.
28      */
29     function RaisingToken () public payable {
30         // Make sure some ether was provided
31         require (msg.value > 0);
32 
33         // Issue one token...
34         totalSupply = 1;
35 
36         // ... and give it to message sender
37         balanceOf [msg.sender] = 1;
38 
39         // Log token creation
40         Transfer (address (0), msg.sender, 1);
41     }
42 
43     /**
44      * Issue and buy more tokens.
45      */
46     function buy() public payable {
47         // Calculate number of token that could be bought for ether provided
48         uint256 count = msg.value * totalSupply / this.balance;
49 
50         // Proceed only if some tokens could actually be bought.
51         require (count > 0);
52 
53         // Issue tokens ...        
54         totalSupply += count;
55 
56         // ... and give them to message sender
57         balanceOf [msg.sender] += count;
58 
59         // Log token creation
60         Transfer (address (0), msg.sender, count);
61     }
62 
63     /**
64      * Sell and burn given number of tokens.
65      *
66      * @param _value number of tokens to sell
67      * @return true if tokens were sold successfully, false otherwise
68      */
69     function sell(uint256 _value) public returns (bool) {
70         // Proceed only if
71         // 1. Number of tokens to be sold is non-zero
72         // 2. Some tokens will still exist after burning tokens to be sold
73         // 3. Message sender has enough tokens to sell
74         if (_value > 0 &&
75             _value < totalSupply &&
76             _value <= balanceOf [msg.sender]) {
77             // Calculate amount of ether to be sent to seller
78             uint256 toSend = _value * this.balance / totalSupply;
79 
80             // If we failed to send ether to seller ...
81             if (!msg.sender.send (toSend))
82                 return false; // ... report failure
83 
84             // Take tokens from seller ...
85             balanceOf [msg.sender] -= _value;
86 
87             // ... and burn them
88             totalSupply -= _value;
89 
90             // Log token burning
91             Transfer (msg.sender, address (0), _value);
92 
93             // Report success
94             return true;
95         } else return false; // Report failure
96     }
97 
98     /**
99      * Get token name.
100      * 
101      * @return token name
102      */
103     function name() public pure returns (string) {
104         return "RaisingToken";
105     }
106 
107     /**
108      * Get token symbol.
109      * 
110      * @return token symbol
111      */
112     function symbol() public pure returns (string) {
113         return "RAT";
114     }
115 
116     /**
117      * Get token decimals.
118      * 
119      * @return token decimals
120      */
121     function decimals() public pure returns (uint8) {
122         return 0;
123     }
124 
125     /**
126      * Transfer given number of tokens from message sender to the owner of given
127      * address.  Charge commission of 1 token and burn it.
128      *
129      * @param _to address to send tokens to the owner of
130      * @param _value number of token to send (recepient will get one less)
131      * @return true if tokens were sent successfully, false otherwise
132      */
133     function transfer(address _to, uint256 _value) public returns (bool) {
134         // Proceed only if
135         // 1. There are more than 1 tokens being transferred
136         // 2. Message sender has enough tokens
137         if (_value > 1 && _value >= balanceOf [msg.sender]) {
138             // Take tokens from message sender
139             balanceOf [msg.sender] -= _value;
140 
141             // Decrement transfer value by one
142             _value -= 1;
143 
144             // Give tokens to recipient
145             balanceOf [_to] += _value;
146 
147             // Burn commission
148             totalSupply -= 1;
149 
150             // Log token transfer
151             Transfer (msg.sender, _to, _value);
152 
153             // Log token burning
154             Transfer (msg.sender, address (0), 1);
155 
156             // Report success
157             return true;
158         } else return false; // Report failure
159     }
160 
161     /**
162      * Transfer given number of tokens from the owner of given sender address to
163      * the owner of given destination address.  Owner of sender address should
164      * approve transfer in advance.  Charge commission of 1 token and burn it.
165      *
166      * @param _from source address
167      * @param _to destination address
168      * @param _value number of tokens to transfer (recipient will receive one
169      *        less)
170      * @return true if tokens were sent successfully, false otherwise
171      */
172     function transferFrom(address _from, address _to, uint256 _value)
173         public returns (bool) {
174         // Proceed only If
175         // 1. There are more than 1 tokens being transferred
176         // 2. Transfer is approved by the owner of source address
177         // 3. The owner of source address has enough tokens
178         if (_value > 1 &&
179             _value >= allowance [_from][msg.sender] &&
180             _value >= balanceOf [_from]) {
181             // Reduce number of tokens message sender is allowed to transfer
182             // from the owner of source address
183             allowance [_from][msg.sender] -= _value;
184 
185             // Take tokens from the owner of source address
186             balanceOf [_from] -= _value;
187 
188             // Decrement transfer value by one
189             _value -= 1;
190 
191             // Give tokens to the owner of destination address
192             balanceOf [_to] += _value;
193     
194             // Burn commission
195             totalSupply -= 1;
196     
197             // Log token transfer
198             Transfer (_from, _to, _value);
199 
200             // Log token burning
201             Transfer (_from, address (0), 1);
202     
203             // Report success
204             return true;
205         } else return false; // Report failure
206     }
207 
208     /**
209      * Allow owher of given spender address to transfer at most given number of
210      * tokens from message sender.
211      *
212      * @param _spender address to allow transfer for the owner of
213      * @param _value number of tokens to allow transfer of
214      * @return true if transfer was approved successfully, false otherwise
215      */
216     function approve(address _spender, uint256 _value) public returns (bool) {
217         // Approve token transfer
218         allowance [msg.sender][_spender] = _value;
219 
220         // Log transfer approval
221         Approval (msg.sender, _spender, _value);
222     }
223 
224     /**
225      * Logged when tokens were transferred, created, or burned.
226      *
227      * @param _from address tokens were transferred from or zero if tokens were
228      *        created
229      * @param _to address tokens were transferred to or zero if tokens were
230      *        burned
231      * @param _value number of tokens transferred, created, or burned
232      */
233     event Transfer(
234         address indexed _from, address indexed _to, uint256 _value);
235 
236     /**
237      * Logged when token transfer was approved.
238      *
239      * @param _owner address of the owner of tokens approved to be transferred
240      * @param _spender spender approved to transfer tokens
241      * @param _value number of tokens approved to be trasferred
242      */
243     event Approval(
244         address indexed _owner, address indexed _spender, uint256 _value);
245 }