1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8  
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 contract token { function transfer(address receiver, uint amount){  } }
43 
44 contract DistributeTokens is Ownable{
45   
46   token tokenReward;
47   address public addressOfTokenUsedAsReward;
48   function setTokenReward(address _addr) onlyOwner {
49     tokenReward = token(_addr);
50     addressOfTokenUsedAsReward = _addr;
51   }
52 
53   function distributeVariable(address[] _addrs, uint[] _bals) onlyOwner{
54     for(uint i = 0; i < _addrs.length; ++i){
55       tokenReward.transfer(_addrs[i],_bals[i]);
56     }
57   }
58 
59   function distributeFixed(address[] _addrs, uint _amoutToEach) onlyOwner{
60     for(uint i = 0; i < _addrs.length; ++i){
61       tokenReward.transfer(_addrs[i],_amoutToEach);
62     }
63   }
64 
65   function withdrawTokens(uint _amount) onlyOwner {
66     tokenReward.transfer(owner,_amount);
67   }
68 }