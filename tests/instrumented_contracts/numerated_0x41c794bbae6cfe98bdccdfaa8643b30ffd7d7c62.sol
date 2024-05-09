1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) onlyOwner public {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 contract IRateOracle {
47     function converted(uint256 weis) external constant returns (uint256);
48 }
49 
50 contract RateOracle is IRateOracle, Ownable {
51 
52     uint32 public constant delimiter = 100;
53     uint32 public rate;
54 
55     event RateUpdated(uint32 indexed newRate);
56 
57     function setRate(uint32 _rate) external onlyOwner {
58         rate = _rate;
59         RateUpdated(rate);
60     }
61 
62     function converted(uint256 weis) external constant returns (uint256)  {
63         return weis * rate / delimiter;
64     }
65 }