1 pragma solidity ^0.4.18;
2 
3 contract EthWallet {
4 
5     address public owner;
6     uint256 public icoEndTimestamp;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         require(newOwner != address(0));      
17         OwnershipTransferred(owner, newOwner);
18         owner = newOwner;
19     }
20 
21     function EthWallet(address _owner, uint256 _icoEnd) public {
22         require(_owner != address(0));
23         require(_icoEnd > now);
24         owner = _owner;
25         icoEndTimestamp = _icoEnd;
26     }
27 
28     function () payable external {
29         require(now < icoEndTimestamp);
30         require(msg.value >= (1 ether) / 10);
31         Transfer(msg.sender, address(this), msg.value);
32         owner.transfer(msg.value);
33     }
34 
35     function cleanup() onlyOwner public {
36         require(now > icoEndTimestamp);
37         selfdestruct(owner);
38     }
39 
40     function cleanupTo(address _to) onlyOwner public {
41         require(now > icoEndTimestamp);
42         selfdestruct(_to);
43     }
44 
45 }