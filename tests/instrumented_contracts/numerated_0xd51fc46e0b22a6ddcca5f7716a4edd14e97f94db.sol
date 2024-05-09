1 // Dr. Sebastian Buergel, Validity Labs AG
2 pragma solidity ^0.4.11;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to. 
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 
47 contract Token {
48     /* This is a slight change to the ERC20 base standard.
49     function totalSupply() constant returns (uint256 supply);
50     is replaced with:
51     uint256 public totalSupply;
52     This automatically creates a getter function for the totalSupply.
53     This is moved to the base contract since public getter functions are not
54     currently recognised as an implementation of the matching abstract
55     function by the compiler.
56     */
57     /// total amount of tokens
58     uint256 public totalSupply;
59 
60     /// @param _owner The address from which the balance will be retrieved
61     /// @return The balance
62     function balanceOf(address _owner) constant returns (uint256 balance);
63 
64     /// @notice send `_value` token to `_to` from `msg.sender`
65     /// @param _to The address of the recipient
66     /// @param _value The amount of token to be transferred
67     /// @return Whether the transfer was successful or not
68     function transfer(address _to, uint256 _value) returns (bool success);
69 
70     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
71     /// @param _from The address of the sender
72     /// @param _to The address of the recipient
73     /// @param _value The amount of token to be transferred
74     /// @return Whether the transfer was successful or not
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
76 
77     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @param _value The amount of tokens to be approved for transfer
80     /// @return Whether the approval was successful or not
81     function approve(address _spender, uint256 _value) returns (bool success);
82 
83     /// @param _owner The address of the account owning tokens
84     /// @param _spender The address of the account able to transfer the tokens
85     /// @return Amount of remaining tokens allowed to spent
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 
92 
93 
94 contract StandardToken is Token {
95 
96     function transfer(address _to, uint256 _value) returns (bool success) {
97         //Default assumes totalSupply can't be over max (2^256 - 1).
98         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
99         //Replace the if with this one instead.
100         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101         if (balances[msg.sender] >= _value && _value > 0) {
102             balances[msg.sender] -= _value;
103             balances[_to] += _value;
104             Transfer(msg.sender, _to, _value);
105             return true;
106         } else { return false; }
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         //same as above. Replace this line with the following if you want to protect against wrapping uints.
111         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
113             balances[_to] += _value;
114             balances[_from] -= _value;
115             allowed[_from][msg.sender] -= _value;
116             Transfer(_from, _to, _value);
117             return true;
118         } else { return false; }
119     }
120 
121     function balanceOf(address _owner) constant returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125     function approve(address _spender, uint256 _value) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128         return true;
129     }
130 
131     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132       return allowed[_owner][_spender];
133     }
134 
135     mapping (address => uint256) balances;
136     mapping (address => mapping (address => uint256)) allowed;
137 }
138 
139 
140 
141 // wraps non-ERC20-conforming fundraising contracts (aka pure IOU ICO) in a standard ERC20 contract that is immediately tradable and usable via default tools.
142 // this is again a pure IOU token but now having all the benefits of standard tokens.
143 contract ERC20nator is StandardToken, Ownable {
144 
145     address public fundraiserAddress;
146 
147     uint constant issueFeePercent = 10; // fee in percent that is collected for all paid in funds
148 
149     event requestedRedeem(address indexed requestor, uint amount);
150     
151     event redeemed(address redeemer, uint amount);
152 
153     // fallback function invests in fundraiser
154     // fee percentage is given to owner for providing this service
155     // remainder is invested in fundraiser
156     function() payable {
157         uint issuedTokens = msg.value * (100 - issueFeePercent) / 100;
158 
159         // invest 90% into fundraiser
160         if(!fundraiserAddress.send(issuedTokens))
161             throw;
162 
163         // pay 10% to owner
164         if(!owner.send(msg.value - issuedTokens))
165             throw;
166         
167         // issue tokens by increasing total supply and balance
168         totalSupply += issuedTokens;
169         balances[msg.sender] += issuedTokens;
170     }
171 
172     // allow owner to set fundraiser target address
173     function setFundraiserAddress(address _fundraiserAddress) onlyOwner {
174         fundraiserAddress = _fundraiserAddress;
175     }
176 
177     // this is just to inform the owner that a user wants to redeem some of their IOU tokens
178     function requestRedeem(uint amount) {
179         requestedRedeem(msg.sender, amount);
180     }
181 
182     // this is just to inform the investor that the owner redeemed some of their IOU tokens
183     function redeem(uint amount) onlyOwner{
184         redeemed(msg.sender, amount);
185     }
186 }