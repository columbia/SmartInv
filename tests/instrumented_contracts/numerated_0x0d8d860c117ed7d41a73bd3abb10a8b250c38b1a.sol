1 pragma solidity ^0.4.18;
2 
3 /**
4  * ICrowdsale
5  *
6  * Base crowdsale interface to manage the sale of 
7  * an ERC20 token
8  *
9  * #created 09/09/2017
10  * #author Frank Bonnet
11  */
12 interface ICrowdsale {
13 
14     /**
15      * Returns true if the contract is currently in the presale phase
16      *
17      * @return True if in presale phase
18      */
19     function isInPresalePhase() public view returns (bool);
20 
21 
22     /**
23      * Returns true if the contract is currently in the ended stage
24      *
25      * @return True if ended
26      */
27     function isEnded() public view returns (bool);
28 
29 
30     /**
31      * Returns true if `_beneficiary` has a balance allocated
32      *
33      * @param _beneficiary The account that the balance is allocated for
34      * @param _releaseDate The date after which the balance can be withdrawn
35      * @return True if there is a balance that belongs to `_beneficiary`
36      */
37     function hasBalance(address _beneficiary, uint _releaseDate) public view returns (bool);
38 
39 
40     /** 
41      * Get the allocated token balance of `_owner`
42      * 
43      * @param _owner The address from which the allocated token balance will be retrieved
44      * @return The allocated token balance
45      */
46     function balanceOf(address _owner) public view returns (uint);
47 
48 
49     /** 
50      * Get the allocated eth balance of `_owner`
51      * 
52      * @param _owner The address from which the allocated eth balance will be retrieved
53      * @return The allocated eth balance
54      */
55     function ethBalanceOf(address _owner) public view returns (uint);
56 
57 
58     /** 
59      * Get invested and refundable balance of `_owner` (only contributions during the ICO phase are registered)
60      * 
61      * @param _owner The address from which the refundable balance will be retrieved
62      * @return The invested refundable balance
63      */
64     function refundableEthBalanceOf(address _owner) public view returns (uint);
65 
66 
67     /**
68      * Returns the rate and bonus release date
69      *
70      * @param _phase The phase to use while determining the rate
71      * @param _volume The amount wei used to determine what volume multiplier to use
72      * @return The rate used in `_phase` multiplied by the corresponding volume multiplier
73      */
74     function getRate(uint _phase, uint _volume) public view returns (uint);
75 
76 
77     /**
78      * Convert `_wei` to an amount in tokens using 
79      * the `_rate`
80      *
81      * @param _wei amount of wei to convert
82      * @param _rate rate to use for the conversion
83      * @return Amount in tokens
84      */
85     function toTokens(uint _wei, uint _rate) public view returns (uint);
86 
87 
88     /**
89      * Receive ether and issue tokens to the sender
90      * 
91      * This function requires that msg.sender is not a contract. This is required because it's 
92      * not possible for a contract to specify a gas amount when calling the (internal) send() 
93      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
94      * 
95      * Contracts can call the contribute() function instead
96      */
97     function () public payable;
98 
99 
100     /**
101      * Receive ether and issue tokens to the sender
102      *
103      * @return The accepted ether amount
104      */
105     function contribute() public payable returns (uint);
106 
107 
108     /**
109      * Receive ether and issue tokens to `_beneficiary`
110      *
111      * @param _beneficiary The account that receives the tokens
112      * @return The accepted ether amount
113      */
114     function contributeFor(address _beneficiary) public payable returns (uint);
115 
116 
117     /**
118      * Withdraw allocated tokens
119      */
120     function withdrawTokens() public;
121 
122 
123     /**
124      * Withdraw allocated ether
125      */
126     function withdrawEther() public;
127 
128 
129     /**
130      * Refund in the case of an unsuccessful crowdsale. The 
131      * crowdsale is considered unsuccessful if minAmount was 
132      * not raised before end of the crowdsale
133      */
134     function refund() public;
135 }
136 
137 
138 /**
139  * ICrowdsaleProxy
140  *
141  * #created 23/11/2017
142  * #author Frank Bonnet
143  */
144 interface ICrowdsaleProxy {
145 
146     /**
147      * Receive ether and issue tokens to the sender
148      * 
149      * This function requires that msg.sender is not a contract. This is required because it's 
150      * not possible for a contract to specify a gas amount when calling the (internal) send() 
151      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
152      * 
153      * Contracts can call the contribute() function instead
154      */
155     function () public payable;
156 
157 
158     /**
159      * Receive ether and issue tokens to the sender
160      *
161      * @return The accepted ether amount
162      */
163     function contribute() public payable returns (uint);
164 
165 
166     /**
167      * Receive ether and issue tokens to `_beneficiary`
168      *
169      * @param _beneficiary The account that receives the tokens
170      * @return The accepted ether amount
171      */
172     function contributeFor(address _beneficiary) public payable returns (uint);
173 }
174 
175 
176 /**
177  * CrowdsaleProxy
178  *
179  * #created 22/11/2017
180  * #author Frank Bonnet
181  */
182 contract CrowdsaleProxy is ICrowdsaleProxy {
183 
184     address public owner;
185     ICrowdsale public target;
186     
187 
188     /**
189      * Deploy proxy
190      *
191      * @param _owner Owner of the proxy
192      * @param _target Target crowdsale
193      */
194     function CrowdsaleProxy(address _owner, address _target) public {
195         target = ICrowdsale(_target);
196         owner = _owner;
197     }
198 
199 
200     /**
201      * Receive contribution and forward to the crowdsale
202      * 
203      * This function requires that msg.sender is not a contract. This is required because it's 
204      * not possible for a contract to specify a gas amount when calling the (internal) send() 
205      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
206      */
207     function () public payable {
208         target.contributeFor.value(msg.value)(msg.sender);
209     }
210 
211 
212     /**
213      * Receive ether and issue tokens to the sender
214      *
215      * @return The accepted ether amount
216      */
217     function contribute() public payable returns (uint) {
218         target.contributeFor.value(msg.value)(msg.sender);
219     }
220 
221 
222     /**
223      * Receive ether and issue tokens to `_beneficiary`
224      *
225      * @param _beneficiary The account that receives the tokens
226      * @return The accepted ether amount
227      */
228     function contributeFor(address _beneficiary) public payable returns (uint) {
229         target.contributeFor.value(msg.value)(_beneficiary);
230     }
231 }