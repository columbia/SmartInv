1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal returns(uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8     }
9     
10     function div(uint256 a, uint256 b) internal returns(uint256) {
11 		uint256 c = a / b;
12 		return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal returns(uint256) {
16 		assert(b <= a);
17 		return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal returns(uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a && c >= b);
23 		return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner {
40         require(newOwner != address(0));
41         owner = newOwner;
42     }
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) constant returns (uint256);
48     function transfer(address to, uint256 value) returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) returns (bool);
55     function approve(address spender, uint256 value) returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Fosha is ERC20, Ownable {
60    
61     using SafeMath for uint256;
62 	
63     string constant public symbol = "FOSHA";
64     string constant public name = "Fosha";
65     uint8 constant public decimals = 18;
66 
67 	uint public totalSupply;
68 	uint public tokensForIco;
69 	uint256 public startTransferTime;
70 	uint256 public tokensSold;
71 	uint256 public start;
72 	uint256 public end;
73 	uint256 public tokenExchangeRate;
74 	uint256 public amountRaised;
75     bool public crowdsaleClosed = false;
76 	
77     address public fundWallet;
78     address ethFundWallet;
79 	
80 	mapping(address => uint256) balances;
81     mapping(address => mapping (address => uint256)) allowed;
82 	
83 	event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
84 
85 	function Fosha(uint256 _total, uint256 _icototal, uint256 _start, uint256 _end, uint256 _exchange) {
86 		totalSupply = _total * 1 ether;
87 		tokensForIco = _icototal * 1 ether;
88 		start = _start;
89 		end = _end;
90 		tokenExchangeRate = _exchange;
91 		ethFundWallet = msg.sender;
92 		fundWallet = msg.sender;
93 		balances[fundWallet] = totalSupply;
94 		startTransferTime = end;
95     }
96 
97     function() payable {
98 		uint256 amount = msg.value;
99 		uint256 numTokens = amount.mul(tokenExchangeRate); 
100 		require(!crowdsaleClosed && now >= start && now <= end && tokensSold.add(numTokens) <= tokensForIco && amount <= 5 ether);
101 		ethFundWallet.transfer(amount);
102 		balances[fundWallet] = balances[fundWallet].sub(numTokens); 
103 		balances[msg.sender] = balances[msg.sender].add(numTokens);
104 		Transfer(fundWallet, msg.sender, numTokens);
105 		amountRaised = amountRaised.add(amount);
106 		tokensSold += numTokens;
107 		FundTransfer(msg.sender, amount, true, amountRaised);
108     }
109 
110     function transfer(address _to, uint256 _value) returns(bool success) {
111 		require(now >= startTransferTime); 
112 		balances[msg.sender] = balances[msg.sender].sub(_value); 
113 		balances[_to] = balances[_to].add(_value); 
114 		Transfer(msg.sender, _to, _value); 
115 		return true;
116     }
117 	
118 	function balanceOf(address _owner) constant returns (uint256 balance) {
119         return balances[_owner];
120     }
121 	
122     function approve(address _spender, uint256 _value) returns(bool success) {
123 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
124 		allowed[msg.sender][_spender] = _value;
125 		Approval(msg.sender, _spender, _value);
126 		return true;
127     }
128 
129 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 	
133     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
134 		if (now < startTransferTime) {
135 		    require(_from == fundWallet);
136 		}
137 		var _allowance = allowed[_from][msg.sender];
138 		require(_value <= _allowance);
139 		balances[_from] = balances[_from].sub(_value); 
140 		balances[_to] = balances[_to].add(_value); 
141 		allowed[_from][msg.sender] = _allowance.sub(_value);
142 		Transfer(_from, _to, _value);
143 		return true;
144     }
145 
146     function markCrowdsaleEnding() {
147 		require(now > end);
148 		crowdsaleClosed = true;
149     }
150 }