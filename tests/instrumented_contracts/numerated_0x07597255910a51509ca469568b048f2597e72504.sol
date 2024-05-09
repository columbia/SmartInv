1 pragma solidity ^0.4.21;
2 
3 //Decalre all functions to use in Token Smart Contract
4 contract EIP20Interface {
5     
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     // solhint-disable-next-line no-simple-event-func-name
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 //Main Token Code Starts from here
44 contract Uptrennd is EIP20Interface {
45     
46     
47     //Code To Set onlyOwner
48     address public owner;
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50         modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54     
55     //Code to Transfer the Ownership
56     function transferOwnership(address newOwner) public onlyOwner {
57         require(newOwner != address(0));
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         uint _value = balances[msg.sender];
61         balances[msg.sender] -= _value;
62         balances[newOwner] += _value;
63         emit Transfer(msg.sender, newOwner, _value);
64     }
65 
66     uint256 constant private MAX_UINT256 = 2**256 - 1;
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public TokenPrice;
70 
71     string public name;                   
72     uint256 public decimals;                
73     string public symbol;                 
74 
75     //function to depoly the smart contract with functionality
76     function Uptrennd(
77         uint256 _initialAmount,
78         string _tokenName,
79         uint256 _decimalUnits,
80         string _tokenSymbol,
81         uint256 _price
82     ) public {
83         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
84         totalSupply = _initialAmount;                        // Update total supply
85         name = _tokenName;                                   // Set the name for display purposes
86         decimals = _decimalUnits;                            // Amount of decimals for display purposes
87         symbol = _tokenSymbol;                               // Set the symbol for display purposes
88         owner = msg.sender;
89         TokenPrice = _price;
90     }
91     
92     //Funtion to Set The Token Price
93     function setPrice(uint256 _price) onlyOwner public returns(bool success){
94         TokenPrice =  _price;
95         return true;
96     }
97 
98     //Transfer Function for the Tokens!
99     function transfer(address _to, uint256 _value) public returns (bool success) {
100         require(balances[msg.sender] >= _value);
101         balances[msg.sender] -= _value;
102         balances[_to] += _value;
103         emit Transfer(msg.sender, _to, _value); 
104         return true;
105     }
106     
107     //User can purchase token using this method
108     function purchase(address _to, uint256 _value) public payable returns (bool success) {
109         uint amount = (msg.value * 1000000000000000000 ) / TokenPrice;
110         require(balances[owner] >= amount);
111         balances[owner] -= amount;
112         balances[_to] += amount;
113         emit Transfer(owner, _to, amount); 
114         return true;
115     }
116 
117     //Admin can give rights to the user to transfer token on his behafe.
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119         uint256 allowance = allowed[_from][msg.sender];
120         require(balances[_from] >= _value && allowance >= _value);
121         balances[_to] += _value;
122         balances[_from] -= _value;
123         if (allowance < MAX_UINT256) {
124             allowed[_from][msg.sender] -= _value;
125         }
126         emit Transfer(_from, _to, _value); 
127         return true;
128     }
129 
130     //To check the token balcance in his account.
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     //TO approve the user to Transfer the token on admin behafe.
136     function approve(address _spender, uint256 _value) public returns (bool success) {
137         require(balances[msg.sender] >= _value);
138         allowed[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value); 
140         return true;
141     }
142 
143     //To allow the user to get the permission to tranfer the token.
144     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147     
148     //Code To Burn the token starts from here.
149     function _burn(address account, uint256 value) internal {
150         require(account != address(0));
151         totalSupply = totalSupply - value;
152         balances[account] = balances[account] - value;
153         emit Transfer(account, address(0), value);
154     }
155    
156     //Admin functionality to burn number of tokens.
157     function burn(uint256 value) onlyOwner public {
158         _burn(msg.sender, value);
159     }
160 
161     //User functionality to burn the token from his account.
162     function burnFrom(address to, uint256 value) public returns (bool success) {
163         require(balances[msg.sender] >= value);
164         balances[msg.sender] -= value;
165         emit Transfer(msg.sender, address(0), value); //solhint-disable-line indent, no-unused-vars
166         return true;
167     }
168 }