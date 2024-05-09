1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7 
8     function allowance(address owner, address spender) public view returns (uint256);
9     function transferFrom(address from, address to, uint256 value) public returns (bool);
10     function approve(address spender, uint256 value) public returns (bool);
11 
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * Aethia CHI Token
18  *
19  * Chi is the in-game currency used throughout Aethia. This contract governs
20  * the ownership and transfer of all Chi within the game.
21  */
22 contract ChiToken is ERC20 {
23 
24     /**
25      * The currency is named Chi.
26      * 
27      * The currency's symbol is 'CHI'. The different uses for the two are as 
28      * follows:
29      *  - "That Jelly Pill will cost you 5 CHI."
30      *  - "Did you know Aethia uses Chi as currency?"
31      */
32     string public name = 'Chi';
33     string public symbol = 'CHI';
34     
35     /**
36      * There is ten-billion Chi in circulation.
37      */
38     uint256 _totalSupply = 10000000000;
39     
40     /**
41      * Chi is an atomic currency.
42      * 
43      * It is not possible to have a fraction of a Chi. You are only able to have
44      * integer values of Chi tokens.
45      */
46     uint256 public decimals = 0;
47 
48     /**
49      * The amount of CHI owned per address.
50      */
51     mapping (address => uint256) balances;
52     
53     /**
54      * The amount of CHI an owner has allowed a certain spender.
55      */
56     mapping (address => mapping (address => uint256)) allowances;
57 
58     /**
59      * Chi token transfer event.
60      * 
61      * For audit and logging purposes, as well as to adhere to the ERC-20
62      * standard, all chi token transfers are logged by benefactor and 
63      * beneficiary.
64      */
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     
67     /**
68      * Chi token allowance approval event.
69      * 
70      * For audit and logging purposes, as well as to adhere to the ERC-20
71      * standard, all chi token allowance approvals are logged by owner and 
72      * approved spender.
73      */
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 
76     /**
77      * Contract constructor.
78      * 
79      * This creates all ten-billion Chi tokens and sets them to the creating
80      * address. From this address, the tokens will be distributed to the proper
81      * locations.
82      */
83     function ChiToken() public {
84         balances[msg.sender] = _totalSupply;
85     }
86     
87     /**
88      * The total supply of Chi tokens. 
89      * 
90      * Returns
91      * -------
92      * uint256
93      *     The total number of Chi tokens in circulation.
94      */
95     function totalSupply() public view returns (uint256) {
96         return _totalSupply;
97     }
98 
99     /**
100      * Get Chi balance of an address.
101      * 
102      * Parameters 
103      * ----------
104      * address : _owner
105      *     The address to return the Chi balance of.
106      * 
107      * Returns
108      * -------
109      * uint256
110      *     The amount of Chi owned by given address.
111      */
112     function balanceOf(address _owner) public view returns (uint256) {
113         return balances[_owner];
114     }
115 
116     /**
117      * Transfer an amount of Chi to an address.
118      * 
119      * Parameters
120      * ----------
121      * address : _to
122      *     The beneficiary address to transfer the Chi tokens to.
123      * uint256 : _value
124      *     The number of Chi tokens to transfer.
125      * 
126      * Returns
127      * -------
128      * bool
129      *     True if the transfer succeeds.
130      */
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         require(balances[msg.sender] >= _value);
133 
134         balances[msg.sender] -= _value;
135         balances[_to] += _value;
136 
137         Transfer(msg.sender, _to, _value);
138 
139         return true;
140     }
141 
142     /**
143      * Transfer Chi tokens from one address to another.
144      * 
145      * This requires an allowance to be set for the requester.
146      * 
147      * Parameters
148      * ----------
149      * address : _from
150      *     The benefactor address from which the Chi tokens are to be sent.
151      * address : _to
152      *     The beneficiary address to transfer the Chi tokens to.
153      * uint256 : _value
154      *      The number of Chi tokens to transfer.
155      * 
156      * Returns
157      * -------
158      * bool
159      *     True if the transfer succeeds.
160      */
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162         require(balances[_from] >= _value);
163         require(allowances[_from][msg.sender] >= _value);
164 
165         balances[_to] += _value;
166         balances[_from] -= _value;
167 
168         allowances[_from][msg.sender] -= _value;
169 
170         Transfer(_from, _to, _value);
171 
172         return true;
173     }
174 
175     /**
176      * Approve given address to spend a number of Chi tokens.
177      * 
178      * This gives an approval to `_spender` to spend `_value` tokens on behalf
179      * of `msg.sender`.
180      * 
181      * Parameters
182      * ----------
183      * address : _spender
184      *     The address that is to be allowed to spend the given number of Chi
185      *     tokens.
186      * uint256 : _value
187      *     The number of Chi tokens that `_spender` is allowed to spend.
188      * 
189      * Returns
190      * -------
191      * bool
192      *     True if the approval succeeds.
193      */
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowances[msg.sender][_spender] = _value;
196 
197         Approval(msg.sender, _spender, _value);
198 
199         return true;
200     }
201     
202     /**
203      * Get the number of tokens `_spender` is allowed to spend by `_owner`.
204      * 
205      * Parameters
206      * ----------
207      * address : _owner
208      *     The address that gave out the allowance.
209      * address : _spender
210      *     The address that is given the allowance to spend.
211      * 
212      * Returns
213      * -------
214      * uint256
215      *     The number of tokens `_spender` is allowed to spend by `_owner`.
216      */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowances[_owner][_spender];
219     }
220 }