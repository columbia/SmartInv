1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
5         uint256 z = x + y;
6         assert((z >= x) && (z >= y));
7         return z;
8     }
9     
10     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
11         assert(x >= y);
12         uint256 z = x - y;
13         return z;
14     }
15     
16     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
17         uint256 z = x * y; 
18         assert((x == 0)||(z/x == y));
19         return z;
20     }
21     
22 }
23 
24 contract Token {
25      /// total amount of tokens
26     uint256 public totalSupply;
27     
28     /// @param _owner The address from which the balance will be retrieved
29     /// @return The balance
30     function balanceOf(address _owner) constant public returns (uint256  balance);
31     
32     /// @notice send `_value` token to `_to` from `msg.sender`
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transfer(address _to, uint256 _value) public returns (bool success);
37     
38      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39     /// @param _from The address of the sender
40     /// @param _to The address of the recipient
41     /// @param _value The amount of token to be transferred
42     /// @return Whether the transfer was successful or not
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
44     
45     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @param _value The amount of tokens to be approved for transfer
48     /// @return Whether the approval was successful or not
49     function approve(address _spender, uint256 _value) public returns (bool success);
50     
51     /// @param _owner The address of the account owning tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @return Amount of remaining tokens allowed to spent
54     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 /*  ERC 20 token */
60 contract StandardToken is Token ,SafeMath{
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] = safeSubtract(balances[msg.sender],_value);
64             balances[_to] = safeAdd(balances[_to],_value) ;
65             emit Transfer(msg.sender, _to, _value);
66             return true;
67         } else {
68             return false;
69         }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74             balances[_to] = safeAdd(balances[_to],_value) ;
75             balances[_from] = safeSubtract(balances[_from],_value) ;
76             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
77             emit Transfer(_from, _to, _value);
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     function balanceOf(address _owner) constant public returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90        emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 
102 contract POCCToken is StandardToken  {
103     // metadata
104     string  public constant name = "POCC Token";
105     string  public constant symbol = "POCC";                                
106     uint256 public constant decimals = 18;
107     string  public version = "1.0";
108     uint256 public tokenExchangeRate = 80000;                              // 80000  tokens per 1 ETH
109     
110     address public owner; //owner
111     
112     // events 
113     event DecreaseSupply(uint256 _value);
114 
115     // constructor
116     constructor(address _owner) public {
117         owner = _owner;
118         totalSupply = safeMult(10000000000,10 ** decimals);
119         balances[owner] = totalSupply;
120     }
121     
122     modifier onlyOwner {
123         require(msg.sender == owner);
124         _;
125     }
126    
127      /// @dev decrease the token's supply
128     function decreaseSupply (uint256 _value) onlyOwner  public{
129         if (balances[owner] < _value)  revert();
130         uint256 value = safeMult(_value , 10 ** decimals);
131         balances[owner] = safeSubtract(balances[owner],value);
132         totalSupply = safeSubtract(totalSupply, value);
133         emit DecreaseSupply(value);
134     }
135     
136 }