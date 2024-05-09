1 pragma solidity ^0.4.10;
2 
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     function transfer(address to, uint256 value) returns (bool success);
7     function transferFrom(address from, address to, uint256 value) returns (bool success);
8     function approve(address spender, uint256 value) returns (bool success);
9 
10     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions.
11     function totalSupply() constant returns (uint256) {}
12     function balanceOf(address owner) constant returns (uint256 balance);
13     function allowance(address owner, address spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 /// @title Standard token contract - Standard token interface implementation.
21 contract StandardToken is Token {
22 
23     /*
24      *  Data structures
25      */
26     mapping (address => uint256) balances;
27     mapping (address => mapping (address => uint256)) allowed;
28     uint256 public totalSupply;
29 
30     /*
31      *  Public functions
32      */
33     /// @dev Transfers sender's tokens to a given address. Returns success.
34     /// @param _to Address of token receiver.
35     /// @param _value Number of tokens to transfer.
36     /// @return Returns success of function call.
37     function transfer(address _to, uint256 _value)
38         public
39         returns (bool)
40     {
41         if (balances[msg.sender] < _value) {
42             // Balance too low
43             throw;
44         }
45         balances[msg.sender] -= _value;
46         balances[_to] += _value;
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50 
51     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
52     /// @param _from Address from where tokens are withdrawn.
53     /// @param _to Address to where tokens are sent.
54     /// @param _value Number of tokens to transfer.
55     /// @return Returns success of function call.
56     function transferFrom(address _from, address _to, uint256 _value)
57         public
58         returns (bool)
59     {
60         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
61             // Balance or allowance too low
62             throw;
63         }
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         allowed[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     /// @dev Sets approved amount of tokens for spender. Returns success.
72     /// @param _spender Address of allowed account.
73     /// @param _value Number of approved tokens.
74     /// @return Returns success of function call.
75     function approve(address _spender, uint256 _value)
76         public
77         returns (bool)
78     {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     /*
85      * Read functions
86      */
87     /// @dev Returns number of allowed tokens for given address.
88     /// @param _owner Address of token owner.
89     /// @param _spender Address of token spender.
90     /// @return Returns remaining allowance for spender.
91     function allowance(address _owner, address _spender)
92         constant
93         public
94         returns (uint256)
95     {
96         return allowed[_owner][_spender];
97     }
98 
99     /// @dev Returns number of tokens owned by given address.
100     /// @param _owner Address of token owner.
101     /// @return Returns balance of owner.
102     function balanceOf(address _owner)
103         constant
104         public
105         returns (uint256)
106     {
107         return balances[_owner];
108     }
109 }
110 
111 
112 /// @title DelphiToken contract
113 /// @author Christopher Grant - <christopher@delphi.markets>
114 contract DelphiToken is StandardToken {
115 
116     /*
117      *  Token meta data
118      */
119     string constant public name = "Delphi";
120     string constant public symbol = "DEL";
121     uint8 constant public decimals = 18;
122 
123     /*
124      *  Public functions
125      */
126 
127     /* Initializes contract with initial supply tokens to the creator of the contract */
128     function DelphiToken() public {
129         uint256 initialSupply = 10000000 * 10**18;
130         totalSupply = initialSupply;
131         balances[msg.sender] = initialSupply;
132     }
133 }