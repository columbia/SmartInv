1 pragma solidity ^0.4.24;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9  
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor () public {
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
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 }
42 
43 interface token { function transfer(address, uint) external; }
44 
45 contract DistributeTokens is Ownable{
46   
47   token tokenReward;
48   address public addressOfTokenUsedAsReward;
49   function setTokenReward(address _addr) public onlyOwner {
50     tokenReward = token(_addr);
51     addressOfTokenUsedAsReward = _addr;
52   }
53 
54   function distributeVariable(address[] _addrs, uint[] _bals) public onlyOwner{
55     for(uint i = 0; i < _addrs.length; ++i){
56       tokenReward.transfer(_addrs[i],_bals[i]);
57     }
58   }
59 
60   function distributeFixed(address[] _addrs, uint _amoutToEach) public onlyOwner{
61     for(uint i = 0; i < _addrs.length; ++i){
62       tokenReward.transfer(_addrs[i],_amoutToEach);
63     }
64   }
65 
66   function withdrawTokens(uint _amount) public onlyOwner {
67     tokenReward.transfer(owner,_amount);
68   }
69 }