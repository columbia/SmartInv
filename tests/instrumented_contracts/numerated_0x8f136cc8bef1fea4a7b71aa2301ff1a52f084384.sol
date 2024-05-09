1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4       function totalSupply() constant returns (uint256 total);
5 
6       function balanceOf(address _owner) constant returns (uint256 balance);
7 
8       function transfer(address _to, uint256 _value) returns (bool success);
9 
10       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11 
12       function approve(address _spender, uint256 _value) returns (bool success);
13 
14       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15 
16       event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 
18       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract StcToken is ERC20Interface {
22 	string public constant symbol = "STC";
23 	string public constant name = "StarChainToken";
24 	uint8 public constant decimals = 8;
25 	uint256 _totalSupply = 1000000000*100000000;
26 	mapping(address => uint256) balances;
27 	mapping(address => mapping (address => uint256)) allowed;
28 
29 	function StcToken(){
30 		balances[msg.sender] = _totalSupply;
31 	}
32 
33 	function totalSupply() public constant returns (uint256 total){
34 		total = _totalSupply;
35 	}
36 
37 	function balanceOf(address _owner) public constant returns(uint256 balance){
38 		return balances[_owner];
39 	}
40 
41 	function transfer(address _to,uint256 _amount) public returns (bool success){
42 		if(balances[msg.sender] >= _amount
43 			&& _amount >0
44 			&& (balances[_to]+_amount) > balances[_to]){
45 			balances[msg.sender] -= _amount;
46 			balances[_to] += _amount;
47 			Transfer(msg.sender,_to,_amount);
48 			return true;
49 		}else{
50 			return false;
51 		}
52 	}
53 
54 	function transferFrom(address _from,address _to,uint256 _amount) public returns(bool success){
55 		if(balances[_from] >= _amount
56 			&& _amount > 0
57 			&& (balances[_to]+_amount) > balances[_to]
58 			&& allowed[_from][msg.sender] >= _amount){
59 			balances[_from] -= _amount;
60 			balances[_to] += _amount;
61 			allowed[_from][msg.sender] -= _amount;
62 			Transfer(_from,_to,_amount);
63 			return true;
64 		}else{
65 			return false;
66 		}
67 	}
68 
69 	function approve(address _spender,uint256 _amount) public returns(bool success){
70 		allowed[msg.sender][_spender] = _amount;
71 		Approval(msg.sender,_spender,_amount);
72 		return true;
73 	}
74 
75 	function allowance(address _owner,address _spender) public constant returns(uint256 remaining){
76 		return allowed[_owner][_spender];
77 	}
78 
79 }