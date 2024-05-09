1 pragma solidity 0.4.19;
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
21 contract Token is owned {
22 
23     /// @return total amount of tokens
24     function totalSupply() constant returns (uint256 supply) {}
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint256 balance) {}
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value, string _message) returns (bool success) {}
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) returns (bool success) {}
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56     
57 }
58 
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint _value, string _message) returns (bool) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
64             balances[msg.sender] -= _value;
65             balances[_to] += _value;
66             Transfer(msg.sender, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function transferFrom(address _from, address _to, uint _value) returns (bool) {
72         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             allowed[_from][msg.sender] -= _value;
76             Transfer(_from, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function balanceOf(address _owner) constant returns (uint) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint _value) returns (bool) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) constant returns (uint) {
92         return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint) balances;
96     mapping (address => mapping (address => uint)) allowed;
97     uint public totalSupply;
98 }
99 
100 contract UnlimitedAllowanceToken is StandardToken {
101 
102     uint constant MAX_UINT = 2**256 - 1;
103     
104     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
105     /// @param _from Address to transfer from.
106     /// @param _to Address to transfer to.
107     /// @param _value Amount to transfer.
108     /// @return Success of transfer.
109     function transferFrom(address _from, address _to, uint _value)
110         public
111         returns (bool)
112     {
113         uint allowance = allowed[_from][msg.sender];
114         if (balances[_from] >= _value
115             && allowance >= _value
116             && balances[_to] + _value >= balances[_to]
117         ) {
118             balances[_to] += _value;
119             balances[_from] -= _value;
120             if (allowance < MAX_UINT) {
121                 allowed[_from][msg.sender] -= _value;
122             }
123             Transfer(_from, _to, _value);
124             return true;
125         } else {
126             return false;
127         }
128     }
129 }
130 
131 contract ZerroXBToken is UnlimitedAllowanceToken {
132 
133     uint8 constant public decimals = 3;
134     uint public totalSupply = 210000000000; // 210 billion tokens
135     string constant public name = "ZerroXBToken Project 0xbt";
136     string constant public symbol = "ZXBT";
137     string messageString = "Welcome to the Project 0xbt.net";
138     
139     function getPost() public constant returns (string) {
140         return messageString;
141     }
142     
143     function setPost(string newPost) public {
144         messageString = newPost;
145     }
146     
147     function ZerroXBToken() {
148         balances[msg.sender] = totalSupply;
149     }
150 }