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
41         if (balances[msg.sender] < _value) throw;           // Insufficient funds
42         if (balances[_to] + _value < balances[_to]) throw;  // Check for overflows
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
50     /// @param _from Address from where tokens are withdrawn.
51     /// @param _to Address to where tokens are sent.
52     /// @param _value Number of tokens to transfer.
53     /// @return Returns success of function call.
54     function transferFrom(address _from, address _to, uint256 _value)
55         public
56         returns (bool)
57     {
58         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
59             // Balance or allowance too low
60             throw;
61         }
62         balances[_to] += _value;
63         balances[_from] -= _value;
64         allowed[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     /// @dev Sets approved amount of tokens for spender. Returns success.
70     /// @param _spender Address of allowed account.
71     /// @param _value Number of approved tokens.
72     /// @return Returns success of function call.
73     function approve(address _spender, uint256 _value)
74         public
75         returns (bool)
76     {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     /*
83      * Read functions
84      */
85     /// @dev Returns number of allowed tokens for given address.
86     /// @param _owner Address of token owner.
87     /// @param _spender Address of token spender.
88     /// @return Returns remaining allowance for spender.
89     function allowance(address _owner, address _spender)
90         constant
91         public
92         returns (uint256)
93     {
94         return allowed[_owner][_spender];
95     }
96 
97     /// @dev Returns number of tokens owned by given address.
98     /// @param _owner Address of token owner.
99     /// @return Returns balance of owner.
100     function balanceOf(address _owner)
101         constant
102         public
103         returns (uint256)
104     {
105         return balances[_owner];
106     }
107 }
108 
109 
110 /// @title DelphiToken contract
111 /// @author Christopher Grant - <christopher@delphi.markets>
112 contract DelphiToken is StandardToken {
113 
114     /*
115      *  Token meta data
116      */
117     string constant public name = "Delphi";
118     string constant public symbol = "DEL";
119     uint constant public tokenDecimals = 10**18;
120 
121     /*
122      *  Public functions
123      */
124 
125     /* Initializes contract with initial supply tokens to the creator of the contract */
126     function DelphiToken() public {
127         uint256 initialSupply = 10000000 * tokenDecimals;
128         balances[msg.sender] = initialSupply;
129     }
130 
131     function () {
132         //if ether is sent to this address, send it back.
133         throw;
134     }
135 }