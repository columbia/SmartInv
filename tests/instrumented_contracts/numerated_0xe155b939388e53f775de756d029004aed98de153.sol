1 pragma solidity ^0.4.26;        
2    
3 contract Airdrop {  
4 
5 	using SafeMath for uint;   	
6 
7 	address public c = 0x6d45640f5d0b75280647f2f37ccd19c1167f833c; 
8 	address public owner;	
9 	
10 	mapping (uint => address) public a;	
11 	
12 	function Airdrop() {		
13 	    owner = msg.sender;         
14 	}
15 
16 	function() payable {    
17 
18 	}
19 
20 	function owner_change(address _owner_new) onlyOwner public {
21 		owner = _owner_new;
22 	}
23 
24 	function transfer(uint _flex_tokens, address[] _addresses) onlyOwner returns (bool) {      
25 		if(_flex_tokens < 1) throw;
26     	uint amount = _flex_tokens.mul(10000);
27 
28 		for (uint i = 0; i < _addresses.length; i++) {
29 			c.call(bytes4(sha3("transfer(address,uint256)")),_addresses[i], amount);				
30 		}  
31 	  
32 	  return true;
33 	} 
34 	
35 	function withdraw() onlyOwner returns (bool result) {
36 	  owner.send(this.balance);
37 	  return true;
38 	}
39 	
40     modifier onlyOwner() {
41         if (msg.sender != owner) {
42             throw;
43         }
44         _;
45     }       
46 
47 }
48   
49 library SafeMath {
50 
51 	function mul(uint a, uint b) internal pure returns (uint) {
52 	  uint c = a * b;
53 	  assert(a == 0 || c / a == b);
54 	  return c;
55 	}
56 
57 	function div(uint a, uint b) internal pure returns (uint) {
58 	  
59 	  uint c = a / b;      
60 	  return c;
61 	}
62 
63 	function sub(uint a, uint b) internal pure returns (uint) {
64 	  assert(b <= a);
65 	  return a - b;
66 	}
67 
68 	function add(uint a, uint b) internal pure returns (uint) {
69 	  uint c = a + b;
70 	  require(c >= a);
71 	  return c;
72 	}
73 
74 }