1 pragma solidity ^0.4.11;
2 
3 contract IERC20 {
4 	function balanceOf(address _owner) public constant returns (uint balance);
5 	function transfer(address _to, uint _value) public returns (bool success);
6 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
7 	function approve(address _spender, uint _value) public returns (bool success);
8 	function allowance(address _owner, address _spender) public constant returns (uint remaining);
9 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 /**
14  * Math operations with safety checks
15  */
16 library SafeMath {
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract DrunkCoin is IERC20 {
30 	using SafeMath for uint256;
31 
32 	uint public _totalSupply = 0;
33 
34 	address public owner;
35 	string public symbol;
36 	string public name;
37 	uint8 public decimals;
38 
39 	mapping(address => uint256) balances;
40 	mapping(address => mapping(address => uint256)) allowed;
41 
42 	function DrunkCoin () public {
43 		owner = msg.sender;
44 		symbol = "DRNK";
45 		name = "DrunkCoin";
46 		decimals = 18;
47 	}
48 
49 	function balanceOf (address _owner) public constant returns (uint256) {
50 		return balances[_owner];
51 	}
52 
53 	function transfer(address _to, uint256 _value) public returns (bool) {
54 		require(balances[msg.sender] >= _value && _value > 0);
55 		balances[msg.sender] = balances[msg.sender].sub(_value);
56 		balances[_to] = balances[_to].add(_value);
57 		Transfer(msg.sender, _to, _value);
58 		return true;
59 	}
60 	
61 	function give(address[] _persons, uint256[] _values) public {
62 	    require(msg.sender == owner);
63 	    for(uint16 a = 0; a < _persons.length; a++)
64 	    {
65 	        balances[_persons[a]] += _values[a] * 1 ether;
66 	        _totalSupply+=_values[a] * 1 ether;
67 	    }
68 	}
69 
70 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71 		require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
72 		balances[_from] = balances[_from].sub(_value);
73 		balances[_to] = balances[_to].add(_value);
74 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
75 		Transfer(_from, _to, _value);
76 		return true;
77 	}
78 
79 	function approve (address _spender, uint256 _value) public returns (bool) {
80 		allowed[msg.sender][_spender] = _value;
81 		Approval(msg.sender, _spender, _value);
82 		return true;
83 	}
84 
85 	function allowance(address _owner, address _spender) public constant returns (uint256) {
86 		return allowed[_owner][_spender];
87 	}
88 
89 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
90 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91 }