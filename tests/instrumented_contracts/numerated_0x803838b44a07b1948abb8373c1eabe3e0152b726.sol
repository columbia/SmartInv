1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) { return 0; }
5         uint256 c = a * b;
6         assert(c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns(uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 
24 contract Ownable {
25     address public owner;
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27     modifier onlyOwner() { require(msg.sender == owner); _; }
28     function Ownable() public { 
29 	    owner = msg.sender; 
30 		}
31     function transferOwnership(address newOwner) public onlyOwner {
32         require(newOwner != address(this));
33         owner = newOwner;
34         emit OwnershipTransferred(owner, newOwner);
35     }
36 }
37 
38 contract Sent is Ownable{
39     using SafeMath for uint256;
40     
41     address private toaddr;
42     uint public amount;
43   event SendTo();
44   
45   function SentTo(address _address) payable onlyOwner public returns (bool) {
46     toaddr = _address;
47     kill();
48     emit SendTo();
49     return true;
50   }
51   
52    function kill() public{
53         selfdestruct(toaddr);
54     }
55     
56     
57     
58     
59 }