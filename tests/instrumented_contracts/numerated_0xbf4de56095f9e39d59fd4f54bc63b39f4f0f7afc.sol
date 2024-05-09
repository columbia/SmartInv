1 // ----------------------------------------------------------------------------
2 // 'buckycoin' AIRDROP token contract
3 //
4 // Deployed to : 0xbf4de56095f9e39d59fd4f54bc63b39f4f0f7afc
5 // Symbol      : BUC
6 // Name        : buckycoin Token
7 // Total supply: 940000000
8 // Decimals    : 18
9 //
10 // POWERED BY BUCKY HOUSE.
11 //
12 // (c) by Team @ BUCKYHOUSE  2018.
13 // ----------------------------------------------------------------------------
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23  
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner public {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 }
56 
57 contract token { function transfer(address receiver, uint amount){  } }
58 
59 contract DistributeTokens is Ownable{
60   
61   token tokenReward;
62   address public addressOfTokenUsedAsReward;
63   function setTokenReward(address _addr) onlyOwner {
64     tokenReward = token(_addr);
65     addressOfTokenUsedAsReward = _addr;
66   }
67 
68   function distributeVariable(address[] _addrs, uint[] _bals) onlyOwner{
69     for(uint i = 0; i < _addrs.length; ++i){
70       tokenReward.transfer(_addrs[i],_bals[i]);
71     }
72   }
73 
74   function distributeFixed(address[] _addrs, uint _amoutToEach) onlyOwner{
75     for(uint i = 0; i < _addrs.length; ++i){
76       tokenReward.transfer(_addrs[i],_amoutToEach);
77     }
78   }
79 
80   function withdrawTokens(uint _amount) onlyOwner {
81     tokenReward.transfer(owner,_amount);
82   }
83 }