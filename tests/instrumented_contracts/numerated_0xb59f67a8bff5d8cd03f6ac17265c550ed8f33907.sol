1 //! FrozenToken ECR20-compliant token contract
2 //! By Parity Technologies, 2017.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.17;
6 
7 // Owned contract.
8 contract Owned {
9 	modifier only_owner { require (msg.sender == owner); _; }
10 
11 	event NewOwner(address indexed old, address indexed current);
12 
13 	function setOwner(address _new) public only_owner { NewOwner(owner, _new); owner = _new; }
14 
15 	address public owner;
16 }
17 
18 // FrozenToken, a bit like an ECR20 token (though not - as it doesn't
19 // implement most of the API).
20 // All token balances are generally non-transferable.
21 // All "tokens" belong to the owner (who is uniquely liquid) at construction.
22 // Liquid accounts can make other accounts liquid and send their tokens
23 // to other axccounts.
24 contract FrozenToken is Owned {
25 	event Transfer(address indexed from, address indexed to, uint256 value);
26 
27 	// this is as basic as can be, only the associated balance & allowances
28 	struct Account {
29 		uint balance;
30 		bool liquid;
31 	}
32 
33 	// constructor sets the parameters of execution, _totalSupply is all units
34 	function FrozenToken(uint _totalSupply, address _owner)
35         public
36 		when_non_zero(_totalSupply)
37 	{
38 		totalSupply = _totalSupply;
39 		owner = _owner;
40 		accounts[_owner].balance = totalSupply;
41 		accounts[_owner].liquid = true;
42 	}
43 
44 	// balance of a specific address
45 	function balanceOf(address _who) public constant returns (uint256) {
46 		return accounts[_who].balance;
47 	}
48 
49 	// make an account liquid: only liquid accounts can do this.
50 	function makeLiquid(address _to)
51 		public
52 		when_liquid(msg.sender)
53 		returns(bool)
54 	{
55 		accounts[_to].liquid = true;
56 		return true;
57 	}
58 
59 	// transfer
60 	function transfer(address _to, uint256 _value)
61 		public
62 		when_owns(msg.sender, _value)
63 		when_liquid(msg.sender)
64 		returns(bool)
65 	{
66 		Transfer(msg.sender, _to, _value);
67 		accounts[msg.sender].balance -= _value;
68 		accounts[_to].balance += _value;
69 
70 		return true;
71 	}
72 
73 	// no default function, simple contract only, entry-level users
74 	function() public {
75 		assert(false);
76 	}
77 
78 	// the balance should be available
79 	modifier when_owns(address _owner, uint _amount) {
80 		require (accounts[_owner].balance >= _amount);
81 		_;
82 	}
83 
84 	modifier when_liquid(address who) {
85 		require (accounts[who].liquid);
86 		_;
87 	}
88 
89 	// a value should be > 0
90 	modifier when_non_zero(uint _value) {
91 		require (_value > 0);
92 		_;
93 	}
94 
95 	// Available token supply
96 	uint public totalSupply;
97 
98 	// Storage and mapping of all balances & allowances
99 	mapping (address => Account) accounts;
100 
101 	// Conventional metadata.
102 	string public constant name = "DOT Allocation Indicator";
103 	string public constant symbol = "DOT";
104 	uint8 public constant decimals = 3;
105 }