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
30 	uint256 public totalSupply;
31 	string public name;
32 	uint256 public decimals;
33 	string public symbol;
34 	address public owner;
35 
36 	mapping (address => uint256) balances;
37 	mapping (address => mapping (address => uint256)) allowed;
38 
39   function ERC20Standard(uint256 _totalSupply, string _symbol, string _name) public {
40 		decimals = 18;
41 		symbol = _symbol;
42 		name = _name;
43 		owner = msg.sender;
44         totalSupply = _totalSupply * (10 ** decimals);
45         balances[msg.sender] = totalSupply;
46   }
47 	//Fix for short address attack against ERC20
48 	modifier onlyPayloadSize(uint size) {
49 		assert(msg.data.length == size + 4);
50 		_;
51 	} 
52 
53 	function balanceOf(address _owner) constant public returns (uint256) {
54 		return balances[_owner];
55 	}
56 
57 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
58 		require(balances[msg.sender] >= _value && _value > 0);
59 	    balances[msg.sender] -= _value;
60 	    balances[_recipient] += _value;
61 	    Transfer(msg.sender, _recipient, _value);        
62     }
63 
64 	function transferFrom(address _from, address _to, uint256 _value) public {
65 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70     }
71 
72 	function approve(address _spender, uint256 _value) public {
73 		allowed[msg.sender][_spender] = _value;
74 		Approval(msg.sender, _spender, _value);
75 	}
76 
77 	function allowance(address _owner, address _spender) constant public returns (uint256) {
78 		return allowed[_owner][_spender];
79 	}
80 
81 	//Event which is triggered to log all transfers to this contract's event log
82 	event Transfer(
83 		address indexed _from,
84 		address indexed _to,
85 		uint256 _value
86 		);
87 		
88 	//Event which is triggered whenever an owner approves a new allowance for a spender.
89 	event Approval(
90 		address indexed _owner,
91 		address indexed _spender,
92 		uint256 _value
93 		);
94 
95 }