1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   constructor() public { owner = msg.sender;  }
7  
8   modifier onlyOwner() {     
9       address sender =  msg.sender;
10       address _owner = owner;
11       require(msg.sender == _owner);    
12       _;  
13   }
14   
15   function transferOwnership(address newOwner) onlyOwner public { 
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract SelfDestroy is Ownable {
48     using SafeMath for uint256;
49     uint256 public weiAmount = 0;
50     constructor() public {}
51    
52    // fallback function to receive ether
53     function () public payable {
54         weiAmount = weiAmount + msg.value;
55     }
56    
57    function destroy(address _address) public onlyOwner {
58        selfdestruct(_address);
59    }
60 
61 }