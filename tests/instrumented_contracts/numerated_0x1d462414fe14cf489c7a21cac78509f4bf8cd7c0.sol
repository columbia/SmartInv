1 /**
2  *  CanYaCoin (CAN) contract (FINAL)
3  */
4 
5 pragma solidity 0.4.15;
6 
7 
8 contract ERC20TokenInterface {
9 
10     /// @return The total amount of tokens
11     function totalSupply() constant returns (uint256 supply);
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) constant public returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of tokens to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44 }
45 
46 
47 contract CanYaCoin is ERC20TokenInterface {
48 
49     string public constant name = "CanYaCoin";
50     string public constant symbol = "CAN";
51     uint256 public constant decimals = 6;
52     uint256 public constant totalTokens = 100000000 * (10 ** decimals);
53 
54     mapping (address => uint256) public balances;
55     mapping (address => mapping (address => uint256)) public allowed;
56 
57     function CanYaCoin() {
58         balances[msg.sender] = totalTokens;
59     }
60 
61     function totalSupply() constant returns (uint256) {
62         return totalTokens;
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         if (balances[msg.sender] >= _value) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         }
72         return false;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
77             balances[_from] -= _value;
78             allowed[_from][msg.sender] -= _value;
79             balances[_to] += _value;
80             Transfer(_from, _to, _value);
81             return true;
82         }
83         return false;
84     }
85 
86     function balanceOf(address _owner) constant public returns (uint256) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 
100 }