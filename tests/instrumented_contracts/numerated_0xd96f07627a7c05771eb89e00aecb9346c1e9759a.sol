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
75 pragma solidity 0.4.15;
76 
77 /**
78  * @title Blind Croupier Token
79  * WIN fixed supply Token, used for Blind Croupier TokenDistribution
80  */
81  contract WIN is ERC20Token {
82     
83 
84     string public constant symbol = "WIN";
85     string public constant name = "WIN";
86 
87     uint8 public constant decimals = 7;
88     uint256 constant TOKEN = 10**7;
89     uint256 constant MILLION = 10**6;
90     uint256 public totalTokenSupply = 500 * MILLION * TOKEN;
91 
92     /** balances of each accounts */
93     mapping(address => uint256) balances;
94 
95     /** amount of tokens approved for transfer */
96     mapping(address => mapping (address => uint256)) allowed;
97 
98     /** Triggered when `owner` destroys `amount` tokens */
99     event Destroyed(address indexed owner, uint256 amount);
100 
101     /**
102      * Constucts the token, and supplies the creator with `totalTokenSupply` tokens
103      */
104     function WIN ()   { 
105         balances[msg.sender] = totalTokenSupply;
106     }
107 
108     /**
109      * Returns total supply of tokens ever emitted
110      * @return result - total supply of tokens ever emitted
111      */
112     function totalSupply ()  constant  returns (uint256 result) { 
113         result = totalTokenSupply;
114     }
115 
116     /**
117     * Returns `owner` balance of tokens
118     * @param owner address to request balance for
119     * @return balance - token balance of `owner`
120     */
121     function balanceOf (address owner)  constant  returns (uint256 balance) { 
122         return balances[owner];
123     }
124 
125     /**
126      * Transfers `amount` of tokens to `to` address
127      * @param  to - address to transfer to
128      * @param  amount - amount of tokens to transfer
129      * @return success - `true` if the transfer was succesful, `false` otherwise
130      */
131     function transfer (address to, uint256 amount)   returns (bool success) { 
132         if(balances[msg.sender] < amount)
133             return false;
134 
135         if(amount <= 0)
136             return false;
137 
138         if(balances[to] + amount <= balances[to])
139             return false;
140 
141         balances[msg.sender] -= amount;
142         balances[to] += amount;
143         Transfer(msg.sender, to, amount);
144         return true;
145     }
146 
147     /**
148      * Transfers `amount` tokens from `from` address to `to`
149      * the sender needs to have allowance for this operation
150      * @param  from - address to take tokens from
151      * @param  to - address to send tokens to
152      * @param  amount - amount of tokens to send
153      * @return success - `true` if the transfer was succesful, `false` otherwise
154      */
155     function transferFrom (address from, address to, uint256 amount)   returns (bool success) { 
156         if (balances[from] < amount)
157             return false;
158 
159         if(allowed[from][msg.sender] < amount)
160             return false;
161 
162         if(amount == 0)
163             return false;
164 
165         if(balances[to] + amount <= balances[to])
166             return false;
167 
168         balances[from] -= amount;
169         allowed[from][msg.sender] -= amount;
170         balances[to] += amount;
171         Transfer(from, to, amount);
172         return true;
173     }
174 
175     /**
176      * Allow spender to withdraw from your account, multiple times, up to the amount amount.
177      * If this function is called again it overwrites the current allowance with `amount`.
178      * this function is required for some DEX functionality
179      * @param spender - address to give allowance to
180      * @param amount - the maximum amount of tokens allowed for spending
181      * @return success - `true` if the allowance was given, `false` otherwise
182      */
183     function approve (address spender, uint256 amount)   returns (bool success) { 
184        allowed[msg.sender][spender] = amount;
185        Approval(msg.sender, spender, amount);
186        return true;
187    }
188 
189     /**
190      * Returns the amount which `spender` is still allowed to withdraw from `owner`
191      * @param  owner - tokens owner
192      * @param  spender - addres to request allowance for
193      * @return remaining - remaining allowance (token count)
194      */
195     function allowance (address owner, address spender)  constant  returns (uint256 remaining) { 
196         return allowed[owner][spender];
197     }
198 
199      /**
200       * Destroys `amount` of tokens permanently, they cannot be restored
201       * @return success - `true` if `amount` of tokens were destroyed, `false` otherwise
202       */
203     function destroy (uint256 amount)   returns (bool success) { 
204         if(amount == 0) return false;
205         if(balances[msg.sender] < amount) return false;
206         balances[msg.sender] -= amount;
207         totalTokenSupply -= amount;
208         Destroyed(msg.sender, amount);
209     }
210 }