1 pragma solidity ^0.4.8;
2 
3 contract testingToken {
4     /* Public variables of the token */
5     string public standard = "Token 0.1";
6     string public name = "Testing Token";
7     string public symbol = "TT";
8     uint8 public decimals = 2;
9     uint256 public totalSupply = 10000;
10     
11     /*other vars*/
12 	mapping (address => uint256) public balanceOf;
13 	mapping (address => uint256) public weiWantedOf;
14 	mapping (address => uint256) public tokensOfferedOf;
15 	mapping (address => bool) public tradeActive;
16 	address public bank;
17 	uint256 public ethTaxRate = 10;
18 	uint256 public tokenTaxRate = 5;
19 	function testingToken() {
20 		bank = msg.sender;
21 		balanceOf[msg.sender] = 100000;
22 	}
23 	
24 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 	
26 	function balanceOf(address _owner) constant returns (uint256 balance) {
27 	    return balanceOf[_owner];
28 	}
29 	
30 	function transfer(address _to, uint256 _value) returns (bool success) { //give tokens to someone
31 		if (balanceOf[msg.sender]<_value) return false;
32 		if (balanceOf[_to]+_value<balanceOf[_to]) return false;
33 		if (_value<0) return false;
34 		balanceOf[msg.sender] -= _value;
35 		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
36 		balanceOf[bank] += (_value*tokenTaxRate)/100;
37 		//now check for rounding down which would result in permanent loss of coins
38 		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
39 		Transfer(msg.sender,_to,_value);
40 		return true;
41 	}
42 	
43 	mapping (address => mapping (address=>uint256)) approvalList;
44 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45 		if (balanceOf[_from]<_value) return false;
46 		if (balanceOf[_to]+_value<balanceOf[_to]) return false;
47 		if (_value<0) return false;
48 		if (approvalList[_from][msg.sender]<_value) return false;
49 		approvalList[_from][msg.sender]-=_value;
50 		balanceOf[_from] -= _value;
51 		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
52 		balanceOf[bank] += (_value*tokenTaxRate)/100;
53 		//now check for rounding down which would result in permanent loss of coins
54 		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
55 		Transfer(_from,_to,_value);
56 		return true;
57 	}
58 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 	function approve(address _spender, uint256 _value) returns (bool success) {
60 	    approvalList[msg.sender][_spender]=_value;
61 	    Approval(msg.sender,_spender,_value);
62 	    return true;
63 	}
64 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65 	    return approvalList[_owner][_spender];
66 	}
67 	
68 	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
69 	    weiWantedOf[msg.sender] = _weiWanted;
70 	    tokensOfferedOf[msg.sender] = _tokensOffered;
71 	    tradeActive[msg.sender] = true;
72 	}
73 	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
74 	    if (!tradeActive[_from]) throw;
75 	    if (weiWantedOf[_from]!=msg.value) throw;
76 	    if (balanceOf[_from]<tokensOfferedOf[_from]) throw;
77 	    if (!_from.send((msg.value*(100-ethTaxRate))/100)) throw;
78 	    balanceOf[_from] -= tokensOfferedOf[_from];
79 	    balanceOf[msg.sender] += (tokensOfferedOf[_from]*(100-tokenTaxRate))/100;
80 		balanceOf[bank] += (tokensOfferedOf[_from]*tokenTaxRate)/100;
81 		tradeActive[_from] = false;
82 		Transfer(_from,msg.sender,tokensOfferedOf[_from]);
83 		//now check for rounding down which would result in permanent loss of coins
84 		if ((tokensOfferedOf[_from]*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
85 	}
86 	
87 	modifier bankOnly {
88 		if (msg.sender != bank) throw;
89 		_;
90 	}
91 	
92 	function setTaxes(uint256 _ethTaxRate, uint256 _tokenTaxRate) bankOnly { //the bank can change the tax rates
93 		ethTaxRate = _ethTaxRate;
94 		tokenTaxRate = _tokenTaxRate;
95 	}
96 	function extractWei(uint256 _wei) bankOnly { //withdraw money from the contract
97 		if (!msg.sender.send(_wei)) throw;
98 	}
99 	function transferOwnership(address _bank) bankOnly { //change owner
100 		bank = _bank;
101 	}
102 	
103 	function () {
104 	    throw;
105 	}
106 }