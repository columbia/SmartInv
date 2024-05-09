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
31 	bool public mintable;
32 	string public name;
33 	uint256 public decimals;
34 	string public symbol;
35 	address public owner;
36 
37 	mapping (address => uint256) balances;
38 	mapping (address => mapping (address => uint256)) allowed;
39 
40   function ERC20Standard(uint256 _totalSupply, string _symbol, bool _mintable) public {
41 		decimals = 18;
42 		symbol = _symbol;
43 		mintable = _mintable;
44 		owner = msg.sender;
45 
46     totalSupply = _totalSupply * (10 ** decimals);
47     balances[msg.sender] = totalSupply;
48   }
49 	//Fix for short address attack against ERC20
50 	modifier onlyPayloadSize(uint size) {
51 		assert(msg.data.length == size + 4);
52 		_;
53 	} 
54 
55 	function balanceOf(address _owner) constant public returns (uint256) {
56 		return balances[_owner];
57 	}
58 
59 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
60 		require(balances[msg.sender] >= _value && _value > 0);
61 	    balances[msg.sender] -= _value;
62 	    balances[_recipient] += _value;
63 	    Transfer(msg.sender, _recipient, _value);        
64     }
65 
66 	function transferFrom(address _from, address _to, uint256 _value) public {
67 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72     }
73 
74 	function approve(address _spender, uint256 _value) public {
75 		allowed[msg.sender][_spender] = _value;
76 		Approval(msg.sender, _spender, _value);
77 	}
78 
79 	function allowance(address _owner, address _spender) constant public returns (uint256) {
80 		return allowed[_owner][_spender];
81 	}
82 
83 	function mint(uint256 amount) public {
84 		assert(amount >= 0);
85 		require(msg.sender == owner);
86 		balances[msg.sender] += amount;
87 		totalSupply += amount;
88 	}
89 
90 	//Event which is triggered to log all transfers to this contract's event log
91 	event Transfer(
92 		address indexed _from,
93 		address indexed _to,
94 		uint256 _value
95 		);
96 		
97 	//Event which is triggered whenever an owner approves a new allowance for a spender.
98 	event Approval(
99 		address indexed _owner,
100 		address indexed _spender,
101 		uint256 _value
102 		);
103 
104 }