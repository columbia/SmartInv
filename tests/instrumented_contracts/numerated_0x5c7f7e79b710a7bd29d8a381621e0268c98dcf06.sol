1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, April 19, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.11;
6 
7 //------------------------------------------------------------------------------------------------
8 // ERC20 Standard Token Implementation, based on ERC Standard:
9 // https://github.com/ethereum/EIPs/issues/20
10 // With some inspiration from ConsenSys HumanStandardToken as well
11 // Copyright 2017 BattleDrome
12 //------------------------------------------------------------------------------------------------
13 
14 //------------------------------------------------------------------------------------------------
15 // LICENSE
16 //
17 // This file is part of BattleDrome.
18 // 
19 // BattleDrome is free software: you can redistribute it and/or modify
20 // it under the terms of the GNU General Public License as published by
21 // the Free Software Foundation, either version 3 of the License, or
22 // (at your option) any later version.
23 // 
24 // BattleDrome is distributed in the hope that it will be useful,
25 // but WITHOUT ANY WARRANTY; without even the implied warranty of
26 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
27 // GNU General Public License for more details.
28 // 
29 // You should have received a copy of the GNU General Public License
30 // along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.
31 //------------------------------------------------------------------------------------------------
32 
33 contract ERC20Standard {
34 	uint256 public totalSupply;
35 	bool public mintable;
36 	string public name;
37 	uint256 public decimals;
38 	string public symbol;
39 	address public owner;
40 
41 	mapping (address => uint256) balances;
42 	mapping (address => mapping (address => uint256)) allowed;
43 
44   function ERC20Standard(uint256 _totalSupply, string _symbol, string _name, bool _mintable) public {
45 		decimals = 18;
46 		symbol = _symbol;
47 		name = _name;
48 		mintable = _mintable;
49 		owner = msg.sender;
50         totalSupply = _totalSupply * (10 ** decimals);
51         balances[msg.sender] = totalSupply;
52   }
53 	//Fix for short address attack against ERC20
54 	modifier onlyPayloadSize(uint size) {
55 		assert(msg.data.length == size + 4);
56 		_;
57 	} 
58 
59 	function balanceOf(address _owner) constant public returns (uint256) {
60 		return balances[_owner];
61 	}
62 
63 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
64 		require(balances[msg.sender] >= _value && _value > 0);
65 	    balances[msg.sender] -= _value;
66 	    balances[_recipient] += _value;
67 	    Transfer(msg.sender, _recipient, _value);        
68     }
69 
70 	function transferFrom(address _from, address _to, uint256 _value) public {
71 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
72         balances[_to] += _value;
73         balances[_from] -= _value;
74         allowed[_from][msg.sender] -= _value;
75         Transfer(_from, _to, _value);
76     }
77 
78 	function approve(address _spender, uint256 _value) public {
79 		allowed[msg.sender][_spender] = _value;
80 		Approval(msg.sender, _spender, _value);
81 	}
82 
83 	function allowance(address _owner, address _spender) constant public returns (uint256) {
84 		return allowed[_owner][_spender];
85 	}
86 
87 	function mint(uint256 amount) public {
88 		assert(amount >= 0);
89 		require(msg.sender == owner);
90 		balances[msg.sender] += amount;
91 		totalSupply += amount;
92 	}
93 
94 	//Event which is triggered to log all transfers to this contract's event log
95 	event Transfer(
96 		address indexed _from,
97 		address indexed _to,
98 		uint256 _value
99 		);
100 		
101 	//Event which is triggered whenever an owner approves a new allowance for a spender.
102 	event Approval(
103 		address indexed _owner,
104 		address indexed _spender,
105 		uint256 _value
106 		);
107 
108 }