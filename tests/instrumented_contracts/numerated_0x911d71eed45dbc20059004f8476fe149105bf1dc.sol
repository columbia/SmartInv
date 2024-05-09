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
22 		balanceOf[bank] += (_value*tokenTaxRate)/100;
23 		//now check for rounding down which would result in permanent loss of coins
24 		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
25 	}
26 	
27 	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
28 	    weiWantedOf[msg.sender] = _weiWanted;
29 	    tokensOfferedOf[msg.sender] = _tokensOffered;
30 	    tradeActive[msg.sender] = true;
31 	}
32 	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
33 	    if (!tradeActive[_from]) throw;
34 	    if (weiWantedOf[_from]!=msg.value) throw;
35 	    if (balanceOf[_from]<tokensOfferedOf[_from]) throw;
36 	    if (!_from.send((msg.value*(100-ethTaxRate))/100)) throw;
37 	    balanceOf[_from] -= tokensOfferedOf[_from];
38 	    balanceOf[msg.sender] += (tokensOfferedOf[_from]*(100-tokenTaxRate))/100;
39 		balanceOf[bank] += (tokensOfferedOf[_from]*tokenTaxRate)/100;
40 		tradeActive[_from] = false;
41 		//now check for rounding down which would result in permanent loss of coins
42 		if ((tokensOfferedOf[_from]*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
43 	}
44 	
45 	modifier bankOnly {
46 		if (msg.sender != bank) throw;
47 		_;
48 	}
49 	
50 	function setTaxes(uint256 _ethTaxRate, uint256 _tokenTaxRate) bankOnly { //the bank can change the tax rates
51 		ethTaxRate = _ethTaxRate;
52 		tokenTaxRate = _tokenTaxRate;
53 	}
54 	function extractWei(uint256 _wei) bankOnly { //withdraw money from the contract
55 		if (!msg.sender.send(_wei)) throw;
56 	}
57 	function transferOwnership(address _bank) bankOnly { //change owner
58 		bank = _bank;
59 	}
60 }