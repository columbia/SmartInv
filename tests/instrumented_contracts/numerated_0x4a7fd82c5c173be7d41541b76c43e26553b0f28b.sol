1 pragma solidity ^0.4.8;
2 
3 contract testingToken {
4 	mapping (address => uint256) public balanceOf;
5 	mapping (address => uint256) public weiWantedOf;
6 	mapping (address => uint256) public tokensOfferedOf;
7 	mapping (address => bool) public tradeActive;
8 	address public owner;
9 	function testingToken() {
10 		owner = msg.sender;
11 		balanceOf[msg.sender] = 100000;
12 	}
13 	function send(address _to, uint256 _value) { //give tokens to someone
14 		if (balanceOf[msg.sender]<_value) throw;
15 		if (balanceOf[_to]+_value<balanceOf[_to]) throw;
16 		if (_value<0) throw;
17 		balanceOf[msg.sender] -= _value;
18 		balanceOf[_to] += (_value/100)*100;
19 	}
20 	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
21 	    weiWantedOf[msg.sender] = _weiWanted;
22 	    tokensOfferedOf[msg.sender] = _tokensOffered;
23 	    tradeActive[msg.sender] = true;
24 	}
25 	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
26 	    if (!tradeActive[_from]) throw;
27 	    if (weiWantedOf[_from]!=msg.value) throw;
28 	    if (balanceOf[_from]<tokensOfferedOf[_from]) throw;
29 	    if (!_from.send((msg.value/100)*100)) throw;
30 	    balanceOf[_from] -= tokensOfferedOf[_from];
31 	    balanceOf[msg.sender] += (tokensOfferedOf[_from]/100)*100;
32 		tradeActive[_from] = false;
33 	}
34 }