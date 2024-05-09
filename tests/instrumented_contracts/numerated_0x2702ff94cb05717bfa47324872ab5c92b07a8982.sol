1 pragma solidity ^0.4.0;
2 
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     function transfer(address to, uint256 value) public returns (bool success);
7     function transferFrom(address from, address to, uint256 value) public returns (bool success);
8     function approve(address spender, uint256 value) public returns (bool success);
9 
10     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions.
11     function totalSupply() public constant returns (uint256 supply);
12     function balanceOf(address owner) public constant returns (uint256 balance);
13     function allowance(address owner, address spender) public constant returns (uint256 remaining);
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
28     uint256 public maxSupply;
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
43             revert();
44         }
45         balances[msg.sender] -= _value;
46         balances[_to] += _value;
47         emit Transfer(msg.sender, _to, _value);
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
62             revert();
63         }
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         allowed[_from][msg.sender] -= _value;
67         emit Transfer(_from, _to, _value);
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
80         emit Approval(msg.sender, _spender, _value);
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
112 // author: SuXeN
113 contract SolarNA is StandardToken {
114 
115     /*
116      *  Token meta data
117      */
118     string constant public name = "SolarNA Token";
119     string constant public symbol = "SOLA";
120     uint8 constant public decimals = 3;
121     address public owner;
122     uint remaining;
123     uint divPrice = 10 ** 12;
124 
125     /*
126      *  Public functions
127      */
128     /// @dev Contract constructor function gives tokens to presale_addresses and leave 100k tokens for sale.
129     /// @param presale_addresses Array of addresses receiving preassigned tokens.
130     /// @param tokens Array of preassigned token amounts.
131     /// NB: Max 4 presale_addresses
132     function SolarNA(address[] presale_addresses, uint[] tokens)
133         public
134     {
135         uint assignedTokens;
136         owner = msg.sender;
137         maxSupply = 500000 * 10**3;
138         for (uint i=0; i<presale_addresses.length; i++) {
139             if (presale_addresses[i] == 0) {
140                 // Address should not be null.
141                 revert();
142             }
143             balances[presale_addresses[i]] += tokens[i];
144             assignedTokens += tokens[i];
145             emit Transfer(0, presale_addresses[i], tokens[i]); // emit an event
146         }
147         /// If presale_addresses > 4 => The maxSupply will increase
148         remaining = maxSupply - assignedTokens;
149         assignedTokens += remaining;
150         if (assignedTokens != maxSupply) {
151             revert();
152         }
153     }
154 
155     /// Change price from 1000 SOLA = 1 ether to 500 SOLA = 1 ether 
156     function changePrice(bool _conditon) public returns (uint) {
157         require(msg.sender == owner);
158         if (_conditon) {
159             divPrice *= 2;
160         }
161         return divPrice;
162     }
163 
164     function () public payable {
165         /// Required msg.value > 0 and still remaining tokens
166         uint value = msg.value / uint(divPrice);
167         require(remaining >= value && value != 0);
168         balances[msg.sender] += value;
169         remaining -= value;
170         emit Transfer(address(0), msg.sender, value);
171     }
172     
173     /// Transfer all the funds in ETH to the owner
174     function transferAll() public returns (bool) {
175         require(msg.sender == owner);
176         owner.transfer(address(this).balance);
177         return true;
178     }
179 
180     /// Return MaxSupply    
181     function totalSupply()  public constant returns (uint256 supply) {
182         return maxSupply;
183     }
184     
185     /// Return remaining tokens
186     function remainingTokens() public view returns (uint256) {
187         return remaining;
188     } 
189 
190 }