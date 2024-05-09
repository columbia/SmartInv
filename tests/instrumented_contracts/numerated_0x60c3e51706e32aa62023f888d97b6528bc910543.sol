1 pragma solidity ^0.4.18;
2 
3 // EIP20 - ERC20 Token standard
4 contract ERC20TokenInterface {
5 
6     /// @return The total amount of tokens
7     function totalSupply() constant returns (uint256 supply);
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant public returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40 }
41 
42 // DDToken contract
43 contract DDToken is ERC20TokenInterface {
44 
45     string public constant name = "DDToken";
46     string public constant symbol = "DDT";
47     uint256 public constant decimals = 6;
48     uint256 public constant totalTokens = 50000000 * (10 ** decimals);
49 
50     mapping (address => uint256) public balances;
51     mapping (address => mapping (address => uint256)) public allowed;
52 
53     function DDToken() {
54         balances[msg.sender] = totalTokens;
55     }
56 
57     function totalSupply() constant returns (uint256) {
58         return totalTokens;
59     }
60 
61     function transfer(address _to, uint256 _value) public returns (bool) {
62         if (balances[msg.sender] >= _value) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         }
68         return false;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(_from, _to, _value);
77             return true;
78         }
79         return false;
80     }
81 
82     function balanceOf(address _owner) constant public returns (uint256) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
93         return allowed[_owner][_spender];
94     }
95 
96 }