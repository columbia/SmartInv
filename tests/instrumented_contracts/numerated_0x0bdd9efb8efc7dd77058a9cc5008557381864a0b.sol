1 /**
2  * Social Remit Contract Airdrop
3  * Developer: Nechesov Andrey 
4  * Skype: Nechesov
5  * Telegram: @nechesoff
6  * Facebook: http://fb.com/nechesov
7 */
8 
9 pragma solidity ^0.5.10;        
10    
11 contract Airdrop {     	
12 
13 	address public c = 0x7a0e91c4204355e0A6bBf746dc0B7E32dFEFDecf; 
14 	address payable public owner;	
15 	
16 	mapping (uint => address) public a;	
17 	
18 
19 	constructor() public{
20         owner = msg.sender;                
21     }
22 
23 	function() payable external{    
24 
25 	}
26 
27 	function transfer(uint _sreur_tokens, address[] memory _addresses) onlyOwner public returns (bool) {      
28 		
29 		require (_sreur_tokens > 0);		
30     	uint amount = _sreur_tokens*100000000;
31 
32 		for (uint i = 0; i < _addresses.length; i++) {
33 			//c.call(bytes4(sha3("transfer(address,uint256)")),_addresses[i], amount);				
34 			(bool success,) = address(c).call(abi.encodeWithSignature("transfer(address,uint256)", _addresses[i], amount));                  
35           	require(success);
36 		}  
37 	  
38 	  return true;
39 	} 
40 	
41 	function withdraw() onlyOwner public returns (bool result) {
42 	  owner.transfer(address(this).balance);
43 	  return true;
44 	}
45 	
46     modifier onlyOwner() {
47         require (msg.sender == owner);
48         _;
49     }       
50 
51 }