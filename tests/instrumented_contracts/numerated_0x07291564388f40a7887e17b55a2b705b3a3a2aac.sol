1 pragma solidity ^0.5.1;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public view returns (uint supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public view returns (uint balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) public returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) public returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public view returns (uint remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38     event Burn(address indexed from, uint256 value);
39 }
40 
41 contract RegularToken is Token {
42 
43     function transfer(address _to, uint _value) public returns (bool) {
44         if(uint256(_to)==0)
45         {
46             return false;
47         }
48         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             emit Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55     
56     uint constant MAX_UINT = 2**256 - 1;
57     function transferFrom(address _from, address _to, uint _value) public returns (bool)
58     { 
59         if(uint256(_to)==0)
60         {
61             return false;
62         }
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             if (allowed[_from][msg.sender] < MAX_UINT) {
67                 allowed[_from][msg.sender] -= _value;
68             }
69             emit Transfer(_from, _to, _value);
70             return true;
71         } else {
72             return false;
73         }
74     }
75     
76     function balanceOf(address _owner) public view returns (uint) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint _value) public returns (bool) {
81         allowed[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) public view returns (uint) {
87         return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint) balances;
91     mapping (address => mapping (address => uint)) allowed;
92 
93 }
94 
95 contract DMToken is RegularToken {
96     
97     string public name;
98     string public symbol;
99     uint8 public decimals;
100     uint256 public _totalSupply;
101 
102     constructor(
103         uint256 initialSupply,
104         string memory tokenName,
105         uint8 decimalUnits,
106         string memory tokenSymbol
107         ) public {
108         balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
109         _totalSupply = initialSupply;                        // Update total supply
110         name = tokenName;                                   // Set the name for display purposes
111         symbol = tokenSymbol;                               // Set the symbol for display purposes
112         decimals = decimalUnits;                            // Amount of decimals for display purposes
113     }
114     
115     function totalSupply() public view returns (uint) {
116         return _totalSupply;
117     }
118     
119     function burn(uint256 _value) public returns (bool) {
120         if(balances[msg.sender] < _value){
121             return false;
122         }
123         if(_value <= 0){
124             return false;
125         }
126         if(_value > balances[msg.sender]){
127             return false;
128         }
129         balances[msg.sender] -= _value; 
130         _totalSupply -= _value;                                // Updates _totalSupply
131         emit Burn(msg.sender, _value);
132         return true;
133     }
134 }