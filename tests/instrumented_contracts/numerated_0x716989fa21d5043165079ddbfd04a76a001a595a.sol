1 pragma solidity ^0.4.18;
2 
3 // -----------------------------------------------------------------------
4 // COC Token by CMCM.
5 // As ERC20 standard
6 // Release tokens as a temporary measure 
7 // Creator: Asa17
8 contract ERC20 {
9     // the total token supply
10     uint256 public totalSupply;
11  
12     // Get the account balance of another account with address _owner
13     function balanceOf(address _owner) public constant returns (uint256 balance);
14  
15     // Send _value amount of tokens to address _to
16     function transfer(address _to, uint256 _value) public returns (bool success);
17     
18     // transfer _value amount of token approved by address _from
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21     // approve an address with _value amount of tokens
22     function approve(address _spender, uint256 _value) public returns (bool success);
23 
24     // get remaining token approved by _owner to _spender
25     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
26   
27     // Triggered when tokens are transferred.
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29  
30     // Triggered whenever approve(address _spender, uint256 _value) is called.
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     // Trigger when the owner resign and transfer his balance to successor.
34     event TransferOfPower(address indexed _from, address indexed _to);
35 }
36 
37 interface TokenRecipient {
38     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
39 }
40 
41 contract COCTokenBase is ERC20 {
42     // Public variables of the token
43     string public name;
44     string public symbol;
45     uint8  public decimals = 18;
46     address public administrator;
47     // 18 decimals is the strongly suggested default, avoid changing it
48 
49     // Balances
50     mapping (address => uint256) balances;
51     // Allowances
52     mapping (address => mapping (address => uint256)) allowances;
53 
54 
55     // ----- Events -----
56     event Burn(address indexed from, uint256 value);
57 
58 
59     /**
60      * Constructor function
61      */
62     function COCTokenBase(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
63         name = _tokenName;                                   // Set the name for display purposes
64         symbol = _tokenSymbol;                               // Set the symbol for display purposes
65         decimals = _decimals;
66         administrator = msg.sender;
67 
68         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
69         balances[administrator] = totalSupply;                // Give the creator all initial tokens
70     }
71 
72     function balanceOf(address _owner) public view returns(uint256) {
73         return balances[_owner];
74     }
75 
76     function allowance(address _owner, address _spender) public view returns (uint256) {
77         return allowances[_owner][_spender];
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balances[_from] >= _value);
88         // Check for overflows
89         require(balances[_to] + _value > balances[_to]);
90         // Save this for an assertion in the future
91         uint previousBalances = balances[_from] + balances[_to];
92         // Subtract from the sender
93         balances[_from] -= _value;
94         // Add the same to the recipient
95         balances[_to] += _value;
96         Transfer(_from, _to, _value);
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balances[_from] + balances[_to] == previousBalances);
99 
100         return true;
101     }
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public returns(bool) {
112         return _transfer(msg.sender, _to, _value);
113     }
114 
115     /**
116      * Transfer tokens from other address
117      *
118      * Send `_value` tokens to `_to` in behalf of `_from`
119      *
120      * @param _from The address of the sender
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
125         require(_value <= allowances[_from][msg.sender]);     // Check allowance
126         allowances[_from][msg.sender] -= _value;
127         return _transfer(_from, _to, _value);
128     }
129 
130     /**
131      * Set allowance for other address
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      */
138     function approve(address _spender, uint256 _value) public returns(bool) {
139         allowances[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
154         if (approve(_spender, _value)) {
155             TokenRecipient spender = TokenRecipient(_spender);
156             spender.receiveApproval(msg.sender, _value, this, _extraData);
157             return true;
158         }
159         return false;
160     }
161 
162     /**
163      * Destroy tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns(bool) {
170         require(balances[msg.sender] >= _value);   // Check if the sender has enough
171         balances[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         Burn(msg.sender, _value);
174         return true;
175     }
176 
177     /**
178      * Destroy tokens from other account
179      *
180      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
181      *
182      * @param _from the address of the sender
183      * @param _value the amount of money to burn
184      */
185     function burnFrom(address _from, uint256 _value) public returns(bool) {
186         require(balances[_from] >= _value);                // Check if the targeted balance is enough
187         require(_value <= allowances[_from][msg.sender]);    // Check allowance
188         balances[_from] -= _value;                         // Subtract from the targeted balance
189         allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
190         totalSupply -= _value;                              // Update totalSupply
191         Burn(_from, _value);
192         return true;
193     }
194 
195     /**
196      * Transfer administrator's power to others
197      * 
198      * @param _to the address of the successor
199      */
200     function transferOfPower(address _to) public returns (bool) {
201         require(msg.sender == administrator);
202         uint value = balances[msg.sender];
203         _transfer(msg.sender, _to, value);
204         administrator = _to; 
205         TransferOfPower(msg.sender, _to);
206         return true;
207     }
208 
209     /**
210      * approve should be called when allowances[_spender] == 0. To increment
211      * allowances value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      */
215     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216         // Check for overflows
217         require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);
218 
219         allowances[msg.sender][_spender] += _addedValue;
220         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
221         return true;
222     }
223 
224     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
225         uint oldValue = allowances[msg.sender][_spender];
226         if (_subtractedValue > oldValue) {
227             allowances[msg.sender][_spender] = 0;
228         } else {
229             allowances[msg.sender][_spender] = oldValue - _subtractedValue;
230         }
231         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
232         return true;
233     }
234 
235 }
236 
237 
238 contract COCToken is COCTokenBase {
239 
240     function COCToken() COCTokenBase(100000000000, "COC Token", "COC", 18) public {
241 
242     }
243 }