1 pragma solidity ^0.4.8;
2 
3 contract testingToken {
4 	mapping (address => uint256) public balanceOf;
5 	mapping (address => uint256) public weiWantedOf;
6 	mapping (address => uint256) public tokensOfferedOf;
7 	mapping (address => bool) public tradeActive;
8 	address public bank;
9 	uint256 public ethTaxRate = 10;
10 	uint256 public tokenTaxRate = 5;
11 	function testingToken() {
12 		bank = msg.sender;
13 		balanceOf[msg.sender] = 100000;
14 	}
15 	
16 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 	
18 	function totalSupply() constant returns (uint256 totalSupply) {
19 	    return 10000;
20 	}
21 	function balanceOf(address _owner) constant returns (uint256 balance) {
22 	    return balanceOf[_owner];
23 	}
24 	
25 	function transfer(address _to, uint256 _value) returns (bool success) { //give tokens to someone
26 		if (balanceOf[msg.sender]<_value) throw;
27 		if (balanceOf[_to]+_value<balanceOf[_to]) throw;
28 		if (_value<0) throw;
29 		balanceOf[msg.sender] -= _value;
30 		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
31 		balanceOf[bank] += (_value*tokenTaxRate)/100;
32 		//now check for rounding down which would result in permanent loss of coins
33 		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
34 		Transfer(msg.sender,_to,_value);
35 		return true;
36 	}
37 	
38 	mapping (address => mapping (address=>uint256)) approvalList;
39 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40 		if (balanceOf[_from]<_value) throw;
41 		if (balanceOf[_to]+_value<balanceOf[_to]) throw;
42 		if (_value<0) throw;
43 		if (approvalList[_from][msg.sender]<_value) throw;
44 		approvalList[_from][msg.sender]-=_value;
45 		balanceOf[_from] -= _value;
46 		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
47 		balanceOf[bank] += (_value*tokenTaxRate)/100;
48 		//now check for rounding down which would result in permanent loss of coins
49 		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
50 		Transfer(_from,_to,_value);
51 		return true;
52 	}
53 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 	function approve(address _spender, uint256 _value) returns (bool success) {
55 	    approvalList[msg.sender][_spender]=_value;
56 	    Approval(msg.sender,_spender,_value);
57 	    return true;
58 	}
59 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60 	    return approvalList[_owner][_spender];
61 	}
62 	
63 	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
64 	    weiWantedOf[msg.sender] = _weiWanted;
65 	    tokensOfferedOf[msg.sender] = _tokensOffered;
66 	    tradeActive[msg.sender] = true;
67 	}
68 	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
69 	    if (!tradeActive[_from]) throw;
70 	    if (weiWantedOf[_from]!=msg.value) throw;
71 	    if (balanceOf[_from]<tokensOfferedOf[_from]) throw;
72 	    if (!_from.send((msg.value*(100-ethTaxRate))/100)) throw;
73 	    balanceOf[_from] -= tokensOfferedOf[_from];
74 	    balanceOf[msg.sender] += (tokensOfferedOf[_from]*(100-tokenTaxRate))/100;
75 		balanceOf[bank] += (tokensOfferedOf[_from]*tokenTaxRate)/100;
76 		tradeActive[_from] = false;
77 		Transfer(_from,msg.sender,tokensOfferedOf[_from]);
78 		//now check for rounding down which would result in permanent loss of coins
79 		if ((tokensOfferedOf[_from]*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
80 	}
81 	
82 	modifier bankOnly {
83 		if (msg.sender != bank) throw;
84 		_;
85 	}
86 	
87 	function setTaxes(uint256 _ethTaxRate, uint256 _tokenTaxRate) bankOnly { //the bank can change the tax rates
88 		ethTaxRate = _ethTaxRate;
89 		tokenTaxRate = _tokenTaxRate;
90 	}
91 	function extractWei(uint256 _wei) bankOnly { //withdraw money from the contract
92 		if (!msg.sender.send(_wei)) throw;
93 	}
94 	function transferOwnership(address _bank) bankOnly { //change owner
95 		bank = _bank;
96 	}
97 }