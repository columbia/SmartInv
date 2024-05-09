1 pragma solidity ^0.4.8;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   /**
8    * @dev Throws if called by any account other than the owner.
9    */
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   /**
16    * @dev Allows the current owner to transfer control of the contract to a newOwner.
17    * @param newOwner The address to transfer ownership to.
18    */
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 }
25 
26 
27 contract Token {
28     /* This is a slight change to the ERC20 base standard.
29     function totalSupply() constant returns (uint256 supply);
30     is replaced with:
31     uint256 public totalSupply;
32     This automatically creates a getter function for the totalSupply.
33     This is moved to the base contract since public getter functions are not
34     currently recognised as an implementation of the matching abstract
35     function by the compiler.
36     */
37     /// total amount of tokens
38     uint256 public totalSupply;
39 
40     /// @param _owner The address from which the balance will be retrieved
41     /// @return The balance
42     function balanceOf(address _owner) constant returns (uint256 balance);
43 
44     /// @notice send `_value` token to `_to` from `msg.sender`
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transfer(address _to, uint256 _value) returns (bool success);
49 
50     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
51     /// @param _from The address of the sender
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
56 
57     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @param _value The amount of tokens to be approved for transfer
60     /// @return Whether the approval was successful or not
61     function approve(address _spender, uint256 _value) returns (bool success);
62 
63     /// @param _owner The address of the account owning tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @return Amount of remaining tokens allowed to spent
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 /*
73 You should inherit from StandardToken or, for a token like you would want to
74 deploy in something like Mist, see HumanStandardToken.sol.
75 (This implements ONLY the standard functions and NOTHING else.
76 If you deploy this, you won't have anything useful.)
77 
78 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
79 .*/
80 
81 contract StandardToken is Token {
82 
83     function transfer(address _to, uint256 _value) returns (bool success) {
84         //Default assumes totalSupply can't be over max (2^256 - 1).
85         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
86         //Replace the if with this one instead.
87         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
88         if (balances[msg.sender] >= _value && _value > 0) {
89             balances[msg.sender] -= _value;
90             balances[_to] += _value;
91             Transfer(msg.sender, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         //same as above. Replace this line with the following if you want to protect against wrapping uints.
98         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
99         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             allowed[_from][msg.sender] -= _value;
103             Transfer(_from, _to, _value);
104             return true;
105         } else { return false; }
106     }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 }
125 
126 contract HumanStandardToken is StandardToken, Ownable {
127 
128     function () {
129         //if ether is sent to this address, send it back.
130         throw;
131     }
132 
133     /* Public variables of the token */
134 
135     /*
136     NOTE:
137     The following variables are OPTIONAL vanities. One does not have to include them.
138     They allow one to customise the token contract & in no way influences the core functionality.
139     Some wallets/interfaces might not even bother to look at this information.
140     */
141     string public name;                   //fancy name: eg Simon Bucks
142     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
143     string public symbol;                 //An identifier: eg SBX
144     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
145 
146     function HumanStandardToken(
147         uint256 _initialAmount,
148         string _tokenName,
149         uint8 _decimalUnits,
150         string _tokenSymbol
151         ) {
152         balances[0xd76618b352D0bFC8014Fc44BF31Bd0F947331660] = _initialAmount;               // Give the creator all initial tokens
153         totalSupply = _initialAmount;                        // Update total supply
154         name = _tokenName;                                   // Set the name for display purposes
155         decimals = _decimalUnits;                            // Amount of decimals for display purposes
156         symbol = _tokenSymbol;                               // Set the symbol for display purposes
157         owner = 0xd76618b352D0bFC8014Fc44BF31Bd0F947331660;  // Set owner
158     }
159 
160     /* Approves and then calls the receiving contract */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164 
165         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
166         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
167         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
168         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
169         return true;
170     }
171 
172     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
173         balances[target] = balances[target] + mintedAmount;
174         totalSupply = totalSupply + mintedAmount;
175         Transfer(0, this, mintedAmount);
176         Transfer(this, target, mintedAmount);
177     }    
178 }