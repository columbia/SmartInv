1 pragma solidity ^0.4.4;
2 /* This currency XG4K/ETH can only be issued by the coiner Xgains4keeps owner of 
3 the Equity4keeps programme and can be transferred to anyone or entity.
4 */
5 contract XG4K {	
6 	mapping (address => uint) public balances;
7 	function XG4K() {
8 		balances[tx.origin] = 100000;
9 	}
10 	function sendToken(address receiver, uint amount) returns(bool successful){
11 		if (balances[msg.sender] < amount) return false;
12  		balances[msg.sender] -= amount;
13  		balances[receiver] += amount;
14  		return false;
15  	}
16 } 
17 contract coinSpawn{
18  	mapping(uint => XG4K) deployedContracts;
19 	uint numContracts;
20 	function createCoin() returns(address a){
21 		deployedContracts[numContracts] = new XG4K();
22 		numContracts++;
23 		return deployedContracts[numContracts];
24 	}
25 }