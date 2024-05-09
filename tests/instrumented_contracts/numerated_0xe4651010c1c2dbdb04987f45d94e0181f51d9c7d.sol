1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11   /** 
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner. 
21   */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 }
28 
29 
30 contract Token{
31   function transfer(address to, uint value) external returns (bool);
32 }
33 
34 contract FanfareAirdrop3 is Ownable {
35 
36     function multisend (address _tokenAddr, address[] _to, uint256[] _value) external
37     
38     returns (bool _success) {
39         assert(_to.length == _value.length);
40         assert(_to.length <= 150);
41         // loop through to addresses and send value
42         for (uint8 i = 0; i < _to.length; i++) {
43                 uint256 actualValue = _value[i] * 10**18;
44                 require((Token(_tokenAddr).transfer(_to[i], actualValue)) == true);
45             }
46             return true;
47         }
48 }