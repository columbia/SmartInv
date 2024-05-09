1 pragma solidity ^0.4.19;
2 
3 contract ProductItem {
4 
5     address[] public _owners;
6     address public _currentOwner;
7     address public _nextOwner;
8     string public _productDigest;
9 
10     function ProductItem(string productDigest) public {
11         _currentOwner = msg.sender;
12         _productDigest = productDigest;
13         _owners.push(msg.sender);
14     }
15 
16     function setNextOwner(address nextOwner) public returns(bool set) {
17         if (_currentOwner != msg.sender) {
18             return false;
19         }
20 
21         _nextOwner = nextOwner;
22 
23         return true;
24     }
25 
26     function confirmOwnership() public returns(bool confirmed) {
27         if (_nextOwner != msg.sender) {
28             return false;
29         }
30 
31         _owners.push(_nextOwner);
32         _currentOwner = _nextOwner;
33         _nextOwner = address(0);
34 
35         return true;
36     }
37 }