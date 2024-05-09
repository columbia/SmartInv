1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 interface itoken {
46     function transferMultiAddressFrom(address _from, address[] _toMulti, uint256[] _values) public returns (bool);
47 }
48 
49 contract AirsendGifts is Ownable {
50     // uint256 private m_rate = 1e18;
51 
52     // function initialize(address _tokenAddr, address _tokenOwner, uint256 _amount) onlyOwner public {
53     //     require(_tokenAddr != address(0));
54     //     require(_tokenOwner != address(0));
55     //     require(_amount > 0);
56     //     m_token = DRCTestToken(_tokenAddr);
57     //     m_token.approve(this, _amount.mul(m_rate));
58     //     m_tokenOwner = _tokenOwner;
59     // }
60     
61     function multiSend(address _tokenAddr, address _tokenOwner, address[] _destAddrs, uint256[] _values) onlyOwner public returns (bool) {
62         assert(_destAddrs.length == _values.length);
63 
64         return itoken(_tokenAddr).transferMultiAddressFrom(_tokenOwner, _destAddrs, _values);
65     }
66 }