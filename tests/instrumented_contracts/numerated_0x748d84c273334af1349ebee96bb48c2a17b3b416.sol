1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract owned {
26         address public owner;
27 
28         function owned() public{
29             owner = msg.sender;
30         }
31 
32         modifier onlyOwner {
33             require(msg.sender == owner);
34             _;
35         }
36 
37         function transferOwnership(address newOwner) public onlyOwner {
38             owner = newOwner;
39         }
40     }
41 
42 contract Verification is owned {
43 	using SafeMath for uint256;
44     mapping(address => uint256) veruser;
45 	
46 	function RA(address _to) public view returns(bool){
47 		if(veruser[_to]>0){
48 			return true;
49 			}else{
50 				return false;
51 				}
52 	}
53 	
54 	function Verification() public {
55 	    if(RA(msg.sender) == false){
56 			veruser[msg.sender] = veruser[msg.sender].add(1);
57 			}
58 	}
59 	
60 	/*Удаление верификации*/
61 	function DelVer(address _address) public onlyOwner{
62 		if(RA(_address) == true){
63 			veruser[_address] = veruser[_address].sub(0);
64 		}
65 		
66 		
67 	}
68 	
69 }