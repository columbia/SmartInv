1 pragma solidity 0.5.9;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
5 
6 contract Token {
7 
8     /// @return total amount of tokens
9     function totalSupply() public view returns (uint256 supply) {}
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) public view returns (uint256 balance) {}
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) public returns (bool success) {}
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
27 
28     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of wei to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) public returns (bool success) {}
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 /*
45 This implements ONLY the standard functions and NOTHING else.
46 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
47 
48 If you deploy this, you won't have anything useful.
49 
50 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
51 .*/
52 
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         require(_to != address(0));
61         require(balances[msg.sender] >= _value && _value > 0);
62             balances[msg.sender] -= _value;
63             balances[_to] += _value;
64             emit Transfer(msg.sender, _to, _value);
65             return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         require(_to != address(0));
72         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             allowed[_from][msg.sender] -= _value;
76             emit Transfer(_from, _to, _value);
77             return true;
78     }
79 
80     function balanceOf(address _owner) public view returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         emit Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93     
94     
95     function totalSupply() public view returns (uint256 supply) {
96         return _totalSupply;
97     }
98     mapping (address => uint256) internal balances;
99     mapping (address => mapping (address => uint256)) internal allowed;
100     uint256 internal _totalSupply;
101 }
102 
103 /*
104 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
105 
106 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
107 Imagine coins, currencies, shares, voting weight, etc.
108 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
109 
110 1) Initial Finite Supply (upon creation one specifies how much is minted).
111 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
112 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
113 
114 .*/
115 
116 contract HumanStandardToken is StandardToken {
117 
118     function () external {
119         //if ether is sent to this address, send it back.
120         revert();
121     }
122 
123     /* Public variables of the token */
124 
125     /*
126     NOTE:
127     The following variables are OPTIONAL vanities. One does not have to include them.
128     They allow one to customise the token contract & in no way influences the core functionality.
129     Some wallets/interfaces might not even bother to look at this information.
130     */
131     string public name;                   //fancy name: eg Simon Bucks
132     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
133     string public symbol;                 //An identifier: eg SBX
134     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
135     address public owner;
136 
137     event Burn(address indexed _owner, uint256 _value);
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     constructor(
141         uint256 _initialAmount,
142         string memory _tokenName,
143         uint8 _decimalUnits,
144         string memory _tokenSymbol
145         ) public {
146         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
147         _totalSupply = _initialAmount;                        // Update total supply
148         name = _tokenName;                                   // Set the name for display purposes
149         decimals = _decimalUnits;                            // Amount of decimals for display purposes
150         symbol = _tokenSymbol;                               // Set the symbol for display purposes
151         owner = msg.sender;
152         emit Transfer(address(0), msg.sender, _totalSupply);
153         emit OwnershipTransferred(address(0), owner);
154     }
155 
156     /* Approves and then calls the receiving contract */
157     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
158         tokenRecipient spender = tokenRecipient(_spender);
159         if (approve(_spender, _value)) {
160             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
161             return true;
162         }
163     }
164 
165     /**
166      * @dev Burns a specific amount of tokens.
167      * @param _value The amount of token to be burned.
168     */
169     function burn(uint256 _value) public {
170         require(msg.sender == owner);
171         require(_value <= balances[msg.sender]);
172         require(_value <= _totalSupply);
173         // no need to require value <= totalSupply, since that would imply the
174         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
175         balances[msg.sender] -= _value;
176         _totalSupply -= _value;
177         emit Transfer(msg.sender, address(0), _value);
178         emit Burn(msg.sender, _value);
179     }
180 
181     /**
182      * @dev Transfers control of the contract to a newOwner.
183      * @param newOwner The address to transfer ownership to.
184      */
185     function transferOwnership(address newOwner) public {
186         require(msg.sender == owner);
187         require(newOwner != address(0), "Cannot transfer control of the contract to zero address");
188         emit OwnershipTransferred(owner, newOwner);
189         owner = newOwner;
190     }
191 }