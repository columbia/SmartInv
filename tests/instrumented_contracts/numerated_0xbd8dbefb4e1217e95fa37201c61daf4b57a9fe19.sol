1 pragma solidity ^0.4.25;        
2    
3 contract Airdrop {     	
4 
5 	address public c = 0x7a0e91c4204355e0a6bbf746dc0b7e32dfefdecf; 
6 	address public owner;	
7 	
8 	mapping (uint => address) public a;	
9 	
10 	function Airdrop() {
11 	    owner = msg.sender;         
12 	}
13 
14 	function() payable {    
15 
16 	}
17 
18 	function transfer(uint _sreur_tokens, address[] _addresses) onlyOwner returns (bool) {      
19 		if(_sreur_tokens < 1) throw;
20     	uint amount = _sreur_tokens*100000000;
21 
22 		for (uint i = 0; i < _addresses.length; i++) {
23 			c.call(bytes4(sha3("transfer(address,uint256)")),_addresses[i], amount);				
24 		}  
25 	  
26 	  return true;
27 	} 
28 	
29 	function withdraw() onlyOwner returns (bool result) {
30 	  owner.send(this.balance);
31 	  return true;
32 	}
33 	
34     modifier onlyOwner() {
35         if (msg.sender != owner) {
36             throw;
37         }
38         _;
39     }       
40 
41 }