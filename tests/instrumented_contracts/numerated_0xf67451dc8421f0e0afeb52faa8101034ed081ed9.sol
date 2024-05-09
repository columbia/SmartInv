1 pragma solidity ^0.4.15;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20 {
6   // Get the total token supply
7   /// @return Total amount of tokens
8   function totalSupply() constant returns (uint256);
9 
10   // Get the account balance of another account with address _owner
11   /// @param _owner The address from which the balance will be retrieved
12   /// @return The balance
13   function balanceOf(address _owner) constant returns (uint256);
14 
15   // Send _value amount of tokens to address _to
16   /// @notice send `_value` token to `_to` from `msg.sender`
17   /// @param _to The address of the recipient
18   /// @param _value The amount of token to be transferred
19   /// @return Whether the transfer was successful or not
20   function transfer(address _to, uint256 _value) returns (bool);
21 
22   // Send _value amount of tokens from address _from to address
23   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24   /// @param _from The address of the sender
25   /// @param _to The address of the recipient
26   /// @param _value The amount of token to be transferred
27   /// @return Whether the transfer was successful or not
28   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
29 
30   // Allow _spender to withdraw from your account, multiple times, up to the
31   // _value amount. If this function is called again it overwrites the current
32   // allowance with _value.
33   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34   /// @param _spender The address of the account able to transfer the tokens
35   /// @param _value The amount of tokens to be approved for transfer
36   /// @return Whether the approval was successful or not
37   function approve(address _spender, uint256 _value) returns (bool);
38 
39   // Returns the amount which _spender is still allowed to withdraw from _owner
40   /// @param _owner The address of the account owning tokens
41   /// @param _spender The address of the account able to transfer the tokens
42   /// @return Amount of remaining tokens allowed to spent
43   function allowance(address _owner, address _spender) constant returns (uint256);
44 
45   // Triggered when tokens are transferred.
46   event Transfer(address indexed _from, address indexed _to, uint256 _value);
47 
48   // Triggered whenever approve(address _spender, uint256 _value) is called.
49   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 /**
53  * Owned
54  *
55  * Base contract with an owner.
56  * Provides onlyOwner modifier, which prevents the function from running if
57  * it is called by anyone other than the owner.
58  **/
59 contract Owned {
60   address public owner;
61 
62   function Owned() {
63     owner = msg.sender;
64   }
65 
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71   function changeOwnership(address newOwner) onlyOwner {
72     if (newOwner != address(0)) {
73       owner = newOwner;
74     }
75   }
76 
77 }
78 
79 contract Token is ERC20 {
80   function () {
81     // if ether is sent to this address, send it back.
82     require(false);
83   }
84 
85   // Balances for each account
86   mapping(address => uint256) balances;
87 
88   // Owner of account approves the transfer of an amount to another account
89   mapping(address => mapping (address => uint256)) allowed;
90 
91   // The total token supply
92   uint256 internal _totalSupply;
93 
94   // Get the total token supply
95   /// @return Total amount of tokens
96   function totalSupply() constant returns (uint256) {
97     return _totalSupply;
98   }
99 
100   // Get the account balance of another account with address _owner
101   /// @param _owner The address from which the balance will be retrieved
102   /// @return The balance
103   function balanceOf(address _owner) constant returns (uint256) {
104     return balances[_owner];
105   }
106 
107   // Send _value amount of tokens to address _to
108   /// @notice send `_value` token to `_to` from `msg.sender`
109   /// @param _to The address of the recipient
110   /// @param _value The amount of token to be transferred
111   /// @return Whether the transfer was successful or not
112   function transfer(address _to, uint256 _value) returns (bool) {
113     require(balances[msg.sender] >= _value);
114     require(_value > 0);
115     require(balances[_to] + _value > balances[_to]);
116 
117     balances[msg.sender] -= _value;
118     balances[_to]        += _value;
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   // Send _value amount of tokens from address _from to address
124   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
125   /// @param _from The address of the sender
126   /// @param _to The address of the recipient
127   /// @param _value The amount of token to be transferred
128   /// @return Whether the transfer was successful or not
129   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
130     require(balances[_from] >= _value);
131     require(_value > 0);
132     require(allowed[_from][msg.sender] >= _value);
133     require(balances[_to] + _value > balances[_to]);
134 
135     balances[_from] -= _value;
136     balances[_to]   += _value;
137     allowed[_from][msg.sender] -= _value;
138     Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   // Allow _spender to withdraw from your account, multiple times, up to the
143   // _value amount. If this function is called again it overwrites the current
144   // allowance with _value.
145   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
146   /// @param _spender The address of the account able to transfer the tokens
147   /// @param _value The amount of tokens to be approved for transfer
148   /// @return Whether the approval was successful or not
149   function approve(address _spender, uint256 _value) returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   // Returns the amount which _spender is still allowed to withdraw from _owner
156   /// @param _owner The address of the account owning tokens
157   /// @param _spender The address of the account able to transfer the tokens
158   /// @return Amount of remaining tokens allowed to spent
159   function allowance(address _owner, address _spender) constant returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 }
163 
164 contract Gambit is Token, Owned {
165   string public constant name     = 'Gambit';
166   uint8  public constant decimals = 8;
167   string public constant symbol   = 'GAM';
168   string public constant version  = '1.0.0';
169   uint256 internal _totalBurnt    = 0;
170 
171   // Constructor
172   function Gambit() {
173     _totalSupply = 260000000000000;
174     balances[owner] = _totalSupply;
175   }
176 
177   // Get the total of token burnt
178   /// @return Total amount of burned tokens
179   function totalBurnt() constant returns (uint256) {
180     return _totalBurnt;
181   }
182 
183   // Only the Owner of the contract can burn tokens.
184   /// @param _value The amount of token to be burned
185   /// @return Whether the burning was successful or not
186   function burn(uint256 _value) onlyOwner returns (bool) {
187     require(balances[msg.sender] >= _value);
188     require(_value > 0);
189 
190     balances[msg.sender] -= _value;
191     _totalSupply         -= _value;
192     _totalBurnt          += _value;
193     Transfer(msg.sender, 0x0, _value);
194     return true;
195   }
196 }