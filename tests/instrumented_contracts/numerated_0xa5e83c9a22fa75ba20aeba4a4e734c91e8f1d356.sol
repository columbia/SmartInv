1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.25;
4 
5 
6 contract EIP20Interface {
7 /* This is a slight change to the ERC20 base standard.
8 function totalSupply() constant returns (uint256 supply);
9 is replaced with:
10 uint256 public totalSupply;
11 This automatically creates a getter function for the totalSupply.
12 This is moved to the base contract since public getter functions are not
13 currently recognised as an implementation of the matching abstract
14 function by the compiler.
15 */
16 /// total amount of tokens
17 uint256 public totalSupply;
18 
19 /// @param _owner The address from which the balance will be retrieved
20 /// @return The balance
21 function balanceOf(address _owner) public view returns (uint256 balance);
22 
23 /// @notice send `_value` token to `_to` from `msg.sender`
24 /// @param _to The address of the recipient
25 /// @param _value The amount of token to be transferred
26 /// @return Whether the transfer was successful or not
27 function transfer(address _to, uint256 _value) public returns (bool success);
28 
29 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30 /// @param _from The address of the sender
31 /// @param _to The address of the recipient
32 /// @param _value The amount of token to be transferred
33 /// @return Whether the transfer was successful or not
34 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36 /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37 /// @param _spender The address of the account able to transfer the tokens
38 /// @param _value The amount of tokens to be approved for transfer
39 /// @return Whether the approval was successful or not
40 function approve(address _spender, uint256 _value) public returns (bool success);
41 
42 /// @param _owner The address of the account owning tokens
43 /// @param _spender The address of the account able to transfer the tokens
44 /// @return Amount of remaining tokens allowed to spent
45 function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47 // solhint-disable-next-line no-simple-event-func-name
48 event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 
54 /*
55 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
56 .*/
57 
58 
59 pragma solidity ^0.4.25;
60 
61 contract VisualFodderCoin is EIP20Interface {
62 
63     uint256 constant private MAX_UINT256 = 2**256 - 1;
64     mapping (address => uint256) public balances;
65     mapping (address => mapping (address => uint256)) public allowed;
66     /*
67     NOTE:
68     The following variables are OPTIONAL vanities. One does not have to include them.
69     They allow one to customise the token contract & in no way influences the core functionality.
70     Some wallets/interfaces might not even bother to look at this information.
71     */
72     string public constant name = "VisualFodderCoin";            //Set the name for display purposes
73     string public constant symbol = "VFC";              // Set the symbol for display purposes
74     uint8 public constant decimals = 18;                //How many decimals to show.
75     uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(decimals));
76 
77     function VisualFodderCoin() public {
78         balances[msg.sender] = INITIAL_SUPPLY;               // Give the creator all initial tokens
79         totalSupply = INITIAL_SUPPLY;                        // Update total supply
80         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
81     }
82 
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         require(balances[msg.sender] >= _value);
85         balances[msg.sender] -= _value;
86         balances[_to] += _value;
87         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         uint256 allowance = allowed[_from][msg.sender];
93         require(balances[_from] >= _value && allowance >= _value);
94         balances[_to] += _value;
95         balances[_from] -= _value;
96         if (allowance < MAX_UINT256) {
97             allowed[_from][msg.sender] -= _value;
98         }
99         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
100         return true;
101     }
102 
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 }