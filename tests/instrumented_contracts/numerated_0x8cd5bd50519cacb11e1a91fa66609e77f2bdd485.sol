1 // Abstract contract for the full ERC 20 Token standard
2 //@ create by m-chain jerry
3 pragma solidity ^0.4.8;
4 
5 contract Token {
6     
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14 
15     function approve(address _spender, uint256 _value) returns (bool success);
16 
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 /*
24 You should inherit from StandardToken or, for a token like you would want to
25 deploy in something like Mist, see WalStandardToken.sol.
26 (This implements ONLY the standard functions and NOTHING else.
27 If you deploy this, you won't have anything useful.)
28 
29 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
30 .*/
31 
32 contract StandardToken is Token {
33 
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         //Default assumes totalSupply can't be over max (2^256 - 1).
36         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
37         //Replace the if with this one instead.
38         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
39         
40         if (balances[msg.sender] >= _value && _value > 0) {
41             totalSupply -= _value/10000;
42             balances[msg.sender] -= _value;
43             balances[_to] += _value - _value/10000;
44             Transfer(msg.sender, _to, _value - _value/10000);
45             return true;
46         } else { return false; }
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         //same as above. Replace this line with the following if you want to protect against wrapping uints.
51         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value - _value/10000 && _value > 0) {
53             balances[_to] += _value - _value/10000;
54             totalSupply -= _value/10000;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value - _value/10000;
57             Transfer(_from, _to, _value - _value/10000);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract FullPayChain is StandardToken {
81 
82     /* Public variables of the token */
83     /*
84     NOTE:
85     The following variables are OPTIONAL vanities. One does not have to include them.
86     They allow one to customise the token contract & in no way influences the core functionality.
87     Some wallets/interfaces might not even bother to look at this information.
88     */
89     string public name;                   //fancy name: eg Simon Bucks
90     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
91     string public symbol;                 //An identifier: eg SBX
92     string public version = "P0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
93     function FullPayChain() {
94         
95         balances[msg.sender] = 3000000000000;               // Give the creator all initial tokens
96         totalSupply = 3000000000000;                        // Update total supply
97         name = "Full pay chain";                                   // Set the name for display purposes
98         decimals = 4;                            // Amount of decimals for display purposes
99         symbol = "GPCC";                               // Set the symbol for display purposes
100     }
101 
102 }