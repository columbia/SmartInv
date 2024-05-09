1 pragma solidity 0.4.15;
2 
3 /**
4  * Basic interface for contracts, following ERC20 standard
5  */
6 contract ERC20Token {
7     
8 
9     /**
10      * Triggered when tokens are transferred.
11      * @param from - address tokens were transfered from
12      * @param to - address tokens were transfered to
13      * @param value - amount of tokens transfered
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * Triggered whenever allowance status changes
19      * @param owner - tokens owner, allowance changed for
20      * @param spender - tokens spender, allowance changed for
21      * @param value - new allowance value (overwriting the old value)
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * Returns total supply of tokens ever emitted
27      * @return totalSupply - total supply of tokens ever emitted
28      */
29     function totalSupply() constant returns (uint256 totalSupply);
30 
31     /**
32      * Returns `owner` balance of tokens
33      * @param owner address to request balance for
34      * @return balance - token balance of `owner`
35      */
36     function balanceOf(address owner) constant returns (uint256 balance);
37 
38     /**
39      * Transfers `amount` of tokens to `to` address
40      * @param  to - address to transfer to
41      * @param  value - amount of tokens to transfer
42      * @return success - `true` if the transfer was succesful, `false` otherwise
43      */
44     function transfer(address to, uint256 value) returns (bool success);
45 
46     /**
47      * Transfers `value` tokens from `from` address to `to`
48      * the sender needs to have allowance for this operation
49      * @param  from - address to take tokens from
50      * @param  to - address to send tokens to
51      * @param  value - amount of tokens to send
52      * @return success - `true` if the transfer was succesful, `false` otherwise
53      */
54     function transferFrom(address from, address to, uint256 value) returns (bool success);
55 
56     /**
57      * Allow spender to withdraw from your account, multiple times, up to the value amount.
58      * If this function is called again it overwrites the current allowance with `value`.
59      * this function is required for some DEX functionality
60      * @param spender - address to give allowance to
61      * @param value - the maximum amount of tokens allowed for spending
62      * @return success - `true` if the allowance was given, `false` otherwise
63      */
64     function approve(address spender, uint256 value) returns (bool success);
65 
66     /**
67      * Returns the amount which `spender` is still allowed to withdraw from `owner`
68      * @param  owner - tokens owner
69      * @param  spender - addres to request allowance for
70      * @return remaining - remaining allowance (token count)
71      */
72     function allowance(address owner, address spender) constant returns (uint256 remaining);
73 }
74 
75 
76 
77 /**
78  * @title Token Holder
79  * Given a ERC20 compatible Token allows holding for a certain amount of time
80  * after that time, the beneficiar can acquire his Tokens
81  */
82  contract TokenHolder {
83     
84     
85     
86 
87     uint256 constant MIN_TOKENS_TO_HOLD = 1000;
88 
89     /**
90      * A single token deposit for a certain amount of time for a certain beneficiar
91      */
92     struct TokenDeposit {
93         uint256 tokens;
94         uint256 releaseTime;
95     }
96 
97     /** Emited when Tokens where put on hold
98      * @param tokens - amount of Tokens
99      * @param beneficiar - the address that will be able to claim Tokens in the future
100      * @param depositor - the address deposited tokens
101      * @param releaseTime - timestamp of a moment which `beneficiar` would be able to claim Tokens after
102      */
103     event Deposited(address indexed depositor, address indexed beneficiar, uint256 tokens, uint256 releaseTime);
104 
105     /** Emited when Tokens where claimed back
106      * @param tokens - amount of Tokens claimed
107      * @param beneficiar - who claimed the Tokens
108      */
109     event Claimed(address indexed beneficiar, uint256 tokens);
110 
111     /** all the deposits made */
112     mapping(address => TokenDeposit[]) deposits;
113 
114     /** Tokens contract instance */
115     ERC20Token public tokenContract;
116 
117     /**
118      * Creates the Token Holder with the specifief `ERC20` Token Contract instance
119      * @param _tokenContract `ERC20` Token Contract instance to use
120      */
121     function TokenHolder (address _tokenContract)   {  
122         tokenContract = ERC20Token(_tokenContract);
123     }
124 
125     /**
126      * Puts some amount of Tokens on hold to be retrieved later
127      * @param  tokenCount - amount of tokens
128      * @param  tokenBeneficiar - will be able to retrieve tokens in the future
129      * @param  depositTime - time to hold in seconds
130      */
131     function depositTokens (uint256 tokenCount, address tokenBeneficiar, uint256 depositTime)   {  
132         require(tokenCount >= MIN_TOKENS_TO_HOLD);
133         require(tokenContract.allowance(msg.sender, address(this)) >= tokenCount);
134 
135         if(tokenContract.transferFrom(msg.sender, address(this), tokenCount)) {
136             deposits[tokenBeneficiar].push(TokenDeposit(tokenCount, now + depositTime));
137             Deposited(msg.sender, tokenBeneficiar, tokenCount, now + depositTime);
138         }
139     }
140 
141     /**
142      * Returns the amount of deposits for `beneficiar`
143      */
144     function getDepositCount (address beneficiar)   constant   returns (uint count) {  
145         return deposits[beneficiar].length;
146     }
147 
148     /**
149      * returns the `idx` deposit for `beneficiar`
150      */
151     function getDeposit (address beneficiar, uint idx)   constant   returns (uint256 deposit_dot_tokens, uint256 deposit_dot_releaseTime) {  
152 TokenDeposit memory deposit;
153 
154         require(idx < deposits[beneficiar].length);
155         deposit = deposits[beneficiar][idx];
156     deposit_dot_tokens = uint256(deposit.tokens);
157 deposit_dot_releaseTime = uint256(deposit.releaseTime);}
158 
159     /**
160      * Transfers all the Tokens already unlocked to `msg.sender`
161      */
162     function claimAllTokens ()   {  
163         uint256 toPay = 0;
164 
165         TokenDeposit[] storage myDeposits = deposits[msg.sender];
166 
167         uint idx = 0;
168         while(true) {
169             if(idx >= myDeposits.length) { break; }
170             if(now > myDeposits[idx].releaseTime) {
171                 toPay += myDeposits[idx].tokens;
172                 myDeposits[idx] = myDeposits[myDeposits.length - 1];
173                 myDeposits.length--;
174             } else {
175                 idx++;
176             }
177         }
178 
179         if(toPay > 0) {
180             tokenContract.transfer(msg.sender, toPay);
181             Claimed(msg.sender, toPay);
182         }
183     }
184 }