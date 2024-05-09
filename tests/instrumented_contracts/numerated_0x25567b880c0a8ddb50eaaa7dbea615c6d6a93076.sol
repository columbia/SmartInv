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
29 contract ERC20Standard {
30 	uint public totalSupply;
31 	
32 	string public name;
33 	uint8 public decimals;
34 	string public symbol;
35 	string public version;
36 	
37 	mapping (address => uint256) balances;
38 	mapping (address => mapping (address => uint)) allowed;
39 
40 	//Fix for short address attack against ERC20
41 	modifier onlyPayloadSize(uint size) {
42 		assert(msg.data.length == size + 4);
43 		_;
44 	} 
45 
46 	function balanceOf(address _owner) constant returns (uint balance) {
47 		return balances[_owner];
48 	}
49 
50 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
51 		require(balances[msg.sender] >= _value && _value > 0);
52 	    balances[msg.sender] -= _value;
53 	    balances[_recipient] += _value;
54 	    Transfer(msg.sender, _recipient, _value);        
55     }
56 
57 	function transferFrom(address _from, address _to, uint _value) {
58 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         allowed[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63     }
64 
65 	function approve(address _spender, uint _value) {
66 		allowed[msg.sender][_spender] = _value;
67 		Approval(msg.sender, _spender, _value);
68 	}
69 
70 	function allowance(address _spender, address _owner) constant returns (uint balance) {
71 		return allowed[_owner][_spender];
72 	}
73 
74 	//Event which is triggered to log all transfers to this contract's event log
75 	event Transfer(
76 		address indexed _from,
77 		address indexed _to,
78 		uint _value
79 		);
80 		
81 	//Event which is triggered whenever an owner approves a new allowance for a spender.
82 	event Approval(
83 		address indexed _owner,
84 		address indexed _spender,
85 		uint _value
86 		);
87 
88 }
89 
90 contract NewToken is ERC20Standard {
91 	function NewToken() {
92 		totalSupply = 1000000000000000;
93 		name = "Rebit Token";
94 		decimals = 4;
95 		symbol = "RET";
96 		version = "1.0";
97 		balances[msg.sender] = totalSupply;
98 	}
99 }