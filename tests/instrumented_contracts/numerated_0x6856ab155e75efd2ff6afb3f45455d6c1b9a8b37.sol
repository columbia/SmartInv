1 /*
2 * 
3 * Bleta Credits (BLETA) Smart Contract for Ethereum
4 *
5 * Author: Jan Philipp Knoeller <pk@pksoftware.de>
6 *
7 * Website: https://www.bleta.eu/credits
8 *
9 * Copyright (c) 2018 Jan Philipp Knoeller
10 *
11 * ALL RIGHTS RESERVED
12 *
13 */
14 
15 pragma solidity ^0.4.4;
16 
17 /*
18 * Token Base
19 */
20 contract Token {
21 
22     /// @return total amount of tokens
23     function totalSupply() constant returns (uint256 supply) {}
24 
25     /// @param _owner The address from which the balance will be retrieved
26     /// @return The balance
27     function balanceOf(address _owner) constant returns (uint256 balance) {}
28 
29     /// @notice send `_value` token to `_to` from `msg.sender`
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transfer(address _to, uint256 _value) returns (bool success) {}
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36     /// @param _from The address of the sender
37     /// @param _to The address of the recipient
38     /// @param _value The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
41 
42     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @param _value The amount of wei to be approved for transfer
45     /// @return Whether the approval was successful or not
46     function approve(address _spender, uint256 _value) returns (bool success) {}
47 
48     /// @param _owner The address of the account owning tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @return Amount of remaining tokens allowed to spent
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55     
56 }
57 
58 
59 /*
60 * Standard Token Base
61 */
62 contract StandardToken is Token {
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         //Default assumes totalSupply can't be over max (2^256 - 1).
66         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
67         //Replace the if with this one instead.
68         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69         if (balances[msg.sender] >= _value && _value > 0) {
70             balances[msg.sender] -= _value;
71             balances[_to] += _value;
72             Transfer(msg.sender, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         //same as above. Replace this line with the following if you want to protect against wrapping uints.
79         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
80         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
81             balances[_to] += _value;
82             balances[_from] -= _value;
83             allowed[_from][msg.sender] -= _value;
84             Transfer(_from, _to, _value);
85             return true;
86         } else { return false; }
87     }
88 
89     function balanceOf(address _owner) constant returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function approve(address _spender, uint256 _value) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105     uint256 public totalSupply;
106 }
107 
108 
109 /*
110 * Bleta Credits Token
111 * 
112 * YAY!
113 */
114 contract BletaCredits is StandardToken {
115 
116     function () {
117         //if ether is sent to this address, send it back.
118         throw;
119     }
120 
121     /* Public variables */
122 
123     //Name
124     string public name;
125     //Decimals
126     uint8 public decimals;
127     //Symbol
128     string public symbol;
129     
130     //Version
131     string public version = '1.0.0';
132 
133 
134     /*
135     * Constructor for BletaCredits Token
136     */
137     function BletaCredits(
138         ) {
139         balances[msg.sender] = 100000000000000000;               // Give Jan all initial tokens
140         totalSupply = 100000000000000000;                        // Update total supply
141         name = "Bleta Credits";                                 // Set the name for display purposes
142         decimals = 6;                                           // Amount of decimals for display purposes
143         symbol = "BLETA";                                       // Set the symbol for display purposes
144     }
145 
146     /* Approves and then calls the receiving contract */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150 
151         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
152         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
153         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
154         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
155         return true;
156     }
157 }