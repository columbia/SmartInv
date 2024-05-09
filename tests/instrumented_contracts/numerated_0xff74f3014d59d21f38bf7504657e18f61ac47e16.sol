1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Token {
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) public view returns (uint balance);
30 
31     /// @notice send `_value` token to `_to` from `msg.sender`
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transfer(address _to, uint _value) public returns (bool success);
36 
37     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
38     /// @param _from The address of the sender
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
43 
44     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @param _value The amount of wei to be approved for transfer
47     /// @return Whether the approval was successful or not
48     function approve(address _spender, uint _value) public returns (bool success);
49 
50     /// @param _owner The address of the account owning tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @return Amount of remaining tokens allowed to spent
53     function allowance(address _owner, address _spender) public view returns (uint remaining);
54 
55     event Transfer(address indexed _from, address indexed _to, uint _value);
56     event Approval(address indexed _owner, address indexed _spender, uint _value);
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Contract function to receive approval and execute function in one call
62 //
63 // Borrowed from MiniMeToken
64 // ----------------------------------------------------------------------------
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 }
68 
69 //------------------------------------------------------------------------
70 // This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
71 //
72 // In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
73 // Imagine coins, currencies, shares, voting weight, etc.
74 // Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
75 //
76 // 1) Initial Finite Supply (upon creation one specifies how much is minted).
77 // 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
78 // 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
79 // ------------------------------------------------------------------------
80 contract DIDSToken is ERC20Token {
81     using SafeMath for uint;
82 
83     mapping (address => uint) balances;
84     mapping (address => mapping (address => uint)) allowed;
85 
86     /// ------------------------------------------------------------------------
87     ///  Public variables of the token
88     ///
89     /// NOTE:
90     /// The following variables are OPTIONAL vanities. One does not have to include them.
91     /// They allow one to customise the token contract & in no way influences the core functionality.
92     /// Some wallets/interfaces might not even bother to look at this information.
93     /// ------------------------------------------------------------------------
94     string public name;                   //fancy name: eg Simon Bucks
95     uint8  public decimals;               //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
96     string public symbol;                 //An identifier: eg SBX
97     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
98     uint   public totalSupply;
99 
100     // ------------------------------------------------------------------------
101     // Don't accept ETH
102     // ------------------------------------------------------------------------
103     function() external payable {
104         revert();
105     }
106     
107     constructor() public {
108         symbol   = "DIDS";                              // Set the symbol for display purposes
109         name     = "Doitdo Axis";                       // Set the name for display purposes
110         decimals = 18;                                  // Amount of decimals for display purposes
111 
112         totalSupply = 3 * 10**27;                      // Update total supply
113         balances[msg.sender] = totalSupply;            // Give the creator all initial tokens
114     }
115 
116 
117     function transfer(address _to, uint _value) public returns (bool) {
118         /// Default assumes totalSupply can't be over max (2^256 - 1).
119         /// If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
120         /// Replace the if with this one instead.
121         /// if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
122         if (_value > 0 && balances[msg.sender] >= _value) {
123             balances[msg.sender] = balances[msg.sender].sub(_value);
124             balances[_to] = balances[_to].add(_value);
125             emit Transfer(msg.sender, _to, _value);
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
133         /// same as above. Replace this line with the following if you want to protect against wrapping uints.
134         /// if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
135         if (_value > 0 && balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
136             balances[_to] = balances[_to].add(_value);
137             balances[_from] = balances[_to].sub(_value);
138             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139             emit Transfer(_from, _to, _value);
140             return true;
141         } else {
142             return false;
143         }
144     }
145 
146     function balanceOf(address _owner) public view returns (uint balance) {
147         return balances[_owner];
148     }
149 
150     function approve(address _spender, uint _value) public returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     function allowance(address _owner, address _spender) public view returns (uint remaining) {
157         return allowed[_owner][_spender];
158     }
159     
160     //// Approves and then calls the receiving contract
161     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163         emit Approval(msg.sender, _spender, _value);
164 
165         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _extraData);
166         return true;
167     }
168 }