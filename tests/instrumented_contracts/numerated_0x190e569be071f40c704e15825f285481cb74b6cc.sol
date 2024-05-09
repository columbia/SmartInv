1 pragma solidity ^0.4.11;
2 
3 //------------------------------------------------------------------------------------------------
4 // ERC20 Standard Token Implementation, based on ERC Standard:
5 // https://github.com/ethereum/EIPs/issues/20
6 // With some inspiration from ConsenSys HumanStandardToken as well
7 // Copyright 2017 BattleDrome
8 //------------------------------------------------------------------------------------------------
9 
10 contract ERC20Standard {
11 	uint public totalSupply;
12 	
13 	string public name;
14 	uint8 public decimals;
15 	string public symbol;
16 	string public version;
17 	
18 	mapping (address => uint256) balances;
19 	mapping (address => mapping (address => uint)) allowed;
20 
21 	//Fix for short address attack against ERC20
22 	modifier onlyPayloadSize(uint size) {
23 		assert(msg.data.length == size + 4);
24 		_;
25 	} 
26 
27 	function balanceOf(address _owner) constant returns (uint balance) {
28 		return balances[_owner];
29 	}
30 
31 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
32 		require(balances[msg.sender] >= _value && _value > 0);
33 	    balances[msg.sender] -= _value;
34 	    balances[_recipient] += _value;
35 	    Transfer(msg.sender, _recipient, _value);        
36     }
37 
38 	function transferFrom(address _from, address _to, uint _value) {
39 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
40         balances[_to] += _value;
41         balances[_from] -= _value;
42         allowed[_from][msg.sender] -= _value;
43         Transfer(_from, _to, _value);
44     }
45 
46 	function approve(address _spender, uint _value) {
47 		allowed[msg.sender][_spender] = _value;
48 		Approval(msg.sender, _spender, _value);
49 	}
50 
51 	function allowance(address _spender, address _owner) constant returns (uint balance) {
52 		return allowed[_owner][_spender];
53 	}
54 
55 	//Event which is triggered to log all transfers to this contract's event log
56 	event Transfer(
57 		address indexed _from,
58 		address indexed _to,
59 		uint _value
60 		);
61 		
62 	//Event which is triggered whenever an owner approves a new allowance for a spender.
63 	event Approval(
64 		address indexed _owner,
65 		address indexed _spender,
66 		uint _value
67 		);
68 
69 }
70 
71 //------------------------------------------------------------------------------------------------
72 // FAME ERC20 Token, based on ERC20Standard interface
73 // Copyright 2017 BattleDrome
74 //------------------------------------------------------------------------------------------------
75 
76 //------------------------------------------------------------------------------------------------
77 // LICENSE
78 //
79 // This file is part of BattleDrome.
80 // 
81 // BattleDrome is free software: you can redistribute it and/or modify
82 // it under the terms of the GNU General Public License as published by
83 // the Free Software Foundation, either version 3 of the License, or
84 // (at your option) any later version.
85 // 
86 // BattleDrome is distributed in the hope that it will be useful,
87 // but WITHOUT ANY WARRANTY; without even the implied warranty of
88 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
89 // GNU General Public License for more details.
90 // 
91 // You should have received a copy of the GNU General Public License
92 // along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.
93 //------------------------------------------------------------------------------------------------
94 
95 contract FAMEToken is ERC20Standard {
96 
97 	function FAMEToken() {
98 		totalSupply = 2100000 szabo;			//Total Supply (including all decimal places!)
99 		name = "Fame";							//Pretty Name
100 		decimals = 12;							//Decimal places (with 12 decimal places 1 szabo = 1 token in uint256)
101 		symbol = "FAM";							//Ticker Symbol (3 characters, upper case)
102 		version = "FAME1.0";					//Version Code
103 		balances[msg.sender] = totalSupply;		//Assign all balance to creator initially for distribution from there.
104 	}
105 
106 	//Burn _value of tokens from your balance.
107 	//Will destroy the tokens, removing them from your balance, and reduce totalSupply accordingly.
108 	function burn(uint _value) {
109 		require(balances[msg.sender] >= _value && _value > 0);
110         balances[msg.sender] -= _value;
111         totalSupply -= _value;
112         Burn(msg.sender, _value);
113 	}
114 
115 	//Event to log any time someone burns tokens to the contract's event log:
116 	event Burn(
117 		address indexed _owner,
118 		uint _value
119 		);
120 
121 }