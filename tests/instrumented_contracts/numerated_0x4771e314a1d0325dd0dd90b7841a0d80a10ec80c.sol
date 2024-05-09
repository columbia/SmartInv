1 pragma solidity 0.4.14;
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
61     string messageString = "[Welcome to the ZerroXBToken-2 Project 0xbt.net]";
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
74     function transfer_data(address _to, uint _value, string _data) returns (bool) {
75         //Default assumes totalSupply can't be over max (2^256 - 1).
76         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             
81             return true;
82         } else { return false; }
83     }
84 
85     function transferFrom(address _from, address _to, uint _value) returns (bool) {
86         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
87             balances[_to] += _value;
88             balances[_from] -= _value;
89             allowed[_from][msg.sender] -= _value;
90             Transfer(_from, _to, _value);
91             return true;
92         } else { return false; }
93     }
94 
95     function balanceOf(address _owner) constant returns (uint) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint _value) returns (bool) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) constant returns (uint) {
106         return allowed[_owner][_spender];
107     }
108 
109     mapping (address => uint) balances;
110     mapping (address => mapping (address => uint)) allowed;
111     uint public totalSupply;
112 }
113 
114 contract UnlimitedAllowanceToken is StandardToken {
115 
116     uint constant MAX_UINT = 2**256 - 1;
117     
118     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
119     /// @param _from Address to transfer from.
120     /// @param _to Address to transfer to.
121     /// @param _value Amount to transfer.
122     /// @return Success of transfer.
123     function transferFrom(address _from, address _to, uint _value)
124         public
125         returns (bool)
126     {
127         uint allowance = allowed[_from][msg.sender];
128         if (balances[_from] >= _value
129             && allowance >= _value
130             && balances[_to] + _value >= balances[_to]
131         ) {
132             balances[_to] += _value;
133             balances[_from] -= _value;
134             if (allowance < MAX_UINT) {
135                 allowed[_from][msg.sender] -= _value;
136             }
137             Transfer(_from, _to, _value);
138             return true;
139         } else {
140             return false;
141         }
142     }
143 }
144 
145 contract ZerroXBToken is UnlimitedAllowanceToken {
146 
147     uint8 constant public decimals = 3;
148     uint public totalSupply = 270000000000; // 270 billion tokens
149     string constant public name = "ZerroXBToken-2";
150     string constant public symbol = "ZxBT";
151     string messageString = "[Welcome to the ZerroXBToken-2 Project 0xbt.net]";
152     
153     function getNews() public constant returns (string message) {
154         return messageString;
155     }
156     
157     function setNews(string lastNews) public {
158         messageString = lastNews;
159     }
160     
161     function ZerroXBToken() {
162         balances[msg.sender] = totalSupply;
163     }
164 }