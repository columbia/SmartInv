1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ConoToken  {
37 
38     using SafeMath for uint256;
39     
40     uint256 public _totalSupply;
41     
42     uint256 public constant AMOUNT = 1000000000;    // initial amount of token
43     
44     string public constant symbol = "CONO";
45     string public constant name = "Cono Coins";
46     uint8 public constant decimals = 18; 
47     string public version = '1.0';  
48 
49     
50     mapping(address => uint256) balances;
51     mapping(address => mapping(address => uint256)) allowed;
52     
53     address _contractCreator;
54     
55     function ConoToken(address owner) public {
56         _contractCreator = owner;
57         _totalSupply = AMOUNT * 1000000000000000000;
58         balances[_contractCreator] = _totalSupply;
59     }
60      
61 
62     /// @return total amount of tokens
63     function totalSupply() constant public returns (uint256) {
64         return _totalSupply;
65     }
66 
67     /// @param who The address from which the balance will be retrieved
68     /// @return The balance
69     function balanceOf(address who) constant public returns (uint256){
70         return balances[who];
71     }
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         
79         require(_to != 0x00);
80         //Default assumes totalSupply can't be over max (2^256 - 1).
81         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
82         //Replace the if with this one instead.
83         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84         require(balances[msg.sender] >= _value && _value > 0 );
85         require(balances[_to] + _value >= balances[_to]); // Check for overflows
86 
87         if (balances[msg.sender] >= _value && _value > 0) {
88             //balances[msg.sender] -= _value;
89             balances[msg.sender] = balances[msg.sender].sub(_value);
90             balances[_to] += _value;
91             Transfer(msg.sender, _to, _value);  // Log the Transaction
92             return true;
93         } else { return false; }
94     }
95         
96 
97     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
98     /// @param _from The address of the sender
99     /// @param _to The address of the recipient
100     /// @param _value The amount of token to be transferred
101     /// @return Whether the transfer was successful or not
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103          //same as above. Replace this line with the following if you want to protect against wrapping uints.
104         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
105         require(
106             allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0
107         );
108         require(balances[_to] + _value >= balances[_to]); // Check for overflows
109         
110         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
111             balances[_to] += _value;
112 
113             balances[_from] -= _value;
114             allowed[_from][msg.sender] -= _value;
115             Transfer(_from, _to, _value);
116             return true;
117         } else { return false; }
118     }
119 
120     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
121     /// @param _spender The address of the account able to transfer the tokens
122     /// @param _value The amount of wei to be approved for transfer
123     /// @return Whether the approval was successful or not
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value); // Log the Transaction
127         return true;
128     }
129 
130     /// @param _owner The address of the account owning tokens
131     /// @param _spender The address of the account able to transfer the tokens
132     /// @return Amount of remaining tokens allowed to spent
133     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
134         return allowed[_owner][_spender];
135     }
136 
137     event Transfer(address indexed _from, address indexed _to, uint256 _value);
138     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
139  
140 }