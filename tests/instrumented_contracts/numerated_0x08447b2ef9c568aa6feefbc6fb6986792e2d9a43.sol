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
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         //Default assumes totalSupply can't be over max (2^256 - 1).
36         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
37         //Replace the if with this one instead.
38         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
39         if (balances[msg.sender] >= _value && _value > 0) {
40             balances[msg.sender] -= _value;
41             balances[_to] += _value;
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         //same as above. Replace this line with the following if you want to protect against wrapping uints.
49         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
51             balances[_to] += _value;
52             balances[_from] -= _value;
53             allowed[_from][msg.sender] -= _value;
54             Transfer(_from, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function balanceOf(address _owner) constant returns (uint256 balance) {
60         return balances[_owner];
61     }
62 
63     function approve(address _spender, uint256 _value) returns (bool success) {
64         allowed[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70       return allowed[_owner][_spender];
71     }
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75 }
76 
77 contract LKLZ is StandardToken {
78 
79     /* Public variables of the token */
80     /*
81     NOTE:
82     The following variables are OPTIONAL vanities. One does not have to include them.
83     They allow one to customise the token contract & in no way influences the core functionality.
84     Some wallets/interfaces might not even bother to look at this information.
85     */
86     string public name;                   //fancy name: eg Simon Bucks
87     uint8 public decimals;                //How many decimals to show. ie. 
88     string public symbol;                 //An identifier: eg SBX
89     function LKLZ() {
90         balances[msg.sender] = 510000000000000000;               // Give the creator all initial tokens
91         totalSupply = 510000000000000000;                        // Update total supply
92         name = "LKLZ";                                   // Set the name for display purposes
93         decimals = 8;                            // Amount of decimals for display purposes
94         symbol = "LKLZ";                               // Set the symbol for display purposes
95     }
96 }