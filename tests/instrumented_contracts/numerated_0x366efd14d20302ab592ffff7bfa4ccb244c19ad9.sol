1 pragma solidity ^0.4.20;
2 
3 contract LCoin {
4     mapping (address => uint256) public balanceOf;
5 	mapping (address => mapping (address => uint256)) allowed;
6 
7 	uint256 public totalSupply;
8 	string public name;
9 	string public symbol;
10 	uint8 public decimals;
11 	
12     constructor(uint _totalSupply,string tokenName,string tokenSymbol,uint8 decimalUnits) public{
13 		balanceOf[msg.sender] = _totalSupply; 
14 		totalSupply = _totalSupply;
15 		name = tokenName;		
16 		symbol = tokenSymbol;		
17 		decimals = decimalUnits;	
18 	}
19 	function transfer(address _to, uint256 _value) public returns (bool success){
20 		require(balanceOf[msg.sender]>=_value);			
21 		require(balanceOf[_to] + _value >= balanceOf[_to]);	
22 		balanceOf[msg.sender] -= _value;
23 		balanceOf[_to] += _value;
24 		return true;
25 	}
26 	
27 	
28 	function transferFrom(address _from,address _to,uint _value) public 
29 	returns (bool success){
30 		require(balanceOf[_from]>= _value);
31 		require(allowed[_from][msg.sender]>=_value);
32 		require(_value>0);
33 		balanceOf[_to] += _value;
34         balanceOf[_from] -= _value;
35         allowed[_from][msg.sender] -= _value;
36         emit Transfer(_from, _to, _value);
37         return true;
38 	}
39 	
40 	
41 	function approve(address _spender,uint _value) public returns (bool success){
42 		allowed[msg.sender][_spender] = _value;
43 	        emit Approval(msg.sender, _spender, _value);
44 		return true;
45 	}
46 	
47 	event Transfer(address indexed _from,address indexed _to,uint _value);
48 	
49 	event Approval(address indexed _owner, address indexed _spender, uint _value);
50 }