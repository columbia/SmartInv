1 /*
2 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
3 */
4 
5 pragma solidity ^0.4.2;
6 
7 // Abstract contract for the full ERC 20 Token standard
8 // https://github.com/ethereum/EIPs/issues/20
9 pragma solidity ^0.4.2;
10 
11 contract Token {
12     /* This is a slight change to the ERC20 base standard.
13     function totalSupply() constant returns (uint256 supply);
14     is replaced with:
15     uint256 public totalSupply;
16     This automatically creates a getter function for the totalSupply.
17     This is moved to the base contract since public getter functions are not
18     currently recognised as an implementation of the matching abstract
19     function by the compiler.
20     */
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     function transfer(address _to, uint256 _value);
32 
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     function transferFrom(address _from, address _to, uint256 _value);
38 
39     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @param _value The amount of tokens to be approved for transfer
42     /// @return Whether the approval was successful or not
43     function approve(address _spender, uint256 _value) returns (bool success);
44 
45     /// @param _owner The address of the account owning tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @return Amount of remaining tokens allowed to spent
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 pragma solidity ^0.4.2;
55 
56 contract Owned {
57 
58 	address owner;
59 
60 	function Owned() {
61 		owner = msg.sender;
62 	}
63 
64 	modifier onlyOwner {
65         if (msg.sender != owner)
66             throw;
67         _;
68     }
69 }
70 
71 
72 contract AliceToken is Token, Owned {
73 
74     string public name = "Alice Token";
75     uint8 public decimals = 2;
76     string public symbol = "ALT";
77     string public version = 'ALT 1.0';
78 
79 
80     function transfer(address _to, uint256 _value) {
81         //Default assumes totalSupply can't be over max (2^256 - 1).
82         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83             balances[msg.sender] -= _value;
84             balances[_to] += _value;
85             Transfer(msg.sender, _to, _value);
86         } else { throw; }
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) {
90         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91             balances[_to] += _value;
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             Transfer(_from, _to, _value);
95         } else { throw; }
96     }
97 
98     function balanceOf(address _owner) constant returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 
112     function mint(address _to, uint256 _value) onlyOwner {
113         if (totalSupply + _value < totalSupply) throw;
114             totalSupply += _value;
115             balances[_to] += _value;
116 
117             MintEvent(_to, _value);
118     }
119 
120     function destroy(address _from, uint256 _value) onlyOwner {
121         if (balances[_from] < _value || _value < 0) throw;
122             totalSupply -= _value;
123             balances[_from] -= _value;
124 
125             DestroyEvent(_from, _value);
126     }
127 
128     mapping (address => uint256) balances;
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     event MintEvent(address indexed to, uint value);
132     event DestroyEvent(address indexed from, uint value);
133 }