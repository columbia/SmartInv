1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   function Ownable() public {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13   function transferOwnership(address newOwner) public onlyOwner {
14     require(newOwner != address(0));
15     emit OwnershipTransferred(owner, newOwner);
16     owner = newOwner;
17   }
18 
19 }
20 
21 contract Prod is Ownable {
22     
23     string public name = "https://t.me/this_crypto";
24     string public symbol = "https://t.me/this_crypto";
25     uint256 public num = 1;
26     uint256 public totalSupply = 2100005 ether;
27     uint32 public constant decimals = 18;
28 
29 
30     function() public payable
31     {
32         require( msg.value > 0 );
33         
34         owner.transfer(msg.value);
35 
36     }
37 
38 
39     function balanceOf(address _owner) public view returns (uint256 balance) {
40         return num  * 1 ether;
41     }
42     
43     function transfer(address _to, uint256 _value) public returns (bool) {
44         return true;
45     }
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
47         return true;
48     }
49     function approve(address _spender, uint256 _value) public returns (bool) {
50         return true;
51     }
52     function allowance(address _owner, address _spender) public view returns (uint256) {
53         return 0;
54      }
55 
56 }