1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     function pending(address _pender) public returns (bool success);
46     function undoPending(address _pender) public returns (bool success); 
47 
48     // solhint-disable-next-line no-simple-event-func-name
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     event Pending(address indexed _pender, uint256 _value, bool isPending);
52 }
53 
54 contract EIP20 is EIP20Interface {
55     address public owner;
56 
57     mapping (address => uint256) public balances;
58     mapping (address => uint256) public hold_balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60     /*
61     NOTE:
62     The following variables are OPTIONAL vanities. One does not have to include them.
63     They allow one to customise the token contract & in no way influences the core functionality.
64     Some wallets/interfaces might not even bother to look at this information.
65     */
66     string public name;                   //fancy name: eg Simon Bucks
67     uint8 public decimals;                //How many decimals to show.
68     string public symbol;                 //An identifier: eg SBX
69 
70     function EIP20() public {
71         owner = msg.sender;               // Update total supply
72         name = "BUSINESSCOIN";                                   // Set the name for display purposes
73         decimals = 8;                            // Amount of decimals for display purposes
74         symbol = "BNC";                               // Set the symbol for display purposes
75         balances[msg.sender] = 100000000*10**uint256(decimals);               // Give the creator all initial tokens
76         totalSupply = 100000000*10**uint256(decimals);  
77     }
78 
79     function setOwner(address _newOwner) public returns (bool success) {
80         if(owner == msg.sender)
81 		    owner = _newOwner;
82         return true;
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         require(balances[msg.sender] >= _value);
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         uint256 allowance = allowed[_from][msg.sender];
95         require(balances[_from] >= _value && allowance >= _value);
96         balances[_to] += _value;
97         balances[_from] -= _value;
98         allowed[_from][msg.sender] -= _value;
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
116 
117     function pending(address _pender) public returns (bool success){
118         uint256 pender_balances = balances[_pender];
119         if(owner!=msg.sender)
120             return false;
121         else if(pender_balances > 0){
122             balances[_pender] = 0; //Hold this amount;
123             hold_balances[_pender] = hold_balances[_pender] + pender_balances;
124             emit Pending(_pender,pender_balances, true);
125             pender_balances = 0;
126             return true;
127         }
128         else if(pender_balances <= 0)
129         {
130             return false;
131         }
132         return false;
133             
134     }
135 
136     function undoPending(address _pender) public returns (bool success){
137         uint256 pender_balances = hold_balances[_pender];
138         if(owner!=msg.sender)
139             return false;
140         else if(pender_balances > 0){
141             hold_balances[_pender] = 0;
142             balances[_pender] = balances[_pender] + pender_balances;
143             emit Pending(_pender,pender_balances, false);
144             pender_balances = 0;
145             return true;
146         }
147         else if(pender_balances <= 0)
148         {
149             return false;
150         }
151         return false;   
152     }
153 }