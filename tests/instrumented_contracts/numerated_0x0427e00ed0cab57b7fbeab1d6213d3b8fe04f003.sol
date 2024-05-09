1 contract Ownable {
2   address public owner;
3   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
4 
5   function Ownable() public {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13 
14   function transferOwnership(address newOwner) public onlyOwner {
15     require(newOwner != address(0));
16     OwnershipTransferred(owner, newOwner);
17     owner = newOwner;
18   }
19 }
20 
21 contract SAMPreSaleToken is Ownable {
22     event Payment(address indexed investor, uint256 value);
23 
24     function () external payable {
25         owner.transfer(msg.value);
26         Payment(msg.sender, msg.value);
27     }
28 }