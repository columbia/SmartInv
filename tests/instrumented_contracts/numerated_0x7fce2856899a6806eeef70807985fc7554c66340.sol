1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  *
6  */
7 contract SafeMath {
8     //internals
9 
10     function safeMul(uint a, uint b) internal returns (uint) {
11         uint c = a * b;
12         require(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function safeSub(uint a, uint b) internal returns (uint) {
17         require(b <= a);
18         return a - b;
19     }
20 
21     function safeAdd(uint a, uint b) internal returns (uint) {
22         uint c = a + b;
23         require(c>=a && c>=b);
24         return c;
25     }
26 
27     function safeDiv(uint a, uint b) internal returns (uint) {
28         require(b > 0);
29         uint c = a / b;
30         require(a == b * c + a % b);
31         return c;
32     }
33 }
34 
35 
36 /**
37  * ERC 20 token
38  *
39  * https://github.com/ethereum/EIPs/issues/20
40  */
41 interface Token {
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 
47     /// @notice send `_value` token to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _value) returns (bool success);
52 
53     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
59 
60     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of wei to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) returns (bool success);
65 
66     /// @param _owner The address of the account owning tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @return Amount of remaining tokens allowed to spent
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74 }
75 
76 /**
77  * ERC 20 token
78  *
79  * https://github.com/ethereum/EIPs/issues/20
80  */
81 contract StandardToken is Token {
82 
83     /**
84      * Reviewed:
85      * - Integer overflow = OK, checked
86      */
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         //Default assumes totalSupply can't be over max (2^256 - 1).
89         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90         //Replace the if with this one instead.
91         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92             //if (balances[msg.sender] >= _value && _value > 0) {
93             balances[msg.sender] -= _value;
94             balances[_to] += _value;
95             Transfer(msg.sender, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         //same as above. Replace this line with the following if you want to protect against wrapping uints.
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103             //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104             balances[_to] += _value;
105             balances[_from] -= _value;
106             allowed[_from][msg.sender] -= _value;
107             Transfer(_from, _to, _value);
108             return true;
109         } else { return false; }
110     }
111 
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     mapping(address => uint256) balances;
127 
128     mapping (address => mapping (address => uint256)) allowed;
129 
130     uint256 public totalSupply;
131 }
132 
133 
134 /**
135  * CLP crowdsale ICO contract.
136  *
137  */
138 contract CLPToken is StandardToken, SafeMath {
139 
140     string public name = "CLP Token";
141     string public symbol = "CLP";
142 	uint public decimals = 9;
143 
144     // Initial founder address (set in constructor)
145     // This address handle administration of the token.
146     address public founder = 0x0;
147 	
148     // Block timing/contract unlocking information
149 	uint public month6companyUnlock = 1525132801; // May 01, 2018 UTC
150 	uint public month12companyUnlock = 1541030401; // Nov 01, 2018 UTC
151 	uint public month18companyUnlock = 1556668801; // May 01, 2019 UTC
152 	uint public month24companyUnlock = 1572566401; // Nov 01, 2019 UTC
153     uint public year1Unlock = 1541030401; // Nov 01, 2018 UTC
154     uint public year2Unlock = 1572566401; // Nov 01, 2019 UTC
155     uint public year3Unlock = 1604188801; // Nov 01, 2020 UTC
156     uint public year4Unlock = 1635724801; // Nov 01, 2021 UTC
157 
158     // Have the post-reward allocations been completed
159     bool public allocated1Year = false;
160     bool public allocated2Year = false;
161     bool public allocated3Year = false;
162     bool public allocated4Year = false;
163 	
164 	bool public allocated6Months = false;
165     bool public allocated12Months = false;
166     bool public allocated18Months = false;
167     bool public allocated24Months = false;
168 
169     // Token count information
170 	uint currentTokenSaled = 0;
171     uint public totalTokensSale = 87000000 * 10**decimals;
172     uint public totalTokensReserve = 39000000 * 10**decimals; 
173     uint public totalTokensCompany = 24000000 * 10**decimals;
174 
175     event Buy(address indexed sender, uint eth, uint fbt);
176     event Withdraw(address indexed sender, address to, uint eth);
177     event AllocateTokens(address indexed sender);
178 
179     function CLPToken() {
180         /*
181             Initialize the contract with a sane set of owners
182         */
183         founder = msg.sender;
184     }
185 
186 	/*
187         Allocate reserved tokens based on the running time and state of the contract.
188      */
189     function allocateReserveCompanyTokens() {
190         require(msg.sender==founder);
191         uint tokens = 0;
192 
193         if(block.timestamp > month6companyUnlock && !allocated6Months)
194         {
195             allocated6Months = true;
196             tokens = safeDiv(totalTokensCompany, 4);
197             balances[founder] = safeAdd(balances[founder], tokens);
198             totalSupply = safeAdd(totalSupply, tokens);
199         }
200         else if(block.timestamp > month12companyUnlock && !allocated12Months)
201         {
202             allocated12Months = true;
203             tokens = safeDiv(totalTokensCompany, 4);
204             balances[founder] = safeAdd(balances[founder], tokens);
205             totalSupply = safeAdd(totalSupply, tokens);
206         }
207         else if(block.timestamp > month18companyUnlock && !allocated18Months)
208         {
209             allocated18Months = true;
210             tokens = safeDiv(totalTokensCompany, 4);
211             balances[founder] = safeAdd(balances[founder], tokens);
212             totalSupply = safeAdd(totalSupply, tokens);
213         }
214         else if(block.timestamp > month24companyUnlock && !allocated24Months)
215         {
216             allocated24Months = true;
217             tokens = safeDiv(totalTokensCompany, 4);
218             balances[founder] = safeAdd(balances[founder], tokens);
219             totalSupply = safeAdd(totalSupply, tokens);
220         }
221         else revert();
222 
223         AllocateTokens(msg.sender);
224     }
225 
226     /*
227         Allocate reserved tokens based on the running time and state of the contract.
228      */
229     function allocateReserveTokens() {
230         require(msg.sender==founder);
231         uint tokens = 0;
232 
233         if(block.timestamp > year1Unlock && !allocated1Year)
234         {
235             allocated1Year = true;
236             tokens = safeDiv(totalTokensReserve, 4);
237             balances[founder] = safeAdd(balances[founder], tokens);
238             totalSupply = safeAdd(totalSupply, tokens);
239         }
240         else if(block.timestamp > year2Unlock && !allocated2Year)
241         {
242             allocated2Year = true;
243             tokens = safeDiv(totalTokensReserve, 4);
244             balances[founder] = safeAdd(balances[founder], tokens);
245             totalSupply = safeAdd(totalSupply, tokens);
246         }
247         else if(block.timestamp > year3Unlock && !allocated3Year)
248         {
249             allocated3Year = true;
250             tokens = safeDiv(totalTokensReserve, 4);
251             balances[founder] = safeAdd(balances[founder], tokens);
252             totalSupply = safeAdd(totalSupply, tokens);
253         }
254         else if(block.timestamp > year4Unlock && !allocated4Year)
255         {
256             allocated4Year = true;
257             tokens = safeDiv(totalTokensReserve, 4);
258             balances[founder] = safeAdd(balances[founder], tokens);
259             totalSupply = safeAdd(totalSupply, tokens);
260         }
261         else revert();
262 
263         AllocateTokens(msg.sender);
264     }
265 
266 
267    /**
268     *   Change founder address (Controlling address for contract)
269     */
270     function changeFounder(address newFounder) {
271         require(msg.sender==founder);
272         founder = newFounder;
273     }
274 
275 	/**
276     *   Get current total token sale
277     */
278     function getTotalCurrentSaled() constant returns (uint256 currentTokenSaled)  {
279 		require(msg.sender==founder);
280 		
281 		return currentTokenSaled;
282     }
283 
284    /**
285     *   Send token to investor
286     */
287     function addInvestorList(address investor, uint256 amountToken)  returns (bool success) {
288 		require(msg.sender==founder);
289 		
290 		if(currentTokenSaled + amountToken <= totalTokensSale)
291 		{
292 			balances[investor] = safeAdd(balances[investor], amountToken);
293 			currentTokenSaled = safeAdd(currentTokenSaled, amountToken);
294 			totalSupply = safeAdd(totalSupply, amountToken);
295 			return true;
296 		}
297 		else
298 		{
299 		    return false;
300 		}
301     }
302 }