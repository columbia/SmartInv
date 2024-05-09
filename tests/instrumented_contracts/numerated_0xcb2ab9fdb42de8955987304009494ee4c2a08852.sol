1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) public constant returns (uint balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint _value);
47     event Approval(address indexed _owner, address indexed _spender, uint _value);
48 }
49 contract StandardToken is Token {
50 
51     function transfer(address _to, uint _value) public returns (bool success) {
52         //Default assumes totalSupply can't be over max (2^256 - 1).
53         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
54         //Replace the if with this one instead.
55         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
56         require(balances[msg.sender] >= _value);
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
64         //same as above. Replace this line with the following if you want to protect against wrapping uints.
65         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
66         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
67         balances[_to] += _value;
68         balances[_from] -= _value;
69         allowed[_from][msg.sender] -= _value;
70         Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) public constant returns (uint balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint _value) public returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint) balances;
89     mapping (address => mapping (address => uint)) allowed;
90 }
91 
92 contract Owned {
93     address public owner;
94 
95     modifier onlyOwner() {
96         require(msg.sender == owner);
97         _;
98     }
99 
100     function Owned() public {
101         owner = msg.sender;
102     }
103 
104     function transferOwnership(address _owner) public onlyOwner {
105         require(_owner != 0x0);
106         owner = _owner;
107     }
108 }
109 
110 contract VankiaToken is StandardToken, Owned {
111     string public constant name = "Vankia Token";
112     uint8 public constant decimals = 18;
113     string public constant symbol = "VNT";
114 
115     event Burnt(address indexed from, uint amount);
116 
117     function VankiaToken() public {
118         totalSupply = (10 ** 9) * (10 ** uint(decimals));
119         balances[msg.sender] = totalSupply;
120     }
121 
122     function withdraw(uint _amount) public onlyOwner {
123         owner.transfer(_amount);
124     }
125 
126     // anyone can burn their VKN tokens
127     function burn(uint _amount) public {
128         require(_amount > 0);
129         require(balances[msg.sender] >= _amount);
130         balances[msg.sender] -= _amount;
131         totalSupply -= _amount;
132         
133         Burnt(msg.sender, _amount);
134         Transfer(msg.sender, 0x0, _amount);
135     }
136 
137     // can accept ether
138     function() public payable {}
139 }