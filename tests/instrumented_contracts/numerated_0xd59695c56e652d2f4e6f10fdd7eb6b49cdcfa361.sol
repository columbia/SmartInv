1 // Abstract contract for the full ERC 20 Token standard
2 //@ create by m-chain jerry
3 // https://github.com/ethereum/EIPs/issues/20
4 pragma solidity ^0.4.8;
5 
6 contract Token {
7     
8     uint256 public totalSupply;
9 
10     function balanceOf(address _owner) constant returns (uint256 balance);
11 
12     function transfer(address _to, uint256 _value) returns (bool success);
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15 
16     function approve(address _spender, uint256 _value) returns (bool success);
17 
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 /*
25 You should inherit from StandardToken or, for a token like you would want to
26 deploy in something like Mist, see WalStandardToken.sol.
27 (This implements ONLY the standard functions and NOTHING else.
28 If you deploy this, you won't have anything useful.)
29 
30 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
31 .*/
32 
33 contract StandardToken is Token {
34 
35     function transfer(address _to, uint256 _value) returns (bool success) {
36         //Default assumes totalSupply can't be over max (2^256 - 1).
37         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
38         //Replace the if with this one instead.
39         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
40         if (balances[msg.sender] >= _value && _value > 0) {
41             balances[msg.sender] -= _value;
42             balances[_to] += _value;
43             Transfer(msg.sender, _to, _value);
44             return true;
45         } else { return false; }
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49         //same as above. Replace this line with the following if you want to protect against wrapping uints.
50         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76 }
77 
78 contract RyeCoin is StandardToken {
79 
80     /* Public variables of the token */
81     /*
82     NOTE:
83     The following variables are OPTIONAL vanities. One does not have to include them.
84     They allow one to customise the token contract & in no way influences the core functionality.
85     Some wallets/interfaces might not even bother to look at this information.
86     */
87     string public name;                   //fancy name: eg Simon Bucks
88     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
89     string public symbol;                 //An identifier: eg SBX
90     string public version = "R0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
91     function RyeCoin() {
92         balances[msg.sender] = 1500000000000;               // Give the creator all initial tokens
93         totalSupply = 1500000000000;                        // Update total supply
94         name = "Rye Coin";                                   // Set the name for display purposes
95         decimals = 4;                           // Amount of decimals for display purposes
96         symbol = "RYE";                               // Set the symbol for display purposes
97     }
98 }