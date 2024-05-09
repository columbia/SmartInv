1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4 
5 	function totalSupply() public view returns (uint256);
6 	function balanceOf(address who) public view returns (uint256);
7 	function transfer(address to, uint256 value) public returns (bool);
8 	function transferFrom(address from, address to, uint value)public returns (bool);
9 	function allowance(address owner, address spender)public view returns (uint);
10 	function approve(address spender, uint value)public returns (bool ok);
11 	event Transfer(address indexed from, address indexed to, uint256 value);
12 	event Approval(address indexed owner, address indexed spender, uint value);
13 
14 }
15 
16 contract BitronCoin is ERC20Basic {
17 
18 	string	public name			= "Bitron Coin";
19 	string	public symbol		= "BTO";
20 	uint 	public decimals		= 9;
21 	uint 	public _totalSupply = 50000000 * 10 ** decimals;
22 	uint 	public tokens		= 0;
23 	uint 	public oneEth		= 10000;
24 	uint 	public icoEndDate	= 1535673600;
25 	address public owner		= msg.sender;
26 	bool	public stopped		= false;
27 	address public ethFundMain  = 0x1e6d1Fc2d934D2E4e2aE5e4882409C3fECD769dF;
28 
29 	mapping (address => uint) balance;
30 	mapping(address => mapping(address => uint)) allowed;
31 
32 	modifier onlyOwner() {
33 		if(msg.sender != owner){
34 			revert();
35 		}
36 		_;
37 	}
38 
39 	constructor() public {
40 
41 		balance[owner] = _totalSupply;
42 		emit Transfer(0x0, owner, _totalSupply);
43 
44 	}
45 
46 	function() payable public {
47 
48 		if( msg.sender != owner && msg.value >= 0.02 ether && now <= icoEndDate && stopped == false ){
49 
50 			tokens				 = ( msg.value / 10 ** decimals ) * oneEth;
51 			balance[msg.sender] += tokens;
52 			balance[owner]		-= tokens;
53 
54 			emit Transfer(owner, msg.sender, tokens);
55 
56 		} else {
57 			revert();
58 		}
59 
60 	}
61 
62 	function totalSupply() public view returns (uint) {
63 		return _totalSupply;
64 	}
65 
66 	function balanceOf(address who) public view returns (uint) {
67 		return balance[who];
68 	}
69 
70 	function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
71 		require( _to != 0x0);
72 		tokens = _amount * 10 ** decimals;
73 		require(balance[_from] >= tokens && allowed[_from][msg.sender] >= tokens && tokens >= 0);
74 		balance[_from] -= tokens;
75 		allowed[_from][msg.sender] -= tokens;
76 		balance[_to] += tokens;
77 		emit Transfer(_from, _to, tokens);
78 		return true;
79 	}
80 
81 	function transfer(address to, uint256 value) public returns (bool) {
82 
83 		tokens			= value * 10 ** decimals;
84 		balance[to]		= balance[to] + tokens;
85 		balance[owner]	= balance[owner] - tokens;
86 
87 		emit Transfer(owner, to, tokens);
88 
89 	}
90 
91 	function approve(address _spender, uint256 _amount)public returns (bool success) {
92 		require( _spender != 0x0);
93 		tokens = _amount * 10 ** decimals;
94 		allowed[msg.sender][_spender] = tokens;
95 		emit Approval(msg.sender, _spender, tokens);
96 		return true;
97 	}
98 
99 	function allowance(address _owner, address _spender)public view returns (uint256) {
100 		require( _owner != 0x0 && _spender !=0x0);
101 		return allowed[_owner][_spender];
102 	}
103 
104 	function drain() external onlyOwner {
105 		ethFundMain.transfer(address(this).balance);
106 	}
107 
108 	function PauseICO() external onlyOwner
109 	{
110 		stopped = true;
111 	}
112 
113 	function ResumeICO() external onlyOwner
114 	{
115 		stopped = false;
116 	}
117 	
118 	function sendTokens(address[] a, uint[] v) public 
119 	{
120 	    uint i = 0;
121 	    while( i < a.length ){
122 	        transfer(a[i], v[i]);
123 	        i++;
124 	    }
125 	}
126 
127 }