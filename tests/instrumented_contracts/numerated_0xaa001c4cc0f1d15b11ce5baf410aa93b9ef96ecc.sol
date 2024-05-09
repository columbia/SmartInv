1 pragma solidity 0.4.11;
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
23 
24     /// @return total amount of tokens
25     function totalSupply() constant returns (uint256 supply) {}
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) constant returns (uint256 balance) {}
30 
31     /// @notice send `_value` token to `_to` from `msg.sender`
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transfer(address _to, uint256 _value) returns (bool success) {}
36     
37     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
38     /// @param _from The address of the sender
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
43 
44     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @param _value The amount of wei to be approved for transfer
47     /// @return Whether the approval was successful or not
48     function approve(address _spender, uint256 _value) returns (bool success) {}
49 
50     /// @param _owner The address of the account owning tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @return Amount of remaining tokens allowed to spent
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57     
58 }
59 
60 contract StandardToken is Token {
61     string messageString = "[ Welcome to the «ZENITH TTA | Tokens Ttansfer Adaptation» Project 0xbt ]";
62 
63     function transfer(address _to, uint _value) returns (bool) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             
70             return true;
71         } else { return false; }
72     }
73     
74     // Transfer token with data and signature
75     function transferAndData(address _to, uint _value, string _data) returns (bool) {
76         //Default assumes totalSupply can't be over max (2^256 - 1).
77         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
78             balances[msg.sender] -= _value;
79             balances[_to] += _value;
80             Transfer(msg.sender, _to, _value);
81             
82             return true;
83         } else { return false; }
84     }
85 
86     function transferFrom(address _from, address _to, uint _value) returns (bool) {
87         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
88             balances[_to] += _value;
89             balances[_from] -= _value;
90             allowed[_from][msg.sender] -= _value;
91             Transfer(_from, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function balanceOf(address _owner) constant returns (uint) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint _value) returns (bool) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) constant returns (uint) {
107         return allowed[_owner][_spender];
108     }
109 
110     mapping (address => uint) balances;
111     mapping (address => mapping (address => uint)) allowed;
112     uint public totalSupply;
113 }
114 
115 contract UnlimitedAllowanceToken is StandardToken {
116 
117     uint constant MAX_UINT = 2**256 - 1;
118     
119     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
120     /// @param _from Address to transfer from.
121     /// @param _to Address to transfer to.
122     /// @param _value Amount to transfer.
123     /// @return Success of transfer.
124     function transferFrom(address _from, address _to, uint _value)
125         public
126         returns (bool)
127     {
128         uint allowance = allowed[_from][msg.sender];
129         if (balances[_from] >= _value
130             && allowance >= _value
131             && balances[_to] + _value >= balances[_to]
132         ) {
133             balances[_to] += _value;
134             balances[_from] -= _value;
135             if (allowance < MAX_UINT) {
136                 allowed[_from][msg.sender] -= _value;
137             }
138             Transfer(_from, _to, _value);
139             return true;
140         } else {
141             return false;
142         }
143     }
144 }
145 
146 contract ZENITH is UnlimitedAllowanceToken {
147 
148     uint8 constant public decimals = 6;
149     uint public totalSupply = 270000000000000;
150     string constant public name = "ZENITH TTA";
151     string constant public symbol = "ZENITH";
152     string messageString = "[ Welcome to the «ZENITH TTA | Tokens Ttansfer Adaptation» Project 0xbt ]";
153 	mapping (address => mapping (address => uint)) public tokens; // this maps an address of a token with a mapping of an address of an owner and the amount of those tokens
154     event Transfer(address token, address user, uint amount, uint balance);
155   
156     // Transfer any ERC token with data and signature
157     function transferTokenData(address token, address _to, uint _value, string _data) {
158     if (token==0) throw;
159     if (!Token(token).transferFrom(msg.sender, _to, _value)) throw;
160     Transfer(token, _to, _value, tokens[token][msg.sender]);
161     }
162     
163     function getNews() public constant returns (string message) {
164         return messageString;
165     }
166     
167     function setNews(string lastNews) public {
168         messageString = lastNews;
169     }
170     
171     function ZENITH() {
172         balances[msg.sender] = totalSupply;
173     }
174 }