1 pragma solidity ^0.4.13;
2 
3 contract Token {
4   /* This is a slight change to the ERC20 base standard.
5      function totalSupply() constant returns (uint256 supply);
6      is replaced with:
7      uint256 public totalSupply;
8      This automatically creates a getter function for the totalSupply.
9      This is moved to the base contract since public getter functions are not
10      currently recognised as an implementation of the matching abstract
11      function by the compiler.
12   */
13   /// total amount of tokens
14   uint256 public totalSupply;
15 
16   /// @param _owner The address from which the balance will be retrieved
17   /// @return The balance
18   function balanceOf(address _owner) constant returns (uint256 balance);
19 
20   /// @notice send `_value` token to `_to` from `msg.sender`
21   /// @param _to The address of the recipient
22   /// @param _value The amount of token to be transferred
23   /// @return Whether the transfer was successful or not
24   function transfer(address _to, uint256 _value) returns (bool success);
25 
26   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27   /// @param _from The address of the sender
28   /// @param _to The address of the recipient
29   /// @param _value The amount of token to be transferred
30   /// @return Whether the transfer was successful or not
31   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34   /// @param _spender The address of the account able to transfer the tokens
35   /// @param _value The amount of tokens to be approved for transfer
36   /// @return Whether the approval was successful or not
37   function approve(address _spender, uint256 _value) returns (bool success);
38 
39   /// @param _owner The address of the account owning tokens
40   /// @param _spender The address of the account able to transfer the tokens
41   /// @return Amount of remaining tokens allowed to spent
42   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49 
50   function transfer(address _to, uint256 _value) returns (bool success) {
51     //Default assumes totalSupply can't be over max (2^256 - 1).
52     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53     //Replace the if with this one instead.
54     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55     if (balances[msg.sender] >= _value && _value > 0) {
56       balances[msg.sender] -= _value;
57       balances[_to] += _value;
58       Transfer(msg.sender, _to, _value);
59       return true;
60     } else { return false; }
61   }
62 
63   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64     //same as above. Replace this line with the following if you want to protect against wrapping uints.
65     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67       balances[_to] += _value;
68       balances[_from] -= _value;
69       allowed[_from][msg.sender] -= _value;
70       Transfer(_from, _to, _value);
71       return true;
72     } else { return false; }
73   }
74 
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79   function approve(address _spender, uint256 _value) returns (bool success) {
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84 
85   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89   mapping (address => uint256) balances;
90   mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract EasyMineToken is StandardToken {
94 
95   string public constant name = "easyMINE Token";
96   string public constant symbol = "EMT";
97   uint8 public constant decimals = 18;
98 
99   function EasyMineToken(address _icoAddress,
100                          address _preIcoAddress,
101                          address _easyMineWalletAddress,
102                          address _bountyWalletAddress) {
103     require(_icoAddress != 0x0);
104     require(_preIcoAddress != 0x0);
105     require(_easyMineWalletAddress != 0x0);
106     require(_bountyWalletAddress != 0x0);
107 
108     totalSupply = 33000000 * 10**18;                     // 33.000.000 EMT
109 
110     uint256 icoTokens = 27000000 * 10**18;               // 27.000.000 EMT
111 
112     uint256 preIcoTokens = 2000000 * 10**18;             // 2.000.000 EMT
113 
114     uint256 easyMineTokens = 3000000 * 10**18;           // 1.500.000 EMT dev team +
115                                                          // 500.000 EMT advisors +
116                                                          // 1.000.000 EMT easyMINE corporation +
117                                                          // = 3.000.000 EMT
118 
119     uint256 bountyTokens = 1000000 * 10**18;             // 1.000.000 EMT
120 
121     assert(icoTokens + preIcoTokens + easyMineTokens + bountyTokens == totalSupply);
122 
123     balances[_icoAddress] = icoTokens;
124     Transfer(0, _icoAddress, icoTokens);
125 
126     balances[_preIcoAddress] = preIcoTokens;
127     Transfer(0, _preIcoAddress, preIcoTokens);
128 
129     balances[_easyMineWalletAddress] = easyMineTokens;
130     Transfer(0, _easyMineWalletAddress, easyMineTokens);
131 
132     balances[_bountyWalletAddress] = bountyTokens;
133     Transfer(0, _bountyWalletAddress, bountyTokens);
134   }
135 
136   function burn(uint256 _value) returns (bool success) {
137     if (balances[msg.sender] >= _value && _value > 0) {
138       balances[msg.sender] -= _value;
139       totalSupply -= _value;
140       Transfer(msg.sender, 0x0, _value);
141       return true;
142     } else {
143       return false;
144     }
145   }
146 }
147 
148 contract EasyMineTokenWallet {
149 
150   uint256 constant public VESTING_PERIOD = 180 days;
151   uint256 constant public DAILY_FUNDS_RELEASE = 15000 * 10**18; // 0.5% * 3M tokens = 15k tokens a day
152 
153   address public owner;
154   address public withdrawalAddress;
155   Token public easyMineToken;
156   uint256 public startTime;
157   uint256 public totalWithdrawn;
158 
159   modifier isOwner() {
160     require(msg.sender == owner);
161     _;
162   }
163 
164   function EasyMineTokenWallet() {
165     owner = msg.sender;
166   }
167 
168   function setup(address _easyMineToken, address _withdrawalAddress)
169     public
170     isOwner
171   {
172     require(_easyMineToken != 0x0);
173     require(_withdrawalAddress != 0x0);
174 
175     easyMineToken = Token(_easyMineToken);
176     withdrawalAddress = _withdrawalAddress;
177     startTime = now;
178   }
179 
180   function withdraw(uint256 requestedAmount)
181     public
182     isOwner
183     returns (uint256 amount)
184   {
185     uint256 limit = maxPossibleWithdrawal();
186     uint256 withdrawalAmount = requestedAmount;
187     if (requestedAmount > limit) {
188       withdrawalAmount = limit;
189     }
190 
191     if (withdrawalAmount > 0) {
192       if (!easyMineToken.transfer(withdrawalAddress, withdrawalAmount)) {
193         revert();
194       }
195       totalWithdrawn += withdrawalAmount;
196     }
197 
198     return withdrawalAmount;
199   }
200 
201   function maxPossibleWithdrawal()
202     public
203     constant
204     returns (uint256)
205   {
206     if (now < startTime + VESTING_PERIOD) {
207       return 0;
208     } else {
209       uint256 daysPassed = (now - (startTime + VESTING_PERIOD)) / 86400;
210       uint256 res = DAILY_FUNDS_RELEASE * daysPassed - totalWithdrawn;
211       if (res < 0) {
212         return 0;
213       } else {
214         return res;
215       }
216     }
217   }
218 
219 }