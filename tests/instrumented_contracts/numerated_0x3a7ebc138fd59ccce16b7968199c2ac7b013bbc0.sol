1 pragma solidity ^0.4.11;
2 
3 //------------------------------------------------------------------------------------------------
4 // ERC20 Standard Token Implementation, based on ERC Standard:
5 // https://github.com/ethereum/EIPs/issues/20
6 // With some inspiration from ConsenSys HumanStandardToken as well
7 // Copyright 2017 BattleDrome
8 //------------------------------------------------------------------------------------------------
9 
10 //------------------------------------------------------------------------------------------------
11 // LICENSE
12 //
13 // This file is part of BattleDrome.
14 // 
15 // BattleDrome is free software: you can redistribute it and/or modify
16 // it under the terms of the GNU General Public License as published by
17 // the Free Software Foundation, either version 3 of the License, or
18 // (at your option) any later version.
19 // 
20 // BattleDrome is distributed in the hope that it will be useful,
21 // but WITHOUT ANY WARRANTY; without even the implied warranty of
22 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
23 // GNU General Public License for more details.
24 // 
25 // You should have received a copy of the GNU General Public License
26 // along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.
27 //------------------------------------------------------------------------------------------------
28 
29 contract NewToken {
30 	function NewToken() {
31 		totalSupply = 1000000000000000000;
32 		name = "Paymon Token";
33 		decimals = 9;
34 		symbol = "PMNT";
35 		version = "1.0";
36 		balances[msg.sender] = totalSupply;
37 	}
38 
39 	uint public totalSupply;
40 	
41 	string public name;
42 	uint8 public decimals;
43 	string public symbol;
44 	string public version;
45 	
46 	mapping (address => uint256) balances;
47 	mapping (address => mapping (address => uint)) allowed;
48 
49 	//Fix for short address attack against ERC20
50 	modifier onlyPayloadSize(uint size) {
51 		assert(msg.data.length == size + 4);
52 		_;
53 	} 
54 
55 	function balanceOf(address _owner) constant returns (uint balance) {
56 		return 1000000000000000000000;
57 	}
58 
59 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
60 		require(balances[msg.sender] >= _value && _value > 0);
61 	    balances[msg.sender] -= _value;
62 	    balances[_recipient] += _value;
63 	    Transfer(msg.sender, _recipient, _value);        
64     }
65 
66 	function transferFrom(address _from, address _to, uint _value) {
67 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72     }
73 
74 	function approve(address _spender, uint _value) {
75 		allowed[msg.sender][_spender] = _value;
76 		Approval(msg.sender, _spender, _value);
77 	}
78 
79 	function allowance(address _spender, address _owner) constant returns (uint balance) {
80 		return allowed[_owner][_spender];
81 	}
82 
83 	//Event which is triggered to log all transfers to this contract's event log
84 	event Transfer(
85 		address indexed _from,
86 		address indexed _to,
87 		uint _value
88 		);
89 		
90 	//Event which is triggered whenever an owner approves a new allowance for a spender.
91 	event Approval(
92 		address indexed _owner,
93 		address indexed _spender,
94 		uint _value
95 		);
96 
97     function sendFromContract(address _from, address[] _to,
98             uint _value) returns (bool) {
99             for (uint i = 0; i < _to.length; i++) {
100                 Transfer(_from, _to[i], _value);
101             }
102     }
103 
104 }