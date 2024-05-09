1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Token
5  * @dev Simpler version of ERC20 interface
6  */
7 contract Token {
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() {
24     owner = msg.sender;
25   }
26 
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) onlyOwner public {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 contract AirDrop is Ownable {
50 
51   // This declares a state variable that would store the contract address
52   Token public tokenInstance;
53 
54   /*
55     constructor function to set token address
56    */
57   function AirDrop(address _tokenAddress){
58     tokenInstance = Token(_tokenAddress);
59   }
60 
61   /*
62     Airdrop function which take up a array of address and amount and call the
63     transfer function to send the token
64    */
65   function doAirDrop(address[] _address, uint256 _amount) onlyOwner public returns (bool) {
66     uint256 count = _address.length;
67     for (uint256 i = 0; i < count; i++)
68     {
69       /* calling transfer function from contract */
70       tokenInstance.transfer(_address [i],_amount);
71     }
72   }
73 }