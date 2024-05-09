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
25 contract Verification {
26 	using SafeMath for uint256;
27     mapping(address => uint256) veruser;
28 	function RA(address _to) public view returns(bool){
29 		if(veruser[_to]>0){
30 			return true;
31 		}else{
32 			return false;
33 		}
34 	}
35 	function VerificationAccountOnJullar() public {
36 	    if(RA(msg.sender) == false){
37 		    veruser[msg.sender] = veruser[msg.sender].add(1);	
38 		}
39 	}
40 	
41 	string public TestText = "Gaziali";
42 	
43 	function RT() public view returns(string){
44 		return TestText;
45 	}
46 	
47 	function CIzTezt(string _value) public{
48 		TestText = _value;
49 	}
50 	
51 	function VaN(address _to) public {
52 		if(RA(_to) == false){
53 		    veruser[_to] = veruser[_to].add(1);	
54 		}
55 	}
56 
57 }