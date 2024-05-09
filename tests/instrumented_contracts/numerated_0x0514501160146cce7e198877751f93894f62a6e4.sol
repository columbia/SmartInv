1 // Abstract contract for the full ERC 20 Token standard
2 pragma solidity ^0.5.17;
3 
4 contract Token {
5     
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13 
14     function approve(address _spender, uint256 _value) public returns (bool success);
15 
16     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 /*
23 You should inherit from StandardToken or, for a token like you would want to
24 deploy in something like Mist, see WalStandardToken.sol.
25 (This implements ONLY the standard functions and NOTHING else.
26 If you deploy this, you won't have anything useful.)
27 
28 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
29 .*/
30 
31 contract StandardToken is Token {
32 
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34         //Default assumes totalSupply can't be over max (2^256 - 1).
35         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
36         //Replace the if with this one instead.
37         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             emit Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         //same as above. Replace this line with the following if you want to protect against wrapping uints.
48         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
49         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
50             balances[_to] += _value;
51             balances[_from] -= _value;
52             allowed[_from][msg.sender] -= _value;
53             emit Transfer(_from, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function balanceOf(address _owner) public view returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     function approve(address _spender, uint256 _value) public returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70     }
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 }
75 
76 contract MST is StandardToken {
77 
78     /* Public variables of the token */
79     /*
80     NOTE:
81     The following variables are OPTIONAL vanities. One does not have to include them.
82     They allow one to customise the token contract & in no way influences the core functionality.
83     Some wallets/interfaces might not even bother to look at this information.
84     */
85     string public name;                   //fancy name
86     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals.
87     string public symbol;                 //An identifier
88     string public version = "1.0";       // 0.1 standard. Just an arbitrary versioning scheme.
89     constructor() public{
90         balances[msg.sender] = 31000000000000;               // Give the creator all initial tokens
91         totalSupply = 31000000000000;                        // Update total supply
92         name = "MST";                                   // Set the name for display purposes
93         decimals = 6;                            // Amount of decimals for display purposes
94         symbol = "MST";                               // Set the symbol for display purposes
95     }
96 }