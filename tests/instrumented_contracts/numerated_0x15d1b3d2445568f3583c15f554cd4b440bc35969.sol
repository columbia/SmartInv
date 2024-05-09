1 pragma solidity ^0.4.24;
2 
3 interface Token {
4   function transfer(address _to, uint256 _value) external returns (bool);
5 }
6 
7 contract onlyOwner {
8   address public owner;
9   /** 
10   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11   * account.
12   */
13   constructor() public {
14     owner = msg.sender;
15 
16   }
17   modifier isOwner {
18     require(msg.sender == owner);
19     _;
20   }
21 }
22 
23 contract Campaigns is onlyOwner{
24 
25   Token token;
26   event TransferredToken(address indexed to, uint256 value);
27 
28 
29   constructor(address _contract) public{
30       address _tokenAddr = _contract; //here pass address of your token
31       token = Token(_tokenAddr);
32   }
33 
34 
35     function sendResidualAmount(uint256 value) isOwner public returns(bool){
36         token.transfer(owner, value*10**18);
37         emit TransferredToken(msg.sender, value);
38         return true;
39     }    
40     
41     function sendAmount(address[] _user, uint256 value) isOwner public returns(bool){
42         for(uint i=0; i<_user.length; i++)
43         token.transfer(_user[i], value*10**18);
44         return true;
45     }
46 	
47 	function sendIndividualAmount(address[] _user, uint256[] value) isOwner public returns(bool){
48         for(uint i=0; i<_user.length; i++)
49         token.transfer(_user[i], value[i]*10**18);
50         return true;
51     }
52   
53 }