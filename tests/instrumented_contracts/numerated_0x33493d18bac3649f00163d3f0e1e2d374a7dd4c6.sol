1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13  
14 contract Multibot is ERC20Interface {
15     address public owner;
16 
17     string public constant symbol = "MBT";
18     string public constant name = "Multibot";
19     uint8 public constant decimals = 8;
20     uint256 initialSupply = 2500000000000000;
21     
22     uint256 public shareholdersBalance;
23     uint256 public totalShareholders;
24     mapping (address => bool) registeredShareholders;
25     mapping (uint => address) public shareholders;
26     
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) public allowed;
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34     
35     function isToken() public constant returns (bool weAre) {
36         return true;
37     }
38     
39     modifier onlyPayloadSize(uint size) {
40         require(msg.data.length >= size + 4);
41         _;
42     }
43  
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     event Burn(address indexed from, uint256 value);
47     
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 
50     function Multibot() {
51         owner = msg.sender;
52         balances[owner] = initialSupply;
53         totalSupply=initialSupply;
54         totalShareholders = 0;
55 		shareholdersBalance = 0;
56     }
57 
58     function balanceOf(address _owner) constant returns (uint256 balance) {
59         return balances[_owner];
60     }
61     
62     /// @notice Send `_value` tokens to `_to` from your account
63     /// @param _to The address of the recipient
64     /// @param _value the amount to send
65     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
66         if(_to != 0x0 && _value > 0 && balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
67         {
68             balances[msg.sender] -= _value;
69             balances[_to] += _value;
70             
71             if (msg.sender == owner && _to != owner) {
72                 shareholdersBalance += _value;
73             }
74             if (msg.sender != owner && _to == owner) {
75                 shareholdersBalance -= _value;
76             }
77             if (owner != _to) {
78                 insertShareholder(_to);
79             }
80             
81             Transfer(msg.sender, _to, _value);
82             return true;
83         }
84         else 
85         {
86             return false;
87         }
88     }
89 
90     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
91     /// @param _from The address of the sender
92     /// @param _to The address of the recipient
93     /// @param _value the amount to send
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
96             balances[_from] -= _value;
97             allowed[_from][msg.sender] -= _value;
98             balances[_to] += _value;
99             
100             if (_from == owner && _to != owner) {
101                 shareholdersBalance += _value;
102             }
103             if (_from != owner && _to == owner) {
104                 shareholdersBalance -= _value;
105             }
106             if (owner != _to) {
107                 insertShareholder(_to); 
108             }
109             
110             Transfer(_from, _to, _value);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 
117     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
118     /// @param _spender The address authorized to spend
119     /// @param _value the max amount they can spend
120     function approve(address _spender, uint256 _value) returns (bool success) {
121         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) 
122         {
123             return false;
124         }
125         
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128         return true;
129     }
130     
131     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132         return allowed[_owner][_spender];
133     }
134 
135     /// @notice Remove `_value` tokens from the system irreversibly
136     /// @param _value the amount of money to burn
137     function burn(uint256 _value) onlyOwner returns (bool success) {
138         require (balances[msg.sender] > _value);            // Check if the sender has enough
139         balances[msg.sender] -= _value;                      // Subtract from the sender
140         totalSupply -= _value;                                // Updates totalSupply
141         Burn(msg.sender, _value);
142         return true;
143     }
144     
145     function insertShareholder(address _shareholder) internal returns (bool) {
146         if (registeredShareholders[_shareholder] == true) {
147             return false;
148         } else {
149             totalShareholders += 1;
150             shareholders[totalShareholders] = _shareholder;
151             registeredShareholders[_shareholder] = true;
152             return true;
153         }
154         return false;
155     }
156     
157     function shareholdersBalance() public returns (uint256) {
158         return shareholdersBalance;
159     }
160     
161     function totalShareholders() public returns (uint256) {
162         return totalShareholders;
163     }
164     
165     function getShareholder(uint256 _index) public returns (address) {
166         return shareholders[_index];
167     }
168 }