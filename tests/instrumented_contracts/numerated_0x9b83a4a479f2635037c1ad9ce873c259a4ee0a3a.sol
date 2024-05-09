1 pragma solidity ^0.5.1;
2 //区块链技术服务+手机号/微信：19933104907
3 
4 contract ERC20Standard {
5     using SafeMath for uint256;
6 	uint256 public totalSupply;
7 	string public name;
8 	uint8 public decimals;
9 	string public symbol;
10 	address public owner;
11 
12 	mapping (address => uint256) balances;
13 	mapping (address => mapping (address => uint256)) allowed;
14 
15 	//Event which is triggered to log all transfers to this contract's event log
16 	event Transfer(
17 		address indexed _from,
18 		address indexed _to,
19 		uint256 _value
20 		);
21 		
22 	//Event which is triggered whenever an owner approves a new allowance for a spender.
23 	event Approval(
24 		address indexed _owner,
25 		address indexed _spender,
26 		uint256 _value
27 		);
28 		
29    constructor(uint256 _totalSupply, string memory _symbol, string memory _name, uint8 _decimals) public {
30 		symbol = _symbol;
31 		name = _name;
32         decimals = _decimals;
33 		owner = msg.sender;
34         totalSupply = SafeMath.mul(_totalSupply ,(10 ** uint256(decimals)));
35         balances[owner] = totalSupply;
36   }
37 
38 	function balanceOf(address _owner) view public returns (uint256) {
39 		return balances[_owner];
40 	}
41 
42 	function transfer(address _recipient, uint256 _value)public returns(bool){
43 	    require(_recipient!=address(0));
44 		require(balances[msg.sender] >= _value && _value >= 0);
45 	    require(balances[_recipient].add(_value)>= balances[_recipient]);
46 	    balances[msg.sender] = balances[msg.sender].sub(_value) ;
47 	    balances[_recipient] = balances[_recipient].add(_value) ;
48 	    emit Transfer(msg.sender, _recipient, _value);  
49 	    return true;
50     }
51 
52 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
53 	    require(_to!=address(0));
54 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
55 		require(balances[_to].add(_value) >= balances[_to]);
56         balances[_to] = balances[_to].add(_value);
57         balances[_from] = balances[_from].sub(_value) ;
58         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value) ;
59         emit Transfer(_from, _to, _value);
60         return true;
61     }
62 
63 	function approve(address _spender, uint256 _value) public returns(bool){
64 	    require((_value==0)||(allowed[msg.sender][_spender]==0));
65     	allowed[msg.sender][_spender] = _value;
66 		emit Approval(msg.sender, _spender, _value);
67 		return true;
68 	}
69 
70 	function allowance(address _owner, address _spender) view public returns (uint256) {
71 		return allowed[_owner][_spender];
72 	}
73 
74 
75 }
76 library SafeMath {
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {if (a == 0) {return 0;} uint256 c = a * b; assert(c / a == b); return c;}
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a / b; return c;}
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; assert(c >= a); return c;}
81 }