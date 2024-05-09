1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));      
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 contract trustedOracle is Ownable {
45 	mapping (uint => uint) pricePoints;
46 	uint public lastTimestamp;
47 
48 	function submitPrice(uint _timestamp, uint _weiForCent)
49 		onlyOwner
50 	{
51 		pricePoints[_timestamp] = _weiForCent;
52 		if (_timestamp > lastTimestamp) lastTimestamp = _timestamp;
53 	}
54 
55 
56 	function getWeiForCent(uint _timestamp)
57 		public
58 		constant
59 		returns (uint)
60 	{
61 		uint stamp = _timestamp;
62 		if (stamp == 0) stamp = lastTimestamp;
63 		return pricePoints[stamp];
64 	}
65 }