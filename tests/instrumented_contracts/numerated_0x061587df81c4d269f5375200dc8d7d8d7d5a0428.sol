1 pragma solidity 0.4.12;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     
15 function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 
22 
23 contract Token is owned {
24 
25     /// @return total amount of tokens
26     function totalSupply() constant returns (uint256 supply) {}
27 
28     /// @param _owner The address from which the balance will be retrieved
29     /// @return The balance
30     function balanceOf(address _owner) constant returns (uint256 balance) {}
31 
32     /// @notice send `_value` token to `_to` from `msg.sender`
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transfer(address _to, uint256 _value) returns (bool success) {}
37 
38     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39     /// @param _from The address of the sender
40     /// @param _to The address of the recipient
41     /// @param _value The amount of token to be transferred
42     /// @return Whether the transfer was successful or not
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
44 
45     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @param _value The amount of wei to be approved for transfer
48     /// @return Whether the approval was successful or not
49     function approve(address _spender, uint256 _value) returns (bool success) {}
50 
51     /// @param _owner The address of the account owning tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @return Amount of remaining tokens allowed to spent
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
55 
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58     
59 }
60 
61 contract StandardToken is Token {
62 
63     function transfer(address _to, uint _value) returns (bool) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function transferFrom(address _from, address _to, uint _value) returns (bool) {
74         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             allowed[_from][msg.sender] -= _value;
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function balanceOf(address _owner) constant returns (uint) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint _value) returns (bool) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns (uint) {
94         return allowed[_owner][_spender];
95     }
96 
97     mapping (address => uint) balances;
98     mapping (address => mapping (address => uint)) allowed;
99     uint public totalSupply;
100 }
101 
102 contract UnlimitedAllowanceToken is StandardToken {
103 
104     uint constant MAX_UINT = 2**256 - 1;
105     
106     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
107     /// @param _from Address to transfer from.
108     /// @param _to Address to transfer to.
109     /// @param _value Amount to transfer.
110     /// @return Success of transfer.
111     function transferFrom(address _from, address _to, uint _value)
112         public
113         returns (bool)
114     {
115         uint allowance = allowed[_from][msg.sender];
116         if (balances[_from] >= _value
117             && allowance >= _value
118             && balances[_to] + _value >= balances[_to]
119         ) {
120             balances[_to] += _value;
121             balances[_from] -= _value;
122             if (allowance < MAX_UINT) {
123                 allowed[_from][msg.sender] -= _value;
124             }
125             Transfer(_from, _to, _value);
126             return true;
127         } else {
128             return false;
129         }
130     }
131 }
132 
133 contract zXBToken is UnlimitedAllowanceToken {
134 
135     uint8 constant public decimals = 3;
136     uint public totalSupply = 210000000000; // 210 billion tokens
137     string constant public name = "zXBToken 0xbt";
138     string constant public symbol = "zXBT";
139     string wellcomeString = "Welcome to the 0xbt.net";
140     
141     function getData() public constant returns (string) {
142         return wellcomeString;
143     }
144     
145     function setData(string newData) public {
146         wellcomeString = newData;
147     }
148     
149     function zXBToken() {
150         balances[msg.sender] = totalSupply;
151     }
152 }