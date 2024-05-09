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
16 	function send(address _to, uint256 _value) { //give tokens to someone
17 		if (balanceOf[msg.sender]<_value) throw;
18 		if (balanceOf[_to]+_value<balanceOf[_to]) throw;
19 		if (_value<0) throw;
20 		balanceOf[msg.sender] -= _value;
21 		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
22 	}
23 	
24 	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
25 	    weiWantedOf[msg.sender] = _weiWanted;
26 	    tokensOfferedOf[msg.sender] = _tokensOffered;
27 	    tradeActive[msg.sender] = true;
28 	}
29 	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
30 	    if (!tradeActive[_from]) throw;
31 	    if (weiWantedOf[_from]!=msg.value) throw;
32 	    if (balanceOf[_from]<tokensOfferedOf[_from]) throw;
33 	    if (!_from.send((msg.value*(100-ethTaxRate))/100)) throw;
34 	    balanceOf[_from] -= tokensOfferedOf[_from];
35 	    balanceOf[msg.sender] += (tokensOfferedOf[_from]*(100-tokenTaxRate))/100;
36 		balanceOf[bank] += (tokensOfferedOf[_from]*tokenTaxRate)/100;
37 		tradeActive[_from] = false;
38 	}
39 	
40 	modifier bankOnly {
41 		if (msg.sender != bank) throw;
42 		_;
43 	}
44 	
45 	function setTaxes(uint256 _ethTaxRate, uint256 _tokenTaxRate) bankOnly { //the bank can change the tax rates
46 		ethTaxRate = _ethTaxRate;
47 		tokenTaxRate = _tokenTaxRate;
48 	}
49 	function extractWei(uint256 _wei) bankOnly { //withdraw money from the contract
50 		if (!msg.sender.send(_wei)) throw;
51 	}
52 	function transferOwnership(address _bank) bankOnly { //change owner
53 		bank = _bank;
54 	}
55 }